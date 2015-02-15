#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>
#include <kern/time.h>

extern uintptr_t gdtdesc_64;
static struct Taskstate ts;
extern struct Segdesc gdt[];
extern long gdt_pd;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {0,0};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
trap_init(void)
{
	extern struct Segdesc gdt[];
	uint32_t istrap = 0;
	uint32_t dpl = 0;
	uint32_t upl = 3;
	
	extern void CSE_DIVIDE();     /* divide error*/ 
	extern void CSE_DEBUG();      /* debug exception*/
	extern void CSE_NMI();     /* non-maskable interrupt*/
	extern void CSE_BRKPT();     /* breakpoint*/
	extern void CSE_OFLOW();     /* overflow*/
	extern void CSE_BOUND();     /* bounds check*/
	extern void CSE_ILLOP();     /* illegal opcode*/
	extern void CSE_DEVICE();     /* device not available*/
	extern void CSE_DBLFLT();      /* double fault*/
	/* #define T_COPROC  9    // reserved (not generated by recent processors)*/
	extern void CSE_TSS();     /* invalid task switch segment*/
	extern void CSE_SEGNP();      /* segment not present*/
	extern void CSE_STACK();      /* stack exception*/
	extern void CSE_GPFLT();      /* general protection fault*/
	extern void CSE_PGFLT();      /* page fault*/
	/* #define T_RES    15    // reserved*/
	extern void CSE_FPERR();      /* floating point error*/
	extern void CSE_ALIGN();      /* aligment check*/
	extern void CSE_MCHK();      /* machine check*/
	extern void CSE_SIMDERR();      /* SIMD floating point error*/
	
	extern void CSE_SYSCALL();		/*SYSTEM CALL interrupt*/
	
	extern void CSE_IRQ0();
	extern void CSE_IRQ1();
	extern void CSE_IRQ2();
	extern void CSE_IRQ3();
	extern void CSE_IRQ4();
	extern void CSE_IRQ5();
	extern void CSE_IRQ6();
	extern void CSE_IRQ7();
	extern void CSE_IRQ8();
	extern void CSE_IRQ9();
	extern void CSE_IRQ10();
	extern void CSE_IRQ11();
	extern void CSE_IRQ12();
	extern void CSE_IRQ13();
	extern void CSE_IRQ14();
	extern void CSE_IRQ15();
		
	SETGATE(idt[0], istrap, GD_KT, CSE_DIVIDE, dpl);
	SETGATE(idt[1], istrap, GD_KT, CSE_DEBUG, dpl);
	SETGATE(idt[2], istrap, GD_KT, CSE_NMI, dpl);
	SETGATE(idt[3], istrap, GD_KT, CSE_BRKPT, upl);
	SETGATE(idt[4], istrap, GD_KT, CSE_OFLOW, dpl);
	SETGATE(idt[5], istrap, GD_KT, CSE_BOUND, dpl);
	SETGATE(idt[6], istrap, GD_KT, CSE_ILLOP, dpl);
	SETGATE(idt[7], istrap, GD_KT, CSE_DEVICE, dpl);
	SETGATE(idt[8], istrap, GD_KT, CSE_DBLFLT, dpl);
	SETGATE(idt[10], istrap, GD_KT, CSE_TSS, dpl);
	SETGATE(idt[11], istrap, GD_KT, CSE_SEGNP, dpl);
	SETGATE(idt[12], istrap, GD_KT, CSE_STACK, dpl);
	SETGATE(idt[13], istrap, GD_KT, CSE_GPFLT, dpl);
	SETGATE(idt[14], istrap, GD_KT, CSE_PGFLT, dpl);
	SETGATE(idt[16], istrap, GD_KT, CSE_FPERR, dpl);
	SETGATE(idt[17], istrap, GD_KT, CSE_ALIGN, dpl);
	SETGATE(idt[18], istrap, GD_KT, CSE_MCHK, dpl);
	SETGATE(idt[19], istrap, GD_KT, CSE_SIMDERR, dpl);
	
	SETGATE(idt[48], istrap, GD_KT, CSE_SYSCALL, upl);

	
	SETGATE(idt[32], istrap, GD_KT, CSE_IRQ0, dpl);
	SETGATE(idt[33], istrap, GD_KT, CSE_IRQ1, dpl);
	SETGATE(idt[34], istrap, GD_KT, CSE_IRQ2, dpl);
	SETGATE(idt[35], istrap, GD_KT, CSE_IRQ3, dpl);
	SETGATE(idt[36], istrap, GD_KT, CSE_IRQ4, dpl);
	SETGATE(idt[37], istrap, GD_KT, CSE_IRQ5, dpl);
	SETGATE(idt[38], istrap, GD_KT, CSE_IRQ6, dpl);
	SETGATE(idt[39], istrap, GD_KT, CSE_IRQ7, dpl);
	SETGATE(idt[40], istrap, GD_KT, CSE_IRQ8, dpl);
	SETGATE(idt[41], istrap, GD_KT, CSE_IRQ9, dpl);
	SETGATE(idt[42], istrap, GD_KT, CSE_IRQ10, dpl);
	SETGATE(idt[43], istrap, GD_KT, CSE_IRQ11, dpl);
	SETGATE(idt[44], istrap, GD_KT, CSE_IRQ12, dpl);
	SETGATE(idt[45], istrap, GD_KT, CSE_IRQ13, dpl);
	SETGATE(idt[46], istrap, GD_KT, CSE_IRQ14, dpl);
	SETGATE(idt[47], istrap, GD_KT, CSE_IRQ15, dpl);


	// LAB 3: Your code here.
	idt_pd.pd_lim = sizeof(idt)-1;
	idt_pd.pd_base = (uint64_t)idt;
	// Per-CPU setup
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + 2*i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int id = thiscpu->cpu_id;
	size_t kstacktop_ncpus = KSTACKTOP - id*(KSTKSIZE+KSTKGAP);
	thiscpu->cpu_ts.ts_esp0 = kstacktop_ncpus;
	SETTSS((struct SystemSegdesc64 *)(&gdt[(GD_TSS0>>3)+2*id]),STS_T64A, (uint64_t) (&thiscpu->cpu_ts),sizeof(struct Taskstate), 0);
	/*
	ts.ts_esp0 = KSTACKTOP;

	// Initialize the TSS slot of the gdt.
	SETTSS((struct SystemSegdesc64 *)((gdt_pd>>16)+40),STS_T64A, (uint64_t) (&ts),sizeof(struct Taskstate), 0);
	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)	*/
	ltr(GD_TSS0 + ((2*id << 3) & (~0x7)));
	//ltr(GD_TSS0+2*id);

	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  rip  0x%08x\n", tf->tf_rip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  rsp  0x%08x\n", tf->tf_rsp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  r15  0x%08x\n", regs->reg_r15);
	cprintf("  r14  0x%08x\n", regs->reg_r14);
	cprintf("  r13  0x%08x\n", regs->reg_r13);
	cprintf("  r12  0x%08x\n", regs->reg_r12);
	cprintf("  r11  0x%08x\n", regs->reg_r11);
	cprintf("  r10  0x%08x\n", regs->reg_r10);
	cprintf("  r9  0x%08x\n", regs->reg_r9);
	cprintf("  r8  0x%08x\n", regs->reg_r8);
	cprintf("  rdi  0x%08x\n", regs->reg_rdi);
	cprintf("  rsi  0x%08x\n", regs->reg_rsi);
	cprintf("  rbp  0x%08x\n", regs->reg_rbp);
	cprintf("  rbx  0x%08x\n", regs->reg_rbx);
	cprintf("  rdx  0x%08x\n", regs->reg_rdx);
	cprintf("  rcx  0x%08x\n", regs->reg_rcx);
	cprintf("  rax  0x%08x\n", regs->reg_rax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
		lapic_eoi();
		//print_trapframe(tf);
		sched_yield();
		return;
	}

	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
		kbd_intr();
		return;
	}
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
		serial_intr();
		return;
	}


	// Unexpected trap: The user process or the kernel has a bug.
	switch(tf->tf_trapno) {
	case T_PGFLT:
			page_fault_handler(tf);
			break;
	case T_BRKPT:
			monitor(tf);
			break;
	case T_SYSCALL:
			//print_trapframe(tf);
			tf->tf_regs.reg_rax = syscall(tf->tf_regs.reg_rax, 
										  tf->tf_regs.reg_rdx,
										  tf->tf_regs.reg_rcx,
										  tf->tf_regs.reg_rbx,
										  tf->tf_regs.reg_rdi,
										  tf->tf_regs.reg_rsi);
			break;
	default:
	print_trapframe(tf);
		if (tf->tf_cs == GD_KT) {
		panic("unhandled trap in kernel");
		}
	else {
		env_destroy(curenv);
		return;
	}
}
}

