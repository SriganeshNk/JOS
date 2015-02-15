
obj/user/num.debug:     file format elf64-x86-64


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
  80003c:	e8 7f 02 00 00       	callq  8002c0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800053:	e9 da 00 00 00       	jmpq   800132 <num+0xee>
		if (bol) {
  800058:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005f:	00 00 00 
  800062:	8b 00                	mov    (%rax),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	74 54                	je     8000bc <num+0x78>
			printf("%5d ", ++line);
  800068:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006f:	00 00 00 
  800072:	8b 00                	mov    (%rax),%eax
  800074:	8d 50 01             	lea    0x1(%rax),%edx
  800077:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007e:	00 00 00 
  800081:	89 10                	mov    %edx,(%rax)
  800083:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80008a:	00 00 00 
  80008d:	8b 00                	mov    (%rax),%eax
  80008f:	89 c6                	mov    %eax,%esi
  800091:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 ba 98 2c 80 00 00 	movabs $0x802c98,%rdx
  8000a7:	00 00 00 
  8000aa:	ff d2                	callq  *%rdx
			bol = 0;
  8000ac:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b3:	00 00 00 
  8000b6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bc:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000c0:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c5:	48 89 c6             	mov    %rax,%rsi
  8000c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cd:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8000d4:	00 00 00 
  8000d7:	ff d0                	callq  *%rax
  8000d9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000dc:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000e0:	74 38                	je     80011a <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e9:	41 89 d0             	mov    %edx,%r8d
  8000ec:	48 89 c1             	mov    %rax,%rcx
  8000ef:	48 ba a5 40 80 00 00 	movabs $0x8040a5,%rdx
  8000f6:	00 00 00 
  8000f9:	be 13 00 00 00       	mov    $0x13,%esi
  8000fe:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  800105:	00 00 00 
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  800114:	00 00 00 
  800117:	41 ff d1             	callq  *%r9
		if (c == '\n')
  80011a:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011e:	3c 0a                	cmp    $0xa,%al
  800120:	75 10                	jne    800132 <num+0xee>
			bol = 1;
  800122:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800129:	00 00 00 
  80012c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800132:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800136:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800139:	ba 01 00 00 00       	mov    $0x1,%edx
  80013e:	48 89 ce             	mov    %rcx,%rsi
  800141:	89 c7                	mov    %eax,%edi
  800143:	48 b8 38 23 80 00 00 	movabs $0x802338,%rax
  80014a:	00 00 00 
  80014d:	ff d0                	callq  *%rax
  80014f:	48 98                	cltq   
  800151:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800155:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80015a:	0f 8f f8 fe ff ff    	jg     800058 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  800160:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800165:	79 39                	jns    8001a0 <num+0x15c>
		panic("error reading %s: %e", s, n);
  800167:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016f:	49 89 d0             	mov    %rdx,%r8
  800172:	48 89 c1             	mov    %rax,%rcx
  800175:	48 ba cb 40 80 00 00 	movabs $0x8040cb,%rdx
  80017c:	00 00 00 
  80017f:	be 18 00 00 00       	mov    $0x18,%esi
  800184:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9
}
  8001a0:	c9                   	leaveq 
  8001a1:	c3                   	retq   

00000000008001a2 <umain>:

void
umain(int argc, char **argv)
{
  8001a2:	55                   	push   %rbp
  8001a3:	48 89 e5             	mov    %rsp,%rbp
  8001a6:	48 83 ec 20          	sub    $0x20,%rsp
  8001aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  8001c2:	00 00 00 
  8001c5:	48 89 10             	mov    %rdx,(%rax)
	if (argc == 1)
  8001c8:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4c>
		num(0, "<stdin>");
  8001ce:	48 be e4 40 80 00 00 	movabs $0x8040e4,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 c2 00 00 00       	jmpq   8002b0 <umain+0x10e>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8001f5:	e9 aa 00 00 00       	jmpq   8002a4 <umain+0x102>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 c1 e0 03          	shl    $0x3,%rax
  800203:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800207:	48 8b 00             	mov    (%rax),%rax
  80020a:	be 00 00 00 00       	mov    $0x0,%esi
  80020f:	48 89 c7             	mov    %rax,%rdi
  800212:	48 b8 17 28 80 00 00 	movabs $0x802817,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  800221:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800225:	79 44                	jns    80026b <umain+0xc9>
				panic("can't open %s: %e", argv[i], f);
  800227:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022a:	48 98                	cltq   
  80022c:	48 c1 e0 03          	shl    $0x3,%rax
  800230:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800234:	48 8b 00             	mov    (%rax),%rax
  800237:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80023a:	41 89 d0             	mov    %edx,%r8d
  80023d:	48 89 c1             	mov    %rax,%rcx
  800240:	48 ba ec 40 80 00 00 	movabs $0x8040ec,%rdx
  800247:	00 00 00 
  80024a:	be 27 00 00 00       	mov    $0x27,%esi
  80024f:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  800256:	00 00 00 
  800259:	b8 00 00 00 00       	mov    $0x0,%eax
  80025e:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  800265:	00 00 00 
  800268:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  80026b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026e:	48 98                	cltq   
  800270:	48 c1 e0 03          	shl    $0x3,%rax
  800274:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800278:	48 8b 10             	mov    (%rax),%rdx
  80027b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80027e:	48 89 d6             	mov    %rdx,%rsi
  800281:	89 c7                	mov    %eax,%edi
  800283:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80028a:	00 00 00 
  80028d:	ff d0                	callq  *%rax
				close(f);
  80028f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 16 21 80 00 00 	movabs $0x802116,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8002a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002aa:	0f 8c 4a ff ff ff    	jl     8001fa <umain+0x58>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002b0:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  8002b7:	00 00 00 
  8002ba:	ff d0                	callq  *%rax
}
  8002bc:	c9                   	leaveq 
  8002bd:	c3                   	retq   
	...

00000000008002c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %rbp
  8002c1:	48 89 e5             	mov    %rsp,%rbp
  8002c4:	48 83 ec 10          	sub    $0x10,%rsp
  8002c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002cf:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002d6:	00 00 00 
  8002d9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e0:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	callq  *%rax
  8002ec:	48 98                	cltq   
  8002ee:	48 89 c2             	mov    %rax,%rdx
  8002f1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8002f7:	48 89 d0             	mov    %rdx,%rax
  8002fa:	48 c1 e0 02          	shl    $0x2,%rax
  8002fe:	48 01 d0             	add    %rdx,%rax
  800301:	48 01 c0             	add    %rax,%rax
  800304:	48 01 d0             	add    %rdx,%rax
  800307:	48 c1 e0 05          	shl    $0x5,%rax
  80030b:	48 89 c2             	mov    %rax,%rdx
  80030e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800315:	00 00 00 
  800318:	48 01 c2             	add    %rax,%rdx
  80031b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800322:	00 00 00 
  800325:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80032c:	7e 14                	jle    800342 <libmain+0x82>
		binaryname = argv[0];
  80032e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800332:	48 8b 10             	mov    (%rax),%rdx
  800335:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80033c:	00 00 00 
  80033f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800349:	48 89 d6             	mov    %rdx,%rsi
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80035a:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  800361:	00 00 00 
  800364:	ff d0                	callq  *%rax
}
  800366:	c9                   	leaveq 
  800367:	c3                   	retq   

0000000000800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %rbp
  800369:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80036c:	48 b8 61 21 80 00 00 	movabs $0x802161,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800378:	bf 00 00 00 00       	mov    $0x0,%edi
  80037d:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
}
  800389:	5d                   	pop    %rbp
  80038a:	c3                   	retq   
	...

000000000080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038c:	55                   	push   %rbp
  80038d:	48 89 e5             	mov    %rsp,%rbp
  800390:	53                   	push   %rbx
  800391:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800398:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80039f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003a5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003ac:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003b3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ba:	84 c0                	test   %al,%al
  8003bc:	74 23                	je     8003e1 <_panic+0x55>
  8003be:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003c5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003cd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003d1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003d5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003dd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003e1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003ef:	00 00 00 
  8003f2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f9:	00 00 00 
  8003fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800400:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800407:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80040e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800415:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80041c:	00 00 00 
  80041f:	48 8b 18             	mov    (%rax),%rbx
  800422:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
  80042e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800434:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80043b:	41 89 c8             	mov    %ecx,%r8d
  80043e:	48 89 d1             	mov    %rdx,%rcx
  800441:	48 89 da             	mov    %rbx,%rdx
  800444:	89 c6                	mov    %eax,%esi
  800446:	48 bf 08 41 80 00 00 	movabs $0x804108,%rdi
  80044d:	00 00 00 
  800450:	b8 00 00 00 00       	mov    $0x0,%eax
  800455:	49 b9 c7 05 80 00 00 	movabs $0x8005c7,%r9
  80045c:	00 00 00 
  80045f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800462:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800469:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800470:	48 89 d6             	mov    %rdx,%rsi
  800473:	48 89 c7             	mov    %rax,%rdi
  800476:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  80047d:	00 00 00 
  800480:	ff d0                	callq  *%rax
	cprintf("\n");
  800482:	48 bf 2b 41 80 00 00 	movabs $0x80412b,%rdi
  800489:	00 00 00 
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	48 ba c7 05 80 00 00 	movabs $0x8005c7,%rdx
  800498:	00 00 00 
  80049b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80049d:	cc                   	int3   
  80049e:	eb fd                	jmp    80049d <_panic+0x111>

00000000008004a0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	48 83 ec 10          	sub    $0x10,%rsp
  8004a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b3:	8b 00                	mov    (%rax),%eax
  8004b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b8:	89 d6                	mov    %edx,%esi
  8004ba:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004be:	48 63 d0             	movslq %eax,%rdx
  8004c1:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8004c6:	8d 50 01             	lea    0x1(%rax),%edx
  8004c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cd:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8004cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d3:	8b 00                	mov    (%rax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8004dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e0:	8b 00                	mov    (%rax),%eax
  8004e2:	48 98                	cltq   
  8004e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e8:	48 83 c2 08          	add    $0x8,%rdx
  8004ec:	48 89 c6             	mov    %rax,%rsi
  8004ef:	48 89 d7             	mov    %rdx,%rdi
  8004f2:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
        b->idx = 0;
  8004fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050c:	8b 40 04             	mov    0x4(%rax),%eax
  80050f:	8d 50 01             	lea    0x1(%rax),%edx
  800512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800516:	89 50 04             	mov    %edx,0x4(%rax)
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800526:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80052d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800534:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80053b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800542:	48 8b 0a             	mov    (%rdx),%rcx
  800545:	48 89 08             	mov    %rcx,(%rax)
  800548:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800550:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800554:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800558:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80055f:	00 00 00 
    b.cnt = 0;
  800562:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800569:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80056c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800573:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80057a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800581:	48 89 c6             	mov    %rax,%rsi
  800584:	48 bf a0 04 80 00 00 	movabs $0x8004a0,%rdi
  80058b:	00 00 00 
  80058e:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  800595:	00 00 00 
  800598:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80059a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005a0:	48 98                	cltq   
  8005a2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a9:	48 83 c2 08          	add    $0x8,%rdx
  8005ad:	48 89 c6             	mov    %rax,%rsi
  8005b0:	48 89 d7             	mov    %rdx,%rdi
  8005b3:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  8005ba:	00 00 00 
  8005bd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005c5:	c9                   	leaveq 
  8005c6:	c3                   	retq   

00000000008005c7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005c7:	55                   	push   %rbp
  8005c8:	48 89 e5             	mov    %rsp,%rbp
  8005cb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005d2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005f5:	84 c0                	test   %al,%al
  8005f7:	74 20                	je     800619 <cprintf+0x52>
  8005f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800601:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800605:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800609:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80060d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800611:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800615:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800619:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800620:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800627:	00 00 00 
  80062a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800631:	00 00 00 
  800634:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800638:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80063f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800646:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80064d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800654:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80065b:	48 8b 0a             	mov    (%rdx),%rcx
  80065e:	48 89 08             	mov    %rcx,(%rax)
  800661:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800665:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800669:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80066d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800671:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800678:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80067f:	48 89 d6             	mov    %rdx,%rsi
  800682:	48 89 c7             	mov    %rax,%rdi
  800685:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  80068c:	00 00 00 
  80068f:	ff d0                	callq  *%rax
  800691:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800697:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80069d:	c9                   	leaveq 
  80069e:	c3                   	retq   
	...

00000000008006a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 30          	sub    $0x30,%rsp
  8006a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006b4:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006b7:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006bb:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006c2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006c6:	77 52                	ja     80071a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006cb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006cf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006d2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
  8006df:	48 f7 75 d0          	divq   -0x30(%rbp)
  8006e3:	48 89 c2             	mov    %rax,%rdx
  8006e6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8006e9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006ec:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f4:	41 89 f9             	mov    %edi,%r9d
  8006f7:	48 89 c7             	mov    %rax,%rdi
  8006fa:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	eb 1c                	jmp    800724 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800708:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80070f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800713:	48 89 d6             	mov    %rdx,%rsi
  800716:	89 c7                	mov    %eax,%edi
  800718:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80071a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80071e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800722:	7f e4                	jg     800708 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800724:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	48 f7 f1             	div    %rcx
  800733:	48 89 d0             	mov    %rdx,%rax
  800736:	48 ba 30 43 80 00 00 	movabs $0x804330,%rdx
  80073d:	00 00 00 
  800740:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800744:	0f be c0             	movsbl %al,%eax
  800747:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80074f:	48 89 d6             	mov    %rdx,%rsi
  800752:	89 c7                	mov    %eax,%edi
  800754:	ff d1                	callq  *%rcx
}
  800756:	c9                   	leaveq 
  800757:	c3                   	retq   

0000000000800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %rbp
  800759:	48 89 e5             	mov    %rsp,%rbp
  80075c:	48 83 ec 20          	sub    $0x20,%rsp
  800760:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800764:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800767:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076b:	7e 52                	jle    8007bf <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	83 f8 30             	cmp    $0x30,%eax
  800776:	73 24                	jae    80079c <getuint+0x44>
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	89 c0                	mov    %eax,%eax
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	8b 12                	mov    (%rdx),%edx
  800791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800798:	89 0a                	mov    %ecx,(%rdx)
  80079a:	eb 17                	jmp    8007b3 <getuint+0x5b>
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a4:	48 89 d0             	mov    %rdx,%rax
  8007a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b3:	48 8b 00             	mov    (%rax),%rax
  8007b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ba:	e9 a3 00 00 00       	jmpq   800862 <getuint+0x10a>
	else if (lflag)
  8007bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c3:	74 4f                	je     800814 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	8b 00                	mov    (%rax),%eax
  8007cb:	83 f8 30             	cmp    $0x30,%eax
  8007ce:	73 24                	jae    8007f4 <getuint+0x9c>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	8b 00                	mov    (%rax),%eax
  8007de:	89 c0                	mov    %eax,%eax
  8007e0:	48 01 d0             	add    %rdx,%rax
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	8b 12                	mov    (%rdx),%edx
  8007e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f0:	89 0a                	mov    %ecx,(%rdx)
  8007f2:	eb 17                	jmp    80080b <getuint+0xb3>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080b:	48 8b 00             	mov    (%rax),%rax
  80080e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800812:	eb 4e                	jmp    800862 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	83 f8 30             	cmp    $0x30,%eax
  80081d:	73 24                	jae    800843 <getuint+0xeb>
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	89 c0                	mov    %eax,%eax
  80082f:	48 01 d0             	add    %rdx,%rax
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	8b 12                	mov    (%rdx),%edx
  800838:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	89 0a                	mov    %ecx,(%rdx)
  800841:	eb 17                	jmp    80085a <getuint+0x102>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084b:	48 89 d0             	mov    %rdx,%rax
  80084e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	89 c0                	mov    %eax,%eax
  80085e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800866:	c9                   	leaveq 
  800867:	c3                   	retq   

0000000000800868 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800868:	55                   	push   %rbp
  800869:	48 89 e5             	mov    %rsp,%rbp
  80086c:	48 83 ec 20          	sub    $0x20,%rsp
  800870:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800874:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800877:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80087b:	7e 52                	jle    8008cf <getint+0x67>
		x=va_arg(*ap, long long);
  80087d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800881:	8b 00                	mov    (%rax),%eax
  800883:	83 f8 30             	cmp    $0x30,%eax
  800886:	73 24                	jae    8008ac <getint+0x44>
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	89 c0                	mov    %eax,%eax
  800898:	48 01 d0             	add    %rdx,%rax
  80089b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089f:	8b 12                	mov    (%rdx),%edx
  8008a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a8:	89 0a                	mov    %ecx,(%rdx)
  8008aa:	eb 17                	jmp    8008c3 <getint+0x5b>
  8008ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b4:	48 89 d0             	mov    %rdx,%rax
  8008b7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c3:	48 8b 00             	mov    (%rax),%rax
  8008c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ca:	e9 a3 00 00 00       	jmpq   800972 <getint+0x10a>
	else if (lflag)
  8008cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008d3:	74 4f                	je     800924 <getint+0xbc>
		x=va_arg(*ap, long);
  8008d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d9:	8b 00                	mov    (%rax),%eax
  8008db:	83 f8 30             	cmp    $0x30,%eax
  8008de:	73 24                	jae    800904 <getint+0x9c>
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	89 c0                	mov    %eax,%eax
  8008f0:	48 01 d0             	add    %rdx,%rax
  8008f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f7:	8b 12                	mov    (%rdx),%edx
  8008f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800900:	89 0a                	mov    %ecx,(%rdx)
  800902:	eb 17                	jmp    80091b <getint+0xb3>
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090c:	48 89 d0             	mov    %rdx,%rax
  80090f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800913:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800917:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091b:	48 8b 00             	mov    (%rax),%rax
  80091e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800922:	eb 4e                	jmp    800972 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	8b 00                	mov    (%rax),%eax
  80092a:	83 f8 30             	cmp    $0x30,%eax
  80092d:	73 24                	jae    800953 <getint+0xeb>
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	8b 00                	mov    (%rax),%eax
  80093d:	89 c0                	mov    %eax,%eax
  80093f:	48 01 d0             	add    %rdx,%rax
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	8b 12                	mov    (%rdx),%edx
  800948:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094f:	89 0a                	mov    %ecx,(%rdx)
  800951:	eb 17                	jmp    80096a <getint+0x102>
  800953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800957:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095b:	48 89 d0             	mov    %rdx,%rax
  80095e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800962:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800966:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096a:	8b 00                	mov    (%rax),%eax
  80096c:	48 98                	cltq   
  80096e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800976:	c9                   	leaveq 
  800977:	c3                   	retq   

