
obj/user/cat.debug:     file format elf64-x86-64


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
  80003c:	e8 ef 01 00 00       	callq  800230 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800053:	eb 68                	jmp    8000bd <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800055:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800059:	48 89 c2             	mov    %rax,%rdx
  80005c:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800063:	00 00 00 
  800066:	bf 01 00 00 00       	mov    $0x1,%edi
  80006b:	48 b8 f6 23 80 00 00 	movabs $0x8023f6,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax
  800077:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80007a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007d:	48 98                	cltq   
  80007f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800083:	74 38                	je     8000bd <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800085:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800088:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008c:	41 89 d0             	mov    %edx,%r8d
  80008f:	48 89 c1             	mov    %rax,%rcx
  800092:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  800099:	00 00 00 
  80009c:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a1:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  8000b7:	00 00 00 
  8000ba:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000c0:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c5:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8000cc:	00 00 00 
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax
  8000dd:	48 98                	cltq   
  8000df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e8:	0f 8f 67 ff ff ff    	jg     800055 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f3:	79 39                	jns    80012e <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fd:	49 89 d0             	mov    %rdx,%r8
  800100:	48 89 c1             	mov    %rax,%rcx
  800103:	48 ba 26 40 80 00 00 	movabs $0x804026,%rdx
  80010a:	00 00 00 
  80010d:	be 0f 00 00 00       	mov    $0xf,%esi
  800112:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  800128:	00 00 00 
  80012b:	41 ff d1             	callq  *%r9
}
  80012e:	c9                   	leaveq 
  80012f:	c3                   	retq   

0000000000800130 <umain>:

void
umain(int argc, char **argv)
{
  800130:	55                   	push   %rbp
  800131:	48 89 e5             	mov    %rsp,%rbp
  800134:	48 83 ec 20          	sub    $0x20,%rsp
  800138:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80013b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 ba 3b 40 80 00 00 	movabs $0x80403b,%rdx
  800150:	00 00 00 
  800153:	48 89 10             	mov    %rdx,(%rax)
	if (argc == 1)
  800156:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4c>
		cat(0, "<stdin>");
  80015c:	48 be 3f 40 80 00 00 	movabs $0x80403f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 b1 00 00 00       	jmpq   80022d <umain+0xfd>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  800183:	e9 99 00 00 00       	jmpq   800221 <umain+0xf1>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 c1 e0 03          	shl    $0x3,%rax
  800191:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800195:	48 8b 00             	mov    (%rax),%rax
  800198:	be 00 00 00 00       	mov    $0x0,%esi
  80019d:	48 89 c7             	mov    %rax,%rdi
  8001a0:	48 b8 87 27 80 00 00 	movabs $0x802787,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
  8001ac:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  8001af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001b3:	79 33                	jns    8001e8 <umain+0xb8>
				printf("can't open %s: %e\n", argv[i], f);
  8001b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b8:	48 98                	cltq   
  8001ba:	48 c1 e0 03          	shl    $0x3,%rax
  8001be:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8001c2:	48 8b 00             	mov    (%rax),%rax
  8001c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8001c8:	48 89 c6             	mov    %rax,%rsi
  8001cb:	48 bf 47 40 80 00 00 	movabs $0x804047,%rdi
  8001d2:	00 00 00 
  8001d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001da:	48 b9 08 2c 80 00 00 	movabs $0x802c08,%rcx
  8001e1:	00 00 00 
  8001e4:	ff d1                	callq  *%rcx
  8001e6:	eb 35                	jmp    80021d <umain+0xed>
			else {
				cat(f, argv[i]);
  8001e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001eb:	48 98                	cltq   
  8001ed:	48 c1 e0 03          	shl    $0x3,%rax
  8001f1:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8001f5:	48 8b 10             	mov    (%rax),%rdx
  8001f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001fb:	48 89 d6             	mov    %rdx,%rsi
  8001fe:	89 c7                	mov    %eax,%edi
  800200:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
				close(f);
  80020c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80020f:	89 c7                	mov    %eax,%edi
  800211:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80021d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800227:	0f 8c 5b ff ff ff    	jl     800188 <umain+0x58>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80022d:	c9                   	leaveq 
  80022e:	c3                   	retq   
	...

0000000000800230 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 10          	sub    $0x10,%rsp
  800238:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80023b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80023f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800246:	00 00 00 
  800249:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800250:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax
  80025c:	48 98                	cltq   
  80025e:	48 89 c2             	mov    %rax,%rdx
  800261:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800267:	48 89 d0             	mov    %rdx,%rax
  80026a:	48 c1 e0 02          	shl    $0x2,%rax
  80026e:	48 01 d0             	add    %rdx,%rax
  800271:	48 01 c0             	add    %rax,%rax
  800274:	48 01 d0             	add    %rdx,%rax
  800277:	48 c1 e0 05          	shl    $0x5,%rax
  80027b:	48 89 c2             	mov    %rax,%rdx
  80027e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800285:	00 00 00 
  800288:	48 01 c2             	add    %rax,%rdx
  80028b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800292:	00 00 00 
  800295:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800298:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029c:	7e 14                	jle    8002b2 <libmain+0x82>
		binaryname = argv[0];
  80029e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a2:	48 8b 10             	mov    (%rax),%rdx
  8002a5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ac:	00 00 00 
  8002af:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b9:	48 89 d6             	mov    %rdx,%rsi
  8002bc:	89 c7                	mov    %eax,%edi
  8002be:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002ca:	48 b8 d8 02 80 00 00 	movabs $0x8002d8,%rax
  8002d1:	00 00 00 
  8002d4:	ff d0                	callq  *%rax
}
  8002d6:	c9                   	leaveq 
  8002d7:	c3                   	retq   

00000000008002d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002dc:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  8002e3:	00 00 00 
  8002e6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ed:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
}
  8002f9:	5d                   	pop    %rbp
  8002fa:	c3                   	retq   
	...

00000000008002fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fc:	55                   	push   %rbp
  8002fd:	48 89 e5             	mov    %rsp,%rbp
  800300:	53                   	push   %rbx
  800301:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800308:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800315:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80031c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800323:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80032a:	84 c0                	test   %al,%al
  80032c:	74 23                	je     800351 <_panic+0x55>
  80032e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800335:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800339:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80033d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800341:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800345:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800349:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80034d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800351:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800358:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035f:	00 00 00 
  800362:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800369:	00 00 00 
  80036c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800370:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800377:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80038c:	00 00 00 
  80038f:	48 8b 18             	mov    (%rax),%rbx
  800392:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
  80039e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003ab:	41 89 c8             	mov    %ecx,%r8d
  8003ae:	48 89 d1             	mov    %rdx,%rcx
  8003b1:	48 89 da             	mov    %rbx,%rdx
  8003b4:	89 c6                	mov    %eax,%esi
  8003b6:	48 bf 68 40 80 00 00 	movabs $0x804068,%rdi
  8003bd:	00 00 00 
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	49 b9 37 05 80 00 00 	movabs $0x800537,%r9
  8003cc:	00 00 00 
  8003cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e0:	48 89 d6             	mov    %rdx,%rsi
  8003e3:	48 89 c7             	mov    %rax,%rdi
  8003e6:	48 b8 8b 04 80 00 00 	movabs $0x80048b,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f2:	48 bf 8b 40 80 00 00 	movabs $0x80408b,%rdi
  8003f9:	00 00 00 
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	48 ba 37 05 80 00 00 	movabs $0x800537,%rdx
  800408:	00 00 00 
  80040b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040d:	cc                   	int3   
  80040e:	eb fd                	jmp    80040d <_panic+0x111>

0000000000800410 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	48 83 ec 10          	sub    $0x10,%rsp
  800418:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80041f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800423:	8b 00                	mov    (%rax),%eax
  800425:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800428:	89 d6                	mov    %edx,%esi
  80042a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042e:	48 63 d0             	movslq %eax,%rdx
  800431:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800436:	8d 50 01             	lea    0x1(%rax),%edx
  800439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043d:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80043f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800443:	8b 00                	mov    (%rax),%eax
  800445:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044a:	75 2c                	jne    800478 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  80044c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800450:	8b 00                	mov    (%rax),%eax
  800452:	48 98                	cltq   
  800454:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800458:	48 83 c2 08          	add    $0x8,%rdx
  80045c:	48 89 c6             	mov    %rax,%rsi
  80045f:	48 89 d7             	mov    %rdx,%rdi
  800462:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  800469:	00 00 00 
  80046c:	ff d0                	callq  *%rax
        b->idx = 0;
  80046e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800472:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047c:	8b 40 04             	mov    0x4(%rax),%eax
  80047f:	8d 50 01             	lea    0x1(%rax),%edx
  800482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800486:	89 50 04             	mov    %edx,0x4(%rax)
}
  800489:	c9                   	leaveq 
  80048a:	c3                   	retq   

000000000080048b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80048b:	55                   	push   %rbp
  80048c:	48 89 e5             	mov    %rsp,%rbp
  80048f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800496:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80049d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004a4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004ab:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004b2:	48 8b 0a             	mov    (%rdx),%rcx
  8004b5:	48 89 08             	mov    %rcx,(%rax)
  8004b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004cf:	00 00 00 
    b.cnt = 0;
  8004d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004dc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004e3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004ea:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004f1:	48 89 c6             	mov    %rax,%rsi
  8004f4:	48 bf 10 04 80 00 00 	movabs $0x800410,%rdi
  8004fb:	00 00 00 
  8004fe:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800505:	00 00 00 
  800508:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80050a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800510:	48 98                	cltq   
  800512:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800519:	48 83 c2 08          	add    $0x8,%rdx
  80051d:	48 89 c6             	mov    %rax,%rsi
  800520:	48 89 d7             	mov    %rdx,%rdi
  800523:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  80052a:	00 00 00 
  80052d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80052f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800535:	c9                   	leaveq 
  800536:	c3                   	retq   

0000000000800537 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800537:	55                   	push   %rbp
  800538:	48 89 e5             	mov    %rsp,%rbp
  80053b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800542:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800549:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800550:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800557:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800565:	84 c0                	test   %al,%al
  800567:	74 20                	je     800589 <cprintf+0x52>
  800569:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80056d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800571:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800575:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800579:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80057d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800581:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800585:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800589:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800590:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800597:	00 00 00 
  80059a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005a1:	00 00 00 
  8005a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005bd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005cb:	48 8b 0a             	mov    (%rdx),%rcx
  8005ce:	48 89 08             	mov    %rcx,(%rax)
  8005d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005e1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ef:	48 89 d6             	mov    %rdx,%rsi
  8005f2:	48 89 c7             	mov    %rax,%rdi
  8005f5:	48 b8 8b 04 80 00 00 	movabs $0x80048b,%rax
  8005fc:	00 00 00 
  8005ff:	ff d0                	callq  *%rax
  800601:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800607:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80060d:	c9                   	leaveq 
  80060e:	c3                   	retq   
	...

0000000000800610 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800610:	55                   	push   %rbp
  800611:	48 89 e5             	mov    %rsp,%rbp
  800614:	48 83 ec 30          	sub    $0x30,%rsp
  800618:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80061c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800620:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800624:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800627:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80062b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800632:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800636:	77 52                	ja     80068a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800638:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80063b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800642:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064a:	ba 00 00 00 00       	mov    $0x0,%edx
  80064f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800653:	48 89 c2             	mov    %rax,%rdx
  800656:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800659:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80065c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800664:	41 89 f9             	mov    %edi,%r9d
  800667:	48 89 c7             	mov    %rax,%rdi
  80066a:	48 b8 10 06 80 00 00 	movabs $0x800610,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
  800676:	eb 1c                	jmp    800694 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800678:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80067f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800683:	48 89 d6             	mov    %rdx,%rsi
  800686:	89 c7                	mov    %eax,%edi
  800688:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80068e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800692:	7f e4                	jg     800678 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800694:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	48 f7 f1             	div    %rcx
  8006a3:	48 89 d0             	mov    %rdx,%rax
  8006a6:	48 ba 90 42 80 00 00 	movabs $0x804290,%rdx
  8006ad:	00 00 00 
  8006b0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006b4:	0f be c0             	movsbl %al,%eax
  8006b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006bb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006bf:	48 89 d6             	mov    %rdx,%rsi
  8006c2:	89 c7                	mov    %eax,%edi
  8006c4:	ff d1                	callq  *%rcx
}
  8006c6:	c9                   	leaveq 
  8006c7:	c3                   	retq   

00000000008006c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %rbp
  8006c9:	48 89 e5             	mov    %rsp,%rbp
  8006cc:	48 83 ec 20          	sub    $0x20,%rsp
  8006d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006db:	7e 52                	jle    80072f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e1:	8b 00                	mov    (%rax),%eax
  8006e3:	83 f8 30             	cmp    $0x30,%eax
  8006e6:	73 24                	jae    80070c <getuint+0x44>
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	89 c0                	mov    %eax,%eax
  8006f8:	48 01 d0             	add    %rdx,%rax
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	8b 12                	mov    (%rdx),%edx
  800701:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800704:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800708:	89 0a                	mov    %ecx,(%rdx)
  80070a:	eb 17                	jmp    800723 <getuint+0x5b>
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800714:	48 89 d0             	mov    %rdx,%rax
  800717:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800723:	48 8b 00             	mov    (%rax),%rax
  800726:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072a:	e9 a3 00 00 00       	jmpq   8007d2 <getuint+0x10a>
	else if (lflag)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800733:	74 4f                	je     800784 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	83 f8 30             	cmp    $0x30,%eax
  80073e:	73 24                	jae    800764 <getuint+0x9c>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 01 d0             	add    %rdx,%rax
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	8b 12                	mov    (%rdx),%edx
  800759:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800760:	89 0a                	mov    %ecx,(%rdx)
  800762:	eb 17                	jmp    80077b <getuint+0xb3>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076c:	48 89 d0             	mov    %rdx,%rax
  80076f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077b:	48 8b 00             	mov    (%rax),%rax
  80077e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800782:	eb 4e                	jmp    8007d2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 24                	jae    8007b3 <getuint+0xeb>
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	8b 12                	mov    (%rdx),%edx
  8007a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	89 0a                	mov    %ecx,(%rdx)
  8007b1:	eb 17                	jmp    8007ca <getuint+0x102>
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ca:	8b 00                	mov    (%rax),%eax
  8007cc:	89 c0                	mov    %eax,%eax
  8007ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d6:	c9                   	leaveq 
  8007d7:	c3                   	retq   

