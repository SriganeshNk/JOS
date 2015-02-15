
obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 73 03 00 00       	callq  8003b4 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	53                   	push   %rbx
  800049:	48 83 ec 28          	sub    $0x28,%rsp
  80004d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800050:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800054:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80005b:	00 00 00 
  80005e:	ff d0                	callq  *%rax
  800060:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800063:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80006a:	00 00 00 
  80006d:	48 ba 00 47 80 00 00 	movabs $0x804700,%rdx
  800074:	00 00 00 
  800077:	48 89 10             	mov    %rdx,(%rax)

    output_envid = fork();
  80007a:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80008d:	00 00 00 
  800090:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800092:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800099:	00 00 00 
  80009c:	8b 00                	mov    (%rax),%eax
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 2a                	jns    8000cc <umain+0x88>
        panic("error forking");
  8000a2:	48 ba 0b 47 80 00 00 	movabs $0x80470b,%rdx
  8000a9:	00 00 00 
  8000ac:	be 16 00 00 00       	mov    $0x16,%esi
  8000b1:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  8000b8:	00 00 00 
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  8000c7:	00 00 00 
  8000ca:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d3:	00 00 00 
  8000d6:	8b 00                	mov    (%rax),%eax
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	75 16                	jne    8000f2 <umain+0xae>
        output(ns_envid);
  8000dc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	48 b8 90 03 80 00 00 	movabs $0x800390,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax
        return;
  8000ed:	e9 50 01 00 00       	jmpq   800242 <umain+0x1fe>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000f9:	e9 1b 01 00 00       	jmpq   800219 <umain+0x1d5>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000fe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800105:	00 00 00 
  800108:	48 8b 00             	mov    (%rax),%rax
  80010b:	ba 07 00 00 00       	mov    $0x7,%edx
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 00       	mov    $0x0,%edi
  800118:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
  800124:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800127:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012b:	79 30                	jns    80015d <umain+0x119>
            panic("sys_page_alloc: %e", r);
  80012d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800130:	89 c1                	mov    %eax,%ecx
  800132:	48 ba 2a 47 80 00 00 	movabs $0x80472a,%rdx
  800139:	00 00 00 
  80013c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800141:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  800148:	00 00 00 
  80014b:	b8 00 00 00 00       	mov    $0x0,%eax
  800150:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  800157:	00 00 00 
  80015a:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80015d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800164:	00 00 00 
  800167:	48 8b 18             	mov    (%rax),%rbx
  80016a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800171:	00 00 00 
  800174:	48 8b 00             	mov    (%rax),%rax
  800177:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017e:	89 c1                	mov    %eax,%ecx
  800180:	48 ba 3d 47 80 00 00 	movabs $0x80473d,%rdx
  800187:	00 00 00 
  80018a:	be fc 0f 00 00       	mov    $0xffc,%esi
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	49 b8 3d 11 80 00 00 	movabs $0x80113d,%r8
  80019b:	00 00 00 
  80019e:	41 ff d0             	callq  *%r8
  8001a1:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a6:	89 c6                	mov    %eax,%esi
  8001a8:	48 bf 49 47 80 00 00 	movabs $0x804749,%rdi
  8001af:	00 00 00 
  8001b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b7:	48 ba bb 06 80 00 00 	movabs $0x8006bb,%rdx
  8001be:	00 00 00 
  8001c1:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ca:	00 00 00 
  8001cd:	48 8b 10             	mov    (%rax),%rdx
  8001d0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001d7:	00 00 00 
  8001da:	8b 00                	mov    (%rax),%eax
  8001dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e1:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e6:	89 c7                	mov    %eax,%edi
  8001e8:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 00             	mov    (%rax),%rax
  800201:	48 89 c6             	mov    %rax,%rsi
  800204:	bf 00 00 00 00       	mov    $0x0,%edi
  800209:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
    else if (output_envid == 0) {
        output(ns_envid);
        return;
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800215:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800219:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021d:	0f 8e db fe ff ff    	jle    8000fe <umain+0xba>
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800223:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80022a:	eb 10                	jmp    80023c <umain+0x1f8>
        sys_yield();
  80022c:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800238:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023c:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  800240:	7e ea                	jle    80022c <umain+0x1e8>
        sys_yield();
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   
  800249:	00 00                	add    %al,(%rax)
	...

000000000080024c <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	48 83 ec 20          	sub    $0x20,%rsp
  800254:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800257:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  80025a:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
  800266:	03 45 e8             	add    -0x18(%rbp),%eax
  800269:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  80026c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800273:	00 00 00 
  800276:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  80027d:	00 00 00 
  800280:	48 89 10             	mov    %rdx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800283:	eb 0c                	jmp    800291 <timer+0x45>
            sys_yield();
  800285:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800291:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
  80029d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002a6:	73 06                	jae    8002ae <timer+0x62>
  8002a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ac:	79 d7                	jns    800285 <timer+0x39>
            sys_yield();
        }
        if (r < 0)
  8002ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002b2:	79 30                	jns    8002e4 <timer+0x98>
            panic("sys_time_msec: %e", r);
  8002b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	48 ba 71 47 80 00 00 	movabs $0x804771,%rdx
  8002c0:	00 00 00 
  8002c3:	be 0f 00 00 00       	mov    $0xf,%esi
  8002c8:	48 bf 83 47 80 00 00 	movabs $0x804783,%rdi
  8002cf:	00 00 00 
  8002d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d7:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8002de:	00 00 00 
  8002e1:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f1:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f6:	89 c7                	mov    %eax,%edi
  8002f8:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800304:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	be 00 00 00 00       	mov    $0x0,%esi
  800312:	48 89 c7             	mov    %rax,%rdi
  800315:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	callq  *%rax
  800321:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  800324:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800327:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032a:	39 c2                	cmp    %eax,%edx
  80032c:	74 22                	je     800350 <timer+0x104>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  80032e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 90 47 80 00 00 	movabs $0x804790,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 ba bb 06 80 00 00 	movabs $0x8006bb,%rdx
  800349:	00 00 00 
  80034c:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  80034e:	eb b4                	jmp    800304 <timer+0xb8>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800350:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  800357:	00 00 00 
  80035a:	ff d0                	callq  *%rax
  80035c:	03 45 f4             	add    -0xc(%rbp),%eax
  80035f:	89 45 fc             	mov    %eax,-0x4(%rbp)
            break;
  800362:	90                   	nop
        }
    }
  800363:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800364:	e9 28 ff ff ff       	jmpq   800291 <timer+0x45>
  800369:	00 00                	add    %al,(%rax)
	...

000000000080036c <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	48 83 ec 08          	sub    $0x8,%rsp
  800374:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  800377:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80037e:	00 00 00 
  800381:	48 ba cb 47 80 00 00 	movabs $0x8047cb,%rdx
  800388:	00 00 00 
  80038b:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  80038e:	c9                   	leaveq 
  80038f:	c3                   	retq   

0000000000800390 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	48 83 ec 08          	sub    $0x8,%rsp
  800398:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_output";
  80039b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a2:	00 00 00 
  8003a5:	48 ba d4 47 80 00 00 	movabs $0x8047d4,%rdx
  8003ac:	00 00 00 
  8003af:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
}
  8003b2:	c9                   	leaveq 
  8003b3:	c3                   	retq   

00000000008003b4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003b4:	55                   	push   %rbp
  8003b5:	48 89 e5             	mov    %rsp,%rbp
  8003b8:	48 83 ec 10          	sub    $0x10,%rsp
  8003bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8003c3:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003ca:	00 00 00 
  8003cd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8003d4:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
  8003e0:	48 98                	cltq   
  8003e2:	48 89 c2             	mov    %rax,%rdx
  8003e5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8003eb:	48 89 d0             	mov    %rdx,%rax
  8003ee:	48 c1 e0 02          	shl    $0x2,%rax
  8003f2:	48 01 d0             	add    %rdx,%rax
  8003f5:	48 01 c0             	add    %rax,%rax
  8003f8:	48 01 d0             	add    %rdx,%rax
  8003fb:	48 c1 e0 05          	shl    $0x5,%rax
  8003ff:	48 89 c2             	mov    %rax,%rdx
  800402:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800409:	00 00 00 
  80040c:	48 01 c2             	add    %rax,%rdx
  80040f:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800416:	00 00 00 
  800419:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80041c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800420:	7e 14                	jle    800436 <libmain+0x82>
		binaryname = argv[0];
  800422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800426:	48 8b 10             	mov    (%rax),%rdx
  800429:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800430:	00 00 00 
  800433:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800436:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043d:	48 89 d6             	mov    %rdx,%rsi
  800440:	89 c7                	mov    %eax,%edi
  800442:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800449:	00 00 00 
  80044c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80044e:	48 b8 5c 04 80 00 00 	movabs $0x80045c,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
}
  80045a:	c9                   	leaveq 
  80045b:	c3                   	retq   

000000000080045c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80045c:	55                   	push   %rbp
  80045d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800460:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80046c:	bf 00 00 00 00       	mov    $0x0,%edi
  800471:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  800478:	00 00 00 
  80047b:	ff d0                	callq  *%rax
}
  80047d:	5d                   	pop    %rbp
  80047e:	c3                   	retq   
	...

0000000000800480 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800480:	55                   	push   %rbp
  800481:	48 89 e5             	mov    %rsp,%rbp
  800484:	53                   	push   %rbx
  800485:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80048c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800493:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800499:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004a0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004a7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004ae:	84 c0                	test   %al,%al
  8004b0:	74 23                	je     8004d5 <_panic+0x55>
  8004b2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004b9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004bd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004c1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004c5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8004c9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8004cd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8004d1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8004d5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004dc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004e3:	00 00 00 
  8004e6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004ed:	00 00 00 
  8004f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004fb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800502:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800509:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800510:	00 00 00 
  800513:	48 8b 18             	mov    (%rax),%rbx
  800516:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800528:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80052f:	41 89 c8             	mov    %ecx,%r8d
  800532:	48 89 d1             	mov    %rdx,%rcx
  800535:	48 89 da             	mov    %rbx,%rdx
  800538:	89 c6                	mov    %eax,%esi
  80053a:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  800541:	00 00 00 
  800544:	b8 00 00 00 00       	mov    $0x0,%eax
  800549:	49 b9 bb 06 80 00 00 	movabs $0x8006bb,%r9
  800550:	00 00 00 
  800553:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800556:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80055d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800564:	48 89 d6             	mov    %rdx,%rsi
  800567:	48 89 c7             	mov    %rax,%rdi
  80056a:	48 b8 0f 06 80 00 00 	movabs $0x80060f,%rax
  800571:	00 00 00 
  800574:	ff d0                	callq  *%rax
	cprintf("\n");
  800576:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  80057d:	00 00 00 
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	48 ba bb 06 80 00 00 	movabs $0x8006bb,%rdx
  80058c:	00 00 00 
  80058f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800591:	cc                   	int3   
  800592:	eb fd                	jmp    800591 <_panic+0x111>

0000000000800594 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 83 ec 10          	sub    $0x10,%rsp
  80059c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80059f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005ac:	89 d6                	mov    %edx,%esi
  8005ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005b2:	48 63 d0             	movslq %eax,%rdx
  8005b5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8005ba:	8d 50 01             	lea    0x1(%rax),%edx
  8005bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c1:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8005c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c7:	8b 00                	mov    (%rax),%eax
  8005c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ce:	75 2c                	jne    8005fc <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8005d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d4:	8b 00                	mov    (%rax),%eax
  8005d6:	48 98                	cltq   
  8005d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005dc:	48 83 c2 08          	add    $0x8,%rdx
  8005e0:	48 89 c6             	mov    %rax,%rsi
  8005e3:	48 89 d7             	mov    %rdx,%rdi
  8005e6:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
        b->idx = 0;
  8005f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800600:	8b 40 04             	mov    0x4(%rax),%eax
  800603:	8d 50 01             	lea    0x1(%rax),%edx
  800606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80060d:	c9                   	leaveq 
  80060e:	c3                   	retq   

000000000080060f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80060f:	55                   	push   %rbp
  800610:	48 89 e5             	mov    %rsp,%rbp
  800613:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80061a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800621:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800628:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80062f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800636:	48 8b 0a             	mov    (%rdx),%rcx
  800639:	48 89 08             	mov    %rcx,(%rax)
  80063c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800640:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800644:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800648:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80064c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800653:	00 00 00 
    b.cnt = 0;
  800656:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80065d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800660:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800667:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80066e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800675:	48 89 c6             	mov    %rax,%rsi
  800678:	48 bf 94 05 80 00 00 	movabs $0x800594,%rdi
  80067f:	00 00 00 
  800682:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80068e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800694:	48 98                	cltq   
  800696:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80069d:	48 83 c2 08          	add    $0x8,%rdx
  8006a1:	48 89 c6             	mov    %rax,%rsi
  8006a4:	48 89 d7             	mov    %rdx,%rdi
  8006a7:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8006ae:	00 00 00 
  8006b1:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006b9:	c9                   	leaveq 
  8006ba:	c3                   	retq   

00000000008006bb <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006bb:	55                   	push   %rbp
  8006bc:	48 89 e5             	mov    %rsp,%rbp
  8006bf:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006c6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8006cd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8006d4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8006db:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006e2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006e9:	84 c0                	test   %al,%al
  8006eb:	74 20                	je     80070d <cprintf+0x52>
  8006ed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006f1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006f5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006f9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006fd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800701:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800705:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800709:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80070d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800714:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80071b:	00 00 00 
  80071e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800725:	00 00 00 
  800728:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80072c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800733:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80073a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800741:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800748:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80074f:	48 8b 0a             	mov    (%rdx),%rcx
  800752:	48 89 08             	mov    %rcx,(%rax)
  800755:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800759:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80075d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800761:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800765:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80076c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800773:	48 89 d6             	mov    %rdx,%rsi
  800776:	48 89 c7             	mov    %rax,%rdi
  800779:	48 b8 0f 06 80 00 00 	movabs $0x80060f,%rax
  800780:	00 00 00 
  800783:	ff d0                	callq  *%rax
  800785:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80078b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800791:	c9                   	leaveq 
  800792:	c3                   	retq   
	...

0000000000800794 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800794:	55                   	push   %rbp
  800795:	48 89 e5             	mov    %rsp,%rbp
  800798:	48 83 ec 30          	sub    $0x30,%rsp
  80079c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8007a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8007a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8007a8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8007ab:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8007af:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007b6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8007ba:	77 52                	ja     80080e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007bf:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007c3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8007c6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	48 f7 75 d0          	divq   -0x30(%rbp)
  8007d7:	48 89 c2             	mov    %rax,%rdx
  8007da:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8007dd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007e0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8007e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007e8:	41 89 f9             	mov    %edi,%r9d
  8007eb:	48 89 c7             	mov    %rax,%rdi
  8007ee:	48 b8 94 07 80 00 00 	movabs $0x800794,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
  8007fa:	eb 1c                	jmp    800818 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800800:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800803:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800807:	48 89 d6             	mov    %rdx,%rsi
  80080a:	89 c7                	mov    %eax,%edi
  80080c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800812:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800816:	7f e4                	jg     8007fc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	ba 00 00 00 00       	mov    $0x0,%edx
  800824:	48 f7 f1             	div    %rcx
  800827:	48 89 d0             	mov    %rdx,%rax
  80082a:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
  800831:	00 00 00 
  800834:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800838:	0f be c0             	movsbl %al,%eax
  80083b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80083f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800843:	48 89 d6             	mov    %rdx,%rsi
  800846:	89 c7                	mov    %eax,%edi
  800848:	ff d1                	callq  *%rcx
}
  80084a:	c9                   	leaveq 
  80084b:	c3                   	retq   

000000000080084c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80084c:	55                   	push   %rbp
  80084d:	48 89 e5             	mov    %rsp,%rbp
  800850:	48 83 ec 20          	sub    $0x20,%rsp
  800854:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800858:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80085b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80085f:	7e 52                	jle    8008b3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	8b 00                	mov    (%rax),%eax
  800867:	83 f8 30             	cmp    $0x30,%eax
  80086a:	73 24                	jae    800890 <getuint+0x44>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	89 c0                	mov    %eax,%eax
  80087c:	48 01 d0             	add    %rdx,%rax
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	8b 12                	mov    (%rdx),%edx
  800885:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	89 0a                	mov    %ecx,(%rdx)
  80088e:	eb 17                	jmp    8008a7 <getuint+0x5b>
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a7:	48 8b 00             	mov    (%rax),%rax
  8008aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ae:	e9 a3 00 00 00       	jmpq   800956 <getuint+0x10a>
	else if (lflag)
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008b7:	74 4f                	je     800908 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bd:	8b 00                	mov    (%rax),%eax
  8008bf:	83 f8 30             	cmp    $0x30,%eax
  8008c2:	73 24                	jae    8008e8 <getuint+0x9c>
  8008c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d0:	8b 00                	mov    (%rax),%eax
  8008d2:	89 c0                	mov    %eax,%eax
  8008d4:	48 01 d0             	add    %rdx,%rax
  8008d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008db:	8b 12                	mov    (%rdx),%edx
  8008dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e4:	89 0a                	mov    %ecx,(%rdx)
  8008e6:	eb 17                	jmp    8008ff <getuint+0xb3>
  8008e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f0:	48 89 d0             	mov    %rdx,%rax
  8008f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ff:	48 8b 00             	mov    (%rax),%rax
  800902:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800906:	eb 4e                	jmp    800956 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	8b 00                	mov    (%rax),%eax
  80090e:	83 f8 30             	cmp    $0x30,%eax
  800911:	73 24                	jae    800937 <getuint+0xeb>
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80091b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091f:	8b 00                	mov    (%rax),%eax
  800921:	89 c0                	mov    %eax,%eax
  800923:	48 01 d0             	add    %rdx,%rax
  800926:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092a:	8b 12                	mov    (%rdx),%edx
  80092c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800933:	89 0a                	mov    %ecx,(%rdx)
  800935:	eb 17                	jmp    80094e <getuint+0x102>
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80093f:	48 89 d0             	mov    %rdx,%rax
  800942:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	89 c0                	mov    %eax,%eax
  800952:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800956:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80095a:	c9                   	leaveq 
  80095b:	c3                   	retq   

