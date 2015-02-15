
obj/user/testpiperace2.debug:     file format elf64-x86-64


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
  80003c:	e8 f7 02 00 00       	callq  800338 <libmain>
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
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800053:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800072:	48 89 c7             	mov    %rax,%rdi
  800075:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
  800081:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800084:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800088:	79 30                	jns    8000ba <umain+0x76>
		panic("pipe: %e", r);
  80008a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008d:	89 c1                	mov    %eax,%ecx
  80008f:	48 ba a2 46 80 00 00 	movabs $0x8046a2,%rdx
  800096:	00 00 00 
  800099:	be 0d 00 00 00       	mov    $0xd,%esi
  80009e:	48 bf ab 46 80 00 00 	movabs $0x8046ab,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8000b4:	00 00 00 
  8000b7:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000ba:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
  8000c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cd:	79 30                	jns    8000ff <umain+0xbb>
		panic("fork: %e", r);
  8000cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d2:	89 c1                	mov    %eax,%ecx
  8000d4:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  8000db:	00 00 00 
  8000de:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e3:	48 bf ab 46 80 00 00 	movabs $0x8046ab,%rdi
  8000ea:	00 00 00 
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8000f9:	00 00 00 
  8000fc:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800103:	0f 85 c0 00 00 00    	jne    8001c9 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800109:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010c:	89 c7                	mov    %eax,%edi
  80010e:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  80011a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800121:	e9 8a 00 00 00       	jmpq   8001b0 <umain+0x16c>
			if (i % 10 == 0)
  800126:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800129:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012e:	89 c8                	mov    %ecx,%eax
  800130:	f7 ea                	imul   %edx
  800132:	c1 fa 02             	sar    $0x2,%edx
  800135:	89 c8                	mov    %ecx,%eax
  800137:	c1 f8 1f             	sar    $0x1f,%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	89 d0                	mov    %edx,%eax
  80013e:	c1 e0 02             	shl    $0x2,%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	01 c0                	add    %eax,%eax
  800145:	89 ca                	mov    %ecx,%edx
  800147:	29 c2                	sub    %eax,%edx
  800149:	85 d2                	test   %edx,%edx
  80014b:	75 20                	jne    80016d <umain+0x129>
				cprintf("%d.", i);
  80014d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800150:	89 c6                	mov    %eax,%esi
  800152:	48 bf c9 46 80 00 00 	movabs $0x8046c9,%rdi
  800159:	00 00 00 
  80015c:	b8 00 00 00 00       	mov    $0x0,%eax
  800161:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800168:	00 00 00 
  80016b:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800170:	be 0a 00 00 00       	mov    $0xa,%esi
  800175:	89 c7                	mov    %eax,%edi
  800177:	48 b8 6b 29 80 00 00 	movabs $0x80296b,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
			sys_yield();
  800183:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
			close(10);
  80018f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800194:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
			sys_yield();
  8001a0:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b0:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b7:	0f 8e 69 ff ff ff    	jle    800126 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bd:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cc:	48 98                	cltq   
  8001ce:	48 89 c2             	mov    %rax,%rdx
  8001d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001d7:	48 89 d0             	mov    %rdx,%rax
  8001da:	48 c1 e0 02          	shl    $0x2,%rax
  8001de:	48 01 d0             	add    %rdx,%rax
  8001e1:	48 01 c0             	add    %rax,%rax
  8001e4:	48 01 d0             	add    %rdx,%rax
  8001e7:	48 c1 e0 05          	shl    $0x5,%rax
  8001eb:	48 89 c2             	mov    %rax,%rdx
  8001ee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f5:	00 00 00 
  8001f8:	48 01 d0             	add    %rdx,%rax
  8001fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001ff:	eb 4d                	jmp    80024e <umain+0x20a>
		if (pipeisclosed(p[0]) != 0) {
  800201:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800204:	89 c7                	mov    %eax,%edi
  800206:	48 b8 f5 3c 80 00 00 	movabs $0x803cf5,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	85 c0                	test   %eax,%eax
  800214:	74 38                	je     80024e <umain+0x20a>
			cprintf("\nRACE: pipe appears closed\n");
  800216:	48 bf cd 46 80 00 00 	movabs $0x8046cd,%rdi
  80021d:	00 00 00 
  800220:	b8 00 00 00 00       	mov    $0x0,%eax
  800225:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  80022c:	00 00 00 
  80022f:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800231:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
			exit();
  800242:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  800249:	00 00 00 
  80024c:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  80024e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800252:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800258:	83 f8 02             	cmp    $0x2,%eax
  80025b:	74 a4                	je     800201 <umain+0x1bd>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80025d:	48 bf e9 46 80 00 00 	movabs $0x8046e9,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800273:	00 00 00 
  800276:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800278:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80027b:	89 c7                	mov    %eax,%edi
  80027d:	48 b8 f5 3c 80 00 00 	movabs $0x803cf5,%rax
  800284:	00 00 00 
  800287:	ff d0                	callq  *%rax
  800289:	85 c0                	test   %eax,%eax
  80028b:	74 2a                	je     8002b7 <umain+0x273>
		panic("somehow the other end of p[0] got closed!");
  80028d:	48 ba 00 47 80 00 00 	movabs $0x804700,%rdx
  800294:	00 00 00 
  800297:	be 40 00 00 00       	mov    $0x40,%esi
  80029c:	48 bf ab 46 80 00 00 	movabs $0x8046ab,%rdi
  8002a3:	00 00 00 
  8002a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ab:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  8002b2:	00 00 00 
  8002b5:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002b7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ba:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002be:	48 89 d6             	mov    %rdx,%rsi
  8002c1:	89 c7                	mov    %eax,%edi
  8002c3:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  8002ca:	00 00 00 
  8002cd:	ff d0                	callq  *%rax
  8002cf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002d2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002d6:	79 30                	jns    800308 <umain+0x2c4>
		panic("cannot look up p[0]: %e", r);
  8002d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	48 ba 2a 47 80 00 00 	movabs $0x80472a,%rdx
  8002e4:	00 00 00 
  8002e7:	be 42 00 00 00       	mov    $0x42,%esi
  8002ec:	48 bf ab 46 80 00 00 	movabs $0x8046ab,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  800302:	00 00 00 
  800305:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  800308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80030c:	48 89 c7             	mov    %rax,%rdi
  80030f:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  800316:	00 00 00 
  800319:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80031b:	48 bf 42 47 80 00 00 	movabs $0x804742,%rdi
  800322:	00 00 00 
  800325:	b8 00 00 00 00       	mov    $0x0,%eax
  80032a:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800331:	00 00 00 
  800334:	ff d2                	callq  *%rdx
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 83 ec 10          	sub    $0x10,%rsp
  800340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800347:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80034e:	00 00 00 
  800351:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800358:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
  800364:	48 98                	cltq   
  800366:	48 89 c2             	mov    %rax,%rdx
  800369:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80036f:	48 89 d0             	mov    %rdx,%rax
  800372:	48 c1 e0 02          	shl    $0x2,%rax
  800376:	48 01 d0             	add    %rdx,%rax
  800379:	48 01 c0             	add    %rax,%rax
  80037c:	48 01 d0             	add    %rdx,%rax
  80037f:	48 c1 e0 05          	shl    $0x5,%rax
  800383:	48 89 c2             	mov    %rax,%rdx
  800386:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80038d:	00 00 00 
  800390:	48 01 c2             	add    %rax,%rdx
  800393:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80039a:	00 00 00 
  80039d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a4:	7e 14                	jle    8003ba <libmain+0x82>
		binaryname = argv[0];
  8003a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003aa:	48 8b 10             	mov    (%rax),%rdx
  8003ad:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b4:	00 00 00 
  8003b7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	48 89 d6             	mov    %rdx,%rsi
  8003c4:	89 c7                	mov    %eax,%edi
  8003c6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003cd:	00 00 00 
  8003d0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003d2:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
}
  8003de:	c9                   	leaveq 
  8003df:	c3                   	retq   

00000000008003e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e0:	55                   	push   %rbp
  8003e1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e4:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f5:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  8003fc:	00 00 00 
  8003ff:	ff d0                	callq  *%rax
}
  800401:	5d                   	pop    %rbp
  800402:	c3                   	retq   
	...

0000000000800404 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
  800408:	53                   	push   %rbx
  800409:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800410:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800417:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80041d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800424:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80042b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800432:	84 c0                	test   %al,%al
  800434:	74 23                	je     800459 <_panic+0x55>
  800436:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80043d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800441:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800445:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800449:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80044d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800451:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800455:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800459:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800460:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800467:	00 00 00 
  80046a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800471:	00 00 00 
  800474:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800478:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80047f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800486:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80048d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800494:	00 00 00 
  800497:	48 8b 18             	mov    (%rax),%rbx
  80049a:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8004a1:	00 00 00 
  8004a4:	ff d0                	callq  *%rax
  8004a6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004ac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004b3:	41 89 c8             	mov    %ecx,%r8d
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 da             	mov    %rbx,%rdx
  8004bc:	89 c6                	mov    %eax,%esi
  8004be:	48 bf 60 47 80 00 00 	movabs $0x804760,%rdi
  8004c5:	00 00 00 
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cd:	49 b9 3f 06 80 00 00 	movabs $0x80063f,%r9
  8004d4:	00 00 00 
  8004d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004e8:	48 89 d6             	mov    %rdx,%rsi
  8004eb:	48 89 c7             	mov    %rax,%rdi
  8004ee:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8004fa:	48 bf 83 47 80 00 00 	movabs $0x804783,%rdi
  800501:	00 00 00 
  800504:	b8 00 00 00 00       	mov    $0x0,%eax
  800509:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800510:	00 00 00 
  800513:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800515:	cc                   	int3   
  800516:	eb fd                	jmp    800515 <_panic+0x111>

0000000000800518 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 83 ec 10          	sub    $0x10,%rsp
  800520:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800523:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052b:	8b 00                	mov    (%rax),%eax
  80052d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800530:	89 d6                	mov    %edx,%esi
  800532:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800536:	48 63 d0             	movslq %eax,%rdx
  800539:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80053e:	8d 50 01             	lea    0x1(%rax),%edx
  800541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800545:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054b:	8b 00                	mov    (%rax),%eax
  80054d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800552:	75 2c                	jne    800580 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800558:	8b 00                	mov    (%rax),%eax
  80055a:	48 98                	cltq   
  80055c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800560:	48 83 c2 08          	add    $0x8,%rdx
  800564:	48 89 c6             	mov    %rax,%rsi
  800567:	48 89 d7             	mov    %rdx,%rdi
  80056a:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800571:	00 00 00 
  800574:	ff d0                	callq  *%rax
        b->idx = 0;
  800576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800584:	8b 40 04             	mov    0x4(%rax),%eax
  800587:	8d 50 01             	lea    0x1(%rax),%edx
  80058a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800591:	c9                   	leaveq 
  800592:	c3                   	retq   

0000000000800593 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800593:	55                   	push   %rbp
  800594:	48 89 e5             	mov    %rsp,%rbp
  800597:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80059e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005ac:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ba:	48 8b 0a             	mov    (%rdx),%rcx
  8005bd:	48 89 08             	mov    %rcx,(%rax)
  8005c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005d7:	00 00 00 
    b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005eb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005f9:	48 89 c6             	mov    %rax,%rsi
  8005fc:	48 bf 18 05 80 00 00 	movabs $0x800518,%rdi
  800603:	00 00 00 
  800606:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800612:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800618:	48 98                	cltq   
  80061a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800621:	48 83 c2 08          	add    $0x8,%rdx
  800625:	48 89 c6             	mov    %rax,%rsi
  800628:	48 89 d7             	mov    %rdx,%rdi
  80062b:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800637:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80063d:	c9                   	leaveq 
  80063e:	c3                   	retq   

000000000080063f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80063f:	55                   	push   %rbp
  800640:	48 89 e5             	mov    %rsp,%rbp
  800643:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800651:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800658:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80065f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800666:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80066d:	84 c0                	test   %al,%al
  80066f:	74 20                	je     800691 <cprintf+0x52>
  800671:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800675:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800679:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80067d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800681:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800685:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800689:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80068d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800691:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800698:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80069f:	00 00 00 
  8006a2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006a9:	00 00 00 
  8006ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006b7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006be:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006c5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006cc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d3:	48 8b 0a             	mov    (%rdx),%rcx
  8006d6:	48 89 08             	mov    %rcx,(%rax)
  8006d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006e9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006f7:	48 89 d6             	mov    %rdx,%rsi
  8006fa:	48 89 c7             	mov    %rax,%rdi
  8006fd:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  800704:	00 00 00 
  800707:	ff d0                	callq  *%rax
  800709:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80070f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800715:	c9                   	leaveq 
  800716:	c3                   	retq   
	...

0000000000800718 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800718:	55                   	push   %rbp
  800719:	48 89 e5             	mov    %rsp,%rbp
  80071c:	48 83 ec 30          	sub    $0x30,%rsp
  800720:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800724:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800728:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80072c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80072f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800733:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800737:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80073a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80073e:	77 52                	ja     800792 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800740:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800743:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800747:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80074a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	48 f7 75 d0          	divq   -0x30(%rbp)
  80075b:	48 89 c2             	mov    %rax,%rdx
  80075e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800761:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800764:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80076c:	41 89 f9             	mov    %edi,%r9d
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	eb 1c                	jmp    80079c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800780:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800784:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800787:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80078b:	48 89 d6             	mov    %rdx,%rsi
  80078e:	89 c7                	mov    %eax,%edi
  800790:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800792:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800796:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80079a:	7f e4                	jg     800780 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	48 f7 f1             	div    %rcx
  8007ab:	48 89 d0             	mov    %rdx,%rax
  8007ae:	48 ba 90 49 80 00 00 	movabs $0x804990,%rdx
  8007b5:	00 00 00 
  8007b8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007bc:	0f be c0             	movsbl %al,%eax
  8007bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007c3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007c7:	48 89 d6             	mov    %rdx,%rsi
  8007ca:	89 c7                	mov    %eax,%edi
  8007cc:	ff d1                	callq  *%rcx
}
  8007ce:	c9                   	leaveq 
  8007cf:	c3                   	retq   

00000000008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %rbp
  8007d1:	48 89 e5             	mov    %rsp,%rbp
  8007d4:	48 83 ec 20          	sub    $0x20,%rsp
  8007d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e3:	7e 52                	jle    800837 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 24                	jae    800814 <getuint+0x44>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	8b 00                	mov    (%rax),%eax
  8007fe:	89 c0                	mov    %eax,%eax
  800800:	48 01 d0             	add    %rdx,%rax
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	8b 12                	mov    (%rdx),%edx
  800809:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800810:	89 0a                	mov    %ecx,(%rdx)
  800812:	eb 17                	jmp    80082b <getuint+0x5b>
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081c:	48 89 d0             	mov    %rdx,%rax
  80081f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082b:	48 8b 00             	mov    (%rax),%rax
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800832:	e9 a3 00 00 00       	jmpq   8008da <getuint+0x10a>
	else if (lflag)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083b:	74 4f                	je     80088c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	8b 00                	mov    (%rax),%eax
  800843:	83 f8 30             	cmp    $0x30,%eax
  800846:	73 24                	jae    80086c <getuint+0x9c>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 01 d0             	add    %rdx,%rax
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	8b 12                	mov    (%rdx),%edx
  800861:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	89 0a                	mov    %ecx,(%rdx)
  80086a:	eb 17                	jmp    800883 <getuint+0xb3>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800874:	48 89 d0             	mov    %rdx,%rax
  800877:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800883:	48 8b 00             	mov    (%rax),%rax
  800886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088a:	eb 4e                	jmp    8008da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	83 f8 30             	cmp    $0x30,%eax
  800895:	73 24                	jae    8008bb <getuint+0xeb>
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	8b 12                	mov    (%rdx),%edx
  8008b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	89 0a                	mov    %ecx,(%rdx)
  8008b9:	eb 17                	jmp    8008d2 <getuint+0x102>
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c3:	48 89 d0             	mov    %rdx,%rax
  8008c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d2:	8b 00                	mov    (%rax),%eax
  8008d4:	89 c0                	mov    %eax,%eax
  8008d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	48 83 ec 20          	sub    $0x20,%rsp
  8008e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f3:	7e 52                	jle    800947 <getint+0x67>
		x=va_arg(*ap, long long);
  8008f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	83 f8 30             	cmp    $0x30,%eax
  8008fe:	73 24                	jae    800924 <getint+0x44>
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	8b 00                	mov    (%rax),%eax
  80090e:	89 c0                	mov    %eax,%eax
  800910:	48 01 d0             	add    %rdx,%rax
  800913:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800917:	8b 12                	mov    (%rdx),%edx
  800919:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800920:	89 0a                	mov    %ecx,(%rdx)
  800922:	eb 17                	jmp    80093b <getint+0x5b>
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092c:	48 89 d0             	mov    %rdx,%rax
  80092f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800937:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093b:	48 8b 00             	mov    (%rax),%rax
  80093e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800942:	e9 a3 00 00 00       	jmpq   8009ea <getint+0x10a>
	else if (lflag)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094b:	74 4f                	je     80099c <getint+0xbc>
		x=va_arg(*ap, long);
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	8b 00                	mov    (%rax),%eax
  800953:	83 f8 30             	cmp    $0x30,%eax
  800956:	73 24                	jae    80097c <getint+0x9c>
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	8b 00                	mov    (%rax),%eax
  800966:	89 c0                	mov    %eax,%eax
  800968:	48 01 d0             	add    %rdx,%rax
  80096b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096f:	8b 12                	mov    (%rdx),%edx
  800971:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800978:	89 0a                	mov    %ecx,(%rdx)
  80097a:	eb 17                	jmp    800993 <getint+0xb3>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800984:	48 89 d0             	mov    %rdx,%rax
  800987:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800993:	48 8b 00             	mov    (%rax),%rax
  800996:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099a:	eb 4e                	jmp    8009ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80099c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	83 f8 30             	cmp    $0x30,%eax
  8009a5:	73 24                	jae    8009cb <getint+0xeb>
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	8b 00                	mov    (%rax),%eax
  8009b5:	89 c0                	mov    %eax,%eax
  8009b7:	48 01 d0             	add    %rdx,%rax
  8009ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009be:	8b 12                	mov    (%rdx),%edx
  8009c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c7:	89 0a                	mov    %ecx,(%rdx)
  8009c9:	eb 17                	jmp    8009e2 <getint+0x102>
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d3:	48 89 d0             	mov    %rdx,%rax
  8009d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e2:	8b 00                	mov    (%rax),%eax
  8009e4:	48 98                	cltq   
  8009e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ee:	c9                   	leaveq 
  8009ef:	c3                   	retq   