00000000008007d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	48 83 ec 20          	sub    $0x20,%rsp
  8007e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007eb:	7e 52                	jle    80083f <getint+0x67>
		x=va_arg(*ap, long long);
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	83 f8 30             	cmp    $0x30,%eax
  8007f6:	73 24                	jae    80081c <getint+0x44>
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	8b 12                	mov    (%rdx),%edx
  800811:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	89 0a                	mov    %ecx,(%rdx)
  80081a:	eb 17                	jmp    800833 <getint+0x5b>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800824:	48 89 d0             	mov    %rdx,%rax
  800827:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800833:	48 8b 00             	mov    (%rax),%rax
  800836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083a:	e9 a3 00 00 00       	jmpq   8008e2 <getint+0x10a>
	else if (lflag)
  80083f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800843:	74 4f                	je     800894 <getint+0xbc>
		x=va_arg(*ap, long);
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	8b 00                	mov    (%rax),%eax
  80084b:	83 f8 30             	cmp    $0x30,%eax
  80084e:	73 24                	jae    800874 <getint+0x9c>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	8b 00                	mov    (%rax),%eax
  80085e:	89 c0                	mov    %eax,%eax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	8b 12                	mov    (%rdx),%edx
  800869:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800870:	89 0a                	mov    %ecx,(%rdx)
  800872:	eb 17                	jmp    80088b <getint+0xb3>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087c:	48 89 d0             	mov    %rdx,%rax
  80087f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800887:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088b:	48 8b 00             	mov    (%rax),%rax
  80088e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800892:	eb 4e                	jmp    8008e2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 24                	jae    8008c3 <getint+0xeb>
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ab:	8b 00                	mov    (%rax),%eax
  8008ad:	89 c0                	mov    %eax,%eax
  8008af:	48 01 d0             	add    %rdx,%rax
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	8b 12                	mov    (%rdx),%edx
  8008b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bf:	89 0a                	mov    %ecx,(%rdx)
  8008c1:	eb 17                	jmp    8008da <getint+0x102>
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	48 98                	cltq   
  8008de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	41 54                	push   %r12
  8008ee:	53                   	push   %rbx
  8008ef:	48 83 ec 60          	sub    $0x60,%rsp
  8008f3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ff:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800903:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800907:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80090b:	48 8b 0a             	mov    (%rdx),%rcx
  80090e:	48 89 08             	mov    %rcx,(%rax)
  800911:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800915:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800919:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800921:	eb 17                	jmp    80093a <vprintfmt+0x52>
			if (ch == '\0')
  800923:	85 db                	test   %ebx,%ebx
  800925:	0f 84 ea 04 00 00    	je     800e15 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  80092b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80092f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800933:	48 89 c6             	mov    %rax,%rsi
  800936:	89 df                	mov    %ebx,%edi
  800938:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093e:	0f b6 00             	movzbl (%rax),%eax
  800941:	0f b6 d8             	movzbl %al,%ebx
  800944:	83 fb 25             	cmp    $0x25,%ebx
  800947:	0f 95 c0             	setne  %al
  80094a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80094f:	84 c0                	test   %al,%al
  800951:	75 d0                	jne    800923 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800953:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800957:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80095e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800965:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80096c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800973:	eb 04                	jmp    800979 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800975:	90                   	nop
  800976:	eb 01                	jmp    800979 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800978:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800979:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80097d:	0f b6 00             	movzbl (%rax),%eax
  800980:	0f b6 d8             	movzbl %al,%ebx
  800983:	89 d8                	mov    %ebx,%eax
  800985:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80098a:	83 e8 23             	sub    $0x23,%eax
  80098d:	83 f8 55             	cmp    $0x55,%eax
  800990:	0f 87 4b 04 00 00    	ja     800de1 <vprintfmt+0x4f9>
  800996:	89 c0                	mov    %eax,%eax
  800998:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80099f:	00 
  8009a0:	48 b8 b8 42 80 00 00 	movabs $0x8042b8,%rax
  8009a7:	00 00 00 
  8009aa:	48 01 d0             	add    %rdx,%rax
  8009ad:	48 8b 00             	mov    (%rax),%rax
  8009b0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009b2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009b6:	eb c1                	jmp    800979 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009bc:	eb bb                	jmp    800979 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009be:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009c5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 02             	shl    $0x2,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	01 c0                	add    %eax,%eax
  8009d1:	01 d8                	add    %ebx,%eax
  8009d3:	83 e8 30             	sub    $0x30,%eax
  8009d6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009dd:	0f b6 00             	movzbl (%rax),%eax
  8009e0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e3:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e6:	7e 63                	jle    800a4b <vprintfmt+0x163>
  8009e8:	83 fb 39             	cmp    $0x39,%ebx
  8009eb:	7f 5e                	jg     800a4b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ed:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f2:	eb d1                	jmp    8009c5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	83 f8 30             	cmp    $0x30,%eax
  8009fa:	73 17                	jae    800a13 <vprintfmt+0x12b>
  8009fc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	89 c0                	mov    %eax,%eax
  800a05:	48 01 d0             	add    %rdx,%rax
  800a08:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0b:	83 c2 08             	add    $0x8,%edx
  800a0e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x13a>
  800a13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a17:	48 89 d0             	mov    %rdx,%rax
  800a1a:	48 83 c2 08          	add    $0x8,%rdx
  800a1e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a27:	eb 23                	jmp    800a4c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a2d:	0f 89 42 ff ff ff    	jns    800975 <vprintfmt+0x8d>
				width = 0;
  800a33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a3a:	e9 36 ff ff ff       	jmpq   800975 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a3f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a46:	e9 2e ff ff ff       	jmpq   800979 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a50:	0f 89 22 ff ff ff    	jns    800978 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a56:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a59:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a5c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a63:	e9 10 ff ff ff       	jmpq   800978 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a68:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a6c:	e9 08 ff ff ff       	jmpq   800979 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	83 f8 30             	cmp    $0x30,%eax
  800a77:	73 17                	jae    800a90 <vprintfmt+0x1a8>
  800a79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a88:	83 c2 08             	add    $0x8,%edx
  800a8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8e:	eb 0f                	jmp    800a9f <vprintfmt+0x1b7>
  800a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a94:	48 89 d0             	mov    %rdx,%rax
  800a97:	48 83 c2 08          	add    $0x8,%rdx
  800a9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9f:	8b 00                	mov    (%rax),%eax
  800aa1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800aa9:	48 89 d6             	mov    %rdx,%rsi
  800aac:	89 c7                	mov    %eax,%edi
  800aae:	ff d1                	callq  *%rcx
			break;
  800ab0:	e9 5a 03 00 00       	jmpq   800e0f <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ab5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab8:	83 f8 30             	cmp    $0x30,%eax
  800abb:	73 17                	jae    800ad4 <vprintfmt+0x1ec>
  800abd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac4:	89 c0                	mov    %eax,%eax
  800ac6:	48 01 d0             	add    %rdx,%rax
  800ac9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800acc:	83 c2 08             	add    $0x8,%edx
  800acf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad2:	eb 0f                	jmp    800ae3 <vprintfmt+0x1fb>
  800ad4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad8:	48 89 d0             	mov    %rdx,%rax
  800adb:	48 83 c2 08          	add    $0x8,%rdx
  800adf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae5:	85 db                	test   %ebx,%ebx
  800ae7:	79 02                	jns    800aeb <vprintfmt+0x203>
				err = -err;
  800ae9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aeb:	83 fb 15             	cmp    $0x15,%ebx
  800aee:	7f 16                	jg     800b06 <vprintfmt+0x21e>
  800af0:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  800af7:	00 00 00 
  800afa:	48 63 d3             	movslq %ebx,%rdx
  800afd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b01:	4d 85 e4             	test   %r12,%r12
  800b04:	75 2e                	jne    800b34 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	89 d9                	mov    %ebx,%ecx
  800b10:	48 ba a1 42 80 00 00 	movabs $0x8042a1,%rdx
  800b17:	00 00 00 
  800b1a:	48 89 c7             	mov    %rax,%rdi
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	49 b8 1f 0e 80 00 00 	movabs $0x800e1f,%r8
  800b29:	00 00 00 
  800b2c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2f:	e9 db 02 00 00       	jmpq   800e0f <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	4c 89 e1             	mov    %r12,%rcx
  800b3f:	48 ba aa 42 80 00 00 	movabs $0x8042aa,%rdx
  800b46:	00 00 00 
  800b49:	48 89 c7             	mov    %rax,%rdi
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	49 b8 1f 0e 80 00 00 	movabs $0x800e1f,%r8
  800b58:	00 00 00 
  800b5b:	41 ff d0             	callq  *%r8
			break;
  800b5e:	e9 ac 02 00 00       	jmpq   800e0f <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b66:	83 f8 30             	cmp    $0x30,%eax
  800b69:	73 17                	jae    800b82 <vprintfmt+0x29a>
  800b6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b72:	89 c0                	mov    %eax,%eax
  800b74:	48 01 d0             	add    %rdx,%rax
  800b77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7a:	83 c2 08             	add    $0x8,%edx
  800b7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x2a9>
  800b82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b86:	48 89 d0             	mov    %rdx,%rax
  800b89:	48 83 c2 08          	add    $0x8,%rdx
  800b8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b91:	4c 8b 20             	mov    (%rax),%r12
  800b94:	4d 85 e4             	test   %r12,%r12
  800b97:	75 0a                	jne    800ba3 <vprintfmt+0x2bb>
				p = "(null)";
  800b99:	49 bc ad 42 80 00 00 	movabs $0x8042ad,%r12
  800ba0:	00 00 00 
			if (width > 0 && padc != '-')
  800ba3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba7:	7e 7a                	jle    800c23 <vprintfmt+0x33b>
  800ba9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bad:	74 74                	je     800c23 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800baf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bb2:	48 98                	cltq   
  800bb4:	48 89 c6             	mov    %rax,%rsi
  800bb7:	4c 89 e7             	mov    %r12,%rdi
  800bba:	48 b8 ca 10 80 00 00 	movabs $0x8010ca,%rax
  800bc1:	00 00 00 
  800bc4:	ff d0                	callq  *%rax
  800bc6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc9:	eb 17                	jmp    800be2 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bcb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd3:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bd7:	48 89 d6             	mov    %rdx,%rsi
  800bda:	89 c7                	mov    %eax,%edi
  800bdc:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bde:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be6:	7f e3                	jg     800bcb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be8:	eb 39                	jmp    800c23 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800bea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bee:	74 1e                	je     800c0e <vprintfmt+0x326>
  800bf0:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf3:	7e 05                	jle    800bfa <vprintfmt+0x312>
  800bf5:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf8:	7e 14                	jle    800c0e <vprintfmt+0x326>
					putch('?', putdat);
  800bfa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bfe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c02:	48 89 c6             	mov    %rax,%rsi
  800c05:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c0a:	ff d2                	callq  *%rdx
  800c0c:	eb 0f                	jmp    800c1d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c16:	48 89 c6             	mov    %rax,%rsi
  800c19:	89 df                	mov    %ebx,%edi
  800c1b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c21:	eb 01                	jmp    800c24 <vprintfmt+0x33c>
  800c23:	90                   	nop
  800c24:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c29:	0f be d8             	movsbl %al,%ebx
  800c2c:	85 db                	test   %ebx,%ebx
  800c2e:	0f 95 c0             	setne  %al
  800c31:	49 83 c4 01          	add    $0x1,%r12
  800c35:	84 c0                	test   %al,%al
  800c37:	74 28                	je     800c61 <vprintfmt+0x379>
  800c39:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3d:	78 ab                	js     800bea <vprintfmt+0x302>
  800c3f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c47:	79 a1                	jns    800bea <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c49:	eb 16                	jmp    800c61 <vprintfmt+0x379>
				putch(' ', putdat);
  800c4b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c4f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c53:	48 89 c6             	mov    %rax,%rsi
  800c56:	bf 20 00 00 00       	mov    $0x20,%edi
  800c5b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c65:	7f e4                	jg     800c4b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c67:	e9 a3 01 00 00       	jmpq   800e0f <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c6c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c70:	be 03 00 00 00       	mov    $0x3,%esi
  800c75:	48 89 c7             	mov    %rax,%rdi
  800c78:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800c7f:	00 00 00 
  800c82:	ff d0                	callq  *%rax
  800c84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8c:	48 85 c0             	test   %rax,%rax
  800c8f:	79 1d                	jns    800cae <vprintfmt+0x3c6>
				putch('-', putdat);
  800c91:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c95:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c99:	48 89 c6             	mov    %rax,%rsi
  800c9c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ca1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca7:	48 f7 d8             	neg    %rax
  800caa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb5:	e9 e8 00 00 00       	jmpq   800da2 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbe:	be 03 00 00 00       	mov    $0x3,%esi
  800cc3:	48 89 c7             	mov    %rax,%rdi
  800cc6:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800ccd:	00 00 00 
  800cd0:	ff d0                	callq  *%rax
  800cd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cd6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cdd:	e9 c0 00 00 00       	jmpq   800da2 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ce2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ce6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cea:	48 89 c6             	mov    %rax,%rsi
  800ced:	bf 58 00 00 00       	mov    $0x58,%edi
  800cf2:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800cf4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cf8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cfc:	48 89 c6             	mov    %rax,%rsi
  800cff:	bf 58 00 00 00       	mov    $0x58,%edi
  800d04:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0e:	48 89 c6             	mov    %rax,%rsi
  800d11:	bf 58 00 00 00       	mov    $0x58,%edi
  800d16:	ff d2                	callq  *%rdx
			break;
  800d18:	e9 f2 00 00 00       	jmpq   800e0f <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800d1d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d21:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d25:	48 89 c6             	mov    %rax,%rsi
  800d28:	bf 30 00 00 00       	mov    $0x30,%edi
  800d2d:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d2f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d33:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d37:	48 89 c6             	mov    %rax,%rsi
  800d3a:	bf 78 00 00 00       	mov    $0x78,%edi
  800d3f:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d44:	83 f8 30             	cmp    $0x30,%eax
  800d47:	73 17                	jae    800d60 <vprintfmt+0x478>
  800d49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d50:	89 c0                	mov    %eax,%eax
  800d52:	48 01 d0             	add    %rdx,%rax
  800d55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d58:	83 c2 08             	add    $0x8,%edx
  800d5b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5e:	eb 0f                	jmp    800d6f <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800d60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d64:	48 89 d0             	mov    %rdx,%rax
  800d67:	48 83 c2 08          	add    $0x8,%rdx
  800d6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d76:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d7d:	eb 23                	jmp    800da2 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d7f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d83:	be 03 00 00 00       	mov    $0x3,%esi
  800d88:	48 89 c7             	mov    %rax,%rdi
  800d8b:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800d92:	00 00 00 
  800d95:	ff d0                	callq  *%rax
  800d97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d9b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800da7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800daa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800db5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db9:	45 89 c1             	mov    %r8d,%r9d
  800dbc:	41 89 f8             	mov    %edi,%r8d
  800dbf:	48 89 c7             	mov    %rax,%rdi
  800dc2:	48 b8 10 06 80 00 00 	movabs $0x800610,%rax
  800dc9:	00 00 00 
  800dcc:	ff d0                	callq  *%rax
			break;
  800dce:	eb 3f                	jmp    800e0f <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dd0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dd4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd8:	48 89 c6             	mov    %rax,%rsi
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	ff d2                	callq  *%rdx
			break;
  800ddf:	eb 2e                	jmp    800e0f <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800de1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800de5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800de9:	48 89 c6             	mov    %rax,%rsi
  800dec:	bf 25 00 00 00       	mov    $0x25,%edi
  800df1:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df8:	eb 05                	jmp    800dff <vprintfmt+0x517>
  800dfa:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dff:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e03:	48 83 e8 01          	sub    $0x1,%rax
  800e07:	0f b6 00             	movzbl (%rax),%eax
  800e0a:	3c 25                	cmp    $0x25,%al
  800e0c:	75 ec                	jne    800dfa <vprintfmt+0x512>
				/* do nothing */;
			break;
  800e0e:	90                   	nop
		}
	}
  800e0f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e10:	e9 25 fb ff ff       	jmpq   80093a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e15:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e16:	48 83 c4 60          	add    $0x60,%rsp
  800e1a:	5b                   	pop    %rbx
  800e1b:	41 5c                	pop    %r12
  800e1d:	5d                   	pop    %rbp
  800e1e:	c3                   	retq   

0000000000800e1f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e1f:	55                   	push   %rbp
  800e20:	48 89 e5             	mov    %rsp,%rbp
  800e23:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e2a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e31:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e38:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e3f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e46:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e4d:	84 c0                	test   %al,%al
  800e4f:	74 20                	je     800e71 <printfmt+0x52>
  800e51:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e55:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e59:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e5d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e61:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e65:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e69:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e6d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e71:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e78:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e7f:	00 00 00 
  800e82:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e89:	00 00 00 
  800e8c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e90:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e97:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e9e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ea5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800eac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eb3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eba:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ec1:	48 89 c7             	mov    %rax,%rdi
  800ec4:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 83 ec 10          	sub    $0x10,%rsp
  800eda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800edd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee5:	8b 40 10             	mov    0x10(%rax),%eax
  800ee8:	8d 50 01             	lea    0x1(%rax),%edx
  800eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eef:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ef2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef6:	48 8b 10             	mov    (%rax),%rdx
  800ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f01:	48 39 c2             	cmp    %rax,%rdx
  800f04:	73 17                	jae    800f1d <sprintputch+0x4b>
		*b->buf++ = ch;
  800f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f0a:	48 8b 00             	mov    (%rax),%rax
  800f0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f10:	88 10                	mov    %dl,(%rax)
  800f12:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1a:	48 89 10             	mov    %rdx,(%rax)
}
  800f1d:	c9                   	leaveq 
  800f1e:	c3                   	retq   

0000000000800f1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f1f:	55                   	push   %rbp
  800f20:	48 89 e5             	mov    %rsp,%rbp
  800f23:	48 83 ec 50          	sub    $0x50,%rsp
  800f27:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f2b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f2e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f32:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f36:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f3a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f3e:	48 8b 0a             	mov    (%rdx),%rcx
  800f41:	48 89 08             	mov    %rcx,(%rax)
  800f44:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f48:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f4c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f50:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f54:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f58:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f5c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f5f:	48 98                	cltq   
  800f61:	48 83 e8 01          	sub    $0x1,%rax
  800f65:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f69:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f74:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f79:	74 06                	je     800f81 <vsnprintf+0x62>
  800f7b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f7f:	7f 07                	jg     800f88 <vsnprintf+0x69>
		return -E_INVAL;
  800f81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f86:	eb 2f                	jmp    800fb7 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f88:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f8c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f94:	48 89 c6             	mov    %rax,%rsi
  800f97:	48 bf d2 0e 80 00 00 	movabs $0x800ed2,%rdi
  800f9e:	00 00 00 
  800fa1:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800fa8:	00 00 00 
  800fab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fb1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fb4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fb7:	c9                   	leaveq 
  800fb8:	c3                   	retq   