000000000080095c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80095c:	55                   	push   %rbp
  80095d:	48 89 e5             	mov    %rsp,%rbp
  800960:	48 83 ec 20          	sub    $0x20,%rsp
  800964:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800968:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80096b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80096f:	7e 52                	jle    8009c3 <getint+0x67>
		x=va_arg(*ap, long long);
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	8b 00                	mov    (%rax),%eax
  800977:	83 f8 30             	cmp    $0x30,%eax
  80097a:	73 24                	jae    8009a0 <getint+0x44>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 01 d0             	add    %rdx,%rax
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	8b 12                	mov    (%rdx),%edx
  800995:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099c:	89 0a                	mov    %ecx,(%rdx)
  80099e:	eb 17                	jmp    8009b7 <getint+0x5b>
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a8:	48 89 d0             	mov    %rdx,%rax
  8009ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b7:	48 8b 00             	mov    (%rax),%rax
  8009ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009be:	e9 a3 00 00 00       	jmpq   800a66 <getint+0x10a>
	else if (lflag)
  8009c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009c7:	74 4f                	je     800a18 <getint+0xbc>
		x=va_arg(*ap, long);
  8009c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cd:	8b 00                	mov    (%rax),%eax
  8009cf:	83 f8 30             	cmp    $0x30,%eax
  8009d2:	73 24                	jae    8009f8 <getint+0x9c>
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e0:	8b 00                	mov    (%rax),%eax
  8009e2:	89 c0                	mov    %eax,%eax
  8009e4:	48 01 d0             	add    %rdx,%rax
  8009e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009eb:	8b 12                	mov    (%rdx),%edx
  8009ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f4:	89 0a                	mov    %ecx,(%rdx)
  8009f6:	eb 17                	jmp    800a0f <getint+0xb3>
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a00:	48 89 d0             	mov    %rdx,%rax
  800a03:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a0f:	48 8b 00             	mov    (%rax),%rax
  800a12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a16:	eb 4e                	jmp    800a66 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	8b 00                	mov    (%rax),%eax
  800a1e:	83 f8 30             	cmp    $0x30,%eax
  800a21:	73 24                	jae    800a47 <getint+0xeb>
  800a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a27:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2f:	8b 00                	mov    (%rax),%eax
  800a31:	89 c0                	mov    %eax,%eax
  800a33:	48 01 d0             	add    %rdx,%rax
  800a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3a:	8b 12                	mov    (%rdx),%edx
  800a3c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a43:	89 0a                	mov    %ecx,(%rdx)
  800a45:	eb 17                	jmp    800a5e <getint+0x102>
  800a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a4f:	48 89 d0             	mov    %rdx,%rax
  800a52:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	48 98                	cltq   
  800a62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a6a:	c9                   	leaveq 
  800a6b:	c3                   	retq   

0000000000800a6c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a6c:	55                   	push   %rbp
  800a6d:	48 89 e5             	mov    %rsp,%rbp
  800a70:	41 54                	push   %r12
  800a72:	53                   	push   %rbx
  800a73:	48 83 ec 60          	sub    $0x60,%rsp
  800a77:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a7b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a7f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a83:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a87:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a8b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a8f:	48 8b 0a             	mov    (%rdx),%rcx
  800a92:	48 89 08             	mov    %rcx,(%rax)
  800a95:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a99:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a9d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aa1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa5:	eb 17                	jmp    800abe <vprintfmt+0x52>
			if (ch == '\0')
  800aa7:	85 db                	test   %ebx,%ebx
  800aa9:	0f 84 ea 04 00 00    	je     800f99 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800aaf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ab7:	48 89 c6             	mov    %rax,%rsi
  800aba:	89 df                	mov    %ebx,%edi
  800abc:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800abe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac2:	0f b6 00             	movzbl (%rax),%eax
  800ac5:	0f b6 d8             	movzbl %al,%ebx
  800ac8:	83 fb 25             	cmp    $0x25,%ebx
  800acb:	0f 95 c0             	setne  %al
  800ace:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ad3:	84 c0                	test   %al,%al
  800ad5:	75 d0                	jne    800aa7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ad7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800adb:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ae2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ae9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800af0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800af7:	eb 04                	jmp    800afd <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800af9:	90                   	nop
  800afa:	eb 01                	jmp    800afd <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800afc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b01:	0f b6 00             	movzbl (%rax),%eax
  800b04:	0f b6 d8             	movzbl %al,%ebx
  800b07:	89 d8                	mov    %ebx,%eax
  800b09:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b0e:	83 e8 23             	sub    $0x23,%eax
  800b11:	83 f8 55             	cmp    $0x55,%eax
  800b14:	0f 87 4b 04 00 00    	ja     800f65 <vprintfmt+0x4f9>
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b23:	00 
  800b24:	48 b8 38 4a 80 00 00 	movabs $0x804a38,%rax
  800b2b:	00 00 00 
  800b2e:	48 01 d0             	add    %rdx,%rax
  800b31:	48 8b 00             	mov    (%rax),%rax
  800b34:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b36:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b3a:	eb c1                	jmp    800afd <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b3c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b40:	eb bb                	jmp    800afd <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b42:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b49:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b4c:	89 d0                	mov    %edx,%eax
  800b4e:	c1 e0 02             	shl    $0x2,%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	01 c0                	add    %eax,%eax
  800b55:	01 d8                	add    %ebx,%eax
  800b57:	83 e8 30             	sub    $0x30,%eax
  800b5a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b5d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b61:	0f b6 00             	movzbl (%rax),%eax
  800b64:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b67:	83 fb 2f             	cmp    $0x2f,%ebx
  800b6a:	7e 63                	jle    800bcf <vprintfmt+0x163>
  800b6c:	83 fb 39             	cmp    $0x39,%ebx
  800b6f:	7f 5e                	jg     800bcf <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b71:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b76:	eb d1                	jmp    800b49 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7b:	83 f8 30             	cmp    $0x30,%eax
  800b7e:	73 17                	jae    800b97 <vprintfmt+0x12b>
  800b80:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b87:	89 c0                	mov    %eax,%eax
  800b89:	48 01 d0             	add    %rdx,%rax
  800b8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8f:	83 c2 08             	add    $0x8,%edx
  800b92:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b95:	eb 0f                	jmp    800ba6 <vprintfmt+0x13a>
  800b97:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9b:	48 89 d0             	mov    %rdx,%rax
  800b9e:	48 83 c2 08          	add    $0x8,%rdx
  800ba2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba6:	8b 00                	mov    (%rax),%eax
  800ba8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bab:	eb 23                	jmp    800bd0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800bad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb1:	0f 89 42 ff ff ff    	jns    800af9 <vprintfmt+0x8d>
				width = 0;
  800bb7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bbe:	e9 36 ff ff ff       	jmpq   800af9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800bc3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800bca:	e9 2e ff ff ff       	jmpq   800afd <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bcf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bd0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd4:	0f 89 22 ff ff ff    	jns    800afc <vprintfmt+0x90>
				width = precision, precision = -1;
  800bda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bdd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800be0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800be7:	e9 10 ff ff ff       	jmpq   800afc <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bec:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bf0:	e9 08 ff ff ff       	jmpq   800afd <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	83 f8 30             	cmp    $0x30,%eax
  800bfb:	73 17                	jae    800c14 <vprintfmt+0x1a8>
  800bfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c04:	89 c0                	mov    %eax,%eax
  800c06:	48 01 d0             	add    %rdx,%rax
  800c09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0c:	83 c2 08             	add    $0x8,%edx
  800c0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c12:	eb 0f                	jmp    800c23 <vprintfmt+0x1b7>
  800c14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c18:	48 89 d0             	mov    %rdx,%rax
  800c1b:	48 83 c2 08          	add    $0x8,%rdx
  800c1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c23:	8b 00                	mov    (%rax),%eax
  800c25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c29:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c2d:	48 89 d6             	mov    %rdx,%rsi
  800c30:	89 c7                	mov    %eax,%edi
  800c32:	ff d1                	callq  *%rcx
			break;
  800c34:	e9 5a 03 00 00       	jmpq   800f93 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3c:	83 f8 30             	cmp    $0x30,%eax
  800c3f:	73 17                	jae    800c58 <vprintfmt+0x1ec>
  800c41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c48:	89 c0                	mov    %eax,%eax
  800c4a:	48 01 d0             	add    %rdx,%rax
  800c4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c50:	83 c2 08             	add    $0x8,%edx
  800c53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c56:	eb 0f                	jmp    800c67 <vprintfmt+0x1fb>
  800c58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5c:	48 89 d0             	mov    %rdx,%rax
  800c5f:	48 83 c2 08          	add    $0x8,%rdx
  800c63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c67:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c69:	85 db                	test   %ebx,%ebx
  800c6b:	79 02                	jns    800c6f <vprintfmt+0x203>
				err = -err;
  800c6d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c6f:	83 fb 15             	cmp    $0x15,%ebx
  800c72:	7f 16                	jg     800c8a <vprintfmt+0x21e>
  800c74:	48 b8 60 49 80 00 00 	movabs $0x804960,%rax
  800c7b:	00 00 00 
  800c7e:	48 63 d3             	movslq %ebx,%rdx
  800c81:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c85:	4d 85 e4             	test   %r12,%r12
  800c88:	75 2e                	jne    800cb8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c92:	89 d9                	mov    %ebx,%ecx
  800c94:	48 ba 21 4a 80 00 00 	movabs $0x804a21,%rdx
  800c9b:	00 00 00 
  800c9e:	48 89 c7             	mov    %rax,%rdi
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	49 b8 a3 0f 80 00 00 	movabs $0x800fa3,%r8
  800cad:	00 00 00 
  800cb0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cb3:	e9 db 02 00 00       	jmpq   800f93 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc0:	4c 89 e1             	mov    %r12,%rcx
  800cc3:	48 ba 2a 4a 80 00 00 	movabs $0x804a2a,%rdx
  800cca:	00 00 00 
  800ccd:	48 89 c7             	mov    %rax,%rdi
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd5:	49 b8 a3 0f 80 00 00 	movabs $0x800fa3,%r8
  800cdc:	00 00 00 
  800cdf:	41 ff d0             	callq  *%r8
			break;
  800ce2:	e9 ac 02 00 00       	jmpq   800f93 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ce7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cea:	83 f8 30             	cmp    $0x30,%eax
  800ced:	73 17                	jae    800d06 <vprintfmt+0x29a>
  800cef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf6:	89 c0                	mov    %eax,%eax
  800cf8:	48 01 d0             	add    %rdx,%rax
  800cfb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfe:	83 c2 08             	add    $0x8,%edx
  800d01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d04:	eb 0f                	jmp    800d15 <vprintfmt+0x2a9>
  800d06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0a:	48 89 d0             	mov    %rdx,%rax
  800d0d:	48 83 c2 08          	add    $0x8,%rdx
  800d11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d15:	4c 8b 20             	mov    (%rax),%r12
  800d18:	4d 85 e4             	test   %r12,%r12
  800d1b:	75 0a                	jne    800d27 <vprintfmt+0x2bb>
				p = "(null)";
  800d1d:	49 bc 2d 4a 80 00 00 	movabs $0x804a2d,%r12
  800d24:	00 00 00 
			if (width > 0 && padc != '-')
  800d27:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d2b:	7e 7a                	jle    800da7 <vprintfmt+0x33b>
  800d2d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d31:	74 74                	je     800da7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d33:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d36:	48 98                	cltq   
  800d38:	48 89 c6             	mov    %rax,%rsi
  800d3b:	4c 89 e7             	mov    %r12,%rdi
  800d3e:	48 b8 4e 12 80 00 00 	movabs $0x80124e,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
  800d4a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d4d:	eb 17                	jmp    800d66 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800d4f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800d53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d57:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	89 c7                	mov    %eax,%edi
  800d60:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d62:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d66:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6a:	7f e3                	jg     800d4f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d6c:	eb 39                	jmp    800da7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800d6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d72:	74 1e                	je     800d92 <vprintfmt+0x326>
  800d74:	83 fb 1f             	cmp    $0x1f,%ebx
  800d77:	7e 05                	jle    800d7e <vprintfmt+0x312>
  800d79:	83 fb 7e             	cmp    $0x7e,%ebx
  800d7c:	7e 14                	jle    800d92 <vprintfmt+0x326>
					putch('?', putdat);
  800d7e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d82:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d86:	48 89 c6             	mov    %rax,%rsi
  800d89:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d8e:	ff d2                	callq  *%rdx
  800d90:	eb 0f                	jmp    800da1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d92:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d96:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d9a:	48 89 c6             	mov    %rax,%rsi
  800d9d:	89 df                	mov    %ebx,%edi
  800d9f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da5:	eb 01                	jmp    800da8 <vprintfmt+0x33c>
  800da7:	90                   	nop
  800da8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800dad:	0f be d8             	movsbl %al,%ebx
  800db0:	85 db                	test   %ebx,%ebx
  800db2:	0f 95 c0             	setne  %al
  800db5:	49 83 c4 01          	add    $0x1,%r12
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 28                	je     800de5 <vprintfmt+0x379>
  800dbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dc1:	78 ab                	js     800d6e <vprintfmt+0x302>
  800dc3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800dc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dcb:	79 a1                	jns    800d6e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dcd:	eb 16                	jmp    800de5 <vprintfmt+0x379>
				putch(' ', putdat);
  800dcf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dd3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd7:	48 89 c6             	mov    %rax,%rsi
  800dda:	bf 20 00 00 00       	mov    $0x20,%edi
  800ddf:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de9:	7f e4                	jg     800dcf <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800deb:	e9 a3 01 00 00       	jmpq   800f93 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800df0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df4:	be 03 00 00 00       	mov    $0x3,%esi
  800df9:	48 89 c7             	mov    %rax,%rdi
  800dfc:	48 b8 5c 09 80 00 00 	movabs $0x80095c,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	callq  *%rax
  800e08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e10:	48 85 c0             	test   %rax,%rax
  800e13:	79 1d                	jns    800e32 <vprintfmt+0x3c6>
				putch('-', putdat);
  800e15:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e19:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e1d:	48 89 c6             	mov    %rax,%rsi
  800e20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e25:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2b:	48 f7 d8             	neg    %rax
  800e2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e39:	e9 e8 00 00 00       	jmpq   800f26 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e42:	be 03 00 00 00       	mov    $0x3,%esi
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e61:	e9 c0 00 00 00       	jmpq   800f26 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e66:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e6a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e6e:	48 89 c6             	mov    %rax,%rsi
  800e71:	bf 58 00 00 00       	mov    $0x58,%edi
  800e76:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e78:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e7c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e80:	48 89 c6             	mov    %rax,%rsi
  800e83:	bf 58 00 00 00       	mov    $0x58,%edi
  800e88:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e92:	48 89 c6             	mov    %rax,%rsi
  800e95:	bf 58 00 00 00       	mov    $0x58,%edi
  800e9a:	ff d2                	callq  *%rdx
			break;
  800e9c:	e9 f2 00 00 00       	jmpq   800f93 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800ea1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ea5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ea9:	48 89 c6             	mov    %rax,%rsi
  800eac:	bf 30 00 00 00       	mov    $0x30,%edi
  800eb1:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800eb3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eb7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ebb:	48 89 c6             	mov    %rax,%rsi
  800ebe:	bf 78 00 00 00       	mov    $0x78,%edi
  800ec3:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ec5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec8:	83 f8 30             	cmp    $0x30,%eax
  800ecb:	73 17                	jae    800ee4 <vprintfmt+0x478>
  800ecd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ed1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed4:	89 c0                	mov    %eax,%eax
  800ed6:	48 01 d0             	add    %rdx,%rax
  800ed9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800edc:	83 c2 08             	add    $0x8,%edx
  800edf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee2:	eb 0f                	jmp    800ef3 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800ee4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ee8:	48 89 d0             	mov    %rdx,%rax
  800eeb:	48 83 c2 08          	add    $0x8,%rdx
  800eef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ef3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ef6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800efa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f01:	eb 23                	jmp    800f26 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f07:	be 03 00 00 00       	mov    $0x3,%esi
  800f0c:	48 89 c7             	mov    %rax,%rdi
  800f0f:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	callq  *%rax
  800f1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f1f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f26:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f2b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f2e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f35:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3d:	45 89 c1             	mov    %r8d,%r9d
  800f40:	41 89 f8             	mov    %edi,%r8d
  800f43:	48 89 c7             	mov    %rax,%rdi
  800f46:	48 b8 94 07 80 00 00 	movabs $0x800794,%rax
  800f4d:	00 00 00 
  800f50:	ff d0                	callq  *%rax
			break;
  800f52:	eb 3f                	jmp    800f93 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f54:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f58:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f5c:	48 89 c6             	mov    %rax,%rsi
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	ff d2                	callq  *%rdx
			break;
  800f63:	eb 2e                	jmp    800f93 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f65:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f69:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f6d:	48 89 c6             	mov    %rax,%rsi
  800f70:	bf 25 00 00 00       	mov    $0x25,%edi
  800f75:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f77:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f7c:	eb 05                	jmp    800f83 <vprintfmt+0x517>
  800f7e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f87:	48 83 e8 01          	sub    $0x1,%rax
  800f8b:	0f b6 00             	movzbl (%rax),%eax
  800f8e:	3c 25                	cmp    $0x25,%al
  800f90:	75 ec                	jne    800f7e <vprintfmt+0x512>
				/* do nothing */;
			break;
  800f92:	90                   	nop
		}
	}
  800f93:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f94:	e9 25 fb ff ff       	jmpq   800abe <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f99:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f9a:	48 83 c4 60          	add    $0x60,%rsp
  800f9e:	5b                   	pop    %rbx
  800f9f:	41 5c                	pop    %r12
  800fa1:	5d                   	pop    %rbp
  800fa2:	c3                   	retq   

0000000000800fa3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa3:	55                   	push   %rbp
  800fa4:	48 89 e5             	mov    %rsp,%rbp
  800fa7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fae:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fb5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fbc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fc3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fd1:	84 c0                	test   %al,%al
  800fd3:	74 20                	je     800ff5 <printfmt+0x52>
  800fd5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fd9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fdd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fe1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fe5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fe9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ff1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ff5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ffc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801003:	00 00 00 
  801006:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80100d:	00 00 00 
  801010:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801014:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80101b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801022:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801029:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801030:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801037:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80103e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801045:	48 89 c7             	mov    %rax,%rdi
  801048:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  80104f:	00 00 00 
  801052:	ff d0                	callq  *%rax
	va_end(ap);
}
  801054:	c9                   	leaveq 
  801055:	c3                   	retq   

0000000000801056 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801056:	55                   	push   %rbp
  801057:	48 89 e5             	mov    %rsp,%rbp
  80105a:	48 83 ec 10          	sub    $0x10,%rsp
  80105e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801069:	8b 40 10             	mov    0x10(%rax),%eax
  80106c:	8d 50 01             	lea    0x1(%rax),%edx
  80106f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801073:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107a:	48 8b 10             	mov    (%rax),%rdx
  80107d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801081:	48 8b 40 08          	mov    0x8(%rax),%rax
  801085:	48 39 c2             	cmp    %rax,%rdx
  801088:	73 17                	jae    8010a1 <sprintputch+0x4b>
		*b->buf++ = ch;
  80108a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108e:	48 8b 00             	mov    (%rax),%rax
  801091:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801094:	88 10                	mov    %dl,(%rax)
  801096:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109e:	48 89 10             	mov    %rdx,(%rax)
}
  8010a1:	c9                   	leaveq 
  8010a2:	c3                   	retq   