00000000008009f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f0:	55                   	push   %rbp
  8009f1:	48 89 e5             	mov    %rsp,%rbp
  8009f4:	41 54                	push   %r12
  8009f6:	53                   	push   %rbx
  8009f7:	48 83 ec 60          	sub    $0x60,%rsp
  8009fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a03:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a07:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a0f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a13:	48 8b 0a             	mov    (%rdx),%rcx
  800a16:	48 89 08             	mov    %rcx,(%rax)
  800a19:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a1d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a21:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a25:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a29:	eb 17                	jmp    800a42 <vprintfmt+0x52>
			if (ch == '\0')
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	0f 84 ea 04 00 00    	je     800f1d <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800a33:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a37:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a3b:	48 89 c6             	mov    %rax,%rsi
  800a3e:	89 df                	mov    %ebx,%edi
  800a40:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a42:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a46:	0f b6 00             	movzbl (%rax),%eax
  800a49:	0f b6 d8             	movzbl %al,%ebx
  800a4c:	83 fb 25             	cmp    $0x25,%ebx
  800a4f:	0f 95 c0             	setne  %al
  800a52:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a57:	84 c0                	test   %al,%al
  800a59:	75 d0                	jne    800a2b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a5f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800a7b:	eb 04                	jmp    800a81 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a7d:	90                   	nop
  800a7e:	eb 01                	jmp    800a81 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a80:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a85:	0f b6 00             	movzbl (%rax),%eax
  800a88:	0f b6 d8             	movzbl %al,%ebx
  800a8b:	89 d8                	mov    %ebx,%eax
  800a8d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a92:	83 e8 23             	sub    $0x23,%eax
  800a95:	83 f8 55             	cmp    $0x55,%eax
  800a98:	0f 87 4b 04 00 00    	ja     800ee9 <vprintfmt+0x4f9>
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa7:	00 
  800aa8:	48 b8 b8 49 80 00 00 	movabs $0x8049b8,%rax
  800aaf:	00 00 00 
  800ab2:	48 01 d0             	add    %rdx,%rax
  800ab5:	48 8b 00             	mov    (%rax),%rax
  800ab8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800abe:	eb c1                	jmp    800a81 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac4:	eb bb                	jmp    800a81 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800acd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	c1 e0 02             	shl    $0x2,%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	01 c0                	add    %eax,%eax
  800ad9:	01 d8                	add    %ebx,%eax
  800adb:	83 e8 30             	sub    $0x30,%eax
  800ade:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae5:	0f b6 00             	movzbl (%rax),%eax
  800ae8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aeb:	83 fb 2f             	cmp    $0x2f,%ebx
  800aee:	7e 63                	jle    800b53 <vprintfmt+0x163>
  800af0:	83 fb 39             	cmp    $0x39,%ebx
  800af3:	7f 5e                	jg     800b53 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afa:	eb d1                	jmp    800acd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800afc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aff:	83 f8 30             	cmp    $0x30,%eax
  800b02:	73 17                	jae    800b1b <vprintfmt+0x12b>
  800b04:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0b:	89 c0                	mov    %eax,%eax
  800b0d:	48 01 d0             	add    %rdx,%rax
  800b10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b13:	83 c2 08             	add    $0x8,%edx
  800b16:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b19:	eb 0f                	jmp    800b2a <vprintfmt+0x13a>
  800b1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1f:	48 89 d0             	mov    %rdx,%rax
  800b22:	48 83 c2 08          	add    $0x8,%rdx
  800b26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2a:	8b 00                	mov    (%rax),%eax
  800b2c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b2f:	eb 23                	jmp    800b54 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b35:	0f 89 42 ff ff ff    	jns    800a7d <vprintfmt+0x8d>
				width = 0;
  800b3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b42:	e9 36 ff ff ff       	jmpq   800a7d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800b47:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b4e:	e9 2e ff ff ff       	jmpq   800a81 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b53:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b54:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b58:	0f 89 22 ff ff ff    	jns    800a80 <vprintfmt+0x90>
				width = precision, precision = -1;
  800b5e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b61:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b64:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b6b:	e9 10 ff ff ff       	jmpq   800a80 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b70:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b74:	e9 08 ff ff ff       	jmpq   800a81 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7c:	83 f8 30             	cmp    $0x30,%eax
  800b7f:	73 17                	jae    800b98 <vprintfmt+0x1a8>
  800b81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b88:	89 c0                	mov    %eax,%eax
  800b8a:	48 01 d0             	add    %rdx,%rax
  800b8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b90:	83 c2 08             	add    $0x8,%edx
  800b93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b96:	eb 0f                	jmp    800ba7 <vprintfmt+0x1b7>
  800b98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9c:	48 89 d0             	mov    %rdx,%rax
  800b9f:	48 83 c2 08          	add    $0x8,%rdx
  800ba3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba7:	8b 00                	mov    (%rax),%eax
  800ba9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bad:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bb1:	48 89 d6             	mov    %rdx,%rsi
  800bb4:	89 c7                	mov    %eax,%edi
  800bb6:	ff d1                	callq  *%rcx
			break;
  800bb8:	e9 5a 03 00 00       	jmpq   800f17 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 30             	cmp    $0x30,%eax
  800bc3:	73 17                	jae    800bdc <vprintfmt+0x1ec>
  800bc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	89 c0                	mov    %eax,%eax
  800bce:	48 01 d0             	add    %rdx,%rax
  800bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd4:	83 c2 08             	add    $0x8,%edx
  800bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bda:	eb 0f                	jmp    800beb <vprintfmt+0x1fb>
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 89 d0             	mov    %rdx,%rax
  800be3:	48 83 c2 08          	add    $0x8,%rdx
  800be7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800beb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	79 02                	jns    800bf3 <vprintfmt+0x203>
				err = -err;
  800bf1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf3:	83 fb 15             	cmp    $0x15,%ebx
  800bf6:	7f 16                	jg     800c0e <vprintfmt+0x21e>
  800bf8:	48 b8 e0 48 80 00 00 	movabs $0x8048e0,%rax
  800bff:	00 00 00 
  800c02:	48 63 d3             	movslq %ebx,%rdx
  800c05:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c09:	4d 85 e4             	test   %r12,%r12
  800c0c:	75 2e                	jne    800c3c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	89 d9                	mov    %ebx,%ecx
  800c18:	48 ba a1 49 80 00 00 	movabs $0x8049a1,%rdx
  800c1f:	00 00 00 
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	49 b8 27 0f 80 00 00 	movabs $0x800f27,%r8
  800c31:	00 00 00 
  800c34:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c37:	e9 db 02 00 00       	jmpq   800f17 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c3c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c44:	4c 89 e1             	mov    %r12,%rcx
  800c47:	48 ba aa 49 80 00 00 	movabs $0x8049aa,%rdx
  800c4e:	00 00 00 
  800c51:	48 89 c7             	mov    %rax,%rdi
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
  800c59:	49 b8 27 0f 80 00 00 	movabs $0x800f27,%r8
  800c60:	00 00 00 
  800c63:	41 ff d0             	callq  *%r8
			break;
  800c66:	e9 ac 02 00 00       	jmpq   800f17 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6e:	83 f8 30             	cmp    $0x30,%eax
  800c71:	73 17                	jae    800c8a <vprintfmt+0x29a>
  800c73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7a:	89 c0                	mov    %eax,%eax
  800c7c:	48 01 d0             	add    %rdx,%rax
  800c7f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c82:	83 c2 08             	add    $0x8,%edx
  800c85:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c88:	eb 0f                	jmp    800c99 <vprintfmt+0x2a9>
  800c8a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8e:	48 89 d0             	mov    %rdx,%rax
  800c91:	48 83 c2 08          	add    $0x8,%rdx
  800c95:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c99:	4c 8b 20             	mov    (%rax),%r12
  800c9c:	4d 85 e4             	test   %r12,%r12
  800c9f:	75 0a                	jne    800cab <vprintfmt+0x2bb>
				p = "(null)";
  800ca1:	49 bc ad 49 80 00 00 	movabs $0x8049ad,%r12
  800ca8:	00 00 00 
			if (width > 0 && padc != '-')
  800cab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800caf:	7e 7a                	jle    800d2b <vprintfmt+0x33b>
  800cb1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb5:	74 74                	je     800d2b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cba:	48 98                	cltq   
  800cbc:	48 89 c6             	mov    %rax,%rsi
  800cbf:	4c 89 e7             	mov    %r12,%rdi
  800cc2:	48 b8 d2 11 80 00 00 	movabs $0x8011d2,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
  800cce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd1:	eb 17                	jmp    800cea <vprintfmt+0x2fa>
					putch(padc, putdat);
  800cd3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800cd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800cdf:	48 89 d6             	mov    %rdx,%rsi
  800ce2:	89 c7                	mov    %eax,%edi
  800ce4:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cee:	7f e3                	jg     800cd3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf0:	eb 39                	jmp    800d2b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf6:	74 1e                	je     800d16 <vprintfmt+0x326>
  800cf8:	83 fb 1f             	cmp    $0x1f,%ebx
  800cfb:	7e 05                	jle    800d02 <vprintfmt+0x312>
  800cfd:	83 fb 7e             	cmp    $0x7e,%ebx
  800d00:	7e 14                	jle    800d16 <vprintfmt+0x326>
					putch('?', putdat);
  800d02:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d06:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0a:	48 89 c6             	mov    %rax,%rsi
  800d0d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d12:	ff d2                	callq  *%rdx
  800d14:	eb 0f                	jmp    800d25 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d16:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d1a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d1e:	48 89 c6             	mov    %rax,%rsi
  800d21:	89 df                	mov    %ebx,%edi
  800d23:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d29:	eb 01                	jmp    800d2c <vprintfmt+0x33c>
  800d2b:	90                   	nop
  800d2c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d31:	0f be d8             	movsbl %al,%ebx
  800d34:	85 db                	test   %ebx,%ebx
  800d36:	0f 95 c0             	setne  %al
  800d39:	49 83 c4 01          	add    $0x1,%r12
  800d3d:	84 c0                	test   %al,%al
  800d3f:	74 28                	je     800d69 <vprintfmt+0x379>
  800d41:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d45:	78 ab                	js     800cf2 <vprintfmt+0x302>
  800d47:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4f:	79 a1                	jns    800cf2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d51:	eb 16                	jmp    800d69 <vprintfmt+0x379>
				putch(' ', putdat);
  800d53:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d57:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d5b:	48 89 c6             	mov    %rax,%rsi
  800d5e:	bf 20 00 00 00       	mov    $0x20,%edi
  800d63:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d65:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6d:	7f e4                	jg     800d53 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800d6f:	e9 a3 01 00 00       	jmpq   800f17 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d74:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d78:	be 03 00 00 00       	mov    $0x3,%esi
  800d7d:	48 89 c7             	mov    %rax,%rdi
  800d80:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	callq  *%rax
  800d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d94:	48 85 c0             	test   %rax,%rax
  800d97:	79 1d                	jns    800db6 <vprintfmt+0x3c6>
				putch('-', putdat);
  800d99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800da1:	48 89 c6             	mov    %rax,%rsi
  800da4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daf:	48 f7 d8             	neg    %rax
  800db2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbd:	e9 e8 00 00 00       	jmpq   800eaa <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc6:	be 03 00 00 00       	mov    $0x3,%esi
  800dcb:	48 89 c7             	mov    %rax,%rdi
  800dce:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800dd5:	00 00 00 
  800dd8:	ff d0                	callq  *%rax
  800dda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dde:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de5:	e9 c0 00 00 00       	jmpq   800eaa <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dee:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800df2:	48 89 c6             	mov    %rax,%rsi
  800df5:	bf 58 00 00 00       	mov    $0x58,%edi
  800dfa:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800dfc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e00:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e04:	48 89 c6             	mov    %rax,%rsi
  800e07:	bf 58 00 00 00       	mov    $0x58,%edi
  800e0c:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e16:	48 89 c6             	mov    %rax,%rsi
  800e19:	bf 58 00 00 00       	mov    $0x58,%edi
  800e1e:	ff d2                	callq  *%rdx
			break;
  800e20:	e9 f2 00 00 00       	jmpq   800f17 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800e25:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e29:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e2d:	48 89 c6             	mov    %rax,%rsi
  800e30:	bf 30 00 00 00       	mov    $0x30,%edi
  800e35:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e37:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e3f:	48 89 c6             	mov    %rax,%rsi
  800e42:	bf 78 00 00 00       	mov    $0x78,%edi
  800e47:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4c:	83 f8 30             	cmp    $0x30,%eax
  800e4f:	73 17                	jae    800e68 <vprintfmt+0x478>
  800e51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e58:	89 c0                	mov    %eax,%eax
  800e5a:	48 01 d0             	add    %rdx,%rax
  800e5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e60:	83 c2 08             	add    $0x8,%edx
  800e63:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e66:	eb 0f                	jmp    800e77 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800e68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6c:	48 89 d0             	mov    %rdx,%rax
  800e6f:	48 83 c2 08          	add    $0x8,%rdx
  800e73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e77:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e7e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e85:	eb 23                	jmp    800eaa <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e87:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8b:	be 03 00 00 00       	mov    $0x3,%esi
  800e90:	48 89 c7             	mov    %rax,%rdi
  800e93:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800e9a:	00 00 00 
  800e9d:	ff d0                	callq  *%rax
  800e9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eaa:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eaf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ebd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec1:	45 89 c1             	mov    %r8d,%r9d
  800ec4:	41 89 f8             	mov    %edi,%r8d
  800ec7:	48 89 c7             	mov    %rax,%rdi
  800eca:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax
			break;
  800ed6:	eb 3f                	jmp    800f17 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ed8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800edc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ee0:	48 89 c6             	mov    %rax,%rsi
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	ff d2                	callq  *%rdx
			break;
  800ee7:	eb 2e                	jmp    800f17 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eed:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ef1:	48 89 c6             	mov    %rax,%rsi
  800ef4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ef9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f00:	eb 05                	jmp    800f07 <vprintfmt+0x517>
  800f02:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0b:	48 83 e8 01          	sub    $0x1,%rax
  800f0f:	0f b6 00             	movzbl (%rax),%eax
  800f12:	3c 25                	cmp    $0x25,%al
  800f14:	75 ec                	jne    800f02 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800f16:	90                   	nop
		}
	}
  800f17:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f18:	e9 25 fb ff ff       	jmpq   800a42 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f1d:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f1e:	48 83 c4 60          	add    $0x60,%rsp
  800f22:	5b                   	pop    %rbx
  800f23:	41 5c                	pop    %r12
  800f25:	5d                   	pop    %rbp
  800f26:	c3                   	retq   

0000000000800f27 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f27:	55                   	push   %rbp
  800f28:	48 89 e5             	mov    %rsp,%rbp
  800f2b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f32:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f39:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f40:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f47:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f4e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f55:	84 c0                	test   %al,%al
  800f57:	74 20                	je     800f79 <printfmt+0x52>
  800f59:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f61:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f65:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f69:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f71:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f75:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f79:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f80:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f87:	00 00 00 
  800f8a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f91:	00 00 00 
  800f94:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f98:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f9f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fad:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fc9:	48 89 c7             	mov    %rax,%rdi
  800fcc:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  800fd3:	00 00 00 
  800fd6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fd8:	c9                   	leaveq 
  800fd9:	c3                   	retq   

0000000000800fda <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fda:	55                   	push   %rbp
  800fdb:	48 89 e5             	mov    %rsp,%rbp
  800fde:	48 83 ec 10          	sub    $0x10,%rsp
  800fe2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fed:	8b 40 10             	mov    0x10(%rax),%eax
  800ff0:	8d 50 01             	lea    0x1(%rax),%edx
  800ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffe:	48 8b 10             	mov    (%rax),%rdx
  801001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801005:	48 8b 40 08          	mov    0x8(%rax),%rax
  801009:	48 39 c2             	cmp    %rax,%rdx
  80100c:	73 17                	jae    801025 <sprintputch+0x4b>
		*b->buf++ = ch;
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801012:	48 8b 00             	mov    (%rax),%rax
  801015:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801018:	88 10                	mov    %dl,(%rax)
  80101a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80101e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801022:	48 89 10             	mov    %rdx,(%rax)
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 50          	sub    $0x50,%rsp
  80102f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801033:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801036:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80103e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801042:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801046:	48 8b 0a             	mov    (%rdx),%rcx
  801049:	48 89 08             	mov    %rcx,(%rax)
  80104c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801050:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801054:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801058:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801060:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801064:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801067:	48 98                	cltq   
  801069:	48 83 e8 01          	sub    $0x1,%rax
  80106d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801071:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801075:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80107c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801081:	74 06                	je     801089 <vsnprintf+0x62>
  801083:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801087:	7f 07                	jg     801090 <vsnprintf+0x69>
		return -E_INVAL;
  801089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108e:	eb 2f                	jmp    8010bf <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801090:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801094:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801098:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80109c:	48 89 c6             	mov    %rax,%rsi
  80109f:	48 bf da 0f 80 00 00 	movabs $0x800fda,%rdi
  8010a6:	00 00 00 
  8010a9:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010b9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010d9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010ee:	84 c0                	test   %al,%al
  8010f0:	74 20                	je     801112 <snprintf+0x51>
  8010f2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010f6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010fa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010fe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801102:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801106:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80110e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801112:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801119:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801120:	00 00 00 
  801123:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112a:	00 00 00 
  80112d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801131:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801138:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80113f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801146:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80114d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801154:	48 8b 0a             	mov    (%rdx),%rcx
  801157:	48 89 08             	mov    %rcx,(%rax)
  80115a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80115e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801162:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801166:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801171:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801178:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80117e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801185:	48 89 c7             	mov    %rax,%rdi
  801188:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  80118f:	00 00 00 
  801192:	ff d0                	callq  *%rax
  801194:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a0:	c9                   	leaveq 
  8011a1:	c3                   	retq   
	...

00000000008011a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 18          	sub    $0x18,%rsp
  8011ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b7:	eb 09                	jmp    8011c2 <strlen+0x1e>
		n++;
  8011b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	0f b6 00             	movzbl (%rax),%eax
  8011c9:	84 c0                	test   %al,%al
  8011cb:	75 ec                	jne    8011b9 <strlen+0x15>
		n++;
	return n;
  8011cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d0:	c9                   	leaveq 
  8011d1:	c3                   	retq   