0000000000800978 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800978:	55                   	push   %rbp
  800979:	48 89 e5             	mov    %rsp,%rbp
  80097c:	41 54                	push   %r12
  80097e:	53                   	push   %rbx
  80097f:	48 83 ec 60          	sub    $0x60,%rsp
  800983:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800987:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80098b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800993:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800997:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80099b:	48 8b 0a             	mov    (%rdx),%rcx
  80099e:	48 89 08             	mov    %rcx,(%rax)
  8009a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b1:	eb 17                	jmp    8009ca <vprintfmt+0x52>
			if (ch == '\0')
  8009b3:	85 db                	test   %ebx,%ebx
  8009b5:	0f 84 ea 04 00 00    	je     800ea5 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8009bb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009bf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009c3:	48 89 c6             	mov    %rax,%rsi
  8009c6:	89 df                	mov    %ebx,%edi
  8009c8:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ce:	0f b6 00             	movzbl (%rax),%eax
  8009d1:	0f b6 d8             	movzbl %al,%ebx
  8009d4:	83 fb 25             	cmp    $0x25,%ebx
  8009d7:	0f 95 c0             	setne  %al
  8009da:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009df:	84 c0                	test   %al,%al
  8009e1:	75 d0                	jne    8009b3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009e7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800a03:	eb 04                	jmp    800a09 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a05:	90                   	nop
  800a06:	eb 01                	jmp    800a09 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a08:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a0d:	0f b6 00             	movzbl (%rax),%eax
  800a10:	0f b6 d8             	movzbl %al,%ebx
  800a13:	89 d8                	mov    %ebx,%eax
  800a15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a1a:	83 e8 23             	sub    $0x23,%eax
  800a1d:	83 f8 55             	cmp    $0x55,%eax
  800a20:	0f 87 4b 04 00 00    	ja     800e71 <vprintfmt+0x4f9>
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a2f:	00 
  800a30:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
  800a37:	00 00 00 
  800a3a:	48 01 d0             	add    %rdx,%rax
  800a3d:	48 8b 00             	mov    (%rax),%rax
  800a40:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a42:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a46:	eb c1                	jmp    800a09 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a48:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a4c:	eb bb                	jmp    800a09 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a55:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a58:	89 d0                	mov    %edx,%eax
  800a5a:	c1 e0 02             	shl    $0x2,%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	01 c0                	add    %eax,%eax
  800a61:	01 d8                	add    %ebx,%eax
  800a63:	83 e8 30             	sub    $0x30,%eax
  800a66:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6d:	0f b6 00             	movzbl (%rax),%eax
  800a70:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a73:	83 fb 2f             	cmp    $0x2f,%ebx
  800a76:	7e 63                	jle    800adb <vprintfmt+0x163>
  800a78:	83 fb 39             	cmp    $0x39,%ebx
  800a7b:	7f 5e                	jg     800adb <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a7d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a82:	eb d1                	jmp    800a55 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a87:	83 f8 30             	cmp    $0x30,%eax
  800a8a:	73 17                	jae    800aa3 <vprintfmt+0x12b>
  800a8c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a93:	89 c0                	mov    %eax,%eax
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9b:	83 c2 08             	add    $0x8,%edx
  800a9e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa1:	eb 0f                	jmp    800ab2 <vprintfmt+0x13a>
  800aa3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa7:	48 89 d0             	mov    %rdx,%rax
  800aaa:	48 83 c2 08          	add    $0x8,%rdx
  800aae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab2:	8b 00                	mov    (%rax),%eax
  800ab4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab7:	eb 23                	jmp    800adc <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800ab9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abd:	0f 89 42 ff ff ff    	jns    800a05 <vprintfmt+0x8d>
				width = 0;
  800ac3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800aca:	e9 36 ff ff ff       	jmpq   800a05 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800acf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad6:	e9 2e ff ff ff       	jmpq   800a09 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800adb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800adc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae0:	0f 89 22 ff ff ff    	jns    800a08 <vprintfmt+0x90>
				width = precision, precision = -1;
  800ae6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800aec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800af3:	e9 10 ff ff ff       	jmpq   800a08 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800afc:	e9 08 ff ff ff       	jmpq   800a09 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b04:	83 f8 30             	cmp    $0x30,%eax
  800b07:	73 17                	jae    800b20 <vprintfmt+0x1a8>
  800b09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b10:	89 c0                	mov    %eax,%eax
  800b12:	48 01 d0             	add    %rdx,%rax
  800b15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b18:	83 c2 08             	add    $0x8,%edx
  800b1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1e:	eb 0f                	jmp    800b2f <vprintfmt+0x1b7>
  800b20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b24:	48 89 d0             	mov    %rdx,%rax
  800b27:	48 83 c2 08          	add    $0x8,%rdx
  800b2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2f:	8b 00                	mov    (%rax),%eax
  800b31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b35:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b39:	48 89 d6             	mov    %rdx,%rsi
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	ff d1                	callq  *%rcx
			break;
  800b40:	e9 5a 03 00 00       	jmpq   800e9f <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b48:	83 f8 30             	cmp    $0x30,%eax
  800b4b:	73 17                	jae    800b64 <vprintfmt+0x1ec>
  800b4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b54:	89 c0                	mov    %eax,%eax
  800b56:	48 01 d0             	add    %rdx,%rax
  800b59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b5c:	83 c2 08             	add    $0x8,%edx
  800b5f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b62:	eb 0f                	jmp    800b73 <vprintfmt+0x1fb>
  800b64:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b68:	48 89 d0             	mov    %rdx,%rax
  800b6b:	48 83 c2 08          	add    $0x8,%rdx
  800b6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b73:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b75:	85 db                	test   %ebx,%ebx
  800b77:	79 02                	jns    800b7b <vprintfmt+0x203>
				err = -err;
  800b79:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b7b:	83 fb 15             	cmp    $0x15,%ebx
  800b7e:	7f 16                	jg     800b96 <vprintfmt+0x21e>
  800b80:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  800b87:	00 00 00 
  800b8a:	48 63 d3             	movslq %ebx,%rdx
  800b8d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b91:	4d 85 e4             	test   %r12,%r12
  800b94:	75 2e                	jne    800bc4 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	89 d9                	mov    %ebx,%ecx
  800ba0:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
  800ba7:	00 00 00 
  800baa:	48 89 c7             	mov    %rax,%rdi
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	49 b8 af 0e 80 00 00 	movabs $0x800eaf,%r8
  800bb9:	00 00 00 
  800bbc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbf:	e9 db 02 00 00       	jmpq   800e9f <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcc:	4c 89 e1             	mov    %r12,%rcx
  800bcf:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
  800bd6:	00 00 00 
  800bd9:	48 89 c7             	mov    %rax,%rdi
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	49 b8 af 0e 80 00 00 	movabs $0x800eaf,%r8
  800be8:	00 00 00 
  800beb:	41 ff d0             	callq  *%r8
			break;
  800bee:	e9 ac 02 00 00       	jmpq   800e9f <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bf3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf6:	83 f8 30             	cmp    $0x30,%eax
  800bf9:	73 17                	jae    800c12 <vprintfmt+0x29a>
  800bfb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c02:	89 c0                	mov    %eax,%eax
  800c04:	48 01 d0             	add    %rdx,%rax
  800c07:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0a:	83 c2 08             	add    $0x8,%edx
  800c0d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c10:	eb 0f                	jmp    800c21 <vprintfmt+0x2a9>
  800c12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c16:	48 89 d0             	mov    %rdx,%rax
  800c19:	48 83 c2 08          	add    $0x8,%rdx
  800c1d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c21:	4c 8b 20             	mov    (%rax),%r12
  800c24:	4d 85 e4             	test   %r12,%r12
  800c27:	75 0a                	jne    800c33 <vprintfmt+0x2bb>
				p = "(null)";
  800c29:	49 bc 4d 43 80 00 00 	movabs $0x80434d,%r12
  800c30:	00 00 00 
			if (width > 0 && padc != '-')
  800c33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c37:	7e 7a                	jle    800cb3 <vprintfmt+0x33b>
  800c39:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c3d:	74 74                	je     800cb3 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c42:	48 98                	cltq   
  800c44:	48 89 c6             	mov    %rax,%rsi
  800c47:	4c 89 e7             	mov    %r12,%rdi
  800c4a:	48 b8 5a 11 80 00 00 	movabs $0x80115a,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
  800c56:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c59:	eb 17                	jmp    800c72 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800c5b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800c5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c63:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c67:	48 89 d6             	mov    %rdx,%rsi
  800c6a:	89 c7                	mov    %eax,%edi
  800c6c:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c72:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c76:	7f e3                	jg     800c5b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c78:	eb 39                	jmp    800cb3 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800c7a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c7e:	74 1e                	je     800c9e <vprintfmt+0x326>
  800c80:	83 fb 1f             	cmp    $0x1f,%ebx
  800c83:	7e 05                	jle    800c8a <vprintfmt+0x312>
  800c85:	83 fb 7e             	cmp    $0x7e,%ebx
  800c88:	7e 14                	jle    800c9e <vprintfmt+0x326>
					putch('?', putdat);
  800c8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c92:	48 89 c6             	mov    %rax,%rsi
  800c95:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c9a:	ff d2                	callq  *%rdx
  800c9c:	eb 0f                	jmp    800cad <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c9e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ca2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca6:	48 89 c6             	mov    %rax,%rsi
  800ca9:	89 df                	mov    %ebx,%edi
  800cab:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb1:	eb 01                	jmp    800cb4 <vprintfmt+0x33c>
  800cb3:	90                   	nop
  800cb4:	41 0f b6 04 24       	movzbl (%r12),%eax
  800cb9:	0f be d8             	movsbl %al,%ebx
  800cbc:	85 db                	test   %ebx,%ebx
  800cbe:	0f 95 c0             	setne  %al
  800cc1:	49 83 c4 01          	add    $0x1,%r12
  800cc5:	84 c0                	test   %al,%al
  800cc7:	74 28                	je     800cf1 <vprintfmt+0x379>
  800cc9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ccd:	78 ab                	js     800c7a <vprintfmt+0x302>
  800ccf:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cd3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cd7:	79 a1                	jns    800c7a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd9:	eb 16                	jmp    800cf1 <vprintfmt+0x379>
				putch(' ', putdat);
  800cdb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cdf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ce3:	48 89 c6             	mov    %rax,%rsi
  800ce6:	bf 20 00 00 00       	mov    $0x20,%edi
  800ceb:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ced:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf5:	7f e4                	jg     800cdb <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800cf7:	e9 a3 01 00 00       	jmpq   800e9f <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cfc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d00:	be 03 00 00 00       	mov    $0x3,%esi
  800d05:	48 89 c7             	mov    %rax,%rdi
  800d08:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800d0f:	00 00 00 
  800d12:	ff d0                	callq  *%rax
  800d14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1c:	48 85 c0             	test   %rax,%rax
  800d1f:	79 1d                	jns    800d3e <vprintfmt+0x3c6>
				putch('-', putdat);
  800d21:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d25:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d29:	48 89 c6             	mov    %rax,%rsi
  800d2c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d31:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d37:	48 f7 d8             	neg    %rax
  800d3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d3e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d45:	e9 e8 00 00 00       	jmpq   800e32 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d4a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4e:	be 03 00 00 00       	mov    $0x3,%esi
  800d53:	48 89 c7             	mov    %rax,%rdi
  800d56:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800d5d:	00 00 00 
  800d60:	ff d0                	callq  *%rax
  800d62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d6d:	e9 c0 00 00 00       	jmpq   800e32 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d7a:	48 89 c6             	mov    %rax,%rsi
  800d7d:	bf 58 00 00 00       	mov    $0x58,%edi
  800d82:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d84:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d88:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d8c:	48 89 c6             	mov    %rax,%rsi
  800d8f:	bf 58 00 00 00       	mov    $0x58,%edi
  800d94:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d96:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d9e:	48 89 c6             	mov    %rax,%rsi
  800da1:	bf 58 00 00 00       	mov    $0x58,%edi
  800da6:	ff d2                	callq  *%rdx
			break;
  800da8:	e9 f2 00 00 00       	jmpq   800e9f <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800dad:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800db1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db5:	48 89 c6             	mov    %rax,%rsi
  800db8:	bf 30 00 00 00       	mov    $0x30,%edi
  800dbd:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800dbf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dc3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dc7:	48 89 c6             	mov    %rax,%rsi
  800dca:	bf 78 00 00 00       	mov    $0x78,%edi
  800dcf:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd4:	83 f8 30             	cmp    $0x30,%eax
  800dd7:	73 17                	jae    800df0 <vprintfmt+0x478>
  800dd9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ddd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de0:	89 c0                	mov    %eax,%eax
  800de2:	48 01 d0             	add    %rdx,%rax
  800de5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800de8:	83 c2 08             	add    $0x8,%edx
  800deb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dee:	eb 0f                	jmp    800dff <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800df0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800df4:	48 89 d0             	mov    %rdx,%rax
  800df7:	48 83 c2 08          	add    $0x8,%rdx
  800dfb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dff:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e06:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e0d:	eb 23                	jmp    800e32 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e13:	be 03 00 00 00       	mov    $0x3,%esi
  800e18:	48 89 c7             	mov    %rax,%rdi
  800e1b:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800e22:	00 00 00 
  800e25:	ff d0                	callq  *%rax
  800e27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e2b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e32:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e37:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e3a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e49:	45 89 c1             	mov    %r8d,%r9d
  800e4c:	41 89 f8             	mov    %edi,%r8d
  800e4f:	48 89 c7             	mov    %rax,%rdi
  800e52:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	callq  *%rax
			break;
  800e5e:	eb 3f                	jmp    800e9f <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e60:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e64:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e68:	48 89 c6             	mov    %rax,%rsi
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	ff d2                	callq  *%rdx
			break;
  800e6f:	eb 2e                	jmp    800e9f <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e71:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e75:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e79:	48 89 c6             	mov    %rax,%rsi
  800e7c:	bf 25 00 00 00       	mov    $0x25,%edi
  800e81:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e83:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e88:	eb 05                	jmp    800e8f <vprintfmt+0x517>
  800e8a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e93:	48 83 e8 01          	sub    $0x1,%rax
  800e97:	0f b6 00             	movzbl (%rax),%eax
  800e9a:	3c 25                	cmp    $0x25,%al
  800e9c:	75 ec                	jne    800e8a <vprintfmt+0x512>
				/* do nothing */;
			break;
  800e9e:	90                   	nop
		}
	}
  800e9f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ea0:	e9 25 fb ff ff       	jmpq   8009ca <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800ea5:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ea6:	48 83 c4 60          	add    $0x60,%rsp
  800eaa:	5b                   	pop    %rbx
  800eab:	41 5c                	pop    %r12
  800ead:	5d                   	pop    %rbp
  800eae:	c3                   	retq   

0000000000800eaf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
  800eb3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eba:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ec1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ec8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ecf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ed6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800edd:	84 c0                	test   %al,%al
  800edf:	74 20                	je     800f01 <printfmt+0x52>
  800ee1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ee5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ee9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ef1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ef5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ef9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800efd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f01:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f08:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f0f:	00 00 00 
  800f12:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f19:	00 00 00 
  800f1c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f20:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f27:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f2e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f3c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f43:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f4a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f51:	48 89 c7             	mov    %rax,%rdi
  800f54:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  800f5b:	00 00 00 
  800f5e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f60:	c9                   	leaveq 
  800f61:	c3                   	retq   

0000000000800f62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 83 ec 10          	sub    $0x10,%rsp
  800f6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f75:	8b 40 10             	mov    0x10(%rax),%eax
  800f78:	8d 50 01             	lea    0x1(%rax),%edx
  800f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f86:	48 8b 10             	mov    (%rax),%rdx
  800f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f91:	48 39 c2             	cmp    %rax,%rdx
  800f94:	73 17                	jae    800fad <sprintputch+0x4b>
		*b->buf++ = ch;
  800f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9a:	48 8b 00             	mov    (%rax),%rax
  800f9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fa0:	88 10                	mov    %dl,(%rax)
  800fa2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800faa:	48 89 10             	mov    %rdx,(%rax)
}
  800fad:	c9                   	leaveq 
  800fae:	c3                   	retq   

0000000000800faf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800faf:	55                   	push   %rbp
  800fb0:	48 89 e5             	mov    %rsp,%rbp
  800fb3:	48 83 ec 50          	sub    $0x50,%rsp
  800fb7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fbb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fbe:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fc2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fc6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fca:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fce:	48 8b 0a             	mov    (%rdx),%rcx
  800fd1:	48 89 08             	mov    %rcx,(%rax)
  800fd4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fdc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fe0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fe8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fec:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fef:	48 98                	cltq   
  800ff1:	48 83 e8 01          	sub    $0x1,%rax
  800ff5:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800ff9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ffd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801004:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801009:	74 06                	je     801011 <vsnprintf+0x62>
  80100b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80100f:	7f 07                	jg     801018 <vsnprintf+0x69>
		return -E_INVAL;
  801011:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801016:	eb 2f                	jmp    801047 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801018:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80101c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801020:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801024:	48 89 c6             	mov    %rax,%rsi
  801027:	48 bf 62 0f 80 00 00 	movabs $0x800f62,%rdi
  80102e:	00 00 00 
  801031:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  801038:	00 00 00 
  80103b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80103d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801041:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801044:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801047:	c9                   	leaveq 
  801048:	c3                   	retq   