00000000008010a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a3:	55                   	push   %rbp
  8010a4:	48 89 e5             	mov    %rsp,%rbp
  8010a7:	48 83 ec 50          	sub    $0x50,%rsp
  8010ab:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010af:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010b2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010b6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010ba:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010be:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010c2:	48 8b 0a             	mov    (%rdx),%rcx
  8010c5:	48 89 08             	mov    %rcx,(%rax)
  8010c8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010d0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010dc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010e0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010e3:	48 98                	cltq   
  8010e5:	48 83 e8 01          	sub    $0x1,%rax
  8010e9:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8010ed:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010f8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010fd:	74 06                	je     801105 <vsnprintf+0x62>
  8010ff:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801103:	7f 07                	jg     80110c <vsnprintf+0x69>
		return -E_INVAL;
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110a:	eb 2f                	jmp    80113b <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80110c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801110:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801114:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801118:	48 89 c6             	mov    %rax,%rsi
  80111b:	48 bf 56 10 80 00 00 	movabs $0x801056,%rdi
  801122:	00 00 00 
  801125:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  80112c:	00 00 00 
  80112f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801131:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801135:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801138:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801148:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80114f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801155:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80115c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801163:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80116a:	84 c0                	test   %al,%al
  80116c:	74 20                	je     80118e <snprintf+0x51>
  80116e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801172:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801176:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80117a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80117e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801182:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801186:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80118a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80118e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801195:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80119c:	00 00 00 
  80119f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011a6:	00 00 00 
  8011a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011c2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011c9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011d0:	48 8b 0a             	mov    (%rdx),%rcx
  8011d3:	48 89 08             	mov    %rcx,(%rax)
  8011d6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011da:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011de:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011e2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011e6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011ed:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011f4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801201:	48 89 c7             	mov    %rax,%rdi
  801204:	48 b8 a3 10 80 00 00 	movabs $0x8010a3,%rax
  80120b:	00 00 00 
  80120e:	ff d0                	callq  *%rax
  801210:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801216:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80121c:	c9                   	leaveq 
  80121d:	c3                   	retq   
	...

0000000000801220 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801220:	55                   	push   %rbp
  801221:	48 89 e5             	mov    %rsp,%rbp
  801224:	48 83 ec 18          	sub    $0x18,%rsp
  801228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80122c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801233:	eb 09                	jmp    80123e <strlen+0x1e>
		n++;
  801235:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801239:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80123e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	75 ec                	jne    801235 <strlen+0x15>
		n++;
	return n;
  801249:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80124c:	c9                   	leaveq 
  80124d:	c3                   	retq   

000000000080124e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	48 83 ec 20          	sub    $0x20,%rsp
  801256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801265:	eb 0e                	jmp    801275 <strnlen+0x27>
		n++;
  801267:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801270:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801275:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80127a:	74 0b                	je     801287 <strnlen+0x39>
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	75 e0                	jne    801267 <strnlen+0x19>
		n++;
	return n;
  801287:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 20          	sub    $0x20,%rsp
  801294:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801298:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012a4:	90                   	nop
  8012a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a9:	0f b6 10             	movzbl (%rax),%edx
  8012ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b0:	88 10                	mov    %dl,(%rax)
  8012b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b6:	0f b6 00             	movzbl (%rax),%eax
  8012b9:	84 c0                	test   %al,%al
  8012bb:	0f 95 c0             	setne  %al
  8012be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8012c8:	84 c0                	test   %al,%al
  8012ca:	75 d9                	jne    8012a5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d0:	c9                   	leaveq 
  8012d1:	c3                   	retq   

00000000008012d2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012d2:	55                   	push   %rbp
  8012d3:	48 89 e5             	mov    %rsp,%rbp
  8012d6:	48 83 ec 20          	sub    $0x20,%rsp
  8012da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e6:	48 89 c7             	mov    %rax,%rdi
  8012e9:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8012f0:	00 00 00 
  8012f3:	ff d0                	callq  *%rax
  8012f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012fb:	48 98                	cltq   
  8012fd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801301:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801305:	48 89 d6             	mov    %rdx,%rsi
  801308:	48 89 c7             	mov    %rax,%rdi
  80130b:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  801312:	00 00 00 
  801315:	ff d0                	callq  *%rax
	return dst;
  801317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80131b:	c9                   	leaveq 
  80131c:	c3                   	retq   

000000000080131d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80131d:	55                   	push   %rbp
  80131e:	48 89 e5             	mov    %rsp,%rbp
  801321:	48 83 ec 28          	sub    $0x28,%rsp
  801325:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801339:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801340:	00 
  801341:	eb 27                	jmp    80136a <strncpy+0x4d>
		*dst++ = *src;
  801343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801347:	0f b6 10             	movzbl (%rax),%edx
  80134a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134e:	88 10                	mov    %dl,(%rax)
  801350:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	74 05                	je     801365 <strncpy+0x48>
			src++;
  801360:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801365:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801372:	72 cf                	jb     801343 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801378:	c9                   	leaveq 
  801379:	c3                   	retq   

000000000080137a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80137a:	55                   	push   %rbp
  80137b:	48 89 e5             	mov    %rsp,%rbp
  80137e:	48 83 ec 28          	sub    $0x28,%rsp
  801382:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801386:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801396:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80139b:	74 37                	je     8013d4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80139d:	eb 17                	jmp    8013b6 <strlcpy+0x3c>
			*dst++ = *src++;
  80139f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a3:	0f b6 10             	movzbl (%rax),%edx
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	88 10                	mov    %dl,(%rax)
  8013ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013b1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c0:	74 0b                	je     8013cd <strlcpy+0x53>
  8013c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c6:	0f b6 00             	movzbl (%rax),%eax
  8013c9:	84 c0                	test   %al,%al
  8013cb:	75 d2                	jne    80139f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dc:	48 89 d1             	mov    %rdx,%rcx
  8013df:	48 29 c1             	sub    %rax,%rcx
  8013e2:	48 89 c8             	mov    %rcx,%rax
}
  8013e5:	c9                   	leaveq 
  8013e6:	c3                   	retq   

00000000008013e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e7:	55                   	push   %rbp
  8013e8:	48 89 e5             	mov    %rsp,%rbp
  8013eb:	48 83 ec 10          	sub    $0x10,%rsp
  8013ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013f7:	eb 0a                	jmp    801403 <strcmp+0x1c>
		p++, q++;
  8013f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	84 c0                	test   %al,%al
  80140c:	74 12                	je     801420 <strcmp+0x39>
  80140e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801412:	0f b6 10             	movzbl (%rax),%edx
  801415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	38 c2                	cmp    %al,%dl
  80141e:	74 d9                	je     8013f9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	0f b6 d0             	movzbl %al,%edx
  80142a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 c0             	movzbl %al,%eax
  801434:	89 d1                	mov    %edx,%ecx
  801436:	29 c1                	sub    %eax,%ecx
  801438:	89 c8                	mov    %ecx,%eax
}
  80143a:	c9                   	leaveq 
  80143b:	c3                   	retq   

000000000080143c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 83 ec 18          	sub    $0x18,%rsp
  801444:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801448:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801450:	eb 0f                	jmp    801461 <strncmp+0x25>
		n--, p++, q++;
  801452:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801457:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801461:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801466:	74 1d                	je     801485 <strncmp+0x49>
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	84 c0                	test   %al,%al
  801471:	74 12                	je     801485 <strncmp+0x49>
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	0f b6 10             	movzbl (%rax),%edx
  80147a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147e:	0f b6 00             	movzbl (%rax),%eax
  801481:	38 c2                	cmp    %al,%dl
  801483:	74 cd                	je     801452 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801485:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148a:	75 07                	jne    801493 <strncmp+0x57>
		return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	eb 1a                	jmp    8014ad <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	0f b6 d0             	movzbl %al,%edx
  80149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	0f b6 c0             	movzbl %al,%eax
  8014a7:	89 d1                	mov    %edx,%ecx
  8014a9:	29 c1                	sub    %eax,%ecx
  8014ab:	89 c8                	mov    %ecx,%eax
}
  8014ad:	c9                   	leaveq 
  8014ae:	c3                   	retq   

00000000008014af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014af:	55                   	push   %rbp
  8014b0:	48 89 e5             	mov    %rsp,%rbp
  8014b3:	48 83 ec 10          	sub    $0x10,%rsp
  8014b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bb:	89 f0                	mov    %esi,%eax
  8014bd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014c0:	eb 17                	jmp    8014d9 <strchr+0x2a>
		if (*s == c)
  8014c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014cc:	75 06                	jne    8014d4 <strchr+0x25>
			return (char *) s;
  8014ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d2:	eb 15                	jmp    8014e9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	84 c0                	test   %al,%al
  8014e2:	75 de                	jne    8014c2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 10          	sub    $0x10,%rsp
  8014f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f7:	89 f0                	mov    %esi,%eax
  8014f9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014fc:	eb 11                	jmp    80150f <strfind+0x24>
		if (*s == c)
  8014fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801508:	74 12                	je     80151c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80150a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	84 c0                	test   %al,%al
  801518:	75 e4                	jne    8014fe <strfind+0x13>
  80151a:	eb 01                	jmp    80151d <strfind+0x32>
		if (*s == c)
			break;
  80151c:	90                   	nop
	return (char *) s;
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801521:	c9                   	leaveq 
  801522:	c3                   	retq   

0000000000801523 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	48 83 ec 18          	sub    $0x18,%rsp
  80152b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801532:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801536:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80153b:	75 06                	jne    801543 <memset+0x20>
		return v;
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	eb 69                	jmp    8015ac <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	83 e0 03             	and    $0x3,%eax
  80154a:	48 85 c0             	test   %rax,%rax
  80154d:	75 48                	jne    801597 <memset+0x74>
  80154f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801553:	83 e0 03             	and    $0x3,%eax
  801556:	48 85 c0             	test   %rax,%rax
  801559:	75 3c                	jne    801597 <memset+0x74>
		c &= 0xFF;
  80155b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801562:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801565:	89 c2                	mov    %eax,%edx
  801567:	c1 e2 18             	shl    $0x18,%edx
  80156a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156d:	c1 e0 10             	shl    $0x10,%eax
  801570:	09 c2                	or     %eax,%edx
  801572:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801575:	c1 e0 08             	shl    $0x8,%eax
  801578:	09 d0                	or     %edx,%eax
  80157a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80157d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801581:	48 89 c1             	mov    %rax,%rcx
  801584:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801588:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158f:	48 89 d7             	mov    %rdx,%rdi
  801592:	fc                   	cld    
  801593:	f3 ab                	rep stos %eax,%es:(%rdi)
  801595:	eb 11                	jmp    8015a8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801597:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80159e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015a2:	48 89 d7             	mov    %rdx,%rdi
  8015a5:	fc                   	cld    
  8015a6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ac:	c9                   	leaveq 
  8015ad:	c3                   	retq   

00000000008015ae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015ae:	55                   	push   %rbp
  8015af:	48 89 e5             	mov    %rsp,%rbp
  8015b2:	48 83 ec 28          	sub    $0x28,%rsp
  8015b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015da:	0f 83 88 00 00 00    	jae    801668 <memmove+0xba>
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e8:	48 01 d0             	add    %rdx,%rax
  8015eb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015ef:	76 77                	jbe    801668 <memmove+0xba>
		s += n;
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801605:	83 e0 03             	and    $0x3,%eax
  801608:	48 85 c0             	test   %rax,%rax
  80160b:	75 3b                	jne    801648 <memmove+0x9a>
  80160d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801611:	83 e0 03             	and    $0x3,%eax
  801614:	48 85 c0             	test   %rax,%rax
  801617:	75 2f                	jne    801648 <memmove+0x9a>
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	83 e0 03             	and    $0x3,%eax
  801620:	48 85 c0             	test   %rax,%rax
  801623:	75 23                	jne    801648 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801629:	48 83 e8 04          	sub    $0x4,%rax
  80162d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801631:	48 83 ea 04          	sub    $0x4,%rdx
  801635:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801639:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80163d:	48 89 c7             	mov    %rax,%rdi
  801640:	48 89 d6             	mov    %rdx,%rsi
  801643:	fd                   	std    
  801644:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801646:	eb 1d                	jmp    801665 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 89 d7             	mov    %rdx,%rdi
  80165f:	48 89 c1             	mov    %rax,%rcx
  801662:	fd                   	std    
  801663:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801665:	fc                   	cld    
  801666:	eb 57                	jmp    8016bf <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166c:	83 e0 03             	and    $0x3,%eax
  80166f:	48 85 c0             	test   %rax,%rax
  801672:	75 36                	jne    8016aa <memmove+0xfc>
  801674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801678:	83 e0 03             	and    $0x3,%eax
  80167b:	48 85 c0             	test   %rax,%rax
  80167e:	75 2a                	jne    8016aa <memmove+0xfc>
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	83 e0 03             	and    $0x3,%eax
  801687:	48 85 c0             	test   %rax,%rax
  80168a:	75 1e                	jne    8016aa <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	48 89 c1             	mov    %rax,%rcx
  801693:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169f:	48 89 c7             	mov    %rax,%rdi
  8016a2:	48 89 d6             	mov    %rdx,%rsi
  8016a5:	fc                   	cld    
  8016a6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a8:	eb 15                	jmp    8016bf <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b6:	48 89 c7             	mov    %rax,%rdi
  8016b9:	48 89 d6             	mov    %rdx,%rsi
  8016bc:	fc                   	cld    
  8016bd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 18          	sub    $0x18,%rsp
  8016cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016dd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	48 89 ce             	mov    %rcx,%rsi
  8016e8:	48 89 c7             	mov    %rax,%rdi
  8016eb:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8016f2:	00 00 00 
  8016f5:	ff d0                	callq  *%rax
}
  8016f7:	c9                   	leaveq 
  8016f8:	c3                   	retq   

00000000008016f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016f9:	55                   	push   %rbp
  8016fa:	48 89 e5             	mov    %rsp,%rbp
  8016fd:	48 83 ec 28          	sub    $0x28,%rsp
  801701:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801705:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801709:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80170d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801715:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801719:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80171d:	eb 38                	jmp    801757 <memcmp+0x5e>
		if (*s1 != *s2)
  80171f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801723:	0f b6 10             	movzbl (%rax),%edx
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	0f b6 00             	movzbl (%rax),%eax
  80172d:	38 c2                	cmp    %al,%dl
  80172f:	74 1c                	je     80174d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	0f b6 d0             	movzbl %al,%edx
  80173b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	89 d1                	mov    %edx,%ecx
  801747:	29 c1                	sub    %eax,%ecx
  801749:	89 c8                	mov    %ecx,%eax
  80174b:	eb 20                	jmp    80176d <memcmp+0x74>
		s1++, s2++;
  80174d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801752:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801757:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80175c:	0f 95 c0             	setne  %al
  80175f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801764:	84 c0                	test   %al,%al
  801766:	75 b7                	jne    80171f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 28          	sub    $0x28,%rsp
  801777:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80177b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80177e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178a:	48 01 d0             	add    %rdx,%rax
  80178d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801791:	eb 13                	jmp    8017a6 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801797:	0f b6 10             	movzbl (%rax),%edx
  80179a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80179d:	38 c2                	cmp    %al,%dl
  80179f:	74 11                	je     8017b2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017a1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017aa:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017ae:	72 e3                	jb     801793 <memfind+0x24>
  8017b0:	eb 01                	jmp    8017b3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017b2:	90                   	nop
	return (void *) s;
  8017b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017b7:	c9                   	leaveq 
  8017b8:	c3                   	retq   

00000000008017b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017b9:	55                   	push   %rbp
  8017ba:	48 89 e5             	mov    %rsp,%rbp
  8017bd:	48 83 ec 38          	sub    $0x38,%rsp
  8017c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017c9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017d3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017da:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017db:	eb 05                	jmp    8017e2 <strtol+0x29>
		s++;
  8017dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	0f b6 00             	movzbl (%rax),%eax
  8017e9:	3c 20                	cmp    $0x20,%al
  8017eb:	74 f0                	je     8017dd <strtol+0x24>
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	3c 09                	cmp    $0x9,%al
  8017f6:	74 e5                	je     8017dd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	3c 2b                	cmp    $0x2b,%al
  801801:	75 07                	jne    80180a <strtol+0x51>
		s++;
  801803:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801808:	eb 17                	jmp    801821 <strtol+0x68>
	else if (*s == '-')
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	3c 2d                	cmp    $0x2d,%al
  801813:	75 0c                	jne    801821 <strtol+0x68>
		s++, neg = 1;
  801815:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80181a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801821:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801825:	74 06                	je     80182d <strtol+0x74>
  801827:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80182b:	75 28                	jne    801855 <strtol+0x9c>
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 30                	cmp    $0x30,%al
  801836:	75 1d                	jne    801855 <strtol+0x9c>
  801838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183c:	48 83 c0 01          	add    $0x1,%rax
  801840:	0f b6 00             	movzbl (%rax),%eax
  801843:	3c 78                	cmp    $0x78,%al
  801845:	75 0e                	jne    801855 <strtol+0x9c>
		s += 2, base = 16;
  801847:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80184c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801853:	eb 2c                	jmp    801881 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801855:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801859:	75 19                	jne    801874 <strtol+0xbb>
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	3c 30                	cmp    $0x30,%al
  801864:	75 0e                	jne    801874 <strtol+0xbb>
		s++, base = 8;
  801866:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801872:	eb 0d                	jmp    801881 <strtol+0xc8>
	else if (base == 0)
  801874:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801878:	75 07                	jne    801881 <strtol+0xc8>
		base = 10;
  80187a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	3c 2f                	cmp    $0x2f,%al
  80188a:	7e 1d                	jle    8018a9 <strtol+0xf0>
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	3c 39                	cmp    $0x39,%al
  801895:	7f 12                	jg     8018a9 <strtol+0xf0>
			dig = *s - '0';
  801897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	0f be c0             	movsbl %al,%eax
  8018a1:	83 e8 30             	sub    $0x30,%eax
  8018a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018a7:	eb 4e                	jmp    8018f7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	3c 60                	cmp    $0x60,%al
  8018b2:	7e 1d                	jle    8018d1 <strtol+0x118>
  8018b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	3c 7a                	cmp    $0x7a,%al
  8018bd:	7f 12                	jg     8018d1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c3:	0f b6 00             	movzbl (%rax),%eax
  8018c6:	0f be c0             	movsbl %al,%eax
  8018c9:	83 e8 57             	sub    $0x57,%eax
  8018cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018cf:	eb 26                	jmp    8018f7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	0f b6 00             	movzbl (%rax),%eax
  8018d8:	3c 40                	cmp    $0x40,%al
  8018da:	7e 47                	jle    801923 <strtol+0x16a>
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	3c 5a                	cmp    $0x5a,%al
  8018e5:	7f 3c                	jg     801923 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	0f b6 00             	movzbl (%rax),%eax
  8018ee:	0f be c0             	movsbl %al,%eax
  8018f1:	83 e8 37             	sub    $0x37,%eax
  8018f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018fa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018fd:	7d 23                	jge    801922 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8018ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801904:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801907:	48 98                	cltq   
  801909:	48 89 c2             	mov    %rax,%rdx
  80190c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801911:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801914:	48 98                	cltq   
  801916:	48 01 d0             	add    %rdx,%rax
  801919:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80191d:	e9 5f ff ff ff       	jmpq   801881 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801922:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801923:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801928:	74 0b                	je     801935 <strtol+0x17c>
		*endptr = (char *) s;
  80192a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80192e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801932:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801935:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801939:	74 09                	je     801944 <strtol+0x18b>
  80193b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193f:	48 f7 d8             	neg    %rax
  801942:	eb 04                	jmp    801948 <strtol+0x18f>
  801944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <strstr>:

char * strstr(const char *in, const char *str)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	48 83 ec 30          	sub    $0x30,%rsp
  801952:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801956:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80195a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80195e:	0f b6 00             	movzbl (%rax),%eax
  801961:	88 45 ff             	mov    %al,-0x1(%rbp)
  801964:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801969:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80196d:	75 06                	jne    801975 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  80196f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801973:	eb 68                	jmp    8019dd <strstr+0x93>

	len = strlen(str);
  801975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801979:	48 89 c7             	mov    %rax,%rdi
  80197c:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  801983:	00 00 00 
  801986:	ff d0                	callq  *%rax
  801988:	48 98                	cltq   
  80198a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80198e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801992:	0f b6 00             	movzbl (%rax),%eax
  801995:	88 45 ef             	mov    %al,-0x11(%rbp)
  801998:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  80199d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019a1:	75 07                	jne    8019aa <strstr+0x60>
				return (char *) 0;
  8019a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a8:	eb 33                	jmp    8019dd <strstr+0x93>
		} while (sc != c);
  8019aa:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019ae:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019b1:	75 db                	jne    80198e <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8019b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	48 89 ce             	mov    %rcx,%rsi
  8019c2:	48 89 c7             	mov    %rax,%rdi
  8019c5:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 b9                	jne    80198e <strstr+0x44>

	return (char *) (in - 1);
  8019d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d9:	48 83 e8 01          	sub    $0x1,%rax
}
  8019dd:	c9                   	leaveq 
  8019de:	c3                   	retq   
	...

00000000008019e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019e0:	55                   	push   %rbp
  8019e1:	48 89 e5             	mov    %rsp,%rbp
  8019e4:	53                   	push   %rbx
  8019e5:	48 83 ec 58          	sub    $0x58,%rsp
  8019e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019ec:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019f3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019f7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019fb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a02:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801a05:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a09:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a0d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a11:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a15:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a19:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801a1c:	4c 89 c3             	mov    %r8,%rbx
  801a1f:	cd 30                	int    $0x30
  801a21:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801a25:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a31:	74 3e                	je     801a71 <syscall+0x91>
  801a33:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a38:	7e 37                	jle    801a71 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a41:	49 89 d0             	mov    %rdx,%r8
  801a44:	89 c1                	mov    %eax,%ecx
  801a46:	48 ba e8 4c 80 00 00 	movabs $0x804ce8,%rdx
  801a4d:	00 00 00 
  801a50:	be 23 00 00 00       	mov    $0x23,%esi
  801a55:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  801a5c:	00 00 00 
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	49 b9 80 04 80 00 00 	movabs $0x800480,%r9
  801a6b:	00 00 00 
  801a6e:	41 ff d1             	callq  *%r9

	return ret;
  801a71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a75:	48 83 c4 58          	add    $0x58,%rsp
  801a79:	5b                   	pop    %rbx
  801a7a:	5d                   	pop    %rbp
  801a7b:	c3                   	retq   

0000000000801a7c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	48 83 ec 20          	sub    $0x20,%rsp
  801a84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9b:	00 
  801a9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa8:	48 89 d1             	mov    %rdx,%rcx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 00 00 00 00       	mov    $0x0,%esi
  801ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab8:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ace:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad5:	00 
  801ad6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	be 00 00 00 00       	mov    $0x0,%esi
  801af1:	bf 01 00 00 00       	mov    $0x1,%edi
  801af6:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
}
  801b02:	c9                   	leaveq 
  801b03:	c3                   	retq   

0000000000801b04 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 20          	sub    $0x20,%rsp
  801b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b12:	48 98                	cltq   
  801b14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1b:	00 
  801b1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2d:	48 89 c2             	mov    %rax,%rdx
  801b30:	be 01 00 00 00       	mov    $0x1,%esi
  801b35:	bf 03 00 00 00       	mov    $0x3,%edi
  801b3a:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b57:	00 
  801b58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b69:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6e:	be 00 00 00 00       	mov    $0x0,%esi
  801b73:	bf 02 00 00 00       	mov    $0x2,%edi
  801b78:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	callq  *%rax
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <sys_yield>:

void
sys_yield(void)
{
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b95:	00 
  801b96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bac:	be 00 00 00 00       	mov    $0x0,%esi
  801bb1:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bb6:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
}
  801bc2:	c9                   	leaveq 
  801bc3:	c3                   	retq   

0000000000801bc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bc4:	55                   	push   %rbp
  801bc5:	48 89 e5             	mov    %rsp,%rbp
  801bc8:	48 83 ec 20          	sub    $0x20,%rsp
  801bcc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd9:	48 63 c8             	movslq %eax,%rcx
  801bdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be3:	48 98                	cltq   
  801be5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bec:	00 
  801bed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf3:	49 89 c8             	mov    %rcx,%r8
  801bf6:	48 89 d1             	mov    %rdx,%rcx
  801bf9:	48 89 c2             	mov    %rax,%rdx
  801bfc:	be 01 00 00 00       	mov    $0x1,%esi
  801c01:	bf 04 00 00 00       	mov    $0x4,%edi
  801c06:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 30          	sub    $0x30,%rsp
  801c1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c23:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c26:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c2a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c2e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c31:	48 63 c8             	movslq %eax,%rcx
  801c34:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c3b:	48 63 f0             	movslq %eax,%rsi
  801c3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c45:	48 98                	cltq   
  801c47:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c4b:	49 89 f9             	mov    %rdi,%r9
  801c4e:	49 89 f0             	mov    %rsi,%r8
  801c51:	48 89 d1             	mov    %rdx,%rcx
  801c54:	48 89 c2             	mov    %rax,%rdx
  801c57:	be 01 00 00 00       	mov    $0x1,%esi
  801c5c:	bf 05 00 00 00       	mov    $0x5,%edi
  801c61:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 20          	sub    $0x20,%rsp
  801c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c85:	48 98                	cltq   
  801c87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8e:	00 
  801c8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9b:	48 89 d1             	mov    %rdx,%rcx
  801c9e:	48 89 c2             	mov    %rax,%rdx
  801ca1:	be 01 00 00 00       	mov    $0x1,%esi
  801ca6:	bf 06 00 00 00       	mov    $0x6,%edi
  801cab:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801cb2:	00 00 00 
  801cb5:	ff d0                	callq  *%rax
}
  801cb7:	c9                   	leaveq 
  801cb8:	c3                   	retq   

0000000000801cb9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cb9:	55                   	push   %rbp
  801cba:	48 89 e5             	mov    %rsp,%rbp
  801cbd:	48 83 ec 20          	sub    $0x20,%rsp
  801cc1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801cc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cca:	48 63 d0             	movslq %eax,%rdx
  801ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd0:	48 98                	cltq   
  801cd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd9:	00 
  801cda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce6:	48 89 d1             	mov    %rdx,%rcx
  801ce9:	48 89 c2             	mov    %rax,%rdx
  801cec:	be 01 00 00 00       	mov    $0x1,%esi
  801cf1:	bf 08 00 00 00       	mov    $0x8,%edi
  801cf6:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801cfd:	00 00 00 
  801d00:	ff d0                	callq  *%rax
}
  801d02:	c9                   	leaveq 
  801d03:	c3                   	retq   

0000000000801d04 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d04:	55                   	push   %rbp
  801d05:	48 89 e5             	mov    %rsp,%rbp
  801d08:	48 83 ec 20          	sub    $0x20,%rsp
  801d0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1a:	48 98                	cltq   
  801d1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d23:	00 
  801d24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d30:	48 89 d1             	mov    %rdx,%rcx
  801d33:	48 89 c2             	mov    %rax,%rdx
  801d36:	be 01 00 00 00       	mov    $0x1,%esi
  801d3b:	bf 09 00 00 00       	mov    $0x9,%edi
  801d40:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
}
  801d4c:	c9                   	leaveq 
  801d4d:	c3                   	retq   

0000000000801d4e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 20          	sub    $0x20,%rsp
  801d56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d64:	48 98                	cltq   
  801d66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6d:	00 
  801d6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7a:	48 89 d1             	mov    %rdx,%rcx
  801d7d:	48 89 c2             	mov    %rax,%rdx
  801d80:	be 01 00 00 00       	mov    $0x1,%esi
  801d85:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d8a:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801d91:	00 00 00 
  801d94:	ff d0                	callq  *%rax
}
  801d96:	c9                   	leaveq 
  801d97:	c3                   	retq   

0000000000801d98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d98:	55                   	push   %rbp
  801d99:	48 89 e5             	mov    %rsp,%rbp
  801d9c:	48 83 ec 30          	sub    $0x30,%rsp
  801da0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dab:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db1:	48 63 f0             	movslq %eax,%rsi
  801db4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	48 98                	cltq   
  801dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc8:	00 
  801dc9:	49 89 f1             	mov    %rsi,%r9
  801dcc:	49 89 c8             	mov    %rcx,%r8
  801dcf:	48 89 d1             	mov    %rdx,%rcx
  801dd2:	48 89 c2             	mov    %rax,%rdx
  801dd5:	be 00 00 00 00       	mov    $0x0,%esi
  801dda:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ddf:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	callq  *%rax
}
  801deb:	c9                   	leaveq 
  801dec:	c3                   	retq   

0000000000801ded <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ded:	55                   	push   %rbp
  801dee:	48 89 e5             	mov    %rsp,%rbp
  801df1:	48 83 ec 20          	sub    $0x20,%rsp
  801df5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801df9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e04:	00 
  801e05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e16:	48 89 c2             	mov    %rax,%rdx
  801e19:	be 01 00 00 00       	mov    $0x1,%esi
  801e1e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e23:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	callq  *%rax
}
  801e2f:	c9                   	leaveq 
  801e30:	c3                   	retq   

0000000000801e31 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e31:	55                   	push   %rbp
  801e32:	48 89 e5             	mov    %rsp,%rbp
  801e35:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e40:	00 
  801e41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	be 00 00 00 00       	mov    $0x0,%esi
  801e5c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e61:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	callq  *%rax
}
  801e6d:	c9                   	leaveq 
  801e6e:	c3                   	retq   

0000000000801e6f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
  801e73:	48 83 ec 30          	sub    $0x30,%rsp
  801e77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e81:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e85:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e89:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e8c:	48 63 c8             	movslq %eax,%rcx
  801e8f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e96:	48 63 f0             	movslq %eax,%rsi
  801e99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea0:	48 98                	cltq   
  801ea2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ea6:	49 89 f9             	mov    %rdi,%r9
  801ea9:	49 89 f0             	mov    %rsi,%r8
  801eac:	48 89 d1             	mov    %rdx,%rcx
  801eaf:	48 89 c2             	mov    %rax,%rdx
  801eb2:	be 00 00 00 00       	mov    $0x0,%esi
  801eb7:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ebc:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ec8:	c9                   	leaveq 
  801ec9:	c3                   	retq   

0000000000801eca <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	48 83 ec 20          	sub    $0x20,%rsp
  801ed2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ed6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801eda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee9:	00 
  801eea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef6:	48 89 d1             	mov    %rdx,%rcx
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	be 00 00 00 00       	mov    $0x0,%esi
  801f01:	bf 10 00 00 00       	mov    $0x10,%edi
  801f06:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	callq  *%rax
}
  801f12:	c9                   	leaveq 
  801f13:	c3                   	retq   

0000000000801f14 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f14:	55                   	push   %rbp
  801f15:	48 89 e5             	mov    %rsp,%rbp
  801f18:	48 83 ec 40          	sub    $0x40,%rsp
  801f1c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f24:	48 8b 00             	mov    (%rax),%rax
  801f27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f2f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f33:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3a:	48 89 c2             	mov    %rax,%rdx
  801f3d:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f41:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f48:	01 00 00 
  801f4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801f53:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f56:	83 e0 02             	and    $0x2,%eax
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	0f 84 4f 01 00 00    	je     8020b0 <pgfault+0x19c>
  801f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f65:	48 89 c2             	mov    %rax,%rdx
  801f68:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f73:	01 00 00 
  801f76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7a:	25 00 08 00 00       	and    $0x800,%eax
  801f7f:	48 85 c0             	test   %rax,%rax
  801f82:	0f 84 28 01 00 00    	je     8020b0 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801f88:	ba 07 00 00 00       	mov    $0x7,%edx
  801f8d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f92:	bf 00 00 00 00       	mov    $0x0,%edi
  801f97:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 85 db 00 00 00    	jne    802086 <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801faf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fbd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801fc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fca:	48 89 c6             	mov    %rax,%rsi
  801fcd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fd2:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801fde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fe8:	48 89 c1             	mov    %rax,%rcx
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ff5:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffa:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802001:	00 00 00 
  802004:	ff d0                	callq  *%rax
  802006:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  802009:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80200d:	79 2a                	jns    802039 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  80200f:	48 ba 18 4d 80 00 00 	movabs $0x804d18,%rdx
  802016:	00 00 00 
  802019:	be 28 00 00 00       	mov    $0x28,%esi
  80201e:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802025:	00 00 00 
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802034:	00 00 00 
  802037:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  802039:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80203e:	bf 00 00 00 00       	mov    $0x0,%edi
  802043:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
  80204f:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  802052:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802056:	0f 89 84 00 00 00    	jns    8020e0 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  80205c:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  802063:	00 00 00 
  802066:	be 2c 00 00 00       	mov    $0x2c,%esi
  80206b:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802072:	00 00 00 
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802081:	00 00 00 
  802084:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  802086:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  80208d:	00 00 00 
  802090:	be 31 00 00 00       	mov    $0x31,%esi
  802095:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  80209c:	00 00 00 
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  8020ab:	00 00 00 
  8020ae:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  8020b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b3:	89 c1                	mov    %eax,%ecx
  8020b5:	48 ba aa 4d 80 00 00 	movabs $0x804daa,%rdx
  8020bc:	00 00 00 
  8020bf:	be 35 00 00 00       	mov    $0x35,%esi
  8020c4:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8020cb:	00 00 00 
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8020da:	00 00 00 
  8020dd:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  8020e0:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  8020e1:	c9                   	leaveq 
  8020e2:	c3                   	retq   

00000000008020e3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020e3:	55                   	push   %rbp
  8020e4:	48 89 e5             	mov    %rsp,%rbp
  8020e7:	48 83 ec 30          	sub    $0x30,%rsp
  8020eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020ee:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  8020f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f8:	01 00 00 
  8020fb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802102:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  802106:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802109:	48 c1 e0 0c          	shl    $0xc,%rax
  80210d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802115:	25 07 0e 00 00       	and    $0xe07,%eax
  80211a:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  80211d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802120:	25 00 04 00 00       	and    $0x400,%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	74 62                	je     80218b <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  802129:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80212c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802130:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802137:	41 89 f0             	mov    %esi,%r8d
  80213a:	48 89 c6             	mov    %rax,%rsi
  80213d:	bf 00 00 00 00       	mov    $0x0,%edi
  802142:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802149:	00 00 00 
  80214c:	ff d0                	callq  *%rax
  80214e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802151:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802155:	0f 89 78 01 00 00    	jns    8022d3 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80215b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80215e:	89 c1                	mov    %eax,%ecx
  802160:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  802167:	00 00 00 
  80216a:	be 4f 00 00 00       	mov    $0x4f,%esi
  80216f:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802176:	00 00 00 
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  802185:	00 00 00 
  802188:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  80218b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80218e:	25 00 08 00 00       	and    $0x800,%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	75 0e                	jne    8021a5 <duppage+0xc2>
  802197:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80219a:	83 e0 02             	and    $0x2,%eax
  80219d:	85 c0                	test   %eax,%eax
  80219f:	0f 84 d0 00 00 00    	je     802275 <duppage+0x192>
		perm &= ~PTE_W;
  8021a5:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  8021a9:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  8021b0:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8021b3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021be:	41 89 f0             	mov    %esi,%r8d
  8021c1:	48 89 c6             	mov    %rax,%rsi
  8021c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c9:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8021d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021dc:	79 30                	jns    80220e <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  8021de:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021e1:	89 c1                	mov    %eax,%ecx
  8021e3:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  8021ea:	00 00 00 
  8021ed:	be 57 00 00 00       	mov    $0x57,%esi
  8021f2:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8021f9:	00 00 00 
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  802208:	00 00 00 
  80220b:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  80220e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802219:	41 89 c8             	mov    %ecx,%r8d
  80221c:	48 89 d1             	mov    %rdx,%rcx
  80221f:	ba 00 00 00 00       	mov    $0x0,%edx
  802224:	48 89 c6             	mov    %rax,%rsi
  802227:	bf 00 00 00 00       	mov    $0x0,%edi
  80222c:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802233:	00 00 00 
  802236:	ff d0                	callq  *%rax
  802238:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80223b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80223f:	0f 89 8e 00 00 00    	jns    8022d3 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802245:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802248:	89 c1                	mov    %eax,%ecx
  80224a:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  802251:	00 00 00 
  802254:	be 5b 00 00 00       	mov    $0x5b,%esi
  802259:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802260:	00 00 00 
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  80226f:	00 00 00 
  802272:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  802275:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802278:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80227c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80227f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802283:	41 89 f0             	mov    %esi,%r8d
  802286:	48 89 c6             	mov    %rax,%rsi
  802289:	bf 00 00 00 00       	mov    $0x0,%edi
  80228e:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80229d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8022a1:	79 30                	jns    8022d3 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8022a3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022a6:	89 c1                	mov    %eax,%ecx
  8022a8:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  8022af:	00 00 00 
  8022b2:	be 61 00 00 00       	mov    $0x61,%esi
  8022b7:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8022be:	00 00 00 
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8022cd:	00 00 00 
  8022d0:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d8:	c9                   	leaveq 
  8022d9:	c3                   	retq   