0000000000800fb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb9:	55                   	push   %rbp
  800fba:	48 89 e5             	mov    %rsp,%rbp
  800fbd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fc4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fcb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fd1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fdf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 20                	je     80100a <snprintf+0x51>
  800fea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ff2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ff6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ffa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ffe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801002:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801006:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80100a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801011:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801018:	00 00 00 
  80101b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801022:	00 00 00 
  801025:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801029:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801030:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801037:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80103e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801045:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80104c:	48 8b 0a             	mov    (%rdx),%rcx
  80104f:	48 89 08             	mov    %rcx,(%rax)
  801052:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801056:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80105a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801062:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801069:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801070:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801076:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80107d:	48 89 c7             	mov    %rax,%rdi
  801080:	48 b8 1f 0f 80 00 00 	movabs $0x800f1f,%rax
  801087:	00 00 00 
  80108a:	ff d0                	callq  *%rax
  80108c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801092:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801098:	c9                   	leaveq 
  801099:	c3                   	retq   
	...

000000000080109c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80109c:	55                   	push   %rbp
  80109d:	48 89 e5             	mov    %rsp,%rbp
  8010a0:	48 83 ec 18          	sub    $0x18,%rsp
  8010a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010af:	eb 09                	jmp    8010ba <strlen+0x1e>
		n++;
  8010b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010be:	0f b6 00             	movzbl (%rax),%eax
  8010c1:	84 c0                	test   %al,%al
  8010c3:	75 ec                	jne    8010b1 <strlen+0x15>
		n++;
	return n;
  8010c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c8:	c9                   	leaveq 
  8010c9:	c3                   	retq   

00000000008010ca <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010ca:	55                   	push   %rbp
  8010cb:	48 89 e5             	mov    %rsp,%rbp
  8010ce:	48 83 ec 20          	sub    $0x20,%rsp
  8010d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010e1:	eb 0e                	jmp    8010f1 <strnlen+0x27>
		n++;
  8010e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ec:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010f6:	74 0b                	je     801103 <strnlen+0x39>
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	0f b6 00             	movzbl (%rax),%eax
  8010ff:	84 c0                	test   %al,%al
  801101:	75 e0                	jne    8010e3 <strnlen+0x19>
		n++;
	return n;
  801103:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 20          	sub    $0x20,%rsp
  801110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801120:	90                   	nop
  801121:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801125:	0f b6 10             	movzbl (%rax),%edx
  801128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112c:	88 10                	mov    %dl,(%rax)
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801132:	0f b6 00             	movzbl (%rax),%eax
  801135:	84 c0                	test   %al,%al
  801137:	0f 95 c0             	setne  %al
  80113a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80113f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801144:	84 c0                	test   %al,%al
  801146:	75 d9                	jne    801121 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80114c:	c9                   	leaveq 
  80114d:	c3                   	retq   

000000000080114e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80114e:	55                   	push   %rbp
  80114f:	48 89 e5             	mov    %rsp,%rbp
  801152:	48 83 ec 20          	sub    $0x20,%rsp
  801156:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	48 89 c7             	mov    %rax,%rdi
  801165:	48 b8 9c 10 80 00 00 	movabs $0x80109c,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax
  801171:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801177:	48 98                	cltq   
  801179:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80117d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801181:	48 89 d6             	mov    %rdx,%rsi
  801184:	48 89 c7             	mov    %rax,%rdi
  801187:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  80118e:	00 00 00 
  801191:	ff d0                	callq  *%rax
	return dst;
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801197:	c9                   	leaveq 
  801198:	c3                   	retq   

0000000000801199 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	48 83 ec 28          	sub    $0x28,%rsp
  8011a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011b5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011bc:	00 
  8011bd:	eb 27                	jmp    8011e6 <strncpy+0x4d>
		*dst++ = *src;
  8011bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c3:	0f b6 10             	movzbl (%rax),%edx
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	88 10                	mov    %dl,(%rax)
  8011cc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	84 c0                	test   %al,%al
  8011da:	74 05                	je     8011e1 <strncpy+0x48>
			src++;
  8011dc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ea:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011ee:	72 cf                	jb     8011bf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 28          	sub    $0x28,%rsp
  8011fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801206:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801212:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801217:	74 37                	je     801250 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801219:	eb 17                	jmp    801232 <strlcpy+0x3c>
			*dst++ = *src++;
  80121b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121f:	0f b6 10             	movzbl (%rax),%edx
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801226:	88 10                	mov    %dl,(%rax)
  801228:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80122d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801232:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801237:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80123c:	74 0b                	je     801249 <strlcpy+0x53>
  80123e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	75 d2                	jne    80121b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801250:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 89 d1             	mov    %rdx,%rcx
  80125b:	48 29 c1             	sub    %rax,%rcx
  80125e:	48 89 c8             	mov    %rcx,%rax
}
  801261:	c9                   	leaveq 
  801262:	c3                   	retq   

0000000000801263 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801263:	55                   	push   %rbp
  801264:	48 89 e5             	mov    %rsp,%rbp
  801267:	48 83 ec 10          	sub    $0x10,%rsp
  80126b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801273:	eb 0a                	jmp    80127f <strcmp+0x1c>
		p++, q++;
  801275:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	74 12                	je     80129c <strcmp+0x39>
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 10             	movzbl (%rax),%edx
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	38 c2                	cmp    %al,%dl
  80129a:	74 d9                	je     801275 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	0f b6 d0             	movzbl %al,%edx
  8012a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	0f b6 c0             	movzbl %al,%eax
  8012b0:	89 d1                	mov    %edx,%ecx
  8012b2:	29 c1                	sub    %eax,%ecx
  8012b4:	89 c8                	mov    %ecx,%eax
}
  8012b6:	c9                   	leaveq 
  8012b7:	c3                   	retq   

00000000008012b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b8:	55                   	push   %rbp
  8012b9:	48 89 e5             	mov    %rsp,%rbp
  8012bc:	48 83 ec 18          	sub    $0x18,%rsp
  8012c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012cc:	eb 0f                	jmp    8012dd <strncmp+0x25>
		n--, p++, q++;
  8012ce:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e2:	74 1d                	je     801301 <strncmp+0x49>
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	74 12                	je     801301 <strncmp+0x49>
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 10             	movzbl (%rax),%edx
  8012f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	38 c2                	cmp    %al,%dl
  8012ff:	74 cd                	je     8012ce <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801301:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801306:	75 07                	jne    80130f <strncmp+0x57>
		return 0;
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
  80130d:	eb 1a                	jmp    801329 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	0f b6 d0             	movzbl %al,%edx
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	89 d1                	mov    %edx,%ecx
  801325:	29 c1                	sub    %eax,%ecx
  801327:	89 c8                	mov    %ecx,%eax
}
  801329:	c9                   	leaveq 
  80132a:	c3                   	retq   

000000000080132b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80132b:	55                   	push   %rbp
  80132c:	48 89 e5             	mov    %rsp,%rbp
  80132f:	48 83 ec 10          	sub    $0x10,%rsp
  801333:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801337:	89 f0                	mov    %esi,%eax
  801339:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80133c:	eb 17                	jmp    801355 <strchr+0x2a>
		if (*s == c)
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801348:	75 06                	jne    801350 <strchr+0x25>
			return (char *) s;
  80134a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134e:	eb 15                	jmp    801365 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801350:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	75 de                	jne    80133e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801360:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801365:	c9                   	leaveq 
  801366:	c3                   	retq   

0000000000801367 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801367:	55                   	push   %rbp
  801368:	48 89 e5             	mov    %rsp,%rbp
  80136b:	48 83 ec 10          	sub    $0x10,%rsp
  80136f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801373:	89 f0                	mov    %esi,%eax
  801375:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801378:	eb 11                	jmp    80138b <strfind+0x24>
		if (*s == c)
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	0f b6 00             	movzbl (%rax),%eax
  801381:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801384:	74 12                	je     801398 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801386:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	84 c0                	test   %al,%al
  801394:	75 e4                	jne    80137a <strfind+0x13>
  801396:	eb 01                	jmp    801399 <strfind+0x32>
		if (*s == c)
			break;
  801398:	90                   	nop
	return (char *) s;
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 18          	sub    $0x18,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b7:	75 06                	jne    8013bf <memset+0x20>
		return v;
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	eb 69                	jmp    801428 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	83 e0 03             	and    $0x3,%eax
  8013c6:	48 85 c0             	test   %rax,%rax
  8013c9:	75 48                	jne    801413 <memset+0x74>
  8013cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	48 85 c0             	test   %rax,%rax
  8013d5:	75 3c                	jne    801413 <memset+0x74>
		c &= 0xFF;
  8013d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	89 c2                	mov    %eax,%edx
  8013e3:	c1 e2 18             	shl    $0x18,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 10             	shl    $0x10,%eax
  8013ec:	09 c2                	or     %eax,%edx
  8013ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f1:	c1 e0 08             	shl    $0x8,%eax
  8013f4:	09 d0                	or     %edx,%eax
  8013f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	48 89 c1             	mov    %rax,%rcx
  801400:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801404:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801408:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80140b:	48 89 d7             	mov    %rdx,%rdi
  80140e:	fc                   	cld    
  80140f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801411:	eb 11                	jmp    801424 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801413:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801417:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80141e:	48 89 d7             	mov    %rdx,%rdi
  801421:	fc                   	cld    
  801422:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801428:	c9                   	leaveq 
  801429:	c3                   	retq   

000000000080142a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80142a:	55                   	push   %rbp
  80142b:	48 89 e5             	mov    %rsp,%rbp
  80142e:	48 83 ec 28          	sub    $0x28,%rsp
  801432:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80143a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80143e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801442:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801456:	0f 83 88 00 00 00    	jae    8014e4 <memmove+0xba>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801464:	48 01 d0             	add    %rdx,%rax
  801467:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80146b:	76 77                	jbe    8014e4 <memmove+0xba>
		s += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80147d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801481:	83 e0 03             	and    $0x3,%eax
  801484:	48 85 c0             	test   %rax,%rax
  801487:	75 3b                	jne    8014c4 <memmove+0x9a>
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	83 e0 03             	and    $0x3,%eax
  801490:	48 85 c0             	test   %rax,%rax
  801493:	75 2f                	jne    8014c4 <memmove+0x9a>
  801495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801499:	83 e0 03             	and    $0x3,%eax
  80149c:	48 85 c0             	test   %rax,%rax
  80149f:	75 23                	jne    8014c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	48 83 e8 04          	sub    $0x4,%rax
  8014a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ad:	48 83 ea 04          	sub    $0x4,%rdx
  8014b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b9:	48 89 c7             	mov    %rax,%rdi
  8014bc:	48 89 d6             	mov    %rdx,%rsi
  8014bf:	fd                   	std    
  8014c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014c2:	eb 1d                	jmp    8014e1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	48 89 d7             	mov    %rdx,%rdi
  8014db:	48 89 c1             	mov    %rax,%rcx
  8014de:	fd                   	std    
  8014df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014e1:	fc                   	cld    
  8014e2:	eb 57                	jmp    80153b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	83 e0 03             	and    $0x3,%eax
  8014eb:	48 85 c0             	test   %rax,%rax
  8014ee:	75 36                	jne    801526 <memmove+0xfc>
  8014f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f4:	83 e0 03             	and    $0x3,%eax
  8014f7:	48 85 c0             	test   %rax,%rax
  8014fa:	75 2a                	jne    801526 <memmove+0xfc>
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	83 e0 03             	and    $0x3,%eax
  801503:	48 85 c0             	test   %rax,%rax
  801506:	75 1e                	jne    801526 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150c:	48 89 c1             	mov    %rax,%rcx
  80150f:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151b:	48 89 c7             	mov    %rax,%rdi
  80151e:	48 89 d6             	mov    %rdx,%rsi
  801521:	fc                   	cld    
  801522:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801524:	eb 15                	jmp    80153b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801532:	48 89 c7             	mov    %rax,%rdi
  801535:	48 89 d6             	mov    %rdx,%rsi
  801538:	fc                   	cld    
  801539:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80153f:	c9                   	leaveq 
  801540:	c3                   	retq   

0000000000801541 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	48 83 ec 18          	sub    $0x18,%rsp
  801549:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801551:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801559:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80155d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801561:	48 89 ce             	mov    %rcx,%rsi
  801564:	48 89 c7             	mov    %rax,%rdi
  801567:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  80156e:	00 00 00 
  801571:	ff d0                	callq  *%rax
}
  801573:	c9                   	leaveq 
  801574:	c3                   	retq   

0000000000801575 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801575:	55                   	push   %rbp
  801576:	48 89 e5             	mov    %rsp,%rbp
  801579:	48 83 ec 28          	sub    $0x28,%rsp
  80157d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801581:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801585:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801591:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801595:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801599:	eb 38                	jmp    8015d3 <memcmp+0x5e>
		if (*s1 != *s2)
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	0f b6 10             	movzbl (%rax),%edx
  8015a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	38 c2                	cmp    %al,%dl
  8015ab:	74 1c                	je     8015c9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8015ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	0f b6 d0             	movzbl %al,%edx
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	0f b6 c0             	movzbl %al,%eax
  8015c1:	89 d1                	mov    %edx,%ecx
  8015c3:	29 c1                	sub    %eax,%ecx
  8015c5:	89 c8                	mov    %ecx,%eax
  8015c7:	eb 20                	jmp    8015e9 <memcmp+0x74>
		s1++, s2++;
  8015c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015d8:	0f 95 c0             	setne  %al
  8015db:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015e0:	84 c0                	test   %al,%al
  8015e2:	75 b7                	jne    80159b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e9:	c9                   	leaveq 
  8015ea:	c3                   	retq   

00000000008015eb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
  8015ef:	48 83 ec 28          	sub    $0x28,%rsp
  8015f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801606:	48 01 d0             	add    %rdx,%rax
  801609:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80160d:	eb 13                	jmp    801622 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80160f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801613:	0f b6 10             	movzbl (%rax),%edx
  801616:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801619:	38 c2                	cmp    %al,%dl
  80161b:	74 11                	je     80162e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801626:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80162a:	72 e3                	jb     80160f <memfind+0x24>
  80162c:	eb 01                	jmp    80162f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80162e:	90                   	nop
	return (void *) s;
  80162f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 38          	sub    $0x38,%rsp
  80163d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801641:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801645:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80164f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801656:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801657:	eb 05                	jmp    80165e <strtol+0x29>
		s++;
  801659:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 20                	cmp    $0x20,%al
  801667:	74 f0                	je     801659 <strtol+0x24>
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 09                	cmp    $0x9,%al
  801672:	74 e5                	je     801659 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	3c 2b                	cmp    $0x2b,%al
  80167d:	75 07                	jne    801686 <strtol+0x51>
		s++;
  80167f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801684:	eb 17                	jmp    80169d <strtol+0x68>
	else if (*s == '-')
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	3c 2d                	cmp    $0x2d,%al
  80168f:	75 0c                	jne    80169d <strtol+0x68>
		s++, neg = 1;
  801691:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801696:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80169d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a1:	74 06                	je     8016a9 <strtol+0x74>
  8016a3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016a7:	75 28                	jne    8016d1 <strtol+0x9c>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 1d                	jne    8016d1 <strtol+0x9c>
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	48 83 c0 01          	add    $0x1,%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	3c 78                	cmp    $0x78,%al
  8016c1:	75 0e                	jne    8016d1 <strtol+0x9c>
		s += 2, base = 16;
  8016c3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016c8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016cf:	eb 2c                	jmp    8016fd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d5:	75 19                	jne    8016f0 <strtol+0xbb>
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 30                	cmp    $0x30,%al
  8016e0:	75 0e                	jne    8016f0 <strtol+0xbb>
		s++, base = 8;
  8016e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ee:	eb 0d                	jmp    8016fd <strtol+0xc8>
	else if (base == 0)
  8016f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016f4:	75 07                	jne    8016fd <strtol+0xc8>
		base = 10;
  8016f6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 2f                	cmp    $0x2f,%al
  801706:	7e 1d                	jle    801725 <strtol+0xf0>
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	0f b6 00             	movzbl (%rax),%eax
  80170f:	3c 39                	cmp    $0x39,%al
  801711:	7f 12                	jg     801725 <strtol+0xf0>
			dig = *s - '0';
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	0f be c0             	movsbl %al,%eax
  80171d:	83 e8 30             	sub    $0x30,%eax
  801720:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801723:	eb 4e                	jmp    801773 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 60                	cmp    $0x60,%al
  80172e:	7e 1d                	jle    80174d <strtol+0x118>
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 7a                	cmp    $0x7a,%al
  801739:	7f 12                	jg     80174d <strtol+0x118>
			dig = *s - 'a' + 10;
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	0f be c0             	movsbl %al,%eax
  801745:	83 e8 57             	sub    $0x57,%eax
  801748:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80174b:	eb 26                	jmp    801773 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 40                	cmp    $0x40,%al
  801756:	7e 47                	jle    80179f <strtol+0x16a>
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	3c 5a                	cmp    $0x5a,%al
  801761:	7f 3c                	jg     80179f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	0f be c0             	movsbl %al,%eax
  80176d:	83 e8 37             	sub    $0x37,%eax
  801770:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801773:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801776:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801779:	7d 23                	jge    80179e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80177b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801780:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801783:	48 98                	cltq   
  801785:	48 89 c2             	mov    %rax,%rdx
  801788:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80178d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801790:	48 98                	cltq   
  801792:	48 01 d0             	add    %rdx,%rax
  801795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801799:	e9 5f ff ff ff       	jmpq   8016fd <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80179e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80179f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017a4:	74 0b                	je     8017b1 <strtol+0x17c>
		*endptr = (char *) s;
  8017a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ae:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017b5:	74 09                	je     8017c0 <strtol+0x18b>
  8017b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bb:	48 f7 d8             	neg    %rax
  8017be:	eb 04                	jmp    8017c4 <strtol+0x18f>
  8017c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017c4:	c9                   	leaveq 
  8017c5:	c3                   	retq   

