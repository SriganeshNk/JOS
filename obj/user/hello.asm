
obj/user/hello.debug:     file format elf64-x86-64


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
  80003c:	e8 5f 00 00 00       	callq  8000a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800053:	48 bf 60 3b 80 00 00 	movabs $0x803b60,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 93 02 80 00 00 	movabs $0x800293,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800075:	00 00 00 
  800078:	48 8b 00             	mov    (%rax),%rax
  80007b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 6e 3b 80 00 00 	movabs $0x803b6e,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 ba 93 02 80 00 00 	movabs $0x800293,%rdx
  800099:	00 00 00 
  80009c:	ff d2                	callq  *%rdx
}
  80009e:	c9                   	leaveq 
  80009f:	c3                   	retq   

00000000008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %rbp
  8000a1:	48 89 e5             	mov    %rsp,%rbp
  8000a4:	48 83 ec 10          	sub    $0x10,%rsp
  8000a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000b6:	00 00 00 
  8000b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	48 98                	cltq   
  8000ce:	48 89 c2             	mov    %rax,%rdx
  8000d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000d7:	48 89 d0             	mov    %rdx,%rax
  8000da:	48 c1 e0 02          	shl    $0x2,%rax
  8000de:	48 01 d0             	add    %rdx,%rax
  8000e1:	48 01 c0             	add    %rax,%rax
  8000e4:	48 01 d0             	add    %rdx,%rax
  8000e7:	48 c1 e0 05          	shl    $0x5,%rax
  8000eb:	48 89 c2             	mov    %rax,%rdx
  8000ee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f5:	00 00 00 
  8000f8:	48 01 c2             	add    %rax,%rdx
  8000fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800102:	00 00 00 
  800105:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80010c:	7e 14                	jle    800122 <libmain+0x82>
		binaryname = argv[0];
  80010e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800112:	48 8b 10             	mov    (%rax),%rdx
  800115:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80011c:	00 00 00 
  80011f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800122:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	48 89 d6             	mov    %rdx,%rsi
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80013a:	48 b8 48 01 80 00 00 	movabs $0x800148,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80014c:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800158:	bf 00 00 00 00       	mov    $0x0,%edi
  80015d:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  800164:	00 00 00 
  800167:	ff d0                	callq  *%rax
}
  800169:	5d                   	pop    %rbp
  80016a:	c3                   	retq   
	...

000000000080016c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80016c:	55                   	push   %rbp
  80016d:	48 89 e5             	mov    %rsp,%rbp
  800170:	48 83 ec 10          	sub    $0x10,%rsp
  800174:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800177:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80017b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017f:	8b 00                	mov    (%rax),%eax
  800181:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800184:	89 d6                	mov    %edx,%esi
  800186:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80018a:	48 63 d0             	movslq %eax,%rdx
  80018d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800192:	8d 50 01             	lea    0x1(%rax),%edx
  800195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800199:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80019b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019f:	8b 00                	mov    (%rax),%eax
  8001a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a6:	75 2c                	jne    8001d4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8001a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ac:	8b 00                	mov    (%rax),%eax
  8001ae:	48 98                	cltq   
  8001b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b4:	48 83 c2 08          	add    $0x8,%rdx
  8001b8:	48 89 c6             	mov    %rax,%rsi
  8001bb:	48 89 d7             	mov    %rdx,%rdi
  8001be:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
        b->idx = 0;
  8001ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ce:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d8:	8b 40 04             	mov    0x4(%rax),%eax
  8001db:	8d 50 01             	lea    0x1(%rax),%edx
  8001de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001e5:	c9                   	leaveq 
  8001e6:	c3                   	retq   

00000000008001e7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
  8001eb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001f2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001f9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800200:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800207:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80020e:	48 8b 0a             	mov    (%rdx),%rcx
  800211:	48 89 08             	mov    %rcx,(%rax)
  800214:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800218:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80021c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800220:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800224:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80022b:	00 00 00 
    b.cnt = 0;
  80022e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800235:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800238:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80023f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800246:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80024d:	48 89 c6             	mov    %rax,%rsi
  800250:	48 bf 6c 01 80 00 00 	movabs $0x80016c,%rdi
  800257:	00 00 00 
  80025a:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800266:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80026c:	48 98                	cltq   
  80026e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800275:	48 83 c2 08          	add    $0x8,%rdx
  800279:	48 89 c6             	mov    %rax,%rsi
  80027c:	48 89 d7             	mov    %rdx,%rdi
  80027f:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80028b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800291:	c9                   	leaveq 
  800292:	c3                   	retq   

0000000000800293 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800293:	55                   	push   %rbp
  800294:	48 89 e5             	mov    %rsp,%rbp
  800297:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80029e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002a5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002ac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002b3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002ba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002c1:	84 c0                	test   %al,%al
  8002c3:	74 20                	je     8002e5 <cprintf+0x52>
  8002c5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002c9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002cd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002d1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002d5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002d9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002dd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002e1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002e5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002ec:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002f3:	00 00 00 
  8002f6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002fd:	00 00 00 
  800300:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800304:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80030b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800312:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800319:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800320:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800327:	48 8b 0a             	mov    (%rdx),%rcx
  80032a:	48 89 08             	mov    %rcx,(%rax)
  80032d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800331:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800335:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800339:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80033d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800344:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80034b:	48 89 d6             	mov    %rdx,%rsi
  80034e:	48 89 c7             	mov    %rax,%rdi
  800351:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  800358:	00 00 00 
  80035b:	ff d0                	callq  *%rax
  80035d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800363:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800369:	c9                   	leaveq 
  80036a:	c3                   	retq   
	...

000000000080036c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	48 83 ec 30          	sub    $0x30,%rsp
  800374:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800378:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80037c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800380:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800383:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800387:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80038b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80038e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800392:	77 52                	ja     8003e6 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800394:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800397:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80039b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80039e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8003a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ab:	48 f7 75 d0          	divq   -0x30(%rbp)
  8003af:	48 89 c2             	mov    %rax,%rdx
  8003b2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8003b5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003b8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8003bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c0:	41 89 f9             	mov    %edi,%r9d
  8003c3:	48 89 c7             	mov    %rax,%rdi
  8003c6:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  8003cd:	00 00 00 
  8003d0:	ff d0                	callq  *%rax
  8003d2:	eb 1c                	jmp    8003f0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8003db:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8003df:	48 89 d6             	mov    %rdx,%rsi
  8003e2:	89 c7                	mov    %eax,%edi
  8003e4:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003ee:	7f e4                	jg     8003d4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003f0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	48 f7 f1             	div    %rcx
  8003ff:	48 89 d0             	mov    %rdx,%rax
  800402:	48 ba 90 3d 80 00 00 	movabs $0x803d90,%rdx
  800409:	00 00 00 
  80040c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800410:	0f be c0             	movsbl %al,%eax
  800413:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800417:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80041b:	48 89 d6             	mov    %rdx,%rsi
  80041e:	89 c7                	mov    %eax,%edi
  800420:	ff d1                	callq  *%rcx
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 20          	sub    $0x20,%rsp
  80042c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800430:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800433:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800437:	7e 52                	jle    80048b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043d:	8b 00                	mov    (%rax),%eax
  80043f:	83 f8 30             	cmp    $0x30,%eax
  800442:	73 24                	jae    800468 <getuint+0x44>
  800444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800448:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80044c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800450:	8b 00                	mov    (%rax),%eax
  800452:	89 c0                	mov    %eax,%eax
  800454:	48 01 d0             	add    %rdx,%rax
  800457:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045b:	8b 12                	mov    (%rdx),%edx
  80045d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800460:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800464:	89 0a                	mov    %ecx,(%rdx)
  800466:	eb 17                	jmp    80047f <getuint+0x5b>
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800470:	48 89 d0             	mov    %rdx,%rax
  800473:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800477:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80047f:	48 8b 00             	mov    (%rax),%rax
  800482:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800486:	e9 a3 00 00 00       	jmpq   80052e <getuint+0x10a>
	else if (lflag)
  80048b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80048f:	74 4f                	je     8004e0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800495:	8b 00                	mov    (%rax),%eax
  800497:	83 f8 30             	cmp    $0x30,%eax
  80049a:	73 24                	jae    8004c0 <getuint+0x9c>
  80049c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	8b 00                	mov    (%rax),%eax
  8004aa:	89 c0                	mov    %eax,%eax
  8004ac:	48 01 d0             	add    %rdx,%rax
  8004af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b3:	8b 12                	mov    (%rdx),%edx
  8004b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bc:	89 0a                	mov    %ecx,(%rdx)
  8004be:	eb 17                	jmp    8004d7 <getuint+0xb3>
  8004c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004c8:	48 89 d0             	mov    %rdx,%rax
  8004cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d7:	48 8b 00             	mov    (%rax),%rax
  8004da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004de:	eb 4e                	jmp    80052e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e4:	8b 00                	mov    (%rax),%eax
  8004e6:	83 f8 30             	cmp    $0x30,%eax
  8004e9:	73 24                	jae    80050f <getuint+0xeb>
  8004eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	8b 00                	mov    (%rax),%eax
  8004f9:	89 c0                	mov    %eax,%eax
  8004fb:	48 01 d0             	add    %rdx,%rax
  8004fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800502:	8b 12                	mov    (%rdx),%edx
  800504:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050b:	89 0a                	mov    %ecx,(%rdx)
  80050d:	eb 17                	jmp    800526 <getuint+0x102>
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800517:	48 89 d0             	mov    %rdx,%rax
  80051a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800522:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800526:	8b 00                	mov    (%rax),%eax
  800528:	89 c0                	mov    %eax,%eax
  80052a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800532:	c9                   	leaveq 
  800533:	c3                   	retq   