00000000008011d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	48 83 ec 20          	sub    $0x20,%rsp
  8011da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011e9:	eb 0e                	jmp    8011f9 <strnlen+0x27>
		n++;
  8011eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011f9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011fe:	74 0b                	je     80120b <strnlen+0x39>
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	84 c0                	test   %al,%al
  801209:	75 e0                	jne    8011eb <strnlen+0x19>
		n++;
	return n;
  80120b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 20          	sub    $0x20,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801228:	90                   	nop
  801229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80122d:	0f b6 10             	movzbl (%rax),%edx
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	88 10                	mov    %dl,(%rax)
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	0f 95 c0             	setne  %al
  801242:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801247:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80124c:	84 c0                	test   %al,%al
  80124e:	75 d9                	jne    801229 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801254:	c9                   	leaveq 
  801255:	c3                   	retq   

0000000000801256 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	48 83 ec 20          	sub    $0x20,%rsp
  80125e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801262:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	48 89 c7             	mov    %rax,%rdi
  80126d:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  801274:	00 00 00 
  801277:	ff d0                	callq  *%rax
  801279:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80127c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127f:	48 98                	cltq   
  801281:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801285:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801289:	48 89 d6             	mov    %rdx,%rsi
  80128c:	48 89 c7             	mov    %rax,%rdi
  80128f:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  801296:	00 00 00 
  801299:	ff d0                	callq  *%rax
	return dst;
  80129b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129f:	c9                   	leaveq 
  8012a0:	c3                   	retq   

00000000008012a1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a1:	55                   	push   %rbp
  8012a2:	48 89 e5             	mov    %rsp,%rbp
  8012a5:	48 83 ec 28          	sub    $0x28,%rsp
  8012a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012bd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c4:	00 
  8012c5:	eb 27                	jmp    8012ee <strncpy+0x4d>
		*dst++ = *src;
  8012c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cb:	0f b6 10             	movzbl (%rax),%edx
  8012ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d2:	88 10                	mov    %dl,(%rax)
  8012d4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	84 c0                	test   %al,%al
  8012e2:	74 05                	je     8012e9 <strncpy+0x48>
			src++;
  8012e4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012f6:	72 cf                	jb     8012c7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012fc:	c9                   	leaveq 
  8012fd:	c3                   	retq   

00000000008012fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp
  801302:	48 83 ec 28          	sub    $0x28,%rsp
  801306:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80131a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131f:	74 37                	je     801358 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801321:	eb 17                	jmp    80133a <strlcpy+0x3c>
			*dst++ = *src++;
  801323:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801327:	0f b6 10             	movzbl (%rax),%edx
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	88 10                	mov    %dl,(%rax)
  801330:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801335:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80133a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80133f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801344:	74 0b                	je     801351 <strlcpy+0x53>
  801346:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134a:	0f b6 00             	movzbl (%rax),%eax
  80134d:	84 c0                	test   %al,%al
  80134f:	75 d2                	jne    801323 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801355:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801358:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	48 89 d1             	mov    %rdx,%rcx
  801363:	48 29 c1             	sub    %rax,%rcx
  801366:	48 89 c8             	mov    %rcx,%rax
}
  801369:	c9                   	leaveq 
  80136a:	c3                   	retq   

000000000080136b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136b:	55                   	push   %rbp
  80136c:	48 89 e5             	mov    %rsp,%rbp
  80136f:	48 83 ec 10          	sub    $0x10,%rsp
  801373:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801377:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80137b:	eb 0a                	jmp    801387 <strcmp+0x1c>
		p++, q++;
  80137d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801382:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	84 c0                	test   %al,%al
  801390:	74 12                	je     8013a4 <strcmp+0x39>
  801392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801396:	0f b6 10             	movzbl (%rax),%edx
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	38 c2                	cmp    %al,%dl
  8013a2:	74 d9                	je     80137d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a8:	0f b6 00             	movzbl (%rax),%eax
  8013ab:	0f b6 d0             	movzbl %al,%edx
  8013ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	0f b6 c0             	movzbl %al,%eax
  8013b8:	89 d1                	mov    %edx,%ecx
  8013ba:	29 c1                	sub    %eax,%ecx
  8013bc:	89 c8                	mov    %ecx,%eax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 18          	sub    $0x18,%rsp
  8013c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013d4:	eb 0f                	jmp    8013e5 <strncmp+0x25>
		n--, p++, q++;
  8013d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ea:	74 1d                	je     801409 <strncmp+0x49>
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 12                	je     801409 <strncmp+0x49>
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	0f b6 10             	movzbl (%rax),%edx
  8013fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	38 c2                	cmp    %al,%dl
  801407:	74 cd                	je     8013d6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801409:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140e:	75 07                	jne    801417 <strncmp+0x57>
		return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 1a                	jmp    801431 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	0f b6 d0             	movzbl %al,%edx
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	0f b6 c0             	movzbl %al,%eax
  80142b:	89 d1                	mov    %edx,%ecx
  80142d:	29 c1                	sub    %eax,%ecx
  80142f:	89 c8                	mov    %ecx,%eax
}
  801431:	c9                   	leaveq 
  801432:	c3                   	retq   

0000000000801433 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801433:	55                   	push   %rbp
  801434:	48 89 e5             	mov    %rsp,%rbp
  801437:	48 83 ec 10          	sub    $0x10,%rsp
  80143b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143f:	89 f0                	mov    %esi,%eax
  801441:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801444:	eb 17                	jmp    80145d <strchr+0x2a>
		if (*s == c)
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801450:	75 06                	jne    801458 <strchr+0x25>
			return (char *) s;
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	eb 15                	jmp    80146d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801458:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	84 c0                	test   %al,%al
  801466:	75 de                	jne    801446 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 10          	sub    $0x10,%rsp
  801477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147b:	89 f0                	mov    %esi,%eax
  80147d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801480:	eb 11                	jmp    801493 <strfind+0x24>
		if (*s == c)
  801482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148c:	74 12                	je     8014a0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80148e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	84 c0                	test   %al,%al
  80149c:	75 e4                	jne    801482 <strfind+0x13>
  80149e:	eb 01                	jmp    8014a1 <strfind+0x32>
		if (*s == c)
			break;
  8014a0:	90                   	nop
	return (char *) s;
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a5:	c9                   	leaveq 
  8014a6:	c3                   	retq   

00000000008014a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014a7:	55                   	push   %rbp
  8014a8:	48 89 e5             	mov    %rsp,%rbp
  8014ab:	48 83 ec 18          	sub    $0x18,%rsp
  8014af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014bf:	75 06                	jne    8014c7 <memset+0x20>
		return v;
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	eb 69                	jmp    801530 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cb:	83 e0 03             	and    $0x3,%eax
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 48                	jne    80151b <memset+0x74>
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d7:	83 e0 03             	and    $0x3,%eax
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 3c                	jne    80151b <memset+0x74>
		c &= 0xFF;
  8014df:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	c1 e2 18             	shl    $0x18,%edx
  8014ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f1:	c1 e0 10             	shl    $0x10,%eax
  8014f4:	09 c2                	or     %eax,%edx
  8014f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f9:	c1 e0 08             	shl    $0x8,%eax
  8014fc:	09 d0                	or     %edx,%eax
  8014fe:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801505:	48 89 c1             	mov    %rax,%rcx
  801508:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80150c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801510:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801513:	48 89 d7             	mov    %rdx,%rdi
  801516:	fc                   	cld    
  801517:	f3 ab                	rep stos %eax,%es:(%rdi)
  801519:	eb 11                	jmp    80152c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80151b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801522:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801526:	48 89 d7             	mov    %rdx,%rdi
  801529:	fc                   	cld    
  80152a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80152c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801530:	c9                   	leaveq 
  801531:	c3                   	retq   

0000000000801532 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801532:	55                   	push   %rbp
  801533:	48 89 e5             	mov    %rsp,%rbp
  801536:	48 83 ec 28          	sub    $0x28,%rsp
  80153a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80153e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801542:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801546:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80154e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155e:	0f 83 88 00 00 00    	jae    8015ec <memmove+0xba>
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156c:	48 01 d0             	add    %rdx,%rax
  80156f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801573:	76 77                	jbe    8015ec <memmove+0xba>
		s += n;
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80157d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801581:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801589:	83 e0 03             	and    $0x3,%eax
  80158c:	48 85 c0             	test   %rax,%rax
  80158f:	75 3b                	jne    8015cc <memmove+0x9a>
  801591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801595:	83 e0 03             	and    $0x3,%eax
  801598:	48 85 c0             	test   %rax,%rax
  80159b:	75 2f                	jne    8015cc <memmove+0x9a>
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	83 e0 03             	and    $0x3,%eax
  8015a4:	48 85 c0             	test   %rax,%rax
  8015a7:	75 23                	jne    8015cc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ad:	48 83 e8 04          	sub    $0x4,%rax
  8015b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b5:	48 83 ea 04          	sub    $0x4,%rdx
  8015b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015bd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c1:	48 89 c7             	mov    %rax,%rdi
  8015c4:	48 89 d6             	mov    %rdx,%rsi
  8015c7:	fd                   	std    
  8015c8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ca:	eb 1d                	jmp    8015e9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	48 89 d7             	mov    %rdx,%rdi
  8015e3:	48 89 c1             	mov    %rax,%rcx
  8015e6:	fd                   	std    
  8015e7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015e9:	fc                   	cld    
  8015ea:	eb 57                	jmp    801643 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f0:	83 e0 03             	and    $0x3,%eax
  8015f3:	48 85 c0             	test   %rax,%rax
  8015f6:	75 36                	jne    80162e <memmove+0xfc>
  8015f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fc:	83 e0 03             	and    $0x3,%eax
  8015ff:	48 85 c0             	test   %rax,%rax
  801602:	75 2a                	jne    80162e <memmove+0xfc>
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	83 e0 03             	and    $0x3,%eax
  80160b:	48 85 c0             	test   %rax,%rax
  80160e:	75 1e                	jne    80162e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	48 89 c1             	mov    %rax,%rcx
  801617:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80161b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801623:	48 89 c7             	mov    %rax,%rdi
  801626:	48 89 d6             	mov    %rdx,%rsi
  801629:	fc                   	cld    
  80162a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80162c:	eb 15                	jmp    801643 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80162e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801632:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801636:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163a:	48 89 c7             	mov    %rax,%rdi
  80163d:	48 89 d6             	mov    %rdx,%rsi
  801640:	fc                   	cld    
  801641:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801647:	c9                   	leaveq 
  801648:	c3                   	retq   

0000000000801649 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801649:	55                   	push   %rbp
  80164a:	48 89 e5             	mov    %rsp,%rbp
  80164d:	48 83 ec 18          	sub    $0x18,%rsp
  801651:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801655:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801659:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80165d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801661:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801669:	48 89 ce             	mov    %rcx,%rsi
  80166c:	48 89 c7             	mov    %rax,%rdi
  80166f:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  801676:	00 00 00 
  801679:	ff d0                	callq  *%rax
}
  80167b:	c9                   	leaveq 
  80167c:	c3                   	retq   

000000000080167d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	48 83 ec 28          	sub    $0x28,%rsp
  801685:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801689:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801695:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801699:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80169d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a1:	eb 38                	jmp    8016db <memcmp+0x5e>
		if (*s1 != *s2)
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	0f b6 10             	movzbl (%rax),%edx
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	38 c2                	cmp    %al,%dl
  8016b3:	74 1c                	je     8016d1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8016b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	0f b6 d0             	movzbl %al,%edx
  8016bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	0f b6 c0             	movzbl %al,%eax
  8016c9:	89 d1                	mov    %edx,%ecx
  8016cb:	29 c1                	sub    %eax,%ecx
  8016cd:	89 c8                	mov    %ecx,%eax
  8016cf:	eb 20                	jmp    8016f1 <memcmp+0x74>
		s1++, s2++;
  8016d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016e0:	0f 95 c0             	setne  %al
  8016e3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016e8:	84 c0                	test   %al,%al
  8016ea:	75 b7                	jne    8016a3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 28          	sub    $0x28,%rsp
  8016fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801702:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170e:	48 01 d0             	add    %rdx,%rax
  801711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801715:	eb 13                	jmp    80172a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171b:	0f b6 10             	movzbl (%rax),%edx
  80171e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801721:	38 c2                	cmp    %al,%dl
  801723:	74 11                	je     801736 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801725:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801732:	72 e3                	jb     801717 <memfind+0x24>
  801734:	eb 01                	jmp    801737 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801736:	90                   	nop
	return (void *) s;
  801737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173b:	c9                   	leaveq 
  80173c:	c3                   	retq   

000000000080173d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173d:	55                   	push   %rbp
  80173e:	48 89 e5             	mov    %rsp,%rbp
  801741:	48 83 ec 38          	sub    $0x38,%rsp
  801745:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801749:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80174d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801750:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801757:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80175e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 05                	jmp    801766 <strtol+0x29>
		s++;
  801761:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	3c 20                	cmp    $0x20,%al
  80176f:	74 f0                	je     801761 <strtol+0x24>
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	3c 09                	cmp    $0x9,%al
  80177a:	74 e5                	je     801761 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	3c 2b                	cmp    $0x2b,%al
  801785:	75 07                	jne    80178e <strtol+0x51>
		s++;
  801787:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178c:	eb 17                	jmp    8017a5 <strtol+0x68>
	else if (*s == '-')
  80178e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	3c 2d                	cmp    $0x2d,%al
  801797:	75 0c                	jne    8017a5 <strtol+0x68>
		s++, neg = 1;
  801799:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80179e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a9:	74 06                	je     8017b1 <strtol+0x74>
  8017ab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017af:	75 28                	jne    8017d9 <strtol+0x9c>
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	0f b6 00             	movzbl (%rax),%eax
  8017b8:	3c 30                	cmp    $0x30,%al
  8017ba:	75 1d                	jne    8017d9 <strtol+0x9c>
  8017bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c0:	48 83 c0 01          	add    $0x1,%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	3c 78                	cmp    $0x78,%al
  8017c9:	75 0e                	jne    8017d9 <strtol+0x9c>
		s += 2, base = 16;
  8017cb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d7:	eb 2c                	jmp    801805 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017dd:	75 19                	jne    8017f8 <strtol+0xbb>
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	3c 30                	cmp    $0x30,%al
  8017e8:	75 0e                	jne    8017f8 <strtol+0xbb>
		s++, base = 8;
  8017ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f6:	eb 0d                	jmp    801805 <strtol+0xc8>
	else if (base == 0)
  8017f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fc:	75 07                	jne    801805 <strtol+0xc8>
		base = 10;
  8017fe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	3c 2f                	cmp    $0x2f,%al
  80180e:	7e 1d                	jle    80182d <strtol+0xf0>
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	3c 39                	cmp    $0x39,%al
  801819:	7f 12                	jg     80182d <strtol+0xf0>
			dig = *s - '0';
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	0f be c0             	movsbl %al,%eax
  801825:	83 e8 30             	sub    $0x30,%eax
  801828:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182b:	eb 4e                	jmp    80187b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 60                	cmp    $0x60,%al
  801836:	7e 1d                	jle    801855 <strtol+0x118>
  801838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183c:	0f b6 00             	movzbl (%rax),%eax
  80183f:	3c 7a                	cmp    $0x7a,%al
  801841:	7f 12                	jg     801855 <strtol+0x118>
			dig = *s - 'a' + 10;
  801843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801847:	0f b6 00             	movzbl (%rax),%eax
  80184a:	0f be c0             	movsbl %al,%eax
  80184d:	83 e8 57             	sub    $0x57,%eax
  801850:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801853:	eb 26                	jmp    80187b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	0f b6 00             	movzbl (%rax),%eax
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 47                	jle    8018a7 <strtol+0x16a>
  801860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801864:	0f b6 00             	movzbl (%rax),%eax
  801867:	3c 5a                	cmp    $0x5a,%al
  801869:	7f 3c                	jg     8018a7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80186b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186f:	0f b6 00             	movzbl (%rax),%eax
  801872:	0f be c0             	movsbl %al,%eax
  801875:	83 e8 37             	sub    $0x37,%eax
  801878:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80187e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801881:	7d 23                	jge    8018a6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801883:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801888:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188b:	48 98                	cltq   
  80188d:	48 89 c2             	mov    %rax,%rdx
  801890:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801895:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801898:	48 98                	cltq   
  80189a:	48 01 d0             	add    %rdx,%rax
  80189d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a1:	e9 5f ff ff ff       	jmpq   801805 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018a6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018a7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018ac:	74 0b                	je     8018b9 <strtol+0x17c>
		*endptr = (char *) s;
  8018ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018bd:	74 09                	je     8018c8 <strtol+0x18b>
  8018bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c3:	48 f7 d8             	neg    %rax
  8018c6:	eb 04                	jmp    8018cc <strtol+0x18f>
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018cc:	c9                   	leaveq 
  8018cd:	c3                   	retq   

00000000008018ce <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ce:	55                   	push   %rbp
  8018cf:	48 89 e5             	mov    %rsp,%rbp
  8018d2:	48 83 ec 30          	sub    $0x30,%rsp
  8018d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8018e8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8018ed:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f1:	75 06                	jne    8018f9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8018f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f7:	eb 68                	jmp    801961 <strstr+0x93>

	len = strlen(str);
  8018f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fd:	48 89 c7             	mov    %rax,%rdi
  801900:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  801907:	00 00 00 
  80190a:	ff d0                	callq  *%rax
  80190c:	48 98                	cltq   
  80190e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	88 45 ef             	mov    %al,-0x11(%rbp)
  80191c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801921:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801925:	75 07                	jne    80192e <strstr+0x60>
				return (char *) 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	eb 33                	jmp    801961 <strstr+0x93>
		} while (sc != c);
  80192e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801932:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801935:	75 db                	jne    801912 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801937:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80193f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801943:	48 89 ce             	mov    %rcx,%rsi
  801946:	48 89 c7             	mov    %rax,%rdi
  801949:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  801950:	00 00 00 
  801953:	ff d0                	callq  *%rax
  801955:	85 c0                	test   %eax,%eax
  801957:	75 b9                	jne    801912 <strstr+0x44>

	return (char *) (in - 1);
  801959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195d:	48 83 e8 01          	sub    $0x1,%rax
}
  801961:	c9                   	leaveq 
  801962:	c3                   	retq   
	...

