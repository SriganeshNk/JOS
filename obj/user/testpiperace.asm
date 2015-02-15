
obj/user/testpiperace.debug:     file format elf64-x86-64


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
  80003c:	e8 5f 03 00 00       	callq  8003a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 50          	sub    $0x50,%rsp
  80004c:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800053:	48 bf e0 46 80 00 00 	movabs $0x8046e0,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800072:	48 89 c7             	mov    %rax,%rdi
  800075:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
  800081:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800084:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800088:	79 30                	jns    8000ba <umain+0x76>
		panic("pipe: %e", r);
  80008a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008d:	89 c1                	mov    %eax,%ecx
  80008f:	48 ba f9 46 80 00 00 	movabs $0x8046f9,%rdx
  800096:	00 00 00 
  800099:	be 0d 00 00 00       	mov    $0xd,%esi
  80009e:	48 bf 02 47 80 00 00 	movabs $0x804702,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8000b4:	00 00 00 
  8000b7:	41 ff d0             	callq  *%r8
	max = 200;
  8000ba:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c1:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax
  8000cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d4:	79 30                	jns    800106 <umain+0xc2>
		panic("fork: %e", r);
  8000d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d9:	89 c1                	mov    %eax,%ecx
  8000db:	48 ba 16 47 80 00 00 	movabs $0x804716,%rdx
  8000e2:	00 00 00 
  8000e5:	be 10 00 00 00       	mov    $0x10,%esi
  8000ea:	48 bf 02 47 80 00 00 	movabs $0x804702,%rdi
  8000f1:	00 00 00 
  8000f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f9:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  800100:	00 00 00 
  800103:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800106:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80010a:	0f 85 89 00 00 00    	jne    800199 <umain+0x155>
		close(p[1]);
  800110:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800113:	89 c7                	mov    %eax,%edi
  800115:	48 b8 7e 2b 80 00 00 	movabs $0x802b7e,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800128:	eb 4c                	jmp    800176 <umain+0x132>
			if(pipeisclosed(p[0])){
  80012a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012d:	89 c7                	mov    %eax,%edi
  80012f:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  800136:	00 00 00 
  800139:	ff d0                	callq  *%rax
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 27                	je     800166 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013f:	48 bf 1f 47 80 00 00 	movabs $0x80471f,%rdi
  800146:	00 00 00 
  800149:	b8 00 00 00 00       	mov    $0x0,%eax
  80014e:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800155:	00 00 00 
  800158:	ff d2                	callq  *%rdx
				exit();
  80015a:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800161:	00 00 00 
  800164:	ff d0                	callq  *%rax
			}
			sys_yield();
  800166:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80016d:	00 00 00 
  800170:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800172:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800179:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017c:	7c ac                	jl     80012a <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017e:	ba 00 00 00 00       	mov    $0x0,%edx
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	bf 00 00 00 00       	mov    $0x0,%edi
  80018d:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  800194:	00 00 00 
  800197:	ff d0                	callq  *%rax
	}
	pid = r;
  800199:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019c:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a2:	89 c6                	mov    %eax,%esi
  8001a4:	48 bf 3a 47 80 00 00 	movabs $0x80473a,%rdi
  8001ab:	00 00 00 
  8001ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b3:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  8001ba:	00 00 00 
  8001bd:	ff d2                	callq  *%rdx
	va = 0;
  8001bf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c6:	00 
	kid = &envs[ENVX(pid)];
  8001c7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001ca:	48 98                	cltq   
  8001cc:	48 89 c2             	mov    %rax,%rdx
  8001cf:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001d5:	48 89 d0             	mov    %rdx,%rax
  8001d8:	48 c1 e0 02          	shl    $0x2,%rax
  8001dc:	48 01 d0             	add    %rdx,%rax
  8001df:	48 01 c0             	add    %rax,%rax
  8001e2:	48 01 d0             	add    %rdx,%rax
  8001e5:	48 c1 e0 05          	shl    $0x5,%rax
  8001e9:	48 89 c2             	mov    %rax,%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 01 d0             	add    %rdx,%rax
  8001f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800201:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800208:	00 00 00 
  80020b:	48 89 d1             	mov    %rdx,%rcx
  80020e:	48 29 c1             	sub    %rax,%rcx
  800211:	48 89 c8             	mov    %rcx,%rax
  800214:	48 89 c2             	mov    %rax,%rdx
  800217:	48 c1 fa 05          	sar    $0x5,%rdx
  80021b:	48 b8 a3 8b 2e ba e8 	movabs $0x2e8ba2e8ba2e8ba3,%rax
  800222:	a2 8b 2e 
  800225:	48 0f af c2          	imul   %rdx,%rax
  800229:	48 89 c6             	mov    %rax,%rsi
  80022c:	48 bf 45 47 80 00 00 	movabs $0x804745,%rdi
  800233:	00 00 00 
  800236:	b8 00 00 00 00       	mov    $0x0,%eax
  80023b:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800242:	00 00 00 
  800245:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	eb 16                	jmp    800275 <umain+0x231>
		dup(p[0], 10);
  80025f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800262:	be 0a 00 00 00       	mov    $0xa,%esi
  800267:	89 c7                	mov    %eax,%edi
  800269:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800279:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80027f:	83 f8 02             	cmp    $0x2,%eax
  800282:	74 db                	je     80025f <umain+0x21b>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800284:	48 bf 50 47 80 00 00 	movabs $0x804750,%rdi
  80028b:	00 00 00 
  80028e:	b8 00 00 00 00       	mov    $0x0,%eax
  800293:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  80029a:	00 00 00 
  80029d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80029f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002a2:	89 c7                	mov    %eax,%edi
  8002a4:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	callq  *%rax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 2a                	je     8002de <umain+0x29a>
		panic("somehow the other end of p[0] got closed!");
  8002b4:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8002bb:	00 00 00 
  8002be:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002c3:	48 bf 02 47 80 00 00 	movabs $0x804702,%rdi
  8002ca:	00 00 00 
  8002cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d2:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8002d9:	00 00 00 
  8002dc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002de:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002e1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002e5:	48 89 d6             	mov    %rdx,%rsi
  8002e8:	89 c7                	mov    %eax,%edi
  8002ea:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax
  8002f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002f9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002fd:	79 30                	jns    80032f <umain+0x2eb>
		panic("cannot look up p[0]: %e", r);
  8002ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800302:	89 c1                	mov    %eax,%ecx
  800304:	48 ba 92 47 80 00 00 	movabs $0x804792,%rdx
  80030b:	00 00 00 
  80030e:	be 3c 00 00 00       	mov    $0x3c,%esi
  800313:	48 bf 02 47 80 00 00 	movabs $0x804702,%rdi
  80031a:	00 00 00 
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  800329:	00 00 00 
  80032c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80032f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800333:	48 89 c7             	mov    %rax,%rdi
  800336:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
  800342:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800346:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 b0 34 80 00 00 	movabs $0x8034b0,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
  800359:	83 f8 04             	cmp    $0x4,%eax
  80035c:	74 1d                	je     80037b <umain+0x337>
		cprintf("\nchild detected race\n");
  80035e:	48 bf aa 47 80 00 00 	movabs $0x8047aa,%rdi
  800365:	00 00 00 
  800368:	b8 00 00 00 00       	mov    $0x0,%eax
  80036d:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800374:	00 00 00 
  800377:	ff d2                	callq  *%rdx
  800379:	eb 20                	jmp    80039b <umain+0x357>
	else
		cprintf("\nrace didn't happen\n", max);
  80037b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80037e:	89 c6                	mov    %eax,%esi
  800380:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  800387:	00 00 00 
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
  80038f:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800396:	00 00 00 
  800399:	ff d2                	callq  *%rdx
}
  80039b:	c9                   	leaveq 
  80039c:	c3                   	retq   
  80039d:	00 00                	add    %al,(%rax)
	...

00000000008003a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003a0:	55                   	push   %rbp
  8003a1:	48 89 e5             	mov    %rsp,%rbp
  8003a4:	48 83 ec 10          	sub    $0x10,%rsp
  8003a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8003af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003b6:	00 00 00 
  8003b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8003c0:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
  8003cc:	48 98                	cltq   
  8003ce:	48 89 c2             	mov    %rax,%rdx
  8003d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8003d7:	48 89 d0             	mov    %rdx,%rax
  8003da:	48 c1 e0 02          	shl    $0x2,%rax
  8003de:	48 01 d0             	add    %rdx,%rax
  8003e1:	48 01 c0             	add    %rax,%rax
  8003e4:	48 01 d0             	add    %rdx,%rax
  8003e7:	48 c1 e0 05          	shl    $0x5,%rax
  8003eb:	48 89 c2             	mov    %rax,%rdx
  8003ee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003f5:	00 00 00 
  8003f8:	48 01 c2             	add    %rax,%rdx
  8003fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800402:	00 00 00 
  800405:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800408:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80040c:	7e 14                	jle    800422 <libmain+0x82>
		binaryname = argv[0];
  80040e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800412:	48 8b 10             	mov    (%rax),%rdx
  800415:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80041c:	00 00 00 
  80041f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800422:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800429:	48 89 d6             	mov    %rdx,%rsi
  80042c:	89 c7                	mov    %eax,%edi
  80042e:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80043a:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800441:	00 00 00 
  800444:	ff d0                	callq  *%rax
}
  800446:	c9                   	leaveq 
  800447:	c3                   	retq   

0000000000800448 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800448:	55                   	push   %rbp
  800449:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80044c:	48 b8 c9 2b 80 00 00 	movabs $0x802bc9,%rax
  800453:	00 00 00 
  800456:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800458:	bf 00 00 00 00       	mov    $0x0,%edi
  80045d:	48 b8 f0 1a 80 00 00 	movabs $0x801af0,%rax
  800464:	00 00 00 
  800467:	ff d0                	callq  *%rax
}
  800469:	5d                   	pop    %rbp
  80046a:	c3                   	retq   
	...

000000000080046c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	53                   	push   %rbx
  800471:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800478:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80047f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800485:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80048c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800493:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80049a:	84 c0                	test   %al,%al
  80049c:	74 23                	je     8004c1 <_panic+0x55>
  80049e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004a5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004a9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004ad:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004b1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8004b5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8004b9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8004bd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8004c1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004c8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004cf:	00 00 00 
  8004d2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004d9:	00 00 00 
  8004dc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004e0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004e7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004fc:	00 00 00 
  8004ff:	48 8b 18             	mov    (%rax),%rbx
  800502:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  800509:	00 00 00 
  80050c:	ff d0                	callq  *%rax
  80050e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800514:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80051b:	41 89 c8             	mov    %ecx,%r8d
  80051e:	48 89 d1             	mov    %rdx,%rcx
  800521:	48 89 da             	mov    %rbx,%rdx
  800524:	89 c6                	mov    %eax,%esi
  800526:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  80052d:	00 00 00 
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	49 b9 a7 06 80 00 00 	movabs $0x8006a7,%r9
  80053c:	00 00 00 
  80053f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800542:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800549:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800550:	48 89 d6             	mov    %rdx,%rsi
  800553:	48 89 c7             	mov    %rax,%rdi
  800556:	48 b8 fb 05 80 00 00 	movabs $0x8005fb,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
	cprintf("\n");
  800562:	48 bf 03 48 80 00 00 	movabs $0x804803,%rdi
  800569:	00 00 00 
  80056c:	b8 00 00 00 00       	mov    $0x0,%eax
  800571:	48 ba a7 06 80 00 00 	movabs $0x8006a7,%rdx
  800578:	00 00 00 
  80057b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80057d:	cc                   	int3   
  80057e:	eb fd                	jmp    80057d <_panic+0x111>

0000000000800580 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800580:	55                   	push   %rbp
  800581:	48 89 e5             	mov    %rsp,%rbp
  800584:	48 83 ec 10          	sub    $0x10,%rsp
  800588:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80058b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80058f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800593:	8b 00                	mov    (%rax),%eax
  800595:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800598:	89 d6                	mov    %edx,%esi
  80059a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80059e:	48 63 d0             	movslq %eax,%rdx
  8005a1:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8005a6:	8d 50 01             	lea    0x1(%rax),%edx
  8005a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ad:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8005af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b3:	8b 00                	mov    (%rax),%eax
  8005b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ba:	75 2c                	jne    8005e8 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8005bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c0:	8b 00                	mov    (%rax),%eax
  8005c2:	48 98                	cltq   
  8005c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005c8:	48 83 c2 08          	add    $0x8,%rdx
  8005cc:	48 89 c6             	mov    %rax,%rsi
  8005cf:	48 89 d7             	mov    %rdx,%rdi
  8005d2:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  8005d9:	00 00 00 
  8005dc:	ff d0                	callq  *%rax
        b->idx = 0;
  8005de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ec:	8b 40 04             	mov    0x4(%rax),%eax
  8005ef:	8d 50 01             	lea    0x1(%rax),%edx
  8005f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005f9:	c9                   	leaveq 
  8005fa:	c3                   	retq   

00000000008005fb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005fb:	55                   	push   %rbp
  8005fc:	48 89 e5             	mov    %rsp,%rbp
  8005ff:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800606:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80060d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800614:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80061b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800622:	48 8b 0a             	mov    (%rdx),%rcx
  800625:	48 89 08             	mov    %rcx,(%rax)
  800628:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800630:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800634:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800638:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80063f:	00 00 00 
    b.cnt = 0;
  800642:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800649:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80064c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800653:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80065a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800661:	48 89 c6             	mov    %rax,%rsi
  800664:	48 bf 80 05 80 00 00 	movabs $0x800580,%rdi
  80066b:	00 00 00 
  80066e:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  800675:	00 00 00 
  800678:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80067a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800680:	48 98                	cltq   
  800682:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800689:	48 83 c2 08          	add    $0x8,%rdx
  80068d:	48 89 c6             	mov    %rax,%rsi
  800690:	48 89 d7             	mov    %rdx,%rdi
  800693:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  80069a:	00 00 00 
  80069d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80069f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006a5:	c9                   	leaveq 
  8006a6:	c3                   	retq   

00000000008006a7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006a7:	55                   	push   %rbp
  8006a8:	48 89 e5             	mov    %rsp,%rbp
  8006ab:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006b2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8006b9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8006c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8006c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006d5:	84 c0                	test   %al,%al
  8006d7:	74 20                	je     8006f9 <cprintf+0x52>
  8006d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006f9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800700:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800707:	00 00 00 
  80070a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800711:	00 00 00 
  800714:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800718:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80071f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800726:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80072d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800734:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80073b:	48 8b 0a             	mov    (%rdx),%rcx
  80073e:	48 89 08             	mov    %rcx,(%rax)
  800741:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800745:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800749:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80074d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800751:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800758:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80075f:	48 89 d6             	mov    %rdx,%rsi
  800762:	48 89 c7             	mov    %rax,%rdi
  800765:	48 b8 fb 05 80 00 00 	movabs $0x8005fb,%rax
  80076c:	00 00 00 
  80076f:	ff d0                	callq  *%rax
  800771:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800777:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80077d:	c9                   	leaveq 
  80077e:	c3                   	retq   
	...

0000000000800780 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800780:	55                   	push   %rbp
  800781:	48 89 e5             	mov    %rsp,%rbp
  800784:	48 83 ec 30          	sub    $0x30,%rsp
  800788:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80078c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800790:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800794:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800797:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80079b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80079f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007a2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8007a6:	77 52                	ja     8007fa <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007ab:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007af:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8007b2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	48 f7 75 d0          	divq   -0x30(%rbp)
  8007c3:	48 89 c2             	mov    %rax,%rdx
  8007c6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8007c9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007cc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8007d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007d4:	41 89 f9             	mov    %edi,%r9d
  8007d7:	48 89 c7             	mov    %rax,%rdi
  8007da:	48 b8 80 07 80 00 00 	movabs $0x800780,%rax
  8007e1:	00 00 00 
  8007e4:	ff d0                	callq  *%rax
  8007e6:	eb 1c                	jmp    800804 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8007ef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007f3:	48 89 d6             	mov    %rdx,%rsi
  8007f6:	89 c7                	mov    %eax,%edi
  8007f8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007fa:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800802:	7f e4                	jg     8007e8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800804:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	ba 00 00 00 00       	mov    $0x0,%edx
  800810:	48 f7 f1             	div    %rcx
  800813:	48 89 d0             	mov    %rdx,%rax
  800816:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
  80081d:	00 00 00 
  800820:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800824:	0f be c0             	movsbl %al,%eax
  800827:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80082b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80082f:	48 89 d6             	mov    %rdx,%rsi
  800832:	89 c7                	mov    %eax,%edi
  800834:	ff d1                	callq  *%rcx
}
  800836:	c9                   	leaveq 
  800837:	c3                   	retq   

0000000000800838 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800838:	55                   	push   %rbp
  800839:	48 89 e5             	mov    %rsp,%rbp
  80083c:	48 83 ec 20          	sub    $0x20,%rsp
  800840:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800844:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800847:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80084b:	7e 52                	jle    80089f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80084d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800851:	8b 00                	mov    (%rax),%eax
  800853:	83 f8 30             	cmp    $0x30,%eax
  800856:	73 24                	jae    80087c <getuint+0x44>
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800864:	8b 00                	mov    (%rax),%eax
  800866:	89 c0                	mov    %eax,%eax
  800868:	48 01 d0             	add    %rdx,%rax
  80086b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086f:	8b 12                	mov    (%rdx),%edx
  800871:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	89 0a                	mov    %ecx,(%rdx)
  80087a:	eb 17                	jmp    800893 <getuint+0x5b>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800884:	48 89 d0             	mov    %rdx,%rax
  800887:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800893:	48 8b 00             	mov    (%rax),%rax
  800896:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089a:	e9 a3 00 00 00       	jmpq   800942 <getuint+0x10a>
	else if (lflag)
  80089f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008a3:	74 4f                	je     8008f4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	8b 00                	mov    (%rax),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 24                	jae    8008d4 <getuint+0x9c>
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	8b 12                	mov    (%rdx),%edx
  8008c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	89 0a                	mov    %ecx,(%rdx)
  8008d2:	eb 17                	jmp    8008eb <getuint+0xb3>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008eb:	48 8b 00             	mov    (%rax),%rax
  8008ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f2:	eb 4e                	jmp    800942 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 24                	jae    800923 <getuint+0xeb>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	8b 00                	mov    (%rax),%eax
  80090d:	89 c0                	mov    %eax,%eax
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	8b 12                	mov    (%rdx),%edx
  800918:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	89 0a                	mov    %ecx,(%rdx)
  800921:	eb 17                	jmp    80093a <getuint+0x102>
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092b:	48 89 d0             	mov    %rdx,%rax
  80092e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800936:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093a:	8b 00                	mov    (%rax),%eax
  80093c:	89 c0                	mov    %eax,%eax
  80093e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800942:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800946:	c9                   	leaveq 
  800947:	c3                   	retq   