00000000008022da <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022da:	55                   	push   %rbp
  8022db:	48 89 e5             	mov    %rsp,%rbp
  8022de:	53                   	push   %rbx
  8022df:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  8022e3:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  8022ea:	48 bf 14 1f 80 00 00 	movabs $0x801f14,%rdi
  8022f1:	00 00 00 
  8022f4:	48 b8 4c 45 80 00 00 	movabs $0x80454c,%rax
  8022fb:	00 00 00 
  8022fe:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802300:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  802307:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80230a:	cd 30                	int    $0x30
  80230c:	89 c3                	mov    %eax,%ebx
  80230e:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802311:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802314:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  802317:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80231b:	79 30                	jns    80234d <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  80231d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802320:	89 c1                	mov    %eax,%ecx
  802322:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  802329:	00 00 00 
  80232c:	be 80 00 00 00       	mov    $0x80,%esi
  802331:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802338:	00 00 00 
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  802347:	00 00 00 
  80234a:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  80234d:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802351:	75 52                	jne    8023a5 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  802353:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
  80235f:	48 98                	cltq   
  802361:	48 89 c2             	mov    %rax,%rdx
  802364:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80236a:	48 89 d0             	mov    %rdx,%rax
  80236d:	48 c1 e0 02          	shl    $0x2,%rax
  802371:	48 01 d0             	add    %rdx,%rax
  802374:	48 01 c0             	add    %rax,%rax
  802377:	48 01 d0             	add    %rdx,%rax
  80237a:	48 c1 e0 05          	shl    $0x5,%rax
  80237e:	48 89 c2             	mov    %rax,%rdx
  802381:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802388:	00 00 00 
  80238b:	48 01 c2             	add    %rax,%rdx
  80238e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802395:	00 00 00 
  802398:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a0:	e9 9d 02 00 00       	jmpq   802642 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  8023a5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8023a8:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ad:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023b2:	89 c7                	mov    %eax,%edi
  8023b4:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	callq  *%rax
  8023c0:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8023c3:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8023c7:	79 30                	jns    8023f9 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  8023c9:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8023cc:	89 c1                	mov    %eax,%ecx
  8023ce:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8023d5:	00 00 00 
  8023d8:	be 88 00 00 00       	mov    $0x88,%esi
  8023dd:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8023e4:	00 00 00 
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8023f3:	00 00 00 
  8023f6:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  8023f9:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802400:	00 
	uint64_t each_pte = 0;
  802401:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802408:	00 
	uint64_t each_pdpe = 0;
  802409:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802410:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802411:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802418:	00 
  802419:	e9 73 01 00 00       	jmpq   802591 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  80241e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802425:	01 00 00 
  802428:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80242c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802430:	83 e0 01             	and    $0x1,%eax
  802433:	84 c0                	test   %al,%al
  802435:	0f 84 41 01 00 00    	je     80257c <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80243b:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802442:	00 
  802443:	e9 24 01 00 00       	jmpq   80256c <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  802448:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80244f:	01 00 00 
  802452:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802456:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245a:	83 e0 01             	and    $0x1,%eax
  80245d:	84 c0                	test   %al,%al
  80245f:	0f 84 ed 00 00 00    	je     802552 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802465:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80246c:	00 
  80246d:	e9 d0 00 00 00       	jmpq   802542 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  802472:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802479:	01 00 00 
  80247c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802480:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802484:	83 e0 01             	and    $0x1,%eax
  802487:	84 c0                	test   %al,%al
  802489:	0f 84 99 00 00 00    	je     802528 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80248f:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802496:	00 
  802497:	eb 7f                	jmp    802518 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802499:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a0:	01 00 00 
  8024a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ab:	83 e0 01             	and    $0x1,%eax
  8024ae:	84 c0                	test   %al,%al
  8024b0:	74 5c                	je     80250e <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  8024b2:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  8024b9:	00 
  8024ba:	74 52                	je     80250e <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  8024bc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024c0:	89 c2                	mov    %eax,%edx
  8024c2:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8024c5:	89 d6                	mov    %edx,%esi
  8024c7:	89 c7                	mov    %eax,%edi
  8024c9:	48 b8 e3 20 80 00 00 	movabs $0x8020e3,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8024d8:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8024dc:	79 30                	jns    80250e <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  8024de:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8024e1:	89 c1                	mov    %eax,%ecx
  8024e3:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8024ea:	00 00 00 
  8024ed:	be a0 00 00 00       	mov    $0xa0,%esi
  8024f2:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8024f9:	00 00 00 
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  802508:	00 00 00 
  80250b:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80250e:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802513:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  802518:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  80251f:	00 
  802520:	0f 86 73 ff ff ff    	jbe    802499 <fork+0x1bf>
  802526:	eb 10                	jmp    802538 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  802528:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80252c:	48 83 c0 01          	add    $0x1,%rax
  802530:	48 c1 e0 09          	shl    $0x9,%rax
  802534:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802538:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80253d:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  802542:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802549:	00 
  80254a:	0f 86 22 ff ff ff    	jbe    802472 <fork+0x198>
  802550:	eb 10                	jmp    802562 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  802552:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802556:	48 83 c0 01          	add    $0x1,%rax
  80255a:	48 c1 e0 09          	shl    $0x9,%rax
  80255e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802562:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802567:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  80256c:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802573:	00 
  802574:	0f 86 ce fe ff ff    	jbe    802448 <fork+0x16e>
  80257a:	eb 10                	jmp    80258c <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  80257c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802580:	48 83 c0 01          	add    $0x1,%rax
  802584:	48 c1 e0 09          	shl    $0x9,%rax
  802588:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  80258c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802591:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802596:	0f 84 82 fe ff ff    	je     80241e <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80259c:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80259f:	48 be e4 45 80 00 00 	movabs $0x8045e4,%rsi
  8025a6:	00 00 00 
  8025a9:	89 c7                	mov    %eax,%edi
  8025ab:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax
  8025b7:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8025ba:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8025be:	79 30                	jns    8025f0 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  8025c0:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8025c3:	89 c1                	mov    %eax,%ecx
  8025c5:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8025cc:	00 00 00 
  8025cf:	be bd 00 00 00       	mov    $0xbd,%esi
  8025d4:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8025db:	00 00 00 
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8025ea:	00 00 00 
  8025ed:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8025f0:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8025f3:	be 02 00 00 00       	mov    $0x2,%esi
  8025f8:	89 c7                	mov    %eax,%edi
  8025fa:	48 b8 b9 1c 80 00 00 	movabs $0x801cb9,%rax
  802601:	00 00 00 
  802604:	ff d0                	callq  *%rax
  802606:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802609:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80260d:	79 30                	jns    80263f <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  80260f:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802612:	89 c1                	mov    %eax,%ecx
  802614:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  80261b:	00 00 00 
  80261e:	be c1 00 00 00       	mov    $0xc1,%esi
  802623:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  80262a:	00 00 00 
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  802639:	00 00 00 
  80263c:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  80263f:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  802642:	48 83 c4 68          	add    $0x68,%rsp
  802646:	5b                   	pop    %rbx
  802647:	5d                   	pop    %rbp
  802648:	c3                   	retq   

0000000000802649 <sfork>:

// Challenge!
int
sfork(void)
{
  802649:	55                   	push   %rbp
  80264a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80264d:	48 ba 04 4e 80 00 00 	movabs $0x804e04,%rdx
  802654:	00 00 00 
  802657:	be cc 00 00 00       	mov    $0xcc,%esi
  80265c:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802663:	00 00 00 
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
  80266b:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802672:	00 00 00 
  802675:	ff d1                	callq  *%rcx
	...

0000000000802678 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802678:	55                   	push   %rbp
  802679:	48 89 e5             	mov    %rsp,%rbp
  80267c:	48 83 ec 30          	sub    $0x30,%rsp
  802680:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802684:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802688:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  80268c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  802693:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802698:	74 18                	je     8026b2 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  80269a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80269e:	48 89 c7             	mov    %rax,%rdi
  8026a1:	48 b8 ed 1d 80 00 00 	movabs $0x801ded,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b0:	eb 19                	jmp    8026cb <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8026b2:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8026b9:	00 00 00 
  8026bc:	48 b8 ed 1d 80 00 00 	movabs $0x801ded,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8026cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cf:	79 39                	jns    80270a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8026d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026d6:	75 08                	jne    8026e0 <ipc_recv+0x68>
  8026d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dc:	8b 00                	mov    (%rax),%eax
  8026de:	eb 05                	jmp    8026e5 <ipc_recv+0x6d>
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026e9:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8026eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026f0:	75 08                	jne    8026fa <ipc_recv+0x82>
  8026f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	eb 05                	jmp    8026ff <ipc_recv+0x87>
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802703:	89 02                	mov    %eax,(%rdx)
		return r;
  802705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802708:	eb 53                	jmp    80275d <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80270a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80270f:	74 19                	je     80272a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  802711:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802718:	00 00 00 
  80271b:	48 8b 00             	mov    (%rax),%rax
  80271e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802728:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80272a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80272f:	74 19                	je     80274a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  802731:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802738:	00 00 00 
  80273b:	48 8b 00             	mov    (%rax),%rax
  80273e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802748:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80274a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802751:	00 00 00 
  802754:	48 8b 00             	mov    (%rax),%rax
  802757:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  80275d:	c9                   	leaveq 
  80275e:	c3                   	retq   

000000000080275f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
  802763:	48 83 ec 30          	sub    $0x30,%rsp
  802767:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80276a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80276d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802771:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  802774:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  80277b:	eb 59                	jmp    8027d6 <ipc_send+0x77>
		if(pg) {
  80277d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802782:	74 20                	je     8027a4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  802784:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802787:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80278a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80278e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	eb 26                	jmp    8027ca <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8027a4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8027a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ad:	89 d1                	mov    %edx,%ecx
  8027af:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8027b6:	00 00 00 
  8027b9:	89 c7                	mov    %eax,%edi
  8027bb:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8027ca:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8027d6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8027da:	74 a1                	je     80277d <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8027dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e0:	74 2a                	je     80280c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8027e2:	48 ba 20 4e 80 00 00 	movabs $0x804e20,%rdx
  8027e9:	00 00 00 
  8027ec:	be 49 00 00 00       	mov    $0x49,%esi
  8027f1:	48 bf 4b 4e 80 00 00 	movabs $0x804e4b,%rdi
  8027f8:	00 00 00 
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802807:	00 00 00 
  80280a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80280c:	c9                   	leaveq 
  80280d:	c3                   	retq   

000000000080280e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80280e:	55                   	push   %rbp
  80280f:	48 89 e5             	mov    %rsp,%rbp
  802812:	48 83 ec 18          	sub    $0x18,%rsp
  802816:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802819:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802820:	eb 6a                	jmp    80288c <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  802822:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802829:	00 00 00 
  80282c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282f:	48 63 d0             	movslq %eax,%rdx
  802832:	48 89 d0             	mov    %rdx,%rax
  802835:	48 c1 e0 02          	shl    $0x2,%rax
  802839:	48 01 d0             	add    %rdx,%rax
  80283c:	48 01 c0             	add    %rax,%rax
  80283f:	48 01 d0             	add    %rdx,%rax
  802842:	48 c1 e0 05          	shl    $0x5,%rax
  802846:	48 01 c8             	add    %rcx,%rax
  802849:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80284f:	8b 00                	mov    (%rax),%eax
  802851:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802854:	75 32                	jne    802888 <ipc_find_env+0x7a>
			return envs[i].env_id;
  802856:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80285d:	00 00 00 
  802860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802863:	48 63 d0             	movslq %eax,%rdx
  802866:	48 89 d0             	mov    %rdx,%rax
  802869:	48 c1 e0 02          	shl    $0x2,%rax
  80286d:	48 01 d0             	add    %rdx,%rax
  802870:	48 01 c0             	add    %rax,%rax
  802873:	48 01 d0             	add    %rdx,%rax
  802876:	48 c1 e0 05          	shl    $0x5,%rax
  80287a:	48 01 c8             	add    %rcx,%rax
  80287d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802883:	8b 40 08             	mov    0x8(%rax),%eax
  802886:	eb 12                	jmp    80289a <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802893:	7e 8d                	jle    802822 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289a:	c9                   	leaveq 
  80289b:	c3                   	retq   

000000000080289c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
  8028a0:	48 83 ec 08          	sub    $0x8,%rsp
  8028a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028b3:	ff ff ff 
  8028b6:	48 01 d0             	add    %rdx,%rax
  8028b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028bd:	c9                   	leaveq 
  8028be:	c3                   	retq   

00000000008028bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028bf:	55                   	push   %rbp
  8028c0:	48 89 e5             	mov    %rsp,%rbp
  8028c3:	48 83 ec 08          	sub    $0x8,%rsp
  8028c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028e8:	c9                   	leaveq 
  8028e9:	c3                   	retq   

00000000008028ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028ea:	55                   	push   %rbp
  8028eb:	48 89 e5             	mov    %rsp,%rbp
  8028ee:	48 83 ec 18          	sub    $0x18,%rsp
  8028f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fd:	eb 6b                	jmp    80296a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802902:	48 98                	cltq   
  802904:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80290a:	48 c1 e0 0c          	shl    $0xc,%rax
  80290e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802916:	48 89 c2             	mov    %rax,%rdx
  802919:	48 c1 ea 15          	shr    $0x15,%rdx
  80291d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802924:	01 00 00 
  802927:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292b:	83 e0 01             	and    $0x1,%eax
  80292e:	48 85 c0             	test   %rax,%rax
  802931:	74 21                	je     802954 <fd_alloc+0x6a>
  802933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802937:	48 89 c2             	mov    %rax,%rdx
  80293a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80293e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802945:	01 00 00 
  802948:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294c:	83 e0 01             	and    $0x1,%eax
  80294f:	48 85 c0             	test   %rax,%rax
  802952:	75 12                	jne    802966 <fd_alloc+0x7c>
			*fd_store = fd;
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	eb 1a                	jmp    802980 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80296a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80296e:	7e 8f                	jle    8028ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802974:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80297b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802980:	c9                   	leaveq 
  802981:	c3                   	retq   

0000000000802982 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802982:	55                   	push   %rbp
  802983:	48 89 e5             	mov    %rsp,%rbp
  802986:	48 83 ec 20          	sub    $0x20,%rsp
  80298a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80298d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802991:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802995:	78 06                	js     80299d <fd_lookup+0x1b>
  802997:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80299b:	7e 07                	jle    8029a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80299d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a2:	eb 6c                	jmp    802a10 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a7:	48 98                	cltq   
  8029a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029af:	48 c1 e0 0c          	shl    $0xc,%rax
  8029b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029bb:	48 89 c2             	mov    %rax,%rdx
  8029be:	48 c1 ea 15          	shr    $0x15,%rdx
  8029c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029c9:	01 00 00 
  8029cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d0:	83 e0 01             	and    $0x1,%eax
  8029d3:	48 85 c0             	test   %rax,%rax
  8029d6:	74 21                	je     8029f9 <fd_lookup+0x77>
  8029d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029dc:	48 89 c2             	mov    %rax,%rdx
  8029df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ea:	01 00 00 
  8029ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f1:	83 e0 01             	and    $0x1,%eax
  8029f4:	48 85 c0             	test   %rax,%rax
  8029f7:	75 07                	jne    802a00 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029fe:	eb 10                	jmp    802a10 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a08:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 30          	sub    $0x30,%rsp
  802a1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a1e:	89 f0                	mov    %esi,%eax
  802a20:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3a:	48 89 d6             	mov    %rdx,%rsi
  802a3d:	89 c7                	mov    %eax,%edi
  802a3f:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	78 0a                	js     802a5e <fd_close+0x4c>
	    || fd != fd2)
  802a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a58:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a5c:	74 12                	je     802a70 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a5e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a62:	74 05                	je     802a69 <fd_close+0x57>
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	eb 05                	jmp    802a6e <fd_close+0x5c>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	eb 69                	jmp    802ad9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a74:	8b 00                	mov    (%rax),%eax
  802a76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7a:	48 89 d6             	mov    %rdx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a92:	78 2a                	js     802abe <fd_close+0xac>
		if (dev->dev_close)
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a9c:	48 85 c0             	test   %rax,%rax
  802a9f:	74 16                	je     802ab7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802aa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aad:	48 89 c7             	mov    %rax,%rdi
  802ab0:	ff d2                	callq  *%rdx
  802ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab5:	eb 07                	jmp    802abe <fd_close+0xac>
		else
			r = 0;
  802ab7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
	return r;
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ad9:	c9                   	leaveq 
  802ada:	c3                   	retq   

0000000000802adb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 20          	sub    $0x20,%rsp
  802ae3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802aea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af1:	eb 41                	jmp    802b34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802af3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802afa:	00 00 00 
  802afd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b00:	48 63 d2             	movslq %edx,%rdx
  802b03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b07:	8b 00                	mov    (%rax),%eax
  802b09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b0c:	75 22                	jne    802b30 <dev_lookup+0x55>
			*dev = devtab[i];
  802b0e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b15:	00 00 00 
  802b18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b1b:	48 63 d2             	movslq %edx,%rdx
  802b1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	eb 60                	jmp    802b90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b34:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b3b:	00 00 00 
  802b3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b41:	48 63 d2             	movslq %edx,%rdx
  802b44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b48:	48 85 c0             	test   %rax,%rax
  802b4b:	75 a6                	jne    802af3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b4d:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802b54:	00 00 00 
  802b57:	48 8b 00             	mov    (%rax),%rax
  802b5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b63:	89 c6                	mov    %eax,%esi
  802b65:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	48 b9 bb 06 80 00 00 	movabs $0x8006bb,%rcx
  802b7b:	00 00 00 
  802b7e:	ff d1                	callq  *%rcx
	*dev = 0;
  802b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <close>:

int
close(int fdnum)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 20          	sub    $0x20,%rsp
  802b9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	79 05                	jns    802bc3 <close+0x31>
		return r;
  802bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc1:	eb 18                	jmp    802bdb <close+0x49>
	else
		return fd_close(fd, 1);
  802bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc7:	be 01 00 00 00       	mov    $0x1,%esi
  802bcc:	48 89 c7             	mov    %rax,%rdi
  802bcf:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <close_all>:

void
close_all(void)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bec:	eb 15                	jmp    802c03 <close_all+0x26>
		close(i);
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802bff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c07:	7e e5                	jle    802bee <close_all+0x11>
		close(i);
}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 40          	sub    $0x40,%rsp
  802c13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c16:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c19:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c1d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c20:	48 89 d6             	mov    %rdx,%rsi
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c38:	79 08                	jns    802c42 <dup+0x37>
		return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	e9 70 01 00 00       	jmpq   802db2 <dup+0x1a7>
	close(newfdnum);
  802c42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c45:	89 c7                	mov    %eax,%edi
  802c47:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c56:	48 98                	cltq   
  802c58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c5e:	48 c1 e0 0c          	shl    $0xc,%rax
  802c62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c81:	48 89 c7             	mov    %rax,%rdi
  802c84:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
  802c90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c98:	48 89 c2             	mov    %rax,%rdx
  802c9b:	48 c1 ea 15          	shr    $0x15,%rdx
  802c9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ca6:	01 00 00 
  802ca9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cad:	83 e0 01             	and    $0x1,%eax
  802cb0:	84 c0                	test   %al,%al
  802cb2:	74 71                	je     802d25 <dup+0x11a>
  802cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb8:	48 89 c2             	mov    %rax,%rdx
  802cbb:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cbf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc6:	01 00 00 
  802cc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ccd:	83 e0 01             	and    $0x1,%eax
  802cd0:	84 c0                	test   %al,%al
  802cd2:	74 51                	je     802d25 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd8:	48 89 c2             	mov    %rax,%rdx
  802cdb:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cdf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ce6:	01 00 00 
  802ce9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ced:	89 c1                	mov    %eax,%ecx
  802cef:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802cf5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfd:	41 89 c8             	mov    %ecx,%r8d
  802d00:	48 89 d1             	mov    %rdx,%rcx
  802d03:	ba 00 00 00 00       	mov    $0x0,%edx
  802d08:	48 89 c6             	mov    %rax,%rsi
  802d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d10:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
  802d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d23:	78 56                	js     802d7b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d29:	48 89 c2             	mov    %rax,%rdx
  802d2c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d37:	01 00 00 
  802d3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d3e:	89 c1                	mov    %eax,%ecx
  802d40:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d4e:	41 89 c8             	mov    %ecx,%r8d
  802d51:	48 89 d1             	mov    %rdx,%rcx
  802d54:	ba 00 00 00 00       	mov    $0x0,%edx
  802d59:	48 89 c6             	mov    %rax,%rsi
  802d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d61:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
  802d6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d74:	78 08                	js     802d7e <dup+0x173>
		goto err;

	return newfdnum;
  802d76:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d79:	eb 37                	jmp    802db2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802d7b:	90                   	nop
  802d7c:	eb 01                	jmp    802d7f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802d7e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d83:	48 89 c6             	mov    %rax,%rsi
  802d86:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8b:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9b:	48 89 c6             	mov    %rax,%rsi
  802d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802da3:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
	return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802db2:	c9                   	leaveq 
  802db3:	c3                   	retq   