0000000000800534 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800534:	55                   	push   %rbp
  800535:	48 89 e5             	mov    %rsp,%rbp
  800538:	48 83 ec 20          	sub    $0x20,%rsp
  80053c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800540:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800543:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800547:	7e 52                	jle    80059b <getint+0x67>
		x=va_arg(*ap, long long);
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	83 f8 30             	cmp    $0x30,%eax
  800552:	73 24                	jae    800578 <getint+0x44>
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	8b 00                	mov    (%rax),%eax
  800562:	89 c0                	mov    %eax,%eax
  800564:	48 01 d0             	add    %rdx,%rax
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	8b 12                	mov    (%rdx),%edx
  80056d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800570:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800574:	89 0a                	mov    %ecx,(%rdx)
  800576:	eb 17                	jmp    80058f <getint+0x5b>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800580:	48 89 d0             	mov    %rdx,%rax
  800583:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800587:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058f:	48 8b 00             	mov    (%rax),%rax
  800592:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800596:	e9 a3 00 00 00       	jmpq   80063e <getint+0x10a>
	else if (lflag)
  80059b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80059f:	74 4f                	je     8005f0 <getint+0xbc>
		x=va_arg(*ap, long);
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	8b 00                	mov    (%rax),%eax
  8005a7:	83 f8 30             	cmp    $0x30,%eax
  8005aa:	73 24                	jae    8005d0 <getint+0x9c>
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	8b 00                	mov    (%rax),%eax
  8005ba:	89 c0                	mov    %eax,%eax
  8005bc:	48 01 d0             	add    %rdx,%rax
  8005bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c3:	8b 12                	mov    (%rdx),%edx
  8005c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cc:	89 0a                	mov    %ecx,(%rdx)
  8005ce:	eb 17                	jmp    8005e7 <getint+0xb3>
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005d8:	48 89 d0             	mov    %rdx,%rax
  8005db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e7:	48 8b 00             	mov    (%rax),%rax
  8005ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ee:	eb 4e                	jmp    80063e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	8b 00                	mov    (%rax),%eax
  8005f6:	83 f8 30             	cmp    $0x30,%eax
  8005f9:	73 24                	jae    80061f <getint+0xeb>
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800607:	8b 00                	mov    (%rax),%eax
  800609:	89 c0                	mov    %eax,%eax
  80060b:	48 01 d0             	add    %rdx,%rax
  80060e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800612:	8b 12                	mov    (%rdx),%edx
  800614:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061b:	89 0a                	mov    %ecx,(%rdx)
  80061d:	eb 17                	jmp    800636 <getint+0x102>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800627:	48 89 d0             	mov    %rdx,%rax
  80062a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800636:	8b 00                	mov    (%rax),%eax
  800638:	48 98                	cltq   
  80063a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80063e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	41 54                	push   %r12
  80064a:	53                   	push   %rbx
  80064b:	48 83 ec 60          	sub    $0x60,%rsp
  80064f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800653:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800657:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80065b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80065f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800663:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800667:	48 8b 0a             	mov    (%rdx),%rcx
  80066a:	48 89 08             	mov    %rcx,(%rax)
  80066d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800671:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800675:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800679:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067d:	eb 17                	jmp    800696 <vprintfmt+0x52>
			if (ch == '\0')
  80067f:	85 db                	test   %ebx,%ebx
  800681:	0f 84 ea 04 00 00    	je     800b71 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800687:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80068b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80068f:	48 89 c6             	mov    %rax,%rsi
  800692:	89 df                	mov    %ebx,%edi
  800694:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800696:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80069a:	0f b6 00             	movzbl (%rax),%eax
  80069d:	0f b6 d8             	movzbl %al,%ebx
  8006a0:	83 fb 25             	cmp    $0x25,%ebx
  8006a3:	0f 95 c0             	setne  %al
  8006a6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006ab:	84 c0                	test   %al,%al
  8006ad:	75 d0                	jne    80067f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006af:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006b3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8006cf:	eb 04                	jmp    8006d5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8006d1:	90                   	nop
  8006d2:	eb 01                	jmp    8006d5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8006d4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d9:	0f b6 00             	movzbl (%rax),%eax
  8006dc:	0f b6 d8             	movzbl %al,%ebx
  8006df:	89 d8                	mov    %ebx,%eax
  8006e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006e6:	83 e8 23             	sub    $0x23,%eax
  8006e9:	83 f8 55             	cmp    $0x55,%eax
  8006ec:	0f 87 4b 04 00 00    	ja     800b3d <vprintfmt+0x4f9>
  8006f2:	89 c0                	mov    %eax,%eax
  8006f4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006fb:	00 
  8006fc:	48 b8 b8 3d 80 00 00 	movabs $0x803db8,%rax
  800703:	00 00 00 
  800706:	48 01 d0             	add    %rdx,%rax
  800709:	48 8b 00             	mov    (%rax),%rax
  80070c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80070e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800712:	eb c1                	jmp    8006d5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800714:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800718:	eb bb                	jmp    8006d5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800721:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800724:	89 d0                	mov    %edx,%eax
  800726:	c1 e0 02             	shl    $0x2,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	01 c0                	add    %eax,%eax
  80072d:	01 d8                	add    %ebx,%eax
  80072f:	83 e8 30             	sub    $0x30,%eax
  800732:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800735:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800739:	0f b6 00             	movzbl (%rax),%eax
  80073c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80073f:	83 fb 2f             	cmp    $0x2f,%ebx
  800742:	7e 63                	jle    8007a7 <vprintfmt+0x163>
  800744:	83 fb 39             	cmp    $0x39,%ebx
  800747:	7f 5e                	jg     8007a7 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800749:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80074e:	eb d1                	jmp    800721 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800750:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800753:	83 f8 30             	cmp    $0x30,%eax
  800756:	73 17                	jae    80076f <vprintfmt+0x12b>
  800758:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80075c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075f:	89 c0                	mov    %eax,%eax
  800761:	48 01 d0             	add    %rdx,%rax
  800764:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80076d:	eb 0f                	jmp    80077e <vprintfmt+0x13a>
  80076f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800773:	48 89 d0             	mov    %rdx,%rax
  800776:	48 83 c2 08          	add    $0x8,%rdx
  80077a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80077e:	8b 00                	mov    (%rax),%eax
  800780:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800783:	eb 23                	jmp    8007a8 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800785:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800789:	0f 89 42 ff ff ff    	jns    8006d1 <vprintfmt+0x8d>
				width = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800796:	e9 36 ff ff ff       	jmpq   8006d1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  80079b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007a2:	e9 2e ff ff ff       	jmpq   8006d5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007a7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ac:	0f 89 22 ff ff ff    	jns    8006d4 <vprintfmt+0x90>
				width = precision, precision = -1;
  8007b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007b5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007bf:	e9 10 ff ff ff       	jmpq   8006d4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007c4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007c8:	e9 08 ff ff ff       	jmpq   8006d5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 17                	jae    8007ec <vprintfmt+0x1a8>
  8007d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dc:	89 c0                	mov    %eax,%eax
  8007de:	48 01 d0             	add    %rdx,%rax
  8007e1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e4:	83 c2 08             	add    $0x8,%edx
  8007e7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ea:	eb 0f                	jmp    8007fb <vprintfmt+0x1b7>
  8007ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f0:	48 89 d0             	mov    %rdx,%rax
  8007f3:	48 83 c2 08          	add    $0x8,%rdx
  8007f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007fb:	8b 00                	mov    (%rax),%eax
  8007fd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800801:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800805:	48 89 d6             	mov    %rdx,%rsi
  800808:	89 c7                	mov    %eax,%edi
  80080a:	ff d1                	callq  *%rcx
			break;
  80080c:	e9 5a 03 00 00       	jmpq   800b6b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800811:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 17                	jae    800830 <vprintfmt+0x1ec>
  800819:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80081d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800820:	89 c0                	mov    %eax,%eax
  800822:	48 01 d0             	add    %rdx,%rax
  800825:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800828:	83 c2 08             	add    $0x8,%edx
  80082b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082e:	eb 0f                	jmp    80083f <vprintfmt+0x1fb>
  800830:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 83 c2 08          	add    $0x8,%rdx
  80083b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800841:	85 db                	test   %ebx,%ebx
  800843:	79 02                	jns    800847 <vprintfmt+0x203>
				err = -err;
  800845:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800847:	83 fb 15             	cmp    $0x15,%ebx
  80084a:	7f 16                	jg     800862 <vprintfmt+0x21e>
  80084c:	48 b8 e0 3c 80 00 00 	movabs $0x803ce0,%rax
  800853:	00 00 00 
  800856:	48 63 d3             	movslq %ebx,%rdx
  800859:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80085d:	4d 85 e4             	test   %r12,%r12
  800860:	75 2e                	jne    800890 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800862:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800866:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086a:	89 d9                	mov    %ebx,%ecx
  80086c:	48 ba a1 3d 80 00 00 	movabs $0x803da1,%rdx
  800873:	00 00 00 
  800876:	48 89 c7             	mov    %rax,%rdi
  800879:	b8 00 00 00 00       	mov    $0x0,%eax
  80087e:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  800885:	00 00 00 
  800888:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088b:	e9 db 02 00 00       	jmpq   800b6b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800890:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800894:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800898:	4c 89 e1             	mov    %r12,%rcx
  80089b:	48 ba aa 3d 80 00 00 	movabs $0x803daa,%rdx
  8008a2:	00 00 00 
  8008a5:	48 89 c7             	mov    %rax,%rdi
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  8008b4:	00 00 00 
  8008b7:	41 ff d0             	callq  *%r8
			break;
  8008ba:	e9 ac 02 00 00       	jmpq   800b6b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c2:	83 f8 30             	cmp    $0x30,%eax
  8008c5:	73 17                	jae    8008de <vprintfmt+0x29a>
  8008c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ce:	89 c0                	mov    %eax,%eax
  8008d0:	48 01 d0             	add    %rdx,%rax
  8008d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d6:	83 c2 08             	add    $0x8,%edx
  8008d9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008dc:	eb 0f                	jmp    8008ed <vprintfmt+0x2a9>
  8008de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e2:	48 89 d0             	mov    %rdx,%rax
  8008e5:	48 83 c2 08          	add    $0x8,%rdx
  8008e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ed:	4c 8b 20             	mov    (%rax),%r12
  8008f0:	4d 85 e4             	test   %r12,%r12
  8008f3:	75 0a                	jne    8008ff <vprintfmt+0x2bb>
				p = "(null)";
  8008f5:	49 bc ad 3d 80 00 00 	movabs $0x803dad,%r12
  8008fc:	00 00 00 
			if (width > 0 && padc != '-')
  8008ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800903:	7e 7a                	jle    80097f <vprintfmt+0x33b>
  800905:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800909:	74 74                	je     80097f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80090e:	48 98                	cltq   
  800910:	48 89 c6             	mov    %rax,%rsi
  800913:	4c 89 e7             	mov    %r12,%rdi
  800916:	48 b8 26 0e 80 00 00 	movabs $0x800e26,%rax
  80091d:	00 00 00 
  800920:	ff d0                	callq  *%rax
  800922:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800925:	eb 17                	jmp    80093e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800927:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  80092b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800933:	48 89 d6             	mov    %rdx,%rsi
  800936:	89 c7                	mov    %eax,%edi
  800938:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80093a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80093e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800942:	7f e3                	jg     800927 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800944:	eb 39                	jmp    80097f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800946:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80094a:	74 1e                	je     80096a <vprintfmt+0x326>
  80094c:	83 fb 1f             	cmp    $0x1f,%ebx
  80094f:	7e 05                	jle    800956 <vprintfmt+0x312>
  800951:	83 fb 7e             	cmp    $0x7e,%ebx
  800954:	7e 14                	jle    80096a <vprintfmt+0x326>
					putch('?', putdat);
  800956:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80095a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80095e:	48 89 c6             	mov    %rax,%rsi
  800961:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800966:	ff d2                	callq  *%rdx
  800968:	eb 0f                	jmp    800979 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  80096a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80096e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800972:	48 89 c6             	mov    %rax,%rsi
  800975:	89 df                	mov    %ebx,%edi
  800977:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800979:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80097d:	eb 01                	jmp    800980 <vprintfmt+0x33c>
  80097f:	90                   	nop
  800980:	41 0f b6 04 24       	movzbl (%r12),%eax
  800985:	0f be d8             	movsbl %al,%ebx
  800988:	85 db                	test   %ebx,%ebx
  80098a:	0f 95 c0             	setne  %al
  80098d:	49 83 c4 01          	add    $0x1,%r12
  800991:	84 c0                	test   %al,%al
  800993:	74 28                	je     8009bd <vprintfmt+0x379>
  800995:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800999:	78 ab                	js     800946 <vprintfmt+0x302>
  80099b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80099f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009a3:	79 a1                	jns    800946 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a5:	eb 16                	jmp    8009bd <vprintfmt+0x379>
				putch(' ', putdat);
  8009a7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009ab:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009af:	48 89 c6             	mov    %rax,%rsi
  8009b2:	bf 20 00 00 00       	mov    $0x20,%edi
  8009b7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c1:	7f e4                	jg     8009a7 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8009c3:	e9 a3 01 00 00       	jmpq   800b6b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009c8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009cc:	be 03 00 00 00       	mov    $0x3,%esi
  8009d1:	48 89 c7             	mov    %rax,%rdi
  8009d4:	48 b8 34 05 80 00 00 	movabs $0x800534,%rax
  8009db:	00 00 00 
  8009de:	ff d0                	callq  *%rax
  8009e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	79 1d                	jns    800a0a <vprintfmt+0x3c6>
				putch('-', putdat);
  8009ed:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009f1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009f5:	48 89 c6             	mov    %rax,%rsi
  8009f8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009fd:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8009ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a03:	48 f7 d8             	neg    %rax
  800a06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a11:	e9 e8 00 00 00       	jmpq   800afe <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a16:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1a:	be 03 00 00 00       	mov    $0x3,%esi
  800a1f:	48 89 c7             	mov    %rax,%rdi
  800a22:	48 b8 24 04 80 00 00 	movabs $0x800424,%rax
  800a29:	00 00 00 
  800a2c:	ff d0                	callq  *%rax
  800a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a39:	e9 c0 00 00 00       	jmpq   800afe <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a3e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a42:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a46:	48 89 c6             	mov    %rax,%rsi
  800a49:	bf 58 00 00 00       	mov    $0x58,%edi
  800a4e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800a50:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a54:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a58:	48 89 c6             	mov    %rax,%rsi
  800a5b:	bf 58 00 00 00       	mov    $0x58,%edi
  800a60:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800a62:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a66:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a6a:	48 89 c6             	mov    %rax,%rsi
  800a6d:	bf 58 00 00 00       	mov    $0x58,%edi
  800a72:	ff d2                	callq  *%rdx
			break;
  800a74:	e9 f2 00 00 00       	jmpq   800b6b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800a79:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a7d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a81:	48 89 c6             	mov    %rax,%rsi
  800a84:	bf 30 00 00 00       	mov    $0x30,%edi
  800a89:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800a8b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a8f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a93:	48 89 c6             	mov    %rax,%rsi
  800a96:	bf 78 00 00 00       	mov    $0x78,%edi
  800a9b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	83 f8 30             	cmp    $0x30,%eax
  800aa3:	73 17                	jae    800abc <vprintfmt+0x478>
  800aa5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	89 c0                	mov    %eax,%eax
  800aae:	48 01 d0             	add    %rdx,%rax
  800ab1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab4:	83 c2 08             	add    $0x8,%edx
  800ab7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aba:	eb 0f                	jmp    800acb <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800abc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac0:	48 89 d0             	mov    %rdx,%rax
  800ac3:	48 83 c2 08          	add    $0x8,%rdx
  800ac7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800acb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ace:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ad2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ad9:	eb 23                	jmp    800afe <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800adb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800adf:	be 03 00 00 00       	mov    $0x3,%esi
  800ae4:	48 89 c7             	mov    %rax,%rdi
  800ae7:	48 b8 24 04 80 00 00 	movabs $0x800424,%rax
  800aee:	00 00 00 
  800af1:	ff d0                	callq  *%rax
  800af3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800af7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800afe:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b03:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b06:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b15:	45 89 c1             	mov    %r8d,%r9d
  800b18:	41 89 f8             	mov    %edi,%r8d
  800b1b:	48 89 c7             	mov    %rax,%rdi
  800b1e:	48 b8 6c 03 80 00 00 	movabs $0x80036c,%rax
  800b25:	00 00 00 
  800b28:	ff d0                	callq  *%rax
			break;
  800b2a:	eb 3f                	jmp    800b6b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b30:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b34:	48 89 c6             	mov    %rax,%rsi
  800b37:	89 df                	mov    %ebx,%edi
  800b39:	ff d2                	callq  *%rdx
			break;
  800b3b:	eb 2e                	jmp    800b6b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b41:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b45:	48 89 c6             	mov    %rax,%rsi
  800b48:	bf 25 00 00 00       	mov    $0x25,%edi
  800b4d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b54:	eb 05                	jmp    800b5b <vprintfmt+0x517>
  800b56:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b5b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5f:	48 83 e8 01          	sub    $0x1,%rax
  800b63:	0f b6 00             	movzbl (%rax),%eax
  800b66:	3c 25                	cmp    $0x25,%al
  800b68:	75 ec                	jne    800b56 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800b6a:	90                   	nop
		}
	}
  800b6b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6c:	e9 25 fb ff ff       	jmpq   800696 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800b71:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b72:	48 83 c4 60          	add    $0x60,%rsp
  800b76:	5b                   	pop    %rbx
  800b77:	41 5c                	pop    %r12
  800b79:	5d                   	pop    %rbp
  800b7a:	c3                   	retq   

0000000000800b7b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7b:	55                   	push   %rbp
  800b7c:	48 89 e5             	mov    %rsp,%rbp
  800b7f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b86:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b8d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b94:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b9b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 20                	je     800bcd <printfmt+0x52>
  800bad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bb5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bb9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bbd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bc5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bc9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bcd:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bd4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bdb:	00 00 00 
  800bde:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800be5:	00 00 00 
  800be8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bf3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bfa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c01:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c08:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c0f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c16:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c1d:	48 89 c7             	mov    %rax,%rdi
  800c20:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800c27:	00 00 00 
  800c2a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c2c:	c9                   	leaveq 
  800c2d:	c3                   	retq   

0000000000800c2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2e:	55                   	push   %rbp
  800c2f:	48 89 e5             	mov    %rsp,%rbp
  800c32:	48 83 ec 10          	sub    $0x10,%rsp
  800c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c41:	8b 40 10             	mov    0x10(%rax),%eax
  800c44:	8d 50 01             	lea    0x1(%rax),%edx
  800c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c52:	48 8b 10             	mov    (%rax),%rdx
  800c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c59:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c5d:	48 39 c2             	cmp    %rax,%rdx
  800c60:	73 17                	jae    800c79 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	48 8b 00             	mov    (%rax),%rax
  800c69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c6c:	88 10                	mov    %dl,(%rax)
  800c6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c76:	48 89 10             	mov    %rdx,(%rax)
}
  800c79:	c9                   	leaveq 
  800c7a:	c3                   	retq   

0000000000800c7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c7b:	55                   	push   %rbp
  800c7c:	48 89 e5             	mov    %rsp,%rbp
  800c7f:	48 83 ec 50          	sub    $0x50,%rsp
  800c83:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c87:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c8a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c8e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c92:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c96:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c9a:	48 8b 0a             	mov    (%rdx),%rcx
  800c9d:	48 89 08             	mov    %rcx,(%rax)
  800ca0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cb8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cbb:	48 98                	cltq   
  800cbd:	48 83 e8 01          	sub    $0x1,%rax
  800cc1:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800cc5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cd0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x62>
  800cd7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x69>
		return -E_INVAL;
  800cdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce2:	eb 2f                	jmp    800d13 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ce4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ce8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cf0:	48 89 c6             	mov    %rax,%rsi
  800cf3:	48 bf 2e 0c 80 00 00 	movabs $0x800c2e,%rdi
  800cfa:	00 00 00 
  800cfd:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d0d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d10:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d13:	c9                   	leaveq 
  800d14:	c3                   	retq   

0000000000800d15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d15:	55                   	push   %rbp
  800d16:	48 89 e5             	mov    %rsp,%rbp
  800d19:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d20:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d27:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d42:	84 c0                	test   %al,%al
  800d44:	74 20                	je     800d66 <snprintf+0x51>
  800d46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d66:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d6d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d74:	00 00 00 
  800d77:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d7e:	00 00 00 
  800d81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d85:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d93:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d9a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800da8:	48 8b 0a             	mov    (%rdx),%rcx
  800dab:	48 89 08             	mov    %rcx,(%rax)
  800dae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dbe:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dc5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dcc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dd2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dd9:	48 89 c7             	mov    %rax,%rdi
  800ddc:	48 b8 7b 0c 80 00 00 	movabs $0x800c7b,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df4:	c9                   	leaveq 
  800df5:	c3                   	retq   
	...

0000000000800df8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 83 ec 18          	sub    $0x18,%rsp
  800e00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0b:	eb 09                	jmp    800e16 <strlen+0x1e>
		n++;
  800e0d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e11:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1a:	0f b6 00             	movzbl (%rax),%eax
  800e1d:	84 c0                	test   %al,%al
  800e1f:	75 ec                	jne    800e0d <strlen+0x15>
		n++;
	return n;
  800e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e24:	c9                   	leaveq 
  800e25:	c3                   	retq   

0000000000800e26 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e26:	55                   	push   %rbp
  800e27:	48 89 e5             	mov    %rsp,%rbp
  800e2a:	48 83 ec 20          	sub    $0x20,%rsp
  800e2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e3d:	eb 0e                	jmp    800e4d <strnlen+0x27>
		n++;
  800e3f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e43:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e48:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e4d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e52:	74 0b                	je     800e5f <strnlen+0x39>
  800e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e58:	0f b6 00             	movzbl (%rax),%eax
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e0                	jne    800e3f <strnlen+0x19>
		n++;
	return n;
  800e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e62:	c9                   	leaveq 
  800e63:	c3                   	retq   

