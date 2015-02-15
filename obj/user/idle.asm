
obj/user/idle.debug:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 37 00 00 00       	callq  800078 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800053:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80005a:	00 00 00 
  80005d:	48 ba 40 3b 80 00 00 	movabs $0x803b40,%rdx
  800064:	00 00 00 
  800067:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  80006a:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
	}
  800076:	eb f2                	jmp    80006a <umain+0x26>

0000000000800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %rbp
  800079:	48 89 e5             	mov    %rsp,%rbp
  80007c:	48 83 ec 10          	sub    $0x10,%rsp
  800080:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800083:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800087:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80008e:	00 00 00 
  800091:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800098:	48 b8 ac 02 80 00 00 	movabs $0x8002ac,%rax
  80009f:	00 00 00 
  8000a2:	ff d0                	callq  *%rax
  8000a4:	48 98                	cltq   
  8000a6:	48 89 c2             	mov    %rax,%rdx
  8000a9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000af:	48 89 d0             	mov    %rdx,%rax
  8000b2:	48 c1 e0 02          	shl    $0x2,%rax
  8000b6:	48 01 d0             	add    %rdx,%rax
  8000b9:	48 01 c0             	add    %rax,%rax
  8000bc:	48 01 d0             	add    %rdx,%rax
  8000bf:	48 c1 e0 05          	shl    $0x5,%rax
  8000c3:	48 89 c2             	mov    %rax,%rdx
  8000c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cd:	00 00 00 
  8000d0:	48 01 c2             	add    %rax,%rdx
  8000d3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000da:	00 00 00 
  8000dd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e4:	7e 14                	jle    8000fa <libmain+0x82>
		binaryname = argv[0];
  8000e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ea:	48 8b 10             	mov    (%rax),%rdx
  8000ed:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f4:	00 00 00 
  8000f7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800101:	48 89 d6             	mov    %rdx,%rsi
  800104:	89 c7                	mov    %eax,%edi
  800106:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80010d:	00 00 00 
  800110:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800112:	48 b8 20 01 80 00 00 	movabs $0x800120,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
}
  80011e:	c9                   	leaveq 
  80011f:	c3                   	retq   

0000000000800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	55                   	push   %rbp
  800121:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800124:	48 b8 b9 09 80 00 00 	movabs $0x8009b9,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800130:	bf 00 00 00 00       	mov    $0x0,%edi
  800135:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	5d                   	pop    %rbp
  800142:	c3                   	retq   
	...

0000000000800144 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	53                   	push   %rbx
  800149:	48 83 ec 58          	sub    $0x58,%rsp
  80014d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800150:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800153:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800157:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80015b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800163:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%rbp)
  800169:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80016d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800171:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800175:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800179:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80017d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800180:	4c 89 c3             	mov    %r8,%rbx
  800183:	cd 30                	int    $0x30
  800185:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800189:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80018d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800191:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800195:	74 3e                	je     8001d5 <syscall+0x91>
  800197:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80019c:	7e 37                	jle    8001d5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80019e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8001a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001a5:	49 89 d0             	mov    %rdx,%r8
  8001a8:	89 c1                	mov    %eax,%ecx
  8001aa:	48 ba 4f 3b 80 00 00 	movabs $0x803b4f,%rdx
  8001b1:	00 00 00 
  8001b4:	be 23 00 00 00       	mov    $0x23,%esi
  8001b9:	48 bf 6c 3b 80 00 00 	movabs $0x803b6c,%rdi
  8001c0:	00 00 00 
  8001c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c8:	49 b9 28 23 80 00 00 	movabs $0x802328,%r9
  8001cf:	00 00 00 
  8001d2:	41 ff d1             	callq  *%r9

	return ret;
  8001d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001d9:	48 83 c4 58          	add    $0x58,%rsp
  8001dd:	5b                   	pop    %rbx
  8001de:	5d                   	pop    %rbp
  8001df:	c3                   	retq   

00000000008001e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001e0:	55                   	push   %rbp
  8001e1:	48 89 e5             	mov    %rsp,%rbp
  8001e4:	48 83 ec 20          	sub    $0x20,%rsp
  8001e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ff:	00 
  800200:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800206:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020c:	48 89 d1             	mov    %rdx,%rcx
  80020f:	48 89 c2             	mov    %rax,%rdx
  800212:	be 00 00 00 00       	mov    $0x0,%esi
  800217:	bf 00 00 00 00       	mov    $0x0,%edi
  80021c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
}
  800228:	c9                   	leaveq 
  800229:	c3                   	retq   

000000000080022a <sys_cgetc>:

int
sys_cgetc(void)
{
  80022a:	55                   	push   %rbp
  80022b:	48 89 e5             	mov    %rsp,%rbp
  80022e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800232:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800239:	00 
  80023a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800240:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800246:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024b:	ba 00 00 00 00       	mov    $0x0,%edx
  800250:	be 00 00 00 00       	mov    $0x0,%esi
  800255:	bf 01 00 00 00       	mov    $0x1,%edi
  80025a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	c9                   	leaveq 
  800267:	c3                   	retq   

0000000000800268 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
  80026c:	48 83 ec 20          	sub    $0x20,%rsp
  800270:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800276:	48 98                	cltq   
  800278:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027f:	00 
  800280:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800286:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800291:	48 89 c2             	mov    %rax,%rdx
  800294:	be 01 00 00 00       	mov    $0x1,%esi
  800299:	bf 03 00 00 00       	mov    $0x3,%edi
  80029e:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8002a5:	00 00 00 
  8002a8:	ff d0                	callq  *%rax
}
  8002aa:	c9                   	leaveq 
  8002ab:	c3                   	retq   

00000000008002ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8002ac:	55                   	push   %rbp
  8002ad:	48 89 e5             	mov    %rsp,%rbp
  8002b0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002bb:	00 
  8002bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d2:	be 00 00 00 00       	mov    $0x0,%esi
  8002d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8002dc:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8002e3:	00 00 00 
  8002e6:	ff d0                	callq  *%rax
}
  8002e8:	c9                   	leaveq 
  8002e9:	c3                   	retq   

00000000008002ea <sys_yield>:

void
sys_yield(void)
{
  8002ea:	55                   	push   %rbp
  8002eb:	48 89 e5             	mov    %rsp,%rbp
  8002ee:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002f9:	00 
  8002fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800300:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	be 00 00 00 00       	mov    $0x0,%esi
  800315:	bf 0b 00 00 00       	mov    $0xb,%edi
  80031a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
}
  800326:	c9                   	leaveq 
  800327:	c3                   	retq   

0000000000800328 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800328:	55                   	push   %rbp
  800329:	48 89 e5             	mov    %rsp,%rbp
  80032c:	48 83 ec 20          	sub    $0x20,%rsp
  800330:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800333:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800337:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80033a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80033d:	48 63 c8             	movslq %eax,%rcx
  800340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800347:	48 98                	cltq   
  800349:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800350:	00 
  800351:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800357:	49 89 c8             	mov    %rcx,%r8
  80035a:	48 89 d1             	mov    %rdx,%rcx
  80035d:	48 89 c2             	mov    %rax,%rdx
  800360:	be 01 00 00 00       	mov    $0x1,%esi
  800365:	bf 04 00 00 00       	mov    $0x4,%edi
  80036a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800371:	00 00 00 
  800374:	ff d0                	callq  *%rax
}
  800376:	c9                   	leaveq 
  800377:	c3                   	retq   

0000000000800378 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	48 83 ec 30          	sub    $0x30,%rsp
  800380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800387:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80038a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80038e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800392:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800395:	48 63 c8             	movslq %eax,%rcx
  800398:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80039c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80039f:	48 63 f0             	movslq %eax,%rsi
  8003a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a9:	48 98                	cltq   
  8003ab:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003af:	49 89 f9             	mov    %rdi,%r9
  8003b2:	49 89 f0             	mov    %rsi,%r8
  8003b5:	48 89 d1             	mov    %rdx,%rcx
  8003b8:	48 89 c2             	mov    %rax,%rdx
  8003bb:	be 01 00 00 00       	mov    $0x1,%esi
  8003c0:	bf 05 00 00 00       	mov    $0x5,%edi
  8003c5:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8003cc:	00 00 00 
  8003cf:	ff d0                	callq  *%rax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 20          	sub    $0x20,%rsp
  8003db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e9:	48 98                	cltq   
  8003eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f2:	00 
  8003f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ff:	48 89 d1             	mov    %rdx,%rcx
  800402:	48 89 c2             	mov    %rax,%rdx
  800405:	be 01 00 00 00       	mov    $0x1,%esi
  80040a:	bf 06 00 00 00       	mov    $0x6,%edi
  80040f:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
}
  80041b:	c9                   	leaveq 
  80041c:	c3                   	retq   

000000000080041d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
  800421:	48 83 ec 20          	sub    $0x20,%rsp
  800425:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800428:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80042b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042e:	48 63 d0             	movslq %eax,%rdx
  800431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800434:	48 98                	cltq   
  800436:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80043d:	00 
  80043e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800444:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044a:	48 89 d1             	mov    %rdx,%rcx
  80044d:	48 89 c2             	mov    %rax,%rdx
  800450:	be 01 00 00 00       	mov    $0x1,%esi
  800455:	bf 08 00 00 00       	mov    $0x8,%edi
  80045a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800461:	00 00 00 
  800464:	ff d0                	callq  *%rax
}
  800466:	c9                   	leaveq 
  800467:	c3                   	retq   

0000000000800468 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	48 83 ec 20          	sub    $0x20,%rsp
  800470:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800473:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800477:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047e:	48 98                	cltq   
  800480:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800487:	00 
  800488:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80048e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800494:	48 89 d1             	mov    %rdx,%rcx
  800497:	48 89 c2             	mov    %rax,%rdx
  80049a:	be 01 00 00 00       	mov    $0x1,%esi
  80049f:	bf 09 00 00 00       	mov    $0x9,%edi
  8004a4:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
}
  8004b0:	c9                   	leaveq 
  8004b1:	c3                   	retq   

00000000008004b2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 20          	sub    $0x20,%rsp
  8004ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c8:	48 98                	cltq   
  8004ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004d1:	00 
  8004d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004de:	48 89 d1             	mov    %rdx,%rcx
  8004e1:	48 89 c2             	mov    %rax,%rdx
  8004e4:	be 01 00 00 00       	mov    $0x1,%esi
  8004e9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004ee:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
}
  8004fa:	c9                   	leaveq 
  8004fb:	c3                   	retq   

00000000008004fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
  800500:	48 83 ec 30          	sub    $0x30,%rsp
  800504:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800507:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80050b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80050f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800512:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800515:	48 63 f0             	movslq %eax,%rsi
  800518:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80051c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051f:	48 98                	cltq   
  800521:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800525:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80052c:	00 
  80052d:	49 89 f1             	mov    %rsi,%r9
  800530:	49 89 c8             	mov    %rcx,%r8
  800533:	48 89 d1             	mov    %rdx,%rcx
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	be 00 00 00 00       	mov    $0x0,%esi
  80053e:	bf 0c 00 00 00       	mov    $0xc,%edi
  800543:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80054a:	00 00 00 
  80054d:	ff d0                	callq  *%rax
}
  80054f:	c9                   	leaveq 
  800550:	c3                   	retq   

0000000000800551 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800551:	55                   	push   %rbp
  800552:	48 89 e5             	mov    %rsp,%rbp
  800555:	48 83 ec 20          	sub    $0x20,%rsp
  800559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80055d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800561:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800568:	00 
  800569:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80056f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800575:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057a:	48 89 c2             	mov    %rax,%rdx
  80057d:	be 01 00 00 00       	mov    $0x1,%esi
  800582:	bf 0d 00 00 00       	mov    $0xd,%edi
  800587:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80058e:	00 00 00 
  800591:	ff d0                	callq  *%rax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80059d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005a4:	00 
  8005a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	be 00 00 00 00       	mov    $0x0,%esi
  8005c0:	bf 0e 00 00 00       	mov    $0xe,%edi
  8005c5:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
}
  8005d1:	c9                   	leaveq 
  8005d2:	c3                   	retq   

00000000008005d3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8005d3:	55                   	push   %rbp
  8005d4:	48 89 e5             	mov    %rsp,%rbp
  8005d7:	48 83 ec 30          	sub    $0x30,%rsp
  8005db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005e2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8005e5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005e9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8005ed:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005f0:	48 63 c8             	movslq %eax,%rcx
  8005f3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8005f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fa:	48 63 f0             	movslq %eax,%rsi
  8005fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 98                	cltq   
  800606:	48 89 0c 24          	mov    %rcx,(%rsp)
  80060a:	49 89 f9             	mov    %rdi,%r9
  80060d:	49 89 f0             	mov    %rsi,%r8
  800610:	48 89 d1             	mov    %rdx,%rcx
  800613:	48 89 c2             	mov    %rax,%rdx
  800616:	be 00 00 00 00       	mov    $0x0,%esi
  80061b:	bf 0f 00 00 00       	mov    $0xf,%edi
  800620:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800627:	00 00 00 
  80062a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80062c:	c9                   	leaveq 
  80062d:	c3                   	retq   

000000000080062e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80062e:	55                   	push   %rbp
  80062f:	48 89 e5             	mov    %rsp,%rbp
  800632:	48 83 ec 20          	sub    $0x20,%rsp
  800636:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80063a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80063e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800646:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80064d:	00 
  80064e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800654:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80065a:	48 89 d1             	mov    %rdx,%rcx
  80065d:	48 89 c2             	mov    %rax,%rdx
  800660:	be 00 00 00 00       	mov    $0x0,%esi
  800665:	bf 10 00 00 00       	mov    $0x10,%edi
  80066a:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
}
  800676:	c9                   	leaveq 
  800677:	c3                   	retq   

0000000000800678 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800678:	55                   	push   %rbp
  800679:	48 89 e5             	mov    %rsp,%rbp
  80067c:	48 83 ec 08          	sub    $0x8,%rsp
  800680:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800684:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800688:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80068f:	ff ff ff 
  800692:	48 01 d0             	add    %rdx,%rax
  800695:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800699:	c9                   	leaveq 
  80069a:	c3                   	retq   

000000000080069b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80069b:	55                   	push   %rbp
  80069c:	48 89 e5             	mov    %rsp,%rbp
  80069f:	48 83 ec 08          	sub    $0x8,%rsp
  8006a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8006a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ab:	48 89 c7             	mov    %rax,%rdi
  8006ae:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  8006b5:	00 00 00 
  8006b8:	ff d0                	callq  *%rax
  8006ba:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006c0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006c4:	c9                   	leaveq 
  8006c5:	c3                   	retq   

00000000008006c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8006c6:	55                   	push   %rbp
  8006c7:	48 89 e5             	mov    %rsp,%rbp
  8006ca:	48 83 ec 18          	sub    $0x18,%rsp
  8006ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006d9:	eb 6b                	jmp    800746 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006de:	48 98                	cltq   
  8006e0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006e6:	48 c1 e0 0c          	shl    $0xc,%rax
  8006ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f2:	48 89 c2             	mov    %rax,%rdx
  8006f5:	48 c1 ea 15          	shr    $0x15,%rdx
  8006f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800700:	01 00 00 
  800703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800707:	83 e0 01             	and    $0x1,%eax
  80070a:	48 85 c0             	test   %rax,%rax
  80070d:	74 21                	je     800730 <fd_alloc+0x6a>
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	48 89 c2             	mov    %rax,%rdx
  800716:	48 c1 ea 0c          	shr    $0xc,%rdx
  80071a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800721:	01 00 00 
  800724:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800728:	83 e0 01             	and    $0x1,%eax
  80072b:	48 85 c0             	test   %rax,%rax
  80072e:	75 12                	jne    800742 <fd_alloc+0x7c>
			*fd_store = fd;
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800738:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80073b:	b8 00 00 00 00       	mov    $0x0,%eax
  800740:	eb 1a                	jmp    80075c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800742:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800746:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80074a:	7e 8f                	jle    8006db <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800757:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80075c:	c9                   	leaveq 
  80075d:	c3                   	retq   

000000000080075e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80075e:	55                   	push   %rbp
  80075f:	48 89 e5             	mov    %rsp,%rbp
  800762:	48 83 ec 20          	sub    $0x20,%rsp
  800766:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800769:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80076d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800771:	78 06                	js     800779 <fd_lookup+0x1b>
  800773:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800777:	7e 07                	jle    800780 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077e:	eb 6c                	jmp    8007ec <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800783:	48 98                	cltq   
  800785:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80078b:	48 c1 e0 0c          	shl    $0xc,%rax
  80078f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800797:	48 89 c2             	mov    %rax,%rdx
  80079a:	48 c1 ea 15          	shr    $0x15,%rdx
  80079e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007a5:	01 00 00 
  8007a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007ac:	83 e0 01             	and    $0x1,%eax
  8007af:	48 85 c0             	test   %rax,%rax
  8007b2:	74 21                	je     8007d5 <fd_lookup+0x77>
  8007b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007b8:	48 89 c2             	mov    %rax,%rdx
  8007bb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8007bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007c6:	01 00 00 
  8007c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007cd:	83 e0 01             	and    $0x1,%eax
  8007d0:	48 85 c0             	test   %rax,%rax
  8007d3:	75 07                	jne    8007dc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007da:	eb 10                	jmp    8007ec <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007e4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ec:	c9                   	leaveq 
  8007ed:	c3                   	retq   