0000000000802db4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802db4:	55                   	push   %rbp
  802db5:	48 89 e5             	mov    %rsp,%rbp
  802db8:	48 83 ec 40          	sub    $0x40,%rsp
  802dbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dc3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dc7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dcb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dce:	48 89 d6             	mov    %rdx,%rsi
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
  802ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de6:	78 24                	js     802e0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dec:	8b 00                	mov    (%rax),%eax
  802dee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df2:	48 89 d6             	mov    %rdx,%rsi
  802df5:	89 c7                	mov    %eax,%edi
  802df7:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
  802e03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0a:	79 05                	jns    802e11 <read+0x5d>
		return r;
  802e0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0f:	eb 7a                	jmp    802e8b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e15:	8b 40 08             	mov    0x8(%rax),%eax
  802e18:	83 e0 03             	and    $0x3,%eax
  802e1b:	83 f8 01             	cmp    $0x1,%eax
  802e1e:	75 3a                	jne    802e5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e20:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802e27:	00 00 00 
  802e2a:	48 8b 00             	mov    (%rax),%rax
  802e2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e36:	89 c6                	mov    %eax,%esi
  802e38:	48 bf 77 4e 80 00 00 	movabs $0x804e77,%rdi
  802e3f:	00 00 00 
  802e42:	b8 00 00 00 00       	mov    $0x0,%eax
  802e47:	48 b9 bb 06 80 00 00 	movabs $0x8006bb,%rcx
  802e4e:	00 00 00 
  802e51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e58:	eb 31                	jmp    802e8b <read+0xd7>
	}
	if (!dev->dev_read)
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e62:	48 85 c0             	test   %rax,%rax
  802e65:	75 07                	jne    802e6e <read+0xba>
		return -E_NOT_SUPP;
  802e67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e6c:	eb 1d                	jmp    802e8b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e7e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e82:	48 89 ce             	mov    %rcx,%rsi
  802e85:	48 89 c7             	mov    %rax,%rdi
  802e88:	41 ff d0             	callq  *%r8
}
  802e8b:	c9                   	leaveq 
  802e8c:	c3                   	retq   

0000000000802e8d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e8d:	55                   	push   %rbp
  802e8e:	48 89 e5             	mov    %rsp,%rbp
  802e91:	48 83 ec 30          	sub    $0x30,%rsp
  802e95:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ea0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ea7:	eb 46                	jmp    802eef <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	48 98                	cltq   
  802eae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eb2:	48 29 c2             	sub    %rax,%rdx
  802eb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb8:	48 98                	cltq   
  802eba:	48 89 c1             	mov    %rax,%rcx
  802ebd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802ec1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec4:	48 89 ce             	mov    %rcx,%rsi
  802ec7:	89 c7                	mov    %eax,%edi
  802ec9:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  802ed0:	00 00 00 
  802ed3:	ff d0                	callq  *%rax
  802ed5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ed8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802edc:	79 05                	jns    802ee3 <readn+0x56>
			return m;
  802ede:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ee1:	eb 1d                	jmp    802f00 <readn+0x73>
		if (m == 0)
  802ee3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ee7:	74 13                	je     802efc <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ee9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eec:	01 45 fc             	add    %eax,-0x4(%rbp)
  802eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef2:	48 98                	cltq   
  802ef4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ef8:	72 af                	jb     802ea9 <readn+0x1c>
  802efa:	eb 01                	jmp    802efd <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802efc:	90                   	nop
	}
	return tot;
  802efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f00:	c9                   	leaveq 
  802f01:	c3                   	retq   

0000000000802f02 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f02:	55                   	push   %rbp
  802f03:	48 89 e5             	mov    %rsp,%rbp
  802f06:	48 83 ec 40          	sub    $0x40,%rsp
  802f0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f11:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f15:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f19:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f1c:	48 89 d6             	mov    %rdx,%rsi
  802f1f:	89 c7                	mov    %eax,%edi
  802f21:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
  802f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f34:	78 24                	js     802f5a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3a:	8b 00                	mov    (%rax),%eax
  802f3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f40:	48 89 d6             	mov    %rdx,%rsi
  802f43:	89 c7                	mov    %eax,%edi
  802f45:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
  802f51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f58:	79 05                	jns    802f5f <write+0x5d>
		return r;
  802f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5d:	eb 79                	jmp    802fd8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f63:	8b 40 08             	mov    0x8(%rax),%eax
  802f66:	83 e0 03             	and    $0x3,%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	75 3a                	jne    802fa7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f6d:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802f74:	00 00 00 
  802f77:	48 8b 00             	mov    (%rax),%rax
  802f7a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f80:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f83:	89 c6                	mov    %eax,%esi
  802f85:	48 bf 93 4e 80 00 00 	movabs $0x804e93,%rdi
  802f8c:	00 00 00 
  802f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f94:	48 b9 bb 06 80 00 00 	movabs $0x8006bb,%rcx
  802f9b:	00 00 00 
  802f9e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fa0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fa5:	eb 31                	jmp    802fd8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fab:	48 8b 40 18          	mov    0x18(%rax),%rax
  802faf:	48 85 c0             	test   %rax,%rax
  802fb2:	75 07                	jne    802fbb <write+0xb9>
		return -E_NOT_SUPP;
  802fb4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fb9:	eb 1d                	jmp    802fd8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbf:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fcb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fcf:	48 89 ce             	mov    %rcx,%rsi
  802fd2:	48 89 c7             	mov    %rax,%rdi
  802fd5:	41 ff d0             	callq  *%r8
}
  802fd8:	c9                   	leaveq 
  802fd9:	c3                   	retq   

0000000000802fda <seek>:

int
seek(int fdnum, off_t offset)
{
  802fda:	55                   	push   %rbp
  802fdb:	48 89 e5             	mov    %rsp,%rbp
  802fde:	48 83 ec 18          	sub    $0x18,%rsp
  802fe2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fe8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fef:	48 89 d6             	mov    %rdx,%rsi
  802ff2:	89 c7                	mov    %eax,%edi
  802ff4:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802ffb:	00 00 00 
  802ffe:	ff d0                	callq  *%rax
  803000:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803003:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803007:	79 05                	jns    80300e <seek+0x34>
		return r;
  803009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300c:	eb 0f                	jmp    80301d <seek+0x43>
	fd->fd_offset = offset;
  80300e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803012:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803015:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301d:	c9                   	leaveq 
  80301e:	c3                   	retq   

000000000080301f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80301f:	55                   	push   %rbp
  803020:	48 89 e5             	mov    %rsp,%rbp
  803023:	48 83 ec 30          	sub    $0x30,%rsp
  803027:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80302a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80302d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803031:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803034:	48 89 d6             	mov    %rdx,%rsi
  803037:	89 c7                	mov    %eax,%edi
  803039:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803048:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304c:	78 24                	js     803072 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80304e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803052:	8b 00                	mov    (%rax),%eax
  803054:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803058:	48 89 d6             	mov    %rdx,%rsi
  80305b:	89 c7                	mov    %eax,%edi
  80305d:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
  803069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803070:	79 05                	jns    803077 <ftruncate+0x58>
		return r;
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	eb 72                	jmp    8030e9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307b:	8b 40 08             	mov    0x8(%rax),%eax
  80307e:	83 e0 03             	and    $0x3,%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	75 3a                	jne    8030bf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803085:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80308c:	00 00 00 
  80308f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803092:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803098:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80309b:	89 c6                	mov    %eax,%esi
  80309d:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  8030a4:	00 00 00 
  8030a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ac:	48 b9 bb 06 80 00 00 	movabs $0x8006bb,%rcx
  8030b3:	00 00 00 
  8030b6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030bd:	eb 2a                	jmp    8030e9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030c7:	48 85 c0             	test   %rax,%rax
  8030ca:	75 07                	jne    8030d3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030cc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030d1:	eb 16                	jmp    8030e9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8030db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8030e2:	89 d6                	mov    %edx,%esi
  8030e4:	48 89 c7             	mov    %rax,%rdi
  8030e7:	ff d1                	callq  *%rcx
}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 83 ec 30          	sub    $0x30,%rsp
  8030f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030fa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803101:	48 89 d6             	mov    %rdx,%rsi
  803104:	89 c7                	mov    %eax,%edi
  803106:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803115:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803119:	78 24                	js     80313f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80311b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311f:	8b 00                	mov    (%rax),%eax
  803121:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803125:	48 89 d6             	mov    %rdx,%rsi
  803128:	89 c7                	mov    %eax,%edi
  80312a:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
  803136:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803139:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313d:	79 05                	jns    803144 <fstat+0x59>
		return r;
  80313f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803142:	eb 5e                	jmp    8031a2 <fstat+0xb7>
	if (!dev->dev_stat)
  803144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803148:	48 8b 40 28          	mov    0x28(%rax),%rax
  80314c:	48 85 c0             	test   %rax,%rax
  80314f:	75 07                	jne    803158 <fstat+0x6d>
		return -E_NOT_SUPP;
  803151:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803156:	eb 4a                	jmp    8031a2 <fstat+0xb7>
	stat->st_name[0] = 0;
  803158:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80315f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803163:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80316a:	00 00 00 
	stat->st_isdir = 0;
  80316d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803171:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803178:	00 00 00 
	stat->st_dev = dev;
  80317b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80317f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803183:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80318a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  803192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803196:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80319a:	48 89 d6             	mov    %rdx,%rsi
  80319d:	48 89 c7             	mov    %rax,%rdi
  8031a0:	ff d1                	callq  *%rcx
}
  8031a2:	c9                   	leaveq 
  8031a3:	c3                   	retq   

00000000008031a4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 83 ec 20          	sub    $0x20,%rsp
  8031ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b8:	be 00 00 00 00       	mov    $0x0,%esi
  8031bd:	48 89 c7             	mov    %rax,%rdi
  8031c0:	48 b8 93 32 80 00 00 	movabs $0x803293,%rax
  8031c7:	00 00 00 
  8031ca:	ff d0                	callq  *%rax
  8031cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d3:	79 05                	jns    8031da <stat+0x36>
		return fd;
  8031d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d8:	eb 2f                	jmp    803209 <stat+0x65>
	r = fstat(fd, stat);
  8031da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e1:	48 89 d6             	mov    %rdx,%rsi
  8031e4:	89 c7                	mov    %eax,%edi
  8031e6:	48 b8 eb 30 80 00 00 	movabs $0x8030eb,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
  8031f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f8:	89 c7                	mov    %eax,%edi
  8031fa:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
	return r;
  803206:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803209:	c9                   	leaveq 
  80320a:	c3                   	retq   
	...

000000000080320c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80320c:	55                   	push   %rbp
  80320d:	48 89 e5             	mov    %rsp,%rbp
  803210:	48 83 ec 10          	sub    $0x10,%rsp
  803214:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803217:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80321b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803222:	00 00 00 
  803225:	8b 00                	mov    (%rax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	75 1d                	jne    803248 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80322b:	bf 01 00 00 00       	mov    $0x1,%edi
  803230:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
  80323c:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803243:	00 00 00 
  803246:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803248:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80324f:	00 00 00 
  803252:	8b 00                	mov    (%rax),%eax
  803254:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803257:	b9 07 00 00 00       	mov    $0x7,%ecx
  80325c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803263:	00 00 00 
  803266:	89 c7                	mov    %eax,%edi
  803268:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803278:	ba 00 00 00 00       	mov    $0x0,%edx
  80327d:	48 89 c6             	mov    %rax,%rsi
  803280:	bf 00 00 00 00       	mov    $0x0,%edi
  803285:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
}
  803291:	c9                   	leaveq 
  803292:	c3                   	retq   

0000000000803293 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  803293:	55                   	push   %rbp
  803294:	48 89 e5             	mov    %rsp,%rbp
  803297:	48 83 ec 20          	sub    $0x20,%rsp
  80329b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80329f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8032a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a6:	48 89 c7             	mov    %rax,%rdi
  8032a9:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032ba:	7e 0a                	jle    8032c6 <open+0x33>
		return -E_BAD_PATH;
  8032bc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032c1:	e9 a5 00 00 00       	jmpq   80336b <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8032c6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032ca:	48 89 c7             	mov    %rax,%rdi
  8032cd:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	callq  *%rax
  8032d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8032dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e0:	79 08                	jns    8032ea <open+0x57>
		return r;
  8032e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e5:	e9 81 00 00 00       	jmpq   80336b <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8032ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f1:	00 00 00 
  8032f4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032f7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8032fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803301:	48 89 c6             	mov    %rax,%rsi
  803304:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80330b:	00 00 00 
  80330e:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331e:	48 89 c6             	mov    %rax,%rsi
  803321:	bf 01 00 00 00       	mov    $0x1,%edi
  803326:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803339:	79 1d                	jns    803358 <open+0xc5>
		fd_close(new_fd, 0);
  80333b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333f:	be 00 00 00 00       	mov    $0x0,%esi
  803344:	48 89 c7             	mov    %rax,%rdi
  803347:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
		return r;	
  803353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803356:	eb 13                	jmp    80336b <open+0xd8>
	}
	return fd2num(new_fd);
  803358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335c:	48 89 c7             	mov    %rax,%rdi
  80335f:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
}
  80336b:	c9                   	leaveq 
  80336c:	c3                   	retq   

000000000080336d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80336d:	55                   	push   %rbp
  80336e:	48 89 e5             	mov    %rsp,%rbp
  803371:	48 83 ec 10          	sub    $0x10,%rsp
  803375:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337d:	8b 50 0c             	mov    0xc(%rax),%edx
  803380:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803387:	00 00 00 
  80338a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80338c:	be 00 00 00 00       	mov    $0x0,%esi
  803391:	bf 06 00 00 00       	mov    $0x6,%edi
  803396:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  80339d:	00 00 00 
  8033a0:	ff d0                	callq  *%rax
}
  8033a2:	c9                   	leaveq 
  8033a3:	c3                   	retq   

00000000008033a4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 83 ec 30          	sub    $0x30,%rsp
  8033ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8033b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8033bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c6:	00 00 00 
  8033c9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d2:	00 00 00 
  8033d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033d9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8033dd:	be 00 00 00 00       	mov    $0x0,%esi
  8033e2:	bf 03 00 00 00       	mov    $0x3,%edi
  8033e7:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8033f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fa:	7e 23                	jle    80341f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8033fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ff:	48 63 d0             	movslq %eax,%rdx
  803402:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803406:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80340d:	00 00 00 
  803410:	48 89 c7             	mov    %rax,%rdi
  803413:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80341f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803422:	c9                   	leaveq 
  803423:	c3                   	retq   

0000000000803424 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803424:	55                   	push   %rbp
  803425:	48 89 e5             	mov    %rsp,%rbp
  803428:	48 83 ec 20          	sub    $0x20,%rsp
  80342c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803438:	8b 50 0c             	mov    0xc(%rax),%edx
  80343b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803442:	00 00 00 
  803445:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803447:	be 00 00 00 00       	mov    $0x0,%esi
  80344c:	bf 05 00 00 00       	mov    $0x5,%edi
  803451:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  803458:	00 00 00 
  80345b:	ff d0                	callq  *%rax
  80345d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803460:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803464:	79 05                	jns    80346b <devfile_stat+0x47>
		return r;
  803466:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803469:	eb 56                	jmp    8034c1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80346b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803476:	00 00 00 
  803479:	48 89 c7             	mov    %rax,%rdi
  80347c:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  803483:	00 00 00 
  803486:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803488:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80348f:	00 00 00 
  803492:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803498:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80349c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034a9:	00 00 00 
  8034ac:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c1:	c9                   	leaveq 
  8034c2:	c3                   	retq   
	...

00000000008034c4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034c4:	55                   	push   %rbp
  8034c5:	48 89 e5             	mov    %rsp,%rbp
  8034c8:	48 83 ec 20          	sub    $0x20,%rsp
  8034cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d6:	48 89 d6             	mov    %rdx,%rsi
  8034d9:	89 c7                	mov    %eax,%edi
  8034db:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  8034e2:	00 00 00 
  8034e5:	ff d0                	callq  *%rax
  8034e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ee:	79 05                	jns    8034f5 <fd2sockid+0x31>
		return r;
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	eb 24                	jmp    803519 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f9:	8b 10                	mov    (%rax),%edx
  8034fb:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803502:	00 00 00 
  803505:	8b 00                	mov    (%rax),%eax
  803507:	39 c2                	cmp    %eax,%edx
  803509:	74 07                	je     803512 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80350b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803510:	eb 07                	jmp    803519 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803516:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803519:	c9                   	leaveq 
  80351a:	c3                   	retq   

000000000080351b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80351b:	55                   	push   %rbp
  80351c:	48 89 e5             	mov    %rsp,%rbp
  80351f:	48 83 ec 20          	sub    $0x20,%rsp
  803523:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803526:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80352a:	48 89 c7             	mov    %rax,%rdi
  80352d:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803540:	78 26                	js     803568 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803546:	ba 07 04 00 00       	mov    $0x407,%edx
  80354b:	48 89 c6             	mov    %rax,%rsi
  80354e:	bf 00 00 00 00       	mov    $0x0,%edi
  803553:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
  80355f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803566:	79 16                	jns    80357e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803568:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80356b:	89 c7                	mov    %eax,%edi
  80356d:	48 b8 28 3a 80 00 00 	movabs $0x803a28,%rax
  803574:	00 00 00 
  803577:	ff d0                	callq  *%rax
		return r;
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357c:	eb 3a                	jmp    8035b8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80357e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803582:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803589:	00 00 00 
  80358c:	8b 12                	mov    (%rdx),%edx
  80358e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803594:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80359b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a9:	48 89 c7             	mov    %rax,%rdi
  8035ac:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
}
  8035b8:	c9                   	leaveq 
  8035b9:	c3                   	retq   

00000000008035ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035ba:	55                   	push   %rbp
  8035bb:	48 89 e5             	mov    %rsp,%rbp
  8035be:	48 83 ec 30          	sub    $0x30,%rsp
  8035c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d0:	89 c7                	mov    %eax,%edi
  8035d2:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
  8035de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e5:	79 05                	jns    8035ec <accept+0x32>
		return r;
  8035e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ea:	eb 3b                	jmp    803627 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f7:	48 89 ce             	mov    %rcx,%rsi
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 05 39 80 00 00 	movabs $0x803905,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360f:	79 05                	jns    803616 <accept+0x5c>
		return r;
  803611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803614:	eb 11                	jmp    803627 <accept+0x6d>
	return alloc_sockfd(r);
  803616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803619:	89 c7                	mov    %eax,%edi
  80361b:	48 b8 1b 35 80 00 00 	movabs $0x80351b,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
}
  803627:	c9                   	leaveq 
  803628:	c3                   	retq   

0000000000803629 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803629:	55                   	push   %rbp
  80362a:	48 89 e5             	mov    %rsp,%rbp
  80362d:	48 83 ec 20          	sub    $0x20,%rsp
  803631:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803634:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803638:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80363b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363e:	89 c7                	mov    %eax,%edi
  803640:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803653:	79 05                	jns    80365a <bind+0x31>
		return r;
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803658:	eb 1b                	jmp    803675 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80365a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80365d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803664:	48 89 ce             	mov    %rcx,%rsi
  803667:	89 c7                	mov    %eax,%edi
  803669:	48 b8 84 39 80 00 00 	movabs $0x803984,%rax
  803670:	00 00 00 
  803673:	ff d0                	callq  *%rax
}
  803675:	c9                   	leaveq 
  803676:	c3                   	retq   