0000000000800e64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e64:	55                   	push   %rbp
  800e65:	48 89 e5             	mov    %rsp,%rbp
  800e68:	48 83 ec 20          	sub    $0x20,%rsp
  800e6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e78:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e7c:	90                   	nop
  800e7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e81:	0f b6 10             	movzbl (%rax),%edx
  800e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e88:	88 10                	mov    %dl,(%rax)
  800e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8e:	0f b6 00             	movzbl (%rax),%eax
  800e91:	84 c0                	test   %al,%al
  800e93:	0f 95 c0             	setne  %al
  800e96:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e9b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800ea0:	84 c0                	test   %al,%al
  800ea2:	75 d9                	jne    800e7d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ea8:	c9                   	leaveq 
  800ea9:	c3                   	retq   

0000000000800eaa <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 83 ec 20          	sub    $0x20,%rsp
  800eb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebe:	48 89 c7             	mov    %rax,%rdi
  800ec1:	48 b8 f8 0d 80 00 00 	movabs $0x800df8,%rax
  800ec8:	00 00 00 
  800ecb:	ff d0                	callq  *%rax
  800ecd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed3:	48 98                	cltq   
  800ed5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800ed9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800edd:	48 89 d6             	mov    %rdx,%rsi
  800ee0:	48 89 c7             	mov    %rax,%rdi
  800ee3:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
	return dst;
  800eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ef3:	c9                   	leaveq 
  800ef4:	c3                   	retq   

0000000000800ef5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef5:	55                   	push   %rbp
  800ef6:	48 89 e5             	mov    %rsp,%rbp
  800ef9:	48 83 ec 28          	sub    $0x28,%rsp
  800efd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f11:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f18:	00 
  800f19:	eb 27                	jmp    800f42 <strncpy+0x4d>
		*dst++ = *src;
  800f1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f1f:	0f b6 10             	movzbl (%rax),%edx
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	88 10                	mov    %dl,(%rax)
  800f28:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f31:	0f b6 00             	movzbl (%rax),%eax
  800f34:	84 c0                	test   %al,%al
  800f36:	74 05                	je     800f3d <strncpy+0x48>
			src++;
  800f38:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f46:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f4a:	72 cf                	jb     800f1b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 28          	sub    $0x28,%rsp
  800f5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f73:	74 37                	je     800fac <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800f75:	eb 17                	jmp    800f8e <strlcpy+0x3c>
			*dst++ = *src++;
  800f77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7b:	0f b6 10             	movzbl (%rax),%edx
  800f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f82:	88 10                	mov    %dl,(%rax)
  800f84:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f89:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f8e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f98:	74 0b                	je     800fa5 <strlcpy+0x53>
  800f9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f9e:	0f b6 00             	movzbl (%rax),%eax
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 d2                	jne    800f77 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb4:	48 89 d1             	mov    %rdx,%rcx
  800fb7:	48 29 c1             	sub    %rax,%rcx
  800fba:	48 89 c8             	mov    %rcx,%rax
}
  800fbd:	c9                   	leaveq 
  800fbe:	c3                   	retq   

0000000000800fbf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fbf:	55                   	push   %rbp
  800fc0:	48 89 e5             	mov    %rsp,%rbp
  800fc3:	48 83 ec 10          	sub    $0x10,%rsp
  800fc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fcf:	eb 0a                	jmp    800fdb <strcmp+0x1c>
		p++, q++;
  800fd1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	74 12                	je     800ff8 <strcmp+0x39>
  800fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fea:	0f b6 10             	movzbl (%rax),%edx
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	0f b6 00             	movzbl (%rax),%eax
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 d9                	je     800fd1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffc:	0f b6 00             	movzbl (%rax),%eax
  800fff:	0f b6 d0             	movzbl %al,%edx
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	89 d1                	mov    %edx,%ecx
  80100e:	29 c1                	sub    %eax,%ecx
  801010:	89 c8                	mov    %ecx,%eax
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 18          	sub    $0x18,%rsp
  80101c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801020:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801024:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801028:	eb 0f                	jmp    801039 <strncmp+0x25>
		n--, p++, q++;
  80102a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80102f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801034:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801039:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80103e:	74 1d                	je     80105d <strncmp+0x49>
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	84 c0                	test   %al,%al
  801049:	74 12                	je     80105d <strncmp+0x49>
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	0f b6 10             	movzbl (%rax),%edx
  801052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	38 c2                	cmp    %al,%dl
  80105b:	74 cd                	je     80102a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80105d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801062:	75 07                	jne    80106b <strncmp+0x57>
		return 0;
  801064:	b8 00 00 00 00       	mov    $0x0,%eax
  801069:	eb 1a                	jmp    801085 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80106b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801079:	0f b6 00             	movzbl (%rax),%eax
  80107c:	0f b6 c0             	movzbl %al,%eax
  80107f:	89 d1                	mov    %edx,%ecx
  801081:	29 c1                	sub    %eax,%ecx
  801083:	89 c8                	mov    %ecx,%eax
}
  801085:	c9                   	leaveq 
  801086:	c3                   	retq   

0000000000801087 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801087:	55                   	push   %rbp
  801088:	48 89 e5             	mov    %rsp,%rbp
  80108b:	48 83 ec 10          	sub    $0x10,%rsp
  80108f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801093:	89 f0                	mov    %esi,%eax
  801095:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801098:	eb 17                	jmp    8010b1 <strchr+0x2a>
		if (*s == c)
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a4:	75 06                	jne    8010ac <strchr+0x25>
			return (char *) s;
  8010a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010aa:	eb 15                	jmp    8010c1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 de                	jne    80109a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c1:	c9                   	leaveq 
  8010c2:	c3                   	retq   

00000000008010c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c3:	55                   	push   %rbp
  8010c4:	48 89 e5             	mov    %rsp,%rbp
  8010c7:	48 83 ec 10          	sub    $0x10,%rsp
  8010cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d4:	eb 11                	jmp    8010e7 <strfind+0x24>
		if (*s == c)
  8010d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010da:	0f b6 00             	movzbl (%rax),%eax
  8010dd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e0:	74 12                	je     8010f4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	0f b6 00             	movzbl (%rax),%eax
  8010ee:	84 c0                	test   %al,%al
  8010f0:	75 e4                	jne    8010d6 <strfind+0x13>
  8010f2:	eb 01                	jmp    8010f5 <strfind+0x32>
		if (*s == c)
			break;
  8010f4:	90                   	nop
	return (char *) s;
  8010f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 18          	sub    $0x18,%rsp
  801103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801107:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80110a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80110e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801113:	75 06                	jne    80111b <memset+0x20>
		return v;
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	eb 69                	jmp    801184 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111f:	83 e0 03             	and    $0x3,%eax
  801122:	48 85 c0             	test   %rax,%rax
  801125:	75 48                	jne    80116f <memset+0x74>
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	83 e0 03             	and    $0x3,%eax
  80112e:	48 85 c0             	test   %rax,%rax
  801131:	75 3c                	jne    80116f <memset+0x74>
		c &= 0xFF;
  801133:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113d:	89 c2                	mov    %eax,%edx
  80113f:	c1 e2 18             	shl    $0x18,%edx
  801142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801145:	c1 e0 10             	shl    $0x10,%eax
  801148:	09 c2                	or     %eax,%edx
  80114a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114d:	c1 e0 08             	shl    $0x8,%eax
  801150:	09 d0                	or     %edx,%eax
  801152:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 89 c1             	mov    %rax,%rcx
  80115c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801160:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801164:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801167:	48 89 d7             	mov    %rdx,%rdi
  80116a:	fc                   	cld    
  80116b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80116d:	eb 11                	jmp    801180 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80116f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801176:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80117a:	48 89 d7             	mov    %rdx,%rdi
  80117d:	fc                   	cld    
  80117e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 28          	sub    $0x28,%rsp
  80118e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801196:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80119a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011b2:	0f 83 88 00 00 00    	jae    801240 <memmove+0xba>
  8011b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c0:	48 01 d0             	add    %rdx,%rax
  8011c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011c7:	76 77                	jbe    801240 <memmove+0xba>
		s += n;
  8011c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	48 85 c0             	test   %rax,%rax
  8011e3:	75 3b                	jne    801220 <memmove+0x9a>
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	83 e0 03             	and    $0x3,%eax
  8011ec:	48 85 c0             	test   %rax,%rax
  8011ef:	75 2f                	jne    801220 <memmove+0x9a>
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	83 e0 03             	and    $0x3,%eax
  8011f8:	48 85 c0             	test   %rax,%rax
  8011fb:	75 23                	jne    801220 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801201:	48 83 e8 04          	sub    $0x4,%rax
  801205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801209:	48 83 ea 04          	sub    $0x4,%rdx
  80120d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801211:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801215:	48 89 c7             	mov    %rax,%rdi
  801218:	48 89 d6             	mov    %rdx,%rsi
  80121b:	fd                   	std    
  80121c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80121e:	eb 1d                	jmp    80123d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801224:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801234:	48 89 d7             	mov    %rdx,%rdi
  801237:	48 89 c1             	mov    %rax,%rcx
  80123a:	fd                   	std    
  80123b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80123d:	fc                   	cld    
  80123e:	eb 57                	jmp    801297 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	83 e0 03             	and    $0x3,%eax
  801247:	48 85 c0             	test   %rax,%rax
  80124a:	75 36                	jne    801282 <memmove+0xfc>
  80124c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801250:	83 e0 03             	and    $0x3,%eax
  801253:	48 85 c0             	test   %rax,%rax
  801256:	75 2a                	jne    801282 <memmove+0xfc>
  801258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125c:	83 e0 03             	and    $0x3,%eax
  80125f:	48 85 c0             	test   %rax,%rax
  801262:	75 1e                	jne    801282 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801268:	48 89 c1             	mov    %rax,%rcx
  80126b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80126f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801273:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801277:	48 89 c7             	mov    %rax,%rdi
  80127a:	48 89 d6             	mov    %rdx,%rsi
  80127d:	fc                   	cld    
  80127e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801280:	eb 15                	jmp    801297 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801286:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 89 d6             	mov    %rdx,%rsi
  801294:	fc                   	cld    
  801295:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 18          	sub    $0x18,%rsp
  8012a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	48 89 ce             	mov    %rcx,%rsi
  8012c0:	48 89 c7             	mov    %rax,%rdi
  8012c3:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	callq  *%rax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 83 ec 28          	sub    $0x28,%rsp
  8012d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012f5:	eb 38                	jmp    80132f <memcmp+0x5e>
		if (*s1 != *s2)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 10             	movzbl (%rax),%edx
  8012fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801302:	0f b6 00             	movzbl (%rax),%eax
  801305:	38 c2                	cmp    %al,%dl
  801307:	74 1c                	je     801325 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	0f b6 d0             	movzbl %al,%edx
  801313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801317:	0f b6 00             	movzbl (%rax),%eax
  80131a:	0f b6 c0             	movzbl %al,%eax
  80131d:	89 d1                	mov    %edx,%ecx
  80131f:	29 c1                	sub    %eax,%ecx
  801321:	89 c8                	mov    %ecx,%eax
  801323:	eb 20                	jmp    801345 <memcmp+0x74>
		s1++, s2++;
  801325:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80132f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801334:	0f 95 c0             	setne  %al
  801337:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80133c:	84 c0                	test   %al,%al
  80133e:	75 b7                	jne    8012f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 28          	sub    $0x28,%rsp
  80134f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801353:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801356:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80135a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801362:	48 01 d0             	add    %rdx,%rax
  801365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801369:	eb 13                	jmp    80137e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	0f b6 10             	movzbl (%rax),%edx
  801372:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801375:	38 c2                	cmp    %al,%dl
  801377:	74 11                	je     80138a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801379:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80137e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801382:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801386:	72 e3                	jb     80136b <memfind+0x24>
  801388:	eb 01                	jmp    80138b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80138a:	90                   	nop
	return (void *) s;
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138f:	c9                   	leaveq 
  801390:	c3                   	retq   

0000000000801391 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	48 83 ec 38          	sub    $0x38,%rsp
  801399:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80139d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013a1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ab:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013b2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b3:	eb 05                	jmp    8013ba <strtol+0x29>
		s++;
  8013b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	3c 20                	cmp    $0x20,%al
  8013c3:	74 f0                	je     8013b5 <strtol+0x24>
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	3c 09                	cmp    $0x9,%al
  8013ce:	74 e5                	je     8013b5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	3c 2b                	cmp    $0x2b,%al
  8013d9:	75 07                	jne    8013e2 <strtol+0x51>
		s++;
  8013db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e0:	eb 17                	jmp    8013f9 <strtol+0x68>
	else if (*s == '-')
  8013e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	3c 2d                	cmp    $0x2d,%al
  8013eb:	75 0c                	jne    8013f9 <strtol+0x68>
		s++, neg = 1;
  8013ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013fd:	74 06                	je     801405 <strtol+0x74>
  8013ff:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801403:	75 28                	jne    80142d <strtol+0x9c>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3c 30                	cmp    $0x30,%al
  80140e:	75 1d                	jne    80142d <strtol+0x9c>
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 83 c0 01          	add    $0x1,%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0e                	jne    80142d <strtol+0x9c>
		s += 2, base = 16;
  80141f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801424:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80142b:	eb 2c                	jmp    801459 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80142d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801431:	75 19                	jne    80144c <strtol+0xbb>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 30                	cmp    $0x30,%al
  80143c:	75 0e                	jne    80144c <strtol+0xbb>
		s++, base = 8;
  80143e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801443:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80144a:	eb 0d                	jmp    801459 <strtol+0xc8>
	else if (base == 0)
  80144c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801450:	75 07                	jne    801459 <strtol+0xc8>
		base = 10;
  801452:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 2f                	cmp    $0x2f,%al
  801462:	7e 1d                	jle    801481 <strtol+0xf0>
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 39                	cmp    $0x39,%al
  80146d:	7f 12                	jg     801481 <strtol+0xf0>
			dig = *s - '0';
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	0f be c0             	movsbl %al,%eax
  801479:	83 e8 30             	sub    $0x30,%eax
  80147c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80147f:	eb 4e                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 60                	cmp    $0x60,%al
  80148a:	7e 1d                	jle    8014a9 <strtol+0x118>
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 7a                	cmp    $0x7a,%al
  801495:	7f 12                	jg     8014a9 <strtol+0x118>
			dig = *s - 'a' + 10;
  801497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	0f be c0             	movsbl %al,%eax
  8014a1:	83 e8 57             	sub    $0x57,%eax
  8014a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a7:	eb 26                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 40                	cmp    $0x40,%al
  8014b2:	7e 47                	jle    8014fb <strtol+0x16a>
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	3c 5a                	cmp    $0x5a,%al
  8014bd:	7f 3c                	jg     8014fb <strtol+0x16a>
			dig = *s - 'A' + 10;
  8014bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c3:	0f b6 00             	movzbl (%rax),%eax
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	83 e8 37             	sub    $0x37,%eax
  8014cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014d5:	7d 23                	jge    8014fa <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014dc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014df:	48 98                	cltq   
  8014e1:	48 89 c2             	mov    %rax,%rdx
  8014e4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8014e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ec:	48 98                	cltq   
  8014ee:	48 01 d0             	add    %rdx,%rax
  8014f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014f5:	e9 5f ff ff ff       	jmpq   801459 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014fa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014fb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801500:	74 0b                	je     80150d <strtol+0x17c>
		*endptr = (char *) s;
  801502:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801506:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80150d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801511:	74 09                	je     80151c <strtol+0x18b>
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	48 f7 d8             	neg    %rax
  80151a:	eb 04                	jmp    801520 <strtol+0x18f>
  80151c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801520:	c9                   	leaveq 
  801521:	c3                   	retq   

0000000000801522 <strstr>:

char * strstr(const char *in, const char *str)
{
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	48 83 ec 30          	sub    $0x30,%rsp
  80152a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801532:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	88 45 ff             	mov    %al,-0x1(%rbp)
  80153c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801541:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801545:	75 06                	jne    80154d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	eb 68                	jmp    8015b5 <strstr+0x93>

	len = strlen(str);
  80154d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801551:	48 89 c7             	mov    %rax,%rdi
  801554:	48 b8 f8 0d 80 00 00 	movabs $0x800df8,%rax
  80155b:	00 00 00 
  80155e:	ff d0                	callq  *%rax
  801560:	48 98                	cltq   
  801562:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	0f b6 00             	movzbl (%rax),%eax
  80156d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801570:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801575:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801579:	75 07                	jne    801582 <strstr+0x60>
				return (char *) 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb 33                	jmp    8015b5 <strstr+0x93>
		} while (sc != c);
  801582:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801586:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801589:	75 db                	jne    801566 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80158b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80158f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 89 ce             	mov    %rcx,%rsi
  80159a:	48 89 c7             	mov    %rax,%rdi
  80159d:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	75 b9                	jne    801566 <strstr+0x44>

	return (char *) (in - 1);
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	48 83 e8 01          	sub    $0x1,%rax
}
  8015b5:	c9                   	leaveq 
  8015b6:	c3                   	retq   
	...

00000000008015b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015b8:	55                   	push   %rbp
  8015b9:	48 89 e5             	mov    %rsp,%rbp
  8015bc:	53                   	push   %rbx
  8015bd:	48 83 ec 58          	sub    $0x58,%rsp
  8015c1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015c4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015c7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015cb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015cf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015d3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015da:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8015dd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015e1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015e5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015e9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015ed:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015f1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8015f4:	4c 89 c3             	mov    %r8,%rbx
  8015f7:	cd 30                	int    $0x30
  8015f9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8015fd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801601:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801605:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801609:	74 3e                	je     801649 <syscall+0x91>
  80160b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801610:	7e 37                	jle    801649 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801612:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801616:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801619:	49 89 d0             	mov    %rdx,%r8
  80161c:	89 c1                	mov    %eax,%ecx
  80161e:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  801625:	00 00 00 
  801628:	be 23 00 00 00       	mov    $0x23,%esi
  80162d:	48 bf 85 40 80 00 00 	movabs $0x804085,%rdi
  801634:	00 00 00 
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	49 b9 9c 37 80 00 00 	movabs $0x80379c,%r9
  801643:	00 00 00 
  801646:	41 ff d1             	callq  *%r9

	return ret;
  801649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164d:	48 83 c4 58          	add    $0x58,%rsp
  801651:	5b                   	pop    %rbx
  801652:	5d                   	pop    %rbp
  801653:	c3                   	retq   

0000000000801654 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 20          	sub    $0x20,%rsp
  80165c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801660:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801668:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80166c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801673:	00 
  801674:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80167a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801680:	48 89 d1             	mov    %rdx,%rcx
  801683:	48 89 c2             	mov    %rax,%rdx
  801686:	be 00 00 00 00       	mov    $0x0,%esi
  80168b:	bf 00 00 00 00       	mov    $0x0,%edi
  801690:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801697:	00 00 00 
  80169a:	ff d0                	callq  *%rax
}
  80169c:	c9                   	leaveq 
  80169d:	c3                   	retq   

000000000080169e <sys_cgetc>:

int
sys_cgetc(void)
{
  80169e:	55                   	push   %rbp
  80169f:	48 89 e5             	mov    %rsp,%rbp
  8016a2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ad:	00 
  8016ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c4:	be 00 00 00 00       	mov    $0x0,%esi
  8016c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8016ce:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8016d5:	00 00 00 
  8016d8:	ff d0                	callq  *%rax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 20          	sub    $0x20,%rsp
  8016e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ea:	48 98                	cltq   
  8016ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f3:	00 
  8016f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801700:	b9 00 00 00 00       	mov    $0x0,%ecx
  801705:	48 89 c2             	mov    %rax,%rdx
  801708:	be 01 00 00 00       	mov    $0x1,%esi
  80170d:	bf 03 00 00 00       	mov    $0x3,%edi
  801712:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801719:	00 00 00 
  80171c:	ff d0                	callq  *%rax
}
  80171e:	c9                   	leaveq 
  80171f:	c3                   	retq   

0000000000801720 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801728:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172f:	00 
  801730:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801736:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	be 00 00 00 00       	mov    $0x0,%esi
  80174b:	bf 02 00 00 00       	mov    $0x2,%edi
  801750:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
}
  80175c:	c9                   	leaveq 
  80175d:	c3                   	retq   

000000000080175e <sys_yield>:

void
sys_yield(void)
{
  80175e:	55                   	push   %rbp
  80175f:	48 89 e5             	mov    %rsp,%rbp
  801762:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801766:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176d:	00 
  80176e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801774:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80177a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	be 00 00 00 00       	mov    $0x0,%esi
  801789:	bf 0b 00 00 00       	mov    $0xb,%edi
  80178e:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801795:	00 00 00 
  801798:	ff d0                	callq  *%rax
}
  80179a:	c9                   	leaveq 
  80179b:	c3                   	retq   

000000000080179c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	48 83 ec 20          	sub    $0x20,%rsp
  8017a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ab:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017b1:	48 63 c8             	movslq %eax,%rcx
  8017b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017bb:	48 98                	cltq   
  8017bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c4:	00 
  8017c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017cb:	49 89 c8             	mov    %rcx,%r8
  8017ce:	48 89 d1             	mov    %rdx,%rcx
  8017d1:	48 89 c2             	mov    %rax,%rdx
  8017d4:	be 01 00 00 00       	mov    $0x1,%esi
  8017d9:	bf 04 00 00 00       	mov    $0x4,%edi
  8017de:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
}
  8017ea:	c9                   	leaveq 
  8017eb:	c3                   	retq   

00000000008017ec <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	48 83 ec 30          	sub    $0x30,%rsp
  8017f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017fb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017fe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801802:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801806:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801809:	48 63 c8             	movslq %eax,%rcx
  80180c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801810:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801813:	48 63 f0             	movslq %eax,%rsi
  801816:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181d:	48 98                	cltq   
  80181f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801823:	49 89 f9             	mov    %rdi,%r9
  801826:	49 89 f0             	mov    %rsi,%r8
  801829:	48 89 d1             	mov    %rdx,%rcx
  80182c:	48 89 c2             	mov    %rax,%rdx
  80182f:	be 01 00 00 00       	mov    $0x1,%esi
  801834:	bf 05 00 00 00       	mov    $0x5,%edi
  801839:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801840:	00 00 00 
  801843:	ff d0                	callq  *%rax
}
  801845:	c9                   	leaveq 
  801846:	c3                   	retq   

0000000000801847 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801847:	55                   	push   %rbp
  801848:	48 89 e5             	mov    %rsp,%rbp
  80184b:	48 83 ec 20          	sub    $0x20,%rsp
  80184f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801852:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801856:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185d:	48 98                	cltq   
  80185f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801866:	00 
  801867:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801873:	48 89 d1             	mov    %rdx,%rcx
  801876:	48 89 c2             	mov    %rax,%rdx
  801879:	be 01 00 00 00       	mov    $0x1,%esi
  80187e:	bf 06 00 00 00       	mov    $0x6,%edi
  801883:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  80188a:	00 00 00 
  80188d:	ff d0                	callq  *%rax
}
  80188f:	c9                   	leaveq 
  801890:	c3                   	retq   

0000000000801891 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801891:	55                   	push   %rbp
  801892:	48 89 e5             	mov    %rsp,%rbp
  801895:	48 83 ec 20          	sub    $0x20,%rsp
  801899:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80189c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80189f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a2:	48 63 d0             	movslq %eax,%rdx
  8018a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a8:	48 98                	cltq   
  8018aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b1:	00 
  8018b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018be:	48 89 d1             	mov    %rdx,%rcx
  8018c1:	48 89 c2             	mov    %rax,%rdx
  8018c4:	be 01 00 00 00       	mov    $0x1,%esi
  8018c9:	bf 08 00 00 00       	mov    $0x8,%edi
  8018ce:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	callq  *%rax
}
  8018da:	c9                   	leaveq 
  8018db:	c3                   	retq   

00000000008018dc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018dc:	55                   	push   %rbp
  8018dd:	48 89 e5             	mov    %rsp,%rbp
  8018e0:	48 83 ec 20          	sub    $0x20,%rsp
  8018e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f2:	48 98                	cltq   
  8018f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fb:	00 
  8018fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801902:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801908:	48 89 d1             	mov    %rdx,%rcx
  80190b:	48 89 c2             	mov    %rax,%rdx
  80190e:	be 01 00 00 00       	mov    $0x1,%esi
  801913:	bf 09 00 00 00       	mov    $0x9,%edi
  801918:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  80191f:	00 00 00 
  801922:	ff d0                	callq  *%rax
}
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	48 83 ec 20          	sub    $0x20,%rsp
  80192e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801931:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801935:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193c:	48 98                	cltq   
  80193e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801945:	00 
  801946:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801952:	48 89 d1             	mov    %rdx,%rcx
  801955:	48 89 c2             	mov    %rax,%rdx
  801958:	be 01 00 00 00       	mov    $0x1,%esi
  80195d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801962:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801969:	00 00 00 
  80196c:	ff d0                	callq  *%rax
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 30          	sub    $0x30,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801983:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801986:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801989:	48 63 f0             	movslq %eax,%rsi
  80198c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801993:	48 98                	cltq   
  801995:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801999:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a0:	00 
  8019a1:	49 89 f1             	mov    %rsi,%r9
  8019a4:	49 89 c8             	mov    %rcx,%r8
  8019a7:	48 89 d1             	mov    %rdx,%rcx
  8019aa:	48 89 c2             	mov    %rax,%rdx
  8019ad:	be 00 00 00 00       	mov    $0x0,%esi
  8019b2:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019b7:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8019be:	00 00 00 
  8019c1:	ff d0                	callq  *%rax
}
  8019c3:	c9                   	leaveq 
  8019c4:	c3                   	retq   

00000000008019c5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019c5:	55                   	push   %rbp
  8019c6:	48 89 e5             	mov    %rsp,%rbp
  8019c9:	48 83 ec 20          	sub    $0x20,%rsp
  8019cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dc:	00 
  8019dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ee:	48 89 c2             	mov    %rax,%rdx
  8019f1:	be 01 00 00 00       	mov    $0x1,%esi
  8019f6:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019fb:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a18:	00 
  801a19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a25:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2f:	be 00 00 00 00       	mov    $0x0,%esi
  801a34:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a39:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801a40:	00 00 00 
  801a43:	ff d0                	callq  *%rax
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 30          	sub    $0x30,%rsp
  801a4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a56:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a59:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a5d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801a61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a64:	48 63 c8             	movslq %eax,%rcx
  801a67:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6e:	48 63 f0             	movslq %eax,%rsi
  801a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a78:	48 98                	cltq   
  801a7a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a7e:	49 89 f9             	mov    %rdi,%r9
  801a81:	49 89 f0             	mov    %rsi,%r8
  801a84:	48 89 d1             	mov    %rdx,%rcx
  801a87:	48 89 c2             	mov    %rax,%rdx
  801a8a:	be 00 00 00 00       	mov    $0x0,%esi
  801a8f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a94:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 20          	sub    $0x20,%rsp
  801aaa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ab2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac1:	00 
  801ac2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ace:	48 89 d1             	mov    %rdx,%rcx
  801ad1:	48 89 c2             	mov    %rax,%rdx
  801ad4:	be 00 00 00 00       	mov    $0x0,%esi
  801ad9:	bf 10 00 00 00       	mov    $0x10,%edi
  801ade:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 08          	sub    $0x8,%rsp
  801af4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801af8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801afc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b03:	ff ff ff 
  801b06:	48 01 d0             	add    %rdx,%rax
  801b09:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 08          	sub    $0x8,%rsp
  801b17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1f:	48 89 c7             	mov    %rax,%rdi
  801b22:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
  801b2e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b34:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b38:	c9                   	leaveq 
  801b39:	c3                   	retq   

0000000000801b3a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b3a:	55                   	push   %rbp
  801b3b:	48 89 e5             	mov    %rsp,%rbp
  801b3e:	48 83 ec 18          	sub    $0x18,%rsp
  801b42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b4d:	eb 6b                	jmp    801bba <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b52:	48 98                	cltq   
  801b54:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b5a:	48 c1 e0 0c          	shl    $0xc,%rax
  801b5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b66:	48 89 c2             	mov    %rax,%rdx
  801b69:	48 c1 ea 15          	shr    $0x15,%rdx
  801b6d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b74:	01 00 00 
  801b77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b7b:	83 e0 01             	and    $0x1,%eax
  801b7e:	48 85 c0             	test   %rax,%rax
  801b81:	74 21                	je     801ba4 <fd_alloc+0x6a>
  801b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b87:	48 89 c2             	mov    %rax,%rdx
  801b8a:	48 c1 ea 0c          	shr    $0xc,%rdx
  801b8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b95:	01 00 00 
  801b98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b9c:	83 e0 01             	and    $0x1,%eax
  801b9f:	48 85 c0             	test   %rax,%rax
  801ba2:	75 12                	jne    801bb6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bac:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb4:	eb 1a                	jmp    801bd0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bbe:	7e 8f                	jle    801b4f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801bcb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 20          	sub    $0x20,%rsp
  801bda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801bdd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801be1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801be5:	78 06                	js     801bed <fd_lookup+0x1b>
  801be7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801beb:	7e 07                	jle    801bf4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf2:	eb 6c                	jmp    801c60 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801bf4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bf7:	48 98                	cltq   
  801bf9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801bff:	48 c1 e0 0c          	shl    $0xc,%rax
  801c03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0b:	48 89 c2             	mov    %rax,%rdx
  801c0e:	48 c1 ea 15          	shr    $0x15,%rdx
  801c12:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c19:	01 00 00 
  801c1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c20:	83 e0 01             	and    $0x1,%eax
  801c23:	48 85 c0             	test   %rax,%rax
  801c26:	74 21                	je     801c49 <fd_lookup+0x77>
  801c28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2c:	48 89 c2             	mov    %rax,%rdx
  801c2f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801c33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c3a:	01 00 00 
  801c3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c41:	83 e0 01             	and    $0x1,%eax
  801c44:	48 85 c0             	test   %rax,%rax
  801c47:	75 07                	jne    801c50 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c4e:	eb 10                	jmp    801c60 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c58:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c60:	c9                   	leaveq 
  801c61:	c3                   	retq   

0000000000801c62 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c62:	55                   	push   %rbp
  801c63:	48 89 e5             	mov    %rsp,%rbp
  801c66:	48 83 ec 30          	sub    $0x30,%rsp
  801c6a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c6e:	89 f0                	mov    %esi,%eax
  801c70:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c77:	48 89 c7             	mov    %rax,%rdi
  801c7a:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
  801c86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c8a:	48 89 d6             	mov    %rdx,%rsi
  801c8d:	89 c7                	mov    %eax,%edi
  801c8f:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
  801c9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ca2:	78 0a                	js     801cae <fd_close+0x4c>
	    || fd != fd2)
  801ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cac:	74 12                	je     801cc0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801cae:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cb2:	74 05                	je     801cb9 <fd_close+0x57>
  801cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb7:	eb 05                	jmp    801cbe <fd_close+0x5c>
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	eb 69                	jmp    801d29 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc4:	8b 00                	mov    (%rax),%eax
  801cc6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cca:	48 89 d6             	mov    %rdx,%rsi
  801ccd:	89 c7                	mov    %eax,%edi
  801ccf:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce2:	78 2a                	js     801d0e <fd_close+0xac>
		if (dev->dev_close)
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cec:	48 85 c0             	test   %rax,%rax
  801cef:	74 16                	je     801d07 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfd:	48 89 c7             	mov    %rax,%rdi
  801d00:	ff d2                	callq  *%rdx
  801d02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d05:	eb 07                	jmp    801d0e <fd_close+0xac>
		else
			r = 0;
  801d07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d12:	48 89 c6             	mov    %rax,%rsi
  801d15:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1a:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	callq  *%rax
	return r;
  801d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d29:	c9                   	leaveq 
  801d2a:	c3                   	retq   