00000000008007ee <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007ee:	55                   	push   %rbp
  8007ef:	48 89 e5             	mov    %rsp,%rbp
  8007f2:	48 83 ec 30          	sub    $0x30,%rsp
  8007f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007fa:	89 f0                	mov    %esi,%eax
  8007fc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800803:	48 89 c7             	mov    %rax,%rdi
  800806:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  80080d:	00 00 00 
  800810:	ff d0                	callq  *%rax
  800812:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800816:	48 89 d6             	mov    %rdx,%rsi
  800819:	89 c7                	mov    %eax,%edi
  80081b:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800822:	00 00 00 
  800825:	ff d0                	callq  *%rax
  800827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80082a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80082e:	78 0a                	js     80083a <fd_close+0x4c>
	    || fd != fd2)
  800830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800834:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800838:	74 12                	je     80084c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80083a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80083e:	74 05                	je     800845 <fd_close+0x57>
  800840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800843:	eb 05                	jmp    80084a <fd_close+0x5c>
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	eb 69                	jmp    8008b5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80084c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800856:	48 89 d6             	mov    %rdx,%rsi
  800859:	89 c7                	mov    %eax,%edi
  80085b:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800862:	00 00 00 
  800865:	ff d0                	callq  *%rax
  800867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80086a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80086e:	78 2a                	js     80089a <fd_close+0xac>
		if (dev->dev_close)
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	48 8b 40 20          	mov    0x20(%rax),%rax
  800878:	48 85 c0             	test   %rax,%rax
  80087b:	74 16                	je     800893 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80087d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800881:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800885:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800889:	48 89 c7             	mov    %rax,%rdi
  80088c:	ff d2                	callq  *%rdx
  80088e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800891:	eb 07                	jmp    80089a <fd_close+0xac>
		else
			r = 0;
  800893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80089a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089e:	48 89 c6             	mov    %rax,%rsi
  8008a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8008a6:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  8008ad:	00 00 00 
  8008b0:	ff d0                	callq  *%rax
	return r;
  8008b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008b5:	c9                   	leaveq 
  8008b6:	c3                   	retq   

00000000008008b7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008b7:	55                   	push   %rbp
  8008b8:	48 89 e5             	mov    %rsp,%rbp
  8008bb:	48 83 ec 20          	sub    $0x20,%rsp
  8008bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8008c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8008c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008cd:	eb 41                	jmp    800910 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008cf:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008d6:	00 00 00 
  8008d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008dc:	48 63 d2             	movslq %edx,%rdx
  8008df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008e3:	8b 00                	mov    (%rax),%eax
  8008e5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008e8:	75 22                	jne    80090c <dev_lookup+0x55>
			*dev = devtab[i];
  8008ea:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008f1:	00 00 00 
  8008f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008f7:	48 63 d2             	movslq %edx,%rdx
  8008fa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800902:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	eb 60                	jmp    80096c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80090c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800910:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800917:	00 00 00 
  80091a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80091d:	48 63 d2             	movslq %edx,%rdx
  800920:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800924:	48 85 c0             	test   %rax,%rax
  800927:	75 a6                	jne    8008cf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800929:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800930:	00 00 00 
  800933:	48 8b 00             	mov    (%rax),%rax
  800936:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80093c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80093f:	89 c6                	mov    %eax,%esi
  800941:	48 bf 80 3b 80 00 00 	movabs $0x803b80,%rdi
  800948:	00 00 00 
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	48 b9 63 25 80 00 00 	movabs $0x802563,%rcx
  800957:	00 00 00 
  80095a:	ff d1                	callq  *%rcx
	*dev = 0;
  80095c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800960:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80096c:	c9                   	leaveq 
  80096d:	c3                   	retq   

000000000080096e <close>:

int
close(int fdnum)
{
  80096e:	55                   	push   %rbp
  80096f:	48 89 e5             	mov    %rsp,%rbp
  800972:	48 83 ec 20          	sub    $0x20,%rsp
  800976:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800979:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80097d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800980:	48 89 d6             	mov    %rdx,%rsi
  800983:	89 c7                	mov    %eax,%edi
  800985:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  80098c:	00 00 00 
  80098f:	ff d0                	callq  *%rax
  800991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800998:	79 05                	jns    80099f <close+0x31>
		return r;
  80099a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80099d:	eb 18                	jmp    8009b7 <close+0x49>
	else
		return fd_close(fd, 1);
  80099f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009a3:	be 01 00 00 00       	mov    $0x1,%esi
  8009a8:	48 89 c7             	mov    %rax,%rdi
  8009ab:	48 b8 ee 07 80 00 00 	movabs $0x8007ee,%rax
  8009b2:	00 00 00 
  8009b5:	ff d0                	callq  *%rax
}
  8009b7:	c9                   	leaveq 
  8009b8:	c3                   	retq   

00000000008009b9 <close_all>:

void
close_all(void)
{
  8009b9:	55                   	push   %rbp
  8009ba:	48 89 e5             	mov    %rsp,%rbp
  8009bd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8009c8:	eb 15                	jmp    8009df <close_all+0x26>
		close(i);
  8009ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009cd:	89 c7                	mov    %eax,%edi
  8009cf:	48 b8 6e 09 80 00 00 	movabs $0x80096e,%rax
  8009d6:	00 00 00 
  8009d9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009df:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009e3:	7e e5                	jle    8009ca <close_all+0x11>
		close(i);
}
  8009e5:	c9                   	leaveq 
  8009e6:	c3                   	retq   

00000000008009e7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009e7:	55                   	push   %rbp
  8009e8:	48 89 e5             	mov    %rsp,%rbp
  8009eb:	48 83 ec 40          	sub    $0x40,%rsp
  8009ef:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009f2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009f5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009f9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009fc:	48 89 d6             	mov    %rdx,%rsi
  8009ff:	89 c7                	mov    %eax,%edi
  800a01:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800a08:	00 00 00 
  800a0b:	ff d0                	callq  *%rax
  800a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a14:	79 08                	jns    800a1e <dup+0x37>
		return r;
  800a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a19:	e9 70 01 00 00       	jmpq   800b8e <dup+0x1a7>
	close(newfdnum);
  800a1e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a21:	89 c7                	mov    %eax,%edi
  800a23:	48 b8 6e 09 80 00 00 	movabs $0x80096e,%rax
  800a2a:	00 00 00 
  800a2d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a2f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a32:	48 98                	cltq   
  800a34:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a3a:	48 c1 e0 0c          	shl    $0xc,%rax
  800a3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a46:	48 89 c7             	mov    %rax,%rdi
  800a49:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  800a50:	00 00 00 
  800a53:	ff d0                	callq  *%rax
  800a55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5d:	48 89 c7             	mov    %rax,%rdi
  800a60:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  800a67:	00 00 00 
  800a6a:	ff d0                	callq  *%rax
  800a6c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a74:	48 89 c2             	mov    %rax,%rdx
  800a77:	48 c1 ea 15          	shr    $0x15,%rdx
  800a7b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a82:	01 00 00 
  800a85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a89:	83 e0 01             	and    $0x1,%eax
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 71                	je     800b01 <dup+0x11a>
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	48 89 c2             	mov    %rax,%rdx
  800a97:	48 c1 ea 0c          	shr    $0xc,%rdx
  800a9b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aa2:	01 00 00 
  800aa5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800aa9:	83 e0 01             	and    $0x1,%eax
  800aac:	84 c0                	test   %al,%al
  800aae:	74 51                	je     800b01 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	48 89 c2             	mov    %rax,%rdx
  800ab7:	48 c1 ea 0c          	shr    $0xc,%rdx
  800abb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ac2:	01 00 00 
  800ac5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ac9:	89 c1                	mov    %eax,%ecx
  800acb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800ad1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad9:	41 89 c8             	mov    %ecx,%r8d
  800adc:	48 89 d1             	mov    %rdx,%rcx
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	48 89 c6             	mov    %rax,%rsi
  800ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  800aec:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  800af3:	00 00 00 
  800af6:	ff d0                	callq  *%rax
  800af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aff:	78 56                	js     800b57 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b05:	48 89 c2             	mov    %rax,%rdx
  800b08:	48 c1 ea 0c          	shr    $0xc,%rdx
  800b0c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b13:	01 00 00 
  800b16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800b22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b2a:	41 89 c8             	mov    %ecx,%r8d
  800b2d:	48 89 d1             	mov    %rdx,%rcx
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	48 89 c6             	mov    %rax,%rsi
  800b38:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3d:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b50:	78 08                	js     800b5a <dup+0x173>
		goto err;

	return newfdnum;
  800b52:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b55:	eb 37                	jmp    800b8e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  800b57:	90                   	nop
  800b58:	eb 01                	jmp    800b5b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  800b5a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5f:	48 89 c6             	mov    %rax,%rsi
  800b62:	bf 00 00 00 00       	mov    $0x0,%edi
  800b67:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b77:	48 89 c6             	mov    %rax,%rsi
  800b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7f:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800b86:	00 00 00 
  800b89:	ff d0                	callq  *%rax
	return r;
  800b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b8e:	c9                   	leaveq 
  800b8f:	c3                   	retq   

0000000000800b90 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b90:	55                   	push   %rbp
  800b91:	48 89 e5             	mov    %rsp,%rbp
  800b94:	48 83 ec 40          	sub    $0x40,%rsp
  800b98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b9f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ba3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ba7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800baa:	48 89 d6             	mov    %rdx,%rsi
  800bad:	89 c7                	mov    %eax,%edi
  800baf:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800bb6:	00 00 00 
  800bb9:	ff d0                	callq  *%rax
  800bbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bc2:	78 24                	js     800be8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc8:	8b 00                	mov    (%rax),%eax
  800bca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bce:	48 89 d6             	mov    %rdx,%rsi
  800bd1:	89 c7                	mov    %eax,%edi
  800bd3:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
  800bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800be6:	79 05                	jns    800bed <read+0x5d>
		return r;
  800be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800beb:	eb 7a                	jmp    800c67 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf1:	8b 40 08             	mov    0x8(%rax),%eax
  800bf4:	83 e0 03             	and    $0x3,%eax
  800bf7:	83 f8 01             	cmp    $0x1,%eax
  800bfa:	75 3a                	jne    800c36 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bfc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c03:	00 00 00 
  800c06:	48 8b 00             	mov    (%rax),%rax
  800c09:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c0f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c12:	89 c6                	mov    %eax,%esi
  800c14:	48 bf 9f 3b 80 00 00 	movabs $0x803b9f,%rdi
  800c1b:	00 00 00 
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	48 b9 63 25 80 00 00 	movabs $0x802563,%rcx
  800c2a:	00 00 00 
  800c2d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c34:	eb 31                	jmp    800c67 <read+0xd7>
	}
	if (!dev->dev_read)
  800c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3a:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c3e:	48 85 c0             	test   %rax,%rax
  800c41:	75 07                	jne    800c4a <read+0xba>
		return -E_NOT_SUPP;
  800c43:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c48:	eb 1d                	jmp    800c67 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  800c4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  800c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c5a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800c5e:	48 89 ce             	mov    %rcx,%rsi
  800c61:	48 89 c7             	mov    %rax,%rdi
  800c64:	41 ff d0             	callq  *%r8
}
  800c67:	c9                   	leaveq 
  800c68:	c3                   	retq   

0000000000800c69 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c69:	55                   	push   %rbp
  800c6a:	48 89 e5             	mov    %rsp,%rbp
  800c6d:	48 83 ec 30          	sub    $0x30,%rsp
  800c71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c78:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c83:	eb 46                	jmp    800ccb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c88:	48 98                	cltq   
  800c8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c8e:	48 29 c2             	sub    %rax,%rdx
  800c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c94:	48 98                	cltq   
  800c96:	48 89 c1             	mov    %rax,%rcx
  800c99:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  800c9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ca0:	48 89 ce             	mov    %rcx,%rsi
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	48 b8 90 0b 80 00 00 	movabs $0x800b90,%rax
  800cac:	00 00 00 
  800caf:	ff d0                	callq  *%rax
  800cb1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800cb4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cb8:	79 05                	jns    800cbf <readn+0x56>
			return m;
  800cba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cbd:	eb 1d                	jmp    800cdc <readn+0x73>
		if (m == 0)
  800cbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cc3:	74 13                	je     800cd8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cc8:	01 45 fc             	add    %eax,-0x4(%rbp)
  800ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cce:	48 98                	cltq   
  800cd0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800cd4:	72 af                	jb     800c85 <readn+0x1c>
  800cd6:	eb 01                	jmp    800cd9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800cd8:	90                   	nop
	}
	return tot;
  800cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800cdc:	c9                   	leaveq 
  800cdd:	c3                   	retq   

0000000000800cde <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cde:	55                   	push   %rbp
  800cdf:	48 89 e5             	mov    %rsp,%rbp
  800ce2:	48 83 ec 40          	sub    $0x40,%rsp
  800ce6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ce9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800ced:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cf5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cf8:	48 89 d6             	mov    %rdx,%rsi
  800cfb:	89 c7                	mov    %eax,%edi
  800cfd:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
  800d09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d10:	78 24                	js     800d36 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d16:	8b 00                	mov    (%rax),%eax
  800d18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d1c:	48 89 d6             	mov    %rdx,%rsi
  800d1f:	89 c7                	mov    %eax,%edi
  800d21:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800d28:	00 00 00 
  800d2b:	ff d0                	callq  *%rax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d34:	79 05                	jns    800d3b <write+0x5d>
		return r;
  800d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d39:	eb 79                	jmp    800db4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3f:	8b 40 08             	mov    0x8(%rax),%eax
  800d42:	83 e0 03             	and    $0x3,%eax
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 3a                	jne    800d83 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d49:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d50:	00 00 00 
  800d53:	48 8b 00             	mov    (%rax),%rax
  800d56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d5f:	89 c6                	mov    %eax,%esi
  800d61:	48 bf bb 3b 80 00 00 	movabs $0x803bbb,%rdi
  800d68:	00 00 00 
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	48 b9 63 25 80 00 00 	movabs $0x802563,%rcx
  800d77:	00 00 00 
  800d7a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d81:	eb 31                	jmp    800db4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d87:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d8b:	48 85 c0             	test   %rax,%rax
  800d8e:	75 07                	jne    800d97 <write+0xb9>
		return -E_NOT_SUPP;
  800d90:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d95:	eb 1d                	jmp    800db4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  800d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  800d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800da7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800dab:	48 89 ce             	mov    %rcx,%rsi
  800dae:	48 89 c7             	mov    %rax,%rdi
  800db1:	41 ff d0             	callq  *%r8
}
  800db4:	c9                   	leaveq 
  800db5:	c3                   	retq   

0000000000800db6 <seek>:

int
seek(int fdnum, off_t offset)
{
  800db6:	55                   	push   %rbp
  800db7:	48 89 e5             	mov    %rsp,%rbp
  800dba:	48 83 ec 18          	sub    $0x18,%rsp
  800dbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dc1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800dcb:	48 89 d6             	mov    %rdx,%rsi
  800dce:	89 c7                	mov    %eax,%edi
  800dd0:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de3:	79 05                	jns    800dea <seek+0x34>
		return r;
  800de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800de8:	eb 0f                	jmp    800df9 <seek+0x43>
	fd->fd_offset = offset;
  800dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800df1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df9:	c9                   	leaveq 
  800dfa:	c3                   	retq   

0000000000800dfb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 83 ec 30          	sub    $0x30,%rsp
  800e03:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e06:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e09:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e10:	48 89 d6             	mov    %rdx,%rsi
  800e13:	89 c7                	mov    %eax,%edi
  800e15:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800e1c:	00 00 00 
  800e1f:	ff d0                	callq  *%rax
  800e21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e28:	78 24                	js     800e4e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2e:	8b 00                	mov    (%rax),%eax
  800e30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e34:	48 89 d6             	mov    %rdx,%rsi
  800e37:	89 c7                	mov    %eax,%edi
  800e39:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800e40:	00 00 00 
  800e43:	ff d0                	callq  *%rax
  800e45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e4c:	79 05                	jns    800e53 <ftruncate+0x58>
		return r;
  800e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e51:	eb 72                	jmp    800ec5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e57:	8b 40 08             	mov    0x8(%rax),%eax
  800e5a:	83 e0 03             	and    $0x3,%eax
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 3a                	jne    800e9b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e61:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800e68:	00 00 00 
  800e6b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e6e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e74:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e77:	89 c6                	mov    %eax,%esi
  800e79:	48 bf d8 3b 80 00 00 	movabs $0x803bd8,%rdi
  800e80:	00 00 00 
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
  800e88:	48 b9 63 25 80 00 00 	movabs $0x802563,%rcx
  800e8f:	00 00 00 
  800e92:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e99:	eb 2a                	jmp    800ec5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9f:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ea3:	48 85 c0             	test   %rax,%rax
  800ea6:	75 07                	jne    800eaf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800ea8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ead:	eb 16                	jmp    800ec5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800eaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  800eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ebe:	89 d6                	mov    %edx,%esi
  800ec0:	48 89 c7             	mov    %rax,%rdi
  800ec3:	ff d1                	callq  *%rcx
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	48 83 ec 30          	sub    $0x30,%rsp
  800ecf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ed2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ed6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800eda:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800edd:	48 89 d6             	mov    %rdx,%rsi
  800ee0:	89 c7                	mov    %eax,%edi
  800ee2:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	callq  *%rax
  800eee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ef1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ef5:	78 24                	js     800f1b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efb:	8b 00                	mov    (%rax),%eax
  800efd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f01:	48 89 d6             	mov    %rdx,%rsi
  800f04:	89 c7                	mov    %eax,%edi
  800f06:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
  800f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f19:	79 05                	jns    800f20 <fstat+0x59>
		return r;
  800f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1e:	eb 5e                	jmp    800f7e <fstat+0xb7>
	if (!dev->dev_stat)
  800f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f24:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f28:	48 85 c0             	test   %rax,%rax
  800f2b:	75 07                	jne    800f34 <fstat+0x6d>
		return -E_NOT_SUPP;
  800f2d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f32:	eb 4a                	jmp    800f7e <fstat+0xb7>
	stat->st_name[0] = 0;
  800f34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f38:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f3f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f46:	00 00 00 
	stat->st_isdir = 0;
  800f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f54:	00 00 00 
	stat->st_dev = dev;
  800f57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f5f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800f76:	48 89 d6             	mov    %rdx,%rsi
  800f79:	48 89 c7             	mov    %rax,%rdi
  800f7c:	ff d1                	callq  *%rcx
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 20          	sub    $0x20,%rsp
  800f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f94:	be 00 00 00 00       	mov    $0x0,%esi
  800f99:	48 89 c7             	mov    %rax,%rdi
  800f9c:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  800fa3:	00 00 00 
  800fa6:	ff d0                	callq  *%rax
  800fa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800faf:	79 05                	jns    800fb6 <stat+0x36>
		return fd;
  800fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fb4:	eb 2f                	jmp    800fe5 <stat+0x65>
	r = fstat(fd, stat);
  800fb6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fbd:	48 89 d6             	mov    %rdx,%rsi
  800fc0:	89 c7                	mov    %eax,%edi
  800fc2:	48 b8 c7 0e 80 00 00 	movabs $0x800ec7,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	callq  *%rax
  800fce:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd4:	89 c7                	mov    %eax,%edi
  800fd6:	48 b8 6e 09 80 00 00 	movabs $0x80096e,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	callq  *%rax
	return r;
  800fe2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800fe5:	c9                   	leaveq 
  800fe6:	c3                   	retq   
	...

0000000000800fe8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fe8:	55                   	push   %rbp
  800fe9:	48 89 e5             	mov    %rsp,%rbp
  800fec:	48 83 ec 10          	sub    $0x10,%rsp
  800ff0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ff3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ff7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ffe:	00 00 00 
  801001:	8b 00                	mov    (%rax),%eax
  801003:	85 c0                	test   %eax,%eax
  801005:	75 1d                	jne    801024 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801007:	bf 01 00 00 00       	mov    $0x1,%edi
  80100c:	48 b8 1e 3a 80 00 00 	movabs $0x803a1e,%rax
  801013:	00 00 00 
  801016:	ff d0                	callq  *%rax
  801018:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80101f:	00 00 00 
  801022:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801024:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80102b:	00 00 00 
  80102e:	8b 00                	mov    (%rax),%eax
  801030:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801033:	b9 07 00 00 00       	mov    $0x7,%ecx
  801038:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80103f:	00 00 00 
  801042:	89 c7                	mov    %eax,%edi
  801044:	48 b8 6f 39 80 00 00 	movabs $0x80396f,%rax
  80104b:	00 00 00 
  80104e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801054:	ba 00 00 00 00       	mov    $0x0,%edx
  801059:	48 89 c6             	mov    %rax,%rsi
  80105c:	bf 00 00 00 00       	mov    $0x0,%edi
  801061:	48 b8 88 38 80 00 00 	movabs $0x803888,%rax
  801068:	00 00 00 
  80106b:	ff d0                	callq  *%rax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 20          	sub    $0x20,%rsp
  801077:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	48 89 c7             	mov    %rax,%rdi
  801085:	48 b8 c8 30 80 00 00 	movabs $0x8030c8,%rax
  80108c:	00 00 00 
  80108f:	ff d0                	callq  *%rax
  801091:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801096:	7e 0a                	jle    8010a2 <open+0x33>
		return -E_BAD_PATH;
  801098:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80109d:	e9 a5 00 00 00       	jmpq   801147 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8010a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8010a6:	48 89 c7             	mov    %rax,%rdi
  8010a9:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	callq  *%rax
  8010b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8010b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010bc:	79 08                	jns    8010c6 <open+0x57>
		return r;
  8010be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c1:	e9 81 00 00 00       	jmpq   801147 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8010c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010cd:	00 00 00 
  8010d0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8010d3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 89 c6             	mov    %rax,%rsi
  8010e0:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8010e7:	00 00 00 
  8010ea:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  8010f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fa:	48 89 c6             	mov    %rax,%rsi
  8010fd:	bf 01 00 00 00       	mov    $0x1,%edi
  801102:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  801109:	00 00 00 
  80110c:	ff d0                	callq  *%rax
  80110e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  801111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801115:	79 1d                	jns    801134 <open+0xc5>
		fd_close(new_fd, 0);
  801117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111b:	be 00 00 00 00       	mov    $0x0,%esi
  801120:	48 89 c7             	mov    %rax,%rdi
  801123:	48 b8 ee 07 80 00 00 	movabs $0x8007ee,%rax
  80112a:	00 00 00 
  80112d:	ff d0                	callq  *%rax
		return r;	
  80112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801132:	eb 13                	jmp    801147 <open+0xd8>
	}
	return fd2num(new_fd);
  801134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801138:	48 89 c7             	mov    %rax,%rdi
  80113b:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  801142:	00 00 00 
  801145:	ff d0                	callq  *%rax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 10          	sub    $0x10,%rsp
  801151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801159:	8b 50 0c             	mov    0xc(%rax),%edx
  80115c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801163:	00 00 00 
  801166:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801168:	be 00 00 00 00       	mov    $0x0,%esi
  80116d:	bf 06 00 00 00       	mov    $0x6,%edi
  801172:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 30          	sub    $0x30,%rsp
  801188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801190:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	8b 50 0c             	mov    0xc(%rax),%edx
  80119b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011a2:	00 00 00 
  8011a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011a7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011ae:	00 00 00 
  8011b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8011b9:	be 00 00 00 00       	mov    $0x0,%esi
  8011be:	bf 03 00 00 00       	mov    $0x3,%edi
  8011c3:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  8011ca:	00 00 00 
  8011cd:	ff d0                	callq  *%rax
  8011cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011d6:	7e 23                	jle    8011fb <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8011d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011db:	48 63 d0             	movslq %eax,%rdx
  8011de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e2:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011e9:	00 00 00 
  8011ec:	48 89 c7             	mov    %rax,%rdi
  8011ef:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  8011f6:	00 00 00 
  8011f9:	ff d0                	callq  *%rax
	}
	return nbytes;
  8011fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011fe:	c9                   	leaveq 
  8011ff:	c3                   	retq   

0000000000801200 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801200:	55                   	push   %rbp
  801201:	48 89 e5             	mov    %rsp,%rbp
  801204:	48 83 ec 20          	sub    $0x20,%rsp
  801208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801214:	8b 50 0c             	mov    0xc(%rax),%edx
  801217:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80121e:	00 00 00 
  801221:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801223:	be 00 00 00 00       	mov    $0x0,%esi
  801228:	bf 05 00 00 00       	mov    $0x5,%edi
  80122d:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  801234:	00 00 00 
  801237:	ff d0                	callq  *%rax
  801239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80123c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801240:	79 05                	jns    801247 <devfile_stat+0x47>
		return r;
  801242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801245:	eb 56                	jmp    80129d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801252:	00 00 00 
  801255:	48 89 c7             	mov    %rax,%rdi
  801258:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  80125f:	00 00 00 
  801262:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801264:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80126b:	00 00 00 
  80126e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801274:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801278:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80127e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801285:	00 00 00 
  801288:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80128e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801292:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   
	...

00000000008012a0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 20          	sub    $0x20,%rsp
  8012a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8012ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8012af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8012b2:	48 89 d6             	mov    %rdx,%rsi
  8012b5:	89 c7                	mov    %eax,%edi
  8012b7:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  8012be:	00 00 00 
  8012c1:	ff d0                	callq  *%rax
  8012c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ca:	79 05                	jns    8012d1 <fd2sockid+0x31>
		return r;
  8012cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012cf:	eb 24                	jmp    8012f5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8012d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d5:	8b 10                	mov    (%rax),%edx
  8012d7:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  8012de:	00 00 00 
  8012e1:	8b 00                	mov    (%rax),%eax
  8012e3:	39 c2                	cmp    %eax,%edx
  8012e5:	74 07                	je     8012ee <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8012e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8012ec:	eb 07                	jmp    8012f5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 20          	sub    $0x20,%rsp
  8012ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801302:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801306:	48 89 c7             	mov    %rax,%rdi
  801309:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  801310:	00 00 00 
  801313:	ff d0                	callq  *%rax
  801315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801318:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80131c:	78 26                	js     801344 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	ba 07 04 00 00       	mov    $0x407,%edx
  801327:	48 89 c6             	mov    %rax,%rsi
  80132a:	bf 00 00 00 00       	mov    $0x0,%edi
  80132f:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801336:	00 00 00 
  801339:	ff d0                	callq  *%rax
  80133b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80133e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801342:	79 16                	jns    80135a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801344:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801347:	89 c7                	mov    %eax,%edi
  801349:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
		return r;
  801355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801358:	eb 3a                	jmp    801394 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80135a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135e:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  801365:	00 00 00 
  801368:	8b 12                	mov    (%rdx),%edx
  80136a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80137e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	48 89 c7             	mov    %rax,%rdi
  801388:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  80138f:	00 00 00 
  801392:	ff d0                	callq  *%rax
}
  801394:	c9                   	leaveq 
  801395:	c3                   	retq   

0000000000801396 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	48 83 ec 30          	sub    $0x30,%rsp
  80139e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8013a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8013ac:	89 c7                	mov    %eax,%edi
  8013ae:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  8013b5:	00 00 00 
  8013b8:	ff d0                	callq  *%rax
  8013ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013c1:	79 05                	jns    8013c8 <accept+0x32>
		return r;
  8013c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c6:	eb 3b                	jmp    801403 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8013c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8013d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d3:	48 89 ce             	mov    %rcx,%rsi
  8013d6:	89 c7                	mov    %eax,%edi
  8013d8:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8013df:	00 00 00 
  8013e2:	ff d0                	callq  *%rax
  8013e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013eb:	79 05                	jns    8013f2 <accept+0x5c>
		return r;
  8013ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013f0:	eb 11                	jmp    801403 <accept+0x6d>
	return alloc_sockfd(r);
  8013f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013f5:	89 c7                	mov    %eax,%edi
  8013f7:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
}
  801403:	c9                   	leaveq 
  801404:	c3                   	retq   

0000000000801405 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801405:	55                   	push   %rbp
  801406:	48 89 e5             	mov    %rsp,%rbp
  801409:	48 83 ec 20          	sub    $0x20,%rsp
  80140d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801410:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801414:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801417:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80141a:	89 c7                	mov    %eax,%edi
  80141c:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  801423:	00 00 00 
  801426:	ff d0                	callq  *%rax
  801428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80142b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80142f:	79 05                	jns    801436 <bind+0x31>
		return r;
  801431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801434:	eb 1b                	jmp    801451 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801436:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801439:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80143d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801440:	48 89 ce             	mov    %rcx,%rsi
  801443:	89 c7                	mov    %eax,%edi
  801445:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  80144c:	00 00 00 
  80144f:	ff d0                	callq  *%rax
}
  801451:	c9                   	leaveq 
  801452:	c3                   	retq   

0000000000801453 <shutdown>:

int
shutdown(int s, int how)
{
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	48 83 ec 20          	sub    $0x20,%rsp
  80145b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80145e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801464:	89 c7                	mov    %eax,%edi
  801466:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  80146d:	00 00 00 
  801470:	ff d0                	callq  *%rax
  801472:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801475:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801479:	79 05                	jns    801480 <shutdown+0x2d>
		return r;
  80147b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80147e:	eb 16                	jmp    801496 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801480:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801486:	89 d6                	mov    %edx,%esi
  801488:	89 c7                	mov    %eax,%edi
  80148a:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 10          	sub    $0x10,%rsp
  8014a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	48 89 c7             	mov    %rax,%rdi
  8014ab:	48 b8 ac 3a 80 00 00 	movabs $0x803aac,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	callq  *%rax
  8014b7:	83 f8 01             	cmp    $0x1,%eax
  8014ba:	75 17                	jne    8014d3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	8b 40 0c             	mov    0xc(%rax),%eax
  8014c3:	89 c7                	mov    %eax,%edi
  8014c5:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	callq  *%rax
  8014d1:	eb 05                	jmp    8014d8 <devsock_close+0x40>
	else
		return 0;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d8:	c9                   	leaveq 
  8014d9:	c3                   	retq   

00000000008014da <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	48 83 ec 20          	sub    $0x20,%rsp
  8014e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ef:	89 c7                	mov    %eax,%edi
  8014f1:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  8014f8:	00 00 00 
  8014fb:	ff d0                	callq  *%rax
  8014fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801500:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801504:	79 05                	jns    80150b <connect+0x31>
		return r;
  801506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801509:	eb 1b                	jmp    801526 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80150b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80150e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801512:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801515:	48 89 ce             	mov    %rcx,%rsi
  801518:	89 c7                	mov    %eax,%edi
  80151a:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801521:	00 00 00 
  801524:	ff d0                	callq  *%rax
}
  801526:	c9                   	leaveq 
  801527:	c3                   	retq   

0000000000801528 <listen>:

int
listen(int s, int backlog)
{
  801528:	55                   	push   %rbp
  801529:	48 89 e5             	mov    %rsp,%rbp
  80152c:	48 83 ec 20          	sub    $0x20,%rsp
  801530:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801533:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801536:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801539:	89 c7                	mov    %eax,%edi
  80153b:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  801542:	00 00 00 
  801545:	ff d0                	callq  *%rax
  801547:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80154e:	79 05                	jns    801555 <listen+0x2d>
		return r;
  801550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801553:	eb 16                	jmp    80156b <listen+0x43>
	return nsipc_listen(r, backlog);
  801555:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80155b:	89 d6                	mov    %edx,%esi
  80155d:	89 c7                	mov    %eax,%edi
  80155f:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 20          	sub    $0x20,%rsp
  801575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801579:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80157d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	89 c2                	mov    %eax,%edx
  801587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158b:	8b 40 0c             	mov    0xc(%rax),%eax
  80158e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801592:	b9 00 00 00 00       	mov    $0x0,%ecx
  801597:	89 c7                	mov    %eax,%edi
  801599:	48 b8 d5 18 80 00 00 	movabs $0x8018d5,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
}
  8015a5:	c9                   	leaveq 
  8015a6:	c3                   	retq   

00000000008015a7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	48 83 ec 20          	sub    $0x20,%rsp
  8015af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bf:	89 c2                	mov    %eax,%edx
  8015c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c5:	8b 40 0c             	mov    0xc(%rax),%eax
  8015c8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8015cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  8015da:	00 00 00 
  8015dd:	ff d0                	callq  *%rax
}
  8015df:	c9                   	leaveq 
  8015e0:	c3                   	retq   

00000000008015e1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
  8015e5:	48 83 ec 10          	sub    $0x10,%rsp
  8015e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	48 be 03 3c 80 00 00 	movabs $0x803c03,%rsi
  8015fc:	00 00 00 
  8015ff:	48 89 c7             	mov    %rax,%rdi
  801602:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  801609:	00 00 00 
  80160c:	ff d0                	callq  *%rax
	return 0;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801613:	c9                   	leaveq 
  801614:	c3                   	retq   

0000000000801615 <socket>:

int
socket(int domain, int type, int protocol)
{
  801615:	55                   	push   %rbp
  801616:	48 89 e5             	mov    %rsp,%rbp
  801619:	48 83 ec 20          	sub    $0x20,%rsp
  80161d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801620:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801623:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801626:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801629:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80162c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80162f:	89 ce                	mov    %ecx,%esi
  801631:	89 c7                	mov    %eax,%edi
  801633:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  80163a:	00 00 00 
  80163d:	ff d0                	callq  *%rax
  80163f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801646:	79 05                	jns    80164d <socket+0x38>
		return r;
  801648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80164b:	eb 11                	jmp    80165e <socket+0x49>
	return alloc_sockfd(r);
  80164d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801650:	89 c7                	mov    %eax,%edi
  801652:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  801659:	00 00 00 
  80165c:	ff d0                	callq  *%rax
}
  80165e:	c9                   	leaveq 
  80165f:	c3                   	retq   