0000000000800948 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800948:	55                   	push   %rbp
  800949:	48 89 e5             	mov    %rsp,%rbp
  80094c:	48 83 ec 20          	sub    $0x20,%rsp
  800950:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800954:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800957:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80095b:	7e 52                	jle    8009af <getint+0x67>
		x=va_arg(*ap, long long);
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	8b 00                	mov    (%rax),%eax
  800963:	83 f8 30             	cmp    $0x30,%eax
  800966:	73 24                	jae    80098c <getint+0x44>
  800968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800974:	8b 00                	mov    (%rax),%eax
  800976:	89 c0                	mov    %eax,%eax
  800978:	48 01 d0             	add    %rdx,%rax
  80097b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097f:	8b 12                	mov    (%rdx),%edx
  800981:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800984:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800988:	89 0a                	mov    %ecx,(%rdx)
  80098a:	eb 17                	jmp    8009a3 <getint+0x5b>
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800994:	48 89 d0             	mov    %rdx,%rax
  800997:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a3:	48 8b 00             	mov    (%rax),%rax
  8009a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009aa:	e9 a3 00 00 00       	jmpq   800a52 <getint+0x10a>
	else if (lflag)
  8009af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009b3:	74 4f                	je     800a04 <getint+0xbc>
		x=va_arg(*ap, long);
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 24                	jae    8009e4 <getint+0x9c>
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d7:	8b 12                	mov    (%rdx),%edx
  8009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e0:	89 0a                	mov    %ecx,(%rdx)
  8009e2:	eb 17                	jmp    8009fb <getint+0xb3>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ec:	48 89 d0             	mov    %rdx,%rax
  8009ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fb:	48 8b 00             	mov    (%rax),%rax
  8009fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a02:	eb 4e                	jmp    800a52 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	83 f8 30             	cmp    $0x30,%eax
  800a0d:	73 24                	jae    800a33 <getint+0xeb>
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1b:	8b 00                	mov    (%rax),%eax
  800a1d:	89 c0                	mov    %eax,%eax
  800a1f:	48 01 d0             	add    %rdx,%rax
  800a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a26:	8b 12                	mov    (%rdx),%edx
  800a28:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	89 0a                	mov    %ecx,(%rdx)
  800a31:	eb 17                	jmp    800a4a <getint+0x102>
  800a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a37:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3b:	48 89 d0             	mov    %rdx,%rax
  800a3e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a46:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4a:	8b 00                	mov    (%rax),%eax
  800a4c:	48 98                	cltq   
  800a4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a56:	c9                   	leaveq 
  800a57:	c3                   	retq   

0000000000800a58 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a58:	55                   	push   %rbp
  800a59:	48 89 e5             	mov    %rsp,%rbp
  800a5c:	41 54                	push   %r12
  800a5e:	53                   	push   %rbx
  800a5f:	48 83 ec 60          	sub    $0x60,%rsp
  800a63:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a67:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a6b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a77:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a7b:	48 8b 0a             	mov    (%rdx),%rcx
  800a7e:	48 89 08             	mov    %rcx,(%rax)
  800a81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a91:	eb 17                	jmp    800aaa <vprintfmt+0x52>
			if (ch == '\0')
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	0f 84 ea 04 00 00    	je     800f85 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800a9b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a9f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aa3:	48 89 c6             	mov    %rax,%rsi
  800aa6:	89 df                	mov    %ebx,%edi
  800aa8:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aaa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aae:	0f b6 00             	movzbl (%rax),%eax
  800ab1:	0f b6 d8             	movzbl %al,%ebx
  800ab4:	83 fb 25             	cmp    $0x25,%ebx
  800ab7:	0f 95 c0             	setne  %al
  800aba:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800abf:	84 c0                	test   %al,%al
  800ac1:	75 d0                	jne    800a93 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ac3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800ac7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ace:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ad5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800adc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800ae3:	eb 04                	jmp    800ae9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800ae5:	90                   	nop
  800ae6:	eb 01                	jmp    800ae9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800ae8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ae9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aed:	0f b6 00             	movzbl (%rax),%eax
  800af0:	0f b6 d8             	movzbl %al,%ebx
  800af3:	89 d8                	mov    %ebx,%eax
  800af5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800afa:	83 e8 23             	sub    $0x23,%eax
  800afd:	83 f8 55             	cmp    $0x55,%eax
  800b00:	0f 87 4b 04 00 00    	ja     800f51 <vprintfmt+0x4f9>
  800b06:	89 c0                	mov    %eax,%eax
  800b08:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b0f:	00 
  800b10:	48 b8 38 4a 80 00 00 	movabs $0x804a38,%rax
  800b17:	00 00 00 
  800b1a:	48 01 d0             	add    %rdx,%rax
  800b1d:	48 8b 00             	mov    (%rax),%rax
  800b20:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b22:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b26:	eb c1                	jmp    800ae9 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b28:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b2c:	eb bb                	jmp    800ae9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b35:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b38:	89 d0                	mov    %edx,%eax
  800b3a:	c1 e0 02             	shl    $0x2,%eax
  800b3d:	01 d0                	add    %edx,%eax
  800b3f:	01 c0                	add    %eax,%eax
  800b41:	01 d8                	add    %ebx,%eax
  800b43:	83 e8 30             	sub    $0x30,%eax
  800b46:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b49:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b4d:	0f b6 00             	movzbl (%rax),%eax
  800b50:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b53:	83 fb 2f             	cmp    $0x2f,%ebx
  800b56:	7e 63                	jle    800bbb <vprintfmt+0x163>
  800b58:	83 fb 39             	cmp    $0x39,%ebx
  800b5b:	7f 5e                	jg     800bbb <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b5d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b62:	eb d1                	jmp    800b35 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b67:	83 f8 30             	cmp    $0x30,%eax
  800b6a:	73 17                	jae    800b83 <vprintfmt+0x12b>
  800b6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b73:	89 c0                	mov    %eax,%eax
  800b75:	48 01 d0             	add    %rdx,%rax
  800b78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7b:	83 c2 08             	add    $0x8,%edx
  800b7e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b81:	eb 0f                	jmp    800b92 <vprintfmt+0x13a>
  800b83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b87:	48 89 d0             	mov    %rdx,%rax
  800b8a:	48 83 c2 08          	add    $0x8,%rdx
  800b8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b92:	8b 00                	mov    (%rax),%eax
  800b94:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b97:	eb 23                	jmp    800bbc <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9d:	0f 89 42 ff ff ff    	jns    800ae5 <vprintfmt+0x8d>
				width = 0;
  800ba3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800baa:	e9 36 ff ff ff       	jmpq   800ae5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800baf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800bb6:	e9 2e ff ff ff       	jmpq   800ae9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bbb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc0:	0f 89 22 ff ff ff    	jns    800ae8 <vprintfmt+0x90>
				width = precision, precision = -1;
  800bc6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bc9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800bcc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800bd3:	e9 10 ff ff ff       	jmpq   800ae8 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bd8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bdc:	e9 08 ff ff ff       	jmpq   800ae9 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 30             	cmp    $0x30,%eax
  800be7:	73 17                	jae    800c00 <vprintfmt+0x1a8>
  800be9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf0:	89 c0                	mov    %eax,%eax
  800bf2:	48 01 d0             	add    %rdx,%rax
  800bf5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf8:	83 c2 08             	add    $0x8,%edx
  800bfb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfe:	eb 0f                	jmp    800c0f <vprintfmt+0x1b7>
  800c00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c04:	48 89 d0             	mov    %rdx,%rax
  800c07:	48 83 c2 08          	add    $0x8,%rdx
  800c0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0f:	8b 00                	mov    (%rax),%eax
  800c11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c15:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c19:	48 89 d6             	mov    %rdx,%rsi
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	ff d1                	callq  *%rcx
			break;
  800c20:	e9 5a 03 00 00       	jmpq   800f7f <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c28:	83 f8 30             	cmp    $0x30,%eax
  800c2b:	73 17                	jae    800c44 <vprintfmt+0x1ec>
  800c2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c34:	89 c0                	mov    %eax,%eax
  800c36:	48 01 d0             	add    %rdx,%rax
  800c39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c3c:	83 c2 08             	add    $0x8,%edx
  800c3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x1fb>
  800c44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c48:	48 89 d0             	mov    %rdx,%rax
  800c4b:	48 83 c2 08          	add    $0x8,%rdx
  800c4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c53:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c55:	85 db                	test   %ebx,%ebx
  800c57:	79 02                	jns    800c5b <vprintfmt+0x203>
				err = -err;
  800c59:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c5b:	83 fb 15             	cmp    $0x15,%ebx
  800c5e:	7f 16                	jg     800c76 <vprintfmt+0x21e>
  800c60:	48 b8 60 49 80 00 00 	movabs $0x804960,%rax
  800c67:	00 00 00 
  800c6a:	48 63 d3             	movslq %ebx,%rdx
  800c6d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c71:	4d 85 e4             	test   %r12,%r12
  800c74:	75 2e                	jne    800ca4 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c76:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7e:	89 d9                	mov    %ebx,%ecx
  800c80:	48 ba 21 4a 80 00 00 	movabs $0x804a21,%rdx
  800c87:	00 00 00 
  800c8a:	48 89 c7             	mov    %rax,%rdi
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	49 b8 8f 0f 80 00 00 	movabs $0x800f8f,%r8
  800c99:	00 00 00 
  800c9c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c9f:	e9 db 02 00 00       	jmpq   800f7f <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ca4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ca8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cac:	4c 89 e1             	mov    %r12,%rcx
  800caf:	48 ba 2a 4a 80 00 00 	movabs $0x804a2a,%rdx
  800cb6:	00 00 00 
  800cb9:	48 89 c7             	mov    %rax,%rdi
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	49 b8 8f 0f 80 00 00 	movabs $0x800f8f,%r8
  800cc8:	00 00 00 
  800ccb:	41 ff d0             	callq  *%r8
			break;
  800cce:	e9 ac 02 00 00       	jmpq   800f7f <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800cd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd6:	83 f8 30             	cmp    $0x30,%eax
  800cd9:	73 17                	jae    800cf2 <vprintfmt+0x29a>
  800cdb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce2:	89 c0                	mov    %eax,%eax
  800ce4:	48 01 d0             	add    %rdx,%rax
  800ce7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cea:	83 c2 08             	add    $0x8,%edx
  800ced:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf0:	eb 0f                	jmp    800d01 <vprintfmt+0x2a9>
  800cf2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf6:	48 89 d0             	mov    %rdx,%rax
  800cf9:	48 83 c2 08          	add    $0x8,%rdx
  800cfd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d01:	4c 8b 20             	mov    (%rax),%r12
  800d04:	4d 85 e4             	test   %r12,%r12
  800d07:	75 0a                	jne    800d13 <vprintfmt+0x2bb>
				p = "(null)";
  800d09:	49 bc 2d 4a 80 00 00 	movabs $0x804a2d,%r12
  800d10:	00 00 00 
			if (width > 0 && padc != '-')
  800d13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d17:	7e 7a                	jle    800d93 <vprintfmt+0x33b>
  800d19:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d1d:	74 74                	je     800d93 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d22:	48 98                	cltq   
  800d24:	48 89 c6             	mov    %rax,%rsi
  800d27:	4c 89 e7             	mov    %r12,%rdi
  800d2a:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  800d31:	00 00 00 
  800d34:	ff d0                	callq  *%rax
  800d36:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d39:	eb 17                	jmp    800d52 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800d3b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800d3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d43:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d47:	48 89 d6             	mov    %rdx,%rsi
  800d4a:	89 c7                	mov    %eax,%edi
  800d4c:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d56:	7f e3                	jg     800d3b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d58:	eb 39                	jmp    800d93 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800d5a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d5e:	74 1e                	je     800d7e <vprintfmt+0x326>
  800d60:	83 fb 1f             	cmp    $0x1f,%ebx
  800d63:	7e 05                	jle    800d6a <vprintfmt+0x312>
  800d65:	83 fb 7e             	cmp    $0x7e,%ebx
  800d68:	7e 14                	jle    800d7e <vprintfmt+0x326>
					putch('?', putdat);
  800d6a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d6e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d72:	48 89 c6             	mov    %rax,%rsi
  800d75:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d7a:	ff d2                	callq  *%rdx
  800d7c:	eb 0f                	jmp    800d8d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d7e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d82:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d86:	48 89 c6             	mov    %rax,%rsi
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d91:	eb 01                	jmp    800d94 <vprintfmt+0x33c>
  800d93:	90                   	nop
  800d94:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d99:	0f be d8             	movsbl %al,%ebx
  800d9c:	85 db                	test   %ebx,%ebx
  800d9e:	0f 95 c0             	setne  %al
  800da1:	49 83 c4 01          	add    $0x1,%r12
  800da5:	84 c0                	test   %al,%al
  800da7:	74 28                	je     800dd1 <vprintfmt+0x379>
  800da9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dad:	78 ab                	js     800d5a <vprintfmt+0x302>
  800daf:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800db3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800db7:	79 a1                	jns    800d5a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db9:	eb 16                	jmp    800dd1 <vprintfmt+0x379>
				putch(' ', putdat);
  800dbb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dbf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dc3:	48 89 c6             	mov    %rax,%rsi
  800dc6:	bf 20 00 00 00       	mov    $0x20,%edi
  800dcb:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dcd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd5:	7f e4                	jg     800dbb <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800dd7:	e9 a3 01 00 00       	jmpq   800f7f <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ddc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de0:	be 03 00 00 00       	mov    $0x3,%esi
  800de5:	48 89 c7             	mov    %rax,%rdi
  800de8:	48 b8 48 09 80 00 00 	movabs $0x800948,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfc:	48 85 c0             	test   %rax,%rax
  800dff:	79 1d                	jns    800e1e <vprintfmt+0x3c6>
				putch('-', putdat);
  800e01:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e05:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e09:	48 89 c6             	mov    %rax,%rsi
  800e0c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e11:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	48 f7 d8             	neg    %rax
  800e1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e25:	e9 e8 00 00 00       	jmpq   800f12 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2e:	be 03 00 00 00       	mov    $0x3,%esi
  800e33:	48 89 c7             	mov    %rax,%rdi
  800e36:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800e3d:	00 00 00 
  800e40:	ff d0                	callq  *%rax
  800e42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e46:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e4d:	e9 c0 00 00 00       	jmpq   800f12 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e52:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e56:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e5a:	48 89 c6             	mov    %rax,%rsi
  800e5d:	bf 58 00 00 00       	mov    $0x58,%edi
  800e62:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e64:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e68:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e6c:	48 89 c6             	mov    %rax,%rsi
  800e6f:	bf 58 00 00 00       	mov    $0x58,%edi
  800e74:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e76:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e7a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e7e:	48 89 c6             	mov    %rax,%rsi
  800e81:	bf 58 00 00 00       	mov    $0x58,%edi
  800e86:	ff d2                	callq  *%rdx
			break;
  800e88:	e9 f2 00 00 00       	jmpq   800f7f <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800e8d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e91:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e95:	48 89 c6             	mov    %rax,%rsi
  800e98:	bf 30 00 00 00       	mov    $0x30,%edi
  800e9d:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e9f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ea3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ea7:	48 89 c6             	mov    %rax,%rsi
  800eaa:	bf 78 00 00 00       	mov    $0x78,%edi
  800eaf:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800eb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb4:	83 f8 30             	cmp    $0x30,%eax
  800eb7:	73 17                	jae    800ed0 <vprintfmt+0x478>
  800eb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ebd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec0:	89 c0                	mov    %eax,%eax
  800ec2:	48 01 d0             	add    %rdx,%rax
  800ec5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ec8:	83 c2 08             	add    $0x8,%edx
  800ecb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ece:	eb 0f                	jmp    800edf <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800ed0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ed4:	48 89 d0             	mov    %rdx,%rax
  800ed7:	48 83 c2 08          	add    $0x8,%rdx
  800edb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800edf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ee6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800eed:	eb 23                	jmp    800f12 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800eef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef3:	be 03 00 00 00       	mov    $0x3,%esi
  800ef8:	48 89 c7             	mov    %rax,%rdi
  800efb:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800f02:	00 00 00 
  800f05:	ff d0                	callq  *%rax
  800f07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f0b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f12:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f17:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f1a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f29:	45 89 c1             	mov    %r8d,%r9d
  800f2c:	41 89 f8             	mov    %edi,%r8d
  800f2f:	48 89 c7             	mov    %rax,%rdi
  800f32:	48 b8 80 07 80 00 00 	movabs $0x800780,%rax
  800f39:	00 00 00 
  800f3c:	ff d0                	callq  *%rax
			break;
  800f3e:	eb 3f                	jmp    800f7f <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f40:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f44:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f48:	48 89 c6             	mov    %rax,%rsi
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	ff d2                	callq  *%rdx
			break;
  800f4f:	eb 2e                	jmp    800f7f <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f51:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f55:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f59:	48 89 c6             	mov    %rax,%rsi
  800f5c:	bf 25 00 00 00       	mov    $0x25,%edi
  800f61:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f63:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f68:	eb 05                	jmp    800f6f <vprintfmt+0x517>
  800f6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f73:	48 83 e8 01          	sub    $0x1,%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	3c 25                	cmp    $0x25,%al
  800f7c:	75 ec                	jne    800f6a <vprintfmt+0x512>
				/* do nothing */;
			break;
  800f7e:	90                   	nop
		}
	}
  800f7f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f80:	e9 25 fb ff ff       	jmpq   800aaa <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f85:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f86:	48 83 c4 60          	add    $0x60,%rsp
  800f8a:	5b                   	pop    %rbx
  800f8b:	41 5c                	pop    %r12
  800f8d:	5d                   	pop    %rbp
  800f8e:	c3                   	retq   

0000000000800f8f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f8f:	55                   	push   %rbp
  800f90:	48 89 e5             	mov    %rsp,%rbp
  800f93:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f9a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fa1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fa8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800faf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fb6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fbd:	84 c0                	test   %al,%al
  800fbf:	74 20                	je     800fe1 <printfmt+0x52>
  800fc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fdd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fe8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fef:	00 00 00 
  800ff2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ff9:	00 00 00 
  800ffc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801000:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801007:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80100e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801015:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80101c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801023:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80102a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801031:	48 89 c7             	mov    %rax,%rdi
  801034:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  80103b:	00 00 00 
  80103e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801040:	c9                   	leaveq 
  801041:	c3                   	retq   

0000000000801042 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801042:	55                   	push   %rbp
  801043:	48 89 e5             	mov    %rsp,%rbp
  801046:	48 83 ec 10          	sub    $0x10,%rsp
  80104a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80104d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801051:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801055:	8b 40 10             	mov    0x10(%rax),%eax
  801058:	8d 50 01             	lea    0x1(%rax),%edx
  80105b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801066:	48 8b 10             	mov    (%rax),%rdx
  801069:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801071:	48 39 c2             	cmp    %rax,%rdx
  801074:	73 17                	jae    80108d <sprintputch+0x4b>
		*b->buf++ = ch;
  801076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107a:	48 8b 00             	mov    (%rax),%rax
  80107d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801080:	88 10                	mov    %dl,(%rax)
  801082:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108a:	48 89 10             	mov    %rdx,(%rax)
}
  80108d:	c9                   	leaveq 
  80108e:	c3                   	retq   

000000000080108f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80108f:	55                   	push   %rbp
  801090:	48 89 e5             	mov    %rsp,%rbp
  801093:	48 83 ec 50          	sub    $0x50,%rsp
  801097:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80109b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80109e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010a2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010a6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010aa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010ae:	48 8b 0a             	mov    (%rdx),%rcx
  8010b1:	48 89 08             	mov    %rcx,(%rax)
  8010b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010c8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010cc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010cf:	48 98                	cltq   
  8010d1:	48 83 e8 01          	sub    $0x1,%rax
  8010d5:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8010d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010e4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010e9:	74 06                	je     8010f1 <vsnprintf+0x62>
  8010eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010ef:	7f 07                	jg     8010f8 <vsnprintf+0x69>
		return -E_INVAL;
  8010f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f6:	eb 2f                	jmp    801127 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010f8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010fc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801100:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801104:	48 89 c6             	mov    %rax,%rsi
  801107:	48 bf 42 10 80 00 00 	movabs $0x801042,%rdi
  80110e:	00 00 00 
  801111:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  801118:	00 00 00 
  80111b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80111d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801121:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801124:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801127:	c9                   	leaveq 
  801128:	c3                   	retq   

0000000000801129 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801129:	55                   	push   %rbp
  80112a:	48 89 e5             	mov    %rsp,%rbp
  80112d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801134:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80113b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801141:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801148:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80114f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801156:	84 c0                	test   %al,%al
  801158:	74 20                	je     80117a <snprintf+0x51>
  80115a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80115e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801162:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801166:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80116a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80116e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801172:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801176:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80117a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801181:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801188:	00 00 00 
  80118b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801192:	00 00 00 
  801195:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801199:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011bc:	48 8b 0a             	mov    (%rdx),%rcx
  8011bf:	48 89 08             	mov    %rcx,(%rax)
  8011c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011d2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011d9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011e0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011ed:	48 89 c7             	mov    %rax,%rdi
  8011f0:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	callq  *%rax
  8011fc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801202:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   
	...