void
trap(struct Trapframe *tf)
{
	//struct Trapframe *tf = &tf_;
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
		asm volatile("hlt");

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
		assert(curenv);
		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
		
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint64_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if (!(tf->tf_cs & 0x3)) {
		print_trapframe(tf);
        panic("unhandled trap in kernel");
    }

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	if (curenv->env_pgfault_upcall) {
		struct UTrapframe *utexp;
		if (tf->tf_rsp <= UXSTACKTOP-1 && tf->tf_rsp >= UXSTACKTOP-PGSIZE) {
			utexp = (struct UTrapframe*) (tf->tf_rsp - sizeof(struct UTrapframe) - 8);
		}
		else {
			utexp = (struct UTrapframe*)(UXSTACKTOP - sizeof(struct UTrapframe));
		}
		//storing that 64 bit thingy.(this was tough!, I'm weak with bits ;) )
		//(time frame) to be stored...but how does it get pushed into the stack...you assign it to uxstacktop
		//thats brilliant. Thank you! thank you...wait a minute...see if it overflows!
		user_mem_assert(curenv, (void*)utexp, sizeof(struct UTrapframe), PTE_W|PTE_U);
		utexp->utf_fault_va = fault_va;
		utexp->utf_err = tf->tf_err;
		utexp->utf_regs = tf->tf_regs;
		utexp->utf_rip = tf->tf_rip;
		utexp->utf_eflags = tf->tf_eflags;
		utexp->utf_rsp = tf->tf_rsp;
		//How do i run the upcall...set the rip...thats nice...thank you exercise 10 :)
		tf->tf_rip = (uint64_t)curenv->env_pgfault_upcall;
		tf->tf_rsp = (uint64_t)utexp;
		env_run(curenv);
	}
	// LAB 4: Your code here.

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n", curenv->env_id, fault_va, tf->tf_rip);
	print_trapframe(tf);
	env_destroy(curenv);
}