0000000000801964 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 83 ec 58          	sub    $0x58,%rsp
  80196d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801970:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801973:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801977:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80197f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801983:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801986:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801989:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80198d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801991:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801995:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801999:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80199d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8019a0:	4c 89 c3             	mov    %r8,%rbx
  8019a3:	cd 30                	int    $0x30
  8019a5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8019a9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b5:	74 3e                	je     8019f5 <syscall+0x91>
  8019b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019bc:	7e 37                	jle    8019f5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c5:	49 89 d0             	mov    %rdx,%r8
  8019c8:	89 c1                	mov    %eax,%ecx
  8019ca:	48 ba 68 4c 80 00 00 	movabs $0x804c68,%rdx
  8019d1:	00 00 00 
  8019d4:	be 23 00 00 00       	mov    $0x23,%esi
  8019d9:	48 bf 85 4c 80 00 00 	movabs $0x804c85,%rdi
  8019e0:	00 00 00 
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e8:	49 b9 04 04 80 00 00 	movabs $0x800404,%r9
  8019ef:	00 00 00 
  8019f2:	41 ff d1             	callq  *%r9

	return ret;
  8019f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f9:	48 83 c4 58          	add    $0x58,%rsp
  8019fd:	5b                   	pop    %rbx
  8019fe:	5d                   	pop    %rbp
  8019ff:	c3                   	retq   

0000000000801a00 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 20          	sub    $0x20,%rsp
  801a08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2c:	48 89 d1             	mov    %rdx,%rcx
  801a2f:	48 89 c2             	mov    %rax,%rdx
  801a32:	be 00 00 00 00       	mov    $0x0,%esi
  801a37:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3c:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	callq  *%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a59:	00 
  801a5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	be 00 00 00 00       	mov    $0x0,%esi
  801a75:	bf 01 00 00 00       	mov    $0x1,%edi
  801a7a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 20          	sub    $0x20,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a96:	48 98                	cltq   
  801a98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9f:	00 
  801aa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 03 00 00 00       	mov    $0x3,%edi
  801abe:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ad4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adb:	00 
  801adc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aed:	ba 00 00 00 00       	mov    $0x0,%edx
  801af2:	be 00 00 00 00       	mov    $0x0,%esi
  801af7:	bf 02 00 00 00       	mov    $0x2,%edi
  801afc:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax
}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_yield>:

void
sys_yield(void)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b19:	00 
  801b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	be 00 00 00 00       	mov    $0x0,%esi
  801b35:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 20          	sub    $0x20,%rsp
  801b50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b57:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 c8             	movslq %eax,%rcx
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b70:	00 
  801b71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b77:	49 89 c8             	mov    %rcx,%r8
  801b7a:	48 89 d1             	mov    %rdx,%rcx
  801b7d:	48 89 c2             	mov    %rax,%rdx
  801b80:	be 01 00 00 00       	mov    $0x1,%esi
  801b85:	bf 04 00 00 00       	mov    $0x4,%edi
  801b8a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 30          	sub    $0x30,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801baa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bb2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb5:	48 63 c8             	movslq %eax,%rcx
  801bb8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbf:	48 63 f0             	movslq %eax,%rsi
  801bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	48 98                	cltq   
  801bcb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bcf:	49 89 f9             	mov    %rdi,%r9
  801bd2:	49 89 f0             	mov    %rsi,%r8
  801bd5:	48 89 d1             	mov    %rdx,%rcx
  801bd8:	48 89 c2             	mov    %rax,%rdx
  801bdb:	be 01 00 00 00       	mov    $0x1,%esi
  801be0:	bf 05 00 00 00       	mov    $0x5,%edi
  801be5:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	callq  *%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 20          	sub    $0x20,%rsp
  801bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c09:	48 98                	cltq   
  801c0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c12:	00 
  801c13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 01 00 00 00       	mov    $0x1,%esi
  801c2a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c2f:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 20          	sub    $0x20,%rsp
  801c45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c48:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4e:	48 63 d0             	movslq %eax,%rdx
  801c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c54:	48 98                	cltq   
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 01 00 00 00       	mov    $0x1,%esi
  801c75:	bf 08 00 00 00       	mov    $0x8,%edi
  801c7a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 20          	sub    $0x20,%rsp
  801c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9e:	48 98                	cltq   
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb4:	48 89 d1             	mov    %rdx,%rcx
  801cb7:	48 89 c2             	mov    %rax,%rdx
  801cba:	be 01 00 00 00       	mov    $0x1,%esi
  801cbf:	bf 09 00 00 00       	mov    $0x9,%edi
  801cc4:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 20          	sub    $0x20,%rsp
  801cda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ce1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	48 98                	cltq   
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	48 89 d1             	mov    %rdx,%rcx
  801d01:	48 89 c2             	mov    %rax,%rdx
  801d04:	be 01 00 00 00       	mov    $0x1,%esi
  801d09:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d0e:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d15:	00 00 00 
  801d18:	ff d0                	callq  *%rax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 30          	sub    $0x30,%rsp
  801d24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d35:	48 63 f0             	movslq %eax,%rsi
  801d38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3f:	48 98                	cltq   
  801d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4c:	00 
  801d4d:	49 89 f1             	mov    %rsi,%r9
  801d50:	49 89 c8             	mov    %rcx,%r8
  801d53:	48 89 d1             	mov    %rdx,%rcx
  801d56:	48 89 c2             	mov    %rax,%rdx
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d63:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 20          	sub    $0x20,%rsp
  801d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d88:	00 
  801d89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9a:	48 89 c2             	mov    %rax,%rdx
  801d9d:	be 01 00 00 00       	mov    $0x1,%esi
  801da2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da7:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc4:	00 
  801dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddb:	be 00 00 00 00       	mov    $0x0,%esi
  801de0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801de5:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801dec:	00 00 00 
  801def:	ff d0                	callq  *%rax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 30          	sub    $0x30,%rsp
  801dfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e02:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e05:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e09:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e0d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e10:	48 63 c8             	movslq %eax,%rcx
  801e13:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1a:	48 63 f0             	movslq %eax,%rsi
  801e1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e24:	48 98                	cltq   
  801e26:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e2a:	49 89 f9             	mov    %rdi,%r9
  801e2d:	49 89 f0             	mov    %rsi,%r8
  801e30:	48 89 d1             	mov    %rdx,%rcx
  801e33:	48 89 c2             	mov    %rax,%rdx
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e40:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 20          	sub    $0x20,%rsp
  801e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6d:	00 
  801e6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7a:	48 89 d1             	mov    %rdx,%rcx
  801e7d:	48 89 c2             	mov    %rax,%rdx
  801e80:	be 00 00 00 00       	mov    $0x0,%esi
  801e85:	bf 10 00 00 00       	mov    $0x10,%edi
  801e8a:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	callq  *%rax
}
  801e96:	c9                   	leaveq 
  801e97:	c3                   	retq   

0000000000801e98 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e98:	55                   	push   %rbp
  801e99:	48 89 e5             	mov    %rsp,%rbp
  801e9c:	48 83 ec 40          	sub    $0x40,%rsp
  801ea0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ea4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ea8:	48 8b 00             	mov    (%rax),%rax
  801eab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801eaf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801eb3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebe:	48 89 c2             	mov    %rax,%rdx
  801ec1:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ec5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ecc:	01 00 00 
  801ecf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801ed7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eda:	83 e0 02             	and    $0x2,%eax
  801edd:	85 c0                	test   %eax,%eax
  801edf:	0f 84 4f 01 00 00    	je     802034 <pgfault+0x19c>
  801ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee9:	48 89 c2             	mov    %rax,%rdx
  801eec:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ef0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ef7:	01 00 00 
  801efa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efe:	25 00 08 00 00       	and    $0x800,%eax
  801f03:	48 85 c0             	test   %rax,%rax
  801f06:	0f 84 28 01 00 00    	je     802034 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801f0c:	ba 07 00 00 00       	mov    $0x7,%edx
  801f11:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f16:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1b:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	0f 85 db 00 00 00    	jne    80200a <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801f2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f33:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801f37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f41:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801f45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f49:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f4e:	48 89 c6             	mov    %rax,%rsi
  801f51:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f56:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801f62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f66:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f6c:	48 89 c1             	mov    %rax,%rcx
  801f6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f74:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f79:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7e:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	callq  *%rax
  801f8a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801f8d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f91:	79 2a                	jns    801fbd <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801f93:	48 ba 98 4c 80 00 00 	movabs $0x804c98,%rdx
  801f9a:	00 00 00 
  801f9d:	be 28 00 00 00       	mov    $0x28,%esi
  801fa2:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  801fa9:	00 00 00 
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  801fb8:	00 00 00 
  801fbb:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  801fbd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	callq  *%rax
  801fd3:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801fd6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801fda:	0f 89 84 00 00 00    	jns    802064 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  801fe0:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  801fe7:	00 00 00 
  801fea:	be 2c 00 00 00       	mov    $0x2c,%esi
  801fef:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  801ff6:	00 00 00 
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  802005:	00 00 00 
  802008:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  80200a:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  802011:	00 00 00 
  802014:	be 31 00 00 00       	mov    $0x31,%esi
  802019:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  802020:	00 00 00 
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
  802028:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  80202f:	00 00 00 
  802032:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802034:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802037:	89 c1                	mov    %eax,%ecx
  802039:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  802040:	00 00 00 
  802043:	be 35 00 00 00       	mov    $0x35,%esi
  802048:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80204f:	00 00 00 
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
  802057:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  80205e:	00 00 00 
  802061:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  802064:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 30          	sub    $0x30,%rsp
  80206f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802072:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  802075:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207c:	01 00 00 
  80207f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802082:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802086:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  80208a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80208d:	48 c1 e0 0c          	shl    $0xc,%rax
  802091:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802099:	25 07 0e 00 00       	and    $0xe07,%eax
  80209e:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  8020a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a4:	25 00 04 00 00       	and    $0x400,%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 62                	je     80210f <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  8020ad:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8020b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bb:	41 89 f0             	mov    %esi,%r8d
  8020be:	48 89 c6             	mov    %rax,%rsi
  8020c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c6:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax
  8020d2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8020d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020d9:	0f 89 78 01 00 00    	jns    802257 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8020df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  8020eb:	00 00 00 
  8020ee:	be 4f 00 00 00       	mov    $0x4f,%esi
  8020f3:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8020fa:	00 00 00 
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802109:	00 00 00 
  80210c:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  80210f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802112:	25 00 08 00 00       	and    $0x800,%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	75 0e                	jne    802129 <duppage+0xc2>
  80211b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211e:	83 e0 02             	and    $0x2,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	0f 84 d0 00 00 00    	je     8021f9 <duppage+0x192>
		perm &= ~PTE_W;
  802129:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  80212d:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  802134:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802137:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80213b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80213e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802142:	41 89 f0             	mov    %esi,%r8d
  802145:	48 89 c6             	mov    %rax,%rsi
  802148:	bf 00 00 00 00       	mov    $0x0,%edi
  80214d:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
  802159:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80215c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802160:	79 30                	jns    802192 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  802162:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802165:	89 c1                	mov    %eax,%ecx
  802167:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  80216e:	00 00 00 
  802171:	be 57 00 00 00       	mov    $0x57,%esi
  802176:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80217d:	00 00 00 
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  80218c:	00 00 00 
  80218f:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802192:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219d:	41 89 c8             	mov    %ecx,%r8d
  8021a0:	48 89 d1             	mov    %rdx,%rcx
  8021a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a8:	48 89 c6             	mov    %rax,%rsi
  8021ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b0:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8021bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021c3:	0f 89 8e 00 00 00    	jns    802257 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8021c9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021cc:	89 c1                	mov    %eax,%ecx
  8021ce:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  8021d5:	00 00 00 
  8021d8:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021dd:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8021e4:	00 00 00 
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8021f3:	00 00 00 
  8021f6:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  8021f9:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8021fc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802200:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802207:	41 89 f0             	mov    %esi,%r8d
  80220a:	48 89 c6             	mov    %rax,%rsi
  80220d:	bf 00 00 00 00       	mov    $0x0,%edi
  802212:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802219:	00 00 00 
  80221c:	ff d0                	callq  *%rax
  80221e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802221:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802225:	79 30                	jns    802257 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802227:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80222a:	89 c1                	mov    %eax,%ecx
  80222c:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  802233:	00 00 00 
  802236:	be 61 00 00 00       	mov    $0x61,%esi
  80223b:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  802242:	00 00 00 
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
  80224a:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802251:	00 00 00 
  802254:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	53                   	push   %rbx
  802263:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  802267:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  80226e:	48 bf 98 1e 80 00 00 	movabs $0x801e98,%rdi
  802275:	00 00 00 
  802278:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  80227f:	00 00 00 
  802282:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802284:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80228b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80228e:	cd 30                	int    $0x30
  802290:	89 c3                	mov    %eax,%ebx
  802292:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802295:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802298:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80229b:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80229f:	79 30                	jns    8022d1 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  8022a1:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8022a4:	89 c1                	mov    %eax,%ecx
  8022a6:	48 ba 6b 4d 80 00 00 	movabs $0x804d6b,%rdx
  8022ad:	00 00 00 
  8022b0:	be 80 00 00 00       	mov    $0x80,%esi
  8022b5:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8022bc:	00 00 00 
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8022cb:	00 00 00 
  8022ce:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  8022d1:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8022d5:	75 52                	jne    802329 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  8022d7:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	callq  *%rax
  8022e3:	48 98                	cltq   
  8022e5:	48 89 c2             	mov    %rax,%rdx
  8022e8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8022ee:	48 89 d0             	mov    %rdx,%rax
  8022f1:	48 c1 e0 02          	shl    $0x2,%rax
  8022f5:	48 01 d0             	add    %rdx,%rax
  8022f8:	48 01 c0             	add    %rax,%rax
  8022fb:	48 01 d0             	add    %rdx,%rax
  8022fe:	48 c1 e0 05          	shl    $0x5,%rax
  802302:	48 89 c2             	mov    %rax,%rdx
  802305:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80230c:	00 00 00 
  80230f:	48 01 c2             	add    %rax,%rdx
  802312:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802319:	00 00 00 
  80231c:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	e9 9d 02 00 00       	jmpq   8025c6 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  802329:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80232c:	ba 07 00 00 00       	mov    $0x7,%edx
  802331:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802336:	89 c7                	mov    %eax,%edi
  802338:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802347:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80234b:	79 30                	jns    80237d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  80234d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802350:	89 c1                	mov    %eax,%ecx
  802352:	48 ba 6b 4d 80 00 00 	movabs $0x804d6b,%rdx
  802359:	00 00 00 
  80235c:	be 88 00 00 00       	mov    $0x88,%esi
  802361:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  802368:	00 00 00 
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802377:	00 00 00 
  80237a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80237d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802384:	00 
	uint64_t each_pte = 0;
  802385:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80238c:	00 
	uint64_t each_pdpe = 0;
  80238d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802394:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802395:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80239c:	00 
  80239d:	e9 73 01 00 00       	jmpq   802515 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  8023a2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023a9:	01 00 00 
  8023ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b4:	83 e0 01             	and    $0x1,%eax
  8023b7:	84 c0                	test   %al,%al
  8023b9:	0f 84 41 01 00 00    	je     802500 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8023bf:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8023c6:	00 
  8023c7:	e9 24 01 00 00       	jmpq   8024f0 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  8023cc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023d3:	01 00 00 
  8023d6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8023da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023de:	83 e0 01             	and    $0x1,%eax
  8023e1:	84 c0                	test   %al,%al
  8023e3:	0f 84 ed 00 00 00    	je     8024d6 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8023e9:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8023f0:	00 
  8023f1:	e9 d0 00 00 00       	jmpq   8024c6 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  8023f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023fd:	01 00 00 
  802400:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802404:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802408:	83 e0 01             	and    $0x1,%eax
  80240b:	84 c0                	test   %al,%al
  80240d:	0f 84 99 00 00 00    	je     8024ac <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802413:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80241a:	00 
  80241b:	eb 7f                	jmp    80249c <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  80241d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802424:	01 00 00 
  802427:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80242b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242f:	83 e0 01             	and    $0x1,%eax
  802432:	84 c0                	test   %al,%al
  802434:	74 5c                	je     802492 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  802436:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  80243d:	00 
  80243e:	74 52                	je     802492 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802440:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802444:	89 c2                	mov    %eax,%edx
  802446:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802449:	89 d6                	mov    %edx,%esi
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 67 20 80 00 00 	movabs $0x802067,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  80245c:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802460:	79 30                	jns    802492 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802462:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802465:	89 c1                	mov    %eax,%ecx
  802467:	48 ba 6b 4d 80 00 00 	movabs $0x804d6b,%rdx
  80246e:	00 00 00 
  802471:	be a0 00 00 00       	mov    $0xa0,%esi
  802476:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80247d:	00 00 00 
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
  802485:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  80248c:	00 00 00 
  80248f:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802492:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802497:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  80249c:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8024a3:	00 
  8024a4:	0f 86 73 ff ff ff    	jbe    80241d <fork+0x1bf>
  8024aa:	eb 10                	jmp    8024bc <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  8024ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8024b0:	48 83 c0 01          	add    $0x1,%rax
  8024b4:	48 c1 e0 09          	shl    $0x9,%rax
  8024b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8024bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8024c1:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8024c6:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8024cd:	00 
  8024ce:	0f 86 22 ff ff ff    	jbe    8023f6 <fork+0x198>
  8024d4:	eb 10                	jmp    8024e6 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8024d6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8024da:	48 83 c0 01          	add    $0x1,%rax
  8024de:	48 c1 e0 09          	shl    $0x9,%rax
  8024e2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8024e6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8024eb:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  8024f0:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8024f7:	00 
  8024f8:	0f 86 ce fe ff ff    	jbe    8023cc <fork+0x16e>
  8024fe:	eb 10                	jmp    802510 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802504:	48 83 c0 01          	add    $0x1,%rax
  802508:	48 c1 e0 09          	shl    $0x9,%rax
  80250c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802510:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802515:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80251a:	0f 84 82 fe ff ff    	je     8023a2 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802520:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802523:	48 be 44 43 80 00 00 	movabs $0x804344,%rsi
  80252a:	00 00 00 
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax
  80253b:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80253e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802542:	79 30                	jns    802574 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802544:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802547:	89 c1                	mov    %eax,%ecx
  802549:	48 ba 6b 4d 80 00 00 	movabs $0x804d6b,%rdx
  802550:	00 00 00 
  802553:	be bd 00 00 00       	mov    $0xbd,%esi
  802558:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80255f:	00 00 00 
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
  802567:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  80256e:	00 00 00 
  802571:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802574:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802577:	be 02 00 00 00       	mov    $0x2,%esi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80258d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802591:	79 30                	jns    8025c3 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802593:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802596:	89 c1                	mov    %eax,%ecx
  802598:	48 ba 6b 4d 80 00 00 	movabs $0x804d6b,%rdx
  80259f:	00 00 00 
  8025a2:	be c1 00 00 00       	mov    $0xc1,%esi
  8025a7:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8025ae:	00 00 00 
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8025bd:	00 00 00 
  8025c0:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  8025c3:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  8025c6:	48 83 c4 68          	add    $0x68,%rsp
  8025ca:	5b                   	pop    %rbx
  8025cb:	5d                   	pop    %rbp
  8025cc:	c3                   	retq   