0000000000801049 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801049:	55                   	push   %rbp
  80104a:	48 89 e5             	mov    %rsp,%rbp
  80104d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801054:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80105b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801061:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801068:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80106f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801076:	84 c0                	test   %al,%al
  801078:	74 20                	je     80109a <snprintf+0x51>
  80107a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80107e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801082:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801086:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80108a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80108e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801092:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801096:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80109a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010a1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010a8:	00 00 00 
  8010ab:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010b2:	00 00 00 
  8010b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010c7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ce:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010d5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010dc:	48 8b 0a             	mov    (%rdx),%rcx
  8010df:	48 89 08             	mov    %rcx,(%rax)
  8010e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010f2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010f9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801100:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801106:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80110d:	48 89 c7             	mov    %rax,%rdi
  801110:	48 b8 af 0f 80 00 00 	movabs $0x800faf,%rax
  801117:	00 00 00 
  80111a:	ff d0                	callq  *%rax
  80111c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801122:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801128:	c9                   	leaveq 
  801129:	c3                   	retq   
	...

000000000080112c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 18          	sub    $0x18,%rsp
  801134:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80113f:	eb 09                	jmp    80114a <strlen+0x1e>
		n++;
  801141:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801145:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	0f b6 00             	movzbl (%rax),%eax
  801151:	84 c0                	test   %al,%al
  801153:	75 ec                	jne    801141 <strlen+0x15>
		n++;
	return n;
  801155:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801158:	c9                   	leaveq 
  801159:	c3                   	retq   

000000000080115a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	48 83 ec 20          	sub    $0x20,%rsp
  801162:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80116a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801171:	eb 0e                	jmp    801181 <strnlen+0x27>
		n++;
  801173:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801177:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80117c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801181:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801186:	74 0b                	je     801193 <strnlen+0x39>
  801188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118c:	0f b6 00             	movzbl (%rax),%eax
  80118f:	84 c0                	test   %al,%al
  801191:	75 e0                	jne    801173 <strnlen+0x19>
		n++;
	return n;
  801193:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801196:	c9                   	leaveq 
  801197:	c3                   	retq   

0000000000801198 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801198:	55                   	push   %rbp
  801199:	48 89 e5             	mov    %rsp,%rbp
  80119c:	48 83 ec 20          	sub    $0x20,%rsp
  8011a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011b0:	90                   	nop
  8011b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b5:	0f b6 10             	movzbl (%rax),%edx
  8011b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bc:	88 10                	mov    %dl,(%rax)
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	0f b6 00             	movzbl (%rax),%eax
  8011c5:	84 c0                	test   %al,%al
  8011c7:	0f 95 c0             	setne  %al
  8011ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011cf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8011d4:	84 c0                	test   %al,%al
  8011d6:	75 d9                	jne    8011b1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011dc:	c9                   	leaveq 
  8011dd:	c3                   	retq   

00000000008011de <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	48 83 ec 20          	sub    $0x20,%rsp
  8011e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f2:	48 89 c7             	mov    %rax,%rdi
  8011f5:	48 b8 2c 11 80 00 00 	movabs $0x80112c,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	callq  *%rax
  801201:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801207:	48 98                	cltq   
  801209:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80120d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801211:	48 89 d6             	mov    %rdx,%rsi
  801214:	48 89 c7             	mov    %rax,%rdi
  801217:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  80121e:	00 00 00 
  801221:	ff d0                	callq  *%rax
	return dst;
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 28          	sub    $0x28,%rsp
  801231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801239:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80123d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801241:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801245:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80124c:	00 
  80124d:	eb 27                	jmp    801276 <strncpy+0x4d>
		*dst++ = *src;
  80124f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801253:	0f b6 10             	movzbl (%rax),%edx
  801256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125a:	88 10                	mov    %dl,(%rax)
  80125c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801261:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801265:	0f b6 00             	movzbl (%rax),%eax
  801268:	84 c0                	test   %al,%al
  80126a:	74 05                	je     801271 <strncpy+0x48>
			src++;
  80126c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801271:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80127e:	72 cf                	jb     80124f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801284:	c9                   	leaveq 
  801285:	c3                   	retq   

0000000000801286 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801286:	55                   	push   %rbp
  801287:	48 89 e5             	mov    %rsp,%rbp
  80128a:	48 83 ec 28          	sub    $0x28,%rsp
  80128e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801292:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801296:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012a7:	74 37                	je     8012e0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8012a9:	eb 17                	jmp    8012c2 <strlcpy+0x3c>
			*dst++ = *src++;
  8012ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012af:	0f b6 10             	movzbl (%rax),%edx
  8012b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b6:	88 10                	mov    %dl,(%rax)
  8012b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012c2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012cc:	74 0b                	je     8012d9 <strlcpy+0x53>
  8012ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	84 c0                	test   %al,%al
  8012d7:	75 d2                	jne    8012ab <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	48 89 d1             	mov    %rdx,%rcx
  8012eb:	48 29 c1             	sub    %rax,%rcx
  8012ee:	48 89 c8             	mov    %rcx,%rax
}
  8012f1:	c9                   	leaveq 
  8012f2:	c3                   	retq   

00000000008012f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f3:	55                   	push   %rbp
  8012f4:	48 89 e5             	mov    %rsp,%rbp
  8012f7:	48 83 ec 10          	sub    $0x10,%rsp
  8012fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801303:	eb 0a                	jmp    80130f <strcmp+0x1c>
		p++, q++;
  801305:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	74 12                	je     80132c <strcmp+0x39>
  80131a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131e:	0f b6 10             	movzbl (%rax),%edx
  801321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	38 c2                	cmp    %al,%dl
  80132a:	74 d9                	je     801305 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	0f b6 d0             	movzbl %al,%edx
  801336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	0f b6 c0             	movzbl %al,%eax
  801340:	89 d1                	mov    %edx,%ecx
  801342:	29 c1                	sub    %eax,%ecx
  801344:	89 c8                	mov    %ecx,%eax
}
  801346:	c9                   	leaveq 
  801347:	c3                   	retq   

0000000000801348 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	48 83 ec 18          	sub    $0x18,%rsp
  801350:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801354:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801358:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80135c:	eb 0f                	jmp    80136d <strncmp+0x25>
		n--, p++, q++;
  80135e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801363:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801368:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80136d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801372:	74 1d                	je     801391 <strncmp+0x49>
  801374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801378:	0f b6 00             	movzbl (%rax),%eax
  80137b:	84 c0                	test   %al,%al
  80137d:	74 12                	je     801391 <strncmp+0x49>
  80137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801383:	0f b6 10             	movzbl (%rax),%edx
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	0f b6 00             	movzbl (%rax),%eax
  80138d:	38 c2                	cmp    %al,%dl
  80138f:	74 cd                	je     80135e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801391:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801396:	75 07                	jne    80139f <strncmp+0x57>
		return 0;
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
  80139d:	eb 1a                	jmp    8013b9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80139f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a3:	0f b6 00             	movzbl (%rax),%eax
  8013a6:	0f b6 d0             	movzbl %al,%edx
  8013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	0f b6 c0             	movzbl %al,%eax
  8013b3:	89 d1                	mov    %edx,%ecx
  8013b5:	29 c1                	sub    %eax,%ecx
  8013b7:	89 c8                	mov    %ecx,%eax
}
  8013b9:	c9                   	leaveq 
  8013ba:	c3                   	retq   

00000000008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	48 83 ec 10          	sub    $0x10,%rsp
  8013c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c7:	89 f0                	mov    %esi,%eax
  8013c9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013cc:	eb 17                	jmp    8013e5 <strchr+0x2a>
		if (*s == c)
  8013ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013d8:	75 06                	jne    8013e0 <strchr+0x25>
			return (char *) s;
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	eb 15                	jmp    8013f5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	0f b6 00             	movzbl (%rax),%eax
  8013ec:	84 c0                	test   %al,%al
  8013ee:	75 de                	jne    8013ce <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f5:	c9                   	leaveq 
  8013f6:	c3                   	retq   

00000000008013f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013f7:	55                   	push   %rbp
  8013f8:	48 89 e5             	mov    %rsp,%rbp
  8013fb:	48 83 ec 10          	sub    $0x10,%rsp
  8013ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801403:	89 f0                	mov    %esi,%eax
  801405:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801408:	eb 11                	jmp    80141b <strfind+0x24>
		if (*s == c)
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801414:	74 12                	je     801428 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801416:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	84 c0                	test   %al,%al
  801424:	75 e4                	jne    80140a <strfind+0x13>
  801426:	eb 01                	jmp    801429 <strfind+0x32>
		if (*s == c)
			break;
  801428:	90                   	nop
	return (char *) s;
  801429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80142d:	c9                   	leaveq 
  80142e:	c3                   	retq   

000000000080142f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80142f:	55                   	push   %rbp
  801430:	48 89 e5             	mov    %rsp,%rbp
  801433:	48 83 ec 18          	sub    $0x18,%rsp
  801437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80143e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801442:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801447:	75 06                	jne    80144f <memset+0x20>
		return v;
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	eb 69                	jmp    8014b8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80144f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801453:	83 e0 03             	and    $0x3,%eax
  801456:	48 85 c0             	test   %rax,%rax
  801459:	75 48                	jne    8014a3 <memset+0x74>
  80145b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145f:	83 e0 03             	and    $0x3,%eax
  801462:	48 85 c0             	test   %rax,%rax
  801465:	75 3c                	jne    8014a3 <memset+0x74>
		c &= 0xFF;
  801467:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80146e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801471:	89 c2                	mov    %eax,%edx
  801473:	c1 e2 18             	shl    $0x18,%edx
  801476:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801479:	c1 e0 10             	shl    $0x10,%eax
  80147c:	09 c2                	or     %eax,%edx
  80147e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801481:	c1 e0 08             	shl    $0x8,%eax
  801484:	09 d0                	or     %edx,%eax
  801486:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148d:	48 89 c1             	mov    %rax,%rcx
  801490:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801494:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801498:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80149b:	48 89 d7             	mov    %rdx,%rdi
  80149e:	fc                   	cld    
  80149f:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014a1:	eb 11                	jmp    8014b4 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014aa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014ae:	48 89 d7             	mov    %rdx,%rdi
  8014b1:	fc                   	cld    
  8014b2:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014b8:	c9                   	leaveq 
  8014b9:	c3                   	retq   

00000000008014ba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014ba:	55                   	push   %rbp
  8014bb:	48 89 e5             	mov    %rsp,%rbp
  8014be:	48 83 ec 28          	sub    $0x28,%rsp
  8014c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e6:	0f 83 88 00 00 00    	jae    801574 <memmove+0xba>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f4:	48 01 d0             	add    %rdx,%rax
  8014f7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014fb:	76 77                	jbe    801574 <memmove+0xba>
		s += n;
  8014fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801501:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	83 e0 03             	and    $0x3,%eax
  801514:	48 85 c0             	test   %rax,%rax
  801517:	75 3b                	jne    801554 <memmove+0x9a>
  801519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151d:	83 e0 03             	and    $0x3,%eax
  801520:	48 85 c0             	test   %rax,%rax
  801523:	75 2f                	jne    801554 <memmove+0x9a>
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	83 e0 03             	and    $0x3,%eax
  80152c:	48 85 c0             	test   %rax,%rax
  80152f:	75 23                	jne    801554 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801535:	48 83 e8 04          	sub    $0x4,%rax
  801539:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153d:	48 83 ea 04          	sub    $0x4,%rdx
  801541:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801545:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 89 d6             	mov    %rdx,%rsi
  80154f:	fd                   	std    
  801550:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801552:	eb 1d                	jmp    801571 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	48 89 d7             	mov    %rdx,%rdi
  80156b:	48 89 c1             	mov    %rax,%rcx
  80156e:	fd                   	std    
  80156f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801571:	fc                   	cld    
  801572:	eb 57                	jmp    8015cb <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	83 e0 03             	and    $0x3,%eax
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	75 36                	jne    8015b6 <memmove+0xfc>
  801580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801584:	83 e0 03             	and    $0x3,%eax
  801587:	48 85 c0             	test   %rax,%rax
  80158a:	75 2a                	jne    8015b6 <memmove+0xfc>
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	83 e0 03             	and    $0x3,%eax
  801593:	48 85 c0             	test   %rax,%rax
  801596:	75 1e                	jne    8015b6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 89 c1             	mov    %rax,%rcx
  80159f:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ab:	48 89 c7             	mov    %rax,%rdi
  8015ae:	48 89 d6             	mov    %rdx,%rsi
  8015b1:	fc                   	cld    
  8015b2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b4:	eb 15                	jmp    8015cb <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c2:	48 89 c7             	mov    %rax,%rdi
  8015c5:	48 89 d6             	mov    %rdx,%rsi
  8015c8:	fc                   	cld    
  8015c9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015cf:	c9                   	leaveq 
  8015d0:	c3                   	retq   

00000000008015d1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015d1:	55                   	push   %rbp
  8015d2:	48 89 e5             	mov    %rsp,%rbp
  8015d5:	48 83 ec 18          	sub    $0x18,%rsp
  8015d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f1:	48 89 ce             	mov    %rcx,%rsi
  8015f4:	48 89 c7             	mov    %rax,%rdi
  8015f7:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  8015fe:	00 00 00 
  801601:	ff d0                	callq  *%rax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 83 ec 28          	sub    $0x28,%rsp
  80160d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801611:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801615:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801625:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801629:	eb 38                	jmp    801663 <memcmp+0x5e>
		if (*s1 != *s2)
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	0f b6 10             	movzbl (%rax),%edx
  801632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	38 c2                	cmp    %al,%dl
  80163b:	74 1c                	je     801659 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80163d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	0f b6 d0             	movzbl %al,%edx
  801647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	0f b6 c0             	movzbl %al,%eax
  801651:	89 d1                	mov    %edx,%ecx
  801653:	29 c1                	sub    %eax,%ecx
  801655:	89 c8                	mov    %ecx,%eax
  801657:	eb 20                	jmp    801679 <memcmp+0x74>
		s1++, s2++;
  801659:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80165e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801663:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801668:	0f 95 c0             	setne  %al
  80166b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801670:	84 c0                	test   %al,%al
  801672:	75 b7                	jne    80162b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801679:	c9                   	leaveq 
  80167a:	c3                   	retq   

000000000080167b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80167b:	55                   	push   %rbp
  80167c:	48 89 e5             	mov    %rsp,%rbp
  80167f:	48 83 ec 28          	sub    $0x28,%rsp
  801683:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801687:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80168a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801696:	48 01 d0             	add    %rdx,%rax
  801699:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80169d:	eb 13                	jmp    8016b2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80169f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a3:	0f b6 10             	movzbl (%rax),%edx
  8016a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016a9:	38 c2                	cmp    %al,%dl
  8016ab:	74 11                	je     8016be <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016ba:	72 e3                	jb     80169f <memfind+0x24>
  8016bc:	eb 01                	jmp    8016bf <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016be:	90                   	nop
	return (void *) s;
  8016bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 38          	sub    $0x38,%rsp
  8016cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016d5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016df:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016e6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e7:	eb 05                	jmp    8016ee <strtol+0x29>
		s++;
  8016e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	3c 20                	cmp    $0x20,%al
  8016f7:	74 f0                	je     8016e9 <strtol+0x24>
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	0f b6 00             	movzbl (%rax),%eax
  801700:	3c 09                	cmp    $0x9,%al
  801702:	74 e5                	je     8016e9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	3c 2b                	cmp    $0x2b,%al
  80170d:	75 07                	jne    801716 <strtol+0x51>
		s++;
  80170f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801714:	eb 17                	jmp    80172d <strtol+0x68>
	else if (*s == '-')
  801716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	3c 2d                	cmp    $0x2d,%al
  80171f:	75 0c                	jne    80172d <strtol+0x68>
		s++, neg = 1;
  801721:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801726:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80172d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801731:	74 06                	je     801739 <strtol+0x74>
  801733:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801737:	75 28                	jne    801761 <strtol+0x9c>
  801739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173d:	0f b6 00             	movzbl (%rax),%eax
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 1d                	jne    801761 <strtol+0x9c>
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	48 83 c0 01          	add    $0x1,%rax
  80174c:	0f b6 00             	movzbl (%rax),%eax
  80174f:	3c 78                	cmp    $0x78,%al
  801751:	75 0e                	jne    801761 <strtol+0x9c>
		s += 2, base = 16;
  801753:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801758:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80175f:	eb 2c                	jmp    80178d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801761:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801765:	75 19                	jne    801780 <strtol+0xbb>
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 30                	cmp    $0x30,%al
  801770:	75 0e                	jne    801780 <strtol+0xbb>
		s++, base = 8;
  801772:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801777:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80177e:	eb 0d                	jmp    80178d <strtol+0xc8>
	else if (base == 0)
  801780:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801784:	75 07                	jne    80178d <strtol+0xc8>
		base = 10;
  801786:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	0f b6 00             	movzbl (%rax),%eax
  801794:	3c 2f                	cmp    $0x2f,%al
  801796:	7e 1d                	jle    8017b5 <strtol+0xf0>
  801798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179c:	0f b6 00             	movzbl (%rax),%eax
  80179f:	3c 39                	cmp    $0x39,%al
  8017a1:	7f 12                	jg     8017b5 <strtol+0xf0>
			dig = *s - '0';
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	0f be c0             	movsbl %al,%eax
  8017ad:	83 e8 30             	sub    $0x30,%eax
  8017b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017b3:	eb 4e                	jmp    801803 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	0f b6 00             	movzbl (%rax),%eax
  8017bc:	3c 60                	cmp    $0x60,%al
  8017be:	7e 1d                	jle    8017dd <strtol+0x118>
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	3c 7a                	cmp    $0x7a,%al
  8017c9:	7f 12                	jg     8017dd <strtol+0x118>
			dig = *s - 'a' + 10;
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	0f be c0             	movsbl %al,%eax
  8017d5:	83 e8 57             	sub    $0x57,%eax
  8017d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017db:	eb 26                	jmp    801803 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e1:	0f b6 00             	movzbl (%rax),%eax
  8017e4:	3c 40                	cmp    $0x40,%al
  8017e6:	7e 47                	jle    80182f <strtol+0x16a>
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	3c 5a                	cmp    $0x5a,%al
  8017f1:	7f 3c                	jg     80182f <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	0f be c0             	movsbl %al,%eax
  8017fd:	83 e8 37             	sub    $0x37,%eax
  801800:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801803:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801806:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801809:	7d 23                	jge    80182e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80180b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801810:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801813:	48 98                	cltq   
  801815:	48 89 c2             	mov    %rax,%rdx
  801818:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80181d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801820:	48 98                	cltq   
  801822:	48 01 d0             	add    %rdx,%rax
  801825:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801829:	e9 5f ff ff ff       	jmpq   80178d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80182e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80182f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801834:	74 0b                	je     801841 <strtol+0x17c>
		*endptr = (char *) s;
  801836:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80183e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801845:	74 09                	je     801850 <strtol+0x18b>
  801847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184b:	48 f7 d8             	neg    %rax
  80184e:	eb 04                	jmp    801854 <strtol+0x18f>
  801850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801854:	c9                   	leaveq 
  801855:	c3                   	retq   