000000000080120c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80120c:	55                   	push   %rbp
  80120d:	48 89 e5             	mov    %rsp,%rbp
  801210:	48 83 ec 18          	sub    $0x18,%rsp
  801214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80121f:	eb 09                	jmp    80122a <strlen+0x1e>
		n++;
  801221:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801225:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	75 ec                	jne    801221 <strlen+0x15>
		n++;
	return n;
  801235:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801238:	c9                   	leaveq 
  801239:	c3                   	retq   

000000000080123a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80123a:	55                   	push   %rbp
  80123b:	48 89 e5             	mov    %rsp,%rbp
  80123e:	48 83 ec 20          	sub    $0x20,%rsp
  801242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80124a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801251:	eb 0e                	jmp    801261 <strnlen+0x27>
		n++;
  801253:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801257:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80125c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801261:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801266:	74 0b                	je     801273 <strnlen+0x39>
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	84 c0                	test   %al,%al
  801271:	75 e0                	jne    801253 <strnlen+0x19>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801276:	c9                   	leaveq 
  801277:	c3                   	retq   

0000000000801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %rbp
  801279:	48 89 e5             	mov    %rsp,%rbp
  80127c:	48 83 ec 20          	sub    $0x20,%rsp
  801280:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801284:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801290:	90                   	nop
  801291:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801295:	0f b6 10             	movzbl (%rax),%edx
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	88 10                	mov    %dl,(%rax)
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	84 c0                	test   %al,%al
  8012a7:	0f 95 c0             	setne  %al
  8012aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8012b4:	84 c0                	test   %al,%al
  8012b6:	75 d9                	jne    801291 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 20          	sub    $0x20,%rsp
  8012c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
  8012e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012e7:	48 98                	cltq   
  8012e9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8012ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f1:	48 89 d6             	mov    %rdx,%rsi
  8012f4:	48 89 c7             	mov    %rax,%rdi
  8012f7:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  8012fe:	00 00 00 
  801301:	ff d0                	callq  *%rax
	return dst;
  801303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801307:	c9                   	leaveq 
  801308:	c3                   	retq   

0000000000801309 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	48 83 ec 28          	sub    $0x28,%rsp
  801311:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801315:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801319:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801321:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801325:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80132c:	00 
  80132d:	eb 27                	jmp    801356 <strncpy+0x4d>
		*dst++ = *src;
  80132f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801333:	0f b6 10             	movzbl (%rax),%edx
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	88 10                	mov    %dl,(%rax)
  80133c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801341:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	84 c0                	test   %al,%al
  80134a:	74 05                	je     801351 <strncpy+0x48>
			src++;
  80134c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801351:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80135e:	72 cf                	jb     80132f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801360:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801364:	c9                   	leaveq 
  801365:	c3                   	retq   

0000000000801366 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801366:	55                   	push   %rbp
  801367:	48 89 e5             	mov    %rsp,%rbp
  80136a:	48 83 ec 28          	sub    $0x28,%rsp
  80136e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801372:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801376:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80137a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801382:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801387:	74 37                	je     8013c0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801389:	eb 17                	jmp    8013a2 <strlcpy+0x3c>
			*dst++ = *src++;
  80138b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138f:	0f b6 10             	movzbl (%rax),%edx
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801396:	88 10                	mov    %dl,(%rax)
  801398:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80139d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013ac:	74 0b                	je     8013b9 <strlcpy+0x53>
  8013ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	84 c0                	test   %al,%al
  8013b7:	75 d2                	jne    80138b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	48 89 d1             	mov    %rdx,%rcx
  8013cb:	48 29 c1             	sub    %rax,%rcx
  8013ce:	48 89 c8             	mov    %rcx,%rax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 10          	sub    $0x10,%rsp
  8013db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013e3:	eb 0a                	jmp    8013ef <strcmp+0x1c>
		p++, q++;
  8013e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	0f b6 00             	movzbl (%rax),%eax
  8013f6:	84 c0                	test   %al,%al
  8013f8:	74 12                	je     80140c <strcmp+0x39>
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	0f b6 10             	movzbl (%rax),%edx
  801401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	38 c2                	cmp    %al,%dl
  80140a:	74 d9                	je     8013e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	0f b6 d0             	movzbl %al,%edx
  801416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141a:	0f b6 00             	movzbl (%rax),%eax
  80141d:	0f b6 c0             	movzbl %al,%eax
  801420:	89 d1                	mov    %edx,%ecx
  801422:	29 c1                	sub    %eax,%ecx
  801424:	89 c8                	mov    %ecx,%eax
}
  801426:	c9                   	leaveq 
  801427:	c3                   	retq   

0000000000801428 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801428:	55                   	push   %rbp
  801429:	48 89 e5             	mov    %rsp,%rbp
  80142c:	48 83 ec 18          	sub    $0x18,%rsp
  801430:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801434:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801438:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80143c:	eb 0f                	jmp    80144d <strncmp+0x25>
		n--, p++, q++;
  80143e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801443:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801448:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80144d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801452:	74 1d                	je     801471 <strncmp+0x49>
  801454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801458:	0f b6 00             	movzbl (%rax),%eax
  80145b:	84 c0                	test   %al,%al
  80145d:	74 12                	je     801471 <strncmp+0x49>
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 10             	movzbl (%rax),%edx
  801466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	38 c2                	cmp    %al,%dl
  80146f:	74 cd                	je     80143e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801471:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801476:	75 07                	jne    80147f <strncmp+0x57>
		return 0;
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
  80147d:	eb 1a                	jmp    801499 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80147f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	0f b6 d0             	movzbl %al,%edx
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	0f b6 c0             	movzbl %al,%eax
  801493:	89 d1                	mov    %edx,%ecx
  801495:	29 c1                	sub    %eax,%ecx
  801497:	89 c8                	mov    %ecx,%eax
}
  801499:	c9                   	leaveq 
  80149a:	c3                   	retq   

000000000080149b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80149b:	55                   	push   %rbp
  80149c:	48 89 e5             	mov    %rsp,%rbp
  80149f:	48 83 ec 10          	sub    $0x10,%rsp
  8014a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a7:	89 f0                	mov    %esi,%eax
  8014a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014ac:	eb 17                	jmp    8014c5 <strchr+0x2a>
		if (*s == c)
  8014ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b2:	0f b6 00             	movzbl (%rax),%eax
  8014b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014b8:	75 06                	jne    8014c0 <strchr+0x25>
			return (char *) s;
  8014ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014be:	eb 15                	jmp    8014d5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	84 c0                	test   %al,%al
  8014ce:	75 de                	jne    8014ae <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d5:	c9                   	leaveq 
  8014d6:	c3                   	retq   

00000000008014d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014d7:	55                   	push   %rbp
  8014d8:	48 89 e5             	mov    %rsp,%rbp
  8014db:	48 83 ec 10          	sub    $0x10,%rsp
  8014df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e3:	89 f0                	mov    %esi,%eax
  8014e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014e8:	eb 11                	jmp    8014fb <strfind+0x24>
		if (*s == c)
  8014ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014f4:	74 12                	je     801508 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	84 c0                	test   %al,%al
  801504:	75 e4                	jne    8014ea <strfind+0x13>
  801506:	eb 01                	jmp    801509 <strfind+0x32>
		if (*s == c)
			break;
  801508:	90                   	nop
	return (char *) s;
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80150d:	c9                   	leaveq 
  80150e:	c3                   	retq   

000000000080150f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80150f:	55                   	push   %rbp
  801510:	48 89 e5             	mov    %rsp,%rbp
  801513:	48 83 ec 18          	sub    $0x18,%rsp
  801517:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80151e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801522:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801527:	75 06                	jne    80152f <memset+0x20>
		return v;
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	eb 69                	jmp    801598 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80152f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801533:	83 e0 03             	and    $0x3,%eax
  801536:	48 85 c0             	test   %rax,%rax
  801539:	75 48                	jne    801583 <memset+0x74>
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	83 e0 03             	and    $0x3,%eax
  801542:	48 85 c0             	test   %rax,%rax
  801545:	75 3c                	jne    801583 <memset+0x74>
		c &= 0xFF;
  801547:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80154e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801551:	89 c2                	mov    %eax,%edx
  801553:	c1 e2 18             	shl    $0x18,%edx
  801556:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801559:	c1 e0 10             	shl    $0x10,%eax
  80155c:	09 c2                	or     %eax,%edx
  80155e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801561:	c1 e0 08             	shl    $0x8,%eax
  801564:	09 d0                	or     %edx,%eax
  801566:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	48 89 c1             	mov    %rax,%rcx
  801570:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801574:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801578:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80157b:	48 89 d7             	mov    %rdx,%rdi
  80157e:	fc                   	cld    
  80157f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801581:	eb 11                	jmp    801594 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801587:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80158e:	48 89 d7             	mov    %rdx,%rdi
  801591:	fc                   	cld    
  801592:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801598:	c9                   	leaveq 
  801599:	c3                   	retq   

000000000080159a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80159a:	55                   	push   %rbp
  80159b:	48 89 e5             	mov    %rsp,%rbp
  80159e:	48 83 ec 28          	sub    $0x28,%rsp
  8015a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015c6:	0f 83 88 00 00 00    	jae    801654 <memmove+0xba>
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d4:	48 01 d0             	add    %rdx,%rax
  8015d7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015db:	76 77                	jbe    801654 <memmove+0xba>
		s += n;
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f1:	83 e0 03             	and    $0x3,%eax
  8015f4:	48 85 c0             	test   %rax,%rax
  8015f7:	75 3b                	jne    801634 <memmove+0x9a>
  8015f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fd:	83 e0 03             	and    $0x3,%eax
  801600:	48 85 c0             	test   %rax,%rax
  801603:	75 2f                	jne    801634 <memmove+0x9a>
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	83 e0 03             	and    $0x3,%eax
  80160c:	48 85 c0             	test   %rax,%rax
  80160f:	75 23                	jne    801634 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801615:	48 83 e8 04          	sub    $0x4,%rax
  801619:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161d:	48 83 ea 04          	sub    $0x4,%rdx
  801621:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801625:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801629:	48 89 c7             	mov    %rax,%rdi
  80162c:	48 89 d6             	mov    %rdx,%rsi
  80162f:	fd                   	std    
  801630:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801632:	eb 1d                	jmp    801651 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801638:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80163c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801640:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 89 d7             	mov    %rdx,%rdi
  80164b:	48 89 c1             	mov    %rax,%rcx
  80164e:	fd                   	std    
  80164f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801651:	fc                   	cld    
  801652:	eb 57                	jmp    8016ab <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	83 e0 03             	and    $0x3,%eax
  80165b:	48 85 c0             	test   %rax,%rax
  80165e:	75 36                	jne    801696 <memmove+0xfc>
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801664:	83 e0 03             	and    $0x3,%eax
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	75 2a                	jne    801696 <memmove+0xfc>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	83 e0 03             	and    $0x3,%eax
  801673:	48 85 c0             	test   %rax,%rax
  801676:	75 1e                	jne    801696 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 89 c1             	mov    %rax,%rcx
  80167f:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801687:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80168b:	48 89 c7             	mov    %rax,%rdi
  80168e:	48 89 d6             	mov    %rdx,%rsi
  801691:	fc                   	cld    
  801692:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801694:	eb 15                	jmp    8016ab <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016a2:	48 89 c7             	mov    %rax,%rdi
  8016a5:	48 89 d6             	mov    %rdx,%rsi
  8016a8:	fc                   	cld    
  8016a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016af:	c9                   	leaveq 
  8016b0:	c3                   	retq   

00000000008016b1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	48 83 ec 18          	sub    $0x18,%rsp
  8016b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d1:	48 89 ce             	mov    %rcx,%rsi
  8016d4:	48 89 c7             	mov    %rax,%rdi
  8016d7:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  8016de:	00 00 00 
  8016e1:	ff d0                	callq  *%rax
}
  8016e3:	c9                   	leaveq 
  8016e4:	c3                   	retq   

00000000008016e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016e5:	55                   	push   %rbp
  8016e6:	48 89 e5             	mov    %rsp,%rbp
  8016e9:	48 83 ec 28          	sub    $0x28,%rsp
  8016ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801701:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801705:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801709:	eb 38                	jmp    801743 <memcmp+0x5e>
		if (*s1 != *s2)
  80170b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170f:	0f b6 10             	movzbl (%rax),%edx
  801712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	38 c2                	cmp    %al,%dl
  80171b:	74 1c                	je     801739 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80171d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	0f b6 d0             	movzbl %al,%edx
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	0f b6 c0             	movzbl %al,%eax
  801731:	89 d1                	mov    %edx,%ecx
  801733:	29 c1                	sub    %eax,%ecx
  801735:	89 c8                	mov    %ecx,%eax
  801737:	eb 20                	jmp    801759 <memcmp+0x74>
		s1++, s2++;
  801739:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80173e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801743:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801748:	0f 95 c0             	setne  %al
  80174b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801750:	84 c0                	test   %al,%al
  801752:	75 b7                	jne    80170b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801759:	c9                   	leaveq 
  80175a:	c3                   	retq   

000000000080175b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80175b:	55                   	push   %rbp
  80175c:	48 89 e5             	mov    %rsp,%rbp
  80175f:	48 83 ec 28          	sub    $0x28,%rsp
  801763:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801767:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80176a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801776:	48 01 d0             	add    %rdx,%rax
  801779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80177d:	eb 13                	jmp    801792 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80177f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801783:	0f b6 10             	movzbl (%rax),%edx
  801786:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801789:	38 c2                	cmp    %al,%dl
  80178b:	74 11                	je     80179e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801796:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80179a:	72 e3                	jb     80177f <memfind+0x24>
  80179c:	eb 01                	jmp    80179f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80179e:	90                   	nop
	return (void *) s;
  80179f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017a3:	c9                   	leaveq 
  8017a4:	c3                   	retq   

00000000008017a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017a5:	55                   	push   %rbp
  8017a6:	48 89 e5             	mov    %rsp,%rbp
  8017a9:	48 83 ec 38          	sub    $0x38,%rsp
  8017ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017b5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017bf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017c6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017c7:	eb 05                	jmp    8017ce <strtol+0x29>
		s++;
  8017c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	3c 20                	cmp    $0x20,%al
  8017d7:	74 f0                	je     8017c9 <strtol+0x24>
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	3c 09                	cmp    $0x9,%al
  8017e2:	74 e5                	je     8017c9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	0f b6 00             	movzbl (%rax),%eax
  8017eb:	3c 2b                	cmp    $0x2b,%al
  8017ed:	75 07                	jne    8017f6 <strtol+0x51>
		s++;
  8017ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f4:	eb 17                	jmp    80180d <strtol+0x68>
	else if (*s == '-')
  8017f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fa:	0f b6 00             	movzbl (%rax),%eax
  8017fd:	3c 2d                	cmp    $0x2d,%al
  8017ff:	75 0c                	jne    80180d <strtol+0x68>
		s++, neg = 1;
  801801:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801806:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80180d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801811:	74 06                	je     801819 <strtol+0x74>
  801813:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801817:	75 28                	jne    801841 <strtol+0x9c>
  801819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181d:	0f b6 00             	movzbl (%rax),%eax
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 1d                	jne    801841 <strtol+0x9c>
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	48 83 c0 01          	add    $0x1,%rax
  80182c:	0f b6 00             	movzbl (%rax),%eax
  80182f:	3c 78                	cmp    $0x78,%al
  801831:	75 0e                	jne    801841 <strtol+0x9c>
		s += 2, base = 16;
  801833:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801838:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80183f:	eb 2c                	jmp    80186d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801841:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801845:	75 19                	jne    801860 <strtol+0xbb>
  801847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184b:	0f b6 00             	movzbl (%rax),%eax
  80184e:	3c 30                	cmp    $0x30,%al
  801850:	75 0e                	jne    801860 <strtol+0xbb>
		s++, base = 8;
  801852:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801857:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80185e:	eb 0d                	jmp    80186d <strtol+0xc8>
	else if (base == 0)
  801860:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801864:	75 07                	jne    80186d <strtol+0xc8>
		base = 10;
  801866:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	3c 2f                	cmp    $0x2f,%al
  801876:	7e 1d                	jle    801895 <strtol+0xf0>
  801878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187c:	0f b6 00             	movzbl (%rax),%eax
  80187f:	3c 39                	cmp    $0x39,%al
  801881:	7f 12                	jg     801895 <strtol+0xf0>
			dig = *s - '0';
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	0f be c0             	movsbl %al,%eax
  80188d:	83 e8 30             	sub    $0x30,%eax
  801890:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801893:	eb 4e                	jmp    8018e3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801895:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801899:	0f b6 00             	movzbl (%rax),%eax
  80189c:	3c 60                	cmp    $0x60,%al
  80189e:	7e 1d                	jle    8018bd <strtol+0x118>
  8018a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a4:	0f b6 00             	movzbl (%rax),%eax
  8018a7:	3c 7a                	cmp    $0x7a,%al
  8018a9:	7f 12                	jg     8018bd <strtol+0x118>
			dig = *s - 'a' + 10;
  8018ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	0f be c0             	movsbl %al,%eax
  8018b5:	83 e8 57             	sub    $0x57,%eax
  8018b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018bb:	eb 26                	jmp    8018e3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	0f b6 00             	movzbl (%rax),%eax
  8018c4:	3c 40                	cmp    $0x40,%al
  8018c6:	7e 47                	jle    80190f <strtol+0x16a>
  8018c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cc:	0f b6 00             	movzbl (%rax),%eax
  8018cf:	3c 5a                	cmp    $0x5a,%al
  8018d1:	7f 3c                	jg     80190f <strtol+0x16a>
			dig = *s - 'A' + 10;
  8018d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d7:	0f b6 00             	movzbl (%rax),%eax
  8018da:	0f be c0             	movsbl %al,%eax
  8018dd:	83 e8 37             	sub    $0x37,%eax
  8018e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018e6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018e9:	7d 23                	jge    80190e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8018eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018f3:	48 98                	cltq   
  8018f5:	48 89 c2             	mov    %rax,%rdx
  8018f8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8018fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801900:	48 98                	cltq   
  801902:	48 01 d0             	add    %rdx,%rax
  801905:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801909:	e9 5f ff ff ff       	jmpq   80186d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80190e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80190f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801914:	74 0b                	je     801921 <strtol+0x17c>
		*endptr = (char *) s;
  801916:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80191e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801921:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801925:	74 09                	je     801930 <strtol+0x18b>
  801927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192b:	48 f7 d8             	neg    %rax
  80192e:	eb 04                	jmp    801934 <strtol+0x18f>
  801930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801934:	c9                   	leaveq 
  801935:	c3                   	retq   

0000000000801936 <strstr>:

char * strstr(const char *in, const char *str)
{
  801936:	55                   	push   %rbp
  801937:	48 89 e5             	mov    %rsp,%rbp
  80193a:	48 83 ec 30          	sub    $0x30,%rsp
  80193e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801942:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801950:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801955:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801959:	75 06                	jne    801961 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	eb 68                	jmp    8019c9 <strstr+0x93>

	len = strlen(str);
  801961:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801965:	48 89 c7             	mov    %rax,%rdi
  801968:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
  801974:	48 98                	cltq   
  801976:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80197a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197e:	0f b6 00             	movzbl (%rax),%eax
  801981:	88 45 ef             	mov    %al,-0x11(%rbp)
  801984:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801989:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80198d:	75 07                	jne    801996 <strstr+0x60>
				return (char *) 0;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	eb 33                	jmp    8019c9 <strstr+0x93>
		} while (sc != c);
  801996:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80199a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80199d:	75 db                	jne    80197a <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80199f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ab:	48 89 ce             	mov    %rcx,%rsi
  8019ae:	48 89 c7             	mov    %rax,%rdi
  8019b1:	48 b8 28 14 80 00 00 	movabs $0x801428,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	callq  *%rax
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	75 b9                	jne    80197a <strstr+0x44>

	return (char *) (in - 1);
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	48 83 e8 01          	sub    $0x1,%rax
}
  8019c9:	c9                   	leaveq 
  8019ca:	c3                   	retq   
	...