0000000000801d2b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d2b:	55                   	push   %rbp
  801d2c:	48 89 e5             	mov    %rsp,%rbp
  801d2f:	48 83 ec 20          	sub    $0x20,%rsp
  801d33:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d41:	eb 41                	jmp    801d84 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d43:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d4a:	00 00 00 
  801d4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d50:	48 63 d2             	movslq %edx,%rdx
  801d53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d57:	8b 00                	mov    (%rax),%eax
  801d59:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d5c:	75 22                	jne    801d80 <dev_lookup+0x55>
			*dev = devtab[i];
  801d5e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d65:	00 00 00 
  801d68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d6b:	48 63 d2             	movslq %edx,%rdx
  801d6e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d76:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	eb 60                	jmp    801de0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d80:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d84:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d8b:	00 00 00 
  801d8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d91:	48 63 d2             	movslq %edx,%rdx
  801d94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d98:	48 85 c0             	test   %rax,%rax
  801d9b:	75 a6                	jne    801d43 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d9d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801da4:	00 00 00 
  801da7:	48 8b 00             	mov    (%rax),%rax
  801daa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801db0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801db3:	89 c6                	mov    %eax,%esi
  801db5:	48 bf 98 40 80 00 00 	movabs $0x804098,%rdi
  801dbc:	00 00 00 
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	48 b9 93 02 80 00 00 	movabs $0x800293,%rcx
  801dcb:	00 00 00 
  801dce:	ff d1                	callq  *%rcx
	*dev = 0;
  801dd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dd4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ddb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801de0:	c9                   	leaveq 
  801de1:	c3                   	retq   

0000000000801de2 <close>:

int
close(int fdnum)
{
  801de2:	55                   	push   %rbp
  801de3:	48 89 e5             	mov    %rsp,%rbp
  801de6:	48 83 ec 20          	sub    $0x20,%rsp
  801dea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ded:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801df1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801df4:	48 89 d6             	mov    %rdx,%rsi
  801df7:	89 c7                	mov    %eax,%edi
  801df9:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
  801e05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e0c:	79 05                	jns    801e13 <close+0x31>
		return r;
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	eb 18                	jmp    801e2b <close+0x49>
	else
		return fd_close(fd, 1);
  801e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e17:	be 01 00 00 00       	mov    $0x1,%esi
  801e1c:	48 89 c7             	mov    %rax,%rdi
  801e1f:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	callq  *%rax
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <close_all>:

void
close_all(void)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e3c:	eb 15                	jmp    801e53 <close_all+0x26>
		close(i);
  801e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e41:	89 c7                	mov    %eax,%edi
  801e43:	48 b8 e2 1d 80 00 00 	movabs $0x801de2,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e4f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e53:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e57:	7e e5                	jle    801e3e <close_all+0x11>
		close(i);
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 40          	sub    $0x40,%rsp
  801e63:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e66:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e69:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801e6d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e70:	48 89 d6             	mov    %rdx,%rsi
  801e73:	89 c7                	mov    %eax,%edi
  801e75:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
  801e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e88:	79 08                	jns    801e92 <dup+0x37>
		return r;
  801e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8d:	e9 70 01 00 00       	jmpq   802002 <dup+0x1a7>
	close(newfdnum);
  801e92:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e95:	89 c7                	mov    %eax,%edi
  801e97:	48 b8 e2 1d 80 00 00 	movabs $0x801de2,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ea3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ea6:	48 98                	cltq   
  801ea8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eae:	48 c1 e0 0c          	shl    $0xc,%rax
  801eb2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eba:	48 89 c7             	mov    %rax,%rdi
  801ebd:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  801ec4:	00 00 00 
  801ec7:	ff d0                	callq  *%rax
  801ec9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed1:	48 89 c7             	mov    %rax,%rdi
  801ed4:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  801edb:	00 00 00 
  801ede:	ff d0                	callq  *%rax
  801ee0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee8:	48 89 c2             	mov    %rax,%rdx
  801eeb:	48 c1 ea 15          	shr    $0x15,%rdx
  801eef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef6:	01 00 00 
  801ef9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efd:	83 e0 01             	and    $0x1,%eax
  801f00:	84 c0                	test   %al,%al
  801f02:	74 71                	je     801f75 <dup+0x11a>
  801f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f08:	48 89 c2             	mov    %rax,%rdx
  801f0b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f16:	01 00 00 
  801f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1d:	83 e0 01             	and    $0x1,%eax
  801f20:	84 c0                	test   %al,%al
  801f22:	74 51                	je     801f75 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f28:	48 89 c2             	mov    %rax,%rdx
  801f2b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f36:	01 00 00 
  801f39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3d:	89 c1                	mov    %eax,%ecx
  801f3f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801f45:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4d:	41 89 c8             	mov    %ecx,%r8d
  801f50:	48 89 d1             	mov    %rdx,%rcx
  801f53:	ba 00 00 00 00       	mov    $0x0,%edx
  801f58:	48 89 c6             	mov    %rax,%rsi
  801f5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f60:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	callq  *%rax
  801f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f73:	78 56                	js     801fcb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f79:	48 89 c2             	mov    %rax,%rdx
  801f7c:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f80:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f87:	01 00 00 
  801f8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f8e:	89 c1                	mov    %eax,%ecx
  801f90:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f9e:	41 89 c8             	mov    %ecx,%r8d
  801fa1:	48 89 d1             	mov    %rdx,%rcx
  801fa4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa9:	48 89 c6             	mov    %rax,%rsi
  801fac:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb1:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801fb8:	00 00 00 
  801fbb:	ff d0                	callq  *%rax
  801fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc4:	78 08                	js     801fce <dup+0x173>
		goto err;

	return newfdnum;
  801fc6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fc9:	eb 37                	jmp    802002 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  801fcb:	90                   	nop
  801fcc:	eb 01                	jmp    801fcf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  801fce:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd3:	48 89 c6             	mov    %rax,%rsi
  801fd6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdb:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801feb:	48 89 c6             	mov    %rax,%rsi
  801fee:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff3:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
	return r;
  801fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802002:	c9                   	leaveq 
  802003:	c3                   	retq   

0000000000802004 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
  802008:	48 83 ec 40          	sub    $0x40,%rsp
  80200c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80200f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802013:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802017:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80201b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80201e:	48 89 d6             	mov    %rdx,%rsi
  802021:	89 c7                	mov    %eax,%edi
  802023:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
  80202f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802032:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802036:	78 24                	js     80205c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203c:	8b 00                	mov    (%rax),%eax
  80203e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802042:	48 89 d6             	mov    %rdx,%rsi
  802045:	89 c7                	mov    %eax,%edi
  802047:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
  802053:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802056:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80205a:	79 05                	jns    802061 <read+0x5d>
		return r;
  80205c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205f:	eb 7a                	jmp    8020db <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802065:	8b 40 08             	mov    0x8(%rax),%eax
  802068:	83 e0 03             	and    $0x3,%eax
  80206b:	83 f8 01             	cmp    $0x1,%eax
  80206e:	75 3a                	jne    8020aa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802070:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802077:	00 00 00 
  80207a:	48 8b 00             	mov    (%rax),%rax
  80207d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802083:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802086:	89 c6                	mov    %eax,%esi
  802088:	48 bf b7 40 80 00 00 	movabs $0x8040b7,%rdi
  80208f:	00 00 00 
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	48 b9 93 02 80 00 00 	movabs $0x800293,%rcx
  80209e:	00 00 00 
  8020a1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020a8:	eb 31                	jmp    8020db <read+0xd7>
	}
	if (!dev->dev_read)
  8020aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020b2:	48 85 c0             	test   %rax,%rax
  8020b5:	75 07                	jne    8020be <read+0xba>
		return -E_NOT_SUPP;
  8020b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020bc:	eb 1d                	jmp    8020db <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8020be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8020c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8020d2:	48 89 ce             	mov    %rcx,%rsi
  8020d5:	48 89 c7             	mov    %rax,%rdi
  8020d8:	41 ff d0             	callq  *%r8
}
  8020db:	c9                   	leaveq 
  8020dc:	c3                   	retq   

00000000008020dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020dd:	55                   	push   %rbp
  8020de:	48 89 e5             	mov    %rsp,%rbp
  8020e1:	48 83 ec 30          	sub    $0x30,%rsp
  8020e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020f7:	eb 46                	jmp    80213f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020fc:	48 98                	cltq   
  8020fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802102:	48 29 c2             	sub    %rax,%rdx
  802105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802108:	48 98                	cltq   
  80210a:	48 89 c1             	mov    %rax,%rcx
  80210d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802111:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802114:	48 89 ce             	mov    %rcx,%rsi
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802128:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80212c:	79 05                	jns    802133 <readn+0x56>
			return m;
  80212e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802131:	eb 1d                	jmp    802150 <readn+0x73>
		if (m == 0)
  802133:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802137:	74 13                	je     80214c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80213c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80213f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802142:	48 98                	cltq   
  802144:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802148:	72 af                	jb     8020f9 <readn+0x1c>
  80214a:	eb 01                	jmp    80214d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80214c:	90                   	nop
	}
	return tot;
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802150:	c9                   	leaveq 
  802151:	c3                   	retq   

0000000000802152 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802152:	55                   	push   %rbp
  802153:	48 89 e5             	mov    %rsp,%rbp
  802156:	48 83 ec 40          	sub    $0x40,%rsp
  80215a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80215d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802161:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802165:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802169:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80216c:	48 89 d6             	mov    %rdx,%rsi
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  80217d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802184:	78 24                	js     8021aa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218a:	8b 00                	mov    (%rax),%eax
  80218c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802190:	48 89 d6             	mov    %rdx,%rsi
  802193:	89 c7                	mov    %eax,%edi
  802195:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	callq  *%rax
  8021a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a8:	79 05                	jns    8021af <write+0x5d>
		return r;
  8021aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ad:	eb 79                	jmp    802228 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b3:	8b 40 08             	mov    0x8(%rax),%eax
  8021b6:	83 e0 03             	and    $0x3,%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	75 3a                	jne    8021f7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021c4:	00 00 00 
  8021c7:	48 8b 00             	mov    (%rax),%rax
  8021ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021d3:	89 c6                	mov    %eax,%esi
  8021d5:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  8021dc:	00 00 00 
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	48 b9 93 02 80 00 00 	movabs $0x800293,%rcx
  8021eb:	00 00 00 
  8021ee:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f5:	eb 31                	jmp    802228 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021ff:	48 85 c0             	test   %rax,%rax
  802202:	75 07                	jne    80220b <write+0xb9>
		return -E_NOT_SUPP;
  802204:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802209:	eb 1d                	jmp    802228 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80220b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802217:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80221b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80221f:	48 89 ce             	mov    %rcx,%rsi
  802222:	48 89 c7             	mov    %rax,%rdi
  802225:	41 ff d0             	callq  *%r8
}
  802228:	c9                   	leaveq 
  802229:	c3                   	retq   

000000000080222a <seek>:

int
seek(int fdnum, off_t offset)
{
  80222a:	55                   	push   %rbp
  80222b:	48 89 e5             	mov    %rsp,%rbp
  80222e:	48 83 ec 18          	sub    $0x18,%rsp
  802232:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802235:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802238:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80223c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80223f:	48 89 d6             	mov    %rdx,%rsi
  802242:	89 c7                	mov    %eax,%edi
  802244:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
  802250:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802257:	79 05                	jns    80225e <seek+0x34>
		return r;
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225c:	eb 0f                	jmp    80226d <seek+0x43>
	fd->fd_offset = offset;
  80225e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802262:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802265:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
  802273:	48 83 ec 30          	sub    $0x30,%rsp
  802277:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80227d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802281:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802284:	48 89 d6             	mov    %rdx,%rsi
  802287:	89 c7                	mov    %eax,%edi
  802289:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802298:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229c:	78 24                	js     8022c2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80229e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a2:	8b 00                	mov    (%rax),%eax
  8022a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a8:	48 89 d6             	mov    %rdx,%rsi
  8022ab:	89 c7                	mov    %eax,%edi
  8022ad:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	callq  *%rax
  8022b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c0:	79 05                	jns    8022c7 <ftruncate+0x58>
		return r;
  8022c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c5:	eb 72                	jmp    802339 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cb:	8b 40 08             	mov    0x8(%rax),%eax
  8022ce:	83 e0 03             	and    $0x3,%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	75 3a                	jne    80230f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8022d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022dc:	00 00 00 
  8022df:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022eb:	89 c6                	mov    %eax,%esi
  8022ed:	48 bf f0 40 80 00 00 	movabs $0x8040f0,%rdi
  8022f4:	00 00 00 
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	48 b9 93 02 80 00 00 	movabs $0x800293,%rcx
  802303:	00 00 00 
  802306:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802308:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80230d:	eb 2a                	jmp    802339 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80230f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802313:	48 8b 40 30          	mov    0x30(%rax),%rax
  802317:	48 85 c0             	test   %rax,%rax
  80231a:	75 07                	jne    802323 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80231c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802321:	eb 16                	jmp    802339 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802327:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80232b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802332:	89 d6                	mov    %edx,%esi
  802334:	48 89 c7             	mov    %rax,%rdi
  802337:	ff d1                	callq  *%rcx
}
  802339:	c9                   	leaveq 
  80233a:	c3                   	retq   

000000000080233b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80233b:	55                   	push   %rbp
  80233c:	48 89 e5             	mov    %rsp,%rbp
  80233f:	48 83 ec 30          	sub    $0x30,%rsp
  802343:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802346:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80234a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80234e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802351:	48 89 d6             	mov    %rdx,%rsi
  802354:	89 c7                	mov    %eax,%edi
  802356:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80235d:	00 00 00 
  802360:	ff d0                	callq  *%rax
  802362:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802369:	78 24                	js     80238f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80236b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236f:	8b 00                	mov    (%rax),%eax
  802371:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802375:	48 89 d6             	mov    %rdx,%rsi
  802378:	89 c7                	mov    %eax,%edi
  80237a:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
  802386:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802389:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238d:	79 05                	jns    802394 <fstat+0x59>
		return r;
  80238f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802392:	eb 5e                	jmp    8023f2 <fstat+0xb7>
	if (!dev->dev_stat)
  802394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802398:	48 8b 40 28          	mov    0x28(%rax),%rax
  80239c:	48 85 c0             	test   %rax,%rax
  80239f:	75 07                	jne    8023a8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023a6:	eb 4a                	jmp    8023f2 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ac:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023b3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023ba:	00 00 00 
	stat->st_isdir = 0;
  8023bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023c1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023c8:	00 00 00 
	stat->st_dev = dev;
  8023cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023d3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8023da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023de:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8023e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8023ea:	48 89 d6             	mov    %rdx,%rsi
  8023ed:	48 89 c7             	mov    %rax,%rdi
  8023f0:	ff d1                	callq  *%rcx
}
  8023f2:	c9                   	leaveq 
  8023f3:	c3                   	retq   

00000000008023f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	48 83 ec 20          	sub    $0x20,%rsp
  8023fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802400:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802408:	be 00 00 00 00       	mov    $0x0,%esi
  80240d:	48 89 c7             	mov    %rax,%rdi
  802410:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802417:	00 00 00 
  80241a:	ff d0                	callq  *%rax
  80241c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802423:	79 05                	jns    80242a <stat+0x36>
		return fd;
  802425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802428:	eb 2f                	jmp    802459 <stat+0x65>
	r = fstat(fd, stat);
  80242a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80242e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802431:	48 89 d6             	mov    %rdx,%rsi
  802434:	89 c7                	mov    %eax,%edi
  802436:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax
  802442:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802448:	89 c7                	mov    %eax,%edi
  80244a:	48 b8 e2 1d 80 00 00 	movabs $0x801de2,%rax
  802451:	00 00 00 
  802454:	ff d0                	callq  *%rax
	return r;
  802456:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802459:	c9                   	leaveq 
  80245a:	c3                   	retq   
	...