0000000000801660 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	48 83 ec 10          	sub    $0x10,%rsp
  801668:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80166b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  801672:	00 00 00 
  801675:	8b 00                	mov    (%rax),%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	75 1d                	jne    801698 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80167b:	bf 02 00 00 00       	mov    $0x2,%edi
  801680:	48 b8 1e 3a 80 00 00 	movabs $0x803a1e,%rax
  801687:	00 00 00 
  80168a:	ff d0                	callq  *%rax
  80168c:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  801693:	00 00 00 
  801696:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801698:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80169f:	00 00 00 
  8016a2:	8b 00                	mov    (%rax),%eax
  8016a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8016a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8016ac:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8016b3:	00 00 00 
  8016b6:	89 c7                	mov    %eax,%edi
  8016b8:	48 b8 6f 39 80 00 00 	movabs $0x80396f,%rax
  8016bf:	00 00 00 
  8016c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8016d3:	48 b8 88 38 80 00 00 	movabs $0x803888,%rax
  8016da:	00 00 00 
  8016dd:	ff d0                	callq  *%rax
}
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 30          	sub    $0x30,%rsp
  8016e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8016ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8016f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8016fb:	00 00 00 
  8016fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801701:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801703:	bf 01 00 00 00       	mov    $0x1,%edi
  801708:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  80170f:	00 00 00 
  801712:	ff d0                	callq  *%rax
  801714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80171b:	78 3e                	js     80175b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80171d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801724:	00 00 00 
  801727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80172b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172f:	8b 40 10             	mov    0x10(%rax),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801738:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80173c:	48 89 ce             	mov    %rcx,%rsi
  80173f:	48 89 c7             	mov    %rax,%rdi
  801742:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  801749:	00 00 00 
  80174c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80174e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801752:	8b 50 10             	mov    0x10(%rax),%edx
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80175b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
  801764:	48 83 ec 10          	sub    $0x10,%rsp
  801768:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80176b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801772:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801779:	00 00 00 
  80177c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80177f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801781:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801788:	48 89 c6             	mov    %rax,%rsi
  80178b:	48 bf 04 90 80 00 00 	movabs $0x809004,%rdi
  801792:	00 00 00 
  801795:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  80179c:	00 00 00 
  80179f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8017a1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8017a8:	00 00 00 
  8017ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8017ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8017b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b6:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
}
  8017c2:	c9                   	leaveq 
  8017c3:	c3                   	retq   

00000000008017c4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	48 83 ec 10          	sub    $0x10,%rsp
  8017cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8017d2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8017d9:	00 00 00 
  8017dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8017df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8017e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8017e8:	00 00 00 
  8017eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8017ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8017f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8017f6:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <nsipc_close>:

int
nsipc_close(int s)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 10          	sub    $0x10,%rsp
  80180c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80180f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801816:	00 00 00 
  801819:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80181c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80181e:	bf 04 00 00 00       	mov    $0x4,%edi
  801823:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  80182a:	00 00 00 
  80182d:	ff d0                	callq  *%rax
}
  80182f:	c9                   	leaveq 
  801830:	c3                   	retq   

0000000000801831 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	48 83 ec 10          	sub    $0x10,%rsp
  801839:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801840:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801843:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80184a:	00 00 00 
  80184d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801850:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801852:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801859:	48 89 c6             	mov    %rax,%rsi
  80185c:	48 bf 04 90 80 00 00 	movabs $0x809004,%rdi
  801863:	00 00 00 
  801866:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801872:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801879:	00 00 00 
  80187c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80187f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801882:	bf 05 00 00 00       	mov    $0x5,%edi
  801887:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  80188e:	00 00 00 
  801891:	ff d0                	callq  *%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 10          	sub    $0x10,%rsp
  80189d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8018a3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8018aa:	00 00 00 
  8018ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018b0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8018b2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8018b9:	00 00 00 
  8018bc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8018bf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8018c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8018c7:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
}
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	48 83 ec 30          	sub    $0x30,%rsp
  8018dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018e4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8018e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8018ea:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8018f1:	00 00 00 
  8018f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8018f7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8018f9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801900:	00 00 00 
  801903:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801906:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801909:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801910:	00 00 00 
  801913:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801916:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801919:	bf 07 00 00 00       	mov    $0x7,%edi
  80191e:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  801925:	00 00 00 
  801928:	ff d0                	callq  *%rax
  80192a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80192d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801931:	78 69                	js     80199c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801933:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80193a:	7f 08                	jg     801944 <nsipc_recv+0x6f>
  80193c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801942:	7e 35                	jle    801979 <nsipc_recv+0xa4>
  801944:	48 b9 0a 3c 80 00 00 	movabs $0x803c0a,%rcx
  80194b:	00 00 00 
  80194e:	48 ba 1f 3c 80 00 00 	movabs $0x803c1f,%rdx
  801955:	00 00 00 
  801958:	be 61 00 00 00       	mov    $0x61,%esi
  80195d:	48 bf 34 3c 80 00 00 	movabs $0x803c34,%rdi
  801964:	00 00 00 
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	49 b8 28 23 80 00 00 	movabs $0x802328,%r8
  801973:	00 00 00 
  801976:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197c:	48 63 d0             	movslq %eax,%rdx
  80197f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801983:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80198a:	00 00 00 
  80198d:	48 89 c7             	mov    %rax,%rdi
  801990:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  801997:	00 00 00 
  80199a:	ff d0                	callq  *%rax
	}

	return r;
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80199f:	c9                   	leaveq 
  8019a0:	c3                   	retq   

00000000008019a1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8019a1:	55                   	push   %rbp
  8019a2:	48 89 e5             	mov    %rsp,%rbp
  8019a5:	48 83 ec 20          	sub    $0x20,%rsp
  8019a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8019b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8019bd:	00 00 00 
  8019c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8019c3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8019c5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8019cc:	7e 35                	jle    801a03 <nsipc_send+0x62>
  8019ce:	48 b9 40 3c 80 00 00 	movabs $0x803c40,%rcx
  8019d5:	00 00 00 
  8019d8:	48 ba 1f 3c 80 00 00 	movabs $0x803c1f,%rdx
  8019df:	00 00 00 
  8019e2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8019e7:	48 bf 34 3c 80 00 00 	movabs $0x803c34,%rdi
  8019ee:	00 00 00 
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f6:	49 b8 28 23 80 00 00 	movabs $0x802328,%r8
  8019fd:	00 00 00 
  801a00:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a06:	48 63 d0             	movslq %eax,%rdx
  801a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a0d:	48 89 c6             	mov    %rax,%rsi
  801a10:	48 bf 0c 90 80 00 00 	movabs $0x80900c,%rdi
  801a17:	00 00 00 
  801a1a:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801a26:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801a2d:	00 00 00 
  801a30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a33:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801a36:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801a3d:	00 00 00 
  801a40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801a43:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801a46:	bf 08 00 00 00       	mov    $0x8,%edi
  801a4b:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 83 ec 10          	sub    $0x10,%rsp
  801a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a64:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801a67:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801a6a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801a71:	00 00 00 
  801a74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801a79:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801a80:	00 00 00 
  801a83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801a86:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801a89:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801a90:	00 00 00 
  801a93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a96:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801a99:	bf 09 00 00 00       	mov    $0x9,%edi
  801a9e:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	53                   	push   %rbx
  801ab1:	48 83 ec 38          	sub    $0x38,%rsp
  801ab5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ab9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801abd:	48 89 c7             	mov    %rax,%rdi
  801ac0:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  801ac7:	00 00 00 
  801aca:	ff d0                	callq  *%rax
  801acc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801acf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ad3:	0f 88 bf 01 00 00    	js     801c98 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801add:	ba 07 04 00 00       	mov    $0x407,%edx
  801ae2:	48 89 c6             	mov    %rax,%rsi
  801ae5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aea:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
  801af6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801af9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801afd:	0f 88 95 01 00 00    	js     801c98 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b03:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801b07:	48 89 c7             	mov    %rax,%rdi
  801b0a:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	callq  *%rax
  801b16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b1d:	0f 88 5d 01 00 00    	js     801c80 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b27:	ba 07 04 00 00       	mov    $0x407,%edx
  801b2c:	48 89 c6             	mov    %rax,%rsi
  801b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b34:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
  801b40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b47:	0f 88 33 01 00 00    	js     801c80 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b51:	48 89 c7             	mov    %rax,%rdi
  801b54:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	callq  *%rax
  801b60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b68:	ba 07 04 00 00       	mov    $0x407,%edx
  801b6d:	48 89 c6             	mov    %rax,%rsi
  801b70:	bf 00 00 00 00       	mov    $0x0,%edi
  801b75:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
  801b81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b88:	0f 88 d9 00 00 00    	js     801c67 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b92:	48 89 c7             	mov    %rax,%rdi
  801b95:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801bae:	48 89 d1             	mov    %rdx,%rcx
  801bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb6:	48 89 c6             	mov    %rax,%rsi
  801bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbe:	48 b8 78 03 80 00 00 	movabs $0x800378,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	callq  *%rax
  801bca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bd1:	78 79                	js     801c4c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd7:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801bde:	00 00 00 
  801be1:	8b 12                	mov    (%rdx),%edx
  801be3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801be5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801bf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf4:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801bfb:	00 00 00 
  801bfe:	8b 12                	mov    (%rdx),%edx
  801c00:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801c02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c11:	48 89 c7             	mov    %rax,%rdi
  801c14:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
  801c20:	89 c2                	mov    %eax,%edx
  801c22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801c26:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801c28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801c2c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801c30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c34:	48 89 c7             	mov    %rax,%rdi
  801c37:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  801c3e:	00 00 00 
  801c41:	ff d0                	callq  *%rax
  801c43:	89 03                	mov    %eax,(%rbx)
	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 4f                	jmp    801c9b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  801c4c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c51:	48 89 c6             	mov    %rax,%rsi
  801c54:	bf 00 00 00 00       	mov    $0x0,%edi
  801c59:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
  801c65:	eb 01                	jmp    801c68 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  801c67:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801c68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c6c:	48 89 c6             	mov    %rax,%rsi
  801c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c74:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c84:	48 89 c6             	mov    %rax,%rsi
  801c87:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8c:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	callq  *%rax
err:
	return r;
  801c98:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801c9b:	48 83 c4 38          	add    $0x38,%rsp
  801c9f:	5b                   	pop    %rbx
  801ca0:	5d                   	pop    %rbp
  801ca1:	c3                   	retq   

0000000000801ca2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	53                   	push   %rbx
  801ca7:	48 83 ec 28          	sub    $0x28,%rsp
  801cab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801caf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801cb3:	eb 01                	jmp    801cb6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  801cb5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801cb6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801cbd:	00 00 00 
  801cc0:	48 8b 00             	mov    (%rax),%rax
  801cc3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801cc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd0:	48 89 c7             	mov    %rax,%rdi
  801cd3:	48 b8 ac 3a 80 00 00 	movabs $0x803aac,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ce5:	48 89 c7             	mov    %rax,%rdi
  801ce8:	48 b8 ac 3a 80 00 00 	movabs $0x803aac,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
  801cf4:	39 c3                	cmp    %eax,%ebx
  801cf6:	0f 94 c0             	sete   %al
  801cf9:	0f b6 c0             	movzbl %al,%eax
  801cfc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801cff:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801d06:	00 00 00 
  801d09:	48 8b 00             	mov    (%rax),%rax
  801d0c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801d12:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801d15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d18:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801d1b:	75 0a                	jne    801d27 <_pipeisclosed+0x85>
			return ret;
  801d1d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801d20:	48 83 c4 28          	add    $0x28,%rsp
  801d24:	5b                   	pop    %rbx
  801d25:	5d                   	pop    %rbp
  801d26:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801d27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d2a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801d2d:	74 86                	je     801cb5 <_pipeisclosed+0x13>
  801d2f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801d33:	75 80                	jne    801cb5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d35:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801d3c:	00 00 00 
  801d3f:	48 8b 00             	mov    (%rax),%rax
  801d42:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801d48:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801d4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d4e:	89 c6                	mov    %eax,%esi
  801d50:	48 bf 51 3c 80 00 00 	movabs $0x803c51,%rdi
  801d57:	00 00 00 
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	49 b8 63 25 80 00 00 	movabs $0x802563,%r8
  801d66:	00 00 00 
  801d69:	41 ff d0             	callq  *%r8
	}
  801d6c:	e9 44 ff ff ff       	jmpq   801cb5 <_pipeisclosed+0x13>

0000000000801d71 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 30          	sub    $0x30,%rsp
  801d79:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d83:	48 89 d6             	mov    %rdx,%rsi
  801d86:	89 c7                	mov    %eax,%edi
  801d88:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
  801d94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d9b:	79 05                	jns    801da2 <pipeisclosed+0x31>
		return r;
  801d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da0:	eb 31                	jmp    801dd3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da6:	48 89 c7             	mov    %rax,%rdi
  801da9:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801db0:	00 00 00 
  801db3:	ff d0                	callq  *%rax
  801db5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc1:	48 89 d6             	mov    %rdx,%rsi
  801dc4:	48 89 c7             	mov    %rax,%rdi
  801dc7:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	callq  *%rax
}
  801dd3:	c9                   	leaveq 
  801dd4:	c3                   	retq   

0000000000801dd5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801dd5:	55                   	push   %rbp
  801dd6:	48 89 e5             	mov    %rsp,%rbp
  801dd9:	48 83 ec 40          	sub    $0x40,%rsp
  801ddd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801de1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801de5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ded:	48 89 c7             	mov    %rax,%rdi
  801df0:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801df7:	00 00 00 
  801dfa:	ff d0                	callq  *%rax
  801dfc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801e00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801e08:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801e0f:	00 
  801e10:	e9 97 00 00 00       	jmpq   801eac <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e15:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801e1a:	74 09                	je     801e25 <devpipe_read+0x50>
				return i;
  801e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e20:	e9 95 00 00 00       	jmpq   801eba <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2d:	48 89 d6             	mov    %rdx,%rsi
  801e30:	48 89 c7             	mov    %rax,%rdi
  801e33:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 07                	je     801e4a <devpipe_read+0x75>
				return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	eb 70                	jmp    801eba <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e4a:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  801e51:	00 00 00 
  801e54:	ff d0                	callq  *%rax
  801e56:	eb 01                	jmp    801e59 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e58:	90                   	nop
  801e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5d:	8b 10                	mov    (%rax),%edx
  801e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e63:	8b 40 04             	mov    0x4(%rax),%eax
  801e66:	39 c2                	cmp    %eax,%edx
  801e68:	74 ab                	je     801e15 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e72:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7a:	8b 00                	mov    (%rax),%eax
  801e7c:	89 c2                	mov    %eax,%edx
  801e7e:	c1 fa 1f             	sar    $0x1f,%edx
  801e81:	c1 ea 1b             	shr    $0x1b,%edx
  801e84:	01 d0                	add    %edx,%eax
  801e86:	83 e0 1f             	and    $0x1f,%eax
  801e89:	29 d0                	sub    %edx,%eax
  801e8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8f:	48 98                	cltq   
  801e91:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801e96:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9c:	8b 00                	mov    (%rax),%eax
  801e9e:	8d 50 01             	lea    0x1(%rax),%edx
  801ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801eb4:	72 a2                	jb     801e58 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801eba:	c9                   	leaveq 
  801ebb:	c3                   	retq   

0000000000801ebc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ebc:	55                   	push   %rbp
  801ebd:	48 89 e5             	mov    %rsp,%rbp
  801ec0:	48 83 ec 40          	sub    $0x40,%rsp
  801ec4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ecc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed4:	48 89 c7             	mov    %rax,%rdi
  801ed7:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801ede:	00 00 00 
  801ee1:	ff d0                	callq  *%rax
  801ee3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801ee7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801eef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801ef6:	00 
  801ef7:	e9 93 00 00 00       	jmpq   801f8f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801efc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f04:	48 89 d6             	mov    %rdx,%rsi
  801f07:	48 89 c7             	mov    %rax,%rdi
  801f0a:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	74 07                	je     801f21 <devpipe_write+0x65>
				return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	eb 7c                	jmp    801f9d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f21:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	callq  *%rax
  801f2d:	eb 01                	jmp    801f30 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f2f:	90                   	nop
  801f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f34:	8b 40 04             	mov    0x4(%rax),%eax
  801f37:	48 63 d0             	movslq %eax,%rdx
  801f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3e:	8b 00                	mov    (%rax),%eax
  801f40:	48 98                	cltq   
  801f42:	48 83 c0 20          	add    $0x20,%rax
  801f46:	48 39 c2             	cmp    %rax,%rdx
  801f49:	73 b1                	jae    801efc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4f:	8b 40 04             	mov    0x4(%rax),%eax
  801f52:	89 c2                	mov    %eax,%edx
  801f54:	c1 fa 1f             	sar    $0x1f,%edx
  801f57:	c1 ea 1b             	shr    $0x1b,%edx
  801f5a:	01 d0                	add    %edx,%eax
  801f5c:	83 e0 1f             	and    $0x1f,%eax
  801f5f:	29 d0                	sub    %edx,%eax
  801f61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f65:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f69:	48 01 ca             	add    %rcx,%rdx
  801f6c:	0f b6 0a             	movzbl (%rdx),%ecx
  801f6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f73:	48 98                	cltq   
  801f75:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7d:	8b 40 04             	mov    0x4(%rax),%eax
  801f80:	8d 50 01             	lea    0x1(%rax),%edx
  801f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f87:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f93:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801f97:	72 96                	jb     801f2f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 83 ec 20          	sub    $0x20,%rsp
  801fa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb3:	48 89 c7             	mov    %rax,%rdi
  801fb6:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
  801fc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801fc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fca:	48 be 64 3c 80 00 00 	movabs $0x803c64,%rsi
  801fd1:	00 00 00 
  801fd4:	48 89 c7             	mov    %rax,%rdi
  801fd7:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe7:	8b 50 04             	mov    0x4(%rax),%edx
  801fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fee:	8b 00                	mov    (%rax),%eax
  801ff0:	29 c2                	sub    %eax,%edx
  801ff2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801ffc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802000:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802007:	00 00 00 
	stat->st_dev = &devpipe;
  80200a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80200e:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802015:	00 00 00 
  802018:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802024:	c9                   	leaveq 
  802025:	c3                   	retq   