0000000000803677 <shutdown>:

int
shutdown(int s, int how)
{
  803677:	55                   	push   %rbp
  803678:	48 89 e5             	mov    %rsp,%rbp
  80367b:	48 83 ec 20          	sub    $0x20,%rsp
  80367f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803682:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803685:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803688:	89 c7                	mov    %eax,%edi
  80368a:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803699:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369d:	79 05                	jns    8036a4 <shutdown+0x2d>
		return r;
  80369f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a2:	eb 16                	jmp    8036ba <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036a4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036aa:	89 d6                	mov    %edx,%esi
  8036ac:	89 c7                	mov    %eax,%edi
  8036ae:	48 b8 e8 39 80 00 00 	movabs $0x8039e8,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
}
  8036ba:	c9                   	leaveq 
  8036bb:	c3                   	retq   

00000000008036bc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8036bc:	55                   	push   %rbp
  8036bd:	48 89 e5             	mov    %rsp,%rbp
  8036c0:	48 83 ec 10          	sub    $0x10,%rsp
  8036c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036cc:	48 89 c7             	mov    %rax,%rdi
  8036cf:	48 b8 68 46 80 00 00 	movabs $0x804668,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
  8036db:	83 f8 01             	cmp    $0x1,%eax
  8036de:	75 17                	jne    8036f7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e4:	8b 40 0c             	mov    0xc(%rax),%eax
  8036e7:	89 c7                	mov    %eax,%edi
  8036e9:	48 b8 28 3a 80 00 00 	movabs $0x803a28,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
  8036f5:	eb 05                	jmp    8036fc <devsock_close+0x40>
	else
		return 0;
  8036f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036fc:	c9                   	leaveq 
  8036fd:	c3                   	retq   

00000000008036fe <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036fe:	55                   	push   %rbp
  8036ff:	48 89 e5             	mov    %rsp,%rbp
  803702:	48 83 ec 20          	sub    $0x20,%rsp
  803706:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803709:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80370d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803710:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803713:	89 c7                	mov    %eax,%edi
  803715:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803728:	79 05                	jns    80372f <connect+0x31>
		return r;
  80372a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372d:	eb 1b                	jmp    80374a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80372f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803732:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803736:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803739:	48 89 ce             	mov    %rcx,%rsi
  80373c:	89 c7                	mov    %eax,%edi
  80373e:	48 b8 55 3a 80 00 00 	movabs $0x803a55,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <listen>:

int
listen(int s, int backlog)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 20          	sub    $0x20,%rsp
  803754:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803757:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80375a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80375d:	89 c7                	mov    %eax,%edi
  80375f:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  803766:	00 00 00 
  803769:	ff d0                	callq  *%rax
  80376b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80376e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803772:	79 05                	jns    803779 <listen+0x2d>
		return r;
  803774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803777:	eb 16                	jmp    80378f <listen+0x43>
	return nsipc_listen(r, backlog);
  803779:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80377c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377f:	89 d6                	mov    %edx,%esi
  803781:	89 c7                	mov    %eax,%edi
  803783:	48 b8 b9 3a 80 00 00 	movabs $0x803ab9,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
}
  80378f:	c9                   	leaveq 
  803790:	c3                   	retq   

0000000000803791 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 20          	sub    $0x20,%rsp
  803799:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80379d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a9:	89 c2                	mov    %eax,%edx
  8037ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037af:	8b 40 0c             	mov    0xc(%rax),%eax
  8037b2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037bb:	89 c7                	mov    %eax,%edi
  8037bd:	48 b8 f9 3a 80 00 00 	movabs $0x803af9,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
}
  8037c9:	c9                   	leaveq 
  8037ca:	c3                   	retq   

00000000008037cb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037cb:	55                   	push   %rbp
  8037cc:	48 89 e5             	mov    %rsp,%rbp
  8037cf:	48 83 ec 20          	sub    $0x20,%rsp
  8037d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e3:	89 c2                	mov    %eax,%edx
  8037e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e9:	8b 40 0c             	mov    0xc(%rax),%eax
  8037ec:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037f5:	89 c7                	mov    %eax,%edi
  8037f7:	48 b8 c5 3b 80 00 00 	movabs $0x803bc5,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
}
  803803:	c9                   	leaveq 
  803804:	c3                   	retq   

0000000000803805 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803805:	55                   	push   %rbp
  803806:	48 89 e5             	mov    %rsp,%rbp
  803809:	48 83 ec 10          	sub    $0x10,%rsp
  80380d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803811:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803815:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803819:	48 be db 4e 80 00 00 	movabs $0x804edb,%rsi
  803820:	00 00 00 
  803823:	48 89 c7             	mov    %rax,%rdi
  803826:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
	return 0;
  803832:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803837:	c9                   	leaveq 
  803838:	c3                   	retq   

0000000000803839 <socket>:

int
socket(int domain, int type, int protocol)
{
  803839:	55                   	push   %rbp
  80383a:	48 89 e5             	mov    %rsp,%rbp
  80383d:	48 83 ec 20          	sub    $0x20,%rsp
  803841:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803844:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803847:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80384a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80384d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803850:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803853:	89 ce                	mov    %ecx,%esi
  803855:	89 c7                	mov    %eax,%edi
  803857:	48 b8 7d 3c 80 00 00 	movabs $0x803c7d,%rax
  80385e:	00 00 00 
  803861:	ff d0                	callq  *%rax
  803863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803866:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386a:	79 05                	jns    803871 <socket+0x38>
		return r;
  80386c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386f:	eb 11                	jmp    803882 <socket+0x49>
	return alloc_sockfd(r);
  803871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803874:	89 c7                	mov    %eax,%edi
  803876:	48 b8 1b 35 80 00 00 	movabs $0x80351b,%rax
  80387d:	00 00 00 
  803880:	ff d0                	callq  *%rax
}
  803882:	c9                   	leaveq 
  803883:	c3                   	retq   

0000000000803884 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803884:	55                   	push   %rbp
  803885:	48 89 e5             	mov    %rsp,%rbp
  803888:	48 83 ec 10          	sub    $0x10,%rsp
  80388c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80388f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803896:	00 00 00 
  803899:	8b 00                	mov    (%rax),%eax
  80389b:	85 c0                	test   %eax,%eax
  80389d:	75 1d                	jne    8038bc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80389f:	bf 02 00 00 00       	mov    $0x2,%edi
  8038a4:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  8038ab:	00 00 00 
  8038ae:	ff d0                	callq  *%rax
  8038b0:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  8038b7:	00 00 00 
  8038ba:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8038bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038c3:	00 00 00 
  8038c6:	8b 00                	mov    (%rax),%eax
  8038c8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038cb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038d0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8038d7:	00 00 00 
  8038da:	89 c7                	mov    %eax,%edi
  8038dc:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8038ed:	be 00 00 00 00       	mov    $0x0,%esi
  8038f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f7:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
}
  803903:	c9                   	leaveq 
  803904:	c3                   	retq   

0000000000803905 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803905:	55                   	push   %rbp
  803906:	48 89 e5             	mov    %rsp,%rbp
  803909:	48 83 ec 30          	sub    $0x30,%rsp
  80390d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803914:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803918:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80391f:	00 00 00 
  803922:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803925:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803927:	bf 01 00 00 00       	mov    $0x1,%edi
  80392c:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
  803938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393f:	78 3e                	js     80397f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803941:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803948:	00 00 00 
  80394b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80394f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803953:	8b 40 10             	mov    0x10(%rax),%eax
  803956:	89 c2                	mov    %eax,%edx
  803958:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80395c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803960:	48 89 ce             	mov    %rcx,%rsi
  803963:	48 89 c7             	mov    %rax,%rdi
  803966:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803976:	8b 50 10             	mov    0x10(%rax),%edx
  803979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80397f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803982:	c9                   	leaveq 
  803983:	c3                   	retq   

0000000000803984 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803984:	55                   	push   %rbp
  803985:	48 89 e5             	mov    %rsp,%rbp
  803988:	48 83 ec 10          	sub    $0x10,%rsp
  80398c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80398f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803993:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803996:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80399d:	00 00 00 
  8039a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039a3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039a5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ac:	48 89 c6             	mov    %rax,%rsi
  8039af:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8039b6:	00 00 00 
  8039b9:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039cc:	00 00 00 
  8039cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8039da:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
}
  8039e6:	c9                   	leaveq 
  8039e7:	c3                   	retq   

00000000008039e8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039e8:	55                   	push   %rbp
  8039e9:	48 89 e5             	mov    %rsp,%rbp
  8039ec:	48 83 ec 10          	sub    $0x10,%rsp
  8039f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039fd:	00 00 00 
  803a00:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a03:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a05:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a0c:	00 00 00 
  803a0f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a12:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a15:	bf 03 00 00 00       	mov    $0x3,%edi
  803a1a:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
}
  803a26:	c9                   	leaveq 
  803a27:	c3                   	retq   

0000000000803a28 <nsipc_close>:

int
nsipc_close(int s)
{
  803a28:	55                   	push   %rbp
  803a29:	48 89 e5             	mov    %rsp,%rbp
  803a2c:	48 83 ec 10          	sub    $0x10,%rsp
  803a30:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a33:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3a:	00 00 00 
  803a3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a40:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a42:	bf 04 00 00 00       	mov    $0x4,%edi
  803a47:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
}
  803a53:	c9                   	leaveq 
  803a54:	c3                   	retq   

0000000000803a55 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a55:	55                   	push   %rbp
  803a56:	48 89 e5             	mov    %rsp,%rbp
  803a59:	48 83 ec 10          	sub    $0x10,%rsp
  803a5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a64:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a67:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a6e:	00 00 00 
  803a71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a74:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a76:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7d:	48 89 c6             	mov    %rax,%rsi
  803a80:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a87:	00 00 00 
  803a8a:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a96:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a9d:	00 00 00 
  803aa0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aa3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803aa6:	bf 05 00 00 00       	mov    $0x5,%edi
  803aab:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
}
  803ab7:	c9                   	leaveq 
  803ab8:	c3                   	retq   

0000000000803ab9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ab9:	55                   	push   %rbp
  803aba:	48 89 e5             	mov    %rsp,%rbp
  803abd:	48 83 ec 10          	sub    $0x10,%rsp
  803ac1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ac4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ac7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ace:	00 00 00 
  803ad1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ad4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ad6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803add:	00 00 00 
  803ae0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ae3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ae6:	bf 06 00 00 00       	mov    $0x6,%edi
  803aeb:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
}
  803af7:	c9                   	leaveq 
  803af8:	c3                   	retq   

0000000000803af9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803af9:	55                   	push   %rbp
  803afa:	48 89 e5             	mov    %rsp,%rbp
  803afd:	48 83 ec 30          	sub    $0x30,%rsp
  803b01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b08:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b0b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b15:	00 00 00 
  803b18:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b1b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b1d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b24:	00 00 00 
  803b27:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b2a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b2d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b34:	00 00 00 
  803b37:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b3a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b3d:	bf 07 00 00 00       	mov    $0x7,%edi
  803b42:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
  803b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b55:	78 69                	js     803bc0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b57:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b5e:	7f 08                	jg     803b68 <nsipc_recv+0x6f>
  803b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b63:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b66:	7e 35                	jle    803b9d <nsipc_recv+0xa4>
  803b68:	48 b9 e2 4e 80 00 00 	movabs $0x804ee2,%rcx
  803b6f:	00 00 00 
  803b72:	48 ba f7 4e 80 00 00 	movabs $0x804ef7,%rdx
  803b79:	00 00 00 
  803b7c:	be 61 00 00 00       	mov    $0x61,%esi
  803b81:	48 bf 0c 4f 80 00 00 	movabs $0x804f0c,%rdi
  803b88:	00 00 00 
  803b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b90:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  803b97:	00 00 00 
  803b9a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba0:	48 63 d0             	movslq %eax,%rdx
  803ba3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803bae:	00 00 00 
  803bb1:	48 89 c7             	mov    %rax,%rdi
  803bb4:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
	}

	return r;
  803bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bc3:	c9                   	leaveq 
  803bc4:	c3                   	retq   

0000000000803bc5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bc5:	55                   	push   %rbp
  803bc6:	48 89 e5             	mov    %rsp,%rbp
  803bc9:	48 83 ec 20          	sub    $0x20,%rsp
  803bcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bd4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803bd7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bda:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803be1:	00 00 00 
  803be4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803be7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803be9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bf0:	7e 35                	jle    803c27 <nsipc_send+0x62>
  803bf2:	48 b9 18 4f 80 00 00 	movabs $0x804f18,%rcx
  803bf9:	00 00 00 
  803bfc:	48 ba f7 4e 80 00 00 	movabs $0x804ef7,%rdx
  803c03:	00 00 00 
  803c06:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c0b:	48 bf 0c 4f 80 00 00 	movabs $0x804f0c,%rdi
  803c12:	00 00 00 
  803c15:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1a:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  803c21:	00 00 00 
  803c24:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c2a:	48 63 d0             	movslq %eax,%rdx
  803c2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c31:	48 89 c6             	mov    %rax,%rsi
  803c34:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803c3b:	00 00 00 
  803c3e:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  803c45:	00 00 00 
  803c48:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c51:	00 00 00 
  803c54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c57:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c5a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c61:	00 00 00 
  803c64:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c67:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c6a:	bf 08 00 00 00       	mov    $0x8,%edi
  803c6f:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
}
  803c7b:	c9                   	leaveq 
  803c7c:	c3                   	retq   

0000000000803c7d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c7d:	55                   	push   %rbp
  803c7e:	48 89 e5             	mov    %rsp,%rbp
  803c81:	48 83 ec 10          	sub    $0x10,%rsp
  803c85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c88:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c8b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c8e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c95:	00 00 00 
  803c98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c9b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ca4:	00 00 00 
  803ca7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803caa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803cad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cb4:	00 00 00 
  803cb7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803cba:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803cbd:	bf 09 00 00 00       	mov    $0x9,%edi
  803cc2:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
}
  803cce:	c9                   	leaveq 
  803ccf:	c3                   	retq   

0000000000803cd0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cd0:	55                   	push   %rbp
  803cd1:	48 89 e5             	mov    %rsp,%rbp
  803cd4:	53                   	push   %rbx
  803cd5:	48 83 ec 38          	sub    $0x38,%rsp
  803cd9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803cdd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ce1:	48 89 c7             	mov    %rax,%rdi
  803ce4:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803ceb:	00 00 00 
  803cee:	ff d0                	callq  *%rax
  803cf0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf7:	0f 88 bf 01 00 00    	js     803ebc <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d01:	ba 07 04 00 00       	mov    $0x407,%edx
  803d06:	48 89 c6             	mov    %rax,%rsi
  803d09:	bf 00 00 00 00       	mov    $0x0,%edi
  803d0e:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  803d15:	00 00 00 
  803d18:	ff d0                	callq  *%rax
  803d1a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d21:	0f 88 95 01 00 00    	js     803ebc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d27:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d2b:	48 89 c7             	mov    %rax,%rdi
  803d2e:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d41:	0f 88 5d 01 00 00    	js     803ea4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d4b:	ba 07 04 00 00       	mov    $0x407,%edx
  803d50:	48 89 c6             	mov    %rax,%rsi
  803d53:	bf 00 00 00 00       	mov    $0x0,%edi
  803d58:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  803d5f:	00 00 00 
  803d62:	ff d0                	callq  *%rax
  803d64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d67:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d6b:	0f 88 33 01 00 00    	js     803ea4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d8c:	ba 07 04 00 00       	mov    $0x407,%edx
  803d91:	48 89 c6             	mov    %rax,%rsi
  803d94:	bf 00 00 00 00       	mov    $0x0,%edi
  803d99:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  803da0:	00 00 00 
  803da3:	ff d0                	callq  *%rax
  803da5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803da8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dac:	0f 88 d9 00 00 00    	js     803e8b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803db2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db6:	48 89 c7             	mov    %rax,%rdi
  803db9:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803dc0:	00 00 00 
  803dc3:	ff d0                	callq  *%rax
  803dc5:	48 89 c2             	mov    %rax,%rdx
  803dc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dcc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803dd2:	48 89 d1             	mov    %rdx,%rcx
  803dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  803dda:	48 89 c6             	mov    %rax,%rsi
  803ddd:	bf 00 00 00 00       	mov    $0x0,%edi
  803de2:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  803de9:	00 00 00 
  803dec:	ff d0                	callq  *%rax
  803dee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803df1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803df5:	78 79                	js     803e70 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803df7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e02:	00 00 00 
  803e05:	8b 12                	mov    (%rdx),%edx
  803e07:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e18:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e1f:	00 00 00 
  803e22:	8b 12                	mov    (%rdx),%edx
  803e24:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e2a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e35:	48 89 c7             	mov    %rax,%rdi
  803e38:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803e3f:	00 00 00 
  803e42:	ff d0                	callq  *%rax
  803e44:	89 c2                	mov    %eax,%edx
  803e46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e4a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e50:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e58:	48 89 c7             	mov    %rax,%rdi
  803e5b:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
  803e67:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e69:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6e:	eb 4f                	jmp    803ebf <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803e70:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e75:	48 89 c6             	mov    %rax,%rsi
  803e78:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7d:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  803e84:	00 00 00 
  803e87:	ff d0                	callq  *%rax
  803e89:	eb 01                	jmp    803e8c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803e8b:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e90:	48 89 c6             	mov    %rax,%rsi
  803e93:	bf 00 00 00 00       	mov    $0x0,%edi
  803e98:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  803e9f:	00 00 00 
  803ea2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea8:	48 89 c6             	mov    %rax,%rsi
  803eab:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb0:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  803eb7:	00 00 00 
  803eba:	ff d0                	callq  *%rax
err:
	return r;
  803ebc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ebf:	48 83 c4 38          	add    $0x38,%rsp
  803ec3:	5b                   	pop    %rbx
  803ec4:	5d                   	pop    %rbp
  803ec5:	c3                   	retq   

0000000000803ec6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ec6:	55                   	push   %rbp
  803ec7:	48 89 e5             	mov    %rsp,%rbp
  803eca:	53                   	push   %rbx
  803ecb:	48 83 ec 28          	sub    $0x28,%rsp
  803ecf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ed3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ed7:	eb 01                	jmp    803eda <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803ed9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803eda:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803ee1:	00 00 00 
  803ee4:	48 8b 00             	mov    (%rax),%rax
  803ee7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803eed:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ef0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef4:	48 89 c7             	mov    %rax,%rdi
  803ef7:	48 b8 68 46 80 00 00 	movabs $0x804668,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	89 c3                	mov    %eax,%ebx
  803f05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f09:	48 89 c7             	mov    %rax,%rdi
  803f0c:	48 b8 68 46 80 00 00 	movabs $0x804668,%rax
  803f13:	00 00 00 
  803f16:	ff d0                	callq  *%rax
  803f18:	39 c3                	cmp    %eax,%ebx
  803f1a:	0f 94 c0             	sete   %al
  803f1d:	0f b6 c0             	movzbl %al,%eax
  803f20:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f23:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803f2a:	00 00 00 
  803f2d:	48 8b 00             	mov    (%rax),%rax
  803f30:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f36:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f3f:	75 0a                	jne    803f4b <_pipeisclosed+0x85>
			return ret;
  803f41:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803f44:	48 83 c4 28          	add    $0x28,%rsp
  803f48:	5b                   	pop    %rbx
  803f49:	5d                   	pop    %rbp
  803f4a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803f4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f51:	74 86                	je     803ed9 <_pipeisclosed+0x13>
  803f53:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f57:	75 80                	jne    803ed9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f59:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803f60:	00 00 00 
  803f63:	48 8b 00             	mov    (%rax),%rax
  803f66:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f6c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f72:	89 c6                	mov    %eax,%esi
  803f74:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  803f7b:	00 00 00 
  803f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f83:	49 b8 bb 06 80 00 00 	movabs $0x8006bb,%r8
  803f8a:	00 00 00 
  803f8d:	41 ff d0             	callq  *%r8
	}
  803f90:	e9 44 ff ff ff       	jmpq   803ed9 <_pipeisclosed+0x13>