00000000008019cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	53                   	push   %rbx
  8019d1:	48 83 ec 58          	sub    $0x58,%rsp
  8019d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019db:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019df:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019e3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019e7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019ee:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8019f1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019f5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019f9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019fd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a01:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a05:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801a08:	4c 89 c3             	mov    %r8,%rbx
  801a0b:	cd 30                	int    $0x30
  801a0d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801a11:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a19:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a1d:	74 3e                	je     801a5d <syscall+0x91>
  801a1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a24:	7e 37                	jle    801a5d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a2d:	49 89 d0             	mov    %rdx,%r8
  801a30:	89 c1                	mov    %eax,%ecx
  801a32:	48 ba e8 4c 80 00 00 	movabs $0x804ce8,%rdx
  801a39:	00 00 00 
  801a3c:	be 23 00 00 00       	mov    $0x23,%esi
  801a41:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  801a48:	00 00 00 
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	49 b9 6c 04 80 00 00 	movabs $0x80046c,%r9
  801a57:	00 00 00 
  801a5a:	41 ff d1             	callq  *%r9

	return ret;
  801a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a61:	48 83 c4 58          	add    $0x58,%rsp
  801a65:	5b                   	pop    %rbx
  801a66:	5d                   	pop    %rbp
  801a67:	c3                   	retq   

0000000000801a68 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	48 83 ec 20          	sub    $0x20,%rsp
  801a70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a87:	00 
  801a88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a94:	48 89 d1             	mov    %rdx,%rcx
  801a97:	48 89 c2             	mov    %rax,%rdx
  801a9a:	be 00 00 00 00       	mov    $0x0,%esi
  801a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa4:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801aab:	00 00 00 
  801aae:	ff d0                	callq  *%rax
}
  801ab0:	c9                   	leaveq 
  801ab1:	c3                   	retq   

0000000000801ab2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ab2:	55                   	push   %rbp
  801ab3:	48 89 e5             	mov    %rsp,%rbp
  801ab6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801aba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac1:	00 
  801ac2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad8:	be 00 00 00 00       	mov    $0x0,%esi
  801add:	bf 01 00 00 00       	mov    $0x1,%edi
  801ae2:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 20          	sub    $0x20,%rsp
  801af8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afe:	48 98                	cltq   
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b19:	48 89 c2             	mov    %rax,%rdx
  801b1c:	be 01 00 00 00       	mov    $0x1,%esi
  801b21:	bf 03 00 00 00       	mov    $0x3,%edi
  801b26:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b43:	00 
  801b44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b50:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b55:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5a:	be 00 00 00 00       	mov    $0x0,%esi
  801b5f:	bf 02 00 00 00       	mov    $0x2,%edi
  801b64:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_yield>:

void
sys_yield(void)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b81:	00 
  801b82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b93:	ba 00 00 00 00       	mov    $0x0,%edx
  801b98:	be 00 00 00 00       	mov    $0x0,%esi
  801b9d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ba2:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	callq  *%rax
}
  801bae:	c9                   	leaveq 
  801baf:	c3                   	retq   

0000000000801bb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bb0:	55                   	push   %rbp
  801bb1:	48 89 e5             	mov    %rsp,%rbp
  801bb4:	48 83 ec 20          	sub    $0x20,%rsp
  801bb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bbf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc5:	48 63 c8             	movslq %eax,%rcx
  801bc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcf:	48 98                	cltq   
  801bd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd8:	00 
  801bd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdf:	49 89 c8             	mov    %rcx,%r8
  801be2:	48 89 d1             	mov    %rdx,%rcx
  801be5:	48 89 c2             	mov    %rax,%rdx
  801be8:	be 01 00 00 00       	mov    $0x1,%esi
  801bed:	bf 04 00 00 00       	mov    $0x4,%edi
  801bf2:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 30          	sub    $0x30,%rsp
  801c08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c12:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c16:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c1d:	48 63 c8             	movslq %eax,%rcx
  801c20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c27:	48 63 f0             	movslq %eax,%rsi
  801c2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c31:	48 98                	cltq   
  801c33:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c37:	49 89 f9             	mov    %rdi,%r9
  801c3a:	49 89 f0             	mov    %rsi,%r8
  801c3d:	48 89 d1             	mov    %rdx,%rcx
  801c40:	48 89 c2             	mov    %rax,%rdx
  801c43:	be 01 00 00 00       	mov    $0x1,%esi
  801c48:	bf 05 00 00 00       	mov    $0x5,%edi
  801c4d:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 20          	sub    $0x20,%rsp
  801c63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c71:	48 98                	cltq   
  801c73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7a:	00 
  801c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c87:	48 89 d1             	mov    %rdx,%rcx
  801c8a:	48 89 c2             	mov    %rax,%rdx
  801c8d:	be 01 00 00 00       	mov    $0x1,%esi
  801c92:	bf 06 00 00 00       	mov    $0x6,%edi
  801c97:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 20          	sub    $0x20,%rsp
  801cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801cb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cb6:	48 63 d0             	movslq %eax,%rdx
  801cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbc:	48 98                	cltq   
  801cbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc5:	00 
  801cc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ccc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd2:	48 89 d1             	mov    %rdx,%rcx
  801cd5:	48 89 c2             	mov    %rax,%rdx
  801cd8:	be 01 00 00 00       	mov    $0x1,%esi
  801cdd:	bf 08 00 00 00       	mov    $0x8,%edi
  801ce2:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801ce9:	00 00 00 
  801cec:	ff d0                	callq  *%rax
}
  801cee:	c9                   	leaveq 
  801cef:	c3                   	retq   

0000000000801cf0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cf0:	55                   	push   %rbp
  801cf1:	48 89 e5             	mov    %rsp,%rbp
  801cf4:	48 83 ec 20          	sub    $0x20,%rsp
  801cf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d06:	48 98                	cltq   
  801d08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0f:	00 
  801d10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1c:	48 89 d1             	mov    %rdx,%rcx
  801d1f:	48 89 c2             	mov    %rax,%rdx
  801d22:	be 01 00 00 00       	mov    $0x1,%esi
  801d27:	bf 09 00 00 00       	mov    $0x9,%edi
  801d2c:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801d33:	00 00 00 
  801d36:	ff d0                	callq  *%rax
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 20          	sub    $0x20,%rsp
  801d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d50:	48 98                	cltq   
  801d52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d59:	00 
  801d5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d66:	48 89 d1             	mov    %rdx,%rcx
  801d69:	48 89 c2             	mov    %rax,%rdx
  801d6c:	be 01 00 00 00       	mov    $0x1,%esi
  801d71:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d76:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
}
  801d82:	c9                   	leaveq 
  801d83:	c3                   	retq   

0000000000801d84 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d84:	55                   	push   %rbp
  801d85:	48 89 e5             	mov    %rsp,%rbp
  801d88:	48 83 ec 30          	sub    $0x30,%rsp
  801d8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d97:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9d:	48 63 f0             	movslq %eax,%rsi
  801da0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	48 98                	cltq   
  801da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db4:	00 
  801db5:	49 89 f1             	mov    %rsi,%r9
  801db8:	49 89 c8             	mov    %rcx,%r8
  801dbb:	48 89 d1             	mov    %rdx,%rcx
  801dbe:	48 89 c2             	mov    %rax,%rdx
  801dc1:	be 00 00 00 00       	mov    $0x0,%esi
  801dc6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dcb:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
}
  801dd7:	c9                   	leaveq 
  801dd8:	c3                   	retq   

0000000000801dd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801dd9:	55                   	push   %rbp
  801dda:	48 89 e5             	mov    %rsp,%rbp
  801ddd:	48 83 ec 20          	sub    $0x20,%rsp
  801de1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801de5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df0:	00 
  801df1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e02:	48 89 c2             	mov    %rax,%rdx
  801e05:	be 01 00 00 00       	mov    $0x1,%esi
  801e0a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e0f:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
}
  801e1b:	c9                   	leaveq 
  801e1c:	c3                   	retq   

0000000000801e1d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e1d:	55                   	push   %rbp
  801e1e:	48 89 e5             	mov    %rsp,%rbp
  801e21:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e2c:	00 
  801e2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e43:	be 00 00 00 00       	mov    $0x0,%esi
  801e48:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e4d:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 30          	sub    $0x30,%rsp
  801e63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e6a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e6d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e71:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e75:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e78:	48 63 c8             	movslq %eax,%rcx
  801e7b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e82:	48 63 f0             	movslq %eax,%rsi
  801e85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8c:	48 98                	cltq   
  801e8e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e92:	49 89 f9             	mov    %rdi,%r9
  801e95:	49 89 f0             	mov    %rsi,%r8
  801e98:	48 89 d1             	mov    %rdx,%rcx
  801e9b:	48 89 c2             	mov    %rax,%rdx
  801e9e:	be 00 00 00 00       	mov    $0x0,%esi
  801ea3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ea8:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801eaf:	00 00 00 
  801eb2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801eb4:	c9                   	leaveq 
  801eb5:	c3                   	retq   

0000000000801eb6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801eb6:	55                   	push   %rbp
  801eb7:	48 89 e5             	mov    %rsp,%rbp
  801eba:	48 83 ec 20          	sub    $0x20,%rsp
  801ebe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ec2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ec6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ece:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed5:	00 
  801ed6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee2:	48 89 d1             	mov    %rdx,%rcx
  801ee5:	48 89 c2             	mov    %rax,%rdx
  801ee8:	be 00 00 00 00       	mov    $0x0,%esi
  801eed:	bf 10 00 00 00       	mov    $0x10,%edi
  801ef2:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
}
  801efe:	c9                   	leaveq 
  801eff:	c3                   	retq   

0000000000801f00 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f00:	55                   	push   %rbp
  801f01:	48 89 e5             	mov    %rsp,%rbp
  801f04:	48 83 ec 40          	sub    $0x40,%rsp
  801f08:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f0c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f10:	48 8b 00             	mov    (%rax),%rax
  801f13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f1f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f26:	48 89 c2             	mov    %rax,%rdx
  801f29:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f2d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f34:	01 00 00 
  801f37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801f3f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f42:	83 e0 02             	and    $0x2,%eax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	0f 84 4f 01 00 00    	je     80209c <pgfault+0x19c>
  801f4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f51:	48 89 c2             	mov    %rax,%rdx
  801f54:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5f:	01 00 00 
  801f62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f66:	25 00 08 00 00       	and    $0x800,%eax
  801f6b:	48 85 c0             	test   %rax,%rax
  801f6e:	0f 84 28 01 00 00    	je     80209c <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801f74:	ba 07 00 00 00       	mov    $0x7,%edx
  801f79:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f83:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	0f 85 db 00 00 00    	jne    802072 <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801f9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fa9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801fad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fb6:	48 89 c6             	mov    %rax,%rsi
  801fb9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fbe:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801fca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fce:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fd4:	48 89 c1             	mov    %rax,%rcx
  801fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fe1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe6:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801ff5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801ff9:	79 2a                	jns    802025 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801ffb:	48 ba 18 4d 80 00 00 	movabs $0x804d18,%rdx
  802002:	00 00 00 
  802005:	be 28 00 00 00       	mov    $0x28,%esi
  80200a:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802011:	00 00 00 
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
  802019:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  802020:	00 00 00 
  802023:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  802025:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80202a:	bf 00 00 00 00       	mov    $0x0,%edi
  80202f:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
  80203b:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  80203e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802042:	0f 89 84 00 00 00    	jns    8020cc <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  802048:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  80204f:	00 00 00 
  802052:	be 2c 00 00 00       	mov    $0x2c,%esi
  802057:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  80205e:	00 00 00 
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  80206d:	00 00 00 
  802070:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  802072:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  802079:	00 00 00 
  80207c:	be 31 00 00 00       	mov    $0x31,%esi
  802081:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802088:	00 00 00 
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  802097:	00 00 00 
  80209a:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  80209c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80209f:	89 c1                	mov    %eax,%ecx
  8020a1:	48 ba aa 4d 80 00 00 	movabs $0x804daa,%rdx
  8020a8:	00 00 00 
  8020ab:	be 35 00 00 00       	mov    $0x35,%esi
  8020b0:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8020b7:	00 00 00 
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8020c6:	00 00 00 
  8020c9:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  8020cc:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  8020cd:	c9                   	leaveq 
  8020ce:	c3                   	retq   

00000000008020cf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020cf:	55                   	push   %rbp
  8020d0:	48 89 e5             	mov    %rsp,%rbp
  8020d3:	48 83 ec 30          	sub    $0x30,%rsp
  8020d7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020da:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  8020dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e4:	01 00 00 
  8020e7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  8020f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8020f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  8020fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802101:	25 07 0e 00 00       	and    $0xe07,%eax
  802106:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  802109:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80210c:	25 00 04 00 00       	and    $0x400,%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	74 62                	je     802177 <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  802115:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802118:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80211c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80211f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802123:	41 89 f0             	mov    %esi,%r8d
  802126:	48 89 c6             	mov    %rax,%rsi
  802129:	bf 00 00 00 00       	mov    $0x0,%edi
  80212e:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802135:	00 00 00 
  802138:	ff d0                	callq  *%rax
  80213a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80213d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802141:	0f 89 78 01 00 00    	jns    8022bf <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802147:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80214a:	89 c1                	mov    %eax,%ecx
  80214c:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  802153:	00 00 00 
  802156:	be 4f 00 00 00       	mov    $0x4f,%esi
  80215b:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802162:	00 00 00 
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
  80216a:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  802171:	00 00 00 
  802174:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  802177:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217a:	25 00 08 00 00       	and    $0x800,%eax
  80217f:	85 c0                	test   %eax,%eax
  802181:	75 0e                	jne    802191 <duppage+0xc2>
  802183:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802186:	83 e0 02             	and    $0x2,%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	0f 84 d0 00 00 00    	je     802261 <duppage+0x192>
		perm &= ~PTE_W;
  802191:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  802195:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  80219c:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80219f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021aa:	41 89 f0             	mov    %esi,%r8d
  8021ad:	48 89 c6             	mov    %rax,%rsi
  8021b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b5:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8021c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021c8:	79 30                	jns    8021fa <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  8021ca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021cd:	89 c1                	mov    %eax,%ecx
  8021cf:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  8021d6:	00 00 00 
  8021d9:	be 57 00 00 00       	mov    $0x57,%esi
  8021de:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8021e5:	00 00 00 
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8021f4:	00 00 00 
  8021f7:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  8021fa:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  8021fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802205:	41 89 c8             	mov    %ecx,%r8d
  802208:	48 89 d1             	mov    %rdx,%rcx
  80220b:	ba 00 00 00 00       	mov    $0x0,%edx
  802210:	48 89 c6             	mov    %rax,%rsi
  802213:	bf 00 00 00 00       	mov    $0x0,%edi
  802218:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  80221f:	00 00 00 
  802222:	ff d0                	callq  *%rax
  802224:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802227:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80222b:	0f 89 8e 00 00 00    	jns    8022bf <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802231:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802234:	89 c1                	mov    %eax,%ecx
  802236:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  80223d:	00 00 00 
  802240:	be 5b 00 00 00       	mov    $0x5b,%esi
  802245:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  80224c:	00 00 00 
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  80225b:	00 00 00 
  80225e:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  802261:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802264:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802268:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	41 89 f0             	mov    %esi,%r8d
  802272:	48 89 c6             	mov    %rax,%rsi
  802275:	bf 00 00 00 00       	mov    $0x0,%edi
  80227a:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
  802286:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802289:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80228d:	79 30                	jns    8022bf <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80228f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802292:	89 c1                	mov    %eax,%ecx
  802294:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  80229b:	00 00 00 
  80229e:	be 61 00 00 00       	mov    $0x61,%esi
  8022a3:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8022aa:	00 00 00 
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8022b9:	00 00 00 
  8022bc:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c4:	c9                   	leaveq 
  8022c5:	c3                   	retq   

00000000008022c6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022c6:	55                   	push   %rbp
  8022c7:	48 89 e5             	mov    %rsp,%rbp
  8022ca:	53                   	push   %rbx
  8022cb:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  8022cf:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  8022d6:	48 bf 00 1f 80 00 00 	movabs $0x801f00,%rdi
  8022dd:	00 00 00 
  8022e0:	48 b8 c4 45 80 00 00 	movabs $0x8045c4,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022ec:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  8022f3:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8022f6:	cd 30                	int    $0x30
  8022f8:	89 c3                	mov    %eax,%ebx
  8022fa:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022fd:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802300:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  802303:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802307:	79 30                	jns    802339 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  802309:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80230c:	89 c1                	mov    %eax,%ecx
  80230e:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  802315:	00 00 00 
  802318:	be 80 00 00 00       	mov    $0x80,%esi
  80231d:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802324:	00 00 00 
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  802333:	00 00 00 
  802336:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  802339:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80233d:	75 52                	jne    802391 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  80233f:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
  80234b:	48 98                	cltq   
  80234d:	48 89 c2             	mov    %rax,%rdx
  802350:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802356:	48 89 d0             	mov    %rdx,%rax
  802359:	48 c1 e0 02          	shl    $0x2,%rax
  80235d:	48 01 d0             	add    %rdx,%rax
  802360:	48 01 c0             	add    %rax,%rax
  802363:	48 01 d0             	add    %rdx,%rax
  802366:	48 c1 e0 05          	shl    $0x5,%rax
  80236a:	48 89 c2             	mov    %rax,%rdx
  80236d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802374:	00 00 00 
  802377:	48 01 c2             	add    %rax,%rdx
  80237a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802381:	00 00 00 
  802384:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	e9 9d 02 00 00       	jmpq   80262e <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  802391:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802394:	ba 07 00 00 00       	mov    $0x7,%edx
  802399:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80239e:	89 c7                	mov    %eax,%edi
  8023a0:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  8023a7:	00 00 00 
  8023aa:	ff d0                	callq  *%rax
  8023ac:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8023af:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8023b3:	79 30                	jns    8023e5 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  8023b5:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8023b8:	89 c1                	mov    %eax,%ecx
  8023ba:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8023c1:	00 00 00 
  8023c4:	be 88 00 00 00       	mov    $0x88,%esi
  8023c9:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8023d0:	00 00 00 
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8023df:	00 00 00 
  8023e2:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  8023e5:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8023ec:	00 
	uint64_t each_pte = 0;
  8023ed:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8023f4:	00 
	uint64_t each_pdpe = 0;
  8023f5:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8023fc:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8023fd:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802404:	00 
  802405:	e9 73 01 00 00       	jmpq   80257d <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  80240a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802411:	01 00 00 
  802414:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802418:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241c:	83 e0 01             	and    $0x1,%eax
  80241f:	84 c0                	test   %al,%al
  802421:	0f 84 41 01 00 00    	je     802568 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802427:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80242e:	00 
  80242f:	e9 24 01 00 00       	jmpq   802558 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  802434:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80243b:	01 00 00 
  80243e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802442:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802446:	83 e0 01             	and    $0x1,%eax
  802449:	84 c0                	test   %al,%al
  80244b:	0f 84 ed 00 00 00    	je     80253e <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802451:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802458:	00 
  802459:	e9 d0 00 00 00       	jmpq   80252e <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  80245e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802465:	01 00 00 
  802468:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80246c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	84 c0                	test   %al,%al
  802475:	0f 84 99 00 00 00    	je     802514 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80247b:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802482:	00 
  802483:	eb 7f                	jmp    802504 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802485:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80248c:	01 00 00 
  80248f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802493:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802497:	83 e0 01             	and    $0x1,%eax
  80249a:	84 c0                	test   %al,%al
  80249c:	74 5c                	je     8024fa <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  80249e:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  8024a5:	00 
  8024a6:	74 52                	je     8024fa <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  8024a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024ac:	89 c2                	mov    %eax,%edx
  8024ae:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8024b1:	89 d6                	mov    %edx,%esi
  8024b3:	89 c7                	mov    %eax,%edi
  8024b5:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	callq  *%rax
  8024c1:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8024c4:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8024c8:	79 30                	jns    8024fa <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  8024ca:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8024cd:	89 c1                	mov    %eax,%ecx
  8024cf:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8024d6:	00 00 00 
  8024d9:	be a0 00 00 00       	mov    $0xa0,%esi
  8024de:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8024e5:	00 00 00 
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ed:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8024f4:	00 00 00 
  8024f7:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8024fa:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8024ff:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  802504:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  80250b:	00 
  80250c:	0f 86 73 ff ff ff    	jbe    802485 <fork+0x1bf>
  802512:	eb 10                	jmp    802524 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  802514:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802518:	48 83 c0 01          	add    $0x1,%rax
  80251c:	48 c1 e0 09          	shl    $0x9,%rax
  802520:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802524:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802529:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80252e:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802535:	00 
  802536:	0f 86 22 ff ff ff    	jbe    80245e <fork+0x198>
  80253c:	eb 10                	jmp    80254e <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  80253e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802542:	48 83 c0 01          	add    $0x1,%rax
  802546:	48 c1 e0 09          	shl    $0x9,%rax
  80254a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80254e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802553:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  802558:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80255f:	00 
  802560:	0f 86 ce fe ff ff    	jbe    802434 <fork+0x16e>
  802566:	eb 10                	jmp    802578 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256c:	48 83 c0 01          	add    $0x1,%rax
  802570:	48 c1 e0 09          	shl    $0x9,%rax
  802574:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802578:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80257d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802582:	0f 84 82 fe ff ff    	je     80240a <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802588:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80258b:	48 be 5c 46 80 00 00 	movabs $0x80465c,%rsi
  802592:	00 00 00 
  802595:	89 c7                	mov    %eax,%edi
  802597:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8025a6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8025aa:	79 30                	jns    8025dc <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  8025ac:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  8025b8:	00 00 00 
  8025bb:	be bd 00 00 00       	mov    $0xbd,%esi
  8025c0:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  8025c7:	00 00 00 
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  8025d6:	00 00 00 
  8025d9:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8025dc:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8025df:	be 02 00 00 00       	mov    $0x2,%esi
  8025e4:	89 c7                	mov    %eax,%edi
  8025e6:	48 b8 a5 1c 80 00 00 	movabs $0x801ca5,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
  8025f2:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8025f5:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8025f9:	79 30                	jns    80262b <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  8025fb:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8025fe:	89 c1                	mov    %eax,%ecx
  802600:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  802607:	00 00 00 
  80260a:	be c1 00 00 00       	mov    $0xc1,%esi
  80260f:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  802616:	00 00 00 
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  802625:	00 00 00 
  802628:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  80262b:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  80262e:	48 83 c4 68          	add    $0x68,%rsp
  802632:	5b                   	pop    %rbx
  802633:	5d                   	pop    %rbp
  802634:	c3                   	retq   