00000000008017c6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017c6:	55                   	push   %rbp
  8017c7:	48 89 e5             	mov    %rsp,%rbp
  8017ca:	48 83 ec 30          	sub    $0x30,%rsp
  8017ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017e0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8017e5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e9:	75 06                	jne    8017f1 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8017eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ef:	eb 68                	jmp    801859 <strstr+0x93>

	len = strlen(str);
  8017f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f5:	48 89 c7             	mov    %rax,%rdi
  8017f8:	48 b8 9c 10 80 00 00 	movabs $0x80109c,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	callq  *%rax
  801804:	48 98                	cltq   
  801806:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	88 45 ef             	mov    %al,-0x11(%rbp)
  801814:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801819:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80181d:	75 07                	jne    801826 <strstr+0x60>
				return (char *) 0;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb 33                	jmp    801859 <strstr+0x93>
		} while (sc != c);
  801826:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80182a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80182d:	75 db                	jne    80180a <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80182f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801833:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183b:	48 89 ce             	mov    %rcx,%rsi
  80183e:	48 89 c7             	mov    %rax,%rdi
  801841:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
  80184d:	85 c0                	test   %eax,%eax
  80184f:	75 b9                	jne    80180a <strstr+0x44>

	return (char *) (in - 1);
  801851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801855:	48 83 e8 01          	sub    $0x1,%rax
}
  801859:	c9                   	leaveq 
  80185a:	c3                   	retq   
	...

000000000080185c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	53                   	push   %rbx
  801861:	48 83 ec 58          	sub    $0x58,%rsp
  801865:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801868:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80186b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801873:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801877:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80187b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801881:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801885:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801889:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80188d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801891:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801895:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801898:	4c 89 c3             	mov    %r8,%rbx
  80189b:	cd 30                	int    $0x30
  80189d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8018a1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8018a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018ad:	74 3e                	je     8018ed <syscall+0x91>
  8018af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018b4:	7e 37                	jle    8018ed <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018bd:	49 89 d0             	mov    %rdx,%r8
  8018c0:	89 c1                	mov    %eax,%ecx
  8018c2:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  8018c9:	00 00 00 
  8018cc:	be 23 00 00 00       	mov    $0x23,%esi
  8018d1:	48 bf 85 45 80 00 00 	movabs $0x804585,%rdi
  8018d8:	00 00 00 
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  8018e7:	00 00 00 
  8018ea:	41 ff d1             	callq  *%r9

	return ret;
  8018ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018f1:	48 83 c4 58          	add    $0x58,%rsp
  8018f5:	5b                   	pop    %rbx
  8018f6:	5d                   	pop    %rbp
  8018f7:	c3                   	retq   

00000000008018f8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 20          	sub    $0x20,%rsp
  801900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801904:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801910:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801917:	00 
  801918:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801924:	48 89 d1             	mov    %rdx,%rcx
  801927:	48 89 c2             	mov    %rax,%rdx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 00 00 00 00       	mov    $0x0,%edi
  801934:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_cgetc>:

int
sys_cgetc(void)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80194a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801951:	00 
  801952:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801958:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
  801968:	be 00 00 00 00       	mov    $0x0,%esi
  80196d:	bf 01 00 00 00       	mov    $0x1,%edi
  801972:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801979:	00 00 00 
  80197c:	ff d0                	callq  *%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	48 83 ec 20          	sub    $0x20,%rsp
  801988:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80198b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198e:	48 98                	cltq   
  801990:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801997:	00 
  801998:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a9:	48 89 c2             	mov    %rax,%rdx
  8019ac:	be 01 00 00 00       	mov    $0x1,%esi
  8019b1:	bf 03 00 00 00       	mov    $0x3,%edi
  8019b6:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d3:	00 
  8019d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	be 00 00 00 00       	mov    $0x0,%esi
  8019ef:	bf 02 00 00 00       	mov    $0x2,%edi
  8019f4:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8019fb:	00 00 00 
  8019fe:	ff d0                	callq  *%rax
}
  801a00:	c9                   	leaveq 
  801a01:	c3                   	retq   

0000000000801a02 <sys_yield>:

void
sys_yield(void)
{
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a11:	00 
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	be 00 00 00 00       	mov    $0x0,%esi
  801a2d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a32:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 20          	sub    $0x20,%rsp
  801a48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a55:	48 63 c8             	movslq %eax,%rcx
  801a58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5f:	48 98                	cltq   
  801a61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a68:	00 
  801a69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6f:	49 89 c8             	mov    %rcx,%r8
  801a72:	48 89 d1             	mov    %rdx,%rcx
  801a75:	48 89 c2             	mov    %rax,%rdx
  801a78:	be 01 00 00 00       	mov    $0x1,%esi
  801a7d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a82:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	callq  *%rax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 30          	sub    $0x30,%rsp
  801a98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aa2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aa6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801aaa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aad:	48 63 c8             	movslq %eax,%rcx
  801ab0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ab4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab7:	48 63 f0             	movslq %eax,%rsi
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ac7:	49 89 f9             	mov    %rdi,%r9
  801aca:	49 89 f0             	mov    %rsi,%r8
  801acd:	48 89 d1             	mov    %rdx,%rcx
  801ad0:	48 89 c2             	mov    %rax,%rdx
  801ad3:	be 01 00 00 00       	mov    $0x1,%esi
  801ad8:	bf 05 00 00 00       	mov    $0x5,%edi
  801add:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	callq  *%rax
}
  801ae9:	c9                   	leaveq 
  801aea:	c3                   	retq   

0000000000801aeb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801aeb:	55                   	push   %rbp
  801aec:	48 89 e5             	mov    %rsp,%rbp
  801aef:	48 83 ec 20          	sub    $0x20,%rsp
  801af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801afa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b01:	48 98                	cltq   
  801b03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0a:	00 
  801b0b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b11:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b17:	48 89 d1             	mov    %rdx,%rcx
  801b1a:	48 89 c2             	mov    %rax,%rdx
  801b1d:	be 01 00 00 00       	mov    $0x1,%esi
  801b22:	bf 06 00 00 00       	mov    $0x6,%edi
  801b27:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801b2e:	00 00 00 
  801b31:	ff d0                	callq  *%rax
}
  801b33:	c9                   	leaveq 
  801b34:	c3                   	retq   

0000000000801b35 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b35:	55                   	push   %rbp
  801b36:	48 89 e5             	mov    %rsp,%rbp
  801b39:	48 83 ec 20          	sub    $0x20,%rsp
  801b3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b40:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b46:	48 63 d0             	movslq %eax,%rdx
  801b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4c:	48 98                	cltq   
  801b4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b55:	00 
  801b56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b62:	48 89 d1             	mov    %rdx,%rcx
  801b65:	48 89 c2             	mov    %rax,%rdx
  801b68:	be 01 00 00 00       	mov    $0x1,%esi
  801b6d:	bf 08 00 00 00       	mov    $0x8,%edi
  801b72:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	callq  *%rax
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 20          	sub    $0x20,%rsp
  801b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b96:	48 98                	cltq   
  801b98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9f:	00 
  801ba0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bac:	48 89 d1             	mov    %rdx,%rcx
  801baf:	48 89 c2             	mov    %rax,%rdx
  801bb2:	be 01 00 00 00       	mov    $0x1,%esi
  801bb7:	bf 09 00 00 00       	mov    $0x9,%edi
  801bbc:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
}
  801bc8:	c9                   	leaveq 
  801bc9:	c3                   	retq   

0000000000801bca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	48 83 ec 20          	sub    $0x20,%rsp
  801bd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be0:	48 98                	cltq   
  801be2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be9:	00 
  801bea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf6:	48 89 d1             	mov    %rdx,%rcx
  801bf9:	48 89 c2             	mov    %rax,%rdx
  801bfc:	be 01 00 00 00       	mov    $0x1,%esi
  801c01:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c06:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 30          	sub    $0x30,%rsp
  801c1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c27:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2d:	48 63 f0             	movslq %eax,%rsi
  801c30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c37:	48 98                	cltq   
  801c39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c44:	00 
  801c45:	49 89 f1             	mov    %rsi,%r9
  801c48:	49 89 c8             	mov    %rcx,%r8
  801c4b:	48 89 d1             	mov    %rdx,%rcx
  801c4e:	48 89 c2             	mov    %rax,%rdx
  801c51:	be 00 00 00 00       	mov    $0x0,%esi
  801c56:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c5b:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801c62:	00 00 00 
  801c65:	ff d0                	callq  *%rax
}
  801c67:	c9                   	leaveq 
  801c68:	c3                   	retq   

0000000000801c69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c69:	55                   	push   %rbp
  801c6a:	48 89 e5             	mov    %rsp,%rbp
  801c6d:	48 83 ec 20          	sub    $0x20,%rsp
  801c71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c80:	00 
  801c81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c92:	48 89 c2             	mov    %rax,%rdx
  801c95:	be 01 00 00 00       	mov    $0x1,%esi
  801c9a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c9f:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801ca6:	00 00 00 
  801ca9:	ff d0                	callq  *%rax
}
  801cab:	c9                   	leaveq 
  801cac:	c3                   	retq   

0000000000801cad <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801cad:	55                   	push   %rbp
  801cae:	48 89 e5             	mov    %rsp,%rbp
  801cb1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbc:	00 
  801cbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cce:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd3:	be 00 00 00 00       	mov    $0x0,%esi
  801cd8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cdd:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	callq  *%rax
}
  801ce9:	c9                   	leaveq 
  801cea:	c3                   	retq   

0000000000801ceb <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 83 ec 30          	sub    $0x30,%rsp
  801cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cfd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d08:	48 63 c8             	movslq %eax,%rcx
  801d0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d12:	48 63 f0             	movslq %eax,%rsi
  801d15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1c:	48 98                	cltq   
  801d1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d22:	49 89 f9             	mov    %rdi,%r9
  801d25:	49 89 f0             	mov    %rsi,%r8
  801d28:	48 89 d1             	mov    %rdx,%rcx
  801d2b:	48 89 c2             	mov    %rax,%rdx
  801d2e:	be 00 00 00 00       	mov    $0x0,%esi
  801d33:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d38:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 20          	sub    $0x20,%rsp
  801d4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d65:	00 
  801d66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d72:	48 89 d1             	mov    %rdx,%rcx
  801d75:	48 89 c2             	mov    %rax,%rdx
  801d78:	be 00 00 00 00       	mov    $0x0,%esi
  801d7d:	bf 10 00 00 00       	mov    $0x10,%edi
  801d82:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 08          	sub    $0x8,%rsp
  801d98:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d9c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801da0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801da7:	ff ff ff 
  801daa:	48 01 d0             	add    %rdx,%rax
  801dad:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 08          	sub    $0x8,%rsp
  801dbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc3:	48 89 c7             	mov    %rax,%rdi
  801dc6:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  801dcd:	00 00 00 
  801dd0:	ff d0                	callq  *%rax
  801dd2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dd8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 18          	sub    $0x18,%rsp
  801de6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801df1:	eb 6b                	jmp    801e5e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df6:	48 98                	cltq   
  801df8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dfe:	48 c1 e0 0c          	shl    $0xc,%rax
  801e02:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0a:	48 89 c2             	mov    %rax,%rdx
  801e0d:	48 c1 ea 15          	shr    $0x15,%rdx
  801e11:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e18:	01 00 00 
  801e1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e1f:	83 e0 01             	and    $0x1,%eax
  801e22:	48 85 c0             	test   %rax,%rax
  801e25:	74 21                	je     801e48 <fd_alloc+0x6a>
  801e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2b:	48 89 c2             	mov    %rax,%rdx
  801e2e:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e39:	01 00 00 
  801e3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e40:	83 e0 01             	and    $0x1,%eax
  801e43:	48 85 c0             	test   %rax,%rax
  801e46:	75 12                	jne    801e5a <fd_alloc+0x7c>
			*fd_store = fd;
  801e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e50:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 1a                	jmp    801e74 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e5e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e62:	7e 8f                	jle    801df3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e68:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e6f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e74:	c9                   	leaveq 
  801e75:	c3                   	retq   

0000000000801e76 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e76:	55                   	push   %rbp
  801e77:	48 89 e5             	mov    %rsp,%rbp
  801e7a:	48 83 ec 20          	sub    $0x20,%rsp
  801e7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e89:	78 06                	js     801e91 <fd_lookup+0x1b>
  801e8b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e8f:	7e 07                	jle    801e98 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e96:	eb 6c                	jmp    801f04 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e9b:	48 98                	cltq   
  801e9d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ea3:	48 c1 e0 0c          	shl    $0xc,%rax
  801ea7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801eab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eaf:	48 89 c2             	mov    %rax,%rdx
  801eb2:	48 c1 ea 15          	shr    $0x15,%rdx
  801eb6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ebd:	01 00 00 
  801ec0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ec4:	83 e0 01             	and    $0x1,%eax
  801ec7:	48 85 c0             	test   %rax,%rax
  801eca:	74 21                	je     801eed <fd_lookup+0x77>
  801ecc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed0:	48 89 c2             	mov    %rax,%rdx
  801ed3:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ed7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ede:	01 00 00 
  801ee1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee5:	83 e0 01             	and    $0x1,%eax
  801ee8:	48 85 c0             	test   %rax,%rax
  801eeb:	75 07                	jne    801ef4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ef2:	eb 10                	jmp    801f04 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801efc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f04:	c9                   	leaveq 
  801f05:	c3                   	retq   

0000000000801f06 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f06:	55                   	push   %rbp
  801f07:	48 89 e5             	mov    %rsp,%rbp
  801f0a:	48 83 ec 30          	sub    $0x30,%rsp
  801f0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f12:	89 f0                	mov    %esi,%eax
  801f14:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1b:	48 89 c7             	mov    %rax,%rdi
  801f1e:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
  801f2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f2e:	48 89 d6             	mov    %rdx,%rsi
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
  801f3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f46:	78 0a                	js     801f52 <fd_close+0x4c>
	    || fd != fd2)
  801f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f50:	74 12                	je     801f64 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f52:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f56:	74 05                	je     801f5d <fd_close+0x57>
  801f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f5b:	eb 05                	jmp    801f62 <fd_close+0x5c>
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	eb 69                	jmp    801fcd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f68:	8b 00                	mov    (%rax),%eax
  801f6a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f6e:	48 89 d6             	mov    %rdx,%rsi
  801f71:	89 c7                	mov    %eax,%edi
  801f73:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	callq  *%rax
  801f7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f86:	78 2a                	js     801fb2 <fd_close+0xac>
		if (dev->dev_close)
  801f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f90:	48 85 c0             	test   %rax,%rax
  801f93:	74 16                	je     801fab <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f99:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa1:	48 89 c7             	mov    %rax,%rdi
  801fa4:	ff d2                	callq  *%rdx
  801fa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa9:	eb 07                	jmp    801fb2 <fd_close+0xac>
		else
			r = 0;
  801fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb6:	48 89 c6             	mov    %rax,%rsi
  801fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbe:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
	return r;
  801fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fcd:	c9                   	leaveq 
  801fce:	c3                   	retq   

0000000000801fcf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fcf:	55                   	push   %rbp
  801fd0:	48 89 e5             	mov    %rsp,%rbp
  801fd3:	48 83 ec 20          	sub    $0x20,%rsp
  801fd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fe5:	eb 41                	jmp    802028 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fe7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fee:	00 00 00 
  801ff1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff4:	48 63 d2             	movslq %edx,%rdx
  801ff7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffb:	8b 00                	mov    (%rax),%eax
  801ffd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802000:	75 22                	jne    802024 <dev_lookup+0x55>
			*dev = devtab[i];
  802002:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802009:	00 00 00 
  80200c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80200f:	48 63 d2             	movslq %edx,%rdx
  802012:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802016:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80201a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
  802022:	eb 60                	jmp    802084 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802024:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802028:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80202f:	00 00 00 
  802032:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802035:	48 63 d2             	movslq %edx,%rdx
  802038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203c:	48 85 c0             	test   %rax,%rax
  80203f:	75 a6                	jne    801fe7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802041:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802048:	00 00 00 
  80204b:	48 8b 00             	mov    (%rax),%rax
  80204e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802054:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802057:	89 c6                	mov    %eax,%esi
  802059:	48 bf 98 45 80 00 00 	movabs $0x804598,%rdi
  802060:	00 00 00 
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	48 b9 37 05 80 00 00 	movabs $0x800537,%rcx
  80206f:	00 00 00 
  802072:	ff d1                	callq  *%rcx
	*dev = 0;
  802074:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802078:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80207f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802084:	c9                   	leaveq 
  802085:	c3                   	retq   