0000000000803f95 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803f95:	55                   	push   %rbp
  803f96:	48 89 e5             	mov    %rsp,%rbp
  803f99:	48 83 ec 30          	sub    $0x30,%rsp
  803f9d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fa0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fa4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fa7:	48 89 d6             	mov    %rdx,%rsi
  803faa:	89 c7                	mov    %eax,%edi
  803fac:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803fb3:	00 00 00 
  803fb6:	ff d0                	callq  *%rax
  803fb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fbf:	79 05                	jns    803fc6 <pipeisclosed+0x31>
		return r;
  803fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc4:	eb 31                	jmp    803ff7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fca:	48 89 c7             	mov    %rax,%rdi
  803fcd:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803fd4:	00 00 00 
  803fd7:	ff d0                	callq  *%rax
  803fd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fe1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fe5:	48 89 d6             	mov    %rdx,%rsi
  803fe8:	48 89 c7             	mov    %rax,%rdi
  803feb:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  803ff2:	00 00 00 
  803ff5:	ff d0                	callq  *%rax
}
  803ff7:	c9                   	leaveq 
  803ff8:	c3                   	retq   

0000000000803ff9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ff9:	55                   	push   %rbp
  803ffa:	48 89 e5             	mov    %rsp,%rbp
  803ffd:	48 83 ec 40          	sub    $0x40,%rsp
  804001:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804005:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804009:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80400d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804011:	48 89 c7             	mov    %rax,%rdi
  804014:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  80401b:	00 00 00 
  80401e:	ff d0                	callq  *%rax
  804020:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804024:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804028:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80402c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804033:	00 
  804034:	e9 97 00 00 00       	jmpq   8040d0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804039:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80403e:	74 09                	je     804049 <devpipe_read+0x50>
				return i;
  804040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804044:	e9 95 00 00 00       	jmpq   8040de <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804049:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80404d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804051:	48 89 d6             	mov    %rdx,%rsi
  804054:	48 89 c7             	mov    %rax,%rdi
  804057:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
  804063:	85 c0                	test   %eax,%eax
  804065:	74 07                	je     80406e <devpipe_read+0x75>
				return 0;
  804067:	b8 00 00 00 00       	mov    $0x0,%eax
  80406c:	eb 70                	jmp    8040de <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80406e:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
  80407a:	eb 01                	jmp    80407d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80407c:	90                   	nop
  80407d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804081:	8b 10                	mov    (%rax),%edx
  804083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804087:	8b 40 04             	mov    0x4(%rax),%eax
  80408a:	39 c2                	cmp    %eax,%edx
  80408c:	74 ab                	je     804039 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80408e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804092:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804096:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80409a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409e:	8b 00                	mov    (%rax),%eax
  8040a0:	89 c2                	mov    %eax,%edx
  8040a2:	c1 fa 1f             	sar    $0x1f,%edx
  8040a5:	c1 ea 1b             	shr    $0x1b,%edx
  8040a8:	01 d0                	add    %edx,%eax
  8040aa:	83 e0 1f             	and    $0x1f,%eax
  8040ad:	29 d0                	sub    %edx,%eax
  8040af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040b3:	48 98                	cltq   
  8040b5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040ba:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c0:	8b 00                	mov    (%rax),%eax
  8040c2:	8d 50 01             	lea    0x1(%rax),%edx
  8040c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040d8:	72 a2                	jb     80407c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040de:	c9                   	leaveq 
  8040df:	c3                   	retq   

00000000008040e0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040e0:	55                   	push   %rbp
  8040e1:	48 89 e5             	mov    %rsp,%rbp
  8040e4:	48 83 ec 40          	sub    $0x40,%rsp
  8040e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f8:	48 89 c7             	mov    %rax,%rdi
  8040fb:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  804102:	00 00 00 
  804105:	ff d0                	callq  *%rax
  804107:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80410b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804113:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80411a:	00 
  80411b:	e9 93 00 00 00       	jmpq   8041b3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804120:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804124:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804128:	48 89 d6             	mov    %rdx,%rsi
  80412b:	48 89 c7             	mov    %rax,%rdi
  80412e:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  804135:	00 00 00 
  804138:	ff d0                	callq  *%rax
  80413a:	85 c0                	test   %eax,%eax
  80413c:	74 07                	je     804145 <devpipe_write+0x65>
				return 0;
  80413e:	b8 00 00 00 00       	mov    $0x0,%eax
  804143:	eb 7c                	jmp    8041c1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804145:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  80414c:	00 00 00 
  80414f:	ff d0                	callq  *%rax
  804151:	eb 01                	jmp    804154 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804153:	90                   	nop
  804154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804158:	8b 40 04             	mov    0x4(%rax),%eax
  80415b:	48 63 d0             	movslq %eax,%rdx
  80415e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804162:	8b 00                	mov    (%rax),%eax
  804164:	48 98                	cltq   
  804166:	48 83 c0 20          	add    $0x20,%rax
  80416a:	48 39 c2             	cmp    %rax,%rdx
  80416d:	73 b1                	jae    804120 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80416f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804173:	8b 40 04             	mov    0x4(%rax),%eax
  804176:	89 c2                	mov    %eax,%edx
  804178:	c1 fa 1f             	sar    $0x1f,%edx
  80417b:	c1 ea 1b             	shr    $0x1b,%edx
  80417e:	01 d0                	add    %edx,%eax
  804180:	83 e0 1f             	and    $0x1f,%eax
  804183:	29 d0                	sub    %edx,%eax
  804185:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804189:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80418d:	48 01 ca             	add    %rcx,%rdx
  804190:	0f b6 0a             	movzbl (%rdx),%ecx
  804193:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804197:	48 98                	cltq   
  804199:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80419d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a1:	8b 40 04             	mov    0x4(%rax),%eax
  8041a4:	8d 50 01             	lea    0x1(%rax),%edx
  8041a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ab:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041bb:	72 96                	jb     804153 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041c1:	c9                   	leaveq 
  8041c2:	c3                   	retq   

00000000008041c3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041c3:	55                   	push   %rbp
  8041c4:	48 89 e5             	mov    %rsp,%rbp
  8041c7:	48 83 ec 20          	sub    $0x20,%rsp
  8041cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041d7:	48 89 c7             	mov    %rax,%rdi
  8041da:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  8041e1:	00 00 00 
  8041e4:	ff d0                	callq  *%rax
  8041e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ee:	48 be 3c 4f 80 00 00 	movabs $0x804f3c,%rsi
  8041f5:	00 00 00 
  8041f8:	48 89 c7             	mov    %rax,%rdi
  8041fb:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  804202:	00 00 00 
  804205:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420b:	8b 50 04             	mov    0x4(%rax),%edx
  80420e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804212:	8b 00                	mov    (%rax),%eax
  804214:	29 c2                	sub    %eax,%edx
  804216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80421a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804224:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80422b:	00 00 00 
	stat->st_dev = &devpipe;
  80422e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804232:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804239:	00 00 00 
  80423c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804243:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804248:	c9                   	leaveq 
  804249:	c3                   	retq   

000000000080424a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80424a:	55                   	push   %rbp
  80424b:	48 89 e5             	mov    %rsp,%rbp
  80424e:	48 83 ec 10          	sub    $0x10,%rsp
  804252:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80425a:	48 89 c6             	mov    %rax,%rsi
  80425d:	bf 00 00 00 00       	mov    $0x0,%edi
  804262:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804269:	00 00 00 
  80426c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80426e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804272:	48 89 c7             	mov    %rax,%rdi
  804275:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  80427c:	00 00 00 
  80427f:	ff d0                	callq  *%rax
  804281:	48 89 c6             	mov    %rax,%rsi
  804284:	bf 00 00 00 00       	mov    $0x0,%edi
  804289:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
}
  804295:	c9                   	leaveq 
  804296:	c3                   	retq   
	...

0000000000804298 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804298:	55                   	push   %rbp
  804299:	48 89 e5             	mov    %rsp,%rbp
  80429c:	48 83 ec 20          	sub    $0x20,%rsp
  8042a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042a6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8042a9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8042ad:	be 01 00 00 00       	mov    $0x1,%esi
  8042b2:	48 89 c7             	mov    %rax,%rdi
  8042b5:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8042bc:	00 00 00 
  8042bf:	ff d0                	callq  *%rax
}
  8042c1:	c9                   	leaveq 
  8042c2:	c3                   	retq   

00000000008042c3 <getchar>:

int
getchar(void)
{
  8042c3:	55                   	push   %rbp
  8042c4:	48 89 e5             	mov    %rsp,%rbp
  8042c7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042cb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042cf:	ba 01 00 00 00       	mov    $0x1,%edx
  8042d4:	48 89 c6             	mov    %rax,%rsi
  8042d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8042dc:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  8042e3:	00 00 00 
  8042e6:	ff d0                	callq  *%rax
  8042e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ef:	79 05                	jns    8042f6 <getchar+0x33>
		return r;
  8042f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f4:	eb 14                	jmp    80430a <getchar+0x47>
	if (r < 1)
  8042f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042fa:	7f 07                	jg     804303 <getchar+0x40>
		return -E_EOF;
  8042fc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804301:	eb 07                	jmp    80430a <getchar+0x47>
	return c;
  804303:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804307:	0f b6 c0             	movzbl %al,%eax
}
  80430a:	c9                   	leaveq 
  80430b:	c3                   	retq   

000000000080430c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80430c:	55                   	push   %rbp
  80430d:	48 89 e5             	mov    %rsp,%rbp
  804310:	48 83 ec 20          	sub    $0x20,%rsp
  804314:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804317:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80431b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80431e:	48 89 d6             	mov    %rdx,%rsi
  804321:	89 c7                	mov    %eax,%edi
  804323:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
  80432f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804336:	79 05                	jns    80433d <iscons+0x31>
		return r;
  804338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80433b:	eb 1a                	jmp    804357 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80433d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804341:	8b 10                	mov    (%rax),%edx
  804343:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80434a:	00 00 00 
  80434d:	8b 00                	mov    (%rax),%eax
  80434f:	39 c2                	cmp    %eax,%edx
  804351:	0f 94 c0             	sete   %al
  804354:	0f b6 c0             	movzbl %al,%eax
}
  804357:	c9                   	leaveq 
  804358:	c3                   	retq   

0000000000804359 <opencons>:

int
opencons(void)
{
  804359:	55                   	push   %rbp
  80435a:	48 89 e5             	mov    %rsp,%rbp
  80435d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804361:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804365:	48 89 c7             	mov    %rax,%rdi
  804368:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  80436f:	00 00 00 
  804372:	ff d0                	callq  *%rax
  804374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80437b:	79 05                	jns    804382 <opencons+0x29>
		return r;
  80437d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804380:	eb 5b                	jmp    8043dd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804386:	ba 07 04 00 00       	mov    $0x407,%edx
  80438b:	48 89 c6             	mov    %rax,%rsi
  80438e:	bf 00 00 00 00       	mov    $0x0,%edi
  804393:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
  80439f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a6:	79 05                	jns    8043ad <opencons+0x54>
		return r;
  8043a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ab:	eb 30                	jmp    8043dd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8043ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8043b8:	00 00 00 
  8043bb:	8b 12                	mov    (%rdx),%edx
  8043bd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8043bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ce:	48 89 c7             	mov    %rax,%rdi
  8043d1:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8043d8:	00 00 00 
  8043db:	ff d0                	callq  *%rax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   

00000000008043df <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043df:	55                   	push   %rbp
  8043e0:	48 89 e5             	mov    %rsp,%rbp
  8043e3:	48 83 ec 30          	sub    $0x30,%rsp
  8043e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043f8:	75 13                	jne    80440d <devcons_read+0x2e>
		return 0;
  8043fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ff:	eb 49                	jmp    80444a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804401:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  804408:	00 00 00 
  80440b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80440d:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
  804419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80441c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804420:	74 df                	je     804401 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804426:	79 05                	jns    80442d <devcons_read+0x4e>
		return c;
  804428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442b:	eb 1d                	jmp    80444a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80442d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804431:	75 07                	jne    80443a <devcons_read+0x5b>
		return 0;
  804433:	b8 00 00 00 00       	mov    $0x0,%eax
  804438:	eb 10                	jmp    80444a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80443a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443d:	89 c2                	mov    %eax,%edx
  80443f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804443:	88 10                	mov    %dl,(%rax)
	return 1;
  804445:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80444a:	c9                   	leaveq 
  80444b:	c3                   	retq   

000000000080444c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80444c:	55                   	push   %rbp
  80444d:	48 89 e5             	mov    %rsp,%rbp
  804450:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804457:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80445e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804465:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80446c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804473:	eb 77                	jmp    8044ec <devcons_write+0xa0>
		m = n - tot;
  804475:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80447c:	89 c2                	mov    %eax,%edx
  80447e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804481:	89 d1                	mov    %edx,%ecx
  804483:	29 c1                	sub    %eax,%ecx
  804485:	89 c8                	mov    %ecx,%eax
  804487:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80448a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80448d:	83 f8 7f             	cmp    $0x7f,%eax
  804490:	76 07                	jbe    804499 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804492:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804499:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80449c:	48 63 d0             	movslq %eax,%rdx
  80449f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a2:	48 98                	cltq   
  8044a4:	48 89 c1             	mov    %rax,%rcx
  8044a7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8044ae:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044b5:	48 89 ce             	mov    %rcx,%rsi
  8044b8:	48 89 c7             	mov    %rax,%rdi
  8044bb:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8044c2:	00 00 00 
  8044c5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044ca:	48 63 d0             	movslq %eax,%rdx
  8044cd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044d4:	48 89 d6             	mov    %rdx,%rsi
  8044d7:	48 89 c7             	mov    %rax,%rdi
  8044da:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8044e1:	00 00 00 
  8044e4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ef:	48 98                	cltq   
  8044f1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044f8:	0f 82 77 ff ff ff    	jb     804475 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804501:	c9                   	leaveq 
  804502:	c3                   	retq   

0000000000804503 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804503:	55                   	push   %rbp
  804504:	48 89 e5             	mov    %rsp,%rbp
  804507:	48 83 ec 08          	sub    $0x8,%rsp
  80450b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80450f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804514:	c9                   	leaveq 
  804515:	c3                   	retq   

0000000000804516 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804516:	55                   	push   %rbp
  804517:	48 89 e5             	mov    %rsp,%rbp
  80451a:	48 83 ec 10          	sub    $0x10,%rsp
  80451e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804522:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80452a:	48 be 48 4f 80 00 00 	movabs $0x804f48,%rsi
  804531:	00 00 00 
  804534:	48 89 c7             	mov    %rax,%rdi
  804537:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  80453e:	00 00 00 
  804541:	ff d0                	callq  *%rax
	return 0;
  804543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804548:	c9                   	leaveq 
  804549:	c3                   	retq   
	...

000000000080454c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80454c:	55                   	push   %rbp
  80454d:	48 89 e5             	mov    %rsp,%rbp
  804550:	48 83 ec 10          	sub    $0x10,%rsp
  804554:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804558:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80455f:	00 00 00 
  804562:	48 8b 00             	mov    (%rax),%rax
  804565:	48 85 c0             	test   %rax,%rax
  804568:	75 66                	jne    8045d0 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  80456a:	ba 07 00 00 00       	mov    $0x7,%edx
  80456f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804574:	bf 00 00 00 00       	mov    $0x0,%edi
  804579:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  804580:	00 00 00 
  804583:	ff d0                	callq  *%rax
  804585:	85 c0                	test   %eax,%eax
  804587:	75 1d                	jne    8045a6 <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804589:	48 be e4 45 80 00 00 	movabs $0x8045e4,%rsi
  804590:	00 00 00 
  804593:	bf 00 00 00 00       	mov    $0x0,%edi
  804598:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  80459f:	00 00 00 
  8045a2:	ff d0                	callq  *%rax
  8045a4:	eb 2a                	jmp    8045d0 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  8045a6:	48 ba 4f 4f 80 00 00 	movabs $0x804f4f,%rdx
  8045ad:	00 00 00 
  8045b0:	be 23 00 00 00       	mov    $0x23,%esi
  8045b5:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  8045bc:	00 00 00 
  8045bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c4:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  8045cb:	00 00 00 
  8045ce:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8045d0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045d7:	00 00 00 
  8045da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045de:	48 89 10             	mov    %rdx,(%rax)
}
  8045e1:	c9                   	leaveq 
  8045e2:	c3                   	retq   
	...

00000000008045e4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8045e4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8045e7:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8045ee:	00 00 00 
call *%rax
  8045f1:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  8045f3:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  8045f7:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  8045fc:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804603:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804604:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804608:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80460b:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804612:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804613:	4c 8b 3c 24          	mov    (%rsp),%r15
  804617:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80461c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804621:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804626:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80462b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804630:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804635:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80463a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80463f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804644:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804649:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80464e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804653:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804658:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80465d:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  804661:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804665:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  804666:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  804667:	c3                   	retq   

0000000000804668 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804668:	55                   	push   %rbp
  804669:	48 89 e5             	mov    %rsp,%rbp
  80466c:	48 83 ec 18          	sub    $0x18,%rsp
  804670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804678:	48 89 c2             	mov    %rax,%rdx
  80467b:	48 c1 ea 15          	shr    $0x15,%rdx
  80467f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804686:	01 00 00 
  804689:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80468d:	83 e0 01             	and    $0x1,%eax
  804690:	48 85 c0             	test   %rax,%rax
  804693:	75 07                	jne    80469c <pageref+0x34>
		return 0;
  804695:	b8 00 00 00 00       	mov    $0x0,%eax
  80469a:	eb 53                	jmp    8046ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80469c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a0:	48 89 c2             	mov    %rax,%rdx
  8046a3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8046a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046ae:	01 00 00 
  8046b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046bd:	83 e0 01             	and    $0x1,%eax
  8046c0:	48 85 c0             	test   %rax,%rax
  8046c3:	75 07                	jne    8046cc <pageref+0x64>
		return 0;
  8046c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ca:	eb 23                	jmp    8046ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d0:	48 89 c2             	mov    %rax,%rdx
  8046d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8046d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8046de:	00 00 00 
  8046e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8046e5:	48 01 d0             	add    %rdx,%rax
  8046e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8046ec:	0f b7 c0             	movzwl %ax,%eax
}
  8046ef:	c9                   	leaveq 
  8046f0:	c3                   	retq   