00000000008025cd <sfork>:

// Challenge!
int
sfork(void)
{
  8025cd:	55                   	push   %rbp
  8025ce:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025d1:	48 ba 84 4d 80 00 00 	movabs $0x804d84,%rdx
  8025d8:	00 00 00 
  8025db:	be cc 00 00 00       	mov    $0xcc,%esi
  8025e0:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8025e7:	00 00 00 
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  8025f6:	00 00 00 
  8025f9:	ff d1                	callq  *%rcx
	...

00000000008025fc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025fc:	55                   	push   %rbp
  8025fd:	48 89 e5             	mov    %rsp,%rbp
  802600:	48 83 ec 08          	sub    $0x8,%rsp
  802604:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802608:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80260c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802613:	ff ff ff 
  802616:	48 01 d0             	add    %rdx,%rax
  802619:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 08          	sub    $0x8,%rsp
  802627:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80262b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80262f:	48 89 c7             	mov    %rax,%rdi
  802632:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802644:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802648:	c9                   	leaveq 
  802649:	c3                   	retq   

000000000080264a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80264a:	55                   	push   %rbp
  80264b:	48 89 e5             	mov    %rsp,%rbp
  80264e:	48 83 ec 18          	sub    $0x18,%rsp
  802652:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80265d:	eb 6b                	jmp    8026ca <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80265f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802662:	48 98                	cltq   
  802664:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80266a:	48 c1 e0 0c          	shl    $0xc,%rax
  80266e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	48 89 c2             	mov    %rax,%rdx
  802679:	48 c1 ea 15          	shr    $0x15,%rdx
  80267d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802684:	01 00 00 
  802687:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268b:	83 e0 01             	and    $0x1,%eax
  80268e:	48 85 c0             	test   %rax,%rax
  802691:	74 21                	je     8026b4 <fd_alloc+0x6a>
  802693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802697:	48 89 c2             	mov    %rax,%rdx
  80269a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80269e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026a5:	01 00 00 
  8026a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ac:	83 e0 01             	and    $0x1,%eax
  8026af:	48 85 c0             	test   %rax,%rax
  8026b2:	75 12                	jne    8026c6 <fd_alloc+0x7c>
			*fd_store = fd;
  8026b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026bc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c4:	eb 1a                	jmp    8026e0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ca:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026ce:	7e 8f                	jle    80265f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026db:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026e0:	c9                   	leaveq 
  8026e1:	c3                   	retq   

00000000008026e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026e2:	55                   	push   %rbp
  8026e3:	48 89 e5             	mov    %rsp,%rbp
  8026e6:	48 83 ec 20          	sub    $0x20,%rsp
  8026ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026f5:	78 06                	js     8026fd <fd_lookup+0x1b>
  8026f7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026fb:	7e 07                	jle    802704 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802702:	eb 6c                	jmp    802770 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802704:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802707:	48 98                	cltq   
  802709:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80270f:	48 c1 e0 0c          	shl    $0xc,%rax
  802713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271b:	48 89 c2             	mov    %rax,%rdx
  80271e:	48 c1 ea 15          	shr    $0x15,%rdx
  802722:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802729:	01 00 00 
  80272c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802730:	83 e0 01             	and    $0x1,%eax
  802733:	48 85 c0             	test   %rax,%rax
  802736:	74 21                	je     802759 <fd_lookup+0x77>
  802738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80273c:	48 89 c2             	mov    %rax,%rdx
  80273f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802743:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274a:	01 00 00 
  80274d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802751:	83 e0 01             	and    $0x1,%eax
  802754:	48 85 c0             	test   %rax,%rax
  802757:	75 07                	jne    802760 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80275e:	eb 10                	jmp    802770 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802760:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802764:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802768:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80276b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802770:	c9                   	leaveq 
  802771:	c3                   	retq   

0000000000802772 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802772:	55                   	push   %rbp
  802773:	48 89 e5             	mov    %rsp,%rbp
  802776:	48 83 ec 30          	sub    $0x30,%rsp
  80277a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80277e:	89 f0                	mov    %esi,%eax
  802780:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802787:	48 89 c7             	mov    %rax,%rdi
  80278a:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
  802796:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80279a:	48 89 d6             	mov    %rdx,%rsi
  80279d:	89 c7                	mov    %eax,%edi
  80279f:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
  8027ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b2:	78 0a                	js     8027be <fd_close+0x4c>
	    || fd != fd2)
  8027b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027bc:	74 12                	je     8027d0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027be:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027c2:	74 05                	je     8027c9 <fd_close+0x57>
  8027c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c7:	eb 05                	jmp    8027ce <fd_close+0x5c>
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ce:	eb 69                	jmp    802839 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d4:	8b 00                	mov    (%rax),%eax
  8027d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027da:	48 89 d6             	mov    %rdx,%rsi
  8027dd:	89 c7                	mov    %eax,%edi
  8027df:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
  8027eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f2:	78 2a                	js     80281e <fd_close+0xac>
		if (dev->dev_close)
  8027f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027fc:	48 85 c0             	test   %rax,%rax
  8027ff:	74 16                	je     802817 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802805:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280d:	48 89 c7             	mov    %rax,%rdi
  802810:	ff d2                	callq  *%rdx
  802812:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802815:	eb 07                	jmp    80281e <fd_close+0xac>
		else
			r = 0;
  802817:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80281e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802822:	48 89 c6             	mov    %rax,%rsi
  802825:	bf 00 00 00 00       	mov    $0x0,%edi
  80282a:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
	return r;
  802836:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 20          	sub    $0x20,%rsp
  802843:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802846:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80284a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802851:	eb 41                	jmp    802894 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802853:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80285a:	00 00 00 
  80285d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802860:	48 63 d2             	movslq %edx,%rdx
  802863:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802867:	8b 00                	mov    (%rax),%eax
  802869:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80286c:	75 22                	jne    802890 <dev_lookup+0x55>
			*dev = devtab[i];
  80286e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802875:	00 00 00 
  802878:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287b:	48 63 d2             	movslq %edx,%rdx
  80287e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802882:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802886:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
  80288e:	eb 60                	jmp    8028f0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802890:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802894:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80289b:	00 00 00 
  80289e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028a1:	48 63 d2             	movslq %edx,%rdx
  8028a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a8:	48 85 c0             	test   %rax,%rax
  8028ab:	75 a6                	jne    802853 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028b4:	00 00 00 
  8028b7:	48 8b 00             	mov    (%rax),%rax
  8028ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028c0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028c3:	89 c6                	mov    %eax,%esi
  8028c5:	48 bf a0 4d 80 00 00 	movabs $0x804da0,%rdi
  8028cc:	00 00 00 
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d4:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  8028db:	00 00 00 
  8028de:	ff d1                	callq  *%rcx
	*dev = 0;
  8028e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028f0:	c9                   	leaveq 
  8028f1:	c3                   	retq   

00000000008028f2 <close>:

int
close(int fdnum)
{
  8028f2:	55                   	push   %rbp
  8028f3:	48 89 e5             	mov    %rsp,%rbp
  8028f6:	48 83 ec 20          	sub    $0x20,%rsp
  8028fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802901:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802904:	48 89 d6             	mov    %rdx,%rsi
  802907:	89 c7                	mov    %eax,%edi
  802909:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
  802915:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291c:	79 05                	jns    802923 <close+0x31>
		return r;
  80291e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802921:	eb 18                	jmp    80293b <close+0x49>
	else
		return fd_close(fd, 1);
  802923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802927:	be 01 00 00 00       	mov    $0x1,%esi
  80292c:	48 89 c7             	mov    %rax,%rdi
  80292f:	48 b8 72 27 80 00 00 	movabs $0x802772,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
}
  80293b:	c9                   	leaveq 
  80293c:	c3                   	retq   

000000000080293d <close_all>:

void
close_all(void)
{
  80293d:	55                   	push   %rbp
  80293e:	48 89 e5             	mov    %rsp,%rbp
  802941:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802945:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80294c:	eb 15                	jmp    802963 <close_all+0x26>
		close(i);
  80294e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802951:	89 c7                	mov    %eax,%edi
  802953:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  80295a:	00 00 00 
  80295d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80295f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802963:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802967:	7e e5                	jle    80294e <close_all+0x11>
		close(i);
}
  802969:	c9                   	leaveq 
  80296a:	c3                   	retq   

000000000080296b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80296b:	55                   	push   %rbp
  80296c:	48 89 e5             	mov    %rsp,%rbp
  80296f:	48 83 ec 40          	sub    $0x40,%rsp
  802973:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802976:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802979:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80297d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802980:	48 89 d6             	mov    %rdx,%rsi
  802983:	89 c7                	mov    %eax,%edi
  802985:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	79 08                	jns    8029a2 <dup+0x37>
		return r;
  80299a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299d:	e9 70 01 00 00       	jmpq   802b12 <dup+0x1a7>
	close(newfdnum);
  8029a2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8029b3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029b6:	48 98                	cltq   
  8029b8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029be:	48 c1 e0 0c          	shl    $0xc,%rax
  8029c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ca:	48 89 c7             	mov    %rax,%rdi
  8029cd:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
  8029d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e1:	48 89 c7             	mov    %rax,%rdi
  8029e4:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	callq  *%rax
  8029f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f8:	48 89 c2             	mov    %rax,%rdx
  8029fb:	48 c1 ea 15          	shr    $0x15,%rdx
  8029ff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a06:	01 00 00 
  802a09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a0d:	83 e0 01             	and    $0x1,%eax
  802a10:	84 c0                	test   %al,%al
  802a12:	74 71                	je     802a85 <dup+0x11a>
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	48 89 c2             	mov    %rax,%rdx
  802a1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a26:	01 00 00 
  802a29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a2d:	83 e0 01             	and    $0x1,%eax
  802a30:	84 c0                	test   %al,%al
  802a32:	74 51                	je     802a85 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a38:	48 89 c2             	mov    %rax,%rdx
  802a3b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a46:	01 00 00 
  802a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a55:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5d:	41 89 c8             	mov    %ecx,%r8d
  802a60:	48 89 d1             	mov    %rdx,%rcx
  802a63:	ba 00 00 00 00       	mov    $0x0,%edx
  802a68:	48 89 c6             	mov    %rax,%rsi
  802a6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a70:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a83:	78 56                	js     802adb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a89:	48 89 c2             	mov    %rax,%rdx
  802a8c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a97:	01 00 00 
  802a9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9e:	89 c1                	mov    %eax,%ecx
  802aa0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802aa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aae:	41 89 c8             	mov    %ecx,%r8d
  802ab1:	48 89 d1             	mov    %rdx,%rcx
  802ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab9:	48 89 c6             	mov    %rax,%rsi
  802abc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac1:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	callq  *%rax
  802acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad4:	78 08                	js     802ade <dup+0x173>
		goto err;

	return newfdnum;
  802ad6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ad9:	eb 37                	jmp    802b12 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802adb:	90                   	nop
  802adc:	eb 01                	jmp    802adf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ade:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae3:	48 89 c6             	mov    %rax,%rsi
  802ae6:	bf 00 00 00 00       	mov    $0x0,%edi
  802aeb:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afb:	48 89 c6             	mov    %rax,%rsi
  802afe:	bf 00 00 00 00       	mov    $0x0,%edi
  802b03:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
	return r;
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b12:	c9                   	leaveq 
  802b13:	c3                   	retq   

0000000000802b14 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b14:	55                   	push   %rbp
  802b15:	48 89 e5             	mov    %rsp,%rbp
  802b18:	48 83 ec 40          	sub    $0x40,%rsp
  802b1c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b1f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b23:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b27:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b2b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b2e:	48 89 d6             	mov    %rdx,%rsi
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
  802b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b46:	78 24                	js     802b6c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4c:	8b 00                	mov    (%rax),%eax
  802b4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b52:	48 89 d6             	mov    %rdx,%rsi
  802b55:	89 c7                	mov    %eax,%edi
  802b57:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax
  802b63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6a:	79 05                	jns    802b71 <read+0x5d>
		return r;
  802b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6f:	eb 7a                	jmp    802beb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b75:	8b 40 08             	mov    0x8(%rax),%eax
  802b78:	83 e0 03             	and    $0x3,%eax
  802b7b:	83 f8 01             	cmp    $0x1,%eax
  802b7e:	75 3a                	jne    802bba <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b87:	00 00 00 
  802b8a:	48 8b 00             	mov    (%rax),%rax
  802b8d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b93:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b96:	89 c6                	mov    %eax,%esi
  802b98:	48 bf bf 4d 80 00 00 	movabs $0x804dbf,%rdi
  802b9f:	00 00 00 
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802bae:	00 00 00 
  802bb1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb8:	eb 31                	jmp    802beb <read+0xd7>
	}
	if (!dev->dev_read)
  802bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bc2:	48 85 c0             	test   %rax,%rax
  802bc5:	75 07                	jne    802bce <read+0xba>
		return -E_NOT_SUPP;
  802bc7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bcc:	eb 1d                	jmp    802beb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bda:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bde:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802be2:	48 89 ce             	mov    %rcx,%rsi
  802be5:	48 89 c7             	mov    %rax,%rdi
  802be8:	41 ff d0             	callq  *%r8
}
  802beb:	c9                   	leaveq 
  802bec:	c3                   	retq   

0000000000802bed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bed:	55                   	push   %rbp
  802bee:	48 89 e5             	mov    %rsp,%rbp
  802bf1:	48 83 ec 30          	sub    $0x30,%rsp
  802bf5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bf8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bfc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c07:	eb 46                	jmp    802c4f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0c:	48 98                	cltq   
  802c0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c12:	48 29 c2             	sub    %rax,%rdx
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	48 98                	cltq   
  802c1a:	48 89 c1             	mov    %rax,%rcx
  802c1d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802c21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c24:	48 89 ce             	mov    %rcx,%rsi
  802c27:	89 c7                	mov    %eax,%edi
  802c29:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c38:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c3c:	79 05                	jns    802c43 <readn+0x56>
			return m;
  802c3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c41:	eb 1d                	jmp    802c60 <readn+0x73>
		if (m == 0)
  802c43:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c47:	74 13                	je     802c5c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c52:	48 98                	cltq   
  802c54:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c58:	72 af                	jb     802c09 <readn+0x1c>
  802c5a:	eb 01                	jmp    802c5d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c5c:	90                   	nop
	}
	return tot;
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c60:	c9                   	leaveq 
  802c61:	c3                   	retq   

0000000000802c62 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c62:	55                   	push   %rbp
  802c63:	48 89 e5             	mov    %rsp,%rbp
  802c66:	48 83 ec 40          	sub    $0x40,%rsp
  802c6a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c71:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c75:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c7c:	48 89 d6             	mov    %rdx,%rsi
  802c7f:	89 c7                	mov    %eax,%edi
  802c81:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
  802c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c94:	78 24                	js     802cba <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	8b 00                	mov    (%rax),%eax
  802c9c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ca0:	48 89 d6             	mov    %rdx,%rsi
  802ca3:	89 c7                	mov    %eax,%edi
  802ca5:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
  802cb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb8:	79 05                	jns    802cbf <write+0x5d>
		return r;
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbd:	eb 79                	jmp    802d38 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc3:	8b 40 08             	mov    0x8(%rax),%eax
  802cc6:	83 e0 03             	and    $0x3,%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	75 3a                	jne    802d07 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ccd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802cd4:	00 00 00 
  802cd7:	48 8b 00             	mov    (%rax),%rax
  802cda:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ce3:	89 c6                	mov    %eax,%esi
  802ce5:	48 bf db 4d 80 00 00 	movabs $0x804ddb,%rdi
  802cec:	00 00 00 
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf4:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802cfb:	00 00 00 
  802cfe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d05:	eb 31                	jmp    802d38 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d0f:	48 85 c0             	test   %rax,%rax
  802d12:	75 07                	jne    802d1b <write+0xb9>
		return -E_NOT_SUPP;
  802d14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d19:	eb 1d                	jmp    802d38 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802d23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d2b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d2f:	48 89 ce             	mov    %rcx,%rsi
  802d32:	48 89 c7             	mov    %rax,%rdi
  802d35:	41 ff d0             	callq  *%r8
}
  802d38:	c9                   	leaveq 
  802d39:	c3                   	retq   

0000000000802d3a <seek>:

int
seek(int fdnum, off_t offset)
{
  802d3a:	55                   	push   %rbp
  802d3b:	48 89 e5             	mov    %rsp,%rbp
  802d3e:	48 83 ec 18          	sub    $0x18,%rsp
  802d42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d45:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d4f:	48 89 d6             	mov    %rdx,%rsi
  802d52:	89 c7                	mov    %eax,%edi
  802d54:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
  802d60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d67:	79 05                	jns    802d6e <seek+0x34>
		return r;
  802d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6c:	eb 0f                	jmp    802d7d <seek+0x43>
	fd->fd_offset = offset;
  802d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d72:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7d:	c9                   	leaveq 
  802d7e:	c3                   	retq   

0000000000802d7f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d7f:	55                   	push   %rbp
  802d80:	48 89 e5             	mov    %rsp,%rbp
  802d83:	48 83 ec 30          	sub    $0x30,%rsp
  802d87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d8a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d8d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d94:	48 89 d6             	mov    %rdx,%rsi
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
  802da5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dac:	78 24                	js     802dd2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db2:	8b 00                	mov    (%rax),%eax
  802db4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802db8:	48 89 d6             	mov    %rdx,%rsi
  802dbb:	89 c7                	mov    %eax,%edi
  802dbd:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802dc4:	00 00 00 
  802dc7:	ff d0                	callq  *%rax
  802dc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd0:	79 05                	jns    802dd7 <ftruncate+0x58>
		return r;
  802dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd5:	eb 72                	jmp    802e49 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddb:	8b 40 08             	mov    0x8(%rax),%eax
  802dde:	83 e0 03             	and    $0x3,%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	75 3a                	jne    802e1f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802de5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802dec:	00 00 00 
  802def:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802df2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802df8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dfb:	89 c6                	mov    %eax,%esi
  802dfd:	48 bf f8 4d 80 00 00 	movabs $0x804df8,%rdi
  802e04:	00 00 00 
  802e07:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0c:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802e13:	00 00 00 
  802e16:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e1d:	eb 2a                	jmp    802e49 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e23:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e27:	48 85 c0             	test   %rax,%rax
  802e2a:	75 07                	jne    802e33 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e31:	eb 16                	jmp    802e49 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e37:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e42:	89 d6                	mov    %edx,%esi
  802e44:	48 89 c7             	mov    %rax,%rdi
  802e47:	ff d1                	callq  *%rcx
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 30          	sub    $0x30,%rsp
  802e53:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e56:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e5a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e61:	48 89 d6             	mov    %rdx,%rsi
  802e64:	89 c7                	mov    %eax,%edi
  802e66:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e79:	78 24                	js     802e9f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7f:	8b 00                	mov    (%rax),%eax
  802e81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e85:	48 89 d6             	mov    %rdx,%rsi
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
  802e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9d:	79 05                	jns    802ea4 <fstat+0x59>
		return r;
  802e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea2:	eb 5e                	jmp    802f02 <fstat+0xb7>
	if (!dev->dev_stat)
  802ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802eac:	48 85 c0             	test   %rax,%rax
  802eaf:	75 07                	jne    802eb8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802eb1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb6:	eb 4a                	jmp    802f02 <fstat+0xb7>
	stat->st_name[0] = 0;
  802eb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ebc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ebf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802eca:	00 00 00 
	stat->st_isdir = 0;
  802ecd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ed8:	00 00 00 
	stat->st_dev = dev;
  802edb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802edf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ee3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eee:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802efa:	48 89 d6             	mov    %rdx,%rsi
  802efd:	48 89 c7             	mov    %rax,%rdi
  802f00:	ff d1                	callq  *%rcx
}
  802f02:	c9                   	leaveq 
  802f03:	c3                   	retq   

0000000000802f04 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 83 ec 20          	sub    $0x20,%rsp
  802f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	be 00 00 00 00       	mov    $0x0,%esi
  802f1d:	48 89 c7             	mov    %rax,%rdi
  802f20:	48 b8 f3 2f 80 00 00 	movabs $0x802ff3,%rax
  802f27:	00 00 00 
  802f2a:	ff d0                	callq  *%rax
  802f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f33:	79 05                	jns    802f3a <stat+0x36>
		return fd;
  802f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f38:	eb 2f                	jmp    802f69 <stat+0x65>
	r = fstat(fd, stat);
  802f3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f41:	48 89 d6             	mov    %rdx,%rsi
  802f44:	89 c7                	mov    %eax,%edi
  802f46:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
  802f52:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	89 c7                	mov    %eax,%edi
  802f5a:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  802f61:	00 00 00 
  802f64:	ff d0                	callq  *%rax
	return r;
  802f66:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   
	...

0000000000802f6c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f6c:	55                   	push   %rbp
  802f6d:	48 89 e5             	mov    %rsp,%rbp
  802f70:	48 83 ec 10          	sub    $0x10,%rsp
  802f74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f7b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f82:	00 00 00 
  802f85:	8b 00                	mov    (%rax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	75 1d                	jne    802fa8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f8b:	bf 01 00 00 00       	mov    $0x1,%edi
  802f90:	48 b8 5e 45 80 00 00 	movabs $0x80455e,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802fa3:	00 00 00 
  802fa6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fa8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802faf:	00 00 00 
  802fb2:	8b 00                	mov    (%rax),%eax
  802fb4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fb7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fbc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802fc3:	00 00 00 
  802fc6:	89 c7                	mov    %eax,%edi
  802fc8:	48 b8 af 44 80 00 00 	movabs $0x8044af,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdd:	48 89 c6             	mov    %rax,%rsi
  802fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe5:	48 b8 c8 43 80 00 00 	movabs $0x8043c8,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
}
  802ff1:	c9                   	leaveq 
  802ff2:	c3                   	retq   

0000000000802ff3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802ff3:	55                   	push   %rbp
  802ff4:	48 89 e5             	mov    %rsp,%rbp
  802ff7:	48 83 ec 20          	sub    $0x20,%rsp
  802ffb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  803002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803006:	48 89 c7             	mov    %rax,%rdi
  803009:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
  803015:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80301a:	7e 0a                	jle    803026 <open+0x33>
		return -E_BAD_PATH;
  80301c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803021:	e9 a5 00 00 00       	jmpq   8030cb <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  803026:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80302a:	48 89 c7             	mov    %rax,%rdi
  80302d:	48 b8 4a 26 80 00 00 	movabs $0x80264a,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
  803039:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80303c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803040:	79 08                	jns    80304a <open+0x57>
		return r;
  803042:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803045:	e9 81 00 00 00       	jmpq   8030cb <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80304a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803051:	00 00 00 
  803054:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803057:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80305d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803061:	48 89 c6             	mov    %rax,%rsi
  803064:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80306b:	00 00 00 
  80306e:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80307a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307e:	48 89 c6             	mov    %rax,%rsi
  803081:	bf 01 00 00 00       	mov    $0x1,%edi
  803086:	48 b8 6c 2f 80 00 00 	movabs $0x802f6c,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
  803092:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803099:	79 1d                	jns    8030b8 <open+0xc5>
		fd_close(new_fd, 0);
  80309b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309f:	be 00 00 00 00       	mov    $0x0,%esi
  8030a4:	48 89 c7             	mov    %rax,%rdi
  8030a7:	48 b8 72 27 80 00 00 	movabs $0x802772,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
		return r;	
  8030b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b6:	eb 13                	jmp    8030cb <open+0xd8>
	}
	return fd2num(new_fd);
  8030b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bc:	48 89 c7             	mov    %rax,%rdi
  8030bf:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  8030c6:	00 00 00 
  8030c9:	ff d0                	callq  *%rax
}
  8030cb:	c9                   	leaveq 
  8030cc:	c3                   	retq   

00000000008030cd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030cd:	55                   	push   %rbp
  8030ce:	48 89 e5             	mov    %rsp,%rbp
  8030d1:	48 83 ec 10          	sub    $0x10,%rsp
  8030d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030dd:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e7:	00 00 00 
  8030ea:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030ec:	be 00 00 00 00       	mov    $0x0,%esi
  8030f1:	bf 06 00 00 00       	mov    $0x6,%edi
  8030f6:	48 b8 6c 2f 80 00 00 	movabs $0x802f6c,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
}
  803102:	c9                   	leaveq 
  803103:	c3                   	retq   

0000000000803104 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803104:	55                   	push   %rbp
  803105:	48 89 e5             	mov    %rsp,%rbp
  803108:	48 83 ec 30          	sub    $0x30,%rsp
  80310c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803110:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803114:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  803118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311c:	8b 50 0c             	mov    0xc(%rax),%edx
  80311f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803126:	00 00 00 
  803129:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80312b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803132:	00 00 00 
  803135:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803139:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  80313d:	be 00 00 00 00       	mov    $0x0,%esi
  803142:	bf 03 00 00 00       	mov    $0x3,%edi
  803147:	48 b8 6c 2f 80 00 00 	movabs $0x802f6c,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
  803153:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  803156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315a:	7e 23                	jle    80317f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80315c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315f:	48 63 d0             	movslq %eax,%rdx
  803162:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803166:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80316d:	00 00 00 
  803170:	48 89 c7             	mov    %rax,%rdi
  803173:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  80317a:	00 00 00 
  80317d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80317f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803182:	c9                   	leaveq 
  803183:	c3                   	retq   

0000000000803184 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803184:	55                   	push   %rbp
  803185:	48 89 e5             	mov    %rsp,%rbp
  803188:	48 83 ec 20          	sub    $0x20,%rsp
  80318c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803198:	8b 50 0c             	mov    0xc(%rax),%edx
  80319b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031a2:	00 00 00 
  8031a5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031a7:	be 00 00 00 00       	mov    $0x0,%esi
  8031ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8031b1:	48 b8 6c 2f 80 00 00 	movabs $0x802f6c,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
  8031bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c4:	79 05                	jns    8031cb <devfile_stat+0x47>
		return r;
  8031c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c9:	eb 56                	jmp    803221 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031d6:	00 00 00 
  8031d9:	48 89 c7             	mov    %rax,%rdi
  8031dc:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031e8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ef:	00 00 00 
  8031f2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031fc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803202:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803209:	00 00 00 
  80320c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803212:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803216:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803221:	c9                   	leaveq 
  803222:	c3                   	retq   
	...

0000000000803224 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803224:	55                   	push   %rbp
  803225:	48 89 e5             	mov    %rsp,%rbp
  803228:	48 83 ec 20          	sub    $0x20,%rsp
  80322c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80322f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803236:	48 89 d6             	mov    %rdx,%rsi
  803239:	89 c7                	mov    %eax,%edi
  80323b:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
  803247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324e:	79 05                	jns    803255 <fd2sockid+0x31>
		return r;
  803250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803253:	eb 24                	jmp    803279 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803259:	8b 10                	mov    (%rax),%edx
  80325b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803262:	00 00 00 
  803265:	8b 00                	mov    (%rax),%eax
  803267:	39 c2                	cmp    %eax,%edx
  803269:	74 07                	je     803272 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80326b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803270:	eb 07                	jmp    803279 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803276:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803279:	c9                   	leaveq 
  80327a:	c3                   	retq   

000000000080327b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80327b:	55                   	push   %rbp
  80327c:	48 89 e5             	mov    %rsp,%rbp
  80327f:	48 83 ec 20          	sub    $0x20,%rsp
  803283:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803286:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80328a:	48 89 c7             	mov    %rax,%rdi
  80328d:	48 b8 4a 26 80 00 00 	movabs $0x80264a,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
  803299:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80329c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a0:	78 26                	js     8032c8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8032ab:	48 89 c6             	mov    %rax,%rsi
  8032ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b3:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8032ba:	00 00 00 
  8032bd:	ff d0                	callq  *%rax
  8032bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c6:	79 16                	jns    8032de <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032cb:	89 c7                	mov    %eax,%edi
  8032cd:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	callq  *%rax
		return r;
  8032d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dc:	eb 3a                	jmp    803318 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032e9:	00 00 00 
  8032ec:	8b 12                	mov    (%rdx),%edx
  8032ee:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803302:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803309:	48 89 c7             	mov    %rax,%rdi
  80330c:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
}
  803318:	c9                   	leaveq 
  803319:	c3                   	retq   

000000000080331a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80331a:	55                   	push   %rbp
  80331b:	48 89 e5             	mov    %rsp,%rbp
  80331e:	48 83 ec 30          	sub    $0x30,%rsp
  803322:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803329:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80332d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803330:	89 c7                	mov    %eax,%edi
  803332:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
  80333e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803341:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803345:	79 05                	jns    80334c <accept+0x32>
		return r;
  803347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334a:	eb 3b                	jmp    803387 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80334c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803350:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803357:	48 89 ce             	mov    %rcx,%rsi
  80335a:	89 c7                	mov    %eax,%edi
  80335c:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  803363:	00 00 00 
  803366:	ff d0                	callq  *%rax
  803368:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336f:	79 05                	jns    803376 <accept+0x5c>
		return r;
  803371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803374:	eb 11                	jmp    803387 <accept+0x6d>
	return alloc_sockfd(r);
  803376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 7b 32 80 00 00 	movabs $0x80327b,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 20          	sub    $0x20,%rsp
  803391:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803394:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803398:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80339b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80339e:	89 c7                	mov    %eax,%edi
  8033a0:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b3:	79 05                	jns    8033ba <bind+0x31>
		return r;
  8033b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b8:	eb 1b                	jmp    8033d5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c4:	48 89 ce             	mov    %rcx,%rsi
  8033c7:	89 c7                	mov    %eax,%edi
  8033c9:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
}
  8033d5:	c9                   	leaveq 
  8033d6:	c3                   	retq   

00000000008033d7 <shutdown>:

int
shutdown(int s, int how)
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	48 83 ec 20          	sub    $0x20,%rsp
  8033df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e8:	89 c7                	mov    %eax,%edi
  8033ea:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
  8033f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fd:	79 05                	jns    803404 <shutdown+0x2d>
		return r;
  8033ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803402:	eb 16                	jmp    80341a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803404:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340a:	89 d6                	mov    %edx,%esi
  80340c:	89 c7                	mov    %eax,%edi
  80340e:	48 b8 48 37 80 00 00 	movabs $0x803748,%rax
  803415:	00 00 00 
  803418:	ff d0                	callq  *%rax
}
  80341a:	c9                   	leaveq 
  80341b:	c3                   	retq   

000000000080341c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80341c:	55                   	push   %rbp
  80341d:	48 89 e5             	mov    %rsp,%rbp
  803420:	48 83 ec 10          	sub    $0x10,%rsp
  803424:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342c:	48 89 c7             	mov    %rax,%rdi
  80342f:	48 b8 ec 45 80 00 00 	movabs $0x8045ec,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
  80343b:	83 f8 01             	cmp    $0x1,%eax
  80343e:	75 17                	jne    803457 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803444:	8b 40 0c             	mov    0xc(%rax),%eax
  803447:	89 c7                	mov    %eax,%edi
  803449:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
  803455:	eb 05                	jmp    80345c <devsock_close+0x40>
	else
		return 0;
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 20          	sub    $0x20,%rsp
  803466:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803469:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80346d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803470:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803488:	79 05                	jns    80348f <connect+0x31>
		return r;
  80348a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348d:	eb 1b                	jmp    8034aa <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80348f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803492:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803499:	48 89 ce             	mov    %rcx,%rsi
  80349c:	89 c7                	mov    %eax,%edi
  80349e:	48 b8 b5 37 80 00 00 	movabs $0x8037b5,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
}
  8034aa:	c9                   	leaveq 
  8034ab:	c3                   	retq   

00000000008034ac <listen>:

int
listen(int s, int backlog)
{
  8034ac:	55                   	push   %rbp
  8034ad:	48 89 e5             	mov    %rsp,%rbp
  8034b0:	48 83 ec 20          	sub    $0x20,%rsp
  8034b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034b7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034bd:	89 c7                	mov    %eax,%edi
  8034bf:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
  8034cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d2:	79 05                	jns    8034d9 <listen+0x2d>
		return r;
  8034d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d7:	eb 16                	jmp    8034ef <listen+0x43>
	return nsipc_listen(r, backlog);
  8034d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034df:	89 d6                	mov    %edx,%esi
  8034e1:	89 c7                	mov    %eax,%edi
  8034e3:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
}
  8034ef:	c9                   	leaveq 
  8034f0:	c3                   	retq   

00000000008034f1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034f1:	55                   	push   %rbp
  8034f2:	48 89 e5             	mov    %rsp,%rbp
  8034f5:	48 83 ec 20          	sub    $0x20,%rsp
  8034f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803501:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803509:	89 c2                	mov    %eax,%edx
  80350b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350f:	8b 40 0c             	mov    0xc(%rax),%eax
  803512:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803516:	b9 00 00 00 00       	mov    $0x0,%ecx
  80351b:	89 c7                	mov    %eax,%edi
  80351d:	48 b8 59 38 80 00 00 	movabs $0x803859,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
}
  803529:	c9                   	leaveq 
  80352a:	c3                   	retq   

000000000080352b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80352b:	55                   	push   %rbp
  80352c:	48 89 e5             	mov    %rsp,%rbp
  80352f:	48 83 ec 20          	sub    $0x20,%rsp
  803533:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803537:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80353b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80353f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803543:	89 c2                	mov    %eax,%edx
  803545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803549:	8b 40 0c             	mov    0xc(%rax),%eax
  80354c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803550:	b9 00 00 00 00       	mov    $0x0,%ecx
  803555:	89 c7                	mov    %eax,%edi
  803557:	48 b8 25 39 80 00 00 	movabs $0x803925,%rax
  80355e:	00 00 00 
  803561:	ff d0                	callq  *%rax
}
  803563:	c9                   	leaveq 
  803564:	c3                   	retq   

0000000000803565 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803565:	55                   	push   %rbp
  803566:	48 89 e5             	mov    %rsp,%rbp
  803569:	48 83 ec 10          	sub    $0x10,%rsp
  80356d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803571:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803579:	48 be 23 4e 80 00 00 	movabs $0x804e23,%rsi
  803580:	00 00 00 
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
	return 0;
  803592:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803597:	c9                   	leaveq 
  803598:	c3                   	retq   

0000000000803599 <socket>:

int
socket(int domain, int type, int protocol)
{
  803599:	55                   	push   %rbp
  80359a:	48 89 e5             	mov    %rsp,%rbp
  80359d:	48 83 ec 20          	sub    $0x20,%rsp
  8035a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035a7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035aa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035ad:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b3:	89 ce                	mov    %ecx,%esi
  8035b5:	89 c7                	mov    %eax,%edi
  8035b7:	48 b8 dd 39 80 00 00 	movabs $0x8039dd,%rax
  8035be:	00 00 00 
  8035c1:	ff d0                	callq  *%rax
  8035c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ca:	79 05                	jns    8035d1 <socket+0x38>
		return r;
  8035cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cf:	eb 11                	jmp    8035e2 <socket+0x49>
	return alloc_sockfd(r);
  8035d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d4:	89 c7                	mov    %eax,%edi
  8035d6:	48 b8 7b 32 80 00 00 	movabs $0x80327b,%rax
  8035dd:	00 00 00 
  8035e0:	ff d0                	callq  *%rax
}
  8035e2:	c9                   	leaveq 
  8035e3:	c3                   	retq   

00000000008035e4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035e4:	55                   	push   %rbp
  8035e5:	48 89 e5             	mov    %rsp,%rbp
  8035e8:	48 83 ec 10          	sub    $0x10,%rsp
  8035ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035ef:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035f6:	00 00 00 
  8035f9:	8b 00                	mov    (%rax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	75 1d                	jne    80361c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035ff:	bf 02 00 00 00       	mov    $0x2,%edi
  803604:	48 b8 5e 45 80 00 00 	movabs $0x80455e,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803617:	00 00 00 
  80361a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80361c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803623:	00 00 00 
  803626:	8b 00                	mov    (%rax),%eax
  803628:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80362b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803630:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803637:	00 00 00 
  80363a:	89 c7                	mov    %eax,%edi
  80363c:	48 b8 af 44 80 00 00 	movabs $0x8044af,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803648:	ba 00 00 00 00       	mov    $0x0,%edx
  80364d:	be 00 00 00 00       	mov    $0x0,%esi
  803652:	bf 00 00 00 00       	mov    $0x0,%edi
  803657:	48 b8 c8 43 80 00 00 	movabs $0x8043c8,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
}
  803663:	c9                   	leaveq 
  803664:	c3                   	retq   