0000000000802086 <close>:

int
close(int fdnum)
{
  802086:	55                   	push   %rbp
  802087:	48 89 e5             	mov    %rsp,%rbp
  80208a:	48 83 ec 20          	sub    $0x20,%rsp
  80208e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802091:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802095:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802098:	48 89 d6             	mov    %rdx,%rsi
  80209b:	89 c7                	mov    %eax,%edi
  80209d:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  8020a4:	00 00 00 
  8020a7:	ff d0                	callq  *%rax
  8020a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b0:	79 05                	jns    8020b7 <close+0x31>
		return r;
  8020b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b5:	eb 18                	jmp    8020cf <close+0x49>
	else
		return fd_close(fd, 1);
  8020b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bb:	be 01 00 00 00       	mov    $0x1,%esi
  8020c0:	48 89 c7             	mov    %rax,%rdi
  8020c3:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8020ca:	00 00 00 
  8020cd:	ff d0                	callq  *%rax
}
  8020cf:	c9                   	leaveq 
  8020d0:	c3                   	retq   

00000000008020d1 <close_all>:

void
close_all(void)
{
  8020d1:	55                   	push   %rbp
  8020d2:	48 89 e5             	mov    %rsp,%rbp
  8020d5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e0:	eb 15                	jmp    8020f7 <close_all+0x26>
		close(i);
  8020e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e5:	89 c7                	mov    %eax,%edi
  8020e7:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020fb:	7e e5                	jle    8020e2 <close_all+0x11>
		close(i);
}
  8020fd:	c9                   	leaveq 
  8020fe:	c3                   	retq   

00000000008020ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020ff:	55                   	push   %rbp
  802100:	48 89 e5             	mov    %rsp,%rbp
  802103:	48 83 ec 40          	sub    $0x40,%rsp
  802107:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80210a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80210d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802111:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802114:	48 89 d6             	mov    %rdx,%rsi
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212c:	79 08                	jns    802136 <dup+0x37>
		return r;
  80212e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802131:	e9 70 01 00 00       	jmpq   8022a6 <dup+0x1a7>
	close(newfdnum);
  802136:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802139:	89 c7                	mov    %eax,%edi
  80213b:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  802142:	00 00 00 
  802145:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802147:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80214a:	48 98                	cltq   
  80214c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802152:	48 c1 e0 0c          	shl    $0xc,%rax
  802156:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80215a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215e:	48 89 c7             	mov    %rax,%rdi
  802161:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
  80216d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802175:	48 89 c7             	mov    %rax,%rdi
  802178:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  80217f:	00 00 00 
  802182:	ff d0                	callq  *%rax
  802184:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	48 89 c2             	mov    %rax,%rdx
  80218f:	48 c1 ea 15          	shr    $0x15,%rdx
  802193:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80219a:	01 00 00 
  80219d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a1:	83 e0 01             	and    $0x1,%eax
  8021a4:	84 c0                	test   %al,%al
  8021a6:	74 71                	je     802219 <dup+0x11a>
  8021a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ac:	48 89 c2             	mov    %rax,%rdx
  8021af:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ba:	01 00 00 
  8021bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c1:	83 e0 01             	and    $0x1,%eax
  8021c4:	84 c0                	test   %al,%al
  8021c6:	74 51                	je     802219 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	48 89 c2             	mov    %rax,%rdx
  8021cf:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021da:	01 00 00 
  8021dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e1:	89 c1                	mov    %eax,%ecx
  8021e3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f1:	41 89 c8             	mov    %ecx,%r8d
  8021f4:	48 89 d1             	mov    %rdx,%rcx
  8021f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021fc:	48 89 c6             	mov    %rax,%rsi
  8021ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802204:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
  802210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802217:	78 56                	js     80226f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80221d:	48 89 c2             	mov    %rax,%rdx
  802220:	48 c1 ea 0c          	shr    $0xc,%rdx
  802224:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222b:	01 00 00 
  80222e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802232:	89 c1                	mov    %eax,%ecx
  802234:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80223a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802242:	41 89 c8             	mov    %ecx,%r8d
  802245:	48 89 d1             	mov    %rdx,%rcx
  802248:	ba 00 00 00 00       	mov    $0x0,%edx
  80224d:	48 89 c6             	mov    %rax,%rsi
  802250:	bf 00 00 00 00       	mov    $0x0,%edi
  802255:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802268:	78 08                	js     802272 <dup+0x173>
		goto err;

	return newfdnum;
  80226a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80226d:	eb 37                	jmp    8022a6 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80226f:	90                   	nop
  802270:	eb 01                	jmp    802273 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802272:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802277:	48 89 c6             	mov    %rax,%rsi
  80227a:	bf 00 00 00 00       	mov    $0x0,%edi
  80227f:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  802286:	00 00 00 
  802289:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80228b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80228f:	48 89 c6             	mov    %rax,%rsi
  802292:	bf 00 00 00 00       	mov    $0x0,%edi
  802297:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
	return r;
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022a6:	c9                   	leaveq 
  8022a7:	c3                   	retq   

00000000008022a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022a8:	55                   	push   %rbp
  8022a9:	48 89 e5             	mov    %rsp,%rbp
  8022ac:	48 83 ec 40          	sub    $0x40,%rsp
  8022b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c2:	48 89 d6             	mov    %rdx,%rsi
  8022c5:	89 c7                	mov    %eax,%edi
  8022c7:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  8022ce:	00 00 00 
  8022d1:	ff d0                	callq  *%rax
  8022d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022da:	78 24                	js     802300 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e0:	8b 00                	mov    (%rax),%eax
  8022e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022e6:	48 89 d6             	mov    %rdx,%rsi
  8022e9:	89 c7                	mov    %eax,%edi
  8022eb:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	callq  *%rax
  8022f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fe:	79 05                	jns    802305 <read+0x5d>
		return r;
  802300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802303:	eb 7a                	jmp    80237f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802309:	8b 40 08             	mov    0x8(%rax),%eax
  80230c:	83 e0 03             	and    $0x3,%eax
  80230f:	83 f8 01             	cmp    $0x1,%eax
  802312:	75 3a                	jne    80234e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802314:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80231b:	00 00 00 
  80231e:	48 8b 00             	mov    (%rax),%rax
  802321:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802327:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232a:	89 c6                	mov    %eax,%esi
  80232c:	48 bf b7 45 80 00 00 	movabs $0x8045b7,%rdi
  802333:	00 00 00 
  802336:	b8 00 00 00 00       	mov    $0x0,%eax
  80233b:	48 b9 37 05 80 00 00 	movabs $0x800537,%rcx
  802342:	00 00 00 
  802345:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234c:	eb 31                	jmp    80237f <read+0xd7>
	}
	if (!dev->dev_read)
  80234e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802352:	48 8b 40 10          	mov    0x10(%rax),%rax
  802356:	48 85 c0             	test   %rax,%rax
  802359:	75 07                	jne    802362 <read+0xba>
		return -E_NOT_SUPP;
  80235b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802360:	eb 1d                	jmp    80237f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802366:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80236a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802372:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802376:	48 89 ce             	mov    %rcx,%rsi
  802379:	48 89 c7             	mov    %rax,%rdi
  80237c:	41 ff d0             	callq  *%r8
}
  80237f:	c9                   	leaveq 
  802380:	c3                   	retq   

0000000000802381 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802381:	55                   	push   %rbp
  802382:	48 89 e5             	mov    %rsp,%rbp
  802385:	48 83 ec 30          	sub    $0x30,%rsp
  802389:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80238c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802390:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80239b:	eb 46                	jmp    8023e3 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80239d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a0:	48 98                	cltq   
  8023a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023a6:	48 29 c2             	sub    %rax,%rdx
  8023a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ac:	48 98                	cltq   
  8023ae:	48 89 c1             	mov    %rax,%rcx
  8023b1:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8023b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023b8:	48 89 ce             	mov    %rcx,%rsi
  8023bb:	89 c7                	mov    %eax,%edi
  8023bd:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	callq  *%rax
  8023c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023cc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d0:	79 05                	jns    8023d7 <readn+0x56>
			return m;
  8023d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d5:	eb 1d                	jmp    8023f4 <readn+0x73>
		if (m == 0)
  8023d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023db:	74 13                	je     8023f0 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e6:	48 98                	cltq   
  8023e8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023ec:	72 af                	jb     80239d <readn+0x1c>
  8023ee:	eb 01                	jmp    8023f1 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023f0:	90                   	nop
	}
	return tot;
  8023f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023f4:	c9                   	leaveq 
  8023f5:	c3                   	retq   

00000000008023f6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023f6:	55                   	push   %rbp
  8023f7:	48 89 e5             	mov    %rsp,%rbp
  8023fa:	48 83 ec 40          	sub    $0x40,%rsp
  8023fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802401:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802405:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802409:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80240d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802428:	78 24                	js     80244e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80242a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242e:	8b 00                	mov    (%rax),%eax
  802430:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802434:	48 89 d6             	mov    %rdx,%rsi
  802437:	89 c7                	mov    %eax,%edi
  802439:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
  802445:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802448:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244c:	79 05                	jns    802453 <write+0x5d>
		return r;
  80244e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802451:	eb 79                	jmp    8024cc <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802457:	8b 40 08             	mov    0x8(%rax),%eax
  80245a:	83 e0 03             	and    $0x3,%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	75 3a                	jne    80249b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802461:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802468:	00 00 00 
  80246b:	48 8b 00             	mov    (%rax),%rax
  80246e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802474:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802477:	89 c6                	mov    %eax,%esi
  802479:	48 bf d3 45 80 00 00 	movabs $0x8045d3,%rdi
  802480:	00 00 00 
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	48 b9 37 05 80 00 00 	movabs $0x800537,%rcx
  80248f:	00 00 00 
  802492:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802494:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802499:	eb 31                	jmp    8024cc <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80249b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a3:	48 85 c0             	test   %rax,%rax
  8024a6:	75 07                	jne    8024af <write+0xb9>
		return -E_NOT_SUPP;
  8024a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024ad:	eb 1d                	jmp    8024cc <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8024af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b3:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8024b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024bf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024c3:	48 89 ce             	mov    %rcx,%rsi
  8024c6:	48 89 c7             	mov    %rax,%rdi
  8024c9:	41 ff d0             	callq  *%r8
}
  8024cc:	c9                   	leaveq 
  8024cd:	c3                   	retq   

00000000008024ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8024ce:	55                   	push   %rbp
  8024cf:	48 89 e5             	mov    %rsp,%rbp
  8024d2:	48 83 ec 18          	sub    $0x18,%rsp
  8024d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	79 05                	jns    802502 <seek+0x34>
		return r;
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	eb 0f                	jmp    802511 <seek+0x43>
	fd->fd_offset = offset;
  802502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802506:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802509:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 30          	sub    $0x30,%rsp
  80251b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80251e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802521:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802525:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	89 c7                	mov    %eax,%edi
  80252d:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802540:	78 24                	js     802566 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	8b 00                	mov    (%rax),%eax
  802548:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254c:	48 89 d6             	mov    %rdx,%rsi
  80254f:	89 c7                	mov    %eax,%edi
  802551:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802564:	79 05                	jns    80256b <ftruncate+0x58>
		return r;
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	eb 72                	jmp    8025dd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256f:	8b 40 08             	mov    0x8(%rax),%eax
  802572:	83 e0 03             	and    $0x3,%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	75 3a                	jne    8025b3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802579:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802580:	00 00 00 
  802583:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802586:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80258c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80258f:	89 c6                	mov    %eax,%esi
  802591:	48 bf f0 45 80 00 00 	movabs $0x8045f0,%rdi
  802598:	00 00 00 
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	48 b9 37 05 80 00 00 	movabs $0x800537,%rcx
  8025a7:	00 00 00 
  8025aa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b1:	eb 2a                	jmp    8025dd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025bb:	48 85 c0             	test   %rax,%rax
  8025be:	75 07                	jne    8025c7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c5:	eb 16                	jmp    8025dd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025d6:	89 d6                	mov    %edx,%esi
  8025d8:	48 89 c7             	mov    %rax,%rdi
  8025db:	ff d1                	callq  *%rcx
}
  8025dd:	c9                   	leaveq 
  8025de:	c3                   	retq   

00000000008025df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025df:	55                   	push   %rbp
  8025e0:	48 89 e5             	mov    %rsp,%rbp
  8025e3:	48 83 ec 30          	sub    $0x30,%rsp
  8025e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f5:	48 89 d6             	mov    %rdx,%rsi
  8025f8:	89 c7                	mov    %eax,%edi
  8025fa:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  802601:	00 00 00 
  802604:	ff d0                	callq  *%rax
  802606:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802609:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260d:	78 24                	js     802633 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802613:	8b 00                	mov    (%rax),%eax
  802615:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802619:	48 89 d6             	mov    %rdx,%rsi
  80261c:	89 c7                	mov    %eax,%edi
  80261e:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802625:	00 00 00 
  802628:	ff d0                	callq  *%rax
  80262a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802631:	79 05                	jns    802638 <fstat+0x59>
		return r;
  802633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802636:	eb 5e                	jmp    802696 <fstat+0xb7>
	if (!dev->dev_stat)
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802640:	48 85 c0             	test   %rax,%rax
  802643:	75 07                	jne    80264c <fstat+0x6d>
		return -E_NOT_SUPP;
  802645:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80264a:	eb 4a                	jmp    802696 <fstat+0xb7>
	stat->st_name[0] = 0;
  80264c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802650:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802653:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802657:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80265e:	00 00 00 
	stat->st_isdir = 0;
  802661:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802665:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80266c:	00 00 00 
	stat->st_dev = dev;
  80266f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802673:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802677:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80267e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802682:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80268e:	48 89 d6             	mov    %rdx,%rsi
  802691:	48 89 c7             	mov    %rax,%rdi
  802694:	ff d1                	callq  *%rcx
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 20          	sub    $0x20,%rsp
  8026a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ac:	be 00 00 00 00       	mov    $0x0,%esi
  8026b1:	48 89 c7             	mov    %rax,%rdi
  8026b4:	48 b8 87 27 80 00 00 	movabs $0x802787,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c7:	79 05                	jns    8026ce <stat+0x36>
		return fd;
  8026c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cc:	eb 2f                	jmp    8026fd <stat+0x65>
	r = fstat(fd, stat);
  8026ce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d5:	48 89 d6             	mov    %rdx,%rsi
  8026d8:	89 c7                	mov    %eax,%edi
  8026da:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ec:	89 c7                	mov    %eax,%edi
  8026ee:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
	return r;
  8026fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   
	...

0000000000802700 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802700:	55                   	push   %rbp
  802701:	48 89 e5             	mov    %rsp,%rbp
  802704:	48 83 ec 10          	sub    $0x10,%rsp
  802708:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80270b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80270f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802716:	00 00 00 
  802719:	8b 00                	mov    (%rax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	75 1d                	jne    80273c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80271f:	bf 01 00 00 00       	mov    $0x1,%edi
  802724:	48 b8 de 3e 80 00 00 	movabs $0x803ede,%rax
  80272b:	00 00 00 
  80272e:	ff d0                	callq  *%rax
  802730:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802737:	00 00 00 
  80273a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80273c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802743:	00 00 00 
  802746:	8b 00                	mov    (%rax),%eax
  802748:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80274b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802750:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802757:	00 00 00 
  80275a:	89 c7                	mov    %eax,%edi
  80275c:	48 b8 2f 3e 80 00 00 	movabs $0x803e2f,%rax
  802763:	00 00 00 
  802766:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276c:	ba 00 00 00 00       	mov    $0x0,%edx
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	bf 00 00 00 00       	mov    $0x0,%edi
  802779:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
}
  802785:	c9                   	leaveq 
  802786:	c3                   	retq   

0000000000802787 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802787:	55                   	push   %rbp
  802788:	48 89 e5             	mov    %rsp,%rbp
  80278b:	48 83 ec 20          	sub    $0x20,%rsp
  80278f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802793:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279a:	48 89 c7             	mov    %rax,%rdi
  80279d:	48 b8 9c 10 80 00 00 	movabs $0x80109c,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax
  8027a9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027ae:	7e 0a                	jle    8027ba <open+0x33>
		return -E_BAD_PATH;
  8027b0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027b5:	e9 a5 00 00 00       	jmpq   80285f <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8027ba:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027be:	48 89 c7             	mov    %rax,%rdi
  8027c1:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8027d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d4:	79 08                	jns    8027de <open+0x57>
		return r;
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d9:	e9 81 00 00 00       	jmpq   80285f <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8027de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8027e5:	00 00 00 
  8027e8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027eb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8027f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f5:	48 89 c6             	mov    %rax,%rsi
  8027f8:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8027ff:	00 00 00 
  802802:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80280e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802812:	48 89 c6             	mov    %rax,%rsi
  802815:	bf 01 00 00 00       	mov    $0x1,%edi
  80281a:	48 b8 00 27 80 00 00 	movabs $0x802700,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
  802826:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282d:	79 1d                	jns    80284c <open+0xc5>
		fd_close(new_fd, 0);
  80282f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802833:	be 00 00 00 00       	mov    $0x0,%esi
  802838:	48 89 c7             	mov    %rax,%rdi
  80283b:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
		return r;	
  802847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284a:	eb 13                	jmp    80285f <open+0xd8>
	}
	return fd2num(new_fd);
  80284c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802850:	48 89 c7             	mov    %rax,%rdi
  802853:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
}
  80285f:	c9                   	leaveq 
  802860:	c3                   	retq   