0000000000801856 <strstr>:

char * strstr(const char *in, const char *str)
{
  801856:	55                   	push   %rbp
  801857:	48 89 e5             	mov    %rsp,%rbp
  80185a:	48 83 ec 30          	sub    $0x30,%rsp
  80185e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801862:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801866:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801870:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801875:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801879:	75 06                	jne    801881 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  80187b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187f:	eb 68                	jmp    8018e9 <strstr+0x93>

	len = strlen(str);
  801881:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801885:	48 89 c7             	mov    %rax,%rdi
  801888:	48 b8 2c 11 80 00 00 	movabs $0x80112c,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
  801894:	48 98                	cltq   
  801896:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80189a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189e:	0f b6 00             	movzbl (%rax),%eax
  8018a1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8018a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  8018a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018ad:	75 07                	jne    8018b6 <strstr+0x60>
				return (char *) 0;
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	eb 33                	jmp    8018e9 <strstr+0x93>
		} while (sc != c);
  8018b6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018ba:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018bd:	75 db                	jne    80189a <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8018bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cb:	48 89 ce             	mov    %rcx,%rsi
  8018ce:	48 89 c7             	mov    %rax,%rdi
  8018d1:	48 b8 48 13 80 00 00 	movabs $0x801348,%rax
  8018d8:	00 00 00 
  8018db:	ff d0                	callq  *%rax
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	75 b9                	jne    80189a <strstr+0x44>

	return (char *) (in - 1);
  8018e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e5:	48 83 e8 01          	sub    $0x1,%rax
}
  8018e9:	c9                   	leaveq 
  8018ea:	c3                   	retq   
	...

00000000008018ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	53                   	push   %rbx
  8018f1:	48 83 ec 58          	sub    $0x58,%rsp
  8018f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018f8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018fb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ff:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801903:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801907:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80190b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80190e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801911:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801915:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801919:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80191d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801921:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801925:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801928:	4c 89 c3             	mov    %r8,%rbx
  80192b:	cd 30                	int    $0x30
  80192d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801931:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801935:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801939:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80193d:	74 3e                	je     80197d <syscall+0x91>
  80193f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801944:	7e 37                	jle    80197d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80194a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80194d:	49 89 d0             	mov    %rdx,%r8
  801950:	89 c1                	mov    %eax,%ecx
  801952:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  801959:	00 00 00 
  80195c:	be 23 00 00 00       	mov    $0x23,%esi
  801961:	48 bf 25 46 80 00 00 	movabs $0x804625,%rdi
  801968:	00 00 00 
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  801977:	00 00 00 
  80197a:	41 ff d1             	callq  *%r9

	return ret;
  80197d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801981:	48 83 c4 58          	add    $0x58,%rsp
  801985:	5b                   	pop    %rbx
  801986:	5d                   	pop    %rbp
  801987:	c3                   	retq   

0000000000801988 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	48 83 ec 20          	sub    $0x20,%rsp
  801990:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801994:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	48 89 d1             	mov    %rdx,%rcx
  8019b7:	48 89 c2             	mov    %rax,%rdx
  8019ba:	be 00 00 00 00       	mov    $0x0,%esi
  8019bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8019c4:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e1:	00 
  8019e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f8:	be 00 00 00 00       	mov    $0x0,%esi
  8019fd:	bf 01 00 00 00       	mov    $0x1,%edi
  801a02:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
}
  801a0e:	c9                   	leaveq 
  801a0f:	c3                   	retq   

0000000000801a10 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	48 83 ec 20          	sub    $0x20,%rsp
  801a18:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1e:	48 98                	cltq   
  801a20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a27:	00 
  801a28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a34:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a39:	48 89 c2             	mov    %rax,%rdx
  801a3c:	be 01 00 00 00       	mov    $0x1,%esi
  801a41:	bf 03 00 00 00       	mov    $0x3,%edi
  801a46:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801a4d:	00 00 00 
  801a50:	ff d0                	callq  *%rax
}
  801a52:	c9                   	leaveq 
  801a53:	c3                   	retq   

0000000000801a54 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a54:	55                   	push   %rbp
  801a55:	48 89 e5             	mov    %rsp,%rbp
  801a58:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a63:	00 
  801a64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a70:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a75:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7a:	be 00 00 00 00       	mov    $0x0,%esi
  801a7f:	bf 02 00 00 00       	mov    $0x2,%edi
  801a84:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801a8b:	00 00 00 
  801a8e:	ff d0                	callq  *%rax
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <sys_yield>:

void
sys_yield(void)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab8:	be 00 00 00 00       	mov    $0x0,%esi
  801abd:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ac2:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801adb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801adf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae5:	48 63 c8             	movslq %eax,%rcx
  801ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af8:	00 
  801af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aff:	49 89 c8             	mov    %rcx,%r8
  801b02:	48 89 d1             	mov    %rdx,%rcx
  801b05:	48 89 c2             	mov    %rax,%rdx
  801b08:	be 01 00 00 00       	mov    $0x1,%esi
  801b0d:	bf 04 00 00 00       	mov    $0x4,%edi
  801b12:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	48 83 ec 30          	sub    $0x30,%rsp
  801b28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b32:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b36:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b3a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b3d:	48 63 c8             	movslq %eax,%rcx
  801b40:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b47:	48 63 f0             	movslq %eax,%rsi
  801b4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b51:	48 98                	cltq   
  801b53:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b57:	49 89 f9             	mov    %rdi,%r9
  801b5a:	49 89 f0             	mov    %rsi,%r8
  801b5d:	48 89 d1             	mov    %rdx,%rcx
  801b60:	48 89 c2             	mov    %rax,%rdx
  801b63:	be 01 00 00 00       	mov    $0x1,%esi
  801b68:	bf 05 00 00 00       	mov    $0x5,%edi
  801b6d:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
}
  801b79:	c9                   	leaveq 
  801b7a:	c3                   	retq   

0000000000801b7b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b7b:	55                   	push   %rbp
  801b7c:	48 89 e5             	mov    %rsp,%rbp
  801b7f:	48 83 ec 20          	sub    $0x20,%rsp
  801b83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b91:	48 98                	cltq   
  801b93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9a:	00 
  801b9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba7:	48 89 d1             	mov    %rdx,%rcx
  801baa:	48 89 c2             	mov    %rax,%rdx
  801bad:	be 01 00 00 00       	mov    $0x1,%esi
  801bb2:	bf 06 00 00 00       	mov    $0x6,%edi
  801bb7:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
}
  801bc3:	c9                   	leaveq 
  801bc4:	c3                   	retq   

0000000000801bc5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bc5:	55                   	push   %rbp
  801bc6:	48 89 e5             	mov    %rsp,%rbp
  801bc9:	48 83 ec 20          	sub    $0x20,%rsp
  801bcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd6:	48 63 d0             	movslq %eax,%rdx
  801bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdc:	48 98                	cltq   
  801bde:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be5:	00 
  801be6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf2:	48 89 d1             	mov    %rdx,%rcx
  801bf5:	48 89 c2             	mov    %rax,%rdx
  801bf8:	be 01 00 00 00       	mov    $0x1,%esi
  801bfd:	bf 08 00 00 00       	mov    $0x8,%edi
  801c02:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
}
  801c0e:	c9                   	leaveq 
  801c0f:	c3                   	retq   

0000000000801c10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
  801c14:	48 83 ec 20          	sub    $0x20,%rsp
  801c18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c26:	48 98                	cltq   
  801c28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2f:	00 
  801c30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3c:	48 89 d1             	mov    %rdx,%rcx
  801c3f:	48 89 c2             	mov    %rax,%rdx
  801c42:	be 01 00 00 00       	mov    $0x1,%esi
  801c47:	bf 09 00 00 00       	mov    $0x9,%edi
  801c4c:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	callq  *%rax
}
  801c58:	c9                   	leaveq 
  801c59:	c3                   	retq   

0000000000801c5a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c5a:	55                   	push   %rbp
  801c5b:	48 89 e5             	mov    %rsp,%rbp
  801c5e:	48 83 ec 20          	sub    $0x20,%rsp
  801c62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c70:	48 98                	cltq   
  801c72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c79:	00 
  801c7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c86:	48 89 d1             	mov    %rdx,%rcx
  801c89:	48 89 c2             	mov    %rax,%rdx
  801c8c:	be 01 00 00 00       	mov    $0x1,%esi
  801c91:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c96:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	callq  *%rax
}
  801ca2:	c9                   	leaveq 
  801ca3:	c3                   	retq   

0000000000801ca4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ca4:	55                   	push   %rbp
  801ca5:	48 89 e5             	mov    %rsp,%rbp
  801ca8:	48 83 ec 30          	sub    $0x30,%rsp
  801cac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801caf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cb3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cb7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cbd:	48 63 f0             	movslq %eax,%rsi
  801cc0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc7:	48 98                	cltq   
  801cc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ccd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd4:	00 
  801cd5:	49 89 f1             	mov    %rsi,%r9
  801cd8:	49 89 c8             	mov    %rcx,%r8
  801cdb:	48 89 d1             	mov    %rdx,%rcx
  801cde:	48 89 c2             	mov    %rax,%rdx
  801ce1:	be 00 00 00 00       	mov    $0x0,%esi
  801ce6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ceb:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801cf2:	00 00 00 
  801cf5:	ff d0                	callq  *%rax
}
  801cf7:	c9                   	leaveq 
  801cf8:	c3                   	retq   

0000000000801cf9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	48 83 ec 20          	sub    $0x20,%rsp
  801d01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d10:	00 
  801d11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d22:	48 89 c2             	mov    %rax,%rdx
  801d25:	be 01 00 00 00       	mov    $0x1,%esi
  801d2a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d2f:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801d36:	00 00 00 
  801d39:	ff d0                	callq  *%rax
}
  801d3b:	c9                   	leaveq 
  801d3c:	c3                   	retq   

0000000000801d3d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4c:	00 
  801d4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	be 00 00 00 00       	mov    $0x0,%esi
  801d68:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d6d:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801d74:	00 00 00 
  801d77:	ff d0                	callq  *%rax
}
  801d79:	c9                   	leaveq 
  801d7a:	c3                   	retq   

0000000000801d7b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d7b:	55                   	push   %rbp
  801d7c:	48 89 e5             	mov    %rsp,%rbp
  801d7f:	48 83 ec 30          	sub    $0x30,%rsp
  801d83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d8a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d8d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d91:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d95:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d98:	48 63 c8             	movslq %eax,%rcx
  801d9b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da2:	48 63 f0             	movslq %eax,%rsi
  801da5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dac:	48 98                	cltq   
  801dae:	48 89 0c 24          	mov    %rcx,(%rsp)
  801db2:	49 89 f9             	mov    %rdi,%r9
  801db5:	49 89 f0             	mov    %rsi,%r8
  801db8:	48 89 d1             	mov    %rdx,%rcx
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dc8:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 20          	sub    $0x20,%rsp
  801dde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801de6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df5:	00 
  801df6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e02:	48 89 d1             	mov    %rdx,%rcx
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	be 00 00 00 00       	mov    $0x0,%esi
  801e0d:	bf 10 00 00 00       	mov    $0x10,%edi
  801e12:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
}
  801e1e:	c9                   	leaveq 
  801e1f:	c3                   	retq   

0000000000801e20 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e20:	55                   	push   %rbp
  801e21:	48 89 e5             	mov    %rsp,%rbp
  801e24:	48 83 ec 08          	sub    $0x8,%rsp
  801e28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e30:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e37:	ff ff ff 
  801e3a:	48 01 d0             	add    %rdx,%rax
  801e3d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e41:	c9                   	leaveq 
  801e42:	c3                   	retq   

0000000000801e43 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e43:	55                   	push   %rbp
  801e44:	48 89 e5             	mov    %rsp,%rbp
  801e47:	48 83 ec 08          	sub    $0x8,%rsp
  801e4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e53:	48 89 c7             	mov    %rax,%rdi
  801e56:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801e5d:	00 00 00 
  801e60:	ff d0                	callq  *%rax
  801e62:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e68:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 18          	sub    $0x18,%rsp
  801e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e81:	eb 6b                	jmp    801eee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e86:	48 98                	cltq   
  801e88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e8e:	48 c1 e0 0c          	shl    $0xc,%rax
  801e92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9a:	48 89 c2             	mov    %rax,%rdx
  801e9d:	48 c1 ea 15          	shr    $0x15,%rdx
  801ea1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea8:	01 00 00 
  801eab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eaf:	83 e0 01             	and    $0x1,%eax
  801eb2:	48 85 c0             	test   %rax,%rax
  801eb5:	74 21                	je     801ed8 <fd_alloc+0x6a>
  801eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebb:	48 89 c2             	mov    %rax,%rdx
  801ebe:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ec2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec9:	01 00 00 
  801ecc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed0:	83 e0 01             	and    $0x1,%eax
  801ed3:	48 85 c0             	test   %rax,%rax
  801ed6:	75 12                	jne    801eea <fd_alloc+0x7c>
			*fd_store = fd;
  801ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee8:	eb 1a                	jmp    801f04 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ef2:	7e 8f                	jle    801e83 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f04:	c9                   	leaveq 
  801f05:	c3                   	retq   

0000000000801f06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f06:	55                   	push   %rbp
  801f07:	48 89 e5             	mov    %rsp,%rbp
  801f0a:	48 83 ec 20          	sub    $0x20,%rsp
  801f0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f19:	78 06                	js     801f21 <fd_lookup+0x1b>
  801f1b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f1f:	7e 07                	jle    801f28 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f26:	eb 6c                	jmp    801f94 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f2b:	48 98                	cltq   
  801f2d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f33:	48 c1 e0 0c          	shl    $0xc,%rax
  801f37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3f:	48 89 c2             	mov    %rax,%rdx
  801f42:	48 c1 ea 15          	shr    $0x15,%rdx
  801f46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f4d:	01 00 00 
  801f50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f54:	83 e0 01             	and    $0x1,%eax
  801f57:	48 85 c0             	test   %rax,%rax
  801f5a:	74 21                	je     801f7d <fd_lookup+0x77>
  801f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f60:	48 89 c2             	mov    %rax,%rdx
  801f63:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6e:	01 00 00 
  801f71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f75:	83 e0 01             	and    $0x1,%eax
  801f78:	48 85 c0             	test   %rax,%rax
  801f7b:	75 07                	jne    801f84 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f82:	eb 10                	jmp    801f94 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f8c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leaveq 
  801f95:	c3                   	retq   

0000000000801f96 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f96:	55                   	push   %rbp
  801f97:	48 89 e5             	mov    %rsp,%rbp
  801f9a:	48 83 ec 30          	sub    $0x30,%rsp
  801f9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fa2:	89 f0                	mov    %esi,%eax
  801fa4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fab:	48 89 c7             	mov    %rax,%rdi
  801fae:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801fb5:	00 00 00 
  801fb8:	ff d0                	callq  *%rax
  801fba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fbe:	48 89 d6             	mov    %rdx,%rsi
  801fc1:	89 c7                	mov    %eax,%edi
  801fc3:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax
  801fcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd6:	78 0a                	js     801fe2 <fd_close+0x4c>
	    || fd != fd2)
  801fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fe0:	74 12                	je     801ff4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fe2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fe6:	74 05                	je     801fed <fd_close+0x57>
  801fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801feb:	eb 05                	jmp    801ff2 <fd_close+0x5c>
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	eb 69                	jmp    80205d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff8:	8b 00                	mov    (%rax),%eax
  801ffa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ffe:	48 89 d6             	mov    %rdx,%rsi
  802001:	89 c7                	mov    %eax,%edi
  802003:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
  80200f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802012:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802016:	78 2a                	js     802042 <fd_close+0xac>
		if (dev->dev_close)
  802018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	74 16                	je     80203b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802029:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80202d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802031:	48 89 c7             	mov    %rax,%rdi
  802034:	ff d2                	callq  *%rdx
  802036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802039:	eb 07                	jmp    802042 <fd_close+0xac>
		else
			r = 0;
  80203b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802042:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802046:	48 89 c6             	mov    %rax,%rsi
  802049:	bf 00 00 00 00       	mov    $0x0,%edi
  80204e:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
	return r;
  80205a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80205d:	c9                   	leaveq 
  80205e:	c3                   	retq   