0000000000802026 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802026:	55                   	push   %rbp
  802027:	48 89 e5             	mov    %rsp,%rbp
  80202a:	48 83 ec 10          	sub    $0x10,%rsp
  80202e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802036:	48 89 c6             	mov    %rax,%rsi
  802039:	bf 00 00 00 00       	mov    $0x0,%edi
  80203e:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204e:	48 89 c7             	mov    %rax,%rdi
  802051:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	48 89 c6             	mov    %rax,%rsi
  802060:	bf 00 00 00 00       	mov    $0x0,%edi
  802065:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
}
  802071:	c9                   	leaveq 
  802072:	c3                   	retq   
	...

0000000000802074 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802074:	55                   	push   %rbp
  802075:	48 89 e5             	mov    %rsp,%rbp
  802078:	48 83 ec 20          	sub    $0x20,%rsp
  80207c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80207f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802082:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802085:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802089:	be 01 00 00 00       	mov    $0x1,%esi
  80208e:	48 89 c7             	mov    %rax,%rdi
  802091:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  802098:	00 00 00 
  80209b:	ff d0                	callq  *%rax
}
  80209d:	c9                   	leaveq 
  80209e:	c3                   	retq   

000000000080209f <getchar>:

int
getchar(void)
{
  80209f:	55                   	push   %rbp
  8020a0:	48 89 e5             	mov    %rsp,%rbp
  8020a3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8020a7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8020ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8020b0:	48 89 c6             	mov    %rax,%rsi
  8020b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b8:	48 b8 90 0b 80 00 00 	movabs $0x800b90,%rax
  8020bf:	00 00 00 
  8020c2:	ff d0                	callq  *%rax
  8020c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8020c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020cb:	79 05                	jns    8020d2 <getchar+0x33>
		return r;
  8020cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d0:	eb 14                	jmp    8020e6 <getchar+0x47>
	if (r < 1)
  8020d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d6:	7f 07                	jg     8020df <getchar+0x40>
		return -E_EOF;
  8020d8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8020dd:	eb 07                	jmp    8020e6 <getchar+0x47>
	return c;
  8020df:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8020e3:	0f b6 c0             	movzbl %al,%eax
}
  8020e6:	c9                   	leaveq 
  8020e7:	c3                   	retq   

00000000008020e8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	48 83 ec 20          	sub    $0x20,%rsp
  8020f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020fa:	48 89 d6             	mov    %rdx,%rsi
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
  80210b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80210e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802112:	79 05                	jns    802119 <iscons+0x31>
		return r;
  802114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802117:	eb 1a                	jmp    802133 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211d:	8b 10                	mov    (%rax),%edx
  80211f:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  802126:	00 00 00 
  802129:	8b 00                	mov    (%rax),%eax
  80212b:	39 c2                	cmp    %eax,%edx
  80212d:	0f 94 c0             	sete   %al
  802130:	0f b6 c0             	movzbl %al,%eax
}
  802133:	c9                   	leaveq 
  802134:	c3                   	retq   

0000000000802135 <opencons>:

int
opencons(void)
{
  802135:	55                   	push   %rbp
  802136:	48 89 e5             	mov    %rsp,%rbp
  802139:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80213d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802141:	48 89 c7             	mov    %rax,%rdi
  802144:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
  802150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802157:	79 05                	jns    80215e <opencons+0x29>
		return r;
  802159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215c:	eb 5b                	jmp    8021b9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80215e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802162:	ba 07 04 00 00       	mov    $0x407,%edx
  802167:	48 89 c6             	mov    %rax,%rsi
  80216a:	bf 00 00 00 00       	mov    $0x0,%edi
  80216f:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  802176:	00 00 00 
  802179:	ff d0                	callq  *%rax
  80217b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802182:	79 05                	jns    802189 <opencons+0x54>
		return r;
  802184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802187:	eb 30                	jmp    8021b9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218d:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  802194:	00 00 00 
  802197:	8b 12                	mov    (%rdx),%edx
  802199:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80219b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8021a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021aa:	48 89 c7             	mov    %rax,%rdi
  8021ad:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
}
  8021b9:	c9                   	leaveq 
  8021ba:	c3                   	retq   

00000000008021bb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021bb:	55                   	push   %rbp
  8021bc:	48 89 e5             	mov    %rsp,%rbp
  8021bf:	48 83 ec 30          	sub    $0x30,%rsp
  8021c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8021cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021d4:	75 13                	jne    8021e9 <devcons_read+0x2e>
		return 0;
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	eb 49                	jmp    802226 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021dd:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021e9:	48 b8 2a 02 80 00 00 	movabs $0x80022a,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
  8021f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fc:	74 df                	je     8021dd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8021fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802202:	79 05                	jns    802209 <devcons_read+0x4e>
		return c;
  802204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802207:	eb 1d                	jmp    802226 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  802209:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80220d:	75 07                	jne    802216 <devcons_read+0x5b>
		return 0;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	eb 10                	jmp    802226 <devcons_read+0x6b>
	*(char*)vbuf = c;
  802216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802219:	89 c2                	mov    %eax,%edx
  80221b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80221f:	88 10                	mov    %dl,(%rax)
	return 1;
  802221:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802226:	c9                   	leaveq 
  802227:	c3                   	retq   

0000000000802228 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802228:	55                   	push   %rbp
  802229:	48 89 e5             	mov    %rsp,%rbp
  80222c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802233:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80223a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802241:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80224f:	eb 77                	jmp    8022c8 <devcons_write+0xa0>
		m = n - tot;
  802251:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802258:	89 c2                	mov    %eax,%edx
  80225a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225d:	89 d1                	mov    %edx,%ecx
  80225f:	29 c1                	sub    %eax,%ecx
  802261:	89 c8                	mov    %ecx,%eax
  802263:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802266:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802269:	83 f8 7f             	cmp    $0x7f,%eax
  80226c:	76 07                	jbe    802275 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80226e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802275:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802278:	48 63 d0             	movslq %eax,%rdx
  80227b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227e:	48 98                	cltq   
  802280:	48 89 c1             	mov    %rax,%rcx
  802283:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80228a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802291:	48 89 ce             	mov    %rcx,%rsi
  802294:	48 89 c7             	mov    %rax,%rdi
  802297:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8022a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022a6:	48 63 d0             	movslq %eax,%rdx
  8022a9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8022b0:	48 89 d6             	mov    %rdx,%rsi
  8022b3:	48 89 c7             	mov    %rax,%rdi
  8022b6:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cb:	48 98                	cltq   
  8022cd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8022d4:	0f 82 77 ff ff ff    	jb     802251 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8022da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 08          	sub    $0x8,%rsp
  8022e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f0:	c9                   	leaveq 
  8022f1:	c3                   	retq   

00000000008022f2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
  8022f6:	48 83 ec 10          	sub    $0x10,%rsp
  8022fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802306:	48 be 70 3c 80 00 00 	movabs $0x803c70,%rsi
  80230d:	00 00 00 
  802310:	48 89 c7             	mov    %rax,%rdi
  802313:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
	return 0;
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802324:	c9                   	leaveq 
  802325:	c3                   	retq   
	...

0000000000802328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802328:	55                   	push   %rbp
  802329:	48 89 e5             	mov    %rsp,%rbp
  80232c:	53                   	push   %rbx
  80232d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802334:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80233b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802341:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802348:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80234f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802356:	84 c0                	test   %al,%al
  802358:	74 23                	je     80237d <_panic+0x55>
  80235a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802361:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802365:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802369:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80236d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802371:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802375:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802379:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80237d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802384:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80238b:	00 00 00 
  80238e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802395:	00 00 00 
  802398:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80239c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8023a3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8023aa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023b1:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8023b8:	00 00 00 
  8023bb:	48 8b 18             	mov    (%rax),%rbx
  8023be:	48 b8 ac 02 80 00 00 	movabs $0x8002ac,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8023d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8023d7:	41 89 c8             	mov    %ecx,%r8d
  8023da:	48 89 d1             	mov    %rdx,%rcx
  8023dd:	48 89 da             	mov    %rbx,%rdx
  8023e0:	89 c6                	mov    %eax,%esi
  8023e2:	48 bf 78 3c 80 00 00 	movabs $0x803c78,%rdi
  8023e9:	00 00 00 
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f1:	49 b9 63 25 80 00 00 	movabs $0x802563,%r9
  8023f8:	00 00 00 
  8023fb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023fe:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802405:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80240c:	48 89 d6             	mov    %rdx,%rsi
  80240f:	48 89 c7             	mov    %rax,%rdi
  802412:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
	cprintf("\n");
  80241e:	48 bf 9b 3c 80 00 00 	movabs $0x803c9b,%rdi
  802425:	00 00 00 
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
  80242d:	48 ba 63 25 80 00 00 	movabs $0x802563,%rdx
  802434:	00 00 00 
  802437:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802439:	cc                   	int3   
  80243a:	eb fd                	jmp    802439 <_panic+0x111>

000000000080243c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	48 83 ec 10          	sub    $0x10,%rsp
  802444:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802447:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	8b 00                	mov    (%rax),%eax
  802451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802454:	89 d6                	mov    %edx,%esi
  802456:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80245a:	48 63 d0             	movslq %eax,%rdx
  80245d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  802462:	8d 50 01             	lea    0x1(%rax),%edx
  802465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802469:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	8b 00                	mov    (%rax),%eax
  802471:	3d ff 00 00 00       	cmp    $0xff,%eax
  802476:	75 2c                	jne    8024a4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  802478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247c:	8b 00                	mov    (%rax),%eax
  80247e:	48 98                	cltq   
  802480:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802484:	48 83 c2 08          	add    $0x8,%rdx
  802488:	48 89 c6             	mov    %rax,%rsi
  80248b:	48 89 d7             	mov    %rdx,%rdi
  80248e:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
        b->idx = 0;
  80249a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8024a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a8:	8b 40 04             	mov    0x4(%rax),%eax
  8024ab:	8d 50 01             	lea    0x1(%rax),%edx
  8024ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8024b5:	c9                   	leaveq 
  8024b6:	c3                   	retq   

00000000008024b7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8024b7:	55                   	push   %rbp
  8024b8:	48 89 e5             	mov    %rsp,%rbp
  8024bb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8024c2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8024c9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8024d0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8024d7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8024de:	48 8b 0a             	mov    (%rdx),%rcx
  8024e1:	48 89 08             	mov    %rcx,(%rax)
  8024e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8024e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8024ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8024f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8024f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8024fb:	00 00 00 
    b.cnt = 0;
  8024fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802505:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802508:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80250f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802516:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80251d:	48 89 c6             	mov    %rax,%rsi
  802520:	48 bf 3c 24 80 00 00 	movabs $0x80243c,%rdi
  802527:	00 00 00 
  80252a:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802536:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80253c:	48 98                	cltq   
  80253e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802545:	48 83 c2 08          	add    $0x8,%rdx
  802549:	48 89 c6             	mov    %rax,%rsi
  80254c:	48 89 d7             	mov    %rdx,%rdi
  80254f:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  802556:	00 00 00 
  802559:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80255b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802561:	c9                   	leaveq 
  802562:	c3                   	retq   

0000000000802563 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802563:	55                   	push   %rbp
  802564:	48 89 e5             	mov    %rsp,%rbp
  802567:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80256e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802575:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80257c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802583:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80258a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802591:	84 c0                	test   %al,%al
  802593:	74 20                	je     8025b5 <cprintf+0x52>
  802595:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802599:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80259d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8025a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8025a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8025a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8025ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8025b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8025b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8025bc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8025c3:	00 00 00 
  8025c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8025cd:	00 00 00 
  8025d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8025d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8025db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8025e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8025e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8025f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8025f7:	48 8b 0a             	mov    (%rdx),%rcx
  8025fa:	48 89 08             	mov    %rcx,(%rax)
  8025fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802601:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802605:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802609:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80260d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802614:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	48 89 c7             	mov    %rax,%rdi
  802621:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  802628:	00 00 00 
  80262b:	ff d0                	callq  *%rax
  80262d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802633:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802639:	c9                   	leaveq 
  80263a:	c3                   	retq   
	...

000000000080263c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80263c:	55                   	push   %rbp
  80263d:	48 89 e5             	mov    %rsp,%rbp
  802640:	48 83 ec 30          	sub    $0x30,%rsp
  802644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80264c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802650:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  802653:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  802657:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80265b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80265e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  802662:	77 52                	ja     8026b6 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802664:	8b 45 e0             	mov    -0x20(%rbp),%eax
  802667:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80266b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80266e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802676:	ba 00 00 00 00       	mov    $0x0,%edx
  80267b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80267f:	48 89 c2             	mov    %rax,%rdx
  802682:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802685:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802688:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80268c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802690:	41 89 f9             	mov    %edi,%r9d
  802693:	48 89 c7             	mov    %rax,%rdi
  802696:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
  8026a2:	eb 1c                	jmp    8026c0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8026a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8026af:	48 89 d6             	mov    %rdx,%rsi
  8026b2:	89 c7                	mov    %eax,%edi
  8026b4:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8026b6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8026ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8026be:	7f e4                	jg     8026a4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8026c0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8026c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cc:	48 f7 f1             	div    %rcx
  8026cf:	48 89 d0             	mov    %rdx,%rax
  8026d2:	48 ba 90 3e 80 00 00 	movabs $0x803e90,%rdx
  8026d9:	00 00 00 
  8026dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8026e0:	0f be c0             	movsbl %al,%eax
  8026e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026e7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8026eb:	48 89 d6             	mov    %rdx,%rsi
  8026ee:	89 c7                	mov    %eax,%edi
  8026f0:	ff d1                	callq  *%rcx
}
  8026f2:	c9                   	leaveq 
  8026f3:	c3                   	retq   

00000000008026f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8026f4:	55                   	push   %rbp
  8026f5:	48 89 e5             	mov    %rsp,%rbp
  8026f8:	48 83 ec 20          	sub    $0x20,%rsp
  8026fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802700:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802703:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802707:	7e 52                	jle    80275b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270d:	8b 00                	mov    (%rax),%eax
  80270f:	83 f8 30             	cmp    $0x30,%eax
  802712:	73 24                	jae    802738 <getuint+0x44>
  802714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	8b 00                	mov    (%rax),%eax
  802722:	89 c0                	mov    %eax,%eax
  802724:	48 01 d0             	add    %rdx,%rax
  802727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80272b:	8b 12                	mov    (%rdx),%edx
  80272d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802734:	89 0a                	mov    %ecx,(%rdx)
  802736:	eb 17                	jmp    80274f <getuint+0x5b>
  802738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802740:	48 89 d0             	mov    %rdx,%rax
  802743:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80274b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80274f:	48 8b 00             	mov    (%rax),%rax
  802752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802756:	e9 a3 00 00 00       	jmpq   8027fe <getuint+0x10a>
	else if (lflag)
  80275b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80275f:	74 4f                	je     8027b0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802765:	8b 00                	mov    (%rax),%eax
  802767:	83 f8 30             	cmp    $0x30,%eax
  80276a:	73 24                	jae    802790 <getuint+0x9c>
  80276c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802770:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802778:	8b 00                	mov    (%rax),%eax
  80277a:	89 c0                	mov    %eax,%eax
  80277c:	48 01 d0             	add    %rdx,%rax
  80277f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802783:	8b 12                	mov    (%rdx),%edx
  802785:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802788:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80278c:	89 0a                	mov    %ecx,(%rdx)
  80278e:	eb 17                	jmp    8027a7 <getuint+0xb3>
  802790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802794:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802798:	48 89 d0             	mov    %rdx,%rax
  80279b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80279f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8027a7:	48 8b 00             	mov    (%rax),%rax
  8027aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8027ae:	eb 4e                	jmp    8027fe <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8027b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b4:	8b 00                	mov    (%rax),%eax
  8027b6:	83 f8 30             	cmp    $0x30,%eax
  8027b9:	73 24                	jae    8027df <getuint+0xeb>
  8027bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8027c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c7:	8b 00                	mov    (%rax),%eax
  8027c9:	89 c0                	mov    %eax,%eax
  8027cb:	48 01 d0             	add    %rdx,%rax
  8027ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027d2:	8b 12                	mov    (%rdx),%edx
  8027d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8027d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027db:	89 0a                	mov    %ecx,(%rdx)
  8027dd:	eb 17                	jmp    8027f6 <getuint+0x102>
  8027df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8027e7:	48 89 d0             	mov    %rdx,%rax
  8027ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8027ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8027f6:	8b 00                	mov    (%rax),%eax
  8027f8:	89 c0                	mov    %eax,%eax
  8027fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8027fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802802:	c9                   	leaveq 
  802803:	c3                   	retq   