0000000000802861 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802861:	55                   	push   %rbp
  802862:	48 89 e5             	mov    %rsp,%rbp
  802865:	48 83 ec 10          	sub    $0x10,%rsp
  802869:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80286d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802871:	8b 50 0c             	mov    0xc(%rax),%edx
  802874:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80287b:	00 00 00 
  80287e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802880:	be 00 00 00 00       	mov    $0x0,%esi
  802885:	bf 06 00 00 00       	mov    $0x6,%edi
  80288a:	48 b8 00 27 80 00 00 	movabs $0x802700,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
}
  802896:	c9                   	leaveq 
  802897:	c3                   	retq   

0000000000802898 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802898:	55                   	push   %rbp
  802899:	48 89 e5             	mov    %rsp,%rbp
  80289c:	48 83 ec 30          	sub    $0x30,%rsp
  8028a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8028ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b0:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028ba:	00 00 00 
  8028bd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028c6:	00 00 00 
  8028c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028cd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8028d1:	be 00 00 00 00       	mov    $0x0,%esi
  8028d6:	bf 03 00 00 00       	mov    $0x3,%edi
  8028db:	48 b8 00 27 80 00 00 	movabs $0x802700,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
  8028e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8028ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ee:	7e 23                	jle    802913 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8028f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f3:	48 63 d0             	movslq %eax,%rdx
  8028f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fa:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802901:	00 00 00 
  802904:	48 89 c7             	mov    %rax,%rdi
  802907:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax
	}
	return nbytes;
  802913:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802916:	c9                   	leaveq 
  802917:	c3                   	retq   

0000000000802918 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802918:	55                   	push   %rbp
  802919:	48 89 e5             	mov    %rsp,%rbp
  80291c:	48 83 ec 20          	sub    $0x20,%rsp
  802920:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802924:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292c:	8b 50 0c             	mov    0xc(%rax),%edx
  80292f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802936:	00 00 00 
  802939:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80293b:	be 00 00 00 00       	mov    $0x0,%esi
  802940:	bf 05 00 00 00       	mov    $0x5,%edi
  802945:	48 b8 00 27 80 00 00 	movabs $0x802700,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax
  802951:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802954:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802958:	79 05                	jns    80295f <devfile_stat+0x47>
		return r;
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	eb 56                	jmp    8029b5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80295f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802963:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80296a:	00 00 00 
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80297c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802983:	00 00 00 
  802986:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80298c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802990:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802996:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80299d:	00 00 00 
  8029a0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029aa:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   
	...

00000000008029b8 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 20          	sub    $0x20,%rsp
  8029c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8029c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c8:	8b 40 0c             	mov    0xc(%rax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	7e 67                	jle    802a36 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8029cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d3:	8b 40 04             	mov    0x4(%rax),%eax
  8029d6:	48 63 d0             	movslq %eax,%rdx
  8029d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029dd:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8029e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e5:	8b 00                	mov    (%rax),%eax
  8029e7:	48 89 ce             	mov    %rcx,%rsi
  8029ea:	89 c7                	mov    %eax,%edi
  8029ec:	48 b8 f6 23 80 00 00 	movabs $0x8023f6,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax
  8029f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8029fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ff:	7e 13                	jle    802a14 <writebuf+0x5c>
			b->result += result;
  802a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a05:	8b 40 08             	mov    0x8(%rax),%eax
  802a08:	89 c2                	mov    %eax,%edx
  802a0a:	03 55 fc             	add    -0x4(%rbp),%edx
  802a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a11:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	8b 40 04             	mov    0x4(%rax),%eax
  802a1b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802a1e:	74 16                	je     802a36 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
  802a25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a29:	89 c2                	mov    %eax,%edx
  802a2b:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802a36:	c9                   	leaveq 
  802a37:	c3                   	retq   

0000000000802a38 <putch>:

static void
putch(int ch, void *thunk)
{
  802a38:	55                   	push   %rbp
  802a39:	48 89 e5             	mov    %rsp,%rbp
  802a3c:	48 83 ec 20          	sub    $0x20,%rsp
  802a40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802a47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802a4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a53:	8b 40 04             	mov    0x4(%rax),%eax
  802a56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a59:	89 d6                	mov    %edx,%esi
  802a5b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802a5f:	48 63 d0             	movslq %eax,%rdx
  802a62:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802a67:	8d 50 01             	lea    0x1(%rax),%edx
  802a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6e:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802a71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a75:	8b 40 04             	mov    0x4(%rax),%eax
  802a78:	3d 00 01 00 00       	cmp    $0x100,%eax
  802a7d:	75 1e                	jne    802a9d <putch+0x65>
		writebuf(b);
  802a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a83:	48 89 c7             	mov    %rax,%rdi
  802a86:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
		b->idx = 0;
  802a92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802a9d:	c9                   	leaveq 
  802a9e:	c3                   	retq   

0000000000802a9f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802a9f:	55                   	push   %rbp
  802aa0:	48 89 e5             	mov    %rsp,%rbp
  802aa3:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802aaa:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ab0:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802ab7:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802abe:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ac4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802aca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802ad1:	00 00 00 
	b.result = 0;
  802ad4:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802adb:	00 00 00 
	b.error = 1;
  802ade:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802ae5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802ae8:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802aef:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802af6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802afd:	48 89 c6             	mov    %rax,%rsi
  802b00:	48 bf 38 2a 80 00 00 	movabs $0x802a38,%rdi
  802b07:	00 00 00 
  802b0a:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802b16:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	7e 16                	jle    802b36 <vfprintf+0x97>
		writebuf(&b);
  802b20:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802b27:	48 89 c7             	mov    %rax,%rdi
  802b2a:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802b36:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	74 08                	je     802b48 <vfprintf+0xa9>
  802b40:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802b46:	eb 06                	jmp    802b4e <vfprintf+0xaf>
  802b48:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802b4e:	c9                   	leaveq 
  802b4f:	c3                   	retq   

0000000000802b50 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802b5b:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802b61:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802b68:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b6f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b76:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b7d:	84 c0                	test   %al,%al
  802b7f:	74 20                	je     802ba1 <fprintf+0x51>
  802b81:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b85:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b89:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b8d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b91:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b95:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b99:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b9d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ba1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ba8:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802baf:	00 00 00 
  802bb2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802bb9:	00 00 00 
  802bbc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bc0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802bc7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802bce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802bd5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802bdc:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802be3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802be9:	48 89 ce             	mov    %rcx,%rsi
  802bec:	89 c7                	mov    %eax,%edi
  802bee:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  802bf5:	00 00 00 
  802bf8:	ff d0                	callq  *%rax
  802bfa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802c00:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802c06:	c9                   	leaveq 
  802c07:	c3                   	retq   

0000000000802c08 <printf>:

int
printf(const char *fmt, ...)
{
  802c08:	55                   	push   %rbp
  802c09:	48 89 e5             	mov    %rsp,%rbp
  802c0c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802c13:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802c1a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802c21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802c28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802c2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802c36:	84 c0                	test   %al,%al
  802c38:	74 20                	je     802c5a <printf+0x52>
  802c3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802c3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802c42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802c46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802c4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802c4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802c52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802c56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802c5a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802c61:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802c68:	00 00 00 
  802c6b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802c72:	00 00 00 
  802c75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c79:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802c80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802c87:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802c8e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802c95:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802c9c:	48 89 c6             	mov    %rax,%rsi
  802c9f:	bf 01 00 00 00       	mov    $0x1,%edi
  802ca4:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	callq  *%rax
  802cb0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802cb6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802cbc:	c9                   	leaveq 
  802cbd:	c3                   	retq   
	...

0000000000802cc0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802cc0:	55                   	push   %rbp
  802cc1:	48 89 e5             	mov    %rsp,%rbp
  802cc4:	48 83 ec 20          	sub    $0x20,%rsp
  802cc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802ccb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd2:	48 89 d6             	mov    %rdx,%rsi
  802cd5:	89 c7                	mov    %eax,%edi
  802cd7:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	callq  *%rax
  802ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cea:	79 05                	jns    802cf1 <fd2sockid+0x31>
		return r;
  802cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cef:	eb 24                	jmp    802d15 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf5:	8b 10                	mov    (%rax),%edx
  802cf7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802cfe:	00 00 00 
  802d01:	8b 00                	mov    (%rax),%eax
  802d03:	39 c2                	cmp    %eax,%edx
  802d05:	74 07                	je     802d0e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d07:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d0c:	eb 07                	jmp    802d15 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d12:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d15:	c9                   	leaveq 
  802d16:	c3                   	retq   

0000000000802d17 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 20          	sub    $0x20,%rsp
  802d1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d22:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d26:	48 89 c7             	mov    %rax,%rdi
  802d29:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	78 26                	js     802d64 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d42:	ba 07 04 00 00       	mov    $0x407,%edx
  802d47:	48 89 c6             	mov    %rax,%rsi
  802d4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4f:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	79 16                	jns    802d7a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
		return r;
  802d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d78:	eb 3a                	jmp    802db4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802d85:	00 00 00 
  802d88:	8b 12                	mov    (%rdx),%edx
  802d8a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d9e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da5:	48 89 c7             	mov    %rax,%rdi
  802da8:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
}
  802db4:	c9                   	leaveq 
  802db5:	c3                   	retq   

0000000000802db6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802db6:	55                   	push   %rbp
  802db7:	48 89 e5             	mov    %rsp,%rbp
  802dba:	48 83 ec 30          	sub    $0x30,%rsp
  802dbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dc5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
  802dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de1:	79 05                	jns    802de8 <accept+0x32>
		return r;
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	eb 3b                	jmp    802e23 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802de8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dec:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df3:	48 89 ce             	mov    %rcx,%rsi
  802df6:	89 c7                	mov    %eax,%edi
  802df8:	48 b8 01 31 80 00 00 	movabs $0x803101,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
  802e04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0b:	79 05                	jns    802e12 <accept+0x5c>
		return r;
  802e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e10:	eb 11                	jmp    802e23 <accept+0x6d>
	return alloc_sockfd(r);
  802e12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e15:	89 c7                	mov    %eax,%edi
  802e17:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802e1e:	00 00 00 
  802e21:	ff d0                	callq  *%rax
}
  802e23:	c9                   	leaveq 
  802e24:	c3                   	retq   

0000000000802e25 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e25:	55                   	push   %rbp
  802e26:	48 89 e5             	mov    %rsp,%rbp
  802e29:	48 83 ec 20          	sub    $0x20,%rsp
  802e2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e34:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e3a:	89 c7                	mov    %eax,%edi
  802e3c:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
  802e48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4f:	79 05                	jns    802e56 <bind+0x31>
		return r;
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e54:	eb 1b                	jmp    802e71 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e56:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e59:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e60:	48 89 ce             	mov    %rcx,%rsi
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 80 31 80 00 00 	movabs $0x803180,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <shutdown>:

int
shutdown(int s, int how)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 20          	sub    $0x20,%rsp
  802e7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e84:	89 c7                	mov    %eax,%edi
  802e86:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
  802e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e99:	79 05                	jns    802ea0 <shutdown+0x2d>
		return r;
  802e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9e:	eb 16                	jmp    802eb6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802ea0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea6:	89 d6                	mov    %edx,%esi
  802ea8:	89 c7                	mov    %eax,%edi
  802eaa:	48 b8 e4 31 80 00 00 	movabs $0x8031e4,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
}
  802eb6:	c9                   	leaveq 
  802eb7:	c3                   	retq   

0000000000802eb8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802eb8:	55                   	push   %rbp
  802eb9:	48 89 e5             	mov    %rsp,%rbp
  802ebc:	48 83 ec 10          	sub    $0x10,%rsp
  802ec0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec8:	48 89 c7             	mov    %rax,%rdi
  802ecb:	48 b8 6c 3f 80 00 00 	movabs $0x803f6c,%rax
  802ed2:	00 00 00 
  802ed5:	ff d0                	callq  *%rax
  802ed7:	83 f8 01             	cmp    $0x1,%eax
  802eda:	75 17                	jne    802ef3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee0:	8b 40 0c             	mov    0xc(%rax),%eax
  802ee3:	89 c7                	mov    %eax,%edi
  802ee5:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
  802ef1:	eb 05                	jmp    802ef8 <devsock_close+0x40>
	else
		return 0;
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	48 83 ec 20          	sub    $0x20,%rsp
  802f02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f09:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0f:	89 c7                	mov    %eax,%edi
  802f11:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f24:	79 05                	jns    802f2b <connect+0x31>
		return r;
  802f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f29:	eb 1b                	jmp    802f46 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f2b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f2e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	48 89 ce             	mov    %rcx,%rsi
  802f38:	89 c7                	mov    %eax,%edi
  802f3a:	48 b8 51 32 80 00 00 	movabs $0x803251,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <listen>:

int
listen(int s, int backlog)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 20          	sub    $0x20,%rsp
  802f50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f53:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f59:	89 c7                	mov    %eax,%edi
  802f5b:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6e:	79 05                	jns    802f75 <listen+0x2d>
		return r;
  802f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f73:	eb 16                	jmp    802f8b <listen+0x43>
	return nsipc_listen(r, backlog);
  802f75:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7b:	89 d6                	mov    %edx,%esi
  802f7d:	89 c7                	mov    %eax,%edi
  802f7f:	48 b8 b5 32 80 00 00 	movabs $0x8032b5,%rax
  802f86:	00 00 00 
  802f89:	ff d0                	callq  *%rax
}
  802f8b:	c9                   	leaveq 
  802f8c:	c3                   	retq   

0000000000802f8d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802f8d:	55                   	push   %rbp
  802f8e:	48 89 e5             	mov    %rsp,%rbp
  802f91:	48 83 ec 20          	sub    $0x20,%rsp
  802f95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa5:	89 c2                	mov    %eax,%edx
  802fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fab:	8b 40 0c             	mov    0xc(%rax),%eax
  802fae:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fb7:	89 c7                	mov    %eax,%edi
  802fb9:	48 b8 f5 32 80 00 00 	movabs $0x8032f5,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
}
  802fc5:	c9                   	leaveq 
  802fc6:	c3                   	retq   

0000000000802fc7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 83 ec 20          	sub    $0x20,%rsp
  802fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdf:	89 c2                	mov    %eax,%edx
  802fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe5:	8b 40 0c             	mov    0xc(%rax),%eax
  802fe8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fec:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	48 b8 c1 33 80 00 00 	movabs $0x8033c1,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
}
  802fff:	c9                   	leaveq 
  803000:	c3                   	retq   

0000000000803001 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 83 ec 10          	sub    $0x10,%rsp
  803009:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80300d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803011:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803015:	48 be 1b 46 80 00 00 	movabs $0x80461b,%rsi
  80301c:	00 00 00 
  80301f:	48 89 c7             	mov    %rax,%rdi
  803022:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
	return 0;
  80302e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803033:	c9                   	leaveq 
  803034:	c3                   	retq   

0000000000803035 <socket>:

int
socket(int domain, int type, int protocol)
{
  803035:	55                   	push   %rbp
  803036:	48 89 e5             	mov    %rsp,%rbp
  803039:	48 83 ec 20          	sub    $0x20,%rsp
  80303d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803040:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803043:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803046:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803049:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80304c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304f:	89 ce                	mov    %ecx,%esi
  803051:	89 c7                	mov    %eax,%edi
  803053:	48 b8 79 34 80 00 00 	movabs $0x803479,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803066:	79 05                	jns    80306d <socket+0x38>
		return r;
  803068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306b:	eb 11                	jmp    80307e <socket+0x49>
	return alloc_sockfd(r);
  80306d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803070:	89 c7                	mov    %eax,%edi
  803072:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
}
  80307e:	c9                   	leaveq 
  80307f:	c3                   	retq   

0000000000803080 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803080:	55                   	push   %rbp
  803081:	48 89 e5             	mov    %rsp,%rbp
  803084:	48 83 ec 10          	sub    $0x10,%rsp
  803088:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80308b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803092:	00 00 00 
  803095:	8b 00                	mov    (%rax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	75 1d                	jne    8030b8 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80309b:	bf 02 00 00 00       	mov    $0x2,%edi
  8030a0:	48 b8 de 3e 80 00 00 	movabs $0x803ede,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
  8030ac:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030b3:	00 00 00 
  8030b6:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030b8:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030bf:	00 00 00 
  8030c2:	8b 00                	mov    (%rax),%eax
  8030c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030c7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030cc:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  8030d3:	00 00 00 
  8030d6:	89 c7                	mov    %eax,%edi
  8030d8:	48 b8 2f 3e 80 00 00 	movabs $0x803e2f,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8030e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e9:	be 00 00 00 00       	mov    $0x0,%esi
  8030ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f3:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
}
  8030ff:	c9                   	leaveq 
  803100:	c3                   	retq   