000000000080205f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80205f:	55                   	push   %rbp
  802060:	48 89 e5             	mov    %rsp,%rbp
  802063:	48 83 ec 20          	sub    $0x20,%rsp
  802067:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80206a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80206e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802075:	eb 41                	jmp    8020b8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802077:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80207e:	00 00 00 
  802081:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802084:	48 63 d2             	movslq %edx,%rdx
  802087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208b:	8b 00                	mov    (%rax),%eax
  80208d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802090:	75 22                	jne    8020b4 <dev_lookup+0x55>
			*dev = devtab[i];
  802092:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802099:	00 00 00 
  80209c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80209f:	48 63 d2             	movslq %edx,%rdx
  8020a2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020aa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	eb 60                	jmp    802114 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020bf:	00 00 00 
  8020c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c5:	48 63 d2             	movslq %edx,%rdx
  8020c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cc:	48 85 c0             	test   %rax,%rax
  8020cf:	75 a6                	jne    802077 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020d1:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8020d8:	00 00 00 
  8020db:	48 8b 00             	mov    (%rax),%rax
  8020de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020e7:	89 c6                	mov    %eax,%esi
  8020e9:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  8020f0:	00 00 00 
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	48 b9 c7 05 80 00 00 	movabs $0x8005c7,%rcx
  8020ff:	00 00 00 
  802102:	ff d1                	callq  *%rcx
	*dev = 0;
  802104:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802108:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80210f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802114:	c9                   	leaveq 
  802115:	c3                   	retq   

0000000000802116 <close>:

int
close(int fdnum)
{
  802116:	55                   	push   %rbp
  802117:	48 89 e5             	mov    %rsp,%rbp
  80211a:	48 83 ec 20          	sub    $0x20,%rsp
  80211e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802121:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802125:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802128:	48 89 d6             	mov    %rdx,%rsi
  80212b:	89 c7                	mov    %eax,%edi
  80212d:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802134:	00 00 00 
  802137:	ff d0                	callq  *%rax
  802139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80213c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802140:	79 05                	jns    802147 <close+0x31>
		return r;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802145:	eb 18                	jmp    80215f <close+0x49>
	else
		return fd_close(fd, 1);
  802147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214b:	be 01 00 00 00       	mov    $0x1,%esi
  802150:	48 89 c7             	mov    %rax,%rdi
  802153:	48 b8 96 1f 80 00 00 	movabs $0x801f96,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	callq  *%rax
}
  80215f:	c9                   	leaveq 
  802160:	c3                   	retq   

0000000000802161 <close_all>:

void
close_all(void)
{
  802161:	55                   	push   %rbp
  802162:	48 89 e5             	mov    %rsp,%rbp
  802165:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802170:	eb 15                	jmp    802187 <close_all+0x26>
		close(i);
  802172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802175:	89 c7                	mov    %eax,%edi
  802177:	48 b8 16 21 80 00 00 	movabs $0x802116,%rax
  80217e:	00 00 00 
  802181:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802183:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802187:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80218b:	7e e5                	jle    802172 <close_all+0x11>
		close(i);
}
  80218d:	c9                   	leaveq 
  80218e:	c3                   	retq   

000000000080218f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80218f:	55                   	push   %rbp
  802190:	48 89 e5             	mov    %rsp,%rbp
  802193:	48 83 ec 40          	sub    $0x40,%rsp
  802197:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80219a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80219d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021a4:	48 89 d6             	mov    %rdx,%rsi
  8021a7:	89 c7                	mov    %eax,%edi
  8021a9:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	callq  *%rax
  8021b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bc:	79 08                	jns    8021c6 <dup+0x37>
		return r;
  8021be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c1:	e9 70 01 00 00       	jmpq   802336 <dup+0x1a7>
	close(newfdnum);
  8021c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021c9:	89 c7                	mov    %eax,%edi
  8021cb:	48 b8 16 21 80 00 00 	movabs $0x802116,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021d7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021da:	48 98                	cltq   
  8021dc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ee:	48 89 c7             	mov    %rax,%rdi
  8021f1:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802205:	48 89 c7             	mov    %rax,%rdi
  802208:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  80220f:	00 00 00 
  802212:	ff d0                	callq  *%rax
  802214:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221c:	48 89 c2             	mov    %rax,%rdx
  80221f:	48 c1 ea 15          	shr    $0x15,%rdx
  802223:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80222a:	01 00 00 
  80222d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802231:	83 e0 01             	and    $0x1,%eax
  802234:	84 c0                	test   %al,%al
  802236:	74 71                	je     8022a9 <dup+0x11a>
  802238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223c:	48 89 c2             	mov    %rax,%rdx
  80223f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802243:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224a:	01 00 00 
  80224d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802251:	83 e0 01             	and    $0x1,%eax
  802254:	84 c0                	test   %al,%al
  802256:	74 51                	je     8022a9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225c:	48 89 c2             	mov    %rax,%rdx
  80225f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802263:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80226a:	01 00 00 
  80226d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802271:	89 c1                	mov    %eax,%ecx
  802273:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802279:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80227d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802281:	41 89 c8             	mov    %ecx,%r8d
  802284:	48 89 d1             	mov    %rdx,%rcx
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	48 89 c6             	mov    %rax,%rsi
  80228f:	bf 00 00 00 00       	mov    $0x0,%edi
  802294:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  80229b:	00 00 00 
  80229e:	ff d0                	callq  *%rax
  8022a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a7:	78 56                	js     8022ff <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ad:	48 89 c2             	mov    %rax,%rdx
  8022b0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022bb:	01 00 00 
  8022be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c2:	89 c1                	mov    %eax,%ecx
  8022c4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8022ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d2:	41 89 c8             	mov    %ecx,%r8d
  8022d5:	48 89 d1             	mov    %rdx,%rcx
  8022d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022dd:	48 89 c6             	mov    %rax,%rsi
  8022e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e5:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	callq  *%rax
  8022f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f8:	78 08                	js     802302 <dup+0x173>
		goto err;

	return newfdnum;
  8022fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022fd:	eb 37                	jmp    802336 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022ff:	90                   	nop
  802300:	eb 01                	jmp    802303 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802302:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802307:	48 89 c6             	mov    %rax,%rsi
  80230a:	bf 00 00 00 00       	mov    $0x0,%edi
  80230f:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  802316:	00 00 00 
  802319:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80231b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80231f:	48 89 c6             	mov    %rax,%rsi
  802322:	bf 00 00 00 00       	mov    $0x0,%edi
  802327:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  80232e:	00 00 00 
  802331:	ff d0                	callq  *%rax
	return r;
  802333:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802336:	c9                   	leaveq 
  802337:	c3                   	retq   

0000000000802338 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802338:	55                   	push   %rbp
  802339:	48 89 e5             	mov    %rsp,%rbp
  80233c:	48 83 ec 40          	sub    $0x40,%rsp
  802340:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802343:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802347:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80234b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80234f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802352:	48 89 d6             	mov    %rdx,%rsi
  802355:	89 c7                	mov    %eax,%edi
  802357:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax
  802363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236a:	78 24                	js     802390 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80236c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802370:	8b 00                	mov    (%rax),%eax
  802372:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802376:	48 89 d6             	mov    %rdx,%rsi
  802379:	89 c7                	mov    %eax,%edi
  80237b:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  802382:	00 00 00 
  802385:	ff d0                	callq  *%rax
  802387:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238e:	79 05                	jns    802395 <read+0x5d>
		return r;
  802390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802393:	eb 7a                	jmp    80240f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802399:	8b 40 08             	mov    0x8(%rax),%eax
  80239c:	83 e0 03             	and    $0x3,%eax
  80239f:	83 f8 01             	cmp    $0x1,%eax
  8023a2:	75 3a                	jne    8023de <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023a4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8023ab:	00 00 00 
  8023ae:	48 8b 00             	mov    (%rax),%rax
  8023b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023ba:	89 c6                	mov    %eax,%esi
  8023bc:	48 bf 57 46 80 00 00 	movabs $0x804657,%rdi
  8023c3:	00 00 00 
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	48 b9 c7 05 80 00 00 	movabs $0x8005c7,%rcx
  8023d2:	00 00 00 
  8023d5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023dc:	eb 31                	jmp    80240f <read+0xd7>
	}
	if (!dev->dev_read)
  8023de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023e6:	48 85 c0             	test   %rax,%rax
  8023e9:	75 07                	jne    8023f2 <read+0xba>
		return -E_NOT_SUPP;
  8023eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023f0:	eb 1d                	jmp    80240f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8023f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802402:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802406:	48 89 ce             	mov    %rcx,%rsi
  802409:	48 89 c7             	mov    %rax,%rdi
  80240c:	41 ff d0             	callq  *%r8
}
  80240f:	c9                   	leaveq 
  802410:	c3                   	retq   

0000000000802411 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802411:	55                   	push   %rbp
  802412:	48 89 e5             	mov    %rsp,%rbp
  802415:	48 83 ec 30          	sub    $0x30,%rsp
  802419:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80241c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802420:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80242b:	eb 46                	jmp    802473 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80242d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802430:	48 98                	cltq   
  802432:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802436:	48 29 c2             	sub    %rax,%rdx
  802439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243c:	48 98                	cltq   
  80243e:	48 89 c1             	mov    %rax,%rcx
  802441:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802445:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802448:	48 89 ce             	mov    %rcx,%rsi
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 38 23 80 00 00 	movabs $0x802338,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80245c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802460:	79 05                	jns    802467 <readn+0x56>
			return m;
  802462:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802465:	eb 1d                	jmp    802484 <readn+0x73>
		if (m == 0)
  802467:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80246b:	74 13                	je     802480 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80246d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802470:	01 45 fc             	add    %eax,-0x4(%rbp)
  802473:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802476:	48 98                	cltq   
  802478:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80247c:	72 af                	jb     80242d <readn+0x1c>
  80247e:	eb 01                	jmp    802481 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802480:	90                   	nop
	}
	return tot;
  802481:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802484:	c9                   	leaveq 
  802485:	c3                   	retq   

0000000000802486 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802486:	55                   	push   %rbp
  802487:	48 89 e5             	mov    %rsp,%rbp
  80248a:	48 83 ec 40          	sub    $0x40,%rsp
  80248e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802491:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802495:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802499:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80249d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	78 24                	js     8024de <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024be:	8b 00                	mov    (%rax),%eax
  8024c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c4:	48 89 d6             	mov    %rdx,%rsi
  8024c7:	89 c7                	mov    %eax,%edi
  8024c9:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024dc:	79 05                	jns    8024e3 <write+0x5d>
		return r;
  8024de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e1:	eb 79                	jmp    80255c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e7:	8b 40 08             	mov    0x8(%rax),%eax
  8024ea:	83 e0 03             	and    $0x3,%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	75 3a                	jne    80252b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024f1:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8024f8:	00 00 00 
  8024fb:	48 8b 00             	mov    (%rax),%rax
  8024fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802504:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802507:	89 c6                	mov    %eax,%esi
  802509:	48 bf 73 46 80 00 00 	movabs $0x804673,%rdi
  802510:	00 00 00 
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	48 b9 c7 05 80 00 00 	movabs $0x8005c7,%rcx
  80251f:	00 00 00 
  802522:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802529:	eb 31                	jmp    80255c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80252b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802533:	48 85 c0             	test   %rax,%rax
  802536:	75 07                	jne    80253f <write+0xb9>
		return -E_NOT_SUPP;
  802538:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80253d:	eb 1d                	jmp    80255c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80254f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802553:	48 89 ce             	mov    %rcx,%rsi
  802556:	48 89 c7             	mov    %rax,%rdi
  802559:	41 ff d0             	callq  *%r8
}
  80255c:	c9                   	leaveq 
  80255d:	c3                   	retq   

000000000080255e <seek>:

int
seek(int fdnum, off_t offset)
{
  80255e:	55                   	push   %rbp
  80255f:	48 89 e5             	mov    %rsp,%rbp
  802562:	48 83 ec 18          	sub    $0x18,%rsp
  802566:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802569:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802570:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802573:	48 89 d6             	mov    %rdx,%rsi
  802576:	89 c7                	mov    %eax,%edi
  802578:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	79 05                	jns    802592 <seek+0x34>
		return r;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	eb 0f                	jmp    8025a1 <seek+0x43>
	fd->fd_offset = offset;
  802592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802596:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802599:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a1:	c9                   	leaveq 
  8025a2:	c3                   	retq   

00000000008025a3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025a3:	55                   	push   %rbp
  8025a4:	48 89 e5             	mov    %rsp,%rbp
  8025a7:	48 83 ec 30          	sub    $0x30,%rsp
  8025ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025b8:	48 89 d6             	mov    %rdx,%rsi
  8025bb:	89 c7                	mov    %eax,%edi
  8025bd:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8025c4:	00 00 00 
  8025c7:	ff d0                	callq  *%rax
  8025c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d0:	78 24                	js     8025f6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d6:	8b 00                	mov    (%rax),%eax
  8025d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025dc:	48 89 d6             	mov    %rdx,%rsi
  8025df:	89 c7                	mov    %eax,%edi
  8025e1:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  8025e8:	00 00 00 
  8025eb:	ff d0                	callq  *%rax
  8025ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f4:	79 05                	jns    8025fb <ftruncate+0x58>
		return r;
  8025f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f9:	eb 72                	jmp    80266d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ff:	8b 40 08             	mov    0x8(%rax),%eax
  802602:	83 e0 03             	and    $0x3,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	75 3a                	jne    802643 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802609:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802610:	00 00 00 
  802613:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802616:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80261c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80261f:	89 c6                	mov    %eax,%esi
  802621:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  802628:	00 00 00 
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
  802630:	48 b9 c7 05 80 00 00 	movabs $0x8005c7,%rcx
  802637:	00 00 00 
  80263a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80263c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802641:	eb 2a                	jmp    80266d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802647:	48 8b 40 30          	mov    0x30(%rax),%rax
  80264b:	48 85 c0             	test   %rax,%rax
  80264e:	75 07                	jne    802657 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802650:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802655:	eb 16                	jmp    80266d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80265f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802663:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802666:	89 d6                	mov    %edx,%esi
  802668:	48 89 c7             	mov    %rax,%rdi
  80266b:	ff d1                	callq  *%rcx
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 30          	sub    $0x30,%rsp
  802677:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80267a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80267e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802682:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802685:	48 89 d6             	mov    %rdx,%rsi
  802688:	89 c7                	mov    %eax,%edi
  80268a:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802691:	00 00 00 
  802694:	ff d0                	callq  *%rax
  802696:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802699:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269d:	78 24                	js     8026c3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80269f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a3:	8b 00                	mov    (%rax),%eax
  8026a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a9:	48 89 d6             	mov    %rdx,%rsi
  8026ac:	89 c7                	mov    %eax,%edi
  8026ae:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c1:	79 05                	jns    8026c8 <fstat+0x59>
		return r;
  8026c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c6:	eb 5e                	jmp    802726 <fstat+0xb7>
	if (!dev->dev_stat)
  8026c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026d0:	48 85 c0             	test   %rax,%rax
  8026d3:	75 07                	jne    8026dc <fstat+0x6d>
		return -E_NOT_SUPP;
  8026d5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026da:	eb 4a                	jmp    802726 <fstat+0xb7>
	stat->st_name[0] = 0;
  8026dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026ee:	00 00 00 
	stat->st_isdir = 0;
  8026f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026fc:	00 00 00 
	stat->st_dev = dev;
  8026ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802703:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802707:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80270e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802712:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80271e:	48 89 d6             	mov    %rdx,%rsi
  802721:	48 89 c7             	mov    %rax,%rdi
  802724:	ff d1                	callq  *%rcx
}
  802726:	c9                   	leaveq 
  802727:	c3                   	retq   

0000000000802728 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802728:	55                   	push   %rbp
  802729:	48 89 e5             	mov    %rsp,%rbp
  80272c:	48 83 ec 20          	sub    $0x20,%rsp
  802730:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802734:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273c:	be 00 00 00 00       	mov    $0x0,%esi
  802741:	48 89 c7             	mov    %rax,%rdi
  802744:	48 b8 17 28 80 00 00 	movabs $0x802817,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
  802750:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802757:	79 05                	jns    80275e <stat+0x36>
		return fd;
  802759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275c:	eb 2f                	jmp    80278d <stat+0x65>
	r = fstat(fd, stat);
  80275e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802765:	48 89 d6             	mov    %rdx,%rsi
  802768:	89 c7                	mov    %eax,%edi
  80276a:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277c:	89 c7                	mov    %eax,%edi
  80277e:	48 b8 16 21 80 00 00 	movabs $0x802116,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
	return r;
  80278a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80278d:	c9                   	leaveq 
  80278e:	c3                   	retq   
	...