000000000080245c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80245c:	55                   	push   %rbp
  80245d:	48 89 e5             	mov    %rsp,%rbp
  802460:	48 83 ec 10          	sub    $0x10,%rsp
  802464:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802467:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80246b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802472:	00 00 00 
  802475:	8b 00                	mov    (%rax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 1d                	jne    802498 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80247b:	bf 01 00 00 00       	mov    $0x1,%edi
  802480:	48 b8 46 3a 80 00 00 	movabs $0x803a46,%rax
  802487:	00 00 00 
  80248a:	ff d0                	callq  *%rax
  80248c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802493:	00 00 00 
  802496:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802498:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80249f:	00 00 00 
  8024a2:	8b 00                	mov    (%rax),%eax
  8024a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024ac:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024b3:	00 00 00 
  8024b6:	89 c7                	mov    %eax,%edi
  8024b8:	48 b8 97 39 80 00 00 	movabs $0x803997,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cd:	48 89 c6             	mov    %rax,%rsi
  8024d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d5:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  8024dc:	00 00 00 
  8024df:	ff d0                	callq  *%rax
}
  8024e1:	c9                   	leaveq 
  8024e2:	c3                   	retq   

00000000008024e3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8024e3:	55                   	push   %rbp
  8024e4:	48 89 e5             	mov    %rsp,%rbp
  8024e7:	48 83 ec 20          	sub    $0x20,%rsp
  8024eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8024f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f6:	48 89 c7             	mov    %rax,%rdi
  8024f9:	48 b8 f8 0d 80 00 00 	movabs $0x800df8,%rax
  802500:	00 00 00 
  802503:	ff d0                	callq  *%rax
  802505:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80250a:	7e 0a                	jle    802516 <open+0x33>
		return -E_BAD_PATH;
  80250c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802511:	e9 a5 00 00 00       	jmpq   8025bb <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802516:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80251a:	48 89 c7             	mov    %rax,%rdi
  80251d:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80252c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802530:	79 08                	jns    80253a <open+0x57>
		return r;
  802532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802535:	e9 81 00 00 00       	jmpq   8025bb <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80253a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802541:	00 00 00 
  802544:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802547:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80254d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802551:	48 89 c6             	mov    %rax,%rsi
  802554:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80255b:	00 00 00 
  80255e:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802565:	00 00 00 
  802568:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80256a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256e:	48 89 c6             	mov    %rax,%rsi
  802571:	bf 01 00 00 00       	mov    $0x1,%edi
  802576:	48 b8 5c 24 80 00 00 	movabs $0x80245c,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802589:	79 1d                	jns    8025a8 <open+0xc5>
		fd_close(new_fd, 0);
  80258b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258f:	be 00 00 00 00       	mov    $0x0,%esi
  802594:	48 89 c7             	mov    %rax,%rdi
  802597:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
		return r;	
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	eb 13                	jmp    8025bb <open+0xd8>
	}
	return fd2num(new_fd);
  8025a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ac:	48 89 c7             	mov    %rax,%rdi
  8025af:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	callq  *%rax
}
  8025bb:	c9                   	leaveq 
  8025bc:	c3                   	retq   

00000000008025bd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025bd:	55                   	push   %rbp
  8025be:	48 89 e5             	mov    %rsp,%rbp
  8025c1:	48 83 ec 10          	sub    $0x10,%rsp
  8025c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8025d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025d7:	00 00 00 
  8025da:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8025dc:	be 00 00 00 00       	mov    $0x0,%esi
  8025e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8025e6:	48 b8 5c 24 80 00 00 	movabs $0x80245c,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 30          	sub    $0x30,%rsp
  8025fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802600:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802604:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	8b 50 0c             	mov    0xc(%rax),%edx
  80260f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802616:	00 00 00 
  802619:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80261b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802622:	00 00 00 
  802625:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802629:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  80262d:	be 00 00 00 00       	mov    $0x0,%esi
  802632:	bf 03 00 00 00       	mov    $0x3,%edi
  802637:	48 b8 5c 24 80 00 00 	movabs $0x80245c,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
  802643:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802646:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264a:	7e 23                	jle    80266f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80264c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264f:	48 63 d0             	movslq %eax,%rdx
  802652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802656:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80265d:	00 00 00 
  802660:	48 89 c7             	mov    %rax,%rdi
  802663:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80266f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802672:	c9                   	leaveq 
  802673:	c3                   	retq   

0000000000802674 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802674:	55                   	push   %rbp
  802675:	48 89 e5             	mov    %rsp,%rbp
  802678:	48 83 ec 20          	sub    $0x20,%rsp
  80267c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802680:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802688:	8b 50 0c             	mov    0xc(%rax),%edx
  80268b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802692:	00 00 00 
  802695:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802697:	be 00 00 00 00       	mov    $0x0,%esi
  80269c:	bf 05 00 00 00       	mov    $0x5,%edi
  8026a1:	48 b8 5c 24 80 00 00 	movabs $0x80245c,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b4:	79 05                	jns    8026bb <devfile_stat+0x47>
		return r;
  8026b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b9:	eb 56                	jmp    802711 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8026bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026bf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8026c6:	00 00 00 
  8026c9:	48 89 c7             	mov    %rax,%rdi
  8026cc:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8026d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026df:	00 00 00 
  8026e2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8026e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ec:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8026f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026f9:	00 00 00 
  8026fc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802702:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802706:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   
	...

0000000000802714 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 20          	sub    $0x20,%rsp
  80271c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80271f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802723:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802726:	48 89 d6             	mov    %rdx,%rsi
  802729:	89 c7                	mov    %eax,%edi
  80272b:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802732:	00 00 00 
  802735:	ff d0                	callq  *%rax
  802737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273e:	79 05                	jns    802745 <fd2sockid+0x31>
		return r;
  802740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802743:	eb 24                	jmp    802769 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	8b 10                	mov    (%rax),%edx
  80274b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802752:	00 00 00 
  802755:	8b 00                	mov    (%rax),%eax
  802757:	39 c2                	cmp    %eax,%edx
  802759:	74 07                	je     802762 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80275b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802760:	eb 07                	jmp    802769 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802766:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802769:	c9                   	leaveq 
  80276a:	c3                   	retq   

000000000080276b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80276b:	55                   	push   %rbp
  80276c:	48 89 e5             	mov    %rsp,%rbp
  80276f:	48 83 ec 20          	sub    $0x20,%rsp
  802773:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802776:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80277a:	48 89 c7             	mov    %rax,%rdi
  80277d:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802790:	78 26                	js     8027b8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802796:	ba 07 04 00 00       	mov    $0x407,%edx
  80279b:	48 89 c6             	mov    %rax,%rsi
  80279e:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a3:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b6:	79 16                	jns    8027ce <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8027b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 78 2c 80 00 00 	movabs $0x802c78,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
		return r;
  8027c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cc:	eb 3a                	jmp    802808 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8027ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8027d9:	00 00 00 
  8027dc:	8b 12                	mov    (%rdx),%edx
  8027de:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8027e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8027eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027f2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8027f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f9:	48 89 c7             	mov    %rax,%rdi
  8027fc:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 30          	sub    $0x30,%rsp
  802812:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802815:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802819:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80281d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
  80282e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802831:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802835:	79 05                	jns    80283c <accept+0x32>
		return r;
  802837:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283a:	eb 3b                	jmp    802877 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80283c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802840:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802847:	48 89 ce             	mov    %rcx,%rsi
  80284a:	89 c7                	mov    %eax,%edi
  80284c:	48 b8 55 2b 80 00 00 	movabs $0x802b55,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax
  802858:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285f:	79 05                	jns    802866 <accept+0x5c>
		return r;
  802861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802864:	eb 11                	jmp    802877 <accept+0x6d>
	return alloc_sockfd(r);
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	89 c7                	mov    %eax,%edi
  80286b:	48 b8 6b 27 80 00 00 	movabs $0x80276b,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
}
  802877:	c9                   	leaveq 
  802878:	c3                   	retq   

0000000000802879 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 20          	sub    $0x20,%rsp
  802881:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802884:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802888:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80288b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80288e:	89 c7                	mov    %eax,%edi
  802890:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
  80289c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a3:	79 05                	jns    8028aa <bind+0x31>
		return r;
  8028a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a8:	eb 1b                	jmp    8028c5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8028aa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8028b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b4:	48 89 ce             	mov    %rcx,%rsi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
}
  8028c5:	c9                   	leaveq 
  8028c6:	c3                   	retq   

00000000008028c7 <shutdown>:

int
shutdown(int s, int how)
{
  8028c7:	55                   	push   %rbp
  8028c8:	48 89 e5             	mov    %rsp,%rbp
  8028cb:	48 83 ec 20          	sub    $0x20,%rsp
  8028cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8028d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d8:	89 c7                	mov    %eax,%edi
  8028da:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ed:	79 05                	jns    8028f4 <shutdown+0x2d>
		return r;
  8028ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f2:	eb 16                	jmp    80290a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8028f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fa:	89 d6                	mov    %edx,%esi
  8028fc:	89 c7                	mov    %eax,%edi
  8028fe:	48 b8 38 2c 80 00 00 	movabs $0x802c38,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax
}
  80290a:	c9                   	leaveq 
  80290b:	c3                   	retq   

000000000080290c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80290c:	55                   	push   %rbp
  80290d:	48 89 e5             	mov    %rsp,%rbp
  802910:	48 83 ec 10          	sub    $0x10,%rsp
  802914:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802918:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291c:	48 89 c7             	mov    %rax,%rdi
  80291f:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  802926:	00 00 00 
  802929:	ff d0                	callq  *%rax
  80292b:	83 f8 01             	cmp    $0x1,%eax
  80292e:	75 17                	jne    802947 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802934:	8b 40 0c             	mov    0xc(%rax),%eax
  802937:	89 c7                	mov    %eax,%edi
  802939:	48 b8 78 2c 80 00 00 	movabs $0x802c78,%rax
  802940:	00 00 00 
  802943:	ff d0                	callq  *%rax
  802945:	eb 05                	jmp    80294c <devsock_close+0x40>
	else
		return 0;
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294c:	c9                   	leaveq 
  80294d:	c3                   	retq   

000000000080294e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80294e:	55                   	push   %rbp
  80294f:	48 89 e5             	mov    %rsp,%rbp
  802952:	48 83 ec 20          	sub    $0x20,%rsp
  802956:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802959:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80295d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802960:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802963:	89 c7                	mov    %eax,%edi
  802965:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
  802971:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802974:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802978:	79 05                	jns    80297f <connect+0x31>
		return r;
  80297a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297d:	eb 1b                	jmp    80299a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80297f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802982:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	48 89 ce             	mov    %rcx,%rsi
  80298c:	89 c7                	mov    %eax,%edi
  80298e:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
}
  80299a:	c9                   	leaveq 
  80299b:	c3                   	retq   

000000000080299c <listen>:

int
listen(int s, int backlog)
{
  80299c:	55                   	push   %rbp
  80299d:	48 89 e5             	mov    %rsp,%rbp
  8029a0:	48 83 ec 20          	sub    $0x20,%rsp
  8029a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029a7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ad:	89 c7                	mov    %eax,%edi
  8029af:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	callq  *%rax
  8029bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c2:	79 05                	jns    8029c9 <listen+0x2d>
		return r;
  8029c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c7:	eb 16                	jmp    8029df <listen+0x43>
	return nsipc_listen(r, backlog);
  8029c9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	89 d6                	mov    %edx,%esi
  8029d1:	89 c7                	mov    %eax,%edi
  8029d3:	48 b8 09 2d 80 00 00 	movabs $0x802d09,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
}
  8029df:	c9                   	leaveq 
  8029e0:	c3                   	retq   

00000000008029e1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8029e1:	55                   	push   %rbp
  8029e2:	48 89 e5             	mov    %rsp,%rbp
  8029e5:	48 83 ec 20          	sub    $0x20,%rsp
  8029e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8029f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f9:	89 c2                	mov    %eax,%edx
  8029fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029ff:	8b 40 0c             	mov    0xc(%rax),%eax
  802a02:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a0b:	89 c7                	mov    %eax,%edi
  802a0d:	48 b8 49 2d 80 00 00 	movabs $0x802d49,%rax
  802a14:	00 00 00 
  802a17:	ff d0                	callq  *%rax
}
  802a19:	c9                   	leaveq 
  802a1a:	c3                   	retq   

0000000000802a1b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802a1b:	55                   	push   %rbp
  802a1c:	48 89 e5             	mov    %rsp,%rbp
  802a1f:	48 83 ec 20          	sub    $0x20,%rsp
  802a23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a2b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	89 c2                	mov    %eax,%edx
  802a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a39:	8b 40 0c             	mov    0xc(%rax),%eax
  802a3c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802a40:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a45:	89 c7                	mov    %eax,%edi
  802a47:	48 b8 15 2e 80 00 00 	movabs $0x802e15,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
}
  802a53:	c9                   	leaveq 
  802a54:	c3                   	retq   

0000000000802a55 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802a55:	55                   	push   %rbp
  802a56:	48 89 e5             	mov    %rsp,%rbp
  802a59:	48 83 ec 10          	sub    $0x10,%rsp
  802a5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a69:	48 be 1b 41 80 00 00 	movabs $0x80411b,%rsi
  802a70:	00 00 00 
  802a73:	48 89 c7             	mov    %rax,%rdi
  802a76:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
	return 0;
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a87:	c9                   	leaveq 
  802a88:	c3                   	retq   

0000000000802a89 <socket>:

int
socket(int domain, int type, int protocol)
{
  802a89:	55                   	push   %rbp
  802a8a:	48 89 e5             	mov    %rsp,%rbp
  802a8d:	48 83 ec 20          	sub    $0x20,%rsp
  802a91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a94:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802a97:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a9a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a9d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802aa0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aa3:	89 ce                	mov    %ecx,%esi
  802aa5:	89 c7                	mov    %eax,%edi
  802aa7:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
  802ab3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aba:	79 05                	jns    802ac1 <socket+0x38>
		return r;
  802abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abf:	eb 11                	jmp    802ad2 <socket+0x49>
	return alloc_sockfd(r);
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 6b 27 80 00 00 	movabs $0x80276b,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
}
  802ad2:	c9                   	leaveq 
  802ad3:	c3                   	retq   

0000000000802ad4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802ad4:	55                   	push   %rbp
  802ad5:	48 89 e5             	mov    %rsp,%rbp
  802ad8:	48 83 ec 10          	sub    $0x10,%rsp
  802adc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802adf:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ae6:	00 00 00 
  802ae9:	8b 00                	mov    (%rax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	75 1d                	jne    802b0c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802aef:	bf 02 00 00 00       	mov    $0x2,%edi
  802af4:	48 b8 46 3a 80 00 00 	movabs $0x803a46,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
  802b00:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802b07:	00 00 00 
  802b0a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802b0c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802b13:	00 00 00 
  802b16:	8b 00                	mov    (%rax),%eax
  802b18:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b1b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b20:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802b27:	00 00 00 
  802b2a:	89 c7                	mov    %eax,%edi
  802b2c:	48 b8 97 39 80 00 00 	movabs $0x803997,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802b38:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3d:	be 00 00 00 00       	mov    $0x0,%esi
  802b42:	bf 00 00 00 00       	mov    $0x0,%edi
  802b47:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
}
  802b53:	c9                   	leaveq 
  802b54:	c3                   	retq   

0000000000802b55 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b55:	55                   	push   %rbp
  802b56:	48 89 e5             	mov    %rsp,%rbp
  802b59:	48 83 ec 30          	sub    $0x30,%rsp
  802b5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802b68:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b6f:	00 00 00 
  802b72:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b75:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802b77:	bf 01 00 00 00       	mov    $0x1,%edi
  802b7c:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8f:	78 3e                	js     802bcf <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802b91:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b98:	00 00 00 
  802b9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802b9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba3:	8b 40 10             	mov    0x10(%rax),%eax
  802ba6:	89 c2                	mov    %eax,%edx
  802ba8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb0:	48 89 ce             	mov    %rcx,%rsi
  802bb3:	48 89 c7             	mov    %rax,%rdi
  802bb6:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc6:	8b 50 10             	mov    0x10(%rax),%edx
  802bc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bcd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd2:	c9                   	leaveq 
  802bd3:	c3                   	retq   