0000000000802635 <sfork>:

// Challenge!
int
sfork(void)
{
  802635:	55                   	push   %rbp
  802636:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802639:	48 ba 04 4e 80 00 00 	movabs $0x804e04,%rdx
  802640:	00 00 00 
  802643:	be cc 00 00 00       	mov    $0xcc,%esi
  802648:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  80264f:	00 00 00 
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
  802657:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  80265e:	00 00 00 
  802661:	ff d1                	callq  *%rcx
	...

0000000000802664 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802664:	55                   	push   %rbp
  802665:	48 89 e5             	mov    %rsp,%rbp
  802668:	48 83 ec 30          	sub    $0x30,%rsp
  80266c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802670:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802674:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  802678:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80267f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802684:	74 18                	je     80269e <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  802686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268a:	48 89 c7             	mov    %rax,%rdi
  80268d:	48 b8 d9 1d 80 00 00 	movabs $0x801dd9,%rax
  802694:	00 00 00 
  802697:	ff d0                	callq  *%rax
  802699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269c:	eb 19                	jmp    8026b7 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80269e:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8026a5:	00 00 00 
  8026a8:	48 b8 d9 1d 80 00 00 	movabs $0x801dd9,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax
  8026b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8026b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bb:	79 39                	jns    8026f6 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8026bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026c2:	75 08                	jne    8026cc <ipc_recv+0x68>
  8026c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c8:	8b 00                	mov    (%rax),%eax
  8026ca:	eb 05                	jmp    8026d1 <ipc_recv+0x6d>
  8026cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026d5:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8026d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026dc:	75 08                	jne    8026e6 <ipc_recv+0x82>
  8026de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e2:	8b 00                	mov    (%rax),%eax
  8026e4:	eb 05                	jmp    8026eb <ipc_recv+0x87>
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ef:	89 02                	mov    %eax,(%rdx)
		return r;
  8026f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f4:	eb 53                	jmp    802749 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  8026f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026fb:	74 19                	je     802716 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  8026fd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802704:	00 00 00 
  802707:	48 8b 00             	mov    (%rax),%rax
  80270a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802714:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  802716:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80271b:	74 19                	je     802736 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  80271d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802724:	00 00 00 
  802727:	48 8b 00             	mov    (%rax),%rax
  80272a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802734:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  802736:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80273d:	00 00 00 
  802740:	48 8b 00             	mov    (%rax),%rax
  802743:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  802749:	c9                   	leaveq 
  80274a:	c3                   	retq   

000000000080274b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80274b:	55                   	push   %rbp
  80274c:	48 89 e5             	mov    %rsp,%rbp
  80274f:	48 83 ec 30          	sub    $0x30,%rsp
  802753:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802756:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802759:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80275d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  802760:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  802767:	eb 59                	jmp    8027c2 <ipc_send+0x77>
		if(pg) {
  802769:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80276e:	74 20                	je     802790 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  802770:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802773:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802776:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80277a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277d:	89 c7                	mov    %eax,%edi
  80277f:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
  80278b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278e:	eb 26                	jmp    8027b6 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  802790:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802793:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802796:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802799:	89 d1                	mov    %edx,%ecx
  80279b:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8027a2:	00 00 00 
  8027a5:	89 c7                	mov    %eax,%edi
  8027a7:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
  8027b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8027b6:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8027c2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8027c6:	74 a1                	je     802769 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8027c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cc:	74 2a                	je     8027f8 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8027ce:	48 ba 20 4e 80 00 00 	movabs $0x804e20,%rdx
  8027d5:	00 00 00 
  8027d8:	be 49 00 00 00       	mov    $0x49,%esi
  8027dd:	48 bf 4b 4e 80 00 00 	movabs $0x804e4b,%rdi
  8027e4:	00 00 00 
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ec:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8027f3:	00 00 00 
  8027f6:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  8027f8:	c9                   	leaveq 
  8027f9:	c3                   	retq   

00000000008027fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027fa:	55                   	push   %rbp
  8027fb:	48 89 e5             	mov    %rsp,%rbp
  8027fe:	48 83 ec 18          	sub    $0x18,%rsp
  802802:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80280c:	eb 6a                	jmp    802878 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80280e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802815:	00 00 00 
  802818:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281b:	48 63 d0             	movslq %eax,%rdx
  80281e:	48 89 d0             	mov    %rdx,%rax
  802821:	48 c1 e0 02          	shl    $0x2,%rax
  802825:	48 01 d0             	add    %rdx,%rax
  802828:	48 01 c0             	add    %rax,%rax
  80282b:	48 01 d0             	add    %rdx,%rax
  80282e:	48 c1 e0 05          	shl    $0x5,%rax
  802832:	48 01 c8             	add    %rcx,%rax
  802835:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80283b:	8b 00                	mov    (%rax),%eax
  80283d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802840:	75 32                	jne    802874 <ipc_find_env+0x7a>
			return envs[i].env_id;
  802842:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802849:	00 00 00 
  80284c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284f:	48 63 d0             	movslq %eax,%rdx
  802852:	48 89 d0             	mov    %rdx,%rax
  802855:	48 c1 e0 02          	shl    $0x2,%rax
  802859:	48 01 d0             	add    %rdx,%rax
  80285c:	48 01 c0             	add    %rax,%rax
  80285f:	48 01 d0             	add    %rdx,%rax
  802862:	48 c1 e0 05          	shl    $0x5,%rax
  802866:	48 01 c8             	add    %rcx,%rax
  802869:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80286f:	8b 40 08             	mov    0x8(%rax),%eax
  802872:	eb 12                	jmp    802886 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802874:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802878:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80287f:	7e 8d                	jle    80280e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802886:	c9                   	leaveq 
  802887:	c3                   	retq   

0000000000802888 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802888:	55                   	push   %rbp
  802889:	48 89 e5             	mov    %rsp,%rbp
  80288c:	48 83 ec 08          	sub    $0x8,%rsp
  802890:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802894:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802898:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80289f:	ff ff ff 
  8028a2:	48 01 d0             	add    %rdx,%rax
  8028a5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028a9:	c9                   	leaveq 
  8028aa:	c3                   	retq   

00000000008028ab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028ab:	55                   	push   %rbp
  8028ac:	48 89 e5             	mov    %rsp,%rbp
  8028af:	48 83 ec 08          	sub    $0x8,%rsp
  8028b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028bb:	48 89 c7             	mov    %rax,%rdi
  8028be:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
  8028ca:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028d0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028d4:	c9                   	leaveq 
  8028d5:	c3                   	retq   

00000000008028d6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	48 83 ec 18          	sub    $0x18,%rsp
  8028de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028e9:	eb 6b                	jmp    802956 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ee:	48 98                	cltq   
  8028f0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8028fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8028fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802902:	48 89 c2             	mov    %rax,%rdx
  802905:	48 c1 ea 15          	shr    $0x15,%rdx
  802909:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802910:	01 00 00 
  802913:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802917:	83 e0 01             	and    $0x1,%eax
  80291a:	48 85 c0             	test   %rax,%rax
  80291d:	74 21                	je     802940 <fd_alloc+0x6a>
  80291f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802923:	48 89 c2             	mov    %rax,%rdx
  802926:	48 c1 ea 0c          	shr    $0xc,%rdx
  80292a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802931:	01 00 00 
  802934:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802938:	83 e0 01             	and    $0x1,%eax
  80293b:	48 85 c0             	test   %rax,%rax
  80293e:	75 12                	jne    802952 <fd_alloc+0x7c>
			*fd_store = fd;
  802940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802944:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802948:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	eb 1a                	jmp    80296c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802952:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802956:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80295a:	7e 8f                	jle    8028eb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80295c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802960:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802967:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80296c:	c9                   	leaveq 
  80296d:	c3                   	retq   

000000000080296e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80296e:	55                   	push   %rbp
  80296f:	48 89 e5             	mov    %rsp,%rbp
  802972:	48 83 ec 20          	sub    $0x20,%rsp
  802976:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802979:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80297d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802981:	78 06                	js     802989 <fd_lookup+0x1b>
  802983:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802987:	7e 07                	jle    802990 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802989:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80298e:	eb 6c                	jmp    8029fc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802990:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802993:	48 98                	cltq   
  802995:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80299b:	48 c1 e0 0c          	shl    $0xc,%rax
  80299f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a7:	48 89 c2             	mov    %rax,%rdx
  8029aa:	48 c1 ea 15          	shr    $0x15,%rdx
  8029ae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029b5:	01 00 00 
  8029b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029bc:	83 e0 01             	and    $0x1,%eax
  8029bf:	48 85 c0             	test   %rax,%rax
  8029c2:	74 21                	je     8029e5 <fd_lookup+0x77>
  8029c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c8:	48 89 c2             	mov    %rax,%rdx
  8029cb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029d6:	01 00 00 
  8029d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029dd:	83 e0 01             	and    $0x1,%eax
  8029e0:	48 85 c0             	test   %rax,%rax
  8029e3:	75 07                	jne    8029ec <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ea:	eb 10                	jmp    8029fc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8029ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029f4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	48 83 ec 30          	sub    $0x30,%rsp
  802a06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a0a:	89 f0                	mov    %esi,%eax
  802a0c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a13:	48 89 c7             	mov    %rax,%rdi
  802a16:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802a1d:	00 00 00 
  802a20:	ff d0                	callq  *%rax
  802a22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a26:	48 89 d6             	mov    %rdx,%rsi
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax
  802a37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3e:	78 0a                	js     802a4a <fd_close+0x4c>
	    || fd != fd2)
  802a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a44:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a48:	74 12                	je     802a5c <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a4a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a4e:	74 05                	je     802a55 <fd_close+0x57>
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 05                	jmp    802a5a <fd_close+0x5c>
  802a55:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5a:	eb 69                	jmp    802ac5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a60:	8b 00                	mov    (%rax),%eax
  802a62:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a66:	48 89 d6             	mov    %rdx,%rsi
  802a69:	89 c7                	mov    %eax,%edi
  802a6b:	48 b8 c7 2a 80 00 00 	movabs $0x802ac7,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
  802a77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7e:	78 2a                	js     802aaa <fd_close+0xac>
		if (dev->dev_close)
  802a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a84:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a88:	48 85 c0             	test   %rax,%rax
  802a8b:	74 16                	je     802aa3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a91:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a99:	48 89 c7             	mov    %rax,%rdi
  802a9c:	ff d2                	callq  *%rdx
  802a9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa1:	eb 07                	jmp    802aaa <fd_close+0xac>
		else
			r = 0;
  802aa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aae:	48 89 c6             	mov    %rax,%rsi
  802ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab6:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
	return r;
  802ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac5:	c9                   	leaveq 
  802ac6:	c3                   	retq   

0000000000802ac7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ac7:	55                   	push   %rbp
  802ac8:	48 89 e5             	mov    %rsp,%rbp
  802acb:	48 83 ec 20          	sub    $0x20,%rsp
  802acf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ad2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802ad6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802add:	eb 41                	jmp    802b20 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802adf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ae6:	00 00 00 
  802ae9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aec:	48 63 d2             	movslq %edx,%rdx
  802aef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af3:	8b 00                	mov    (%rax),%eax
  802af5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802af8:	75 22                	jne    802b1c <dev_lookup+0x55>
			*dev = devtab[i];
  802afa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b01:	00 00 00 
  802b04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b07:	48 63 d2             	movslq %edx,%rdx
  802b0a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b12:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1a:	eb 60                	jmp    802b7c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b1c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b20:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b27:	00 00 00 
  802b2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b2d:	48 63 d2             	movslq %edx,%rdx
  802b30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b34:	48 85 c0             	test   %rax,%rax
  802b37:	75 a6                	jne    802adf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b39:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b40:	00 00 00 
  802b43:	48 8b 00             	mov    (%rax),%rax
  802b46:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b4c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b4f:	89 c6                	mov    %eax,%esi
  802b51:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  802b58:	00 00 00 
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	48 b9 a7 06 80 00 00 	movabs $0x8006a7,%rcx
  802b67:	00 00 00 
  802b6a:	ff d1                	callq  *%rcx
	*dev = 0;
  802b6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b70:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b7c:	c9                   	leaveq 
  802b7d:	c3                   	retq   

0000000000802b7e <close>:

int
close(int fdnum)
{
  802b7e:	55                   	push   %rbp
  802b7f:	48 89 e5             	mov    %rsp,%rbp
  802b82:	48 83 ec 20          	sub    $0x20,%rsp
  802b86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b89:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b90:	48 89 d6             	mov    %rdx,%rsi
  802b93:	89 c7                	mov    %eax,%edi
  802b95:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba8:	79 05                	jns    802baf <close+0x31>
		return r;
  802baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bad:	eb 18                	jmp    802bc7 <close+0x49>
	else
		return fd_close(fd, 1);
  802baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb3:	be 01 00 00 00       	mov    $0x1,%esi
  802bb8:	48 89 c7             	mov    %rax,%rdi
  802bbb:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
}
  802bc7:	c9                   	leaveq 
  802bc8:	c3                   	retq   

0000000000802bc9 <close_all>:

void
close_all(void)
{
  802bc9:	55                   	push   %rbp
  802bca:	48 89 e5             	mov    %rsp,%rbp
  802bcd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bd8:	eb 15                	jmp    802bef <close_all+0x26>
		close(i);
  802bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdd:	89 c7                	mov    %eax,%edi
  802bdf:	48 b8 7e 2b 80 00 00 	movabs $0x802b7e,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802beb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bef:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bf3:	7e e5                	jle    802bda <close_all+0x11>
		close(i);
}
  802bf5:	c9                   	leaveq 
  802bf6:	c3                   	retq   

0000000000802bf7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802bf7:	55                   	push   %rbp
  802bf8:	48 89 e5             	mov    %rsp,%rbp
  802bfb:	48 83 ec 40          	sub    $0x40,%rsp
  802bff:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c02:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c05:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c09:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c0c:	48 89 d6             	mov    %rdx,%rsi
  802c0f:	89 c7                	mov    %eax,%edi
  802c11:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c24:	79 08                	jns    802c2e <dup+0x37>
		return r;
  802c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c29:	e9 70 01 00 00       	jmpq   802d9e <dup+0x1a7>
	close(newfdnum);
  802c2e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c31:	89 c7                	mov    %eax,%edi
  802c33:	48 b8 7e 2b 80 00 00 	movabs $0x802b7e,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c3f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c42:	48 98                	cltq   
  802c44:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c4a:	48 c1 e0 0c          	shl    $0xc,%rax
  802c4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c56:	48 89 c7             	mov    %rax,%rdi
  802c59:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6d:	48 89 c7             	mov    %rax,%rdi
  802c70:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	callq  *%rax
  802c7c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c84:	48 89 c2             	mov    %rax,%rdx
  802c87:	48 c1 ea 15          	shr    $0x15,%rdx
  802c8b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c92:	01 00 00 
  802c95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c99:	83 e0 01             	and    $0x1,%eax
  802c9c:	84 c0                	test   %al,%al
  802c9e:	74 71                	je     802d11 <dup+0x11a>
  802ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca4:	48 89 c2             	mov    %rax,%rdx
  802ca7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cb2:	01 00 00 
  802cb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cb9:	83 e0 01             	and    $0x1,%eax
  802cbc:	84 c0                	test   %al,%al
  802cbe:	74 51                	je     802d11 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc4:	48 89 c2             	mov    %rax,%rdx
  802cc7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ccb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cd2:	01 00 00 
  802cd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd9:	89 c1                	mov    %eax,%ecx
  802cdb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802ce1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce9:	41 89 c8             	mov    %ecx,%r8d
  802cec:	48 89 d1             	mov    %rdx,%rcx
  802cef:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf4:	48 89 c6             	mov    %rax,%rsi
  802cf7:	bf 00 00 00 00       	mov    $0x0,%edi
  802cfc:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802d03:	00 00 00 
  802d06:	ff d0                	callq  *%rax
  802d08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0f:	78 56                	js     802d67 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d15:	48 89 c2             	mov    %rax,%rdx
  802d18:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d23:	01 00 00 
  802d26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d2a:	89 c1                	mov    %eax,%ecx
  802d2c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d3a:	41 89 c8             	mov    %ecx,%r8d
  802d3d:	48 89 d1             	mov    %rdx,%rcx
  802d40:	ba 00 00 00 00       	mov    $0x0,%edx
  802d45:	48 89 c6             	mov    %rax,%rsi
  802d48:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4d:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d60:	78 08                	js     802d6a <dup+0x173>
		goto err;

	return newfdnum;
  802d62:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d65:	eb 37                	jmp    802d9e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802d67:	90                   	nop
  802d68:	eb 01                	jmp    802d6b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802d6a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6f:	48 89 c6             	mov    %rax,%rsi
  802d72:	bf 00 00 00 00       	mov    $0x0,%edi
  802d77:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d87:	48 89 c6             	mov    %rax,%rsi
  802d8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8f:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
	return r;
  802d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d9e:	c9                   	leaveq 
  802d9f:	c3                   	retq   

0000000000802da0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802da0:	55                   	push   %rbp
  802da1:	48 89 e5             	mov    %rsp,%rbp
  802da4:	48 83 ec 40          	sub    $0x40,%rsp
  802da8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802daf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802db3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802db7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dba:	48 89 d6             	mov    %rdx,%rsi
  802dbd:	89 c7                	mov    %eax,%edi
  802dbf:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
  802dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd2:	78 24                	js     802df8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd8:	8b 00                	mov    (%rax),%eax
  802dda:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dde:	48 89 d6             	mov    %rdx,%rsi
  802de1:	89 c7                	mov    %eax,%edi
  802de3:	48 b8 c7 2a 80 00 00 	movabs $0x802ac7,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df6:	79 05                	jns    802dfd <read+0x5d>
		return r;
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	eb 7a                	jmp    802e77 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e01:	8b 40 08             	mov    0x8(%rax),%eax
  802e04:	83 e0 03             	and    $0x3,%eax
  802e07:	83 f8 01             	cmp    $0x1,%eax
  802e0a:	75 3a                	jne    802e46 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e0c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e13:	00 00 00 
  802e16:	48 8b 00             	mov    (%rax),%rax
  802e19:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e1f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e22:	89 c6                	mov    %eax,%esi
  802e24:	48 bf 77 4e 80 00 00 	movabs $0x804e77,%rdi
  802e2b:	00 00 00 
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e33:	48 b9 a7 06 80 00 00 	movabs $0x8006a7,%rcx
  802e3a:	00 00 00 
  802e3d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e44:	eb 31                	jmp    802e77 <read+0xd7>
	}
	if (!dev->dev_read)
  802e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e4e:	48 85 c0             	test   %rax,%rax
  802e51:	75 07                	jne    802e5a <read+0xba>
		return -E_NOT_SUPP;
  802e53:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e58:	eb 1d                	jmp    802e77 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e66:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e6a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e6e:	48 89 ce             	mov    %rcx,%rsi
  802e71:	48 89 c7             	mov    %rax,%rdi
  802e74:	41 ff d0             	callq  *%r8
}
  802e77:	c9                   	leaveq 
  802e78:	c3                   	retq   