0000000000802790 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802790:	55                   	push   %rbp
  802791:	48 89 e5             	mov    %rsp,%rbp
  802794:	48 83 ec 10          	sub    $0x10,%rsp
  802798:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80279b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80279f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8027a6:	00 00 00 
  8027a9:	8b 00                	mov    (%rax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	75 1d                	jne    8027cc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027af:	bf 01 00 00 00       	mov    $0x1,%edi
  8027b4:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	callq  *%rax
  8027c0:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8027c7:	00 00 00 
  8027ca:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027cc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8027d3:	00 00 00 
  8027d6:	8b 00                	mov    (%rax),%eax
  8027d8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027e0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027e7:	00 00 00 
  8027ea:	89 c7                	mov    %eax,%edi
  8027ec:	48 b8 bf 3e 80 00 00 	movabs $0x803ebf,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802801:	48 89 c6             	mov    %rax,%rsi
  802804:	bf 00 00 00 00       	mov    $0x0,%edi
  802809:	48 b8 d8 3d 80 00 00 	movabs $0x803dd8,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
}
  802815:	c9                   	leaveq 
  802816:	c3                   	retq   

0000000000802817 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802817:	55                   	push   %rbp
  802818:	48 89 e5             	mov    %rsp,%rbp
  80281b:	48 83 ec 20          	sub    $0x20,%rsp
  80281f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802823:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282a:	48 89 c7             	mov    %rax,%rdi
  80282d:	48 b8 2c 11 80 00 00 	movabs $0x80112c,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
  802839:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80283e:	7e 0a                	jle    80284a <open+0x33>
		return -E_BAD_PATH;
  802840:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802845:	e9 a5 00 00 00       	jmpq   8028ef <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80284a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80284e:	48 89 c7             	mov    %rax,%rdi
  802851:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
  80285d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802864:	79 08                	jns    80286e <open+0x57>
		return r;
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	e9 81 00 00 00       	jmpq   8028ef <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80286e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802875:	00 00 00 
  802878:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80287b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802885:	48 89 c6             	mov    %rax,%rsi
  802888:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80288f:	00 00 00 
  802892:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80289e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a2:	48 89 c6             	mov    %rax,%rsi
  8028a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8028aa:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
  8028b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8028b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bd:	79 1d                	jns    8028dc <open+0xc5>
		fd_close(new_fd, 0);
  8028bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c3:	be 00 00 00 00       	mov    $0x0,%esi
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 96 1f 80 00 00 	movabs $0x801f96,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
		return r;	
  8028d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028da:	eb 13                	jmp    8028ef <open+0xd8>
	}
	return fd2num(new_fd);
  8028dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e0:	48 89 c7             	mov    %rax,%rdi
  8028e3:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 10          	sub    $0x10,%rsp
  8028f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802901:	8b 50 0c             	mov    0xc(%rax),%edx
  802904:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290b:	00 00 00 
  80290e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802910:	be 00 00 00 00       	mov    $0x0,%esi
  802915:	bf 06 00 00 00       	mov    $0x6,%edi
  80291a:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
  802921:	00 00 00 
  802924:	ff d0                	callq  *%rax
}
  802926:	c9                   	leaveq 
  802927:	c3                   	retq   

0000000000802928 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 83 ec 30          	sub    $0x30,%rsp
  802930:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802934:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802938:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  80293c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802940:	8b 50 0c             	mov    0xc(%rax),%edx
  802943:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80294a:	00 00 00 
  80294d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80294f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802956:	00 00 00 
  802959:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80295d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802961:	be 00 00 00 00       	mov    $0x0,%esi
  802966:	bf 03 00 00 00       	mov    $0x3,%edi
  80296b:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
  802972:	00 00 00 
  802975:	ff d0                	callq  *%rax
  802977:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  80297a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297e:	7e 23                	jle    8029a3 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802983:	48 63 d0             	movslq %eax,%rdx
  802986:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802991:	00 00 00 
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
	}
	return nbytes;
  8029a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029a6:	c9                   	leaveq 
  8029a7:	c3                   	retq   

00000000008029a8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029a8:	55                   	push   %rbp
  8029a9:	48 89 e5             	mov    %rsp,%rbp
  8029ac:	48 83 ec 20          	sub    $0x20,%rsp
  8029b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c6:	00 00 00 
  8029c9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029cb:	be 00 00 00 00       	mov    $0x0,%esi
  8029d0:	bf 05 00 00 00       	mov    $0x5,%edi
  8029d5:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
  8029e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e8:	79 05                	jns    8029ef <devfile_stat+0x47>
		return r;
  8029ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ed:	eb 56                	jmp    802a45 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029fa:	00 00 00 
  8029fd:	48 89 c7             	mov    %rax,%rdi
  802a00:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a13:	00 00 00 
  802a16:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a20:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2d:	00 00 00 
  802a30:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a45:	c9                   	leaveq 
  802a46:	c3                   	retq   
	...

0000000000802a48 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	48 83 ec 20          	sub    $0x20,%rsp
  802a50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a58:	8b 40 0c             	mov    0xc(%rax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	7e 67                	jle    802ac6 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a63:	8b 40 04             	mov    0x4(%rax),%eax
  802a66:	48 63 d0             	movslq %eax,%rdx
  802a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802a71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a75:	8b 00                	mov    (%rax),%eax
  802a77:	48 89 ce             	mov    %rcx,%rsi
  802a7a:	89 c7                	mov    %eax,%edi
  802a7c:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802a83:	00 00 00 
  802a86:	ff d0                	callq  *%rax
  802a88:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8f:	7e 13                	jle    802aa4 <writebuf+0x5c>
			b->result += result;
  802a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a95:	8b 40 08             	mov    0x8(%rax),%eax
  802a98:	89 c2                	mov    %eax,%edx
  802a9a:	03 55 fc             	add    -0x4(%rbp),%edx
  802a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa1:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa8:	8b 40 04             	mov    0x4(%rax),%eax
  802aab:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802aae:	74 16                	je     802ac6 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab9:	89 c2                	mov    %eax,%edx
  802abb:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac3:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ac6:	c9                   	leaveq 
  802ac7:	c3                   	retq   

0000000000802ac8 <putch>:

static void
putch(int ch, void *thunk)
{
  802ac8:	55                   	push   %rbp
  802ac9:	48 89 e5             	mov    %rsp,%rbp
  802acc:	48 83 ec 20          	sub    $0x20,%rsp
  802ad0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ad3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ad7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802adb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae3:	8b 40 04             	mov    0x4(%rax),%eax
  802ae6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ae9:	89 d6                	mov    %edx,%esi
  802aeb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802aef:	48 63 d0             	movslq %eax,%rdx
  802af2:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802af7:	8d 50 01             	lea    0x1(%rax),%edx
  802afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afe:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802b01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b05:	8b 40 04             	mov    0x4(%rax),%eax
  802b08:	3d 00 01 00 00       	cmp    $0x100,%eax
  802b0d:	75 1e                	jne    802b2d <putch+0x65>
		writebuf(b);
  802b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
		b->idx = 0;
  802b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802b3a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802b40:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802b47:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802b4e:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802b54:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802b5a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802b61:	00 00 00 
	b.result = 0;
  802b64:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802b6b:	00 00 00 
	b.error = 1;
  802b6e:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802b75:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802b78:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802b7f:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802b86:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802b8d:	48 89 c6             	mov    %rax,%rsi
  802b90:	48 bf c8 2a 80 00 00 	movabs $0x802ac8,%rdi
  802b97:	00 00 00 
  802b9a:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ba6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	7e 16                	jle    802bc6 <vfprintf+0x97>
		writebuf(&b);
  802bb0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802bb7:	48 89 c7             	mov    %rax,%rdi
  802bba:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802bc6:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 08                	je     802bd8 <vfprintf+0xa9>
  802bd0:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802bd6:	eb 06                	jmp    802bde <vfprintf+0xaf>
  802bd8:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802bde:	c9                   	leaveq 
  802bdf:	c3                   	retq   

0000000000802be0 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802be0:	55                   	push   %rbp
  802be1:	48 89 e5             	mov    %rsp,%rbp
  802be4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802beb:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802bf1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802bf8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802bff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802c06:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802c0d:	84 c0                	test   %al,%al
  802c0f:	74 20                	je     802c31 <fprintf+0x51>
  802c11:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802c15:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802c19:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802c1d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802c21:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802c25:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802c29:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802c2d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802c31:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802c38:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802c3f:	00 00 00 
  802c42:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802c49:	00 00 00 
  802c4c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c50:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802c57:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802c5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802c65:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802c6c:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802c73:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802c79:	48 89 ce             	mov    %rcx,%rsi
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
  802c8a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802c90:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802c96:	c9                   	leaveq 
  802c97:	c3                   	retq   

0000000000802c98 <printf>:

int
printf(const char *fmt, ...)
{
  802c98:	55                   	push   %rbp
  802c99:	48 89 e5             	mov    %rsp,%rbp
  802c9c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ca3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802caa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802cb1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802cb8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802cbf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802cc6:	84 c0                	test   %al,%al
  802cc8:	74 20                	je     802cea <printf+0x52>
  802cca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802cce:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802cd2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802cd6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802cda:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802cde:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ce2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ce6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802cea:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802cf1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802cf8:	00 00 00 
  802cfb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d02:	00 00 00 
  802d05:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d09:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d10:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d17:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802d1e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d25:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802d2c:	48 89 c6             	mov    %rax,%rsi
  802d2f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d34:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  802d3b:	00 00 00 
  802d3e:	ff d0                	callq  *%rax
  802d40:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d46:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d4c:	c9                   	leaveq 
  802d4d:	c3                   	retq   
	...

0000000000802d50 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 83 ec 20          	sub    $0x20,%rsp
  802d58:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d5b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d62:	48 89 d6             	mov    %rdx,%rsi
  802d65:	89 c7                	mov    %eax,%edi
  802d67:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
  802d73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7a:	79 05                	jns    802d81 <fd2sockid+0x31>
		return r;
  802d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7f:	eb 24                	jmp    802da5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d85:	8b 10                	mov    (%rax),%edx
  802d87:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d8e:	00 00 00 
  802d91:	8b 00                	mov    (%rax),%eax
  802d93:	39 c2                	cmp    %eax,%edx
  802d95:	74 07                	je     802d9e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d97:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d9c:	eb 07                	jmp    802da5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802da5:	c9                   	leaveq 
  802da6:	c3                   	retq   

0000000000802da7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802da7:	55                   	push   %rbp
  802da8:	48 89 e5             	mov    %rsp,%rbp
  802dab:	48 83 ec 20          	sub    $0x20,%rsp
  802daf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802db2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802db6:	48 89 c7             	mov    %rax,%rdi
  802db9:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
  802dc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcc:	78 26                	js     802df4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd2:	ba 07 04 00 00       	mov    $0x407,%edx
  802dd7:	48 89 c6             	mov    %rax,%rsi
  802dda:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddf:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax
  802deb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df2:	79 16                	jns    802e0a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802df4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df7:	89 c7                	mov    %eax,%edi
  802df9:	48 b8 b4 32 80 00 00 	movabs $0x8032b4,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
		return r;
  802e05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e08:	eb 3a                	jmp    802e44 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e15:	00 00 00 
  802e18:	8b 12                	mov    (%rdx),%edx
  802e1a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e20:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e2e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e35:	48 89 c7             	mov    %rax,%rdi
  802e38:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
}
  802e44:	c9                   	leaveq 
  802e45:	c3                   	retq   

0000000000802e46 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e46:	55                   	push   %rbp
  802e47:	48 89 e5             	mov    %rsp,%rbp
  802e4a:	48 83 ec 30          	sub    $0x30,%rsp
  802e4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e55:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e5c:	89 c7                	mov    %eax,%edi
  802e5e:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e71:	79 05                	jns    802e78 <accept+0x32>
		return r;
  802e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e76:	eb 3b                	jmp    802eb3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e78:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e7c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e83:	48 89 ce             	mov    %rcx,%rsi
  802e86:	89 c7                	mov    %eax,%edi
  802e88:	48 b8 91 31 80 00 00 	movabs $0x803191,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9b:	79 05                	jns    802ea2 <accept+0x5c>
		return r;
  802e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea0:	eb 11                	jmp    802eb3 <accept+0x6d>
	return alloc_sockfd(r);
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 a7 2d 80 00 00 	movabs $0x802da7,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
}
  802eb3:	c9                   	leaveq 
  802eb4:	c3                   	retq   

0000000000802eb5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802eb5:	55                   	push   %rbp
  802eb6:	48 89 e5             	mov    %rsp,%rbp
  802eb9:	48 83 ec 20          	sub    $0x20,%rsp
  802ebd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ec0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ec4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ec7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eca:	89 c7                	mov    %eax,%edi
  802ecc:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edf:	79 05                	jns    802ee6 <bind+0x31>
		return r;
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee4:	eb 1b                	jmp    802f01 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ee6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ee9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef0:	48 89 ce             	mov    %rcx,%rsi
  802ef3:	89 c7                	mov    %eax,%edi
  802ef5:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  802efc:	00 00 00 
  802eff:	ff d0                	callq  *%rax
}
  802f01:	c9                   	leaveq 
  802f02:	c3                   	retq   

0000000000802f03 <shutdown>:

int
shutdown(int s, int how)
{
  802f03:	55                   	push   %rbp
  802f04:	48 89 e5             	mov    %rsp,%rbp
  802f07:	48 83 ec 20          	sub    $0x20,%rsp
  802f0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f0e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f14:	89 c7                	mov    %eax,%edi
  802f16:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802f1d:	00 00 00 
  802f20:	ff d0                	callq  *%rax
  802f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f29:	79 05                	jns    802f30 <shutdown+0x2d>
		return r;
  802f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2e:	eb 16                	jmp    802f46 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f30:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f36:	89 d6                	mov    %edx,%esi
  802f38:	89 c7                	mov    %eax,%edi
  802f3a:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 10          	sub    $0x10,%rsp
  802f50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f58:	48 89 c7             	mov    %rax,%rdi
  802f5b:	48 b8 fc 3f 80 00 00 	movabs $0x803ffc,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	83 f8 01             	cmp    $0x1,%eax
  802f6a:	75 17                	jne    802f83 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f70:	8b 40 0c             	mov    0xc(%rax),%eax
  802f73:	89 c7                	mov    %eax,%edi
  802f75:	48 b8 b4 32 80 00 00 	movabs $0x8032b4,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
  802f81:	eb 05                	jmp    802f88 <devsock_close+0x40>
	else
		return 0;
  802f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f88:	c9                   	leaveq 
  802f89:	c3                   	retq   

0000000000802f8a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f8a:	55                   	push   %rbp
  802f8b:	48 89 e5             	mov    %rsp,%rbp
  802f8e:	48 83 ec 20          	sub    $0x20,%rsp
  802f92:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f99:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f9f:	89 c7                	mov    %eax,%edi
  802fa1:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802fa8:	00 00 00 
  802fab:	ff d0                	callq  *%rax
  802fad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb4:	79 05                	jns    802fbb <connect+0x31>
		return r;
  802fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb9:	eb 1b                	jmp    802fd6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fbb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fbe:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	48 89 ce             	mov    %rcx,%rsi
  802fc8:	89 c7                	mov    %eax,%edi
  802fca:	48 b8 e1 32 80 00 00 	movabs $0x8032e1,%rax
  802fd1:	00 00 00 
  802fd4:	ff d0                	callq  *%rax
}
  802fd6:	c9                   	leaveq 
  802fd7:	c3                   	retq   

0000000000802fd8 <listen>:

int
listen(int s, int backlog)
{
  802fd8:	55                   	push   %rbp
  802fd9:	48 89 e5             	mov    %rsp,%rbp
  802fdc:	48 83 ec 20          	sub    $0x20,%rsp
  802fe0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fe6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe9:	89 c7                	mov    %eax,%edi
  802feb:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffe:	79 05                	jns    803005 <listen+0x2d>
		return r;
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	eb 16                	jmp    80301b <listen+0x43>
	return nsipc_listen(r, backlog);
  803005:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300b:	89 d6                	mov    %edx,%esi
  80300d:	89 c7                	mov    %eax,%edi
  80300f:	48 b8 45 33 80 00 00 	movabs $0x803345,%rax
  803016:	00 00 00 
  803019:	ff d0                	callq  *%rax
}
  80301b:	c9                   	leaveq 
  80301c:	c3                   	retq   

000000000080301d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80301d:	55                   	push   %rbp
  80301e:	48 89 e5             	mov    %rsp,%rbp
  803021:	48 83 ec 20          	sub    $0x20,%rsp
  803025:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803029:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80302d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803035:	89 c2                	mov    %eax,%edx
  803037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80303b:	8b 40 0c             	mov    0xc(%rax),%eax
  80303e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803042:	b9 00 00 00 00       	mov    $0x0,%ecx
  803047:	89 c7                	mov    %eax,%edi
  803049:	48 b8 85 33 80 00 00 	movabs $0x803385,%rax
  803050:	00 00 00 
  803053:	ff d0                	callq  *%rax
}
  803055:	c9                   	leaveq 
  803056:	c3                   	retq   

0000000000803057 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803057:	55                   	push   %rbp
  803058:	48 89 e5             	mov    %rsp,%rbp
  80305b:	48 83 ec 20          	sub    $0x20,%rsp
  80305f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803063:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803067:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80306b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306f:	89 c2                	mov    %eax,%edx
  803071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803075:	8b 40 0c             	mov    0xc(%rax),%eax
  803078:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80307c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803081:	89 c7                	mov    %eax,%edi
  803083:	48 b8 51 34 80 00 00 	movabs $0x803451,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 83 ec 10          	sub    $0x10,%rsp
  803099:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80309d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a5:	48 be bb 46 80 00 00 	movabs $0x8046bb,%rsi
  8030ac:	00 00 00 
  8030af:	48 89 c7             	mov    %rax,%rdi
  8030b2:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
	return 0;
  8030be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c3:	c9                   	leaveq 
  8030c4:	c3                   	retq   