0000000000802bd4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 10          	sub    $0x10,%rsp
  802bdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802be3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802be6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802bed:	00 00 00 
  802bf0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802bf3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802bf5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfc:	48 89 c6             	mov    %rax,%rsi
  802bff:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802c06:	00 00 00 
  802c09:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802c15:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c1c:	00 00 00 
  802c1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802c22:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802c25:	bf 02 00 00 00       	mov    $0x2,%edi
  802c2a:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 10          	sub    $0x10,%rsp
  802c40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c43:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802c46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c4d:	00 00 00 
  802c50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c53:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802c55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c5c:	00 00 00 
  802c5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802c62:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802c65:	bf 03 00 00 00       	mov    $0x3,%edi
  802c6a:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802c71:	00 00 00 
  802c74:	ff d0                	callq  *%rax
}
  802c76:	c9                   	leaveq 
  802c77:	c3                   	retq   

0000000000802c78 <nsipc_close>:

int
nsipc_close(int s)
{
  802c78:	55                   	push   %rbp
  802c79:	48 89 e5             	mov    %rsp,%rbp
  802c7c:	48 83 ec 10          	sub    $0x10,%rsp
  802c80:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802c83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c8a:	00 00 00 
  802c8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c90:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802c92:	bf 04 00 00 00       	mov    $0x4,%edi
  802c97:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
}
  802ca3:	c9                   	leaveq 
  802ca4:	c3                   	retq   

0000000000802ca5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ca5:	55                   	push   %rbp
  802ca6:	48 89 e5             	mov    %rsp,%rbp
  802ca9:	48 83 ec 10          	sub    $0x10,%rsp
  802cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802cb4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802cb7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cbe:	00 00 00 
  802cc1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cc4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802cc6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccd:	48 89 c6             	mov    %rax,%rsi
  802cd0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802cd7:	00 00 00 
  802cda:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802ce6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ced:	00 00 00 
  802cf0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802cf3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802cf6:	bf 05 00 00 00       	mov    $0x5,%edi
  802cfb:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
}
  802d07:	c9                   	leaveq 
  802d08:	c3                   	retq   

0000000000802d09 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802d09:	55                   	push   %rbp
  802d0a:	48 89 e5             	mov    %rsp,%rbp
  802d0d:	48 83 ec 10          	sub    $0x10,%rsp
  802d11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d14:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802d17:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d1e:	00 00 00 
  802d21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d24:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802d26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d2d:	00 00 00 
  802d30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802d36:	bf 06 00 00 00       	mov    $0x6,%edi
  802d3b:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
}
  802d47:	c9                   	leaveq 
  802d48:	c3                   	retq   

0000000000802d49 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802d49:	55                   	push   %rbp
  802d4a:	48 89 e5             	mov    %rsp,%rbp
  802d4d:	48 83 ec 30          	sub    $0x30,%rsp
  802d51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d58:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802d5b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802d5e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d65:	00 00 00 
  802d68:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d6b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802d6d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d74:	00 00 00 
  802d77:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d7a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802d7d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d84:	00 00 00 
  802d87:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d8a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802d8d:	bf 07 00 00 00       	mov    $0x7,%edi
  802d92:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da5:	78 69                	js     802e10 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802da7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802dae:	7f 08                	jg     802db8 <nsipc_recv+0x6f>
  802db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802db6:	7e 35                	jle    802ded <nsipc_recv+0xa4>
  802db8:	48 b9 22 41 80 00 00 	movabs $0x804122,%rcx
  802dbf:	00 00 00 
  802dc2:	48 ba 37 41 80 00 00 	movabs $0x804137,%rdx
  802dc9:	00 00 00 
  802dcc:	be 61 00 00 00       	mov    $0x61,%esi
  802dd1:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  802dd8:	00 00 00 
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  802de0:	49 b8 9c 37 80 00 00 	movabs $0x80379c,%r8
  802de7:	00 00 00 
  802dea:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df0:	48 63 d0             	movslq %eax,%rdx
  802df3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802dfe:	00 00 00 
  802e01:	48 89 c7             	mov    %rax,%rdi
  802e04:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
	}

	return r;
  802e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e13:	c9                   	leaveq 
  802e14:	c3                   	retq   

0000000000802e15 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802e15:	55                   	push   %rbp
  802e16:	48 89 e5             	mov    %rsp,%rbp
  802e19:	48 83 ec 20          	sub    $0x20,%rsp
  802e1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e24:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802e27:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  802e2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e31:	00 00 00 
  802e34:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e37:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  802e39:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802e40:	7e 35                	jle    802e77 <nsipc_send+0x62>
  802e42:	48 b9 58 41 80 00 00 	movabs $0x804158,%rcx
  802e49:	00 00 00 
  802e4c:	48 ba 37 41 80 00 00 	movabs $0x804137,%rdx
  802e53:	00 00 00 
  802e56:	be 6c 00 00 00       	mov    $0x6c,%esi
  802e5b:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  802e62:	00 00 00 
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6a:	49 b8 9c 37 80 00 00 	movabs $0x80379c,%r8
  802e71:	00 00 00 
  802e74:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802e77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e7a:	48 63 d0             	movslq %eax,%rdx
  802e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e81:	48 89 c6             	mov    %rax,%rsi
  802e84:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  802e8b:	00 00 00 
  802e8e:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  802e9a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ea1:	00 00 00 
  802ea4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  802eaa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eb1:	00 00 00 
  802eb4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eb7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  802eba:	bf 08 00 00 00       	mov    $0x8,%edi
  802ebf:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 10          	sub    $0x10,%rsp
  802ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ed8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802edb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  802ede:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ee5:	00 00 00 
  802ee8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802eeb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  802eed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ef4:	00 00 00 
  802ef7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  802efd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f04:	00 00 00 
  802f07:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f0a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  802f0d:	bf 09 00 00 00       	mov    $0x9,%edi
  802f12:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
}
  802f1e:	c9                   	leaveq 
  802f1f:	c3                   	retq   

0000000000802f20 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	53                   	push   %rbx
  802f25:	48 83 ec 38          	sub    $0x38,%rsp
  802f29:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f2d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f31:	48 89 c7             	mov    %rax,%rdi
  802f34:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802f3b:	00 00 00 
  802f3e:	ff d0                	callq  *%rax
  802f40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f47:	0f 88 bf 01 00 00    	js     80310c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f51:	ba 07 04 00 00       	mov    $0x407,%edx
  802f56:	48 89 c6             	mov    %rax,%rsi
  802f59:	bf 00 00 00 00       	mov    $0x0,%edi
  802f5e:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
  802f6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f71:	0f 88 95 01 00 00    	js     80310c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f77:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f7b:	48 89 c7             	mov    %rax,%rdi
  802f7e:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  802f85:	00 00 00 
  802f88:	ff d0                	callq  *%rax
  802f8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f91:	0f 88 5d 01 00 00    	js     8030f4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9b:	ba 07 04 00 00       	mov    $0x407,%edx
  802fa0:	48 89 c6             	mov    %rax,%rsi
  802fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa8:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fbb:	0f 88 33 01 00 00    	js     8030f4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc5:	48 89 c7             	mov    %rax,%rdi
  802fc8:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
  802fd4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdc:	ba 07 04 00 00       	mov    $0x407,%edx
  802fe1:	48 89 c6             	mov    %rax,%rsi
  802fe4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe9:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
  802ff5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ff8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ffc:	0f 88 d9 00 00 00    	js     8030db <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803002:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803006:	48 89 c7             	mov    %rax,%rdi
  803009:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
  803015:	48 89 c2             	mov    %rax,%rdx
  803018:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803022:	48 89 d1             	mov    %rdx,%rcx
  803025:	ba 00 00 00 00       	mov    $0x0,%edx
  80302a:	48 89 c6             	mov    %rax,%rsi
  80302d:	bf 00 00 00 00       	mov    $0x0,%edi
  803032:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
  80303e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803041:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803045:	78 79                	js     8030c0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803052:	00 00 00 
  803055:	8b 12                	mov    (%rdx),%edx
  803057:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803059:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803064:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803068:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80306f:	00 00 00 
  803072:	8b 12                	mov    (%rdx),%edx
  803074:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803076:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
  803094:	89 c2                	mov    %eax,%edx
  803096:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80309a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80309c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030a0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a8:	48 89 c7             	mov    %rax,%rdi
  8030ab:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	callq  *%rax
  8030b7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030be:	eb 4f                	jmp    80310f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8030c0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8030c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c5:	48 89 c6             	mov    %rax,%rsi
  8030c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030cd:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
  8030d9:	eb 01                	jmp    8030dc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8030db:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8030dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e0:	48 89 c6             	mov    %rax,%rsi
  8030e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e8:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8030f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f8:	48 89 c6             	mov    %rax,%rsi
  8030fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803100:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
err:
	return r;
  80310c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80310f:	48 83 c4 38          	add    $0x38,%rsp
  803113:	5b                   	pop    %rbx
  803114:	5d                   	pop    %rbp
  803115:	c3                   	retq   

0000000000803116 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	53                   	push   %rbx
  80311b:	48 83 ec 28          	sub    $0x28,%rsp
  80311f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803123:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803127:	eb 01                	jmp    80312a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803129:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80312a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803131:	00 00 00 
  803134:	48 8b 00             	mov    (%rax),%rax
  803137:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80313d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803144:	48 89 c7             	mov    %rax,%rdi
  803147:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
  803153:	89 c3                	mov    %eax,%ebx
  803155:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803159:	48 89 c7             	mov    %rax,%rdi
  80315c:	48 b8 d4 3a 80 00 00 	movabs $0x803ad4,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
  803168:	39 c3                	cmp    %eax,%ebx
  80316a:	0f 94 c0             	sete   %al
  80316d:	0f b6 c0             	movzbl %al,%eax
  803170:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803173:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80317a:	00 00 00 
  80317d:	48 8b 00             	mov    (%rax),%rax
  803180:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803186:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803189:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80318f:	75 0a                	jne    80319b <_pipeisclosed+0x85>
			return ret;
  803191:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803194:	48 83 c4 28          	add    $0x28,%rsp
  803198:	5b                   	pop    %rbx
  803199:	5d                   	pop    %rbp
  80319a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80319b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80319e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031a1:	74 86                	je     803129 <_pipeisclosed+0x13>
  8031a3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031a7:	75 80                	jne    803129 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031b0:	00 00 00 
  8031b3:	48 8b 00             	mov    (%rax),%rax
  8031b6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031bc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c2:	89 c6                	mov    %eax,%esi
  8031c4:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  8031cb:	00 00 00 
  8031ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d3:	49 b8 93 02 80 00 00 	movabs $0x800293,%r8
  8031da:	00 00 00 
  8031dd:	41 ff d0             	callq  *%r8
	}
  8031e0:	e9 44 ff ff ff       	jmpq   803129 <_pipeisclosed+0x13>

00000000008031e5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8031e5:	55                   	push   %rbp
  8031e6:	48 89 e5             	mov    %rsp,%rbp
  8031e9:	48 83 ec 30          	sub    $0x30,%rsp
  8031ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031f7:	48 89 d6             	mov    %rdx,%rsi
  8031fa:	89 c7                	mov    %eax,%edi
  8031fc:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80320b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320f:	79 05                	jns    803216 <pipeisclosed+0x31>
		return r;
  803211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803214:	eb 31                	jmp    803247 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321a:	48 89 c7             	mov    %rax,%rdi
  80321d:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80322d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803231:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803235:	48 89 d6             	mov    %rdx,%rsi
  803238:	48 89 c7             	mov    %rax,%rdi
  80323b:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
}
  803247:	c9                   	leaveq 
  803248:	c3                   	retq   

0000000000803249 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803249:	55                   	push   %rbp
  80324a:	48 89 e5             	mov    %rsp,%rbp
  80324d:	48 83 ec 40          	sub    $0x40,%rsp
  803251:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803255:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803259:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80325d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803261:	48 89 c7             	mov    %rax,%rdi
  803264:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803274:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803278:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80327c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803283:	00 
  803284:	e9 97 00 00 00       	jmpq   803320 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803289:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80328e:	74 09                	je     803299 <devpipe_read+0x50>
				return i;
  803290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803294:	e9 95 00 00 00       	jmpq   80332e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803299:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80329d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a1:	48 89 d6             	mov    %rdx,%rsi
  8032a4:	48 89 c7             	mov    %rax,%rdi
  8032a7:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 07                	je     8032be <devpipe_read+0x75>
				return 0;
  8032b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bc:	eb 70                	jmp    80332e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032be:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	eb 01                	jmp    8032cd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032cc:	90                   	nop
  8032cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d1:	8b 10                	mov    (%rax),%edx
  8032d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d7:	8b 40 04             	mov    0x4(%rax),%eax
  8032da:	39 c2                	cmp    %eax,%edx
  8032dc:	74 ab                	je     803289 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ee:	8b 00                	mov    (%rax),%eax
  8032f0:	89 c2                	mov    %eax,%edx
  8032f2:	c1 fa 1f             	sar    $0x1f,%edx
  8032f5:	c1 ea 1b             	shr    $0x1b,%edx
  8032f8:	01 d0                	add    %edx,%eax
  8032fa:	83 e0 1f             	and    $0x1f,%eax
  8032fd:	29 d0                	sub    %edx,%eax
  8032ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803303:	48 98                	cltq   
  803305:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80330a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80330c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803310:	8b 00                	mov    (%rax),%eax
  803312:	8d 50 01             	lea    0x1(%rax),%edx
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80331b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803324:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803328:	72 a2                	jb     8032cc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80332a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80332e:	c9                   	leaveq 
  80332f:	c3                   	retq   

0000000000803330 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803330:	55                   	push   %rbp
  803331:	48 89 e5             	mov    %rsp,%rbp
  803334:	48 83 ec 40          	sub    $0x40,%rsp
  803338:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80333c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803340:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80335b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803363:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80336a:	00 
  80336b:	e9 93 00 00 00       	jmpq   803403 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803370:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803378:	48 89 d6             	mov    %rdx,%rsi
  80337b:	48 89 c7             	mov    %rax,%rdi
  80337e:	48 b8 16 31 80 00 00 	movabs $0x803116,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 07                	je     803395 <devpipe_write+0x65>
				return 0;
  80338e:	b8 00 00 00 00       	mov    $0x0,%eax
  803393:	eb 7c                	jmp    803411 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803395:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
  8033a1:	eb 01                	jmp    8033a4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033a3:	90                   	nop
  8033a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a8:	8b 40 04             	mov    0x4(%rax),%eax
  8033ab:	48 63 d0             	movslq %eax,%rdx
  8033ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b2:	8b 00                	mov    (%rax),%eax
  8033b4:	48 98                	cltq   
  8033b6:	48 83 c0 20          	add    $0x20,%rax
  8033ba:	48 39 c2             	cmp    %rax,%rdx
  8033bd:	73 b1                	jae    803370 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c3:	8b 40 04             	mov    0x4(%rax),%eax
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	c1 fa 1f             	sar    $0x1f,%edx
  8033cb:	c1 ea 1b             	shr    $0x1b,%edx
  8033ce:	01 d0                	add    %edx,%eax
  8033d0:	83 e0 1f             	and    $0x1f,%eax
  8033d3:	29 d0                	sub    %edx,%eax
  8033d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033dd:	48 01 ca             	add    %rcx,%rdx
  8033e0:	0f b6 0a             	movzbl (%rdx),%ecx
  8033e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033e7:	48 98                	cltq   
  8033e9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	8b 40 04             	mov    0x4(%rax),%eax
  8033f4:	8d 50 01             	lea    0x1(%rax),%edx
  8033f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803407:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80340b:	72 96                	jb     8033a3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80340d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803411:	c9                   	leaveq 
  803412:	c3                   	retq   