0000000000802804 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802804:	55                   	push   %rbp
  802805:	48 89 e5             	mov    %rsp,%rbp
  802808:	48 83 ec 20          	sub    $0x20,%rsp
  80280c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802810:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802813:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802817:	7e 52                	jle    80286b <getint+0x67>
		x=va_arg(*ap, long long);
  802819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281d:	8b 00                	mov    (%rax),%eax
  80281f:	83 f8 30             	cmp    $0x30,%eax
  802822:	73 24                	jae    802848 <getint+0x44>
  802824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802828:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80282c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802830:	8b 00                	mov    (%rax),%eax
  802832:	89 c0                	mov    %eax,%eax
  802834:	48 01 d0             	add    %rdx,%rax
  802837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80283b:	8b 12                	mov    (%rdx),%edx
  80283d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802844:	89 0a                	mov    %ecx,(%rdx)
  802846:	eb 17                	jmp    80285f <getint+0x5b>
  802848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802850:	48 89 d0             	mov    %rdx,%rax
  802853:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80285b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80285f:	48 8b 00             	mov    (%rax),%rax
  802862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802866:	e9 a3 00 00 00       	jmpq   80290e <getint+0x10a>
	else if (lflag)
  80286b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80286f:	74 4f                	je     8028c0 <getint+0xbc>
		x=va_arg(*ap, long);
  802871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802875:	8b 00                	mov    (%rax),%eax
  802877:	83 f8 30             	cmp    $0x30,%eax
  80287a:	73 24                	jae    8028a0 <getint+0x9c>
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	8b 00                	mov    (%rax),%eax
  80288a:	89 c0                	mov    %eax,%eax
  80288c:	48 01 d0             	add    %rdx,%rax
  80288f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802893:	8b 12                	mov    (%rdx),%edx
  802895:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80289c:	89 0a                	mov    %ecx,(%rdx)
  80289e:	eb 17                	jmp    8028b7 <getint+0xb3>
  8028a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028a8:	48 89 d0             	mov    %rdx,%rax
  8028ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028b7:	48 8b 00             	mov    (%rax),%rax
  8028ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8028be:	eb 4e                	jmp    80290e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	8b 00                	mov    (%rax),%eax
  8028c6:	83 f8 30             	cmp    $0x30,%eax
  8028c9:	73 24                	jae    8028ef <getint+0xeb>
  8028cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d7:	8b 00                	mov    (%rax),%eax
  8028d9:	89 c0                	mov    %eax,%eax
  8028db:	48 01 d0             	add    %rdx,%rax
  8028de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e2:	8b 12                	mov    (%rdx),%edx
  8028e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028eb:	89 0a                	mov    %ecx,(%rdx)
  8028ed:	eb 17                	jmp    802906 <getint+0x102>
  8028ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028f7:	48 89 d0             	mov    %rdx,%rax
  8028fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802902:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802906:	8b 00                	mov    (%rax),%eax
  802908:	48 98                	cltq   
  80290a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80290e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802912:	c9                   	leaveq 
  802913:	c3                   	retq   

0000000000802914 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802914:	55                   	push   %rbp
  802915:	48 89 e5             	mov    %rsp,%rbp
  802918:	41 54                	push   %r12
  80291a:	53                   	push   %rbx
  80291b:	48 83 ec 60          	sub    $0x60,%rsp
  80291f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802923:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802927:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80292b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80292f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802933:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802937:	48 8b 0a             	mov    (%rdx),%rcx
  80293a:	48 89 08             	mov    %rcx,(%rax)
  80293d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802941:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802945:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802949:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80294d:	eb 17                	jmp    802966 <vprintfmt+0x52>
			if (ch == '\0')
  80294f:	85 db                	test   %ebx,%ebx
  802951:	0f 84 ea 04 00 00    	je     802e41 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  802957:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80295b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80295f:	48 89 c6             	mov    %rax,%rsi
  802962:	89 df                	mov    %ebx,%edi
  802964:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802966:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80296a:	0f b6 00             	movzbl (%rax),%eax
  80296d:	0f b6 d8             	movzbl %al,%ebx
  802970:	83 fb 25             	cmp    $0x25,%ebx
  802973:	0f 95 c0             	setne  %al
  802976:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80297b:	84 c0                	test   %al,%al
  80297d:	75 d0                	jne    80294f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80297f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802983:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80298a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802991:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802998:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80299f:	eb 04                	jmp    8029a5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8029a1:	90                   	nop
  8029a2:	eb 01                	jmp    8029a5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8029a4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8029a5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8029a9:	0f b6 00             	movzbl (%rax),%eax
  8029ac:	0f b6 d8             	movzbl %al,%ebx
  8029af:	89 d8                	mov    %ebx,%eax
  8029b1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8029b6:	83 e8 23             	sub    $0x23,%eax
  8029b9:	83 f8 55             	cmp    $0x55,%eax
  8029bc:	0f 87 4b 04 00 00    	ja     802e0d <vprintfmt+0x4f9>
  8029c2:	89 c0                	mov    %eax,%eax
  8029c4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8029cb:	00 
  8029cc:	48 b8 b8 3e 80 00 00 	movabs $0x803eb8,%rax
  8029d3:	00 00 00 
  8029d6:	48 01 d0             	add    %rdx,%rax
  8029d9:	48 8b 00             	mov    (%rax),%rax
  8029dc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8029de:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8029e2:	eb c1                	jmp    8029a5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8029e4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8029e8:	eb bb                	jmp    8029a5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8029ea:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8029f1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8029f4:	89 d0                	mov    %edx,%eax
  8029f6:	c1 e0 02             	shl    $0x2,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	01 c0                	add    %eax,%eax
  8029fd:	01 d8                	add    %ebx,%eax
  8029ff:	83 e8 30             	sub    $0x30,%eax
  802a02:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802a05:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a09:	0f b6 00             	movzbl (%rax),%eax
  802a0c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802a0f:	83 fb 2f             	cmp    $0x2f,%ebx
  802a12:	7e 63                	jle    802a77 <vprintfmt+0x163>
  802a14:	83 fb 39             	cmp    $0x39,%ebx
  802a17:	7f 5e                	jg     802a77 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802a19:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802a1e:	eb d1                	jmp    8029f1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  802a20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a23:	83 f8 30             	cmp    $0x30,%eax
  802a26:	73 17                	jae    802a3f <vprintfmt+0x12b>
  802a28:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a2f:	89 c0                	mov    %eax,%eax
  802a31:	48 01 d0             	add    %rdx,%rax
  802a34:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802a37:	83 c2 08             	add    $0x8,%edx
  802a3a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802a3d:	eb 0f                	jmp    802a4e <vprintfmt+0x13a>
  802a3f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802a43:	48 89 d0             	mov    %rdx,%rax
  802a46:	48 83 c2 08          	add    $0x8,%rdx
  802a4a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802a4e:	8b 00                	mov    (%rax),%eax
  802a50:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802a53:	eb 23                	jmp    802a78 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  802a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802a59:	0f 89 42 ff ff ff    	jns    8029a1 <vprintfmt+0x8d>
				width = 0;
  802a5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802a66:	e9 36 ff ff ff       	jmpq   8029a1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  802a6b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802a72:	e9 2e ff ff ff       	jmpq   8029a5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802a77:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802a78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802a7c:	0f 89 22 ff ff ff    	jns    8029a4 <vprintfmt+0x90>
				width = precision, precision = -1;
  802a82:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802a85:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802a88:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802a8f:	e9 10 ff ff ff       	jmpq   8029a4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802a94:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802a98:	e9 08 ff ff ff       	jmpq   8029a5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802aa0:	83 f8 30             	cmp    $0x30,%eax
  802aa3:	73 17                	jae    802abc <vprintfmt+0x1a8>
  802aa5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802aac:	89 c0                	mov    %eax,%eax
  802aae:	48 01 d0             	add    %rdx,%rax
  802ab1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ab4:	83 c2 08             	add    $0x8,%edx
  802ab7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802aba:	eb 0f                	jmp    802acb <vprintfmt+0x1b7>
  802abc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ac0:	48 89 d0             	mov    %rdx,%rax
  802ac3:	48 83 c2 08          	add    $0x8,%rdx
  802ac7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802acb:	8b 00                	mov    (%rax),%eax
  802acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ad1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802ad5:	48 89 d6             	mov    %rdx,%rsi
  802ad8:	89 c7                	mov    %eax,%edi
  802ada:	ff d1                	callq  *%rcx
			break;
  802adc:	e9 5a 03 00 00       	jmpq   802e3b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ae4:	83 f8 30             	cmp    $0x30,%eax
  802ae7:	73 17                	jae    802b00 <vprintfmt+0x1ec>
  802ae9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802af0:	89 c0                	mov    %eax,%eax
  802af2:	48 01 d0             	add    %rdx,%rax
  802af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802af8:	83 c2 08             	add    $0x8,%edx
  802afb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802afe:	eb 0f                	jmp    802b0f <vprintfmt+0x1fb>
  802b00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b04:	48 89 d0             	mov    %rdx,%rax
  802b07:	48 83 c2 08          	add    $0x8,%rdx
  802b0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802b0f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802b11:	85 db                	test   %ebx,%ebx
  802b13:	79 02                	jns    802b17 <vprintfmt+0x203>
				err = -err;
  802b15:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802b17:	83 fb 15             	cmp    $0x15,%ebx
  802b1a:	7f 16                	jg     802b32 <vprintfmt+0x21e>
  802b1c:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  802b23:	00 00 00 
  802b26:	48 63 d3             	movslq %ebx,%rdx
  802b29:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802b2d:	4d 85 e4             	test   %r12,%r12
  802b30:	75 2e                	jne    802b60 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  802b32:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802b3a:	89 d9                	mov    %ebx,%ecx
  802b3c:	48 ba a1 3e 80 00 00 	movabs $0x803ea1,%rdx
  802b43:	00 00 00 
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4e:	49 b8 4b 2e 80 00 00 	movabs $0x802e4b,%r8
  802b55:	00 00 00 
  802b58:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802b5b:	e9 db 02 00 00       	jmpq   802e3b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802b60:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802b64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802b68:	4c 89 e1             	mov    %r12,%rcx
  802b6b:	48 ba aa 3e 80 00 00 	movabs $0x803eaa,%rdx
  802b72:	00 00 00 
  802b75:	48 89 c7             	mov    %rax,%rdi
  802b78:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7d:	49 b8 4b 2e 80 00 00 	movabs $0x802e4b,%r8
  802b84:	00 00 00 
  802b87:	41 ff d0             	callq  *%r8
			break;
  802b8a:	e9 ac 02 00 00       	jmpq   802e3b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802b8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b92:	83 f8 30             	cmp    $0x30,%eax
  802b95:	73 17                	jae    802bae <vprintfmt+0x29a>
  802b97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b9e:	89 c0                	mov    %eax,%eax
  802ba0:	48 01 d0             	add    %rdx,%rax
  802ba3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ba6:	83 c2 08             	add    $0x8,%edx
  802ba9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802bac:	eb 0f                	jmp    802bbd <vprintfmt+0x2a9>
  802bae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802bb2:	48 89 d0             	mov    %rdx,%rax
  802bb5:	48 83 c2 08          	add    $0x8,%rdx
  802bb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802bbd:	4c 8b 20             	mov    (%rax),%r12
  802bc0:	4d 85 e4             	test   %r12,%r12
  802bc3:	75 0a                	jne    802bcf <vprintfmt+0x2bb>
				p = "(null)";
  802bc5:	49 bc ad 3e 80 00 00 	movabs $0x803ead,%r12
  802bcc:	00 00 00 
			if (width > 0 && padc != '-')
  802bcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bd3:	7e 7a                	jle    802c4f <vprintfmt+0x33b>
  802bd5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802bd9:	74 74                	je     802c4f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  802bdb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802bde:	48 98                	cltq   
  802be0:	48 89 c6             	mov    %rax,%rsi
  802be3:	4c 89 e7             	mov    %r12,%rdi
  802be6:	48 b8 f6 30 80 00 00 	movabs $0x8030f6,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
  802bf2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802bf5:	eb 17                	jmp    802c0e <vprintfmt+0x2fa>
					putch(padc, putdat);
  802bf7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  802bfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802bff:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  802c03:	48 89 d6             	mov    %rdx,%rsi
  802c06:	89 c7                	mov    %eax,%edi
  802c08:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802c12:	7f e3                	jg     802bf7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802c14:	eb 39                	jmp    802c4f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  802c16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802c1a:	74 1e                	je     802c3a <vprintfmt+0x326>
  802c1c:	83 fb 1f             	cmp    $0x1f,%ebx
  802c1f:	7e 05                	jle    802c26 <vprintfmt+0x312>
  802c21:	83 fb 7e             	cmp    $0x7e,%ebx
  802c24:	7e 14                	jle    802c3a <vprintfmt+0x326>
					putch('?', putdat);
  802c26:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802c2a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802c2e:	48 89 c6             	mov    %rax,%rsi
  802c31:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802c36:	ff d2                	callq  *%rdx
  802c38:	eb 0f                	jmp    802c49 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  802c3a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802c3e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	89 df                	mov    %ebx,%edi
  802c47:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802c49:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802c4d:	eb 01                	jmp    802c50 <vprintfmt+0x33c>
  802c4f:	90                   	nop
  802c50:	41 0f b6 04 24       	movzbl (%r12),%eax
  802c55:	0f be d8             	movsbl %al,%ebx
  802c58:	85 db                	test   %ebx,%ebx
  802c5a:	0f 95 c0             	setne  %al
  802c5d:	49 83 c4 01          	add    $0x1,%r12
  802c61:	84 c0                	test   %al,%al
  802c63:	74 28                	je     802c8d <vprintfmt+0x379>
  802c65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802c69:	78 ab                	js     802c16 <vprintfmt+0x302>
  802c6b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802c6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802c73:	79 a1                	jns    802c16 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802c75:	eb 16                	jmp    802c8d <vprintfmt+0x379>
				putch(' ', putdat);
  802c77:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802c7b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802c7f:	48 89 c6             	mov    %rax,%rsi
  802c82:	bf 20 00 00 00       	mov    $0x20,%edi
  802c87:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802c89:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802c8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802c91:	7f e4                	jg     802c77 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  802c93:	e9 a3 01 00 00       	jmpq   802e3b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802c98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802c9c:	be 03 00 00 00       	mov    $0x3,%esi
  802ca1:	48 89 c7             	mov    %rax,%rdi
  802ca4:	48 b8 04 28 80 00 00 	movabs $0x802804,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	callq  *%rax
  802cb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb8:	48 85 c0             	test   %rax,%rax
  802cbb:	79 1d                	jns    802cda <vprintfmt+0x3c6>
				putch('-', putdat);
  802cbd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802cc1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802cc5:	48 89 c6             	mov    %rax,%rsi
  802cc8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802ccd:	ff d2                	callq  *%rdx
				num = -(long long) num;
  802ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd3:	48 f7 d8             	neg    %rax
  802cd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802cda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802ce1:	e9 e8 00 00 00       	jmpq   802dce <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802ce6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802cea:	be 03 00 00 00       	mov    $0x3,%esi
  802cef:	48 89 c7             	mov    %rax,%rdi
  802cf2:	48 b8 f4 26 80 00 00 	movabs $0x8026f4,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
  802cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802d02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802d09:	e9 c0 00 00 00       	jmpq   802dce <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802d0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d16:	48 89 c6             	mov    %rax,%rsi
  802d19:	bf 58 00 00 00       	mov    $0x58,%edi
  802d1e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  802d20:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d24:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d28:	48 89 c6             	mov    %rax,%rsi
  802d2b:	bf 58 00 00 00       	mov    $0x58,%edi
  802d30:	ff d2                	callq  *%rdx
			putch('X', putdat);
  802d32:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d36:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d3a:	48 89 c6             	mov    %rax,%rsi
  802d3d:	bf 58 00 00 00       	mov    $0x58,%edi
  802d42:	ff d2                	callq  *%rdx
			break;
  802d44:	e9 f2 00 00 00       	jmpq   802e3b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  802d49:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d4d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d51:	48 89 c6             	mov    %rax,%rsi
  802d54:	bf 30 00 00 00       	mov    $0x30,%edi
  802d59:	ff d2                	callq  *%rdx
			putch('x', putdat);
  802d5b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802d5f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802d63:	48 89 c6             	mov    %rax,%rsi
  802d66:	bf 78 00 00 00       	mov    $0x78,%edi
  802d6b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d70:	83 f8 30             	cmp    $0x30,%eax
  802d73:	73 17                	jae    802d8c <vprintfmt+0x478>
  802d75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d7c:	89 c0                	mov    %eax,%eax
  802d7e:	48 01 d0             	add    %rdx,%rax
  802d81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d84:	83 c2 08             	add    $0x8,%edx
  802d87:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802d8a:	eb 0f                	jmp    802d9b <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  802d8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d90:	48 89 d0             	mov    %rdx,%rax
  802d93:	48 83 c2 08          	add    $0x8,%rdx
  802d97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d9b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802d9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802da2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802da9:	eb 23                	jmp    802dce <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802dab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802daf:	be 03 00 00 00       	mov    $0x3,%esi
  802db4:	48 89 c7             	mov    %rax,%rdi
  802db7:	48 b8 f4 26 80 00 00 	movabs $0x8026f4,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
  802dc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802dc7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802dce:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802dd3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802dd6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802dd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ddd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802de5:	45 89 c1             	mov    %r8d,%r9d
  802de8:	41 89 f8             	mov    %edi,%r8d
  802deb:	48 89 c7             	mov    %rax,%rdi
  802dee:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
			break;
  802dfa:	eb 3f                	jmp    802e3b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802dfc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e00:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e04:	48 89 c6             	mov    %rax,%rsi
  802e07:	89 df                	mov    %ebx,%edi
  802e09:	ff d2                	callq  *%rdx
			break;
  802e0b:	eb 2e                	jmp    802e3b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802e0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802e11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802e15:	48 89 c6             	mov    %rax,%rsi
  802e18:	bf 25 00 00 00       	mov    $0x25,%edi
  802e1d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  802e1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802e24:	eb 05                	jmp    802e2b <vprintfmt+0x517>
  802e26:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802e2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802e2f:	48 83 e8 01          	sub    $0x1,%rax
  802e33:	0f b6 00             	movzbl (%rax),%eax
  802e36:	3c 25                	cmp    $0x25,%al
  802e38:	75 ec                	jne    802e26 <vprintfmt+0x512>
				/* do nothing */;
			break;
  802e3a:	90                   	nop
		}
	}
  802e3b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802e3c:	e9 25 fb ff ff       	jmpq   802966 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  802e41:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802e42:	48 83 c4 60          	add    $0x60,%rsp
  802e46:	5b                   	pop    %rbx
  802e47:	41 5c                	pop    %r12
  802e49:	5d                   	pop    %rbp
  802e4a:	c3                   	retq   