00000000008030c5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8030c5:	55                   	push   %rbp
  8030c6:	48 89 e5             	mov    %rsp,%rbp
  8030c9:	48 83 ec 20          	sub    $0x20,%rsp
  8030cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030d0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030d3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030d6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030d9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030df:	89 ce                	mov    %ecx,%esi
  8030e1:	89 c7                	mov    %eax,%edi
  8030e3:	48 b8 09 35 80 00 00 	movabs $0x803509,%rax
  8030ea:	00 00 00 
  8030ed:	ff d0                	callq  *%rax
  8030ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f6:	79 05                	jns    8030fd <socket+0x38>
		return r;
  8030f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fb:	eb 11                	jmp    80310e <socket+0x49>
	return alloc_sockfd(r);
  8030fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 a7 2d 80 00 00 	movabs $0x802da7,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
}
  80310e:	c9                   	leaveq 
  80310f:	c3                   	retq   

0000000000803110 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803110:	55                   	push   %rbp
  803111:	48 89 e5             	mov    %rsp,%rbp
  803114:	48 83 ec 10          	sub    $0x10,%rsp
  803118:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80311b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803122:	00 00 00 
  803125:	8b 00                	mov    (%rax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	75 1d                	jne    803148 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80312b:	bf 02 00 00 00       	mov    $0x2,%edi
  803130:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  803137:	00 00 00 
  80313a:	ff d0                	callq  *%rax
  80313c:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  803143:	00 00 00 
  803146:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803148:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80314f:	00 00 00 
  803152:	8b 00                	mov    (%rax),%eax
  803154:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803157:	b9 07 00 00 00       	mov    $0x7,%ecx
  80315c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803163:	00 00 00 
  803166:	89 c7                	mov    %eax,%edi
  803168:	48 b8 bf 3e 80 00 00 	movabs $0x803ebf,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803174:	ba 00 00 00 00       	mov    $0x0,%edx
  803179:	be 00 00 00 00       	mov    $0x0,%esi
  80317e:	bf 00 00 00 00       	mov    $0x0,%edi
  803183:	48 b8 d8 3d 80 00 00 	movabs $0x803dd8,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 30          	sub    $0x30,%rsp
  803199:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80319c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031a4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ab:	00 00 00 
  8031ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031b1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8031b8:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
  8031c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cb:	78 3e                	js     80320b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d4:	00 00 00 
  8031d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8031db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031df:	8b 40 10             	mov    0x10(%rax),%eax
  8031e2:	89 c2                	mov    %eax,%edx
  8031e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ec:	48 89 ce             	mov    %rcx,%rsi
  8031ef:	48 89 c7             	mov    %rax,%rdi
  8031f2:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803202:	8b 50 10             	mov    0x10(%rax),%edx
  803205:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803209:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80320b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80320e:	c9                   	leaveq 
  80320f:	c3                   	retq   

0000000000803210 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803210:	55                   	push   %rbp
  803211:	48 89 e5             	mov    %rsp,%rbp
  803214:	48 83 ec 10          	sub    $0x10,%rsp
  803218:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80321b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80321f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803222:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803229:	00 00 00 
  80322c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80322f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803231:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803238:	48 89 c6             	mov    %rax,%rsi
  80323b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803242:	00 00 00 
  803245:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803251:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803258:	00 00 00 
  80325b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803261:	bf 02 00 00 00       	mov    $0x2,%edi
  803266:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	48 83 ec 10          	sub    $0x10,%rsp
  80327c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80327f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803282:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803289:	00 00 00 
  80328c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80328f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803291:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803298:	00 00 00 
  80329b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8032a6:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
}
  8032b2:	c9                   	leaveq 
  8032b3:	c3                   	retq   

00000000008032b4 <nsipc_close>:

int
nsipc_close(int s)
{
  8032b4:	55                   	push   %rbp
  8032b5:	48 89 e5             	mov    %rsp,%rbp
  8032b8:	48 83 ec 10          	sub    $0x10,%rsp
  8032bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032c6:	00 00 00 
  8032c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032cc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032ce:	bf 04 00 00 00       	mov    $0x4,%edi
  8032d3:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
}
  8032df:	c9                   	leaveq 
  8032e0:	c3                   	retq   

00000000008032e1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032e1:	55                   	push   %rbp
  8032e2:	48 89 e5             	mov    %rsp,%rbp
  8032e5:	48 83 ec 10          	sub    $0x10,%rsp
  8032e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032f0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032f3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032fa:	00 00 00 
  8032fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803300:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803302:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803309:	48 89 c6             	mov    %rax,%rsi
  80330c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803313:	00 00 00 
  803316:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803322:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803329:	00 00 00 
  80332c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803332:	bf 05 00 00 00       	mov    $0x5,%edi
  803337:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
}
  803343:	c9                   	leaveq 
  803344:	c3                   	retq   

0000000000803345 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803345:	55                   	push   %rbp
  803346:	48 89 e5             	mov    %rsp,%rbp
  803349:	48 83 ec 10          	sub    $0x10,%rsp
  80334d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803350:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803353:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335a:	00 00 00 
  80335d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803360:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803362:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803369:	00 00 00 
  80336c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803372:	bf 06 00 00 00       	mov    $0x6,%edi
  803377:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 30          	sub    $0x30,%rsp
  80338d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803390:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803394:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803397:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80339a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a1:	00 00 00 
  8033a4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033a7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b0:	00 00 00 
  8033b3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c0:	00 00 00 
  8033c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033c6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033c9:	bf 07 00 00 00       	mov    $0x7,%edi
  8033ce:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  8033d5:	00 00 00 
  8033d8:	ff d0                	callq  *%rax
  8033da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e1:	78 69                	js     80344c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033e3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033ea:	7f 08                	jg     8033f4 <nsipc_recv+0x6f>
  8033ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ef:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033f2:	7e 35                	jle    803429 <nsipc_recv+0xa4>
  8033f4:	48 b9 c2 46 80 00 00 	movabs $0x8046c2,%rcx
  8033fb:	00 00 00 
  8033fe:	48 ba d7 46 80 00 00 	movabs $0x8046d7,%rdx
  803405:	00 00 00 
  803408:	be 61 00 00 00       	mov    $0x61,%esi
  80340d:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  803414:	00 00 00 
  803417:	b8 00 00 00 00       	mov    $0x0,%eax
  80341c:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  803423:	00 00 00 
  803426:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803429:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342c:	48 63 d0             	movslq %eax,%rdx
  80342f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803433:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80343a:	00 00 00 
  80343d:	48 89 c7             	mov    %rax,%rdi
  803440:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
	}

	return r;
  80344c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80344f:	c9                   	leaveq 
  803450:	c3                   	retq   

0000000000803451 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803451:	55                   	push   %rbp
  803452:	48 89 e5             	mov    %rsp,%rbp
  803455:	48 83 ec 20          	sub    $0x20,%rsp
  803459:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80345c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803460:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803463:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803466:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80346d:	00 00 00 
  803470:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803473:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803475:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80347c:	7e 35                	jle    8034b3 <nsipc_send+0x62>
  80347e:	48 b9 f8 46 80 00 00 	movabs $0x8046f8,%rcx
  803485:	00 00 00 
  803488:	48 ba d7 46 80 00 00 	movabs $0x8046d7,%rdx
  80348f:	00 00 00 
  803492:	be 6c 00 00 00       	mov    $0x6c,%esi
  803497:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  80349e:	00 00 00 
  8034a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a6:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  8034ad:	00 00 00 
  8034b0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b6:	48 63 d0             	movslq %eax,%rdx
  8034b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034bd:	48 89 c6             	mov    %rax,%rsi
  8034c0:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034c7:	00 00 00 
  8034ca:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034d6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034dd:	00 00 00 
  8034e0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034f3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034f6:	bf 08 00 00 00       	mov    $0x8,%edi
  8034fb:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
}
  803507:	c9                   	leaveq 
  803508:	c3                   	retq   

0000000000803509 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803509:	55                   	push   %rbp
  80350a:	48 89 e5             	mov    %rsp,%rbp
  80350d:	48 83 ec 10          	sub    $0x10,%rsp
  803511:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803514:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803517:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80351a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803521:	00 00 00 
  803524:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803527:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803529:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803530:	00 00 00 
  803533:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803536:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803539:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803540:	00 00 00 
  803543:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803546:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803549:	bf 09 00 00 00       	mov    $0x9,%edi
  80354e:	48 b8 10 31 80 00 00 	movabs $0x803110,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
}
  80355a:	c9                   	leaveq 
  80355b:	c3                   	retq   

000000000080355c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80355c:	55                   	push   %rbp
  80355d:	48 89 e5             	mov    %rsp,%rbp
  803560:	53                   	push   %rbx
  803561:	48 83 ec 38          	sub    $0x38,%rsp
  803565:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803569:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80356d:	48 89 c7             	mov    %rax,%rdi
  803570:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
  80357c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80357f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803583:	0f 88 bf 01 00 00    	js     803748 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80358d:	ba 07 04 00 00       	mov    $0x407,%edx
  803592:	48 89 c6             	mov    %rax,%rsi
  803595:	bf 00 00 00 00       	mov    $0x0,%edi
  80359a:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
  8035a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ad:	0f 88 95 01 00 00    	js     803748 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035b3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035b7:	48 89 c7             	mov    %rax,%rdi
  8035ba:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035cd:	0f 88 5d 01 00 00    	js     803730 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8035dc:	48 89 c6             	mov    %rax,%rsi
  8035df:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e4:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f7:	0f 88 33 01 00 00    	js     803730 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803601:	48 89 c7             	mov    %rax,%rdi
  803604:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803614:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803618:	ba 07 04 00 00       	mov    $0x407,%edx
  80361d:	48 89 c6             	mov    %rax,%rsi
  803620:	bf 00 00 00 00       	mov    $0x0,%edi
  803625:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  80362c:	00 00 00 
  80362f:	ff d0                	callq  *%rax
  803631:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803634:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803638:	0f 88 d9 00 00 00    	js     803717 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803642:	48 89 c7             	mov    %rax,%rdi
  803645:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	48 89 c2             	mov    %rax,%rdx
  803654:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803658:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80365e:	48 89 d1             	mov    %rdx,%rcx
  803661:	ba 00 00 00 00       	mov    $0x0,%edx
  803666:	48 89 c6             	mov    %rax,%rsi
  803669:	bf 00 00 00 00       	mov    $0x0,%edi
  80366e:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
  80367a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803681:	78 79                	js     8036fc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803687:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80368e:	00 00 00 
  803691:	8b 12                	mov    (%rdx),%edx
  803693:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803699:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036ab:	00 00 00 
  8036ae:	8b 12                	mov    (%rdx),%edx
  8036b0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c1:	48 89 c7             	mov    %rax,%rdi
  8036c4:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
  8036d0:	89 c2                	mov    %eax,%edx
  8036d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036d6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036dc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
  8036f3:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fa:	eb 4f                	jmp    80374b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8036fc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803701:	48 89 c6             	mov    %rax,%rsi
  803704:	bf 00 00 00 00       	mov    $0x0,%edi
  803709:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
  803715:	eb 01                	jmp    803718 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803717:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803718:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80371c:	48 89 c6             	mov    %rax,%rsi
  80371f:	bf 00 00 00 00       	mov    $0x0,%edi
  803724:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803734:	48 89 c6             	mov    %rax,%rsi
  803737:	bf 00 00 00 00       	mov    $0x0,%edi
  80373c:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
err:
	return r;
  803748:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80374b:	48 83 c4 38          	add    $0x38,%rsp
  80374f:	5b                   	pop    %rbx
  803750:	5d                   	pop    %rbp
  803751:	c3                   	retq   

0000000000803752 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803752:	55                   	push   %rbp
  803753:	48 89 e5             	mov    %rsp,%rbp
  803756:	53                   	push   %rbx
  803757:	48 83 ec 28          	sub    $0x28,%rsp
  80375b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80375f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803763:	eb 01                	jmp    803766 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803765:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803766:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80376d:	00 00 00 
  803770:	48 8b 00             	mov    (%rax),%rax
  803773:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803779:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80377c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803780:	48 89 c7             	mov    %rax,%rdi
  803783:	48 b8 fc 3f 80 00 00 	movabs $0x803ffc,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
  80378f:	89 c3                	mov    %eax,%ebx
  803791:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803795:	48 89 c7             	mov    %rax,%rdi
  803798:	48 b8 fc 3f 80 00 00 	movabs $0x803ffc,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
  8037a4:	39 c3                	cmp    %eax,%ebx
  8037a6:	0f 94 c0             	sete   %al
  8037a9:	0f b6 c0             	movzbl %al,%eax
  8037ac:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037af:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8037b6:	00 00 00 
  8037b9:	48 8b 00             	mov    (%rax),%rax
  8037bc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037c2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037cb:	75 0a                	jne    8037d7 <_pipeisclosed+0x85>
			return ret;
  8037cd:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8037d0:	48 83 c4 28          	add    $0x28,%rsp
  8037d4:	5b                   	pop    %rbx
  8037d5:	5d                   	pop    %rbp
  8037d6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8037d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037dd:	74 86                	je     803765 <_pipeisclosed+0x13>
  8037df:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8037e3:	75 80                	jne    803765 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8037e5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8037ec:	00 00 00 
  8037ef:	48 8b 00             	mov    (%rax),%rax
  8037f2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037f8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fe:	89 c6                	mov    %eax,%esi
  803800:	48 bf 09 47 80 00 00 	movabs $0x804709,%rdi
  803807:	00 00 00 
  80380a:	b8 00 00 00 00       	mov    $0x0,%eax
  80380f:	49 b8 c7 05 80 00 00 	movabs $0x8005c7,%r8
  803816:	00 00 00 
  803819:	41 ff d0             	callq  *%r8
	}
  80381c:	e9 44 ff ff ff       	jmpq   803765 <_pipeisclosed+0x13>

0000000000803821 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803821:	55                   	push   %rbp
  803822:	48 89 e5             	mov    %rsp,%rbp
  803825:	48 83 ec 30          	sub    $0x30,%rsp
  803829:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80382c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803830:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803833:	48 89 d6             	mov    %rdx,%rsi
  803836:	89 c7                	mov    %eax,%edi
  803838:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  80383f:	00 00 00 
  803842:	ff d0                	callq  *%rax
  803844:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803847:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384b:	79 05                	jns    803852 <pipeisclosed+0x31>
		return r;
  80384d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803850:	eb 31                	jmp    803883 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803856:	48 89 c7             	mov    %rax,%rdi
  803859:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
  803865:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803871:	48 89 d6             	mov    %rdx,%rsi
  803874:	48 89 c7             	mov    %rax,%rdi
  803877:	48 b8 52 37 80 00 00 	movabs $0x803752,%rax
  80387e:	00 00 00 
  803881:	ff d0                	callq  *%rax
}
  803883:	c9                   	leaveq 
  803884:	c3                   	retq   

0000000000803885 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803885:	55                   	push   %rbp
  803886:	48 89 e5             	mov    %rsp,%rbp
  803889:	48 83 ec 40          	sub    $0x40,%rsp
  80388d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803891:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803895:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389d:	48 89 c7             	mov    %rax,%rdi
  8038a0:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  8038a7:	00 00 00 
  8038aa:	ff d0                	callq  *%rax
  8038ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038b8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038bf:	00 
  8038c0:	e9 97 00 00 00       	jmpq   80395c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038c5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038ca:	74 09                	je     8038d5 <devpipe_read+0x50>
				return i;
  8038cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d0:	e9 95 00 00 00       	jmpq   80396a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038dd:	48 89 d6             	mov    %rdx,%rsi
  8038e0:	48 89 c7             	mov    %rax,%rdi
  8038e3:	48 b8 52 37 80 00 00 	movabs $0x803752,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
  8038ef:	85 c0                	test   %eax,%eax
  8038f1:	74 07                	je     8038fa <devpipe_read+0x75>
				return 0;
  8038f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f8:	eb 70                	jmp    80396a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038fa:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  803901:	00 00 00 
  803904:	ff d0                	callq  *%rax
  803906:	eb 01                	jmp    803909 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803908:	90                   	nop
  803909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390d:	8b 10                	mov    (%rax),%edx
  80390f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803913:	8b 40 04             	mov    0x4(%rax),%eax
  803916:	39 c2                	cmp    %eax,%edx
  803918:	74 ab                	je     8038c5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80391a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803922:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392a:	8b 00                	mov    (%rax),%eax
  80392c:	89 c2                	mov    %eax,%edx
  80392e:	c1 fa 1f             	sar    $0x1f,%edx
  803931:	c1 ea 1b             	shr    $0x1b,%edx
  803934:	01 d0                	add    %edx,%eax
  803936:	83 e0 1f             	and    $0x1f,%eax
  803939:	29 d0                	sub    %edx,%eax
  80393b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80393f:	48 98                	cltq   
  803941:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803946:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394c:	8b 00                	mov    (%rax),%eax
  80394e:	8d 50 01             	lea    0x1(%rax),%edx
  803951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803955:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803957:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80395c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803960:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803964:	72 a2                	jb     803908 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803966:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80396a:	c9                   	leaveq 
  80396b:	c3                   	retq   