0000000000803665 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803665:	55                   	push   %rbp
  803666:	48 89 e5             	mov    %rsp,%rbp
  803669:	48 83 ec 30          	sub    $0x30,%rsp
  80366d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803670:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803674:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803678:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80367f:	00 00 00 
  803682:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803685:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803687:	bf 01 00 00 00       	mov    $0x1,%edi
  80368c:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
  803698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369f:	78 3e                	js     8036df <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8036a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036a8:	00 00 00 
  8036ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b3:	8b 40 10             	mov    0x10(%rax),%eax
  8036b6:	89 c2                	mov    %eax,%edx
  8036b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c0:	48 89 ce             	mov    %rcx,%rsi
  8036c3:	48 89 c7             	mov    %rax,%rdi
  8036c6:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d6:	8b 50 10             	mov    0x10(%rax),%edx
  8036d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036dd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036e2:	c9                   	leaveq 
  8036e3:	c3                   	retq   

00000000008036e4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036e4:	55                   	push   %rbp
  8036e5:	48 89 e5             	mov    %rsp,%rbp
  8036e8:	48 83 ec 10          	sub    $0x10,%rsp
  8036ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fd:	00 00 00 
  803700:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803703:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803705:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370c:	48 89 c6             	mov    %rax,%rsi
  80370f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803716:	00 00 00 
  803719:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803725:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372c:	00 00 00 
  80372f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803732:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803735:	bf 02 00 00 00       	mov    $0x2,%edi
  80373a:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
}
  803746:	c9                   	leaveq 
  803747:	c3                   	retq   

0000000000803748 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803748:	55                   	push   %rbp
  803749:	48 89 e5             	mov    %rsp,%rbp
  80374c:	48 83 ec 10          	sub    $0x10,%rsp
  803750:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803753:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803756:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80375d:	00 00 00 
  803760:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803763:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803765:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376c:	00 00 00 
  80376f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803772:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803775:	bf 03 00 00 00       	mov    $0x3,%edi
  80377a:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
}
  803786:	c9                   	leaveq 
  803787:	c3                   	retq   

0000000000803788 <nsipc_close>:

int
nsipc_close(int s)
{
  803788:	55                   	push   %rbp
  803789:	48 89 e5             	mov    %rsp,%rbp
  80378c:	48 83 ec 10          	sub    $0x10,%rsp
  803790:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803793:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379a:	00 00 00 
  80379d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8037a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8037a7:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	callq  *%rax
}
  8037b3:	c9                   	leaveq 
  8037b4:	c3                   	retq   

00000000008037b5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037b5:	55                   	push   %rbp
  8037b6:	48 89 e5             	mov    %rsp,%rbp
  8037b9:	48 83 ec 10          	sub    $0x10,%rsp
  8037bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ce:	00 00 00 
  8037d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037d4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037dd:	48 89 c6             	mov    %rax,%rsi
  8037e0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037e7:	00 00 00 
  8037ea:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fd:	00 00 00 
  803800:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803803:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803806:	bf 05 00 00 00       	mov    $0x5,%edi
  80380b:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	48 83 ec 10          	sub    $0x10,%rsp
  803821:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803824:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803827:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382e:	00 00 00 
  803831:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803834:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803836:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80383d:	00 00 00 
  803840:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803843:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803846:	bf 06 00 00 00       	mov    $0x6,%edi
  80384b:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
}
  803857:	c9                   	leaveq 
  803858:	c3                   	retq   

0000000000803859 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803859:	55                   	push   %rbp
  80385a:	48 89 e5             	mov    %rsp,%rbp
  80385d:	48 83 ec 30          	sub    $0x30,%rsp
  803861:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803864:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803868:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80386b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80386e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803875:	00 00 00 
  803878:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80387b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80387d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803884:	00 00 00 
  803887:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80388a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80388d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803894:	00 00 00 
  803897:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80389a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80389d:	bf 07 00 00 00       	mov    $0x7,%edi
  8038a2:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
  8038ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b5:	78 69                	js     803920 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038b7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038be:	7f 08                	jg     8038c8 <nsipc_recv+0x6f>
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038c6:	7e 35                	jle    8038fd <nsipc_recv+0xa4>
  8038c8:	48 b9 2a 4e 80 00 00 	movabs $0x804e2a,%rcx
  8038cf:	00 00 00 
  8038d2:	48 ba 3f 4e 80 00 00 	movabs $0x804e3f,%rdx
  8038d9:	00 00 00 
  8038dc:	be 61 00 00 00       	mov    $0x61,%esi
  8038e1:	48 bf 54 4e 80 00 00 	movabs $0x804e54,%rdi
  8038e8:	00 00 00 
  8038eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f0:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8038f7:	00 00 00 
  8038fa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803900:	48 63 d0             	movslq %eax,%rdx
  803903:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803907:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80390e:	00 00 00 
  803911:	48 89 c7             	mov    %rax,%rdi
  803914:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
	}

	return r;
  803920:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803923:	c9                   	leaveq 
  803924:	c3                   	retq   

0000000000803925 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803925:	55                   	push   %rbp
  803926:	48 89 e5             	mov    %rsp,%rbp
  803929:	48 83 ec 20          	sub    $0x20,%rsp
  80392d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803930:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803934:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803937:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80393a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803941:	00 00 00 
  803944:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803947:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803949:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803950:	7e 35                	jle    803987 <nsipc_send+0x62>
  803952:	48 b9 60 4e 80 00 00 	movabs $0x804e60,%rcx
  803959:	00 00 00 
  80395c:	48 ba 3f 4e 80 00 00 	movabs $0x804e3f,%rdx
  803963:	00 00 00 
  803966:	be 6c 00 00 00       	mov    $0x6c,%esi
  80396b:	48 bf 54 4e 80 00 00 	movabs $0x804e54,%rdi
  803972:	00 00 00 
  803975:	b8 00 00 00 00       	mov    $0x0,%eax
  80397a:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  803981:	00 00 00 
  803984:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803987:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80398a:	48 63 d0             	movslq %eax,%rdx
  80398d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803991:	48 89 c6             	mov    %rax,%rsi
  803994:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80399b:	00 00 00 
  80399e:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b1:	00 00 00 
  8039b4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039b7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c1:	00 00 00 
  8039c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039c7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039ca:	bf 08 00 00 00       	mov    $0x8,%edi
  8039cf:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
}
  8039db:	c9                   	leaveq 
  8039dc:	c3                   	retq   

00000000008039dd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039dd:	55                   	push   %rbp
  8039de:	48 89 e5             	mov    %rsp,%rbp
  8039e1:	48 83 ec 10          	sub    $0x10,%rsp
  8039e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039eb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039f5:	00 00 00 
  8039f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039fb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a04:	00 00 00 
  803a07:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a0a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a14:	00 00 00 
  803a17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a1a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a1d:	bf 09 00 00 00       	mov    $0x9,%edi
  803a22:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
}
  803a2e:	c9                   	leaveq 
  803a2f:	c3                   	retq   

0000000000803a30 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a30:	55                   	push   %rbp
  803a31:	48 89 e5             	mov    %rsp,%rbp
  803a34:	53                   	push   %rbx
  803a35:	48 83 ec 38          	sub    $0x38,%rsp
  803a39:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a3d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a41:	48 89 c7             	mov    %rax,%rdi
  803a44:	48 b8 4a 26 80 00 00 	movabs $0x80264a,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
  803a50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a57:	0f 88 bf 01 00 00    	js     803c1c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a61:	ba 07 04 00 00       	mov    $0x407,%edx
  803a66:	48 89 c6             	mov    %rax,%rsi
  803a69:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6e:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803a75:	00 00 00 
  803a78:	ff d0                	callq  *%rax
  803a7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a81:	0f 88 95 01 00 00    	js     803c1c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a87:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a8b:	48 89 c7             	mov    %rax,%rdi
  803a8e:	48 b8 4a 26 80 00 00 	movabs $0x80264a,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
  803a9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aa1:	0f 88 5d 01 00 00    	js     803c04 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aa7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aab:	ba 07 04 00 00       	mov    $0x407,%edx
  803ab0:	48 89 c6             	mov    %rax,%rsi
  803ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab8:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
  803ac4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803acb:	0f 88 33 01 00 00    	js     803c04 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ad1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad5:	48 89 c7             	mov    %rax,%rdi
  803ad8:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803adf:	00 00 00 
  803ae2:	ff d0                	callq  *%rax
  803ae4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aec:	ba 07 04 00 00       	mov    $0x407,%edx
  803af1:	48 89 c6             	mov    %rax,%rsi
  803af4:	bf 00 00 00 00       	mov    $0x0,%edi
  803af9:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
  803b05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b0c:	0f 88 d9 00 00 00    	js     803beb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b16:	48 89 c7             	mov    %rax,%rdi
  803b19:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803b20:	00 00 00 
  803b23:	ff d0                	callq  *%rax
  803b25:	48 89 c2             	mov    %rax,%rdx
  803b28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b32:	48 89 d1             	mov    %rdx,%rcx
  803b35:	ba 00 00 00 00       	mov    $0x0,%edx
  803b3a:	48 89 c6             	mov    %rax,%rsi
  803b3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b42:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
  803b4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b55:	78 79                	js     803bd0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b5b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b62:	00 00 00 
  803b65:	8b 12                	mov    (%rdx),%edx
  803b67:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b78:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b7f:	00 00 00 
  803b82:	8b 12                	mov    (%rdx),%edx
  803b84:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b8a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b95:	48 89 c7             	mov    %rax,%rdi
  803b98:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  803b9f:	00 00 00 
  803ba2:	ff d0                	callq  *%rax
  803ba4:	89 c2                	mov    %eax,%edx
  803ba6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803baa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bb0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb8:	48 89 c7             	mov    %rax,%rdi
  803bbb:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  803bc2:	00 00 00 
  803bc5:	ff d0                	callq  *%rax
  803bc7:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	eb 4f                	jmp    803c1f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803bd0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803bd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd5:	48 89 c6             	mov    %rax,%rsi
  803bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdd:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	eb 01                	jmp    803bec <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803beb:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803bec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf0:	48 89 c6             	mov    %rax,%rsi
  803bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf8:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803bff:	00 00 00 
  803c02:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c08:	48 89 c6             	mov    %rax,%rsi
  803c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c10:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803c17:	00 00 00 
  803c1a:	ff d0                	callq  *%rax
err:
	return r;
  803c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c1f:	48 83 c4 38          	add    $0x38,%rsp
  803c23:	5b                   	pop    %rbx
  803c24:	5d                   	pop    %rbp
  803c25:	c3                   	retq   

0000000000803c26 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c26:	55                   	push   %rbp
  803c27:	48 89 e5             	mov    %rsp,%rbp
  803c2a:	53                   	push   %rbx
  803c2b:	48 83 ec 28          	sub    $0x28,%rsp
  803c2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c37:	eb 01                	jmp    803c3a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c39:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c3a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c41:	00 00 00 
  803c44:	48 8b 00             	mov    (%rax),%rax
  803c47:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c54:	48 89 c7             	mov    %rax,%rdi
  803c57:	48 b8 ec 45 80 00 00 	movabs $0x8045ec,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
  803c63:	89 c3                	mov    %eax,%ebx
  803c65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c69:	48 89 c7             	mov    %rax,%rdi
  803c6c:	48 b8 ec 45 80 00 00 	movabs $0x8045ec,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
  803c78:	39 c3                	cmp    %eax,%ebx
  803c7a:	0f 94 c0             	sete   %al
  803c7d:	0f b6 c0             	movzbl %al,%eax
  803c80:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c83:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c8a:	00 00 00 
  803c8d:	48 8b 00             	mov    (%rax),%rax
  803c90:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c96:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c9c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c9f:	75 0a                	jne    803cab <_pipeisclosed+0x85>
			return ret;
  803ca1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803ca4:	48 83 c4 28          	add    $0x28,%rsp
  803ca8:	5b                   	pop    %rbx
  803ca9:	5d                   	pop    %rbp
  803caa:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803cab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cae:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cb1:	74 86                	je     803c39 <_pipeisclosed+0x13>
  803cb3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cb7:	75 80                	jne    803c39 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cb9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cc0:	00 00 00 
  803cc3:	48 8b 00             	mov    (%rax),%rax
  803cc6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ccc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd2:	89 c6                	mov    %eax,%esi
  803cd4:	48 bf 71 4e 80 00 00 	movabs $0x804e71,%rdi
  803cdb:	00 00 00 
  803cde:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce3:	49 b8 3f 06 80 00 00 	movabs $0x80063f,%r8
  803cea:	00 00 00 
  803ced:	41 ff d0             	callq  *%r8
	}
  803cf0:	e9 44 ff ff ff       	jmpq   803c39 <_pipeisclosed+0x13>

0000000000803cf5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803cf5:	55                   	push   %rbp
  803cf6:	48 89 e5             	mov    %rsp,%rbp
  803cf9:	48 83 ec 30          	sub    $0x30,%rsp
  803cfd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d00:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d04:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d07:	48 89 d6             	mov    %rdx,%rsi
  803d0a:	89 c7                	mov    %eax,%edi
  803d0c:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  803d13:	00 00 00 
  803d16:	ff d0                	callq  *%rax
  803d18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1f:	79 05                	jns    803d26 <pipeisclosed+0x31>
		return r;
  803d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d24:	eb 31                	jmp    803d57 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2a:	48 89 c7             	mov    %rax,%rdi
  803d2d:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803d34:	00 00 00 
  803d37:	ff d0                	callq  *%rax
  803d39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d45:	48 89 d6             	mov    %rdx,%rsi
  803d48:	48 89 c7             	mov    %rax,%rdi
  803d4b:	48 b8 26 3c 80 00 00 	movabs $0x803c26,%rax
  803d52:	00 00 00 
  803d55:	ff d0                	callq  *%rax
}
  803d57:	c9                   	leaveq 
  803d58:	c3                   	retq   

0000000000803d59 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d59:	55                   	push   %rbp
  803d5a:	48 89 e5             	mov    %rsp,%rbp
  803d5d:	48 83 ec 40          	sub    $0x40,%rsp
  803d61:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d71:	48 89 c7             	mov    %rax,%rdi
  803d74:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
  803d80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d8c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d93:	00 
  803d94:	e9 97 00 00 00       	jmpq   803e30 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d99:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d9e:	74 09                	je     803da9 <devpipe_read+0x50>
				return i;
  803da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da4:	e9 95 00 00 00       	jmpq   803e3e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803db1:	48 89 d6             	mov    %rdx,%rsi
  803db4:	48 89 c7             	mov    %rax,%rdi
  803db7:	48 b8 26 3c 80 00 00 	movabs $0x803c26,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
  803dc3:	85 c0                	test   %eax,%eax
  803dc5:	74 07                	je     803dce <devpipe_read+0x75>
				return 0;
  803dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803dcc:	eb 70                	jmp    803e3e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803dce:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803dd5:	00 00 00 
  803dd8:	ff d0                	callq  *%rax
  803dda:	eb 01                	jmp    803ddd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ddc:	90                   	nop
  803ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de1:	8b 10                	mov    (%rax),%edx
  803de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de7:	8b 40 04             	mov    0x4(%rax),%eax
  803dea:	39 c2                	cmp    %eax,%edx
  803dec:	74 ab                	je     803d99 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803df6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfe:	8b 00                	mov    (%rax),%eax
  803e00:	89 c2                	mov    %eax,%edx
  803e02:	c1 fa 1f             	sar    $0x1f,%edx
  803e05:	c1 ea 1b             	shr    $0x1b,%edx
  803e08:	01 d0                	add    %edx,%eax
  803e0a:	83 e0 1f             	and    $0x1f,%eax
  803e0d:	29 d0                	sub    %edx,%eax
  803e0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e13:	48 98                	cltq   
  803e15:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e1a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e20:	8b 00                	mov    (%rax),%eax
  803e22:	8d 50 01             	lea    0x1(%rax),%edx
  803e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e29:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e2b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e34:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e38:	72 a2                	jb     803ddc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e3e:	c9                   	leaveq 
  803e3f:	c3                   	retq   

0000000000803e40 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e40:	55                   	push   %rbp
  803e41:	48 89 e5             	mov    %rsp,%rbp
  803e44:	48 83 ec 40          	sub    $0x40,%rsp
  803e48:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e50:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e58:	48 89 c7             	mov    %rax,%rdi
  803e5b:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
  803e67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e73:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e7a:	00 
  803e7b:	e9 93 00 00 00       	jmpq   803f13 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e88:	48 89 d6             	mov    %rdx,%rsi
  803e8b:	48 89 c7             	mov    %rax,%rdi
  803e8e:	48 b8 26 3c 80 00 00 	movabs $0x803c26,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
  803e9a:	85 c0                	test   %eax,%eax
  803e9c:	74 07                	je     803ea5 <devpipe_write+0x65>
				return 0;
  803e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea3:	eb 7c                	jmp    803f21 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ea5:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
  803eb1:	eb 01                	jmp    803eb4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803eb3:	90                   	nop
  803eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb8:	8b 40 04             	mov    0x4(%rax),%eax
  803ebb:	48 63 d0             	movslq %eax,%rdx
  803ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec2:	8b 00                	mov    (%rax),%eax
  803ec4:	48 98                	cltq   
  803ec6:	48 83 c0 20          	add    $0x20,%rax
  803eca:	48 39 c2             	cmp    %rax,%rdx
  803ecd:	73 b1                	jae    803e80 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ecf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed3:	8b 40 04             	mov    0x4(%rax),%eax
  803ed6:	89 c2                	mov    %eax,%edx
  803ed8:	c1 fa 1f             	sar    $0x1f,%edx
  803edb:	c1 ea 1b             	shr    $0x1b,%edx
  803ede:	01 d0                	add    %edx,%eax
  803ee0:	83 e0 1f             	and    $0x1f,%eax
  803ee3:	29 d0                	sub    %edx,%eax
  803ee5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ee9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803eed:	48 01 ca             	add    %rcx,%rdx
  803ef0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ef3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ef7:	48 98                	cltq   
  803ef9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f01:	8b 40 04             	mov    0x4(%rax),%eax
  803f04:	8d 50 01             	lea    0x1(%rax),%edx
  803f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f0e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f17:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f1b:	72 96                	jb     803eb3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f21:	c9                   	leaveq 
  803f22:	c3                   	retq   