0000000000802e79 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e79:	55                   	push   %rbp
  802e7a:	48 89 e5             	mov    %rsp,%rbp
  802e7d:	48 83 ec 30          	sub    $0x30,%rsp
  802e81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e93:	eb 46                	jmp    802edb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e98:	48 98                	cltq   
  802e9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e9e:	48 29 c2             	sub    %rax,%rdx
  802ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea4:	48 98                	cltq   
  802ea6:	48 89 c1             	mov    %rax,%rcx
  802ea9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802ead:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eb0:	48 89 ce             	mov    %rcx,%rsi
  802eb3:	89 c7                	mov    %eax,%edi
  802eb5:	48 b8 a0 2d 80 00 00 	movabs $0x802da0,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
  802ec1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ec4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ec8:	79 05                	jns    802ecf <readn+0x56>
			return m;
  802eca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ecd:	eb 1d                	jmp    802eec <readn+0x73>
		if (m == 0)
  802ecf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ed3:	74 13                	je     802ee8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ed5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ede:	48 98                	cltq   
  802ee0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ee4:	72 af                	jb     802e95 <readn+0x1c>
  802ee6:	eb 01                	jmp    802ee9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802ee8:	90                   	nop
	}
	return tot;
  802ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802eec:	c9                   	leaveq 
  802eed:	c3                   	retq   

0000000000802eee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802eee:	55                   	push   %rbp
  802eef:	48 89 e5             	mov    %rsp,%rbp
  802ef2:	48 83 ec 40          	sub    $0x40,%rsp
  802ef6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802efd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f08:	48 89 d6             	mov    %rdx,%rsi
  802f0b:	89 c7                	mov    %eax,%edi
  802f0d:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f20:	78 24                	js     802f46 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f26:	8b 00                	mov    (%rax),%eax
  802f28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f2c:	48 89 d6             	mov    %rdx,%rsi
  802f2f:	89 c7                	mov    %eax,%edi
  802f31:	48 b8 c7 2a 80 00 00 	movabs $0x802ac7,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f44:	79 05                	jns    802f4b <write+0x5d>
		return r;
  802f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f49:	eb 79                	jmp    802fc4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4f:	8b 40 08             	mov    0x8(%rax),%eax
  802f52:	83 e0 03             	and    $0x3,%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	75 3a                	jne    802f93 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f59:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f60:	00 00 00 
  802f63:	48 8b 00             	mov    (%rax),%rax
  802f66:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f6c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f6f:	89 c6                	mov    %eax,%esi
  802f71:	48 bf 93 4e 80 00 00 	movabs $0x804e93,%rdi
  802f78:	00 00 00 
  802f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f80:	48 b9 a7 06 80 00 00 	movabs $0x8006a7,%rcx
  802f87:	00 00 00 
  802f8a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f91:	eb 31                	jmp    802fc4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f97:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f9b:	48 85 c0             	test   %rax,%rax
  802f9e:	75 07                	jne    802fa7 <write+0xb9>
		return -E_NOT_SUPP;
  802fa0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fa5:	eb 1d                	jmp    802fc4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fab:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fbb:	48 89 ce             	mov    %rcx,%rsi
  802fbe:	48 89 c7             	mov    %rax,%rdi
  802fc1:	41 ff d0             	callq  *%r8
}
  802fc4:	c9                   	leaveq 
  802fc5:	c3                   	retq   

0000000000802fc6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fc6:	55                   	push   %rbp
  802fc7:	48 89 e5             	mov    %rsp,%rbp
  802fca:	48 83 ec 18          	sub    $0x18,%rsp
  802fce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fd4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fd8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fdb:	48 89 d6             	mov    %rdx,%rsi
  802fde:	89 c7                	mov    %eax,%edi
  802fe0:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
  802fec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff3:	79 05                	jns    802ffa <seek+0x34>
		return r;
  802ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff8:	eb 0f                	jmp    803009 <seek+0x43>
	fd->fd_offset = offset;
  802ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803001:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803009:	c9                   	leaveq 
  80300a:	c3                   	retq   

000000000080300b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80300b:	55                   	push   %rbp
  80300c:	48 89 e5             	mov    %rsp,%rbp
  80300f:	48 83 ec 30          	sub    $0x30,%rsp
  803013:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803016:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803019:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80301d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803020:	48 89 d6             	mov    %rdx,%rsi
  803023:	89 c7                	mov    %eax,%edi
  803025:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
  803031:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803034:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803038:	78 24                	js     80305e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80303a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303e:	8b 00                	mov    (%rax),%eax
  803040:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803044:	48 89 d6             	mov    %rdx,%rsi
  803047:	89 c7                	mov    %eax,%edi
  803049:	48 b8 c7 2a 80 00 00 	movabs $0x802ac7,%rax
  803050:	00 00 00 
  803053:	ff d0                	callq  *%rax
  803055:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803058:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305c:	79 05                	jns    803063 <ftruncate+0x58>
		return r;
  80305e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803061:	eb 72                	jmp    8030d5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803067:	8b 40 08             	mov    0x8(%rax),%eax
  80306a:	83 e0 03             	and    $0x3,%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	75 3a                	jne    8030ab <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803071:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803078:	00 00 00 
  80307b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80307e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803084:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803087:	89 c6                	mov    %eax,%esi
  803089:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  803090:	00 00 00 
  803093:	b8 00 00 00 00       	mov    $0x0,%eax
  803098:	48 b9 a7 06 80 00 00 	movabs $0x8006a7,%rcx
  80309f:	00 00 00 
  8030a2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030a9:	eb 2a                	jmp    8030d5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030b3:	48 85 c0             	test   %rax,%rax
  8030b6:	75 07                	jne    8030bf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030bd:	eb 16                	jmp    8030d5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8030c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030cb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8030ce:	89 d6                	mov    %edx,%esi
  8030d0:	48 89 c7             	mov    %rax,%rdi
  8030d3:	ff d1                	callq  *%rcx
}
  8030d5:	c9                   	leaveq 
  8030d6:	c3                   	retq   

00000000008030d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030d7:	55                   	push   %rbp
  8030d8:	48 89 e5             	mov    %rsp,%rbp
  8030db:	48 83 ec 30          	sub    $0x30,%rsp
  8030df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030ed:	48 89 d6             	mov    %rdx,%rsi
  8030f0:	89 c7                	mov    %eax,%edi
  8030f2:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
  8030fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803105:	78 24                	js     80312b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310b:	8b 00                	mov    (%rax),%eax
  80310d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803111:	48 89 d6             	mov    %rdx,%rsi
  803114:	89 c7                	mov    %eax,%edi
  803116:	48 b8 c7 2a 80 00 00 	movabs $0x802ac7,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803125:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803129:	79 05                	jns    803130 <fstat+0x59>
		return r;
  80312b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312e:	eb 5e                	jmp    80318e <fstat+0xb7>
	if (!dev->dev_stat)
  803130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803134:	48 8b 40 28          	mov    0x28(%rax),%rax
  803138:	48 85 c0             	test   %rax,%rax
  80313b:	75 07                	jne    803144 <fstat+0x6d>
		return -E_NOT_SUPP;
  80313d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803142:	eb 4a                	jmp    80318e <fstat+0xb7>
	stat->st_name[0] = 0;
  803144:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803148:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80314b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803156:	00 00 00 
	stat->st_isdir = 0;
  803159:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803164:	00 00 00 
	stat->st_dev = dev;
  803167:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80316b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80316f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80317e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803182:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803186:	48 89 d6             	mov    %rdx,%rsi
  803189:	48 89 c7             	mov    %rax,%rdi
  80318c:	ff d1                	callq  *%rcx
}
  80318e:	c9                   	leaveq 
  80318f:	c3                   	retq   

0000000000803190 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803190:	55                   	push   %rbp
  803191:	48 89 e5             	mov    %rsp,%rbp
  803194:	48 83 ec 20          	sub    $0x20,%rsp
  803198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80319c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a4:	be 00 00 00 00       	mov    $0x0,%esi
  8031a9:	48 89 c7             	mov    %rax,%rdi
  8031ac:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  8031b3:	00 00 00 
  8031b6:	ff d0                	callq  *%rax
  8031b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031bf:	79 05                	jns    8031c6 <stat+0x36>
		return fd;
  8031c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c4:	eb 2f                	jmp    8031f5 <stat+0x65>
	r = fstat(fd, stat);
  8031c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cd:	48 89 d6             	mov    %rdx,%rsi
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 d7 30 80 00 00 	movabs $0x8030d7,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e4:	89 c7                	mov    %eax,%edi
  8031e6:	48 b8 7e 2b 80 00 00 	movabs $0x802b7e,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
	return r;
  8031f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   
	...

00000000008031f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8031f8:	55                   	push   %rbp
  8031f9:	48 89 e5             	mov    %rsp,%rbp
  8031fc:	48 83 ec 10          	sub    $0x10,%rsp
  803200:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803203:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803207:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80320e:	00 00 00 
  803211:	8b 00                	mov    (%rax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	75 1d                	jne    803234 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803217:	bf 01 00 00 00       	mov    $0x1,%edi
  80321c:	48 b8 fa 27 80 00 00 	movabs $0x8027fa,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80322f:	00 00 00 
  803232:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803234:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80323b:	00 00 00 
  80323e:	8b 00                	mov    (%rax),%eax
  803240:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803243:	b9 07 00 00 00       	mov    $0x7,%ecx
  803248:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80324f:	00 00 00 
  803252:	89 c7                	mov    %eax,%edi
  803254:	48 b8 4b 27 80 00 00 	movabs $0x80274b,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803264:	ba 00 00 00 00       	mov    $0x0,%edx
  803269:	48 89 c6             	mov    %rax,%rsi
  80326c:	bf 00 00 00 00       	mov    $0x0,%edi
  803271:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  803278:	00 00 00 
  80327b:	ff d0                	callq  *%rax
}
  80327d:	c9                   	leaveq 
  80327e:	c3                   	retq   

000000000080327f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80327f:	55                   	push   %rbp
  803280:	48 89 e5             	mov    %rsp,%rbp
  803283:	48 83 ec 20          	sub    $0x20,%rsp
  803287:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80328b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80328e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803292:	48 89 c7             	mov    %rax,%rdi
  803295:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
  8032a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032a6:	7e 0a                	jle    8032b2 <open+0x33>
		return -E_BAD_PATH;
  8032a8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032ad:	e9 a5 00 00 00       	jmpq   803357 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8032b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032b6:	48 89 c7             	mov    %rax,%rdi
  8032b9:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
  8032c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8032c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cc:	79 08                	jns    8032d6 <open+0x57>
		return r;
  8032ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d1:	e9 81 00 00 00       	jmpq   803357 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8032d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032dd:	00 00 00 
  8032e0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032e3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8032e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ed:	48 89 c6             	mov    %rax,%rsi
  8032f0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8032f7:	00 00 00 
  8032fa:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  803301:	00 00 00 
  803304:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  803306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330a:	48 89 c6             	mov    %rax,%rsi
  80330d:	bf 01 00 00 00       	mov    $0x1,%edi
  803312:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
  80331e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803325:	79 1d                	jns    803344 <open+0xc5>
		fd_close(new_fd, 0);
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	be 00 00 00 00       	mov    $0x0,%esi
  803330:	48 89 c7             	mov    %rax,%rdi
  803333:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
		return r;	
  80333f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803342:	eb 13                	jmp    803357 <open+0xd8>
	}
	return fd2num(new_fd);
  803344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
}
  803357:	c9                   	leaveq 
  803358:	c3                   	retq   

0000000000803359 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 10          	sub    $0x10,%rsp
  803361:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803369:	8b 50 0c             	mov    0xc(%rax),%edx
  80336c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803373:	00 00 00 
  803376:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803378:	be 00 00 00 00       	mov    $0x0,%esi
  80337d:	bf 06 00 00 00       	mov    $0x6,%edi
  803382:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
}
  80338e:	c9                   	leaveq 
  80338f:	c3                   	retq   

0000000000803390 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803390:	55                   	push   %rbp
  803391:	48 89 e5             	mov    %rsp,%rbp
  803394:	48 83 ec 30          	sub    $0x30,%rsp
  803398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8033a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033b2:	00 00 00 
  8033b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033be:	00 00 00 
  8033c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8033c9:	be 00 00 00 00       	mov    $0x0,%esi
  8033ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8033d3:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8033e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e6:	7e 23                	jle    80340b <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8033e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033eb:	48 63 d0             	movslq %eax,%rdx
  8033ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8033f9:	00 00 00 
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	}
	return nbytes;
  80340b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80340e:	c9                   	leaveq 
  80340f:	c3                   	retq   

0000000000803410 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803410:	55                   	push   %rbp
  803411:	48 89 e5             	mov    %rsp,%rbp
  803414:	48 83 ec 20          	sub    $0x20,%rsp
  803418:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80341c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803424:	8b 50 0c             	mov    0xc(%rax),%edx
  803427:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80342e:	00 00 00 
  803431:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803433:	be 00 00 00 00       	mov    $0x0,%esi
  803438:	bf 05 00 00 00       	mov    $0x5,%edi
  80343d:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80344c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803450:	79 05                	jns    803457 <devfile_stat+0x47>
		return r;
  803452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803455:	eb 56                	jmp    8034ad <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803457:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803462:	00 00 00 
  803465:	48 89 c7             	mov    %rax,%rdi
  803468:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803474:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80347b:	00 00 00 
  80347e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803488:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80348e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803495:	00 00 00 
  803498:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80349e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034a2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ad:	c9                   	leaveq 
  8034ae:	c3                   	retq   
	...

00000000008034b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034b0:	55                   	push   %rbp
  8034b1:	48 89 e5             	mov    %rsp,%rbp
  8034b4:	48 83 ec 18          	sub    $0x18,%rsp
  8034b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8034bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c0:	48 89 c2             	mov    %rax,%rdx
  8034c3:	48 c1 ea 15          	shr    $0x15,%rdx
  8034c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034ce:	01 00 00 
  8034d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034d5:	83 e0 01             	and    $0x1,%eax
  8034d8:	48 85 c0             	test   %rax,%rax
  8034db:	75 07                	jne    8034e4 <pageref+0x34>
		return 0;
  8034dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e2:	eb 53                	jmp    803537 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e8:	48 89 c2             	mov    %rax,%rdx
  8034eb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8034ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034f6:	01 00 00 
  8034f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803505:	83 e0 01             	and    $0x1,%eax
  803508:	48 85 c0             	test   %rax,%rax
  80350b:	75 07                	jne    803514 <pageref+0x64>
		return 0;
  80350d:	b8 00 00 00 00       	mov    $0x0,%eax
  803512:	eb 23                	jmp    803537 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803518:	48 89 c2             	mov    %rax,%rdx
  80351b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80351f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803526:	00 00 00 
  803529:	48 c1 e2 04          	shl    $0x4,%rdx
  80352d:	48 01 d0             	add    %rdx,%rax
  803530:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803534:	0f b7 c0             	movzwl %ax,%eax
}
  803537:	c9                   	leaveq 
  803538:	c3                   	retq   
  803539:	00 00                	add    %al,(%rax)
	...

000000000080353c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80353c:	55                   	push   %rbp
  80353d:	48 89 e5             	mov    %rsp,%rbp
  803540:	48 83 ec 20          	sub    $0x20,%rsp
  803544:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803547:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80354b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354e:	48 89 d6             	mov    %rdx,%rsi
  803551:	89 c7                	mov    %eax,%edi
  803553:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
  80355f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803566:	79 05                	jns    80356d <fd2sockid+0x31>
		return r;
  803568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356b:	eb 24                	jmp    803591 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	8b 10                	mov    (%rax),%edx
  803573:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80357a:	00 00 00 
  80357d:	8b 00                	mov    (%rax),%eax
  80357f:	39 c2                	cmp    %eax,%edx
  803581:	74 07                	je     80358a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803583:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803588:	eb 07                	jmp    803591 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80358a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803591:	c9                   	leaveq 
  803592:	c3                   	retq   

0000000000803593 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803593:	55                   	push   %rbp
  803594:	48 89 e5             	mov    %rsp,%rbp
  803597:	48 83 ec 20          	sub    $0x20,%rsp
  80359b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80359e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035a2:	48 89 c7             	mov    %rax,%rdi
  8035a5:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
  8035b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b8:	78 26                	js     8035e0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8035ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035be:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c3:	48 89 c6             	mov    %rax,%rsi
  8035c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cb:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
  8035d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035de:	79 16                	jns    8035f6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e3:	89 c7                	mov    %eax,%edi
  8035e5:	48 b8 a0 3a 80 00 00 	movabs $0x803aa0,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
		return r;
  8035f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f4:	eb 3a                	jmp    803630 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fa:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803601:	00 00 00 
  803604:	8b 12                	mov    (%rdx),%edx
  803606:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803617:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80361a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80361d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803621:	48 89 c7             	mov    %rax,%rdi
  803624:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  80362b:	00 00 00 
  80362e:	ff d0                	callq  *%rax
}
  803630:	c9                   	leaveq 
  803631:	c3                   	retq   