000000000080396c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80396c:	55                   	push   %rbp
  80396d:	48 89 e5             	mov    %rsp,%rbp
  803970:	48 83 ec 40          	sub    $0x40,%rsp
  803974:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803978:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80397c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803984:	48 89 c7             	mov    %rax,%rdi
  803987:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
  803993:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803997:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80399b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80399f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039a6:	00 
  8039a7:	e9 93 00 00 00       	jmpq   803a3f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b4:	48 89 d6             	mov    %rdx,%rsi
  8039b7:	48 89 c7             	mov    %rax,%rdi
  8039ba:	48 b8 52 37 80 00 00 	movabs $0x803752,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 07                	je     8039d1 <devpipe_write+0x65>
				return 0;
  8039ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cf:	eb 7c                	jmp    803a4d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039d1:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
  8039dd:	eb 01                	jmp    8039e0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039df:	90                   	nop
  8039e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e4:	8b 40 04             	mov    0x4(%rax),%eax
  8039e7:	48 63 d0             	movslq %eax,%rdx
  8039ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ee:	8b 00                	mov    (%rax),%eax
  8039f0:	48 98                	cltq   
  8039f2:	48 83 c0 20          	add    $0x20,%rax
  8039f6:	48 39 c2             	cmp    %rax,%rdx
  8039f9:	73 b1                	jae    8039ac <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ff:	8b 40 04             	mov    0x4(%rax),%eax
  803a02:	89 c2                	mov    %eax,%edx
  803a04:	c1 fa 1f             	sar    $0x1f,%edx
  803a07:	c1 ea 1b             	shr    $0x1b,%edx
  803a0a:	01 d0                	add    %edx,%eax
  803a0c:	83 e0 1f             	and    $0x1f,%eax
  803a0f:	29 d0                	sub    %edx,%eax
  803a11:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a15:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a19:	48 01 ca             	add    %rcx,%rdx
  803a1c:	0f b6 0a             	movzbl (%rdx),%ecx
  803a1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a23:	48 98                	cltq   
  803a25:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2d:	8b 40 04             	mov    0x4(%rax),%eax
  803a30:	8d 50 01             	lea    0x1(%rax),%edx
  803a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a37:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a3a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a43:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a47:	72 96                	jb     8039df <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a4d:	c9                   	leaveq 
  803a4e:	c3                   	retq   

0000000000803a4f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a4f:	55                   	push   %rbp
  803a50:	48 89 e5             	mov    %rsp,%rbp
  803a53:	48 83 ec 20          	sub    $0x20,%rsp
  803a57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a63:	48 89 c7             	mov    %rax,%rdi
  803a66:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7a:	48 be 1c 47 80 00 00 	movabs $0x80471c,%rsi
  803a81:	00 00 00 
  803a84:	48 89 c7             	mov    %rax,%rdi
  803a87:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a97:	8b 50 04             	mov    0x4(%rax),%edx
  803a9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a9e:	8b 00                	mov    (%rax),%eax
  803aa0:	29 c2                	sub    %eax,%edx
  803aa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803aac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ab7:	00 00 00 
	stat->st_dev = &devpipe;
  803aba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abe:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ac5:	00 00 00 
  803ac8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803acf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad4:	c9                   	leaveq 
  803ad5:	c3                   	retq   

0000000000803ad6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ad6:	55                   	push   %rbp
  803ad7:	48 89 e5             	mov    %rsp,%rbp
  803ada:	48 83 ec 10          	sub    $0x10,%rsp
  803ade:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803ae2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae6:	48 89 c6             	mov    %rax,%rsi
  803ae9:	bf 00 00 00 00       	mov    $0x0,%edi
  803aee:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803afe:	48 89 c7             	mov    %rax,%rdi
  803b01:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  803b08:	00 00 00 
  803b0b:	ff d0                	callq  *%rax
  803b0d:	48 89 c6             	mov    %rax,%rsi
  803b10:	bf 00 00 00 00       	mov    $0x0,%edi
  803b15:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
}
  803b21:	c9                   	leaveq 
  803b22:	c3                   	retq   
	...

0000000000803b24 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b24:	55                   	push   %rbp
  803b25:	48 89 e5             	mov    %rsp,%rbp
  803b28:	48 83 ec 20          	sub    $0x20,%rsp
  803b2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b32:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b35:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b39:	be 01 00 00 00       	mov    $0x1,%esi
  803b3e:	48 89 c7             	mov    %rax,%rdi
  803b41:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  803b48:	00 00 00 
  803b4b:	ff d0                	callq  *%rax
}
  803b4d:	c9                   	leaveq 
  803b4e:	c3                   	retq   

0000000000803b4f <getchar>:

int
getchar(void)
{
  803b4f:	55                   	push   %rbp
  803b50:	48 89 e5             	mov    %rsp,%rbp
  803b53:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b57:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b5b:	ba 01 00 00 00       	mov    $0x1,%edx
  803b60:	48 89 c6             	mov    %rax,%rsi
  803b63:	bf 00 00 00 00       	mov    $0x0,%edi
  803b68:	48 b8 38 23 80 00 00 	movabs $0x802338,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
  803b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7b:	79 05                	jns    803b82 <getchar+0x33>
		return r;
  803b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b80:	eb 14                	jmp    803b96 <getchar+0x47>
	if (r < 1)
  803b82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b86:	7f 07                	jg     803b8f <getchar+0x40>
		return -E_EOF;
  803b88:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b8d:	eb 07                	jmp    803b96 <getchar+0x47>
	return c;
  803b8f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b93:	0f b6 c0             	movzbl %al,%eax
}
  803b96:	c9                   	leaveq 
  803b97:	c3                   	retq   

0000000000803b98 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b98:	55                   	push   %rbp
  803b99:	48 89 e5             	mov    %rsp,%rbp
  803b9c:	48 83 ec 20          	sub    $0x20,%rsp
  803ba0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ba3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ba7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803baa:	48 89 d6             	mov    %rdx,%rsi
  803bad:	89 c7                	mov    %eax,%edi
  803baf:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  803bb6:	00 00 00 
  803bb9:	ff d0                	callq  *%rax
  803bbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc2:	79 05                	jns    803bc9 <iscons+0x31>
		return r;
  803bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc7:	eb 1a                	jmp    803be3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcd:	8b 10                	mov    (%rax),%edx
  803bcf:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803bd6:	00 00 00 
  803bd9:	8b 00                	mov    (%rax),%eax
  803bdb:	39 c2                	cmp    %eax,%edx
  803bdd:	0f 94 c0             	sete   %al
  803be0:	0f b6 c0             	movzbl %al,%eax
}
  803be3:	c9                   	leaveq 
  803be4:	c3                   	retq   

0000000000803be5 <opencons>:

int
opencons(void)
{
  803be5:	55                   	push   %rbp
  803be6:	48 89 e5             	mov    %rsp,%rbp
  803be9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803bed:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bf1:	48 89 c7             	mov    %rax,%rdi
  803bf4:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  803bfb:	00 00 00 
  803bfe:	ff d0                	callq  *%rax
  803c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c07:	79 05                	jns    803c0e <opencons+0x29>
		return r;
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0c:	eb 5b                	jmp    803c69 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c12:	ba 07 04 00 00       	mov    $0x407,%edx
  803c17:	48 89 c6             	mov    %rax,%rsi
  803c1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1f:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  803c26:	00 00 00 
  803c29:	ff d0                	callq  *%rax
  803c2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c32:	79 05                	jns    803c39 <opencons+0x54>
		return r;
  803c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c37:	eb 30                	jmp    803c69 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c44:	00 00 00 
  803c47:	8b 12                	mov    (%rdx),%edx
  803c49:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5a:	48 89 c7             	mov    %rax,%rdi
  803c5d:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  803c64:	00 00 00 
  803c67:	ff d0                	callq  *%rax
}
  803c69:	c9                   	leaveq 
  803c6a:	c3                   	retq   

0000000000803c6b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c6b:	55                   	push   %rbp
  803c6c:	48 89 e5             	mov    %rsp,%rbp
  803c6f:	48 83 ec 30          	sub    $0x30,%rsp
  803c73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c7b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c7f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c84:	75 13                	jne    803c99 <devcons_read+0x2e>
		return 0;
  803c86:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8b:	eb 49                	jmp    803cd6 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803c8d:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c99:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
  803ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cac:	74 df                	je     803c8d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803cae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb2:	79 05                	jns    803cb9 <devcons_read+0x4e>
		return c;
  803cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb7:	eb 1d                	jmp    803cd6 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803cb9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803cbd:	75 07                	jne    803cc6 <devcons_read+0x5b>
		return 0;
  803cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc4:	eb 10                	jmp    803cd6 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc9:	89 c2                	mov    %eax,%edx
  803ccb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ccf:	88 10                	mov    %dl,(%rax)
	return 1;
  803cd1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cd6:	c9                   	leaveq 
  803cd7:	c3                   	retq   

0000000000803cd8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803cd8:	55                   	push   %rbp
  803cd9:	48 89 e5             	mov    %rsp,%rbp
  803cdc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ce3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803cea:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cf1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cff:	eb 77                	jmp    803d78 <devcons_write+0xa0>
		m = n - tot;
  803d01:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d08:	89 c2                	mov    %eax,%edx
  803d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0d:	89 d1                	mov    %edx,%ecx
  803d0f:	29 c1                	sub    %eax,%ecx
  803d11:	89 c8                	mov    %ecx,%eax
  803d13:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d19:	83 f8 7f             	cmp    $0x7f,%eax
  803d1c:	76 07                	jbe    803d25 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803d1e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d28:	48 63 d0             	movslq %eax,%rdx
  803d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2e:	48 98                	cltq   
  803d30:	48 89 c1             	mov    %rax,%rcx
  803d33:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803d3a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d41:	48 89 ce             	mov    %rcx,%rsi
  803d44:	48 89 c7             	mov    %rax,%rdi
  803d47:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d56:	48 63 d0             	movslq %eax,%rdx
  803d59:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d60:	48 89 d6             	mov    %rdx,%rsi
  803d63:	48 89 c7             	mov    %rax,%rdi
  803d66:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  803d6d:	00 00 00 
  803d70:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d75:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7b:	48 98                	cltq   
  803d7d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d84:	0f 82 77 ff ff ff    	jb     803d01 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d8d:	c9                   	leaveq 
  803d8e:	c3                   	retq   

0000000000803d8f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d8f:	55                   	push   %rbp
  803d90:	48 89 e5             	mov    %rsp,%rbp
  803d93:	48 83 ec 08          	sub    $0x8,%rsp
  803d97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803da0:	c9                   	leaveq 
  803da1:	c3                   	retq   

0000000000803da2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803da2:	55                   	push   %rbp
  803da3:	48 89 e5             	mov    %rsp,%rbp
  803da6:	48 83 ec 10          	sub    $0x10,%rsp
  803daa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db6:	48 be 28 47 80 00 00 	movabs $0x804728,%rsi
  803dbd:	00 00 00 
  803dc0:	48 89 c7             	mov    %rax,%rdi
  803dc3:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
	return 0;
  803dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dd4:	c9                   	leaveq 
  803dd5:	c3                   	retq   
	...

0000000000803dd8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803dd8:	55                   	push   %rbp
  803dd9:	48 89 e5             	mov    %rsp,%rbp
  803ddc:	48 83 ec 30          	sub    $0x30,%rsp
  803de0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803de4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803de8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803dec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803df3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803df8:	74 18                	je     803e12 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803dfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dfe:	48 89 c7             	mov    %rax,%rdi
  803e01:	48 b8 f9 1c 80 00 00 	movabs $0x801cf9,%rax
  803e08:	00 00 00 
  803e0b:	ff d0                	callq  *%rax
  803e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e10:	eb 19                	jmp    803e2b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803e12:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803e19:	00 00 00 
  803e1c:	48 b8 f9 1c 80 00 00 	movabs $0x801cf9,%rax
  803e23:	00 00 00 
  803e26:	ff d0                	callq  *%rax
  803e28:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803e2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e2f:	79 39                	jns    803e6a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803e31:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e36:	75 08                	jne    803e40 <ipc_recv+0x68>
  803e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e3c:	8b 00                	mov    (%rax),%eax
  803e3e:	eb 05                	jmp    803e45 <ipc_recv+0x6d>
  803e40:	b8 00 00 00 00       	mov    $0x0,%eax
  803e45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e49:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803e4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e50:	75 08                	jne    803e5a <ipc_recv+0x82>
  803e52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e56:	8b 00                	mov    (%rax),%eax
  803e58:	eb 05                	jmp    803e5f <ipc_recv+0x87>
  803e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e63:	89 02                	mov    %eax,(%rdx)
		return r;
  803e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e68:	eb 53                	jmp    803ebd <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803e6a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e6f:	74 19                	je     803e8a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803e71:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803e78:	00 00 00 
  803e7b:	48 8b 00             	mov    (%rax),%rax
  803e7e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e88:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803e8a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e8f:	74 19                	je     803eaa <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803e91:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803e98:	00 00 00 
  803e9b:	48 8b 00             	mov    (%rax),%rax
  803e9e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea8:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803eaa:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803eb1:	00 00 00 
  803eb4:	48 8b 00             	mov    (%rax),%rax
  803eb7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803ebd:	c9                   	leaveq 
  803ebe:	c3                   	retq   

0000000000803ebf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ebf:	55                   	push   %rbp
  803ec0:	48 89 e5             	mov    %rsp,%rbp
  803ec3:	48 83 ec 30          	sub    $0x30,%rsp
  803ec7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803eca:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ecd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ed1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803ed4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803edb:	eb 59                	jmp    803f36 <ipc_send+0x77>
		if(pg) {
  803edd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ee2:	74 20                	je     803f04 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803ee4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ee7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803eea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803eee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef1:	89 c7                	mov    %eax,%edi
  803ef3:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  803efa:	00 00 00 
  803efd:	ff d0                	callq  *%rax
  803eff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f02:	eb 26                	jmp    803f2a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803f04:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f07:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f0d:	89 d1                	mov    %edx,%ecx
  803f0f:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803f16:	00 00 00 
  803f19:	89 c7                	mov    %eax,%edi
  803f1b:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
  803f27:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803f2a:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  803f31:	00 00 00 
  803f34:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803f36:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f3a:	74 a1                	je     803edd <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f40:	74 2a                	je     803f6c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803f42:	48 ba 30 47 80 00 00 	movabs $0x804730,%rdx
  803f49:	00 00 00 
  803f4c:	be 49 00 00 00       	mov    $0x49,%esi
  803f51:	48 bf 5b 47 80 00 00 	movabs $0x80475b,%rdi
  803f58:	00 00 00 
  803f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f60:	48 b9 8c 03 80 00 00 	movabs $0x80038c,%rcx
  803f67:	00 00 00 
  803f6a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803f6c:	c9                   	leaveq 
  803f6d:	c3                   	retq   

0000000000803f6e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f6e:	55                   	push   %rbp
  803f6f:	48 89 e5             	mov    %rsp,%rbp
  803f72:	48 83 ec 18          	sub    $0x18,%rsp
  803f76:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f80:	eb 6a                	jmp    803fec <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803f82:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f89:	00 00 00 
  803f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f8f:	48 63 d0             	movslq %eax,%rdx
  803f92:	48 89 d0             	mov    %rdx,%rax
  803f95:	48 c1 e0 02          	shl    $0x2,%rax
  803f99:	48 01 d0             	add    %rdx,%rax
  803f9c:	48 01 c0             	add    %rax,%rax
  803f9f:	48 01 d0             	add    %rdx,%rax
  803fa2:	48 c1 e0 05          	shl    $0x5,%rax
  803fa6:	48 01 c8             	add    %rcx,%rax
  803fa9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803faf:	8b 00                	mov    (%rax),%eax
  803fb1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fb4:	75 32                	jne    803fe8 <ipc_find_env+0x7a>
			return envs[i].env_id;
  803fb6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fbd:	00 00 00 
  803fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc3:	48 63 d0             	movslq %eax,%rdx
  803fc6:	48 89 d0             	mov    %rdx,%rax
  803fc9:	48 c1 e0 02          	shl    $0x2,%rax
  803fcd:	48 01 d0             	add    %rdx,%rax
  803fd0:	48 01 c0             	add    %rax,%rax
  803fd3:	48 01 d0             	add    %rdx,%rax
  803fd6:	48 c1 e0 05          	shl    $0x5,%rax
  803fda:	48 01 c8             	add    %rcx,%rax
  803fdd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803fe3:	8b 40 08             	mov    0x8(%rax),%eax
  803fe6:	eb 12                	jmp    803ffa <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803fe8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803fec:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ff3:	7e 8d                	jle    803f82 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ffa:	c9                   	leaveq 
  803ffb:	c3                   	retq   

0000000000803ffc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ffc:	55                   	push   %rbp
  803ffd:	48 89 e5             	mov    %rsp,%rbp
  804000:	48 83 ec 18          	sub    $0x18,%rsp
  804004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400c:	48 89 c2             	mov    %rax,%rdx
  80400f:	48 c1 ea 15          	shr    $0x15,%rdx
  804013:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80401a:	01 00 00 
  80401d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804021:	83 e0 01             	and    $0x1,%eax
  804024:	48 85 c0             	test   %rax,%rax
  804027:	75 07                	jne    804030 <pageref+0x34>
		return 0;
  804029:	b8 00 00 00 00       	mov    $0x0,%eax
  80402e:	eb 53                	jmp    804083 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804034:	48 89 c2             	mov    %rax,%rdx
  804037:	48 c1 ea 0c          	shr    $0xc,%rdx
  80403b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804042:	01 00 00 
  804045:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804049:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80404d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804051:	83 e0 01             	and    $0x1,%eax
  804054:	48 85 c0             	test   %rax,%rax
  804057:	75 07                	jne    804060 <pageref+0x64>
		return 0;
  804059:	b8 00 00 00 00       	mov    $0x0,%eax
  80405e:	eb 23                	jmp    804083 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804064:	48 89 c2             	mov    %rax,%rdx
  804067:	48 c1 ea 0c          	shr    $0xc,%rdx
  80406b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804072:	00 00 00 
  804075:	48 c1 e2 04          	shl    $0x4,%rdx
  804079:	48 01 d0             	add    %rdx,%rax
  80407c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804080:	0f b7 c0             	movzwl %ax,%eax
}
  804083:	c9                   	leaveq 
  804084:	c3                   	retq   