0000000000802e4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802e56:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802e5d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802e64:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e6b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e72:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e79:	84 c0                	test   %al,%al
  802e7b:	74 20                	je     802e9d <printfmt+0x52>
  802e7d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e81:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e85:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e89:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e8d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e91:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e95:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e99:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e9d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802ea4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802eab:	00 00 00 
  802eae:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802eb5:	00 00 00 
  802eb8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ebc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802ec3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802eca:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802ed1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802ed8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802edf:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802ee6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802eed:	48 89 c7             	mov    %rax,%rdi
  802ef0:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
	va_end(ap);
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	48 83 ec 10          	sub    $0x10,%rsp
  802f06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f11:	8b 40 10             	mov    0x10(%rax),%eax
  802f14:	8d 50 01             	lea    0x1(%rax),%edx
  802f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f22:	48 8b 10             	mov    (%rax),%rdx
  802f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f29:	48 8b 40 08          	mov    0x8(%rax),%rax
  802f2d:	48 39 c2             	cmp    %rax,%rdx
  802f30:	73 17                	jae    802f49 <sprintputch+0x4b>
		*b->buf++ = ch;
  802f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f36:	48 8b 00             	mov    (%rax),%rax
  802f39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f3c:	88 10                	mov    %dl,(%rax)
  802f3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f46:	48 89 10             	mov    %rdx,(%rax)
}
  802f49:	c9                   	leaveq 
  802f4a:	c3                   	retq   

0000000000802f4b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802f4b:	55                   	push   %rbp
  802f4c:	48 89 e5             	mov    %rsp,%rbp
  802f4f:	48 83 ec 50          	sub    $0x50,%rsp
  802f53:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802f57:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802f5a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802f5e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802f62:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f66:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802f6a:	48 8b 0a             	mov    (%rdx),%rcx
  802f6d:	48 89 08             	mov    %rcx,(%rax)
  802f70:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802f74:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802f78:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802f7c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802f80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f84:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802f88:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802f8b:	48 98                	cltq   
  802f8d:	48 83 e8 01          	sub    $0x1,%rax
  802f91:	48 03 45 c8          	add    -0x38(%rbp),%rax
  802f95:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802f99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802fa0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802fa5:	74 06                	je     802fad <vsnprintf+0x62>
  802fa7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802fab:	7f 07                	jg     802fb4 <vsnprintf+0x69>
		return -E_INVAL;
  802fad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fb2:	eb 2f                	jmp    802fe3 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802fb4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802fb8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802fbc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fc0:	48 89 c6             	mov    %rax,%rsi
  802fc3:	48 bf fe 2e 80 00 00 	movabs $0x802efe,%rdi
  802fca:	00 00 00 
  802fcd:	48 b8 14 29 80 00 00 	movabs $0x802914,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802fd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fdd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802fe0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802fe3:	c9                   	leaveq 
  802fe4:	c3                   	retq   

0000000000802fe5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802fe5:	55                   	push   %rbp
  802fe6:	48 89 e5             	mov    %rsp,%rbp
  802fe9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ff0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ff7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802ffd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803004:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80300b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803012:	84 c0                	test   %al,%al
  803014:	74 20                	je     803036 <snprintf+0x51>
  803016:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80301a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80301e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803022:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803026:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80302a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80302e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803032:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803036:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80303d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803044:	00 00 00 
  803047:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80304e:	00 00 00 
  803051:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803055:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80305c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803063:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80306a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803071:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803078:	48 8b 0a             	mov    (%rdx),%rcx
  80307b:	48 89 08             	mov    %rcx,(%rax)
  80307e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803082:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803086:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80308a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80308e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803095:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80309c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8030a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8030a9:	48 89 c7             	mov    %rax,%rdi
  8030ac:	48 b8 4b 2f 80 00 00 	movabs $0x802f4b,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8030be:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030c4:	c9                   	leaveq 
  8030c5:	c3                   	retq   
	...

00000000008030c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8030c8:	55                   	push   %rbp
  8030c9:	48 89 e5             	mov    %rsp,%rbp
  8030cc:	48 83 ec 18          	sub    $0x18,%rsp
  8030d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8030d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030db:	eb 09                	jmp    8030e6 <strlen+0x1e>
		n++;
  8030dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8030e1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8030e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ea:	0f b6 00             	movzbl (%rax),%eax
  8030ed:	84 c0                	test   %al,%al
  8030ef:	75 ec                	jne    8030dd <strlen+0x15>
		n++;
	return n;
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030f4:	c9                   	leaveq 
  8030f5:	c3                   	retq   

00000000008030f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8030f6:	55                   	push   %rbp
  8030f7:	48 89 e5             	mov    %rsp,%rbp
  8030fa:	48 83 ec 20          	sub    $0x20,%rsp
  8030fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803102:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80310d:	eb 0e                	jmp    80311d <strnlen+0x27>
		n++;
  80310f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803113:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803118:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80311d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803122:	74 0b                	je     80312f <strnlen+0x39>
  803124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803128:	0f b6 00             	movzbl (%rax),%eax
  80312b:	84 c0                	test   %al,%al
  80312d:	75 e0                	jne    80310f <strnlen+0x19>
		n++;
	return n;
  80312f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803132:	c9                   	leaveq 
  803133:	c3                   	retq   

0000000000803134 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803134:	55                   	push   %rbp
  803135:	48 89 e5             	mov    %rsp,%rbp
  803138:	48 83 ec 20          	sub    $0x20,%rsp
  80313c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803140:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803148:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80314c:	90                   	nop
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	0f b6 10             	movzbl (%rax),%edx
  803154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803158:	88 10                	mov    %dl,(%rax)
  80315a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315e:	0f b6 00             	movzbl (%rax),%eax
  803161:	84 c0                	test   %al,%al
  803163:	0f 95 c0             	setne  %al
  803166:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80316b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803170:	84 c0                	test   %al,%al
  803172:	75 d9                	jne    80314d <strcpy+0x19>
		/* do nothing */;
	return ret;
  803174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803178:	c9                   	leaveq 
  803179:	c3                   	retq   

000000000080317a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80317a:	55                   	push   %rbp
  80317b:	48 89 e5             	mov    %rsp,%rbp
  80317e:	48 83 ec 20          	sub    $0x20,%rsp
  803182:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803186:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80318a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318e:	48 89 c7             	mov    %rax,%rdi
  803191:	48 b8 c8 30 80 00 00 	movabs $0x8030c8,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
  80319d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a3:	48 98                	cltq   
  8031a5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8031a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031ad:	48 89 d6             	mov    %rdx,%rsi
  8031b0:	48 89 c7             	mov    %rax,%rdi
  8031b3:	48 b8 34 31 80 00 00 	movabs $0x803134,%rax
  8031ba:	00 00 00 
  8031bd:	ff d0                	callq  *%rax
	return dst;
  8031bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 28          	sub    $0x28,%rsp
  8031cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8031d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8031e1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031e8:	00 
  8031e9:	eb 27                	jmp    803212 <strncpy+0x4d>
		*dst++ = *src;
  8031eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ef:	0f b6 10             	movzbl (%rax),%edx
  8031f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f6:	88 10                	mov    %dl,(%rax)
  8031f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8031fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803201:	0f b6 00             	movzbl (%rax),%eax
  803204:	84 c0                	test   %al,%al
  803206:	74 05                	je     80320d <strncpy+0x48>
			src++;
  803208:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80320d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803216:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80321a:	72 cf                	jb     8031eb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80321c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803220:	c9                   	leaveq 
  803221:	c3                   	retq   

0000000000803222 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803222:	55                   	push   %rbp
  803223:	48 89 e5             	mov    %rsp,%rbp
  803226:	48 83 ec 28          	sub    $0x28,%rsp
  80322a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80322e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803232:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  803236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80323e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803243:	74 37                	je     80327c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  803245:	eb 17                	jmp    80325e <strlcpy+0x3c>
			*dst++ = *src++;
  803247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80324b:	0f b6 10             	movzbl (%rax),%edx
  80324e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803252:	88 10                	mov    %dl,(%rax)
  803254:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803259:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80325e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803263:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803268:	74 0b                	je     803275 <strlcpy+0x53>
  80326a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80326e:	0f b6 00             	movzbl (%rax),%eax
  803271:	84 c0                	test   %al,%al
  803273:	75 d2                	jne    803247 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803279:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80327c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803284:	48 89 d1             	mov    %rdx,%rcx
  803287:	48 29 c1             	sub    %rax,%rcx
  80328a:	48 89 c8             	mov    %rcx,%rax
}
  80328d:	c9                   	leaveq 
  80328e:	c3                   	retq   

000000000080328f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80328f:	55                   	push   %rbp
  803290:	48 89 e5             	mov    %rsp,%rbp
  803293:	48 83 ec 10          	sub    $0x10,%rsp
  803297:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80329b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80329f:	eb 0a                	jmp    8032ab <strcmp+0x1c>
		p++, q++;
  8032a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8032ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032af:	0f b6 00             	movzbl (%rax),%eax
  8032b2:	84 c0                	test   %al,%al
  8032b4:	74 12                	je     8032c8 <strcmp+0x39>
  8032b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ba:	0f b6 10             	movzbl (%rax),%edx
  8032bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c1:	0f b6 00             	movzbl (%rax),%eax
  8032c4:	38 c2                	cmp    %al,%dl
  8032c6:	74 d9                	je     8032a1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8032c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032cc:	0f b6 00             	movzbl (%rax),%eax
  8032cf:	0f b6 d0             	movzbl %al,%edx
  8032d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d6:	0f b6 00             	movzbl (%rax),%eax
  8032d9:	0f b6 c0             	movzbl %al,%eax
  8032dc:	89 d1                	mov    %edx,%ecx
  8032de:	29 c1                	sub    %eax,%ecx
  8032e0:	89 c8                	mov    %ecx,%eax
}
  8032e2:	c9                   	leaveq 
  8032e3:	c3                   	retq   

00000000008032e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8032e4:	55                   	push   %rbp
  8032e5:	48 89 e5             	mov    %rsp,%rbp
  8032e8:	48 83 ec 18          	sub    $0x18,%rsp
  8032ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8032f8:	eb 0f                	jmp    803309 <strncmp+0x25>
		n--, p++, q++;
  8032fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8032ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803304:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803309:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80330e:	74 1d                	je     80332d <strncmp+0x49>
  803310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803314:	0f b6 00             	movzbl (%rax),%eax
  803317:	84 c0                	test   %al,%al
  803319:	74 12                	je     80332d <strncmp+0x49>
  80331b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80331f:	0f b6 10             	movzbl (%rax),%edx
  803322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803326:	0f b6 00             	movzbl (%rax),%eax
  803329:	38 c2                	cmp    %al,%dl
  80332b:	74 cd                	je     8032fa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80332d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803332:	75 07                	jne    80333b <strncmp+0x57>
		return 0;
  803334:	b8 00 00 00 00       	mov    $0x0,%eax
  803339:	eb 1a                	jmp    803355 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80333b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333f:	0f b6 00             	movzbl (%rax),%eax
  803342:	0f b6 d0             	movzbl %al,%edx
  803345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803349:	0f b6 00             	movzbl (%rax),%eax
  80334c:	0f b6 c0             	movzbl %al,%eax
  80334f:	89 d1                	mov    %edx,%ecx
  803351:	29 c1                	sub    %eax,%ecx
  803353:	89 c8                	mov    %ecx,%eax
}
  803355:	c9                   	leaveq 
  803356:	c3                   	retq   

0000000000803357 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 10          	sub    $0x10,%rsp
  80335f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803363:	89 f0                	mov    %esi,%eax
  803365:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803368:	eb 17                	jmp    803381 <strchr+0x2a>
		if (*s == c)
  80336a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336e:	0f b6 00             	movzbl (%rax),%eax
  803371:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803374:	75 06                	jne    80337c <strchr+0x25>
			return (char *) s;
  803376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337a:	eb 15                	jmp    803391 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80337c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803385:	0f b6 00             	movzbl (%rax),%eax
  803388:	84 c0                	test   %al,%al
  80338a:	75 de                	jne    80336a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80338c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803391:	c9                   	leaveq 
  803392:	c3                   	retq   

0000000000803393 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
  803397:	48 83 ec 10          	sub    $0x10,%rsp
  80339b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80339f:	89 f0                	mov    %esi,%eax
  8033a1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8033a4:	eb 11                	jmp    8033b7 <strfind+0x24>
		if (*s == c)
  8033a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033aa:	0f b6 00             	movzbl (%rax),%eax
  8033ad:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8033b0:	74 12                	je     8033c4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8033b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bb:	0f b6 00             	movzbl (%rax),%eax
  8033be:	84 c0                	test   %al,%al
  8033c0:	75 e4                	jne    8033a6 <strfind+0x13>
  8033c2:	eb 01                	jmp    8033c5 <strfind+0x32>
		if (*s == c)
			break;
  8033c4:	90                   	nop
	return (char *) s;
  8033c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033c9:	c9                   	leaveq 
  8033ca:	c3                   	retq   

00000000008033cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8033cb:	55                   	push   %rbp
  8033cc:	48 89 e5             	mov    %rsp,%rbp
  8033cf:	48 83 ec 18          	sub    $0x18,%rsp
  8033d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033d7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8033da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8033de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033e3:	75 06                	jne    8033eb <memset+0x20>
		return v;
  8033e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e9:	eb 69                	jmp    803454 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8033eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ef:	83 e0 03             	and    $0x3,%eax
  8033f2:	48 85 c0             	test   %rax,%rax
  8033f5:	75 48                	jne    80343f <memset+0x74>
  8033f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fb:	83 e0 03             	and    $0x3,%eax
  8033fe:	48 85 c0             	test   %rax,%rax
  803401:	75 3c                	jne    80343f <memset+0x74>
		c &= 0xFF;
  803403:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80340a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80340d:	89 c2                	mov    %eax,%edx
  80340f:	c1 e2 18             	shl    $0x18,%edx
  803412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803415:	c1 e0 10             	shl    $0x10,%eax
  803418:	09 c2                	or     %eax,%edx
  80341a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80341d:	c1 e0 08             	shl    $0x8,%eax
  803420:	09 d0                	or     %edx,%eax
  803422:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  803425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803429:	48 89 c1             	mov    %rax,%rcx
  80342c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803430:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803434:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803437:	48 89 d7             	mov    %rdx,%rdi
  80343a:	fc                   	cld    
  80343b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80343d:	eb 11                	jmp    803450 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80343f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803443:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803446:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80344a:	48 89 d7             	mov    %rdx,%rdi
  80344d:	fc                   	cld    
  80344e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  803450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803454:	c9                   	leaveq 
  803455:	c3                   	retq   

0000000000803456 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  803456:	55                   	push   %rbp
  803457:	48 89 e5             	mov    %rsp,%rbp
  80345a:	48 83 ec 28          	sub    $0x28,%rsp
  80345e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803462:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803466:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80346a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803476:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80347a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80347e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803482:	0f 83 88 00 00 00    	jae    803510 <memmove+0xba>
  803488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80348c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803490:	48 01 d0             	add    %rdx,%rax
  803493:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803497:	76 77                	jbe    803510 <memmove+0xba>
		s += n;
  803499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8034a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8034a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ad:	83 e0 03             	and    $0x3,%eax
  8034b0:	48 85 c0             	test   %rax,%rax
  8034b3:	75 3b                	jne    8034f0 <memmove+0x9a>
  8034b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b9:	83 e0 03             	and    $0x3,%eax
  8034bc:	48 85 c0             	test   %rax,%rax
  8034bf:	75 2f                	jne    8034f0 <memmove+0x9a>
  8034c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c5:	83 e0 03             	and    $0x3,%eax
  8034c8:	48 85 c0             	test   %rax,%rax
  8034cb:	75 23                	jne    8034f0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8034cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d1:	48 83 e8 04          	sub    $0x4,%rax
  8034d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034d9:	48 83 ea 04          	sub    $0x4,%rdx
  8034dd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8034e1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8034e5:	48 89 c7             	mov    %rax,%rdi
  8034e8:	48 89 d6             	mov    %rdx,%rsi
  8034eb:	fd                   	std    
  8034ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8034ee:	eb 1d                	jmp    80350d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8034f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8034f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803504:	48 89 d7             	mov    %rdx,%rdi
  803507:	48 89 c1             	mov    %rax,%rcx
  80350a:	fd                   	std    
  80350b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80350d:	fc                   	cld    
  80350e:	eb 57                	jmp    803567 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803514:	83 e0 03             	and    $0x3,%eax
  803517:	48 85 c0             	test   %rax,%rax
  80351a:	75 36                	jne    803552 <memmove+0xfc>
  80351c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803520:	83 e0 03             	and    $0x3,%eax
  803523:	48 85 c0             	test   %rax,%rax
  803526:	75 2a                	jne    803552 <memmove+0xfc>
  803528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80352c:	83 e0 03             	and    $0x3,%eax
  80352f:	48 85 c0             	test   %rax,%rax
  803532:	75 1e                	jne    803552 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803538:	48 89 c1             	mov    %rax,%rcx
  80353b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80353f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803543:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803547:	48 89 c7             	mov    %rax,%rdi
  80354a:	48 89 d6             	mov    %rdx,%rsi
  80354d:	fc                   	cld    
  80354e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803550:	eb 15                	jmp    803567 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803556:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80355a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80355e:	48 89 c7             	mov    %rax,%rdi
  803561:	48 89 d6             	mov    %rdx,%rsi
  803564:	fc                   	cld    
  803565:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80356b:	c9                   	leaveq 
  80356c:	c3                   	retq   