0000000000803632 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803632:	55                   	push   %rbp
  803633:	48 89 e5             	mov    %rsp,%rbp
  803636:	48 83 ec 30          	sub    $0x30,%rsp
  80363a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80363d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803641:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803648:	89 c7                	mov    %eax,%edi
  80364a:	48 b8 3c 35 80 00 00 	movabs $0x80353c,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
  803656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365d:	79 05                	jns    803664 <accept+0x32>
		return r;
  80365f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803662:	eb 3b                	jmp    80369f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803664:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803668:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80366c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366f:	48 89 ce             	mov    %rcx,%rsi
  803672:	89 c7                	mov    %eax,%edi
  803674:	48 b8 7d 39 80 00 00 	movabs $0x80397d,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803687:	79 05                	jns    80368e <accept+0x5c>
		return r;
  803689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368c:	eb 11                	jmp    80369f <accept+0x6d>
	return alloc_sockfd(r);
  80368e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803691:	89 c7                	mov    %eax,%edi
  803693:	48 b8 93 35 80 00 00 	movabs $0x803593,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
}
  80369f:	c9                   	leaveq 
  8036a0:	c3                   	retq   

00000000008036a1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036a1:	55                   	push   %rbp
  8036a2:	48 89 e5             	mov    %rsp,%rbp
  8036a5:	48 83 ec 20          	sub    $0x20,%rsp
  8036a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036b0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 3c 35 80 00 00 	movabs $0x80353c,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
  8036c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036cb:	79 05                	jns    8036d2 <bind+0x31>
		return r;
  8036cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d0:	eb 1b                	jmp    8036ed <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036d5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036dc:	48 89 ce             	mov    %rcx,%rsi
  8036df:	89 c7                	mov    %eax,%edi
  8036e1:	48 b8 fc 39 80 00 00 	movabs $0x8039fc,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
}
  8036ed:	c9                   	leaveq 
  8036ee:	c3                   	retq   

00000000008036ef <shutdown>:

int
shutdown(int s, int how)
{
  8036ef:	55                   	push   %rbp
  8036f0:	48 89 e5             	mov    %rsp,%rbp
  8036f3:	48 83 ec 20          	sub    $0x20,%rsp
  8036f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036fa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803700:	89 c7                	mov    %eax,%edi
  803702:	48 b8 3c 35 80 00 00 	movabs $0x80353c,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
  80370e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803711:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803715:	79 05                	jns    80371c <shutdown+0x2d>
		return r;
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	eb 16                	jmp    803732 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80371c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80371f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803722:	89 d6                	mov    %edx,%esi
  803724:	89 c7                	mov    %eax,%edi
  803726:	48 b8 60 3a 80 00 00 	movabs $0x803a60,%rax
  80372d:	00 00 00 
  803730:	ff d0                	callq  *%rax
}
  803732:	c9                   	leaveq 
  803733:	c3                   	retq   

0000000000803734 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803734:	55                   	push   %rbp
  803735:	48 89 e5             	mov    %rsp,%rbp
  803738:	48 83 ec 10          	sub    $0x10,%rsp
  80373c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803744:	48 89 c7             	mov    %rax,%rdi
  803747:	48 b8 b0 34 80 00 00 	movabs $0x8034b0,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
  803753:	83 f8 01             	cmp    $0x1,%eax
  803756:	75 17                	jne    80376f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375c:	8b 40 0c             	mov    0xc(%rax),%eax
  80375f:	89 c7                	mov    %eax,%edi
  803761:	48 b8 a0 3a 80 00 00 	movabs $0x803aa0,%rax
  803768:	00 00 00 
  80376b:	ff d0                	callq  *%rax
  80376d:	eb 05                	jmp    803774 <devsock_close+0x40>
	else
		return 0;
  80376f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803774:	c9                   	leaveq 
  803775:	c3                   	retq   

0000000000803776 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 20          	sub    $0x20,%rsp
  80377e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803781:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803785:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803788:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378b:	89 c7                	mov    %eax,%edi
  80378d:	48 b8 3c 35 80 00 00 	movabs $0x80353c,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
  803799:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a0:	79 05                	jns    8037a7 <connect+0x31>
		return r;
  8037a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a5:	eb 1b                	jmp    8037c2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8037a7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b1:	48 89 ce             	mov    %rcx,%rsi
  8037b4:	89 c7                	mov    %eax,%edi
  8037b6:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
}
  8037c2:	c9                   	leaveq 
  8037c3:	c3                   	retq   

00000000008037c4 <listen>:

int
listen(int s, int backlog)
{
  8037c4:	55                   	push   %rbp
  8037c5:	48 89 e5             	mov    %rsp,%rbp
  8037c8:	48 83 ec 20          	sub    $0x20,%rsp
  8037cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037cf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037d5:	89 c7                	mov    %eax,%edi
  8037d7:	48 b8 3c 35 80 00 00 	movabs $0x80353c,%rax
  8037de:	00 00 00 
  8037e1:	ff d0                	callq  *%rax
  8037e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ea:	79 05                	jns    8037f1 <listen+0x2d>
		return r;
  8037ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ef:	eb 16                	jmp    803807 <listen+0x43>
	return nsipc_listen(r, backlog);
  8037f1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f7:	89 d6                	mov    %edx,%esi
  8037f9:	89 c7                	mov    %eax,%edi
  8037fb:	48 b8 31 3b 80 00 00 	movabs $0x803b31,%rax
  803802:	00 00 00 
  803805:	ff d0                	callq  *%rax
}
  803807:	c9                   	leaveq 
  803808:	c3                   	retq   

0000000000803809 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803809:	55                   	push   %rbp
  80380a:	48 89 e5             	mov    %rsp,%rbp
  80380d:	48 83 ec 20          	sub    $0x20,%rsp
  803811:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803815:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803819:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80381d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803821:	89 c2                	mov    %eax,%edx
  803823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803827:	8b 40 0c             	mov    0xc(%rax),%eax
  80382a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80382e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803833:	89 c7                	mov    %eax,%edi
  803835:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
}
  803841:	c9                   	leaveq 
  803842:	c3                   	retq   

0000000000803843 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803843:	55                   	push   %rbp
  803844:	48 89 e5             	mov    %rsp,%rbp
  803847:	48 83 ec 20          	sub    $0x20,%rsp
  80384b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80384f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803853:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80385b:	89 c2                	mov    %eax,%edx
  80385d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803861:	8b 40 0c             	mov    0xc(%rax),%eax
  803864:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803868:	b9 00 00 00 00       	mov    $0x0,%ecx
  80386d:	89 c7                	mov    %eax,%edi
  80386f:	48 b8 3d 3c 80 00 00 	movabs $0x803c3d,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
}
  80387b:	c9                   	leaveq 
  80387c:	c3                   	retq   

000000000080387d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80387d:	55                   	push   %rbp
  80387e:	48 89 e5             	mov    %rsp,%rbp
  803881:	48 83 ec 10          	sub    $0x10,%rsp
  803885:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803889:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80388d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803891:	48 be db 4e 80 00 00 	movabs $0x804edb,%rsi
  803898:	00 00 00 
  80389b:	48 89 c7             	mov    %rax,%rdi
  80389e:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
	return 0;
  8038aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038af:	c9                   	leaveq 
  8038b0:	c3                   	retq   

00000000008038b1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8038b1:	55                   	push   %rbp
  8038b2:	48 89 e5             	mov    %rsp,%rbp
  8038b5:	48 83 ec 20          	sub    $0x20,%rsp
  8038b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038bc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038bf:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038c2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038c5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038cb:	89 ce                	mov    %ecx,%esi
  8038cd:	89 c7                	mov    %eax,%edi
  8038cf:	48 b8 f5 3c 80 00 00 	movabs $0x803cf5,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e2:	79 05                	jns    8038e9 <socket+0x38>
		return r;
  8038e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e7:	eb 11                	jmp    8038fa <socket+0x49>
	return alloc_sockfd(r);
  8038e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ec:	89 c7                	mov    %eax,%edi
  8038ee:	48 b8 93 35 80 00 00 	movabs $0x803593,%rax
  8038f5:	00 00 00 
  8038f8:	ff d0                	callq  *%rax
}
  8038fa:	c9                   	leaveq 
  8038fb:	c3                   	retq   

00000000008038fc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038fc:	55                   	push   %rbp
  8038fd:	48 89 e5             	mov    %rsp,%rbp
  803900:	48 83 ec 10          	sub    $0x10,%rsp
  803904:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803907:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80390e:	00 00 00 
  803911:	8b 00                	mov    (%rax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	75 1d                	jne    803934 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803917:	bf 02 00 00 00       	mov    $0x2,%edi
  80391c:	48 b8 fa 27 80 00 00 	movabs $0x8027fa,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
  803928:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80392f:	00 00 00 
  803932:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803934:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80393b:	00 00 00 
  80393e:	8b 00                	mov    (%rax),%eax
  803940:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803943:	b9 07 00 00 00       	mov    $0x7,%ecx
  803948:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80394f:	00 00 00 
  803952:	89 c7                	mov    %eax,%edi
  803954:	48 b8 4b 27 80 00 00 	movabs $0x80274b,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803960:	ba 00 00 00 00       	mov    $0x0,%edx
  803965:	be 00 00 00 00       	mov    $0x0,%esi
  80396a:	bf 00 00 00 00       	mov    $0x0,%edi
  80396f:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
}
  80397b:	c9                   	leaveq 
  80397c:	c3                   	retq   

000000000080397d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 30          	sub    $0x30,%rsp
  803985:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803988:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80398c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803990:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803997:	00 00 00 
  80399a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80399d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80399f:	bf 01 00 00 00       	mov    $0x1,%edi
  8039a4:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b7:	78 3e                	js     8039f7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8039b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c0:	00 00 00 
  8039c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cb:	8b 40 10             	mov    0x10(%rax),%eax
  8039ce:	89 c2                	mov    %eax,%edx
  8039d0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d8:	48 89 ce             	mov    %rcx,%rsi
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ee:	8b 50 10             	mov    0x10(%rax),%edx
  8039f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039fa:	c9                   	leaveq 
  8039fb:	c3                   	retq   

00000000008039fc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039fc:	55                   	push   %rbp
  8039fd:	48 89 e5             	mov    %rsp,%rbp
  803a00:	48 83 ec 10          	sub    $0x10,%rsp
  803a04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a0b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a15:	00 00 00 
  803a18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a1d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a24:	48 89 c6             	mov    %rax,%rsi
  803a27:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a2e:	00 00 00 
  803a31:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  803a38:	00 00 00 
  803a3b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a3d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a44:	00 00 00 
  803a47:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a4a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a4d:	bf 02 00 00 00       	mov    $0x2,%edi
  803a52:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803a59:	00 00 00 
  803a5c:	ff d0                	callq  *%rax
}
  803a5e:	c9                   	leaveq 
  803a5f:	c3                   	retq   

0000000000803a60 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a60:	55                   	push   %rbp
  803a61:	48 89 e5             	mov    %rsp,%rbp
  803a64:	48 83 ec 10          	sub    $0x10,%rsp
  803a68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a6e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a75:	00 00 00 
  803a78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a7d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a84:	00 00 00 
  803a87:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a8a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a8d:	bf 03 00 00 00       	mov    $0x3,%edi
  803a92:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
}
  803a9e:	c9                   	leaveq 
  803a9f:	c3                   	retq   

0000000000803aa0 <nsipc_close>:

int
nsipc_close(int s)
{
  803aa0:	55                   	push   %rbp
  803aa1:	48 89 e5             	mov    %rsp,%rbp
  803aa4:	48 83 ec 10          	sub    $0x10,%rsp
  803aa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803aab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab2:	00 00 00 
  803ab5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ab8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803aba:	bf 04 00 00 00       	mov    $0x4,%edi
  803abf:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	48 83 ec 10          	sub    $0x10,%rsp
  803ad5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803adc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803adf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ae6:	00 00 00 
  803ae9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aec:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803aee:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af5:	48 89 c6             	mov    %rax,%rsi
  803af8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803aff:	00 00 00 
  803b02:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b15:	00 00 00 
  803b18:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b1b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b1e:	bf 05 00 00 00       	mov    $0x5,%edi
  803b23:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803b2a:	00 00 00 
  803b2d:	ff d0                	callq  *%rax
}
  803b2f:	c9                   	leaveq 
  803b30:	c3                   	retq   

0000000000803b31 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b31:	55                   	push   %rbp
  803b32:	48 89 e5             	mov    %rsp,%rbp
  803b35:	48 83 ec 10          	sub    $0x10,%rsp
  803b39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b3c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b3f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b46:	00 00 00 
  803b49:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b4c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b4e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b55:	00 00 00 
  803b58:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b5b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b5e:	bf 06 00 00 00       	mov    $0x6,%edi
  803b63:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
}
  803b6f:	c9                   	leaveq 
  803b70:	c3                   	retq   

0000000000803b71 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b71:	55                   	push   %rbp
  803b72:	48 89 e5             	mov    %rsp,%rbp
  803b75:	48 83 ec 30          	sub    $0x30,%rsp
  803b79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b80:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b83:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b86:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b8d:	00 00 00 
  803b90:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b93:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b95:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b9c:	00 00 00 
  803b9f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ba2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ba5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bac:	00 00 00 
  803baf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803bb2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803bb5:	bf 07 00 00 00       	mov    $0x7,%edi
  803bba:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
  803bc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bcd:	78 69                	js     803c38 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bcf:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bd6:	7f 08                	jg     803be0 <nsipc_recv+0x6f>
  803bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bdb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bde:	7e 35                	jle    803c15 <nsipc_recv+0xa4>
  803be0:	48 b9 e2 4e 80 00 00 	movabs $0x804ee2,%rcx
  803be7:	00 00 00 
  803bea:	48 ba f7 4e 80 00 00 	movabs $0x804ef7,%rdx
  803bf1:	00 00 00 
  803bf4:	be 61 00 00 00       	mov    $0x61,%esi
  803bf9:	48 bf 0c 4f 80 00 00 	movabs $0x804f0c,%rdi
  803c00:	00 00 00 
  803c03:	b8 00 00 00 00       	mov    $0x0,%eax
  803c08:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  803c0f:	00 00 00 
  803c12:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c18:	48 63 d0             	movslq %eax,%rdx
  803c1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c26:	00 00 00 
  803c29:	48 89 c7             	mov    %rax,%rdi
  803c2c:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
	}

	return r;
  803c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c3b:	c9                   	leaveq 
  803c3c:	c3                   	retq   

0000000000803c3d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c3d:	55                   	push   %rbp
  803c3e:	48 89 e5             	mov    %rsp,%rbp
  803c41:	48 83 ec 20          	sub    $0x20,%rsp
  803c45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c4c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c4f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c59:	00 00 00 
  803c5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c5f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c61:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c68:	7e 35                	jle    803c9f <nsipc_send+0x62>
  803c6a:	48 b9 18 4f 80 00 00 	movabs $0x804f18,%rcx
  803c71:	00 00 00 
  803c74:	48 ba f7 4e 80 00 00 	movabs $0x804ef7,%rdx
  803c7b:	00 00 00 
  803c7e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c83:	48 bf 0c 4f 80 00 00 	movabs $0x804f0c,%rdi
  803c8a:	00 00 00 
  803c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c92:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  803c99:	00 00 00 
  803c9c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca2:	48 63 d0             	movslq %eax,%rdx
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	48 89 c6             	mov    %rax,%rsi
  803cac:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803cb3:	00 00 00 
  803cb6:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803cc2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cc9:	00 00 00 
  803ccc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ccf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cd2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cd9:	00 00 00 
  803cdc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cdf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803ce2:	bf 08 00 00 00       	mov    $0x8,%edi
  803ce7:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803cee:	00 00 00 
  803cf1:	ff d0                	callq  *%rax
}
  803cf3:	c9                   	leaveq 
  803cf4:	c3                   	retq   

0000000000803cf5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803cf5:	55                   	push   %rbp
  803cf6:	48 89 e5             	mov    %rsp,%rbp
  803cf9:	48 83 ec 10          	sub    $0x10,%rsp
  803cfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d00:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d03:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803d06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d0d:	00 00 00 
  803d10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d13:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d15:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d1c:	00 00 00 
  803d1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d22:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d25:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d2c:	00 00 00 
  803d2f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d32:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d35:	bf 09 00 00 00       	mov    $0x9,%edi
  803d3a:	48 b8 fc 38 80 00 00 	movabs $0x8038fc,%rax
  803d41:	00 00 00 
  803d44:	ff d0                	callq  *%rax
}
  803d46:	c9                   	leaveq 
  803d47:	c3                   	retq   

0000000000803d48 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	53                   	push   %rbx
  803d4d:	48 83 ec 38          	sub    $0x38,%rsp
  803d51:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d55:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d59:	48 89 c7             	mov    %rax,%rdi
  803d5c:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  803d63:	00 00 00 
  803d66:	ff d0                	callq  *%rax
  803d68:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d6f:	0f 88 bf 01 00 00    	js     803f34 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d79:	ba 07 04 00 00       	mov    $0x407,%edx
  803d7e:	48 89 c6             	mov    %rax,%rsi
  803d81:	bf 00 00 00 00       	mov    $0x0,%edi
  803d86:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  803d8d:	00 00 00 
  803d90:	ff d0                	callq  *%rax
  803d92:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d95:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d99:	0f 88 95 01 00 00    	js     803f34 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d9f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803da3:	48 89 c7             	mov    %rax,%rdi
  803da6:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  803dad:	00 00 00 
  803db0:	ff d0                	callq  *%rax
  803db2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db9:	0f 88 5d 01 00 00    	js     803f1c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc3:	ba 07 04 00 00       	mov    $0x407,%edx
  803dc8:	48 89 c6             	mov    %rax,%rsi
  803dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd0:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  803dd7:	00 00 00 
  803dda:	ff d0                	callq  *%rax
  803ddc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ddf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803de3:	0f 88 33 01 00 00    	js     803f1c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ded:	48 89 c7             	mov    %rax,%rdi
  803df0:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  803df7:	00 00 00 
  803dfa:	ff d0                	callq  *%rax
  803dfc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e04:	ba 07 04 00 00       	mov    $0x407,%edx
  803e09:	48 89 c6             	mov    %rax,%rsi
  803e0c:	bf 00 00 00 00       	mov    $0x0,%edi
  803e11:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  803e18:	00 00 00 
  803e1b:	ff d0                	callq  *%rax
  803e1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e24:	0f 88 d9 00 00 00    	js     803f03 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
  803e3d:	48 89 c2             	mov    %rax,%rdx
  803e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e44:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e4a:	48 89 d1             	mov    %rdx,%rcx
  803e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803e52:	48 89 c6             	mov    %rax,%rsi
  803e55:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5a:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  803e61:	00 00 00 
  803e64:	ff d0                	callq  *%rax
  803e66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e6d:	78 79                	js     803ee8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e73:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e7a:	00 00 00 
  803e7d:	8b 12                	mov    (%rdx),%edx
  803e7f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e90:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e97:	00 00 00 
  803e9a:	8b 12                	mov    (%rdx),%edx
  803e9c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ea9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ead:	48 89 c7             	mov    %rax,%rdi
  803eb0:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  803eb7:	00 00 00 
  803eba:	ff d0                	callq  *%rax
  803ebc:	89 c2                	mov    %eax,%edx
  803ebe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ec4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ecc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed0:	48 89 c7             	mov    %rax,%rdi
  803ed3:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
  803edf:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee6:	eb 4f                	jmp    803f37 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ee8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803ee9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eed:	48 89 c6             	mov    %rax,%rsi
  803ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef5:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803efc:	00 00 00 
  803eff:	ff d0                	callq  *%rax
  803f01:	eb 01                	jmp    803f04 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803f03:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f08:	48 89 c6             	mov    %rax,%rsi
  803f0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f10:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f20:	48 89 c6             	mov    %rax,%rsi
  803f23:	bf 00 00 00 00       	mov    $0x0,%edi
  803f28:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803f2f:	00 00 00 
  803f32:	ff d0                	callq  *%rax
err:
	return r;
  803f34:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f37:	48 83 c4 38          	add    $0x38,%rsp
  803f3b:	5b                   	pop    %rbx
  803f3c:	5d                   	pop    %rbp
  803f3d:	c3                   	retq   