0000000000803101 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803101:	55                   	push   %rbp
  803102:	48 89 e5             	mov    %rsp,%rbp
  803105:	48 83 ec 30          	sub    $0x30,%rsp
  803109:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80310c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803110:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803114:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80311b:	00 00 00 
  80311e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803121:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803123:	bf 01 00 00 00       	mov    $0x1,%edi
  803128:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
  803134:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313b:	78 3e                	js     80317b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80313d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803144:	00 00 00 
  803147:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80314b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314f:	8b 40 10             	mov    0x10(%rax),%eax
  803152:	89 c2                	mov    %eax,%edx
  803154:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803158:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315c:	48 89 ce             	mov    %rcx,%rsi
  80315f:	48 89 c7             	mov    %rax,%rdi
  803162:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80316e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803172:	8b 50 10             	mov    0x10(%rax),%edx
  803175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803179:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80317b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80317e:	c9                   	leaveq 
  80317f:	c3                   	retq   

0000000000803180 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803180:	55                   	push   %rbp
  803181:	48 89 e5             	mov    %rsp,%rbp
  803184:	48 83 ec 10          	sub    $0x10,%rsp
  803188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80318b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80318f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803192:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803199:	00 00 00 
  80319c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80319f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a8:	48 89 c6             	mov    %rax,%rsi
  8031ab:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8031b2:	00 00 00 
  8031b5:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8031c1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8031c8:	00 00 00 
  8031cb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031ce:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8031d1:	bf 02 00 00 00       	mov    $0x2,%edi
  8031d6:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
}
  8031e2:	c9                   	leaveq 
  8031e3:	c3                   	retq   

00000000008031e4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8031e4:	55                   	push   %rbp
  8031e5:	48 89 e5             	mov    %rsp,%rbp
  8031e8:	48 83 ec 10          	sub    $0x10,%rsp
  8031ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031ef:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8031f2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8031f9:	00 00 00 
  8031fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803201:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803208:	00 00 00 
  80320b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80320e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803211:	bf 03 00 00 00       	mov    $0x3,%edi
  803216:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax
}
  803222:	c9                   	leaveq 
  803223:	c3                   	retq   

0000000000803224 <nsipc_close>:

int
nsipc_close(int s)
{
  803224:	55                   	push   %rbp
  803225:	48 89 e5             	mov    %rsp,%rbp
  803228:	48 83 ec 10          	sub    $0x10,%rsp
  80322c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80322f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803236:	00 00 00 
  803239:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80323c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80323e:	bf 04 00 00 00       	mov    $0x4,%edi
  803243:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
}
  80324f:	c9                   	leaveq 
  803250:	c3                   	retq   

0000000000803251 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803251:	55                   	push   %rbp
  803252:	48 89 e5             	mov    %rsp,%rbp
  803255:	48 83 ec 10          	sub    $0x10,%rsp
  803259:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80325c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803260:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803263:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80326a:	00 00 00 
  80326d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803270:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803272:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803279:	48 89 c6             	mov    %rax,%rsi
  80327c:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803283:	00 00 00 
  803286:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803292:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803299:	00 00 00 
  80329c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80329f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032a2:	bf 05 00 00 00       	mov    $0x5,%edi
  8032a7:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
}
  8032b3:	c9                   	leaveq 
  8032b4:	c3                   	retq   

00000000008032b5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8032b5:	55                   	push   %rbp
  8032b6:	48 89 e5             	mov    %rsp,%rbp
  8032b9:	48 83 ec 10          	sub    $0x10,%rsp
  8032bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032c0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8032c3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032ca:	00 00 00 
  8032cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8032d2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032d9:	00 00 00 
  8032dc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8032e2:	bf 06 00 00 00       	mov    $0x6,%edi
  8032e7:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
}
  8032f3:	c9                   	leaveq 
  8032f4:	c3                   	retq   

00000000008032f5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8032f5:	55                   	push   %rbp
  8032f6:	48 89 e5             	mov    %rsp,%rbp
  8032f9:	48 83 ec 30          	sub    $0x30,%rsp
  8032fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803304:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803307:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80330a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803311:	00 00 00 
  803314:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803317:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803319:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803320:	00 00 00 
  803323:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803326:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803329:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803330:	00 00 00 
  803333:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803336:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803339:	bf 07 00 00 00       	mov    $0x7,%edi
  80333e:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
  80334a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803351:	78 69                	js     8033bc <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803353:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80335a:	7f 08                	jg     803364 <nsipc_recv+0x6f>
  80335c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803362:	7e 35                	jle    803399 <nsipc_recv+0xa4>
  803364:	48 b9 22 46 80 00 00 	movabs $0x804622,%rcx
  80336b:	00 00 00 
  80336e:	48 ba 37 46 80 00 00 	movabs $0x804637,%rdx
  803375:	00 00 00 
  803378:	be 61 00 00 00       	mov    $0x61,%esi
  80337d:	48 bf 4c 46 80 00 00 	movabs $0x80464c,%rdi
  803384:	00 00 00 
  803387:	b8 00 00 00 00       	mov    $0x0,%eax
  80338c:	49 b8 fc 02 80 00 00 	movabs $0x8002fc,%r8
  803393:	00 00 00 
  803396:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339c:	48 63 d0             	movslq %eax,%rdx
  80339f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a3:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8033aa:	00 00 00 
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
	}

	return r;
  8033bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033bf:	c9                   	leaveq 
  8033c0:	c3                   	retq   

00000000008033c1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033c1:	55                   	push   %rbp
  8033c2:	48 89 e5             	mov    %rsp,%rbp
  8033c5:	48 83 ec 20          	sub    $0x20,%rsp
  8033c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033d0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8033d3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8033d6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033dd:	00 00 00 
  8033e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033e3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8033e5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8033ec:	7e 35                	jle    803423 <nsipc_send+0x62>
  8033ee:	48 b9 58 46 80 00 00 	movabs $0x804658,%rcx
  8033f5:	00 00 00 
  8033f8:	48 ba 37 46 80 00 00 	movabs $0x804637,%rdx
  8033ff:	00 00 00 
  803402:	be 6c 00 00 00       	mov    $0x6c,%esi
  803407:	48 bf 4c 46 80 00 00 	movabs $0x80464c,%rdi
  80340e:	00 00 00 
  803411:	b8 00 00 00 00       	mov    $0x0,%eax
  803416:	49 b8 fc 02 80 00 00 	movabs $0x8002fc,%r8
  80341d:	00 00 00 
  803420:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803423:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803426:	48 63 d0             	movslq %eax,%rdx
  803429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342d:	48 89 c6             	mov    %rax,%rsi
  803430:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  803437:	00 00 00 
  80343a:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  803441:	00 00 00 
  803444:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803446:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80344d:	00 00 00 
  803450:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803453:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803456:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80345d:	00 00 00 
  803460:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803463:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803466:	bf 08 00 00 00       	mov    $0x8,%edi
  80346b:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
}
  803477:	c9                   	leaveq 
  803478:	c3                   	retq   

0000000000803479 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803479:	55                   	push   %rbp
  80347a:	48 89 e5             	mov    %rsp,%rbp
  80347d:	48 83 ec 10          	sub    $0x10,%rsp
  803481:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803484:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803487:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80348a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803491:	00 00 00 
  803494:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803497:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803499:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034a0:	00 00 00 
  8034a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034a6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034a9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034b0:	00 00 00 
  8034b3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034b6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8034b9:	bf 09 00 00 00       	mov    $0x9,%edi
  8034be:	48 b8 80 30 80 00 00 	movabs $0x803080,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
}
  8034ca:	c9                   	leaveq 
  8034cb:	c3                   	retq   

00000000008034cc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034cc:	55                   	push   %rbp
  8034cd:	48 89 e5             	mov    %rsp,%rbp
  8034d0:	53                   	push   %rbx
  8034d1:	48 83 ec 38          	sub    $0x38,%rsp
  8034d5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034d9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034dd:	48 89 c7             	mov    %rax,%rdi
  8034e0:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
  8034ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034f3:	0f 88 bf 01 00 00    	js     8036b8 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034fd:	ba 07 04 00 00       	mov    $0x407,%edx
  803502:	48 89 c6             	mov    %rax,%rsi
  803505:	bf 00 00 00 00       	mov    $0x0,%edi
  80350a:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803519:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80351d:	0f 88 95 01 00 00    	js     8036b8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803523:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803527:	48 89 c7             	mov    %rax,%rdi
  80352a:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
  803536:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803539:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80353d:	0f 88 5d 01 00 00    	js     8036a0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803543:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803547:	ba 07 04 00 00       	mov    $0x407,%edx
  80354c:	48 89 c6             	mov    %rax,%rsi
  80354f:	bf 00 00 00 00       	mov    $0x0,%edi
  803554:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803563:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803567:	0f 88 33 01 00 00    	js     8036a0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80356d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803571:	48 89 c7             	mov    %rax,%rdi
  803574:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
  803580:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803584:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803588:	ba 07 04 00 00       	mov    $0x407,%edx
  80358d:	48 89 c6             	mov    %rax,%rsi
  803590:	bf 00 00 00 00       	mov    $0x0,%edi
  803595:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  80359c:	00 00 00 
  80359f:	ff d0                	callq  *%rax
  8035a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a8:	0f 88 d9 00 00 00    	js     803687 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b2:	48 89 c7             	mov    %rax,%rdi
  8035b5:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8035bc:	00 00 00 
  8035bf:	ff d0                	callq  *%rax
  8035c1:	48 89 c2             	mov    %rax,%rdx
  8035c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035ce:	48 89 d1             	mov    %rdx,%rcx
  8035d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d6:	48 89 c6             	mov    %rax,%rsi
  8035d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035de:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  8035e5:	00 00 00 
  8035e8:	ff d0                	callq  *%rax
  8035ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f1:	78 79                	js     80366c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035fe:	00 00 00 
  803601:	8b 12                	mov    (%rdx),%edx
  803603:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803609:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803610:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803614:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80361b:	00 00 00 
  80361e:	8b 12                	mov    (%rdx),%edx
  803620:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803622:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803626:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80362d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803631:	48 89 c7             	mov    %rax,%rdi
  803634:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
  803640:	89 c2                	mov    %eax,%edx
  803642:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803646:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803648:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80364c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803650:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803654:	48 89 c7             	mov    %rax,%rdi
  803657:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	89 03                	mov    %eax,(%rbx)
	return 0;
  803665:	b8 00 00 00 00       	mov    $0x0,%eax
  80366a:	eb 4f                	jmp    8036bb <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80366c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80366d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803671:	48 89 c6             	mov    %rax,%rsi
  803674:	bf 00 00 00 00       	mov    $0x0,%edi
  803679:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  803680:	00 00 00 
  803683:	ff d0                	callq  *%rax
  803685:	eb 01                	jmp    803688 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803687:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368c:	48 89 c6             	mov    %rax,%rsi
  80368f:	bf 00 00 00 00       	mov    $0x0,%edi
  803694:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a4:	48 89 c6             	mov    %rax,%rsi
  8036a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ac:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
err:
	return r;
  8036b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036bb:	48 83 c4 38          	add    $0x38,%rsp
  8036bf:	5b                   	pop    %rbx
  8036c0:	5d                   	pop    %rbp
  8036c1:	c3                   	retq   

00000000008036c2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036c2:	55                   	push   %rbp
  8036c3:	48 89 e5             	mov    %rsp,%rbp
  8036c6:	53                   	push   %rbx
  8036c7:	48 83 ec 28          	sub    $0x28,%rsp
  8036cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036d3:	eb 01                	jmp    8036d6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8036d5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036d6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8036dd:	00 00 00 
  8036e0:	48 8b 00             	mov    (%rax),%rax
  8036e3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 6c 3f 80 00 00 	movabs $0x803f6c,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
  8036ff:	89 c3                	mov    %eax,%ebx
  803701:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803705:	48 89 c7             	mov    %rax,%rdi
  803708:	48 b8 6c 3f 80 00 00 	movabs $0x803f6c,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	39 c3                	cmp    %eax,%ebx
  803716:	0f 94 c0             	sete   %al
  803719:	0f b6 c0             	movzbl %al,%eax
  80371c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80371f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803726:	00 00 00 
  803729:	48 8b 00             	mov    (%rax),%rax
  80372c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803732:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803738:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80373b:	75 0a                	jne    803747 <_pipeisclosed+0x85>
			return ret;
  80373d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803740:	48 83 c4 28          	add    $0x28,%rsp
  803744:	5b                   	pop    %rbx
  803745:	5d                   	pop    %rbp
  803746:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803747:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80374d:	74 86                	je     8036d5 <_pipeisclosed+0x13>
  80374f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803753:	75 80                	jne    8036d5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803755:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80375c:	00 00 00 
  80375f:	48 8b 00             	mov    (%rax),%rax
  803762:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803768:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80376b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376e:	89 c6                	mov    %eax,%esi
  803770:	48 bf 69 46 80 00 00 	movabs $0x804669,%rdi
  803777:	00 00 00 
  80377a:	b8 00 00 00 00       	mov    $0x0,%eax
  80377f:	49 b8 37 05 80 00 00 	movabs $0x800537,%r8
  803786:	00 00 00 
  803789:	41 ff d0             	callq  *%r8
	}
  80378c:	e9 44 ff ff ff       	jmpq   8036d5 <_pipeisclosed+0x13>

0000000000803791 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 30          	sub    $0x30,%rsp
  803799:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80379c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037a3:	48 89 d6             	mov    %rdx,%rsi
  8037a6:	89 c7                	mov    %eax,%edi
  8037a8:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bb:	79 05                	jns    8037c2 <pipeisclosed+0x31>
		return r;
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	eb 31                	jmp    8037f3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c6:	48 89 c7             	mov    %rax,%rdi
  8037c9:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	callq  *%rax
  8037d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037e1:	48 89 d6             	mov    %rdx,%rsi
  8037e4:	48 89 c7             	mov    %rax,%rdi
  8037e7:	48 b8 c2 36 80 00 00 	movabs $0x8036c2,%rax
  8037ee:	00 00 00 
  8037f1:	ff d0                	callq  *%rax
}
  8037f3:	c9                   	leaveq 
  8037f4:	c3                   	retq   

00000000008037f5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037f5:	55                   	push   %rbp
  8037f6:	48 89 e5             	mov    %rsp,%rbp
  8037f9:	48 83 ec 40          	sub    $0x40,%rsp
  8037fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803801:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803805:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380d:	48 89 c7             	mov    %rax,%rdi
  803810:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
  80381c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803820:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803824:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803828:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80382f:	00 
  803830:	e9 97 00 00 00       	jmpq   8038cc <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803835:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80383a:	74 09                	je     803845 <devpipe_read+0x50>
				return i;
  80383c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803840:	e9 95 00 00 00       	jmpq   8038da <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803845:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384d:	48 89 d6             	mov    %rdx,%rsi
  803850:	48 89 c7             	mov    %rax,%rdi
  803853:	48 b8 c2 36 80 00 00 	movabs $0x8036c2,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
  80385f:	85 c0                	test   %eax,%eax
  803861:	74 07                	je     80386a <devpipe_read+0x75>
				return 0;
  803863:	b8 00 00 00 00       	mov    $0x0,%eax
  803868:	eb 70                	jmp    8038da <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80386a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
  803876:	eb 01                	jmp    803879 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803878:	90                   	nop
  803879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387d:	8b 10                	mov    (%rax),%edx
  80387f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803883:	8b 40 04             	mov    0x4(%rax),%eax
  803886:	39 c2                	cmp    %eax,%edx
  803888:	74 ab                	je     803835 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80388a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803892:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389a:	8b 00                	mov    (%rax),%eax
  80389c:	89 c2                	mov    %eax,%edx
  80389e:	c1 fa 1f             	sar    $0x1f,%edx
  8038a1:	c1 ea 1b             	shr    $0x1b,%edx
  8038a4:	01 d0                	add    %edx,%eax
  8038a6:	83 e0 1f             	and    $0x1f,%eax
  8038a9:	29 d0                	sub    %edx,%eax
  8038ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038af:	48 98                	cltq   
  8038b1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038b6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bc:	8b 00                	mov    (%rax),%eax
  8038be:	8d 50 01             	lea    0x1(%rax),%edx
  8038c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038d4:	72 a2                	jb     803878 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038da:	c9                   	leaveq 
  8038db:	c3                   	retq   