000000000080356d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80356d:	55                   	push   %rbp
  80356e:	48 89 e5             	mov    %rsp,%rbp
  803571:	48 83 ec 18          	sub    $0x18,%rsp
  803575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803579:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80357d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803581:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803585:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358d:	48 89 ce             	mov    %rcx,%rsi
  803590:	48 89 c7             	mov    %rax,%rdi
  803593:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  80359a:	00 00 00 
  80359d:	ff d0                	callq  *%rax
}
  80359f:	c9                   	leaveq 
  8035a0:	c3                   	retq   

00000000008035a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8035a1:	55                   	push   %rbp
  8035a2:	48 89 e5             	mov    %rsp,%rbp
  8035a5:	48 83 ec 28          	sub    $0x28,%rsp
  8035a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8035b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8035bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8035c5:	eb 38                	jmp    8035ff <memcmp+0x5e>
		if (*s1 != *s2)
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	0f b6 10             	movzbl (%rax),%edx
  8035ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d2:	0f b6 00             	movzbl (%rax),%eax
  8035d5:	38 c2                	cmp    %al,%dl
  8035d7:	74 1c                	je     8035f5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8035d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dd:	0f b6 00             	movzbl (%rax),%eax
  8035e0:	0f b6 d0             	movzbl %al,%edx
  8035e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e7:	0f b6 00             	movzbl (%rax),%eax
  8035ea:	0f b6 c0             	movzbl %al,%eax
  8035ed:	89 d1                	mov    %edx,%ecx
  8035ef:	29 c1                	sub    %eax,%ecx
  8035f1:	89 c8                	mov    %ecx,%eax
  8035f3:	eb 20                	jmp    803615 <memcmp+0x74>
		s1++, s2++;
  8035f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8035ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803604:	0f 95 c0             	setne  %al
  803607:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80360c:	84 c0                	test   %al,%al
  80360e:	75 b7                	jne    8035c7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803615:	c9                   	leaveq 
  803616:	c3                   	retq   

0000000000803617 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803617:	55                   	push   %rbp
  803618:	48 89 e5             	mov    %rsp,%rbp
  80361b:	48 83 ec 28          	sub    $0x28,%rsp
  80361f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803623:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803626:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80362a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803632:	48 01 d0             	add    %rdx,%rax
  803635:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803639:	eb 13                	jmp    80364e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80363b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363f:	0f b6 10             	movzbl (%rax),%edx
  803642:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803645:	38 c2                	cmp    %al,%dl
  803647:	74 11                	je     80365a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803649:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80364e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803652:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803656:	72 e3                	jb     80363b <memfind+0x24>
  803658:	eb 01                	jmp    80365b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80365a:	90                   	nop
	return (void *) s;
  80365b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 38          	sub    $0x38,%rsp
  803669:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80366d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803671:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803674:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80367b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803682:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803683:	eb 05                	jmp    80368a <strtol+0x29>
		s++;
  803685:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80368a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368e:	0f b6 00             	movzbl (%rax),%eax
  803691:	3c 20                	cmp    $0x20,%al
  803693:	74 f0                	je     803685 <strtol+0x24>
  803695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803699:	0f b6 00             	movzbl (%rax),%eax
  80369c:	3c 09                	cmp    $0x9,%al
  80369e:	74 e5                	je     803685 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8036a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a4:	0f b6 00             	movzbl (%rax),%eax
  8036a7:	3c 2b                	cmp    $0x2b,%al
  8036a9:	75 07                	jne    8036b2 <strtol+0x51>
		s++;
  8036ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8036b0:	eb 17                	jmp    8036c9 <strtol+0x68>
	else if (*s == '-')
  8036b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b6:	0f b6 00             	movzbl (%rax),%eax
  8036b9:	3c 2d                	cmp    $0x2d,%al
  8036bb:	75 0c                	jne    8036c9 <strtol+0x68>
		s++, neg = 1;
  8036bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8036c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8036c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8036cd:	74 06                	je     8036d5 <strtol+0x74>
  8036cf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8036d3:	75 28                	jne    8036fd <strtol+0x9c>
  8036d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d9:	0f b6 00             	movzbl (%rax),%eax
  8036dc:	3c 30                	cmp    $0x30,%al
  8036de:	75 1d                	jne    8036fd <strtol+0x9c>
  8036e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e4:	48 83 c0 01          	add    $0x1,%rax
  8036e8:	0f b6 00             	movzbl (%rax),%eax
  8036eb:	3c 78                	cmp    $0x78,%al
  8036ed:	75 0e                	jne    8036fd <strtol+0x9c>
		s += 2, base = 16;
  8036ef:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8036f4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8036fb:	eb 2c                	jmp    803729 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8036fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803701:	75 19                	jne    80371c <strtol+0xbb>
  803703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803707:	0f b6 00             	movzbl (%rax),%eax
  80370a:	3c 30                	cmp    $0x30,%al
  80370c:	75 0e                	jne    80371c <strtol+0xbb>
		s++, base = 8;
  80370e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803713:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80371a:	eb 0d                	jmp    803729 <strtol+0xc8>
	else if (base == 0)
  80371c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803720:	75 07                	jne    803729 <strtol+0xc8>
		base = 10;
  803722:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372d:	0f b6 00             	movzbl (%rax),%eax
  803730:	3c 2f                	cmp    $0x2f,%al
  803732:	7e 1d                	jle    803751 <strtol+0xf0>
  803734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803738:	0f b6 00             	movzbl (%rax),%eax
  80373b:	3c 39                	cmp    $0x39,%al
  80373d:	7f 12                	jg     803751 <strtol+0xf0>
			dig = *s - '0';
  80373f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803743:	0f b6 00             	movzbl (%rax),%eax
  803746:	0f be c0             	movsbl %al,%eax
  803749:	83 e8 30             	sub    $0x30,%eax
  80374c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80374f:	eb 4e                	jmp    80379f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803755:	0f b6 00             	movzbl (%rax),%eax
  803758:	3c 60                	cmp    $0x60,%al
  80375a:	7e 1d                	jle    803779 <strtol+0x118>
  80375c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803760:	0f b6 00             	movzbl (%rax),%eax
  803763:	3c 7a                	cmp    $0x7a,%al
  803765:	7f 12                	jg     803779 <strtol+0x118>
			dig = *s - 'a' + 10;
  803767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376b:	0f b6 00             	movzbl (%rax),%eax
  80376e:	0f be c0             	movsbl %al,%eax
  803771:	83 e8 57             	sub    $0x57,%eax
  803774:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803777:	eb 26                	jmp    80379f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80377d:	0f b6 00             	movzbl (%rax),%eax
  803780:	3c 40                	cmp    $0x40,%al
  803782:	7e 47                	jle    8037cb <strtol+0x16a>
  803784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803788:	0f b6 00             	movzbl (%rax),%eax
  80378b:	3c 5a                	cmp    $0x5a,%al
  80378d:	7f 3c                	jg     8037cb <strtol+0x16a>
			dig = *s - 'A' + 10;
  80378f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803793:	0f b6 00             	movzbl (%rax),%eax
  803796:	0f be c0             	movsbl %al,%eax
  803799:	83 e8 37             	sub    $0x37,%eax
  80379c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80379f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037a2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8037a5:	7d 23                	jge    8037ca <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8037a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8037ac:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8037af:	48 98                	cltq   
  8037b1:	48 89 c2             	mov    %rax,%rdx
  8037b4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8037b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037bc:	48 98                	cltq   
  8037be:	48 01 d0             	add    %rdx,%rax
  8037c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8037c5:	e9 5f ff ff ff       	jmpq   803729 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8037ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8037cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8037d0:	74 0b                	je     8037dd <strtol+0x17c>
		*endptr = (char *) s;
  8037d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8037dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e1:	74 09                	je     8037ec <strtol+0x18b>
  8037e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e7:	48 f7 d8             	neg    %rax
  8037ea:	eb 04                	jmp    8037f0 <strtol+0x18f>
  8037ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8037f0:	c9                   	leaveq 
  8037f1:	c3                   	retq   

00000000008037f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8037f2:	55                   	push   %rbp
  8037f3:	48 89 e5             	mov    %rsp,%rbp
  8037f6:	48 83 ec 30          	sub    $0x30,%rsp
  8037fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803802:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803806:	0f b6 00             	movzbl (%rax),%eax
  803809:	88 45 ff             	mov    %al,-0x1(%rbp)
  80380c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  803811:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803815:	75 06                	jne    80381d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  803817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381b:	eb 68                	jmp    803885 <strstr+0x93>

	len = strlen(str);
  80381d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803821:	48 89 c7             	mov    %rax,%rdi
  803824:	48 b8 c8 30 80 00 00 	movabs $0x8030c8,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
  803830:	48 98                	cltq   
  803832:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383a:	0f b6 00             	movzbl (%rax),%eax
  80383d:	88 45 ef             	mov    %al,-0x11(%rbp)
  803840:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  803845:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803849:	75 07                	jne    803852 <strstr+0x60>
				return (char *) 0;
  80384b:	b8 00 00 00 00       	mov    $0x0,%eax
  803850:	eb 33                	jmp    803885 <strstr+0x93>
		} while (sc != c);
  803852:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803856:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803859:	75 db                	jne    803836 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80385b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80385f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803867:	48 89 ce             	mov    %rcx,%rsi
  80386a:	48 89 c7             	mov    %rax,%rdi
  80386d:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
  803879:	85 c0                	test   %eax,%eax
  80387b:	75 b9                	jne    803836 <strstr+0x44>

	return (char *) (in - 1);
  80387d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803881:	48 83 e8 01          	sub    $0x1,%rax
}
  803885:	c9                   	leaveq 
  803886:	c3                   	retq   
	...

0000000000803888 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803888:	55                   	push   %rbp
  803889:	48 89 e5             	mov    %rsp,%rbp
  80388c:	48 83 ec 30          	sub    $0x30,%rsp
  803890:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803894:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803898:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  80389c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8038a3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038a8:	74 18                	je     8038c2 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8038aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ae:	48 89 c7             	mov    %rax,%rdi
  8038b1:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c0:	eb 19                	jmp    8038db <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8038c2:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8038c9:	00 00 00 
  8038cc:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
  8038d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8038db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038df:	79 39                	jns    80391a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8038e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8038e6:	75 08                	jne    8038f0 <ipc_recv+0x68>
  8038e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ec:	8b 00                	mov    (%rax),%eax
  8038ee:	eb 05                	jmp    8038f5 <ipc_recv+0x6d>
  8038f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038f9:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8038fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803900:	75 08                	jne    80390a <ipc_recv+0x82>
  803902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803906:	8b 00                	mov    (%rax),%eax
  803908:	eb 05                	jmp    80390f <ipc_recv+0x87>
  80390a:	b8 00 00 00 00       	mov    $0x0,%eax
  80390f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803913:	89 02                	mov    %eax,(%rdx)
		return r;
  803915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803918:	eb 53                	jmp    80396d <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80391a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80391f:	74 19                	je     80393a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803921:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803928:	00 00 00 
  80392b:	48 8b 00             	mov    (%rax),%rax
  80392e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803938:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80393a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80393f:	74 19                	je     80395a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803941:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803948:	00 00 00 
  80394b:	48 8b 00             	mov    (%rax),%rax
  80394e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803958:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80395a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803961:	00 00 00 
  803964:	48 8b 00             	mov    (%rax),%rax
  803967:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  80396d:	c9                   	leaveq 
  80396e:	c3                   	retq   

000000000080396f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80396f:	55                   	push   %rbp
  803970:	48 89 e5             	mov    %rsp,%rbp
  803973:	48 83 ec 30          	sub    $0x30,%rsp
  803977:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80397a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80397d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803981:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803984:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  80398b:	eb 59                	jmp    8039e6 <ipc_send+0x77>
		if(pg) {
  80398d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803992:	74 20                	je     8039b4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803994:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803997:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80399a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80399e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039a1:	89 c7                	mov    %eax,%edi
  8039a3:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  8039aa:	00 00 00 
  8039ad:	ff d0                	callq  *%rax
  8039af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b2:	eb 26                	jmp    8039da <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8039b4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039bd:	89 d1                	mov    %edx,%ecx
  8039bf:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8039c6:	00 00 00 
  8039c9:	89 c7                	mov    %eax,%edi
  8039cb:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8039da:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8039e6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8039ea:	74 a1                	je     80398d <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8039ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f0:	74 2a                	je     803a1c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8039f2:	48 ba 68 41 80 00 00 	movabs $0x804168,%rdx
  8039f9:	00 00 00 
  8039fc:	be 49 00 00 00       	mov    $0x49,%esi
  803a01:	48 bf 93 41 80 00 00 	movabs $0x804193,%rdi
  803a08:	00 00 00 
  803a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a10:	48 b9 28 23 80 00 00 	movabs $0x802328,%rcx
  803a17:	00 00 00 
  803a1a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803a1c:	c9                   	leaveq 
  803a1d:	c3                   	retq   

0000000000803a1e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a1e:	55                   	push   %rbp
  803a1f:	48 89 e5             	mov    %rsp,%rbp
  803a22:	48 83 ec 18          	sub    $0x18,%rsp
  803a26:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803a29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a30:	eb 6a                	jmp    803a9c <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803a32:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a39:	00 00 00 
  803a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3f:	48 63 d0             	movslq %eax,%rdx
  803a42:	48 89 d0             	mov    %rdx,%rax
  803a45:	48 c1 e0 02          	shl    $0x2,%rax
  803a49:	48 01 d0             	add    %rdx,%rax
  803a4c:	48 01 c0             	add    %rax,%rax
  803a4f:	48 01 d0             	add    %rdx,%rax
  803a52:	48 c1 e0 05          	shl    $0x5,%rax
  803a56:	48 01 c8             	add    %rcx,%rax
  803a59:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803a5f:	8b 00                	mov    (%rax),%eax
  803a61:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a64:	75 32                	jne    803a98 <ipc_find_env+0x7a>
			return envs[i].env_id;
  803a66:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a6d:	00 00 00 
  803a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a73:	48 63 d0             	movslq %eax,%rdx
  803a76:	48 89 d0             	mov    %rdx,%rax
  803a79:	48 c1 e0 02          	shl    $0x2,%rax
  803a7d:	48 01 d0             	add    %rdx,%rax
  803a80:	48 01 c0             	add    %rax,%rax
  803a83:	48 01 d0             	add    %rdx,%rax
  803a86:	48 c1 e0 05          	shl    $0x5,%rax
  803a8a:	48 01 c8             	add    %rcx,%rax
  803a8d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803a93:	8b 40 08             	mov    0x8(%rax),%eax
  803a96:	eb 12                	jmp    803aaa <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803a98:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a9c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803aa3:	7e 8d                	jle    803a32 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 18          	sub    $0x18,%rsp
  803ab4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803abc:	48 89 c2             	mov    %rax,%rdx
  803abf:	48 c1 ea 15          	shr    $0x15,%rdx
  803ac3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803aca:	01 00 00 
  803acd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ad1:	83 e0 01             	and    $0x1,%eax
  803ad4:	48 85 c0             	test   %rax,%rax
  803ad7:	75 07                	jne    803ae0 <pageref+0x34>
		return 0;
  803ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ade:	eb 53                	jmp    803b33 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae4:	48 89 c2             	mov    %rax,%rdx
  803ae7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803aeb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803af2:	01 00 00 
  803af5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803af9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803afd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b01:	83 e0 01             	and    $0x1,%eax
  803b04:	48 85 c0             	test   %rax,%rax
  803b07:	75 07                	jne    803b10 <pageref+0x64>
		return 0;
  803b09:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0e:	eb 23                	jmp    803b33 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b14:	48 89 c2             	mov    %rax,%rdx
  803b17:	48 c1 ea 0c          	shr    $0xc,%rdx
  803b1b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803b22:	00 00 00 
  803b25:	48 c1 e2 04          	shl    $0x4,%rdx
  803b29:	48 01 d0             	add    %rdx,%rax
  803b2c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803b30:	0f b7 c0             	movzwl %ax,%eax
}
  803b33:	c9                   	leaveq 
  803b34:	c3                   	retq   