0000000000803f3e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f3e:	55                   	push   %rbp
  803f3f:	48 89 e5             	mov    %rsp,%rbp
  803f42:	53                   	push   %rbx
  803f43:	48 83 ec 28          	sub    $0x28,%rsp
  803f47:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f4b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f4f:	eb 01                	jmp    803f52 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803f51:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f52:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f59:	00 00 00 
  803f5c:	48 8b 00             	mov    (%rax),%rax
  803f5f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f65:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f6c:	48 89 c7             	mov    %rax,%rdi
  803f6f:	48 b8 b0 34 80 00 00 	movabs $0x8034b0,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
  803f7b:	89 c3                	mov    %eax,%ebx
  803f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f81:	48 89 c7             	mov    %rax,%rdi
  803f84:	48 b8 b0 34 80 00 00 	movabs $0x8034b0,%rax
  803f8b:	00 00 00 
  803f8e:	ff d0                	callq  *%rax
  803f90:	39 c3                	cmp    %eax,%ebx
  803f92:	0f 94 c0             	sete   %al
  803f95:	0f b6 c0             	movzbl %al,%eax
  803f98:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f9b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fa2:	00 00 00 
  803fa5:	48 8b 00             	mov    (%rax),%rax
  803fa8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fae:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803fb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fb7:	75 0a                	jne    803fc3 <_pipeisclosed+0x85>
			return ret;
  803fb9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803fbc:	48 83 c4 28          	add    $0x28,%rsp
  803fc0:	5b                   	pop    %rbx
  803fc1:	5d                   	pop    %rbp
  803fc2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803fc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fc9:	74 86                	je     803f51 <_pipeisclosed+0x13>
  803fcb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fcf:	75 80                	jne    803f51 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fd1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fd8:	00 00 00 
  803fdb:	48 8b 00             	mov    (%rax),%rax
  803fde:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fe4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fe7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fea:	89 c6                	mov    %eax,%esi
  803fec:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  803ff3:	00 00 00 
  803ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffb:	49 b8 a7 06 80 00 00 	movabs $0x8006a7,%r8
  804002:	00 00 00 
  804005:	41 ff d0             	callq  *%r8
	}
  804008:	e9 44 ff ff ff       	jmpq   803f51 <_pipeisclosed+0x13>

000000000080400d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80400d:	55                   	push   %rbp
  80400e:	48 89 e5             	mov    %rsp,%rbp
  804011:	48 83 ec 30          	sub    $0x30,%rsp
  804015:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804018:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80401c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80401f:	48 89 d6             	mov    %rdx,%rsi
  804022:	89 c7                	mov    %eax,%edi
  804024:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  80402b:	00 00 00 
  80402e:	ff d0                	callq  *%rax
  804030:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804033:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804037:	79 05                	jns    80403e <pipeisclosed+0x31>
		return r;
  804039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403c:	eb 31                	jmp    80406f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80403e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804042:	48 89 c7             	mov    %rax,%rdi
  804045:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  80404c:	00 00 00 
  80404f:	ff d0                	callq  *%rax
  804051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804059:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405d:	48 89 d6             	mov    %rdx,%rsi
  804060:	48 89 c7             	mov    %rax,%rdi
  804063:	48 b8 3e 3f 80 00 00 	movabs $0x803f3e,%rax
  80406a:	00 00 00 
  80406d:	ff d0                	callq  *%rax
}
  80406f:	c9                   	leaveq 
  804070:	c3                   	retq   

0000000000804071 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804071:	55                   	push   %rbp
  804072:	48 89 e5             	mov    %rsp,%rbp
  804075:	48 83 ec 40          	sub    $0x40,%rsp
  804079:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80407d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804081:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804085:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804089:	48 89 c7             	mov    %rax,%rdi
  80408c:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  804093:	00 00 00 
  804096:	ff d0                	callq  *%rax
  804098:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80409c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040ab:	00 
  8040ac:	e9 97 00 00 00       	jmpq   804148 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040b1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040b6:	74 09                	je     8040c1 <devpipe_read+0x50>
				return i;
  8040b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040bc:	e9 95 00 00 00       	jmpq   804156 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c9:	48 89 d6             	mov    %rdx,%rsi
  8040cc:	48 89 c7             	mov    %rax,%rdi
  8040cf:	48 b8 3e 3f 80 00 00 	movabs $0x803f3e,%rax
  8040d6:	00 00 00 
  8040d9:	ff d0                	callq  *%rax
  8040db:	85 c0                	test   %eax,%eax
  8040dd:	74 07                	je     8040e6 <devpipe_read+0x75>
				return 0;
  8040df:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e4:	eb 70                	jmp    804156 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040e6:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	eb 01                	jmp    8040f5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040f4:	90                   	nop
  8040f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f9:	8b 10                	mov    (%rax),%edx
  8040fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ff:	8b 40 04             	mov    0x4(%rax),%eax
  804102:	39 c2                	cmp    %eax,%edx
  804104:	74 ab                	je     8040b1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80410e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804116:	8b 00                	mov    (%rax),%eax
  804118:	89 c2                	mov    %eax,%edx
  80411a:	c1 fa 1f             	sar    $0x1f,%edx
  80411d:	c1 ea 1b             	shr    $0x1b,%edx
  804120:	01 d0                	add    %edx,%eax
  804122:	83 e0 1f             	and    $0x1f,%eax
  804125:	29 d0                	sub    %edx,%eax
  804127:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80412b:	48 98                	cltq   
  80412d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804132:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804138:	8b 00                	mov    (%rax),%eax
  80413a:	8d 50 01             	lea    0x1(%rax),%edx
  80413d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804141:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804143:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804150:	72 a2                	jb     8040f4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804156:	c9                   	leaveq 
  804157:	c3                   	retq   

0000000000804158 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804158:	55                   	push   %rbp
  804159:	48 89 e5             	mov    %rsp,%rbp
  80415c:	48 83 ec 40          	sub    $0x40,%rsp
  804160:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804164:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804168:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80416c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804170:	48 89 c7             	mov    %rax,%rdi
  804173:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  80417a:	00 00 00 
  80417d:	ff d0                	callq  *%rax
  80417f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804183:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804187:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80418b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804192:	00 
  804193:	e9 93 00 00 00       	jmpq   80422b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804198:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80419c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a0:	48 89 d6             	mov    %rdx,%rsi
  8041a3:	48 89 c7             	mov    %rax,%rdi
  8041a6:	48 b8 3e 3f 80 00 00 	movabs $0x803f3e,%rax
  8041ad:	00 00 00 
  8041b0:	ff d0                	callq  *%rax
  8041b2:	85 c0                	test   %eax,%eax
  8041b4:	74 07                	je     8041bd <devpipe_write+0x65>
				return 0;
  8041b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041bb:	eb 7c                	jmp    804239 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041bd:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8041c4:	00 00 00 
  8041c7:	ff d0                	callq  *%rax
  8041c9:	eb 01                	jmp    8041cc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041cb:	90                   	nop
  8041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d0:	8b 40 04             	mov    0x4(%rax),%eax
  8041d3:	48 63 d0             	movslq %eax,%rdx
  8041d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041da:	8b 00                	mov    (%rax),%eax
  8041dc:	48 98                	cltq   
  8041de:	48 83 c0 20          	add    $0x20,%rax
  8041e2:	48 39 c2             	cmp    %rax,%rdx
  8041e5:	73 b1                	jae    804198 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041eb:	8b 40 04             	mov    0x4(%rax),%eax
  8041ee:	89 c2                	mov    %eax,%edx
  8041f0:	c1 fa 1f             	sar    $0x1f,%edx
  8041f3:	c1 ea 1b             	shr    $0x1b,%edx
  8041f6:	01 d0                	add    %edx,%eax
  8041f8:	83 e0 1f             	and    $0x1f,%eax
  8041fb:	29 d0                	sub    %edx,%eax
  8041fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804201:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804205:	48 01 ca             	add    %rcx,%rdx
  804208:	0f b6 0a             	movzbl (%rdx),%ecx
  80420b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80420f:	48 98                	cltq   
  804211:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804219:	8b 40 04             	mov    0x4(%rax),%eax
  80421c:	8d 50 01             	lea    0x1(%rax),%edx
  80421f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804223:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804226:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80422b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804233:	72 96                	jb     8041cb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804239:	c9                   	leaveq 
  80423a:	c3                   	retq   

000000000080423b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80423b:	55                   	push   %rbp
  80423c:	48 89 e5             	mov    %rsp,%rbp
  80423f:	48 83 ec 20          	sub    $0x20,%rsp
  804243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804247:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80424b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424f:	48 89 c7             	mov    %rax,%rdi
  804252:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  804259:	00 00 00 
  80425c:	ff d0                	callq  *%rax
  80425e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804262:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804266:	48 be 3c 4f 80 00 00 	movabs $0x804f3c,%rsi
  80426d:	00 00 00 
  804270:	48 89 c7             	mov    %rax,%rdi
  804273:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  80427a:	00 00 00 
  80427d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80427f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804283:	8b 50 04             	mov    0x4(%rax),%edx
  804286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428a:	8b 00                	mov    (%rax),%eax
  80428c:	29 c2                	sub    %eax,%edx
  80428e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804292:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804298:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80429c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8042a3:	00 00 00 
	stat->st_dev = &devpipe;
  8042a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042aa:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8042b1:	00 00 00 
  8042b4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8042bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042c0:	c9                   	leaveq 
  8042c1:	c3                   	retq   

00000000008042c2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042c2:	55                   	push   %rbp
  8042c3:	48 89 e5             	mov    %rsp,%rbp
  8042c6:	48 83 ec 10          	sub    $0x10,%rsp
  8042ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d2:	48 89 c6             	mov    %rax,%rsi
  8042d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8042da:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  8042e1:	00 00 00 
  8042e4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ea:	48 89 c7             	mov    %rax,%rdi
  8042ed:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  8042f4:	00 00 00 
  8042f7:	ff d0                	callq  *%rax
  8042f9:	48 89 c6             	mov    %rax,%rsi
  8042fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804301:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  804308:	00 00 00 
  80430b:	ff d0                	callq  *%rax
}
  80430d:	c9                   	leaveq 
  80430e:	c3                   	retq   
	...

0000000000804310 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804310:	55                   	push   %rbp
  804311:	48 89 e5             	mov    %rsp,%rbp
  804314:	48 83 ec 20          	sub    $0x20,%rsp
  804318:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80431b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80431e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804321:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804325:	be 01 00 00 00       	mov    $0x1,%esi
  80432a:	48 89 c7             	mov    %rax,%rdi
  80432d:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
}
  804339:	c9                   	leaveq 
  80433a:	c3                   	retq   

000000000080433b <getchar>:

int
getchar(void)
{
  80433b:	55                   	push   %rbp
  80433c:	48 89 e5             	mov    %rsp,%rbp
  80433f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804343:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804347:	ba 01 00 00 00       	mov    $0x1,%edx
  80434c:	48 89 c6             	mov    %rax,%rsi
  80434f:	bf 00 00 00 00       	mov    $0x0,%edi
  804354:	48 b8 a0 2d 80 00 00 	movabs $0x802da0,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
  804360:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804367:	79 05                	jns    80436e <getchar+0x33>
		return r;
  804369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80436c:	eb 14                	jmp    804382 <getchar+0x47>
	if (r < 1)
  80436e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804372:	7f 07                	jg     80437b <getchar+0x40>
		return -E_EOF;
  804374:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804379:	eb 07                	jmp    804382 <getchar+0x47>
	return c;
  80437b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80437f:	0f b6 c0             	movzbl %al,%eax
}
  804382:	c9                   	leaveq 
  804383:	c3                   	retq   

0000000000804384 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804384:	55                   	push   %rbp
  804385:	48 89 e5             	mov    %rsp,%rbp
  804388:	48 83 ec 20          	sub    $0x20,%rsp
  80438c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80438f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804393:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804396:	48 89 d6             	mov    %rdx,%rsi
  804399:	89 c7                	mov    %eax,%edi
  80439b:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8043a2:	00 00 00 
  8043a5:	ff d0                	callq  *%rax
  8043a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ae:	79 05                	jns    8043b5 <iscons+0x31>
		return r;
  8043b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b3:	eb 1a                	jmp    8043cf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8043b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b9:	8b 10                	mov    (%rax),%edx
  8043bb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8043c2:	00 00 00 
  8043c5:	8b 00                	mov    (%rax),%eax
  8043c7:	39 c2                	cmp    %eax,%edx
  8043c9:	0f 94 c0             	sete   %al
  8043cc:	0f b6 c0             	movzbl %al,%eax
}
  8043cf:	c9                   	leaveq 
  8043d0:	c3                   	retq   

00000000008043d1 <opencons>:

int
opencons(void)
{
  8043d1:	55                   	push   %rbp
  8043d2:	48 89 e5             	mov    %rsp,%rbp
  8043d5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043d9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043dd:	48 89 c7             	mov    %rax,%rdi
  8043e0:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  8043e7:	00 00 00 
  8043ea:	ff d0                	callq  *%rax
  8043ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f3:	79 05                	jns    8043fa <opencons+0x29>
		return r;
  8043f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f8:	eb 5b                	jmp    804455 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043fe:	ba 07 04 00 00       	mov    $0x407,%edx
  804403:	48 89 c6             	mov    %rax,%rsi
  804406:	bf 00 00 00 00       	mov    $0x0,%edi
  80440b:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  804412:	00 00 00 
  804415:	ff d0                	callq  *%rax
  804417:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80441a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80441e:	79 05                	jns    804425 <opencons+0x54>
		return r;
  804420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804423:	eb 30                	jmp    804455 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804429:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804430:	00 00 00 
  804433:	8b 12                	mov    (%rdx),%edx
  804435:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804446:	48 89 c7             	mov    %rax,%rdi
  804449:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  804450:	00 00 00 
  804453:	ff d0                	callq  *%rax
}
  804455:	c9                   	leaveq 
  804456:	c3                   	retq   

0000000000804457 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804457:	55                   	push   %rbp
  804458:	48 89 e5             	mov    %rsp,%rbp
  80445b:	48 83 ec 30          	sub    $0x30,%rsp
  80445f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804463:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804467:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80446b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804470:	75 13                	jne    804485 <devcons_read+0x2e>
		return 0;
  804472:	b8 00 00 00 00       	mov    $0x0,%eax
  804477:	eb 49                	jmp    8044c2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804479:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804485:	48 b8 b2 1a 80 00 00 	movabs $0x801ab2,%rax
  80448c:	00 00 00 
  80448f:	ff d0                	callq  *%rax
  804491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804498:	74 df                	je     804479 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80449a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80449e:	79 05                	jns    8044a5 <devcons_read+0x4e>
		return c;
  8044a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a3:	eb 1d                	jmp    8044c2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8044a5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8044a9:	75 07                	jne    8044b2 <devcons_read+0x5b>
		return 0;
  8044ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b0:	eb 10                	jmp    8044c2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8044b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b5:	89 c2                	mov    %eax,%edx
  8044b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044bb:	88 10                	mov    %dl,(%rax)
	return 1;
  8044bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8044c2:	c9                   	leaveq 
  8044c3:	c3                   	retq   

00000000008044c4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044c4:	55                   	push   %rbp
  8044c5:	48 89 e5             	mov    %rsp,%rbp
  8044c8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8044cf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044d6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044dd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044eb:	eb 77                	jmp    804564 <devcons_write+0xa0>
		m = n - tot;
  8044ed:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044f4:	89 c2                	mov    %eax,%edx
  8044f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f9:	89 d1                	mov    %edx,%ecx
  8044fb:	29 c1                	sub    %eax,%ecx
  8044fd:	89 c8                	mov    %ecx,%eax
  8044ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804502:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804505:	83 f8 7f             	cmp    $0x7f,%eax
  804508:	76 07                	jbe    804511 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80450a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804511:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804514:	48 63 d0             	movslq %eax,%rdx
  804517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451a:	48 98                	cltq   
  80451c:	48 89 c1             	mov    %rax,%rcx
  80451f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804526:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80452d:	48 89 ce             	mov    %rcx,%rsi
  804530:	48 89 c7             	mov    %rax,%rdi
  804533:	48 b8 9a 15 80 00 00 	movabs $0x80159a,%rax
  80453a:	00 00 00 
  80453d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80453f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804542:	48 63 d0             	movslq %eax,%rdx
  804545:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80454c:	48 89 d6             	mov    %rdx,%rsi
  80454f:	48 89 c7             	mov    %rax,%rdi
  804552:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  804559:	00 00 00 
  80455c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80455e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804561:	01 45 fc             	add    %eax,-0x4(%rbp)
  804564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804567:	48 98                	cltq   
  804569:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804570:	0f 82 77 ff ff ff    	jb     8044ed <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804576:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804579:	c9                   	leaveq 
  80457a:	c3                   	retq   

000000000080457b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80457b:	55                   	push   %rbp
  80457c:	48 89 e5             	mov    %rsp,%rbp
  80457f:	48 83 ec 08          	sub    $0x8,%rsp
  804583:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804587:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80458c:	c9                   	leaveq 
  80458d:	c3                   	retq   

000000000080458e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80458e:	55                   	push   %rbp
  80458f:	48 89 e5             	mov    %rsp,%rbp
  804592:	48 83 ec 10          	sub    $0x10,%rsp
  804596:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80459a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80459e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045a2:	48 be 48 4f 80 00 00 	movabs $0x804f48,%rsi
  8045a9:	00 00 00 
  8045ac:	48 89 c7             	mov    %rax,%rdi
  8045af:	48 b8 78 12 80 00 00 	movabs $0x801278,%rax
  8045b6:	00 00 00 
  8045b9:	ff d0                	callq  *%rax
	return 0;
  8045bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045c0:	c9                   	leaveq 
  8045c1:	c3                   	retq   
	...

00000000008045c4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8045c4:	55                   	push   %rbp
  8045c5:	48 89 e5             	mov    %rsp,%rbp
  8045c8:	48 83 ec 10          	sub    $0x10,%rsp
  8045cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8045d0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045d7:	00 00 00 
  8045da:	48 8b 00             	mov    (%rax),%rax
  8045dd:	48 85 c0             	test   %rax,%rax
  8045e0:	75 66                	jne    804648 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8045e2:	ba 07 00 00 00       	mov    $0x7,%edx
  8045e7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8045ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8045f1:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  8045f8:	00 00 00 
  8045fb:	ff d0                	callq  *%rax
  8045fd:	85 c0                	test   %eax,%eax
  8045ff:	75 1d                	jne    80461e <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804601:	48 be 5c 46 80 00 00 	movabs $0x80465c,%rsi
  804608:	00 00 00 
  80460b:	bf 00 00 00 00       	mov    $0x0,%edi
  804610:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  804617:	00 00 00 
  80461a:	ff d0                	callq  *%rax
  80461c:	eb 2a                	jmp    804648 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  80461e:	48 ba 4f 4f 80 00 00 	movabs $0x804f4f,%rdx
  804625:	00 00 00 
  804628:	be 23 00 00 00       	mov    $0x23,%esi
  80462d:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  804634:	00 00 00 
  804637:	b8 00 00 00 00       	mov    $0x0,%eax
  80463c:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  804643:	00 00 00 
  804646:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804648:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80464f:	00 00 00 
  804652:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804656:	48 89 10             	mov    %rdx,(%rax)
}
  804659:	c9                   	leaveq 
  80465a:	c3                   	retq   
	...

000000000080465c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80465c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80465f:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804666:	00 00 00 
call *%rax
  804669:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  80466b:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  80466f:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804674:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  80467b:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  80467c:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804680:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  804683:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  80468a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  80468b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80468f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804694:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804699:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80469e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8046a3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8046a8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8046ad:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8046b2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8046b7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8046bc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8046c1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8046c6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8046cb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8046d0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8046d5:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8046d9:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8046dd:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8046de:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8046df:	c3                   	retq   