0000000000803f23 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f23:	55                   	push   %rbp
  803f24:	48 89 e5             	mov    %rsp,%rbp
  803f27:	48 83 ec 20          	sub    $0x20,%rsp
  803f2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f37:	48 89 c7             	mov    %rax,%rdi
  803f3a:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f4e:	48 be 84 4e 80 00 00 	movabs $0x804e84,%rsi
  803f55:	00 00 00 
  803f58:	48 89 c7             	mov    %rax,%rdi
  803f5b:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803f62:	00 00 00 
  803f65:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6b:	8b 50 04             	mov    0x4(%rax),%edx
  803f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f72:	8b 00                	mov    (%rax),%eax
  803f74:	29 c2                	sub    %eax,%edx
  803f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f7a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f84:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f8b:	00 00 00 
	stat->st_dev = &devpipe;
  803f8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f92:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803f99:	00 00 00 
  803f9c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fa8:	c9                   	leaveq 
  803fa9:	c3                   	retq   

0000000000803faa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803faa:	55                   	push   %rbp
  803fab:	48 89 e5             	mov    %rsp,%rbp
  803fae:	48 83 ec 10          	sub    $0x10,%rsp
  803fb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fba:	48 89 c6             	mov    %rax,%rsi
  803fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc2:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803fc9:	00 00 00 
  803fcc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd2:	48 89 c7             	mov    %rax,%rdi
  803fd5:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803fdc:	00 00 00 
  803fdf:	ff d0                	callq  *%rax
  803fe1:	48 89 c6             	mov    %rax,%rsi
  803fe4:	bf 00 00 00 00       	mov    $0x0,%edi
  803fe9:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803ff0:	00 00 00 
  803ff3:	ff d0                	callq  *%rax
}
  803ff5:	c9                   	leaveq 
  803ff6:	c3                   	retq   
	...

0000000000803ff8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ff8:	55                   	push   %rbp
  803ff9:	48 89 e5             	mov    %rsp,%rbp
  803ffc:	48 83 ec 20          	sub    $0x20,%rsp
  804000:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804003:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804006:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804009:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80400d:	be 01 00 00 00       	mov    $0x1,%esi
  804012:	48 89 c7             	mov    %rax,%rdi
  804015:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  80401c:	00 00 00 
  80401f:	ff d0                	callq  *%rax
}
  804021:	c9                   	leaveq 
  804022:	c3                   	retq   

0000000000804023 <getchar>:

int
getchar(void)
{
  804023:	55                   	push   %rbp
  804024:	48 89 e5             	mov    %rsp,%rbp
  804027:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80402b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80402f:	ba 01 00 00 00       	mov    $0x1,%edx
  804034:	48 89 c6             	mov    %rax,%rsi
  804037:	bf 00 00 00 00       	mov    $0x0,%edi
  80403c:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  804043:	00 00 00 
  804046:	ff d0                	callq  *%rax
  804048:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80404b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404f:	79 05                	jns    804056 <getchar+0x33>
		return r;
  804051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804054:	eb 14                	jmp    80406a <getchar+0x47>
	if (r < 1)
  804056:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80405a:	7f 07                	jg     804063 <getchar+0x40>
		return -E_EOF;
  80405c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804061:	eb 07                	jmp    80406a <getchar+0x47>
	return c;
  804063:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804067:	0f b6 c0             	movzbl %al,%eax
}
  80406a:	c9                   	leaveq 
  80406b:	c3                   	retq   

000000000080406c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80406c:	55                   	push   %rbp
  80406d:	48 89 e5             	mov    %rsp,%rbp
  804070:	48 83 ec 20          	sub    $0x20,%rsp
  804074:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804077:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80407b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80407e:	48 89 d6             	mov    %rdx,%rsi
  804081:	89 c7                	mov    %eax,%edi
  804083:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
  80408a:	00 00 00 
  80408d:	ff d0                	callq  *%rax
  80408f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804092:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804096:	79 05                	jns    80409d <iscons+0x31>
		return r;
  804098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409b:	eb 1a                	jmp    8040b7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80409d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a1:	8b 10                	mov    (%rax),%edx
  8040a3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8040aa:	00 00 00 
  8040ad:	8b 00                	mov    (%rax),%eax
  8040af:	39 c2                	cmp    %eax,%edx
  8040b1:	0f 94 c0             	sete   %al
  8040b4:	0f b6 c0             	movzbl %al,%eax
}
  8040b7:	c9                   	leaveq 
  8040b8:	c3                   	retq   

00000000008040b9 <opencons>:

int
opencons(void)
{
  8040b9:	55                   	push   %rbp
  8040ba:	48 89 e5             	mov    %rsp,%rbp
  8040bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040c1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040c5:	48 89 c7             	mov    %rax,%rdi
  8040c8:	48 b8 4a 26 80 00 00 	movabs $0x80264a,%rax
  8040cf:	00 00 00 
  8040d2:	ff d0                	callq  *%rax
  8040d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040db:	79 05                	jns    8040e2 <opencons+0x29>
		return r;
  8040dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e0:	eb 5b                	jmp    80413d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8040eb:	48 89 c6             	mov    %rax,%rsi
  8040ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f3:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
  8040ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804106:	79 05                	jns    80410d <opencons+0x54>
		return r;
  804108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410b:	eb 30                	jmp    80413d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80410d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804111:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804118:	00 00 00 
  80411b:	8b 12                	mov    (%rdx),%edx
  80411d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80411f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804123:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80412a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412e:	48 89 c7             	mov    %rax,%rdi
  804131:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
}
  80413d:	c9                   	leaveq 
  80413e:	c3                   	retq   

000000000080413f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80413f:	55                   	push   %rbp
  804140:	48 89 e5             	mov    %rsp,%rbp
  804143:	48 83 ec 30          	sub    $0x30,%rsp
  804147:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80414b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80414f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804153:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804158:	75 13                	jne    80416d <devcons_read+0x2e>
		return 0;
  80415a:	b8 00 00 00 00       	mov    $0x0,%eax
  80415f:	eb 49                	jmp    8041aa <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804161:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  804168:	00 00 00 
  80416b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80416d:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  804174:	00 00 00 
  804177:	ff d0                	callq  *%rax
  804179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80417c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804180:	74 df                	je     804161 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804186:	79 05                	jns    80418d <devcons_read+0x4e>
		return c;
  804188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418b:	eb 1d                	jmp    8041aa <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80418d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804191:	75 07                	jne    80419a <devcons_read+0x5b>
		return 0;
  804193:	b8 00 00 00 00       	mov    $0x0,%eax
  804198:	eb 10                	jmp    8041aa <devcons_read+0x6b>
	*(char*)vbuf = c;
  80419a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419d:	89 c2                	mov    %eax,%edx
  80419f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a3:	88 10                	mov    %dl,(%rax)
	return 1;
  8041a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8041aa:	c9                   	leaveq 
  8041ab:	c3                   	retq   

00000000008041ac <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041ac:	55                   	push   %rbp
  8041ad:	48 89 e5             	mov    %rsp,%rbp
  8041b0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041b7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041be:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041c5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041d3:	eb 77                	jmp    80424c <devcons_write+0xa0>
		m = n - tot;
  8041d5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041dc:	89 c2                	mov    %eax,%edx
  8041de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e1:	89 d1                	mov    %edx,%ecx
  8041e3:	29 c1                	sub    %eax,%ecx
  8041e5:	89 c8                	mov    %ecx,%eax
  8041e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ed:	83 f8 7f             	cmp    $0x7f,%eax
  8041f0:	76 07                	jbe    8041f9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8041f2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041fc:	48 63 d0             	movslq %eax,%rdx
  8041ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804202:	48 98                	cltq   
  804204:	48 89 c1             	mov    %rax,%rcx
  804207:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80420e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804215:	48 89 ce             	mov    %rcx,%rsi
  804218:	48 89 c7             	mov    %rax,%rdi
  80421b:	48 b8 32 15 80 00 00 	movabs $0x801532,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804227:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80422a:	48 63 d0             	movslq %eax,%rdx
  80422d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804234:	48 89 d6             	mov    %rdx,%rsi
  804237:	48 89 c7             	mov    %rax,%rdi
  80423a:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  804241:	00 00 00 
  804244:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804246:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804249:	01 45 fc             	add    %eax,-0x4(%rbp)
  80424c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424f:	48 98                	cltq   
  804251:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804258:	0f 82 77 ff ff ff    	jb     8041d5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80425e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804261:	c9                   	leaveq 
  804262:	c3                   	retq   

0000000000804263 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804263:	55                   	push   %rbp
  804264:	48 89 e5             	mov    %rsp,%rbp
  804267:	48 83 ec 08          	sub    $0x8,%rsp
  80426b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80426f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804274:	c9                   	leaveq 
  804275:	c3                   	retq   

0000000000804276 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804276:	55                   	push   %rbp
  804277:	48 89 e5             	mov    %rsp,%rbp
  80427a:	48 83 ec 10          	sub    $0x10,%rsp
  80427e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804282:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80428a:	48 be 90 4e 80 00 00 	movabs $0x804e90,%rsi
  804291:	00 00 00 
  804294:	48 89 c7             	mov    %rax,%rdi
  804297:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
	return 0;
  8042a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042a8:	c9                   	leaveq 
  8042a9:	c3                   	retq   
	...

00000000008042ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8042ac:	55                   	push   %rbp
  8042ad:	48 89 e5             	mov    %rsp,%rbp
  8042b0:	48 83 ec 10          	sub    $0x10,%rsp
  8042b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8042b8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042bf:	00 00 00 
  8042c2:	48 8b 00             	mov    (%rax),%rax
  8042c5:	48 85 c0             	test   %rax,%rax
  8042c8:	75 66                	jne    804330 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8042ca:	ba 07 00 00 00       	mov    $0x7,%edx
  8042cf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8042d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8042d9:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8042e0:	00 00 00 
  8042e3:	ff d0                	callq  *%rax
  8042e5:	85 c0                	test   %eax,%eax
  8042e7:	75 1d                	jne    804306 <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8042e9:	48 be 44 43 80 00 00 	movabs $0x804344,%rsi
  8042f0:	00 00 00 
  8042f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f8:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8042ff:	00 00 00 
  804302:	ff d0                	callq  *%rax
  804304:	eb 2a                	jmp    804330 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  804306:	48 ba 97 4e 80 00 00 	movabs $0x804e97,%rdx
  80430d:	00 00 00 
  804310:	be 23 00 00 00       	mov    $0x23,%esi
  804315:	48 bf b5 4e 80 00 00 	movabs $0x804eb5,%rdi
  80431c:	00 00 00 
  80431f:	b8 00 00 00 00       	mov    $0x0,%eax
  804324:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  80432b:	00 00 00 
  80432e:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804330:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804337:	00 00 00 
  80433a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80433e:	48 89 10             	mov    %rdx,(%rax)
}
  804341:	c9                   	leaveq 
  804342:	c3                   	retq   
	...

0000000000804344 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804344:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804347:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80434e:	00 00 00 
call *%rax
  804351:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804353:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  804357:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  80435c:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804363:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804364:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804368:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80436b:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804372:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804373:	4c 8b 3c 24          	mov    (%rsp),%r15
  804377:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80437c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804381:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804386:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80438b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804390:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804395:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80439a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80439f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8043a4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8043a9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8043ae:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8043b3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8043b8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8043bd:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8043c1:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8043c5:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8043c6:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8043c7:	c3                   	retq   

00000000008043c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8043c8:	55                   	push   %rbp
  8043c9:	48 89 e5             	mov    %rsp,%rbp
  8043cc:	48 83 ec 30          	sub    $0x30,%rsp
  8043d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8043dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8043e3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043e8:	74 18                	je     804402 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8043ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ee:	48 89 c7             	mov    %rax,%rdi
  8043f1:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
  8043fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804400:	eb 19                	jmp    80441b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  804402:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  804409:	00 00 00 
  80440c:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  804413:	00 00 00 
  804416:	ff d0                	callq  *%rax
  804418:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80441b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80441f:	79 39                	jns    80445a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804421:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804426:	75 08                	jne    804430 <ipc_recv+0x68>
  804428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442c:	8b 00                	mov    (%rax),%eax
  80442e:	eb 05                	jmp    804435 <ipc_recv+0x6d>
  804430:	b8 00 00 00 00       	mov    $0x0,%eax
  804435:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804439:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80443b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804440:	75 08                	jne    80444a <ipc_recv+0x82>
  804442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804446:	8b 00                	mov    (%rax),%eax
  804448:	eb 05                	jmp    80444f <ipc_recv+0x87>
  80444a:	b8 00 00 00 00       	mov    $0x0,%eax
  80444f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804453:	89 02                	mov    %eax,(%rdx)
		return r;
  804455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804458:	eb 53                	jmp    8044ad <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80445a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80445f:	74 19                	je     80447a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804461:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804468:	00 00 00 
  80446b:	48 8b 00             	mov    (%rax),%rax
  80446e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804478:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80447a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80447f:	74 19                	je     80449a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804481:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804488:	00 00 00 
  80448b:	48 8b 00             	mov    (%rax),%rax
  80448e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804498:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80449a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8044a1:	00 00 00 
  8044a4:	48 8b 00             	mov    (%rax),%rax
  8044a7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8044ad:	c9                   	leaveq 
  8044ae:	c3                   	retq   

00000000008044af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8044af:	55                   	push   %rbp
  8044b0:	48 89 e5             	mov    %rsp,%rbp
  8044b3:	48 83 ec 30          	sub    $0x30,%rsp
  8044b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8044ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8044bd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8044c1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8044c4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8044cb:	eb 59                	jmp    804526 <ipc_send+0x77>
		if(pg) {
  8044cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044d2:	74 20                	je     8044f4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8044d4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044d7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8044da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044e1:	89 c7                	mov    %eax,%edi
  8044e3:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8044ea:	00 00 00 
  8044ed:	ff d0                	callq  *%rax
  8044ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044f2:	eb 26                	jmp    80451a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8044f4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8044fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044fd:	89 d1                	mov    %edx,%ecx
  8044ff:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  804506:	00 00 00 
  804509:	89 c7                	mov    %eax,%edi
  80450b:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  804512:	00 00 00 
  804515:	ff d0                	callq  *%rax
  804517:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80451a:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  804521:	00 00 00 
  804524:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  804526:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80452a:	74 a1                	je     8044cd <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  80452c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804530:	74 2a                	je     80455c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804532:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  804539:	00 00 00 
  80453c:	be 49 00 00 00       	mov    $0x49,%esi
  804541:	48 bf f3 4e 80 00 00 	movabs $0x804ef3,%rdi
  804548:	00 00 00 
  80454b:	b8 00 00 00 00       	mov    $0x0,%eax
  804550:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  804557:	00 00 00 
  80455a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80455c:	c9                   	leaveq 
  80455d:	c3                   	retq   

000000000080455e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80455e:	55                   	push   %rbp
  80455f:	48 89 e5             	mov    %rsp,%rbp
  804562:	48 83 ec 18          	sub    $0x18,%rsp
  804566:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804569:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804570:	eb 6a                	jmp    8045dc <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804572:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804579:	00 00 00 
  80457c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457f:	48 63 d0             	movslq %eax,%rdx
  804582:	48 89 d0             	mov    %rdx,%rax
  804585:	48 c1 e0 02          	shl    $0x2,%rax
  804589:	48 01 d0             	add    %rdx,%rax
  80458c:	48 01 c0             	add    %rax,%rax
  80458f:	48 01 d0             	add    %rdx,%rax
  804592:	48 c1 e0 05          	shl    $0x5,%rax
  804596:	48 01 c8             	add    %rcx,%rax
  804599:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80459f:	8b 00                	mov    (%rax),%eax
  8045a1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8045a4:	75 32                	jne    8045d8 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8045a6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8045ad:	00 00 00 
  8045b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b3:	48 63 d0             	movslq %eax,%rdx
  8045b6:	48 89 d0             	mov    %rdx,%rax
  8045b9:	48 c1 e0 02          	shl    $0x2,%rax
  8045bd:	48 01 d0             	add    %rdx,%rax
  8045c0:	48 01 c0             	add    %rax,%rax
  8045c3:	48 01 d0             	add    %rdx,%rax
  8045c6:	48 c1 e0 05          	shl    $0x5,%rax
  8045ca:	48 01 c8             	add    %rcx,%rax
  8045cd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8045d3:	8b 40 08             	mov    0x8(%rax),%eax
  8045d6:	eb 12                	jmp    8045ea <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8045d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8045dc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8045e3:	7e 8d                	jle    804572 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8045e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045ea:	c9                   	leaveq 
  8045eb:	c3                   	retq   

00000000008045ec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8045ec:	55                   	push   %rbp
  8045ed:	48 89 e5             	mov    %rsp,%rbp
  8045f0:	48 83 ec 18          	sub    $0x18,%rsp
  8045f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8045f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045fc:	48 89 c2             	mov    %rax,%rdx
  8045ff:	48 c1 ea 15          	shr    $0x15,%rdx
  804603:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80460a:	01 00 00 
  80460d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804611:	83 e0 01             	and    $0x1,%eax
  804614:	48 85 c0             	test   %rax,%rax
  804617:	75 07                	jne    804620 <pageref+0x34>
		return 0;
  804619:	b8 00 00 00 00       	mov    $0x0,%eax
  80461e:	eb 53                	jmp    804673 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804624:	48 89 c2             	mov    %rax,%rdx
  804627:	48 c1 ea 0c          	shr    $0xc,%rdx
  80462b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804632:	01 00 00 
  804635:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804639:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80463d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804641:	83 e0 01             	and    $0x1,%eax
  804644:	48 85 c0             	test   %rax,%rax
  804647:	75 07                	jne    804650 <pageref+0x64>
		return 0;
  804649:	b8 00 00 00 00       	mov    $0x0,%eax
  80464e:	eb 23                	jmp    804673 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804654:	48 89 c2             	mov    %rax,%rdx
  804657:	48 c1 ea 0c          	shr    $0xc,%rdx
  80465b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804662:	00 00 00 
  804665:	48 c1 e2 04          	shl    $0x4,%rdx
  804669:	48 01 d0             	add    %rdx,%rax
  80466c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804670:	0f b7 c0             	movzwl %ax,%eax
}
  804673:	c9                   	leaveq 
  804674:	c3                   	retq   