0000000000803413 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803413:	55                   	push   %rbp
  803414:	48 89 e5             	mov    %rsp,%rbp
  803417:	48 83 ec 20          	sub    $0x20,%rsp
  80341b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80341f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803427:	48 89 c7             	mov    %rax,%rdi
  80342a:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
  803436:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80343a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343e:	48 be 7c 41 80 00 00 	movabs $0x80417c,%rsi
  803445:	00 00 00 
  803448:	48 89 c7             	mov    %rax,%rdi
  80344b:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80345b:	8b 50 04             	mov    0x4(%rax),%edx
  80345e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803462:	8b 00                	mov    (%rax),%eax
  803464:	29 c2                	sub    %eax,%edx
  803466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803470:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803474:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80347b:	00 00 00 
	stat->st_dev = &devpipe;
  80347e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803482:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803489:	00 00 00 
  80348c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803498:	c9                   	leaveq 
  803499:	c3                   	retq   

000000000080349a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80349a:	55                   	push   %rbp
  80349b:	48 89 e5             	mov    %rsp,%rbp
  80349e:	48 83 ec 10          	sub    $0x10,%rsp
  8034a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034aa:	48 89 c6             	mov    %rax,%rsi
  8034ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8034b2:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c2:	48 89 c7             	mov    %rax,%rdi
  8034c5:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
  8034d1:	48 89 c6             	mov    %rax,%rsi
  8034d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d9:	48 b8 47 18 80 00 00 	movabs $0x801847,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   
	...

00000000008034e8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034e8:	55                   	push   %rbp
  8034e9:	48 89 e5             	mov    %rsp,%rbp
  8034ec:	48 83 ec 20          	sub    $0x20,%rsp
  8034f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034f9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034fd:	be 01 00 00 00       	mov    $0x1,%esi
  803502:	48 89 c7             	mov    %rax,%rdi
  803505:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <getchar>:

int
getchar(void)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80351b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80351f:	ba 01 00 00 00       	mov    $0x1,%edx
  803524:	48 89 c6             	mov    %rax,%rsi
  803527:	bf 00 00 00 00       	mov    $0x0,%edi
  80352c:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80353b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353f:	79 05                	jns    803546 <getchar+0x33>
		return r;
  803541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803544:	eb 14                	jmp    80355a <getchar+0x47>
	if (r < 1)
  803546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354a:	7f 07                	jg     803553 <getchar+0x40>
		return -E_EOF;
  80354c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803551:	eb 07                	jmp    80355a <getchar+0x47>
	return c;
  803553:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803557:	0f b6 c0             	movzbl %al,%eax
}
  80355a:	c9                   	leaveq 
  80355b:	c3                   	retq   

000000000080355c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80355c:	55                   	push   %rbp
  80355d:	48 89 e5             	mov    %rsp,%rbp
  803560:	48 83 ec 20          	sub    $0x20,%rsp
  803564:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803567:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80356b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80356e:	48 89 d6             	mov    %rdx,%rsi
  803571:	89 c7                	mov    %eax,%edi
  803573:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
  80357f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803586:	79 05                	jns    80358d <iscons+0x31>
		return r;
  803588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358b:	eb 1a                	jmp    8035a7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80358d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803591:	8b 10                	mov    (%rax),%edx
  803593:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80359a:	00 00 00 
  80359d:	8b 00                	mov    (%rax),%eax
  80359f:	39 c2                	cmp    %eax,%edx
  8035a1:	0f 94 c0             	sete   %al
  8035a4:	0f b6 c0             	movzbl %al,%eax
}
  8035a7:	c9                   	leaveq 
  8035a8:	c3                   	retq   

00000000008035a9 <opencons>:

int
opencons(void)
{
  8035a9:	55                   	push   %rbp
  8035aa:	48 89 e5             	mov    %rsp,%rbp
  8035ad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035b1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035b5:	48 89 c7             	mov    %rax,%rdi
  8035b8:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
  8035c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cb:	79 05                	jns    8035d2 <opencons+0x29>
		return r;
  8035cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d0:	eb 5b                	jmp    80362d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8035db:	48 89 c6             	mov    %rax,%rsi
  8035de:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e3:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
  8035ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f6:	79 05                	jns    8035fd <opencons+0x54>
		return r;
  8035f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fb:	eb 30                	jmp    80362d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803601:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803608:	00 00 00 
  80360b:	8b 12                	mov    (%rdx),%edx
  80360d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80360f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803613:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80361a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361e:	48 89 c7             	mov    %rax,%rdi
  803621:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
}
  80362d:	c9                   	leaveq 
  80362e:	c3                   	retq   

000000000080362f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80362f:	55                   	push   %rbp
  803630:	48 89 e5             	mov    %rsp,%rbp
  803633:	48 83 ec 30          	sub    $0x30,%rsp
  803637:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80363b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80363f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803643:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803648:	75 13                	jne    80365d <devcons_read+0x2e>
		return 0;
  80364a:	b8 00 00 00 00       	mov    $0x0,%eax
  80364f:	eb 49                	jmp    80369a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803651:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80365d:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803670:	74 df                	je     803651 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803676:	79 05                	jns    80367d <devcons_read+0x4e>
		return c;
  803678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367b:	eb 1d                	jmp    80369a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80367d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803681:	75 07                	jne    80368a <devcons_read+0x5b>
		return 0;
  803683:	b8 00 00 00 00       	mov    $0x0,%eax
  803688:	eb 10                	jmp    80369a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80368a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368d:	89 c2                	mov    %eax,%edx
  80368f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803693:	88 10                	mov    %dl,(%rax)
	return 1;
  803695:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80369a:	c9                   	leaveq 
  80369b:	c3                   	retq   

000000000080369c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80369c:	55                   	push   %rbp
  80369d:	48 89 e5             	mov    %rsp,%rbp
  8036a0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036a7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036ae:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036b5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036c3:	eb 77                	jmp    80373c <devcons_write+0xa0>
		m = n - tot;
  8036c5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036cc:	89 c2                	mov    %eax,%edx
  8036ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d1:	89 d1                	mov    %edx,%ecx
  8036d3:	29 c1                	sub    %eax,%ecx
  8036d5:	89 c8                	mov    %ecx,%eax
  8036d7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036dd:	83 f8 7f             	cmp    $0x7f,%eax
  8036e0:	76 07                	jbe    8036e9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8036e2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ec:	48 63 d0             	movslq %eax,%rdx
  8036ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f2:	48 98                	cltq   
  8036f4:	48 89 c1             	mov    %rax,%rcx
  8036f7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8036fe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803705:	48 89 ce             	mov    %rcx,%rsi
  803708:	48 89 c7             	mov    %rax,%rdi
  80370b:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803717:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80371a:	48 63 d0             	movslq %eax,%rdx
  80371d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803724:	48 89 d6             	mov    %rdx,%rsi
  803727:	48 89 c7             	mov    %rax,%rdi
  80372a:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803736:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803739:	01 45 fc             	add    %eax,-0x4(%rbp)
  80373c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373f:	48 98                	cltq   
  803741:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803748:	0f 82 77 ff ff ff    	jb     8036c5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80374e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803751:	c9                   	leaveq 
  803752:	c3                   	retq   

0000000000803753 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 08          	sub    $0x8,%rsp
  80375b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80375f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803764:	c9                   	leaveq 
  803765:	c3                   	retq   

0000000000803766 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	48 83 ec 10          	sub    $0x10,%rsp
  80376e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803772:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80377a:	48 be 88 41 80 00 00 	movabs $0x804188,%rsi
  803781:	00 00 00 
  803784:	48 89 c7             	mov    %rax,%rdi
  803787:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
	return 0;
  803793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803798:	c9                   	leaveq 
  803799:	c3                   	retq   
	...

000000000080379c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80379c:	55                   	push   %rbp
  80379d:	48 89 e5             	mov    %rsp,%rbp
  8037a0:	53                   	push   %rbx
  8037a1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037a8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8037af:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8037b5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037bc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037c3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037ca:	84 c0                	test   %al,%al
  8037cc:	74 23                	je     8037f1 <_panic+0x55>
  8037ce:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037d5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037d9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037dd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037e1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037e5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037e9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037ed:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037f1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037f8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8037ff:	00 00 00 
  803802:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803809:	00 00 00 
  80380c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803810:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803817:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80381e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803825:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80382c:	00 00 00 
  80382f:	48 8b 18             	mov    (%rax),%rbx
  803832:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803844:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80384b:	41 89 c8             	mov    %ecx,%r8d
  80384e:	48 89 d1             	mov    %rdx,%rcx
  803851:	48 89 da             	mov    %rbx,%rdx
  803854:	89 c6                	mov    %eax,%esi
  803856:	48 bf 90 41 80 00 00 	movabs $0x804190,%rdi
  80385d:	00 00 00 
  803860:	b8 00 00 00 00       	mov    $0x0,%eax
  803865:	49 b9 93 02 80 00 00 	movabs $0x800293,%r9
  80386c:	00 00 00 
  80386f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803872:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803879:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803880:	48 89 d6             	mov    %rdx,%rsi
  803883:	48 89 c7             	mov    %rax,%rdi
  803886:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  80388d:	00 00 00 
  803890:	ff d0                	callq  *%rax
	cprintf("\n");
  803892:	48 bf b3 41 80 00 00 	movabs $0x8041b3,%rdi
  803899:	00 00 00 
  80389c:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a1:	48 ba 93 02 80 00 00 	movabs $0x800293,%rdx
  8038a8:	00 00 00 
  8038ab:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8038ad:	cc                   	int3   
  8038ae:	eb fd                	jmp    8038ad <_panic+0x111>

00000000008038b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 30          	sub    $0x30,%rsp
  8038b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8038c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8038cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038d0:	74 18                	je     8038ea <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8038d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
  8038e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e8:	eb 19                	jmp    803903 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8038ea:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8038f1:	00 00 00 
  8038f4:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  8038fb:	00 00 00 
  8038fe:	ff d0                	callq  *%rax
  803900:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803907:	79 39                	jns    803942 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803909:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80390e:	75 08                	jne    803918 <ipc_recv+0x68>
  803910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803914:	8b 00                	mov    (%rax),%eax
  803916:	eb 05                	jmp    80391d <ipc_recv+0x6d>
  803918:	b8 00 00 00 00       	mov    $0x0,%eax
  80391d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803921:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803923:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803928:	75 08                	jne    803932 <ipc_recv+0x82>
  80392a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392e:	8b 00                	mov    (%rax),%eax
  803930:	eb 05                	jmp    803937 <ipc_recv+0x87>
  803932:	b8 00 00 00 00       	mov    $0x0,%eax
  803937:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80393b:	89 02                	mov    %eax,(%rdx)
		return r;
  80393d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803940:	eb 53                	jmp    803995 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803942:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803947:	74 19                	je     803962 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803949:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803950:	00 00 00 
  803953:	48 8b 00             	mov    (%rax),%rax
  803956:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80395c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803960:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803962:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803967:	74 19                	je     803982 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803969:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803970:	00 00 00 
  803973:	48 8b 00             	mov    (%rax),%rax
  803976:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80397c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803980:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803982:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803989:	00 00 00 
  80398c:	48 8b 00             	mov    (%rax),%rax
  80398f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803995:	c9                   	leaveq 
  803996:	c3                   	retq   

0000000000803997 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803997:	55                   	push   %rbp
  803998:	48 89 e5             	mov    %rsp,%rbp
  80399b:	48 83 ec 30          	sub    $0x30,%rsp
  80399f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039a5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8039a9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8039ac:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8039b3:	eb 59                	jmp    803a0e <ipc_send+0x77>
		if(pg) {
  8039b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039ba:	74 20                	je     8039dc <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8039bc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039bf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8039c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8039c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c9:	89 c7                	mov    %eax,%edi
  8039cb:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039da:	eb 26                	jmp    803a02 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8039dc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e5:	89 d1                	mov    %edx,%ecx
  8039e7:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8039ee:	00 00 00 
  8039f1:	89 c7                	mov    %eax,%edi
  8039f3:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
  8039ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803a02:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  803a09:	00 00 00 
  803a0c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803a0e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a12:	74 a1                	je     8039b5 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803a14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a18:	74 2a                	je     803a44 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803a1a:	48 ba b8 41 80 00 00 	movabs $0x8041b8,%rdx
  803a21:	00 00 00 
  803a24:	be 49 00 00 00       	mov    $0x49,%esi
  803a29:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  803a30:	00 00 00 
  803a33:	b8 00 00 00 00       	mov    $0x0,%eax
  803a38:	48 b9 9c 37 80 00 00 	movabs $0x80379c,%rcx
  803a3f:	00 00 00 
  803a42:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803a44:	c9                   	leaveq 
  803a45:	c3                   	retq   

0000000000803a46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a46:	55                   	push   %rbp
  803a47:	48 89 e5             	mov    %rsp,%rbp
  803a4a:	48 83 ec 18          	sub    $0x18,%rsp
  803a4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a58:	eb 6a                	jmp    803ac4 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803a5a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a61:	00 00 00 
  803a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a67:	48 63 d0             	movslq %eax,%rdx
  803a6a:	48 89 d0             	mov    %rdx,%rax
  803a6d:	48 c1 e0 02          	shl    $0x2,%rax
  803a71:	48 01 d0             	add    %rdx,%rax
  803a74:	48 01 c0             	add    %rax,%rax
  803a77:	48 01 d0             	add    %rdx,%rax
  803a7a:	48 c1 e0 05          	shl    $0x5,%rax
  803a7e:	48 01 c8             	add    %rcx,%rax
  803a81:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803a87:	8b 00                	mov    (%rax),%eax
  803a89:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a8c:	75 32                	jne    803ac0 <ipc_find_env+0x7a>
			return envs[i].env_id;
  803a8e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a95:	00 00 00 
  803a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9b:	48 63 d0             	movslq %eax,%rdx
  803a9e:	48 89 d0             	mov    %rdx,%rax
  803aa1:	48 c1 e0 02          	shl    $0x2,%rax
  803aa5:	48 01 d0             	add    %rdx,%rax
  803aa8:	48 01 c0             	add    %rax,%rax
  803aab:	48 01 d0             	add    %rdx,%rax
  803aae:	48 c1 e0 05          	shl    $0x5,%rax
  803ab2:	48 01 c8             	add    %rcx,%rax
  803ab5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803abb:	8b 40 08             	mov    0x8(%rax),%eax
  803abe:	eb 12                	jmp    803ad2 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ac0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ac4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803acb:	7e 8d                	jle    803a5a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad2:	c9                   	leaveq 
  803ad3:	c3                   	retq   

0000000000803ad4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ad4:	55                   	push   %rbp
  803ad5:	48 89 e5             	mov    %rsp,%rbp
  803ad8:	48 83 ec 18          	sub    $0x18,%rsp
  803adc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae4:	48 89 c2             	mov    %rax,%rdx
  803ae7:	48 c1 ea 15          	shr    $0x15,%rdx
  803aeb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803af2:	01 00 00 
  803af5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803af9:	83 e0 01             	and    $0x1,%eax
  803afc:	48 85 c0             	test   %rax,%rax
  803aff:	75 07                	jne    803b08 <pageref+0x34>
		return 0;
  803b01:	b8 00 00 00 00       	mov    $0x0,%eax
  803b06:	eb 53                	jmp    803b5b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0c:	48 89 c2             	mov    %rax,%rdx
  803b0f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803b13:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b1a:	01 00 00 
  803b1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b29:	83 e0 01             	and    $0x1,%eax
  803b2c:	48 85 c0             	test   %rax,%rax
  803b2f:	75 07                	jne    803b38 <pageref+0x64>
		return 0;
  803b31:	b8 00 00 00 00       	mov    $0x0,%eax
  803b36:	eb 23                	jmp    803b5b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3c:	48 89 c2             	mov    %rax,%rdx
  803b3f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803b43:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803b4a:	00 00 00 
  803b4d:	48 c1 e2 04          	shl    $0x4,%rdx
  803b51:	48 01 d0             	add    %rdx,%rax
  803b54:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803b58:	0f b7 c0             	movzwl %ax,%eax
}
  803b5b:	c9                   	leaveq 
  803b5c:	c3                   	retq   