00000000008038dc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038dc:	55                   	push   %rbp
  8038dd:	48 89 e5             	mov    %rsp,%rbp
  8038e0:	48 83 ec 40          	sub    $0x40,%rsp
  8038e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f4:	48 89 c7             	mov    %rax,%rdi
  8038f7:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
  803903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803907:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80390f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803916:	00 
  803917:	e9 93 00 00 00       	jmpq   8039af <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80391c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803924:	48 89 d6             	mov    %rdx,%rsi
  803927:	48 89 c7             	mov    %rax,%rdi
  80392a:	48 b8 c2 36 80 00 00 	movabs $0x8036c2,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
  803936:	85 c0                	test   %eax,%eax
  803938:	74 07                	je     803941 <devpipe_write+0x65>
				return 0;
  80393a:	b8 00 00 00 00       	mov    $0x0,%eax
  80393f:	eb 7c                	jmp    8039bd <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803941:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	eb 01                	jmp    803950 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80394f:	90                   	nop
  803950:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803954:	8b 40 04             	mov    0x4(%rax),%eax
  803957:	48 63 d0             	movslq %eax,%rdx
  80395a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395e:	8b 00                	mov    (%rax),%eax
  803960:	48 98                	cltq   
  803962:	48 83 c0 20          	add    $0x20,%rax
  803966:	48 39 c2             	cmp    %rax,%rdx
  803969:	73 b1                	jae    80391c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80396b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396f:	8b 40 04             	mov    0x4(%rax),%eax
  803972:	89 c2                	mov    %eax,%edx
  803974:	c1 fa 1f             	sar    $0x1f,%edx
  803977:	c1 ea 1b             	shr    $0x1b,%edx
  80397a:	01 d0                	add    %edx,%eax
  80397c:	83 e0 1f             	and    $0x1f,%eax
  80397f:	29 d0                	sub    %edx,%eax
  803981:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803985:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803989:	48 01 ca             	add    %rcx,%rdx
  80398c:	0f b6 0a             	movzbl (%rdx),%ecx
  80398f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803993:	48 98                	cltq   
  803995:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399d:	8b 40 04             	mov    0x4(%rax),%eax
  8039a0:	8d 50 01             	lea    0x1(%rax),%edx
  8039a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039b7:	72 96                	jb     80394f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039bd:	c9                   	leaveq 
  8039be:	c3                   	retq   

00000000008039bf <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039bf:	55                   	push   %rbp
  8039c0:	48 89 e5             	mov    %rsp,%rbp
  8039c3:	48 83 ec 20          	sub    $0x20,%rsp
  8039c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d3:	48 89 c7             	mov    %rax,%rdi
  8039d6:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
  8039e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ea:	48 be 7c 46 80 00 00 	movabs $0x80467c,%rsi
  8039f1:	00 00 00 
  8039f4:	48 89 c7             	mov    %rax,%rdi
  8039f7:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  8039fe:	00 00 00 
  803a01:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a07:	8b 50 04             	mov    0x4(%rax),%edx
  803a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0e:	8b 00                	mov    (%rax),%eax
  803a10:	29 c2                	sub    %eax,%edx
  803a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a16:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a20:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a27:	00 00 00 
	stat->st_dev = &devpipe;
  803a2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a35:	00 00 00 
  803a38:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a44:	c9                   	leaveq 
  803a45:	c3                   	retq   

0000000000803a46 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a46:	55                   	push   %rbp
  803a47:	48 89 e5             	mov    %rsp,%rbp
  803a4a:	48 83 ec 10          	sub    $0x10,%rsp
  803a4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a56:	48 89 c6             	mov    %rax,%rsi
  803a59:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5e:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6e:	48 89 c7             	mov    %rax,%rdi
  803a71:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
  803a7d:	48 89 c6             	mov    %rax,%rsi
  803a80:	bf 00 00 00 00       	mov    $0x0,%edi
  803a85:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   
	...

0000000000803a94 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a94:	55                   	push   %rbp
  803a95:	48 89 e5             	mov    %rsp,%rbp
  803a98:	48 83 ec 20          	sub    $0x20,%rsp
  803a9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aa2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803aa5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803aa9:	be 01 00 00 00       	mov    $0x1,%esi
  803aae:	48 89 c7             	mov    %rax,%rdi
  803ab1:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
}
  803abd:	c9                   	leaveq 
  803abe:	c3                   	retq   

0000000000803abf <getchar>:

int
getchar(void)
{
  803abf:	55                   	push   %rbp
  803ac0:	48 89 e5             	mov    %rsp,%rbp
  803ac3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ac7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803acb:	ba 01 00 00 00       	mov    $0x1,%edx
  803ad0:	48 89 c6             	mov    %rax,%rsi
  803ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad8:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  803adf:	00 00 00 
  803ae2:	ff d0                	callq  *%rax
  803ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aeb:	79 05                	jns    803af2 <getchar+0x33>
		return r;
  803aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af0:	eb 14                	jmp    803b06 <getchar+0x47>
	if (r < 1)
  803af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af6:	7f 07                	jg     803aff <getchar+0x40>
		return -E_EOF;
  803af8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803afd:	eb 07                	jmp    803b06 <getchar+0x47>
	return c;
  803aff:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b03:	0f b6 c0             	movzbl %al,%eax
}
  803b06:	c9                   	leaveq 
  803b07:	c3                   	retq   

0000000000803b08 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b08:	55                   	push   %rbp
  803b09:	48 89 e5             	mov    %rsp,%rbp
  803b0c:	48 83 ec 20          	sub    $0x20,%rsp
  803b10:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b13:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b1a:	48 89 d6             	mov    %rdx,%rsi
  803b1d:	89 c7                	mov    %eax,%edi
  803b1f:	48 b8 76 1e 80 00 00 	movabs $0x801e76,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
  803b2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b32:	79 05                	jns    803b39 <iscons+0x31>
		return r;
  803b34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b37:	eb 1a                	jmp    803b53 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3d:	8b 10                	mov    (%rax),%edx
  803b3f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b46:	00 00 00 
  803b49:	8b 00                	mov    (%rax),%eax
  803b4b:	39 c2                	cmp    %eax,%edx
  803b4d:	0f 94 c0             	sete   %al
  803b50:	0f b6 c0             	movzbl %al,%eax
}
  803b53:	c9                   	leaveq 
  803b54:	c3                   	retq   

0000000000803b55 <opencons>:

int
opencons(void)
{
  803b55:	55                   	push   %rbp
  803b56:	48 89 e5             	mov    %rsp,%rbp
  803b59:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b5d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b61:	48 89 c7             	mov    %rax,%rdi
  803b64:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803b6b:	00 00 00 
  803b6e:	ff d0                	callq  *%rax
  803b70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b77:	79 05                	jns    803b7e <opencons+0x29>
		return r;
  803b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7c:	eb 5b                	jmp    803bd9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b82:	ba 07 04 00 00       	mov    $0x407,%edx
  803b87:	48 89 c6             	mov    %rax,%rsi
  803b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8f:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
  803b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba2:	79 05                	jns    803ba9 <opencons+0x54>
		return r;
  803ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba7:	eb 30                	jmp    803bd9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bad:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803bb4:	00 00 00 
  803bb7:	8b 12                	mov    (%rdx),%edx
  803bb9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bca:	48 89 c7             	mov    %rax,%rdi
  803bcd:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
}
  803bd9:	c9                   	leaveq 
  803bda:	c3                   	retq   

0000000000803bdb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bdb:	55                   	push   %rbp
  803bdc:	48 89 e5             	mov    %rsp,%rbp
  803bdf:	48 83 ec 30          	sub    $0x30,%rsp
  803be3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803be7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803beb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bf4:	75 13                	jne    803c09 <devcons_read+0x2e>
		return 0;
  803bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfb:	eb 49                	jmp    803c46 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803bfd:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803c04:	00 00 00 
  803c07:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c09:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
  803c15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1c:	74 df                	je     803bfd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803c1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c22:	79 05                	jns    803c29 <devcons_read+0x4e>
		return c;
  803c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c27:	eb 1d                	jmp    803c46 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803c29:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c2d:	75 07                	jne    803c36 <devcons_read+0x5b>
		return 0;
  803c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c34:	eb 10                	jmp    803c46 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c39:	89 c2                	mov    %eax,%edx
  803c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3f:	88 10                	mov    %dl,(%rax)
	return 1;
  803c41:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c46:	c9                   	leaveq 
  803c47:	c3                   	retq   

0000000000803c48 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c48:	55                   	push   %rbp
  803c49:	48 89 e5             	mov    %rsp,%rbp
  803c4c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c53:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c5a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c61:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c6f:	eb 77                	jmp    803ce8 <devcons_write+0xa0>
		m = n - tot;
  803c71:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c78:	89 c2                	mov    %eax,%edx
  803c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7d:	89 d1                	mov    %edx,%ecx
  803c7f:	29 c1                	sub    %eax,%ecx
  803c81:	89 c8                	mov    %ecx,%eax
  803c83:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c89:	83 f8 7f             	cmp    $0x7f,%eax
  803c8c:	76 07                	jbe    803c95 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803c8e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c98:	48 63 d0             	movslq %eax,%rdx
  803c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9e:	48 98                	cltq   
  803ca0:	48 89 c1             	mov    %rax,%rcx
  803ca3:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803caa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cb1:	48 89 ce             	mov    %rcx,%rsi
  803cb4:	48 89 c7             	mov    %rax,%rdi
  803cb7:	48 b8 2a 14 80 00 00 	movabs $0x80142a,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cc6:	48 63 d0             	movslq %eax,%rdx
  803cc9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cd0:	48 89 d6             	mov    %rdx,%rsi
  803cd3:	48 89 c7             	mov    %rax,%rdi
  803cd6:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803cdd:	00 00 00 
  803ce0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ce5:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ceb:	48 98                	cltq   
  803ced:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cf4:	0f 82 77 ff ff ff    	jb     803c71 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cfd:	c9                   	leaveq 
  803cfe:	c3                   	retq   

0000000000803cff <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cff:	55                   	push   %rbp
  803d00:	48 89 e5             	mov    %rsp,%rbp
  803d03:	48 83 ec 08          	sub    $0x8,%rsp
  803d07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
  803d16:	48 83 ec 10          	sub    $0x10,%rsp
  803d1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	48 be 88 46 80 00 00 	movabs $0x804688,%rsi
  803d2d:	00 00 00 
  803d30:	48 89 c7             	mov    %rax,%rdi
  803d33:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
	return 0;
  803d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d44:	c9                   	leaveq 
  803d45:	c3                   	retq   
	...

0000000000803d48 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	48 83 ec 30          	sub    $0x30,%rsp
  803d50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803d63:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d68:	74 18                	je     803d82 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803d6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6e:	48 89 c7             	mov    %rax,%rdi
  803d71:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
  803d7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d80:	eb 19                	jmp    803d9b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803d82:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803d89:	00 00 00 
  803d8c:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
  803d98:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803d9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d9f:	79 39                	jns    803dda <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803da1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803da6:	75 08                	jne    803db0 <ipc_recv+0x68>
  803da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dac:	8b 00                	mov    (%rax),%eax
  803dae:	eb 05                	jmp    803db5 <ipc_recv+0x6d>
  803db0:	b8 00 00 00 00       	mov    $0x0,%eax
  803db5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803db9:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803dbb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dc0:	75 08                	jne    803dca <ipc_recv+0x82>
  803dc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc6:	8b 00                	mov    (%rax),%eax
  803dc8:	eb 05                	jmp    803dcf <ipc_recv+0x87>
  803dca:	b8 00 00 00 00       	mov    $0x0,%eax
  803dcf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803dd3:	89 02                	mov    %eax,(%rdx)
		return r;
  803dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd8:	eb 53                	jmp    803e2d <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803dda:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ddf:	74 19                	je     803dfa <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803de1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803de8:	00 00 00 
  803deb:	48 8b 00             	mov    (%rax),%rax
  803dee:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df8:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803dfa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dff:	74 19                	je     803e1a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803e01:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803e08:	00 00 00 
  803e0b:	48 8b 00             	mov    (%rax),%rax
  803e0e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e18:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803e1a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803e21:	00 00 00 
  803e24:	48 8b 00             	mov    (%rax),%rax
  803e27:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803e2d:	c9                   	leaveq 
  803e2e:	c3                   	retq   

0000000000803e2f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e2f:	55                   	push   %rbp
  803e30:	48 89 e5             	mov    %rsp,%rbp
  803e33:	48 83 ec 30          	sub    $0x30,%rsp
  803e37:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e3a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e3d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e41:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803e44:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803e4b:	eb 59                	jmp    803ea6 <ipc_send+0x77>
		if(pg) {
  803e4d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e52:	74 20                	je     803e74 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803e54:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e57:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e5a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e61:	89 c7                	mov    %eax,%edi
  803e63:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
  803e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e72:	eb 26                	jmp    803e9a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803e74:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e77:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e7d:	89 d1                	mov    %edx,%ecx
  803e7f:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803e86:	00 00 00 
  803e89:	89 c7                	mov    %eax,%edi
  803e8b:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  803e92:	00 00 00 
  803e95:	ff d0                	callq  *%rax
  803e97:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803e9a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803ea1:	00 00 00 
  803ea4:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803ea6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803eaa:	74 a1                	je     803e4d <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803eac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb0:	74 2a                	je     803edc <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803eb2:	48 ba 90 46 80 00 00 	movabs $0x804690,%rdx
  803eb9:	00 00 00 
  803ebc:	be 49 00 00 00       	mov    $0x49,%esi
  803ec1:	48 bf bb 46 80 00 00 	movabs $0x8046bb,%rdi
  803ec8:	00 00 00 
  803ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed0:	48 b9 fc 02 80 00 00 	movabs $0x8002fc,%rcx
  803ed7:	00 00 00 
  803eda:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803edc:	c9                   	leaveq 
  803edd:	c3                   	retq   

0000000000803ede <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ede:	55                   	push   %rbp
  803edf:	48 89 e5             	mov    %rsp,%rbp
  803ee2:	48 83 ec 18          	sub    $0x18,%rsp
  803ee6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ee9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ef0:	eb 6a                	jmp    803f5c <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803ef2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ef9:	00 00 00 
  803efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eff:	48 63 d0             	movslq %eax,%rdx
  803f02:	48 89 d0             	mov    %rdx,%rax
  803f05:	48 c1 e0 02          	shl    $0x2,%rax
  803f09:	48 01 d0             	add    %rdx,%rax
  803f0c:	48 01 c0             	add    %rax,%rax
  803f0f:	48 01 d0             	add    %rdx,%rax
  803f12:	48 c1 e0 05          	shl    $0x5,%rax
  803f16:	48 01 c8             	add    %rcx,%rax
  803f19:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f1f:	8b 00                	mov    (%rax),%eax
  803f21:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f24:	75 32                	jne    803f58 <ipc_find_env+0x7a>
			return envs[i].env_id;
  803f26:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f2d:	00 00 00 
  803f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f33:	48 63 d0             	movslq %eax,%rdx
  803f36:	48 89 d0             	mov    %rdx,%rax
  803f39:	48 c1 e0 02          	shl    $0x2,%rax
  803f3d:	48 01 d0             	add    %rdx,%rax
  803f40:	48 01 c0             	add    %rax,%rax
  803f43:	48 01 d0             	add    %rdx,%rax
  803f46:	48 c1 e0 05          	shl    $0x5,%rax
  803f4a:	48 01 c8             	add    %rcx,%rax
  803f4d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f53:	8b 40 08             	mov    0x8(%rax),%eax
  803f56:	eb 12                	jmp    803f6a <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f58:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f5c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f63:	7e 8d                	jle    803ef2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f6a:	c9                   	leaveq 
  803f6b:	c3                   	retq   

0000000000803f6c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f6c:	55                   	push   %rbp
  803f6d:	48 89 e5             	mov    %rsp,%rbp
  803f70:	48 83 ec 18          	sub    $0x18,%rsp
  803f74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7c:	48 89 c2             	mov    %rax,%rdx
  803f7f:	48 c1 ea 15          	shr    $0x15,%rdx
  803f83:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f8a:	01 00 00 
  803f8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f91:	83 e0 01             	and    $0x1,%eax
  803f94:	48 85 c0             	test   %rax,%rax
  803f97:	75 07                	jne    803fa0 <pageref+0x34>
		return 0;
  803f99:	b8 00 00 00 00       	mov    $0x0,%eax
  803f9e:	eb 53                	jmp    803ff3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa4:	48 89 c2             	mov    %rax,%rdx
  803fa7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803fab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fb2:	01 00 00 
  803fb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fb9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc1:	83 e0 01             	and    $0x1,%eax
  803fc4:	48 85 c0             	test   %rax,%rax
  803fc7:	75 07                	jne    803fd0 <pageref+0x64>
		return 0;
  803fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fce:	eb 23                	jmp    803ff3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd4:	48 89 c2             	mov    %rax,%rdx
  803fd7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803fdb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fe2:	00 00 00 
  803fe5:	48 c1 e2 04          	shl    $0x4,%rdx
  803fe9:	48 01 d0             	add    %rdx,%rax
  803fec:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ff0:	0f b7 c0             	movzwl %ax,%eax
}
  803ff3:	c9                   	leaveq 
  803ff4:	c3                   	retq   
