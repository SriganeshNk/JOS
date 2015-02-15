
obj/user/spawnhello.debug:     file format elf64-x86-64


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
  80003c:	e8 a7 00 00 00       	callq  8000e8 <libmain>
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
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800053:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80005a:	00 00 00 
  80005d:	48 8b 00             	mov    (%rax),%rax
  800060:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800066:	89 c6                	mov    %eax,%esi
  800068:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  80006f:	00 00 00 
  800072:	b8 00 00 00 00       	mov    $0x0,%eax
  800077:	48 ba ef 03 80 00 00 	movabs $0x8003ef,%rdx
  80007e:	00 00 00 
  800081:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800083:	ba 00 00 00 00       	mov    $0x0,%edx
  800088:	48 be de 47 80 00 00 	movabs $0x8047de,%rsi
  80008f:	00 00 00 
  800092:	48 bf e4 47 80 00 00 	movabs $0x8047e4,%rdi
  800099:	00 00 00 
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	48 b9 e3 2b 80 00 00 	movabs $0x802be3,%rcx
  8000a8:	00 00 00 
  8000ab:	ff d1                	callq  *%rcx
  8000ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b4:	79 30                	jns    8000e6 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b9:	89 c1                	mov    %eax,%ecx
  8000bb:	48 ba ef 47 80 00 00 	movabs $0x8047ef,%rdx
  8000c2:	00 00 00 
  8000c5:	be 09 00 00 00       	mov    $0x9,%esi
  8000ca:	48 bf 07 48 80 00 00 	movabs $0x804807,%rdi
  8000d1:	00 00 00 
  8000d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d9:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  8000e0:	00 00 00 
  8000e3:	41 ff d0             	callq  *%r8
}
  8000e6:	c9                   	leaveq 
  8000e7:	c3                   	retq   

00000000008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %rbp
  8000e9:	48 89 e5             	mov    %rsp,%rbp
  8000ec:	48 83 ec 10          	sub    $0x10,%rsp
  8000f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000f7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000fe:	00 00 00 
  800101:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800108:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
  800114:	48 98                	cltq   
  800116:	48 89 c2             	mov    %rax,%rdx
  800119:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80011f:	48 89 d0             	mov    %rdx,%rax
  800122:	48 c1 e0 02          	shl    $0x2,%rax
  800126:	48 01 d0             	add    %rdx,%rax
  800129:	48 01 c0             	add    %rax,%rax
  80012c:	48 01 d0             	add    %rdx,%rax
  80012f:	48 c1 e0 05          	shl    $0x5,%rax
  800133:	48 89 c2             	mov    %rax,%rdx
  800136:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80013d:	00 00 00 
  800140:	48 01 c2             	add    %rax,%rdx
  800143:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014a:	00 00 00 
  80014d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800154:	7e 14                	jle    80016a <libmain+0x82>
		binaryname = argv[0];
  800156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015a:	48 8b 10             	mov    (%rax),%rdx
  80015d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800164:	00 00 00 
  800167:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80016a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800171:	48 89 d6             	mov    %rdx,%rsi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800182:	48 b8 90 01 80 00 00 	movabs $0x800190,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
}
  80018e:	c9                   	leaveq 
  80018f:	c3                   	retq   

0000000000800190 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800194:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a5:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
}
  8001b1:	5d                   	pop    %rbp
  8001b2:	c3                   	retq   
	...

00000000008001b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b4:	55                   	push   %rbp
  8001b5:	48 89 e5             	mov    %rsp,%rbp
  8001b8:	53                   	push   %rbx
  8001b9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001c0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001c7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001cd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001d4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001db:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001e2:	84 c0                	test   %al,%al
  8001e4:	74 23                	je     800209 <_panic+0x55>
  8001e6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001ed:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001f1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001f5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001f9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001fd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800201:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800205:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800209:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800210:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800217:	00 00 00 
  80021a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800221:	00 00 00 
  800224:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800228:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80022f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800236:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800244:	00 00 00 
  800247:	48 8b 18             	mov    (%rax),%rbx
  80024a:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80025c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800263:	41 89 c8             	mov    %ecx,%r8d
  800266:	48 89 d1             	mov    %rdx,%rcx
  800269:	48 89 da             	mov    %rbx,%rdx
  80026c:	89 c6                	mov    %eax,%esi
  80026e:	48 bf 28 48 80 00 00 	movabs $0x804828,%rdi
  800275:	00 00 00 
  800278:	b8 00 00 00 00       	mov    $0x0,%eax
  80027d:	49 b9 ef 03 80 00 00 	movabs $0x8003ef,%r9
  800284:	00 00 00 
  800287:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80028a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800291:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800298:	48 89 d6             	mov    %rdx,%rsi
  80029b:	48 89 c7             	mov    %rax,%rdi
  80029e:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  8002a5:	00 00 00 
  8002a8:	ff d0                	callq  *%rax
	cprintf("\n");
  8002aa:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  8002b1:	00 00 00 
  8002b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b9:	48 ba ef 03 80 00 00 	movabs $0x8003ef,%rdx
  8002c0:	00 00 00 
  8002c3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002c5:	cc                   	int3   
  8002c6:	eb fd                	jmp    8002c5 <_panic+0x111>

00000000008002c8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002c8:	55                   	push   %rbp
  8002c9:	48 89 e5             	mov    %rsp,%rbp
  8002cc:	48 83 ec 10          	sub    $0x10,%rsp
  8002d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002db:	8b 00                	mov    (%rax),%eax
  8002dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002e0:	89 d6                	mov    %edx,%esi
  8002e2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8002e6:	48 63 d0             	movslq %eax,%rdx
  8002e9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8002ee:	8d 50 01             	lea    0x1(%rax),%edx
  8002f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f5:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8002f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fb:	8b 00                	mov    (%rax),%eax
  8002fd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800302:	75 2c                	jne    800330 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800308:	8b 00                	mov    (%rax),%eax
  80030a:	48 98                	cltq   
  80030c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800310:	48 83 c2 08          	add    $0x8,%rdx
  800314:	48 89 c6             	mov    %rax,%rsi
  800317:	48 89 d7             	mov    %rdx,%rdi
  80031a:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
        b->idx = 0;
  800326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800334:	8b 40 04             	mov    0x4(%rax),%eax
  800337:	8d 50 01             	lea    0x1(%rax),%edx
  80033a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80033e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800341:	c9                   	leaveq 
  800342:	c3                   	retq   

0000000000800343 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800343:	55                   	push   %rbp
  800344:	48 89 e5             	mov    %rsp,%rbp
  800347:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80034e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800355:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80035c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800363:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80036a:	48 8b 0a             	mov    (%rdx),%rcx
  80036d:	48 89 08             	mov    %rcx,(%rax)
  800370:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800374:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800378:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80037c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800380:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800387:	00 00 00 
    b.cnt = 0;
  80038a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800391:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800394:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80039b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003a2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003a9:	48 89 c6             	mov    %rax,%rsi
  8003ac:	48 bf c8 02 80 00 00 	movabs $0x8002c8,%rdi
  8003b3:	00 00 00 
  8003b6:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003c2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003c8:	48 98                	cltq   
  8003ca:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003d1:	48 83 c2 08          	add    $0x8,%rdx
  8003d5:	48 89 c6             	mov    %rax,%rsi
  8003d8:	48 89 d7             	mov    %rdx,%rdi
  8003db:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003ed:	c9                   	leaveq 
  8003ee:	c3                   	retq   

00000000008003ef <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ef:	55                   	push   %rbp
  8003f0:	48 89 e5             	mov    %rsp,%rbp
  8003f3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003fa:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800401:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800408:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80040f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800416:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80041d:	84 c0                	test   %al,%al
  80041f:	74 20                	je     800441 <cprintf+0x52>
  800421:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800425:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800429:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80042d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800431:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800435:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800439:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80043d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800441:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800448:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80044f:	00 00 00 
  800452:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800459:	00 00 00 
  80045c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800460:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800467:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80046e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800475:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80047c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800483:	48 8b 0a             	mov    (%rdx),%rcx
  800486:	48 89 08             	mov    %rcx,(%rax)
  800489:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80048d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800491:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800495:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800499:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004a0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004a7:	48 89 d6             	mov    %rdx,%rsi
  8004aa:	48 89 c7             	mov    %rax,%rdi
  8004ad:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  8004b4:	00 00 00 
  8004b7:	ff d0                	callq  *%rax
  8004b9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8004bf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004c5:	c9                   	leaveq 
  8004c6:	c3                   	retq   
	...

00000000008004c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
  8004cc:	48 83 ec 30          	sub    $0x30,%rsp
  8004d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004dc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004df:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004e3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004ea:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004ee:	77 52                	ja     800542 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004f3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004f7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004fa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800502:	ba 00 00 00 00       	mov    $0x0,%edx
  800507:	48 f7 75 d0          	divq   -0x30(%rbp)
  80050b:	48 89 c2             	mov    %rax,%rdx
  80050e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800511:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800514:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051c:	41 89 f9             	mov    %edi,%r9d
  80051f:	48 89 c7             	mov    %rax,%rdi
  800522:	48 b8 c8 04 80 00 00 	movabs $0x8004c8,%rax
  800529:	00 00 00 
  80052c:	ff d0                	callq  *%rax
  80052e:	eb 1c                	jmp    80054c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800530:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800534:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800537:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80053b:	48 89 d6             	mov    %rdx,%rsi
  80053e:	89 c7                	mov    %eax,%edi
  800540:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800546:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80054a:	7f e4                	jg     800530 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	ba 00 00 00 00       	mov    $0x0,%edx
  800558:	48 f7 f1             	div    %rcx
  80055b:	48 89 d0             	mov    %rdx,%rax
  80055e:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  800565:	00 00 00 
  800568:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80056c:	0f be c0             	movsbl %al,%eax
  80056f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800573:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800577:	48 89 d6             	mov    %rdx,%rsi
  80057a:	89 c7                	mov    %eax,%edi
  80057c:	ff d1                	callq  *%rcx
}
  80057e:	c9                   	leaveq 
  80057f:	c3                   	retq   

0000000000800580 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800580:	55                   	push   %rbp
  800581:	48 89 e5             	mov    %rsp,%rbp
  800584:	48 83 ec 20          	sub    $0x20,%rsp
  800588:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80058f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800593:	7e 52                	jle    8005e7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	83 f8 30             	cmp    $0x30,%eax
  80059e:	73 24                	jae    8005c4 <getuint+0x44>
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	89 c0                	mov    %eax,%eax
  8005b0:	48 01 d0             	add    %rdx,%rax
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	8b 12                	mov    (%rdx),%edx
  8005b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	89 0a                	mov    %ecx,(%rdx)
  8005c2:	eb 17                	jmp    8005db <getuint+0x5b>
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cc:	48 89 d0             	mov    %rdx,%rax
  8005cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005db:	48 8b 00             	mov    (%rax),%rax
  8005de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e2:	e9 a3 00 00 00       	jmpq   80068a <getuint+0x10a>
	else if (lflag)
  8005e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005eb:	74 4f                	je     80063c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f1:	8b 00                	mov    (%rax),%eax
  8005f3:	83 f8 30             	cmp    $0x30,%eax
  8005f6:	73 24                	jae    80061c <getuint+0x9c>
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	8b 00                	mov    (%rax),%eax
  800606:	89 c0                	mov    %eax,%eax
  800608:	48 01 d0             	add    %rdx,%rax
  80060b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060f:	8b 12                	mov    (%rdx),%edx
  800611:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800618:	89 0a                	mov    %ecx,(%rdx)
  80061a:	eb 17                	jmp    800633 <getuint+0xb3>
  80061c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800620:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800624:	48 89 d0             	mov    %rdx,%rax
  800627:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800633:	48 8b 00             	mov    (%rax),%rax
  800636:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063a:	eb 4e                	jmp    80068a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	83 f8 30             	cmp    $0x30,%eax
  800645:	73 24                	jae    80066b <getuint+0xeb>
  800647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	89 c0                	mov    %eax,%eax
  800657:	48 01 d0             	add    %rdx,%rax
  80065a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065e:	8b 12                	mov    (%rdx),%edx
  800660:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800667:	89 0a                	mov    %ecx,(%rdx)
  800669:	eb 17                	jmp    800682 <getuint+0x102>
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800673:	48 89 d0             	mov    %rdx,%rax
  800676:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800682:	8b 00                	mov    (%rax),%eax
  800684:	89 c0                	mov    %eax,%eax
  800686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80068a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068e:	c9                   	leaveq 
  80068f:	c3                   	retq   

0000000000800690 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800690:	55                   	push   %rbp
  800691:	48 89 e5             	mov    %rsp,%rbp
  800694:	48 83 ec 20          	sub    $0x20,%rsp
  800698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80069c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80069f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006a3:	7e 52                	jle    8006f7 <getint+0x67>
		x=va_arg(*ap, long long);
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	83 f8 30             	cmp    $0x30,%eax
  8006ae:	73 24                	jae    8006d4 <getint+0x44>
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	89 c0                	mov    %eax,%eax
  8006c0:	48 01 d0             	add    %rdx,%rax
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	8b 12                	mov    (%rdx),%edx
  8006c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d0:	89 0a                	mov    %ecx,(%rdx)
  8006d2:	eb 17                	jmp    8006eb <getint+0x5b>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006dc:	48 89 d0             	mov    %rdx,%rax
  8006df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006eb:	48 8b 00             	mov    (%rax),%rax
  8006ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f2:	e9 a3 00 00 00       	jmpq   80079a <getint+0x10a>
	else if (lflag)
  8006f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006fb:	74 4f                	je     80074c <getint+0xbc>
		x=va_arg(*ap, long);
  8006fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800701:	8b 00                	mov    (%rax),%eax
  800703:	83 f8 30             	cmp    $0x30,%eax
  800706:	73 24                	jae    80072c <getint+0x9c>
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	8b 00                	mov    (%rax),%eax
  800716:	89 c0                	mov    %eax,%eax
  800718:	48 01 d0             	add    %rdx,%rax
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	8b 12                	mov    (%rdx),%edx
  800721:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800724:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800728:	89 0a                	mov    %ecx,(%rdx)
  80072a:	eb 17                	jmp    800743 <getint+0xb3>
  80072c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800730:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800734:	48 89 d0             	mov    %rdx,%rax
  800737:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800743:	48 8b 00             	mov    (%rax),%rax
  800746:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80074a:	eb 4e                	jmp    80079a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	8b 00                	mov    (%rax),%eax
  800752:	83 f8 30             	cmp    $0x30,%eax
  800755:	73 24                	jae    80077b <getint+0xeb>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	89 c0                	mov    %eax,%eax
  800767:	48 01 d0             	add    %rdx,%rax
  80076a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076e:	8b 12                	mov    (%rdx),%edx
  800770:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	89 0a                	mov    %ecx,(%rdx)
  800779:	eb 17                	jmp    800792 <getint+0x102>
  80077b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800783:	48 89 d0             	mov    %rdx,%rax
  800786:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800792:	8b 00                	mov    (%rax),%eax
  800794:	48 98                	cltq   
  800796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80079a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80079e:	c9                   	leaveq 
  80079f:	c3                   	retq   

00000000008007a0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a0:	55                   	push   %rbp
  8007a1:	48 89 e5             	mov    %rsp,%rbp
  8007a4:	41 54                	push   %r12
  8007a6:	53                   	push   %rbx
  8007a7:	48 83 ec 60          	sub    $0x60,%rsp
  8007ab:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007af:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8007b3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007b7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007bf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007c3:	48 8b 0a             	mov    (%rdx),%rcx
  8007c6:	48 89 08             	mov    %rcx,(%rax)
  8007c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d9:	eb 17                	jmp    8007f2 <vprintfmt+0x52>
			if (ch == '\0')
  8007db:	85 db                	test   %ebx,%ebx
  8007dd:	0f 84 ea 04 00 00    	je     800ccd <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8007e3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007e7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8007eb:	48 89 c6             	mov    %rax,%rsi
  8007ee:	89 df                	mov    %ebx,%edi
  8007f0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f6:	0f b6 00             	movzbl (%rax),%eax
  8007f9:	0f b6 d8             	movzbl %al,%ebx
  8007fc:	83 fb 25             	cmp    $0x25,%ebx
  8007ff:	0f 95 c0             	setne  %al
  800802:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800807:	84 c0                	test   %al,%al
  800809:	75 d0                	jne    8007db <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80080b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80080f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800816:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80081d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800824:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80082b:	eb 04                	jmp    800831 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80082d:	90                   	nop
  80082e:	eb 01                	jmp    800831 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800830:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800831:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800835:	0f b6 00             	movzbl (%rax),%eax
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	89 d8                	mov    %ebx,%eax
  80083d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800842:	83 e8 23             	sub    $0x23,%eax
  800845:	83 f8 55             	cmp    $0x55,%eax
  800848:	0f 87 4b 04 00 00    	ja     800c99 <vprintfmt+0x4f9>
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800857:	00 
  800858:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
  80085f:	00 00 00 
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	48 8b 00             	mov    (%rax),%rax
  800868:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80086a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80086e:	eb c1                	jmp    800831 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800870:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800874:	eb bb                	jmp    800831 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800876:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80087d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800880:	89 d0                	mov    %edx,%eax
  800882:	c1 e0 02             	shl    $0x2,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c0                	add    %eax,%eax
  800889:	01 d8                	add    %ebx,%eax
  80088b:	83 e8 30             	sub    $0x30,%eax
  80088e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800891:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800895:	0f b6 00             	movzbl (%rax),%eax
  800898:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089b:	83 fb 2f             	cmp    $0x2f,%ebx
  80089e:	7e 63                	jle    800903 <vprintfmt+0x163>
  8008a0:	83 fb 39             	cmp    $0x39,%ebx
  8008a3:	7f 5e                	jg     800903 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008aa:	eb d1                	jmp    80087d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8008ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008af:	83 f8 30             	cmp    $0x30,%eax
  8008b2:	73 17                	jae    8008cb <vprintfmt+0x12b>
  8008b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bb:	89 c0                	mov    %eax,%eax
  8008bd:	48 01 d0             	add    %rdx,%rax
  8008c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c3:	83 c2 08             	add    $0x8,%edx
  8008c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c9:	eb 0f                	jmp    8008da <vprintfmt+0x13a>
  8008cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cf:	48 89 d0             	mov    %rdx,%rax
  8008d2:	48 83 c2 08          	add    $0x8,%rdx
  8008d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008df:	eb 23                	jmp    800904 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8008e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e5:	0f 89 42 ff ff ff    	jns    80082d <vprintfmt+0x8d>
				width = 0;
  8008eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008f2:	e9 36 ff ff ff       	jmpq   80082d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8008f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008fe:	e9 2e ff ff ff       	jmpq   800831 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800903:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800904:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800908:	0f 89 22 ff ff ff    	jns    800830 <vprintfmt+0x90>
				width = precision, precision = -1;
  80090e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800911:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800914:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80091b:	e9 10 ff ff ff       	jmpq   800830 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800920:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800924:	e9 08 ff ff ff       	jmpq   800831 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800929:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092c:	83 f8 30             	cmp    $0x30,%eax
  80092f:	73 17                	jae    800948 <vprintfmt+0x1a8>
  800931:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800935:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800938:	89 c0                	mov    %eax,%eax
  80093a:	48 01 d0             	add    %rdx,%rax
  80093d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800940:	83 c2 08             	add    $0x8,%edx
  800943:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800946:	eb 0f                	jmp    800957 <vprintfmt+0x1b7>
  800948:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094c:	48 89 d0             	mov    %rdx,%rax
  80094f:	48 83 c2 08          	add    $0x8,%rdx
  800953:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800957:	8b 00                	mov    (%rax),%eax
  800959:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80095d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800961:	48 89 d6             	mov    %rdx,%rsi
  800964:	89 c7                	mov    %eax,%edi
  800966:	ff d1                	callq  *%rcx
			break;
  800968:	e9 5a 03 00 00       	jmpq   800cc7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80096d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800970:	83 f8 30             	cmp    $0x30,%eax
  800973:	73 17                	jae    80098c <vprintfmt+0x1ec>
  800975:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800979:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097c:	89 c0                	mov    %eax,%eax
  80097e:	48 01 d0             	add    %rdx,%rax
  800981:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800984:	83 c2 08             	add    $0x8,%edx
  800987:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80098a:	eb 0f                	jmp    80099b <vprintfmt+0x1fb>
  80098c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800990:	48 89 d0             	mov    %rdx,%rax
  800993:	48 83 c2 08          	add    $0x8,%rdx
  800997:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	79 02                	jns    8009a3 <vprintfmt+0x203>
				err = -err;
  8009a1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009a3:	83 fb 15             	cmp    $0x15,%ebx
  8009a6:	7f 16                	jg     8009be <vprintfmt+0x21e>
  8009a8:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  8009af:	00 00 00 
  8009b2:	48 63 d3             	movslq %ebx,%rdx
  8009b5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8009b9:	4d 85 e4             	test   %r12,%r12
  8009bc:	75 2e                	jne    8009ec <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8009be:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c6:	89 d9                	mov    %ebx,%ecx
  8009c8:	48 ba 61 4a 80 00 00 	movabs $0x804a61,%rdx
  8009cf:	00 00 00 
  8009d2:	48 89 c7             	mov    %rax,%rdi
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	49 b8 d7 0c 80 00 00 	movabs $0x800cd7,%r8
  8009e1:	00 00 00 
  8009e4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e7:	e9 db 02 00 00       	jmpq   800cc7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f4:	4c 89 e1             	mov    %r12,%rcx
  8009f7:	48 ba 6a 4a 80 00 00 	movabs $0x804a6a,%rdx
  8009fe:	00 00 00 
  800a01:	48 89 c7             	mov    %rax,%rdi
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
  800a09:	49 b8 d7 0c 80 00 00 	movabs $0x800cd7,%r8
  800a10:	00 00 00 
  800a13:	41 ff d0             	callq  *%r8
			break;
  800a16:	e9 ac 02 00 00       	jmpq   800cc7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1e:	83 f8 30             	cmp    $0x30,%eax
  800a21:	73 17                	jae    800a3a <vprintfmt+0x29a>
  800a23:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2a:	89 c0                	mov    %eax,%eax
  800a2c:	48 01 d0             	add    %rdx,%rax
  800a2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a32:	83 c2 08             	add    $0x8,%edx
  800a35:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a38:	eb 0f                	jmp    800a49 <vprintfmt+0x2a9>
  800a3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3e:	48 89 d0             	mov    %rdx,%rax
  800a41:	48 83 c2 08          	add    $0x8,%rdx
  800a45:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a49:	4c 8b 20             	mov    (%rax),%r12
  800a4c:	4d 85 e4             	test   %r12,%r12
  800a4f:	75 0a                	jne    800a5b <vprintfmt+0x2bb>
				p = "(null)";
  800a51:	49 bc 6d 4a 80 00 00 	movabs $0x804a6d,%r12
  800a58:	00 00 00 
			if (width > 0 && padc != '-')
  800a5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5f:	7e 7a                	jle    800adb <vprintfmt+0x33b>
  800a61:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a65:	74 74                	je     800adb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a67:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a6a:	48 98                	cltq   
  800a6c:	48 89 c6             	mov    %rax,%rsi
  800a6f:	4c 89 e7             	mov    %r12,%rdi
  800a72:	48 b8 82 0f 80 00 00 	movabs $0x800f82,%rax
  800a79:	00 00 00 
  800a7c:	ff d0                	callq  *%rax
  800a7e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a81:	eb 17                	jmp    800a9a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800a83:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800a87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a8f:	48 89 d6             	mov    %rdx,%rsi
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9e:	7f e3                	jg     800a83 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	eb 39                	jmp    800adb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800aa2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800aa6:	74 1e                	je     800ac6 <vprintfmt+0x326>
  800aa8:	83 fb 1f             	cmp    $0x1f,%ebx
  800aab:	7e 05                	jle    800ab2 <vprintfmt+0x312>
  800aad:	83 fb 7e             	cmp    $0x7e,%ebx
  800ab0:	7e 14                	jle    800ac6 <vprintfmt+0x326>
					putch('?', putdat);
  800ab2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aba:	48 89 c6             	mov    %rax,%rsi
  800abd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ac2:	ff d2                	callq  *%rdx
  800ac4:	eb 0f                	jmp    800ad5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800ac6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800aca:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ace:	48 89 c6             	mov    %rax,%rsi
  800ad1:	89 df                	mov    %ebx,%edi
  800ad3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ad9:	eb 01                	jmp    800adc <vprintfmt+0x33c>
  800adb:	90                   	nop
  800adc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ae1:	0f be d8             	movsbl %al,%ebx
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	0f 95 c0             	setne  %al
  800ae9:	49 83 c4 01          	add    $0x1,%r12
  800aed:	84 c0                	test   %al,%al
  800aef:	74 28                	je     800b19 <vprintfmt+0x379>
  800af1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800af5:	78 ab                	js     800aa2 <vprintfmt+0x302>
  800af7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800afb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800aff:	79 a1                	jns    800aa2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b01:	eb 16                	jmp    800b19 <vprintfmt+0x379>
				putch(' ', putdat);
  800b03:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b07:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b0b:	48 89 c6             	mov    %rax,%rsi
  800b0e:	bf 20 00 00 00       	mov    $0x20,%edi
  800b13:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1d:	7f e4                	jg     800b03 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800b1f:	e9 a3 01 00 00       	jmpq   800cc7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b28:	be 03 00 00 00       	mov    $0x3,%esi
  800b2d:	48 89 c7             	mov    %rax,%rdi
  800b30:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  800b37:	00 00 00 
  800b3a:	ff d0                	callq  *%rax
  800b3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b44:	48 85 c0             	test   %rax,%rax
  800b47:	79 1d                	jns    800b66 <vprintfmt+0x3c6>
				putch('-', putdat);
  800b49:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b4d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b51:	48 89 c6             	mov    %rax,%rsi
  800b54:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b59:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5f:	48 f7 d8             	neg    %rax
  800b62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b6d:	e9 e8 00 00 00       	jmpq   800c5a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b72:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b76:	be 03 00 00 00       	mov    $0x3,%esi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 80 05 80 00 00 	movabs $0x800580,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
  800b8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b8e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b95:	e9 c0 00 00 00       	jmpq   800c5a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b9a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b9e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ba2:	48 89 c6             	mov    %rax,%rsi
  800ba5:	bf 58 00 00 00       	mov    $0x58,%edi
  800baa:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800bac:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bb0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bb4:	48 89 c6             	mov    %rax,%rsi
  800bb7:	bf 58 00 00 00       	mov    $0x58,%edi
  800bbc:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800bbe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bc2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bc6:	48 89 c6             	mov    %rax,%rsi
  800bc9:	bf 58 00 00 00       	mov    $0x58,%edi
  800bce:	ff d2                	callq  *%rdx
			break;
  800bd0:	e9 f2 00 00 00       	jmpq   800cc7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800bd5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bdd:	48 89 c6             	mov    %rax,%rsi
  800be0:	bf 30 00 00 00       	mov    $0x30,%edi
  800be5:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800be7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800beb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bef:	48 89 c6             	mov    %rax,%rsi
  800bf2:	bf 78 00 00 00       	mov    $0x78,%edi
  800bf7:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfc:	83 f8 30             	cmp    $0x30,%eax
  800bff:	73 17                	jae    800c18 <vprintfmt+0x478>
  800c01:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c08:	89 c0                	mov    %eax,%eax
  800c0a:	48 01 d0             	add    %rdx,%rax
  800c0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c10:	83 c2 08             	add    $0x8,%edx
  800c13:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c16:	eb 0f                	jmp    800c27 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800c18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c1c:	48 89 d0             	mov    %rdx,%rax
  800c1f:	48 83 c2 08          	add    $0x8,%rdx
  800c23:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c27:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c2e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c35:	eb 23                	jmp    800c5a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3b:	be 03 00 00 00       	mov    $0x3,%esi
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 80 05 80 00 00 	movabs $0x800580,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c5a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c5f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c62:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	45 89 c1             	mov    %r8d,%r9d
  800c74:	41 89 f8             	mov    %edi,%r8d
  800c77:	48 89 c7             	mov    %rax,%rdi
  800c7a:	48 b8 c8 04 80 00 00 	movabs $0x8004c8,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
			break;
  800c86:	eb 3f                	jmp    800cc7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c88:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c90:	48 89 c6             	mov    %rax,%rsi
  800c93:	89 df                	mov    %ebx,%edi
  800c95:	ff d2                	callq  *%rdx
			break;
  800c97:	eb 2e                	jmp    800cc7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca1:	48 89 c6             	mov    %rax,%rsi
  800ca4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ca9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cab:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cb0:	eb 05                	jmp    800cb7 <vprintfmt+0x517>
  800cb2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cb7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cbb:	48 83 e8 01          	sub    $0x1,%rax
  800cbf:	0f b6 00             	movzbl (%rax),%eax
  800cc2:	3c 25                	cmp    $0x25,%al
  800cc4:	75 ec                	jne    800cb2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800cc6:	90                   	nop
		}
	}
  800cc7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc8:	e9 25 fb ff ff       	jmpq   8007f2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800ccd:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cce:	48 83 c4 60          	add    $0x60,%rsp
  800cd2:	5b                   	pop    %rbx
  800cd3:	41 5c                	pop    %r12
  800cd5:	5d                   	pop    %rbp
  800cd6:	c3                   	retq   

0000000000800cd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd7:	55                   	push   %rbp
  800cd8:	48 89 e5             	mov    %rsp,%rbp
  800cdb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ce2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ce9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cf0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cfe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d05:	84 c0                	test   %al,%al
  800d07:	74 20                	je     800d29 <printfmt+0x52>
  800d09:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d0d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d11:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d15:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d19:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d1d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d21:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d25:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d29:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d30:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d37:	00 00 00 
  800d3a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d41:	00 00 00 
  800d44:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d48:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d4f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d56:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d64:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d6b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d72:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d79:	48 89 c7             	mov    %rax,%rdi
  800d7c:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d88:	c9                   	leaveq 
  800d89:	c3                   	retq   

0000000000800d8a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8a:	55                   	push   %rbp
  800d8b:	48 89 e5             	mov    %rsp,%rbp
  800d8e:	48 83 ec 10          	sub    $0x10,%rsp
  800d92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9d:	8b 40 10             	mov    0x10(%rax),%eax
  800da0:	8d 50 01             	lea    0x1(%rax),%edx
  800da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dae:	48 8b 10             	mov    (%rax),%rdx
  800db1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800db9:	48 39 c2             	cmp    %rax,%rdx
  800dbc:	73 17                	jae    800dd5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc2:	48 8b 00             	mov    (%rax),%rax
  800dc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dc8:	88 10                	mov    %dl,(%rax)
  800dca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dd2:	48 89 10             	mov    %rdx,(%rax)
}
  800dd5:	c9                   	leaveq 
  800dd6:	c3                   	retq   

0000000000800dd7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd7:	55                   	push   %rbp
  800dd8:	48 89 e5             	mov    %rsp,%rbp
  800ddb:	48 83 ec 50          	sub    $0x50,%rsp
  800ddf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800de3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800de6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dea:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dee:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800df2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800df6:	48 8b 0a             	mov    (%rdx),%rcx
  800df9:	48 89 08             	mov    %rcx,(%rax)
  800dfc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e00:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e04:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e08:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e0c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e10:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e14:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e17:	48 98                	cltq   
  800e19:	48 83 e8 01          	sub    $0x1,%rax
  800e1d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800e21:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e2c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e31:	74 06                	je     800e39 <vsnprintf+0x62>
  800e33:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e37:	7f 07                	jg     800e40 <vsnprintf+0x69>
		return -E_INVAL;
  800e39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3e:	eb 2f                	jmp    800e6f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e40:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e44:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e48:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e4c:	48 89 c6             	mov    %rax,%rsi
  800e4f:	48 bf 8a 0d 80 00 00 	movabs $0x800d8a,%rdi
  800e56:	00 00 00 
  800e59:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800e60:	00 00 00 
  800e63:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e69:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e6c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e6f:	c9                   	leaveq 
  800e70:	c3                   	retq   

0000000000800e71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e71:	55                   	push   %rbp
  800e72:	48 89 e5             	mov    %rsp,%rbp
  800e75:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e7c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e83:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 20                	je     800ec2 <snprintf+0x51>
  800ea2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ea6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eaa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ebe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ec2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ec9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ed0:	00 00 00 
  800ed3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800eda:	00 00 00 
  800edd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ee1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ee8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eef:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ef6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800efd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f04:	48 8b 0a             	mov    (%rdx),%rcx
  800f07:	48 89 08             	mov    %rcx,(%rax)
  800f0a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f0e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f12:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f16:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f1a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f21:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f28:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f2e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f35:	48 89 c7             	mov    %rax,%rdi
  800f38:	48 b8 d7 0d 80 00 00 	movabs $0x800dd7,%rax
  800f3f:	00 00 00 
  800f42:	ff d0                	callq  *%rax
  800f44:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f4a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   
	...

0000000000800f54 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f54:	55                   	push   %rbp
  800f55:	48 89 e5             	mov    %rsp,%rbp
  800f58:	48 83 ec 18          	sub    $0x18,%rsp
  800f5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f67:	eb 09                	jmp    800f72 <strlen+0x1e>
		n++;
  800f69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f6d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	0f b6 00             	movzbl (%rax),%eax
  800f79:	84 c0                	test   %al,%al
  800f7b:	75 ec                	jne    800f69 <strlen+0x15>
		n++;
	return n;
  800f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f80:	c9                   	leaveq 
  800f81:	c3                   	retq   

0000000000800f82 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f82:	55                   	push   %rbp
  800f83:	48 89 e5             	mov    %rsp,%rbp
  800f86:	48 83 ec 20          	sub    $0x20,%rsp
  800f8a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f99:	eb 0e                	jmp    800fa9 <strnlen+0x27>
		n++;
  800f9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f9f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fa9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fae:	74 0b                	je     800fbb <strnlen+0x39>
  800fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb4:	0f b6 00             	movzbl (%rax),%eax
  800fb7:	84 c0                	test   %al,%al
  800fb9:	75 e0                	jne    800f9b <strnlen+0x19>
		n++;
	return n;
  800fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fbe:	c9                   	leaveq 
  800fbf:	c3                   	retq   

0000000000800fc0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	48 83 ec 20          	sub    $0x20,%rsp
  800fc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fd8:	90                   	nop
  800fd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fdd:	0f b6 10             	movzbl (%rax),%edx
  800fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe4:	88 10                	mov    %dl,(%rax)
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	0f b6 00             	movzbl (%rax),%eax
  800fed:	84 c0                	test   %al,%al
  800fef:	0f 95 c0             	setne  %al
  800ff2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ff7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800ffc:	84 c0                	test   %al,%al
  800ffe:	75 d9                	jne    800fd9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801004:	c9                   	leaveq 
  801005:	c3                   	retq   

0000000000801006 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801006:	55                   	push   %rbp
  801007:	48 89 e5             	mov    %rsp,%rbp
  80100a:	48 83 ec 20          	sub    $0x20,%rsp
  80100e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801012:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101a:	48 89 c7             	mov    %rax,%rdi
  80101d:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
  801029:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80102c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102f:	48 98                	cltq   
  801031:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801035:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801039:	48 89 d6             	mov    %rdx,%rsi
  80103c:	48 89 c7             	mov    %rax,%rdi
  80103f:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  801046:	00 00 00 
  801049:	ff d0                	callq  *%rax
	return dst;
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80104f:	c9                   	leaveq 
  801050:	c3                   	retq   

0000000000801051 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
  801055:	48 83 ec 28          	sub    $0x28,%rsp
  801059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801061:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801069:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80106d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801074:	00 
  801075:	eb 27                	jmp    80109e <strncpy+0x4d>
		*dst++ = *src;
  801077:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80107b:	0f b6 10             	movzbl (%rax),%edx
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	88 10                	mov    %dl,(%rax)
  801084:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801089:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	84 c0                	test   %al,%al
  801092:	74 05                	je     801099 <strncpy+0x48>
			src++;
  801094:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801099:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010a6:	72 cf                	jb     801077 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010ac:	c9                   	leaveq 
  8010ad:	c3                   	retq   

00000000008010ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010ae:	55                   	push   %rbp
  8010af:	48 89 e5             	mov    %rsp,%rbp
  8010b2:	48 83 ec 28          	sub    $0x28,%rsp
  8010b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010cf:	74 37                	je     801108 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8010d1:	eb 17                	jmp    8010ea <strlcpy+0x3c>
			*dst++ = *src++;
  8010d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d7:	0f b6 10             	movzbl (%rax),%edx
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	88 10                	mov    %dl,(%rax)
  8010e0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ea:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010f4:	74 0b                	je     801101 <strlcpy+0x53>
  8010f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	75 d2                	jne    8010d3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801108:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801110:	48 89 d1             	mov    %rdx,%rcx
  801113:	48 29 c1             	sub    %rax,%rcx
  801116:	48 89 c8             	mov    %rcx,%rax
}
  801119:	c9                   	leaveq 
  80111a:	c3                   	retq   

000000000080111b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80111b:	55                   	push   %rbp
  80111c:	48 89 e5             	mov    %rsp,%rbp
  80111f:	48 83 ec 10          	sub    $0x10,%rsp
  801123:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801127:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80112b:	eb 0a                	jmp    801137 <strcmp+0x1c>
		p++, q++;
  80112d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801132:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	74 12                	je     801154 <strcmp+0x39>
  801142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801146:	0f b6 10             	movzbl (%rax),%edx
  801149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114d:	0f b6 00             	movzbl (%rax),%eax
  801150:	38 c2                	cmp    %al,%dl
  801152:	74 d9                	je     80112d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801158:	0f b6 00             	movzbl (%rax),%eax
  80115b:	0f b6 d0             	movzbl %al,%edx
  80115e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801162:	0f b6 00             	movzbl (%rax),%eax
  801165:	0f b6 c0             	movzbl %al,%eax
  801168:	89 d1                	mov    %edx,%ecx
  80116a:	29 c1                	sub    %eax,%ecx
  80116c:	89 c8                	mov    %ecx,%eax
}
  80116e:	c9                   	leaveq 
  80116f:	c3                   	retq   

0000000000801170 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801170:	55                   	push   %rbp
  801171:	48 89 e5             	mov    %rsp,%rbp
  801174:	48 83 ec 18          	sub    $0x18,%rsp
  801178:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80117c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801180:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801184:	eb 0f                	jmp    801195 <strncmp+0x25>
		n--, p++, q++;
  801186:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80118b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801190:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801195:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119a:	74 1d                	je     8011b9 <strncmp+0x49>
  80119c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	74 12                	je     8011b9 <strncmp+0x49>
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	0f b6 10             	movzbl (%rax),%edx
  8011ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	38 c2                	cmp    %al,%dl
  8011b7:	74 cd                	je     801186 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011be:	75 07                	jne    8011c7 <strncmp+0x57>
		return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 1a                	jmp    8011e1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	0f b6 d0             	movzbl %al,%edx
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	0f b6 c0             	movzbl %al,%eax
  8011db:	89 d1                	mov    %edx,%ecx
  8011dd:	29 c1                	sub    %eax,%ecx
  8011df:	89 c8                	mov    %ecx,%eax
}
  8011e1:	c9                   	leaveq 
  8011e2:	c3                   	retq   

00000000008011e3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e3:	55                   	push   %rbp
  8011e4:	48 89 e5             	mov    %rsp,%rbp
  8011e7:	48 83 ec 10          	sub    $0x10,%rsp
  8011eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ef:	89 f0                	mov    %esi,%eax
  8011f1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f4:	eb 17                	jmp    80120d <strchr+0x2a>
		if (*s == c)
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801200:	75 06                	jne    801208 <strchr+0x25>
			return (char *) s;
  801202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801206:	eb 15                	jmp    80121d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	84 c0                	test   %al,%al
  801216:	75 de                	jne    8011f6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 10          	sub    $0x10,%rsp
  801227:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122b:	89 f0                	mov    %esi,%eax
  80122d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801230:	eb 11                	jmp    801243 <strfind+0x24>
		if (*s == c)
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80123c:	74 12                	je     801250 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80123e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	84 c0                	test   %al,%al
  80124c:	75 e4                	jne    801232 <strfind+0x13>
  80124e:	eb 01                	jmp    801251 <strfind+0x32>
		if (*s == c)
			break;
  801250:	90                   	nop
	return (char *) s;
  801251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801255:	c9                   	leaveq 
  801256:	c3                   	retq   

0000000000801257 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	48 83 ec 18          	sub    $0x18,%rsp
  80125f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801263:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801266:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80126a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126f:	75 06                	jne    801277 <memset+0x20>
		return v;
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	eb 69                	jmp    8012e0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	83 e0 03             	and    $0x3,%eax
  80127e:	48 85 c0             	test   %rax,%rax
  801281:	75 48                	jne    8012cb <memset+0x74>
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	83 e0 03             	and    $0x3,%eax
  80128a:	48 85 c0             	test   %rax,%rax
  80128d:	75 3c                	jne    8012cb <memset+0x74>
		c &= 0xFF;
  80128f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801296:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	c1 e2 18             	shl    $0x18,%edx
  80129e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a1:	c1 e0 10             	shl    $0x10,%eax
  8012a4:	09 c2                	or     %eax,%edx
  8012a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a9:	c1 e0 08             	shl    $0x8,%eax
  8012ac:	09 d0                	or     %edx,%eax
  8012ae:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 89 c1             	mov    %rax,%rcx
  8012b8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012c3:	48 89 d7             	mov    %rdx,%rdi
  8012c6:	fc                   	cld    
  8012c7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012c9:	eb 11                	jmp    8012dc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012d6:	48 89 d7             	mov    %rdx,%rdi
  8012d9:	fc                   	cld    
  8012da:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 28          	sub    $0x28,%rsp
  8012ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80130e:	0f 83 88 00 00 00    	jae    80139c <memmove+0xba>
  801314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801318:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131c:	48 01 d0             	add    %rdx,%rax
  80131f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801323:	76 77                	jbe    80139c <memmove+0xba>
		s += n;
  801325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801329:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80132d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801331:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	83 e0 03             	and    $0x3,%eax
  80133c:	48 85 c0             	test   %rax,%rax
  80133f:	75 3b                	jne    80137c <memmove+0x9a>
  801341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801345:	83 e0 03             	and    $0x3,%eax
  801348:	48 85 c0             	test   %rax,%rax
  80134b:	75 2f                	jne    80137c <memmove+0x9a>
  80134d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801351:	83 e0 03             	and    $0x3,%eax
  801354:	48 85 c0             	test   %rax,%rax
  801357:	75 23                	jne    80137c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135d:	48 83 e8 04          	sub    $0x4,%rax
  801361:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801365:	48 83 ea 04          	sub    $0x4,%rdx
  801369:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80136d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801371:	48 89 c7             	mov    %rax,%rdi
  801374:	48 89 d6             	mov    %rdx,%rsi
  801377:	fd                   	std    
  801378:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80137a:	eb 1d                	jmp    801399 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80137c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801380:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80138c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801390:	48 89 d7             	mov    %rdx,%rdi
  801393:	48 89 c1             	mov    %rax,%rcx
  801396:	fd                   	std    
  801397:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801399:	fc                   	cld    
  80139a:	eb 57                	jmp    8013f3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	83 e0 03             	and    $0x3,%eax
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	75 36                	jne    8013de <memmove+0xfc>
  8013a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ac:	83 e0 03             	and    $0x3,%eax
  8013af:	48 85 c0             	test   %rax,%rax
  8013b2:	75 2a                	jne    8013de <memmove+0xfc>
  8013b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b8:	83 e0 03             	and    $0x3,%eax
  8013bb:	48 85 c0             	test   %rax,%rax
  8013be:	75 1e                	jne    8013de <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 89 c1             	mov    %rax,%rcx
  8013c7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d3:	48 89 c7             	mov    %rax,%rdi
  8013d6:	48 89 d6             	mov    %rdx,%rsi
  8013d9:	fc                   	cld    
  8013da:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013dc:	eb 15                	jmp    8013f3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ea:	48 89 c7             	mov    %rax,%rdi
  8013ed:	48 89 d6             	mov    %rdx,%rsi
  8013f0:	fc                   	cld    
  8013f1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013f7:	c9                   	leaveq 
  8013f8:	c3                   	retq   

00000000008013f9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013f9:	55                   	push   %rbp
  8013fa:	48 89 e5             	mov    %rsp,%rbp
  8013fd:	48 83 ec 18          	sub    $0x18,%rsp
  801401:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801405:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801409:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80140d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801411:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	48 89 ce             	mov    %rcx,%rsi
  80141c:	48 89 c7             	mov    %rax,%rdi
  80141f:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  801426:	00 00 00 
  801429:	ff d0                	callq  *%rax
}
  80142b:	c9                   	leaveq 
  80142c:	c3                   	retq   

000000000080142d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80142d:	55                   	push   %rbp
  80142e:	48 89 e5             	mov    %rsp,%rbp
  801431:	48 83 ec 28          	sub    $0x28,%rsp
  801435:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801439:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80143d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801445:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801451:	eb 38                	jmp    80148b <memcmp+0x5e>
		if (*s1 != *s2)
  801453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801457:	0f b6 10             	movzbl (%rax),%edx
  80145a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	38 c2                	cmp    %al,%dl
  801463:	74 1c                	je     801481 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	0f b6 d0             	movzbl %al,%edx
  80146f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	0f b6 c0             	movzbl %al,%eax
  801479:	89 d1                	mov    %edx,%ecx
  80147b:	29 c1                	sub    %eax,%ecx
  80147d:	89 c8                	mov    %ecx,%eax
  80147f:	eb 20                	jmp    8014a1 <memcmp+0x74>
		s1++, s2++;
  801481:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801486:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80148b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801490:	0f 95 c0             	setne  %al
  801493:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801498:	84 c0                	test   %al,%al
  80149a:	75 b7                	jne    801453 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a1:	c9                   	leaveq 
  8014a2:	c3                   	retq   

00000000008014a3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014a3:	55                   	push   %rbp
  8014a4:	48 89 e5             	mov    %rsp,%rbp
  8014a7:	48 83 ec 28          	sub    $0x28,%rsp
  8014ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014be:	48 01 d0             	add    %rdx,%rax
  8014c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014c5:	eb 13                	jmp    8014da <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cb:	0f b6 10             	movzbl (%rax),%edx
  8014ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014d1:	38 c2                	cmp    %al,%dl
  8014d3:	74 11                	je     8014e6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014d5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014de:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014e2:	72 e3                	jb     8014c7 <memfind+0x24>
  8014e4:	eb 01                	jmp    8014e7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014e6:	90                   	nop
	return (void *) s;
  8014e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014eb:	c9                   	leaveq 
  8014ec:	c3                   	retq   

00000000008014ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014ed:	55                   	push   %rbp
  8014ee:	48 89 e5             	mov    %rsp,%rbp
  8014f1:	48 83 ec 38          	sub    $0x38,%rsp
  8014f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014fd:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801507:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80150e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80150f:	eb 05                	jmp    801516 <strtol+0x29>
		s++;
  801511:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	3c 20                	cmp    $0x20,%al
  80151f:	74 f0                	je     801511 <strtol+0x24>
  801521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	3c 09                	cmp    $0x9,%al
  80152a:	74 e5                	je     801511 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 2b                	cmp    $0x2b,%al
  801535:	75 07                	jne    80153e <strtol+0x51>
		s++;
  801537:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80153c:	eb 17                	jmp    801555 <strtol+0x68>
	else if (*s == '-')
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	3c 2d                	cmp    $0x2d,%al
  801547:	75 0c                	jne    801555 <strtol+0x68>
		s++, neg = 1;
  801549:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80154e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801555:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801559:	74 06                	je     801561 <strtol+0x74>
  80155b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80155f:	75 28                	jne    801589 <strtol+0x9c>
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	3c 30                	cmp    $0x30,%al
  80156a:	75 1d                	jne    801589 <strtol+0x9c>
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	48 83 c0 01          	add    $0x1,%rax
  801574:	0f b6 00             	movzbl (%rax),%eax
  801577:	3c 78                	cmp    $0x78,%al
  801579:	75 0e                	jne    801589 <strtol+0x9c>
		s += 2, base = 16;
  80157b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801580:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801587:	eb 2c                	jmp    8015b5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801589:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80158d:	75 19                	jne    8015a8 <strtol+0xbb>
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	3c 30                	cmp    $0x30,%al
  801598:	75 0e                	jne    8015a8 <strtol+0xbb>
		s++, base = 8;
  80159a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015a6:	eb 0d                	jmp    8015b5 <strtol+0xc8>
	else if (base == 0)
  8015a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ac:	75 07                	jne    8015b5 <strtol+0xc8>
		base = 10;
  8015ae:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	0f b6 00             	movzbl (%rax),%eax
  8015bc:	3c 2f                	cmp    $0x2f,%al
  8015be:	7e 1d                	jle    8015dd <strtol+0xf0>
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	3c 39                	cmp    $0x39,%al
  8015c9:	7f 12                	jg     8015dd <strtol+0xf0>
			dig = *s - '0';
  8015cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cf:	0f b6 00             	movzbl (%rax),%eax
  8015d2:	0f be c0             	movsbl %al,%eax
  8015d5:	83 e8 30             	sub    $0x30,%eax
  8015d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015db:	eb 4e                	jmp    80162b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	3c 60                	cmp    $0x60,%al
  8015e6:	7e 1d                	jle    801605 <strtol+0x118>
  8015e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	3c 7a                	cmp    $0x7a,%al
  8015f1:	7f 12                	jg     801605 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	0f be c0             	movsbl %al,%eax
  8015fd:	83 e8 57             	sub    $0x57,%eax
  801600:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801603:	eb 26                	jmp    80162b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	3c 40                	cmp    $0x40,%al
  80160e:	7e 47                	jle    801657 <strtol+0x16a>
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	0f b6 00             	movzbl (%rax),%eax
  801617:	3c 5a                	cmp    $0x5a,%al
  801619:	7f 3c                	jg     801657 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	0f be c0             	movsbl %al,%eax
  801625:	83 e8 37             	sub    $0x37,%eax
  801628:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80162b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80162e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801631:	7d 23                	jge    801656 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801633:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801638:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80163b:	48 98                	cltq   
  80163d:	48 89 c2             	mov    %rax,%rdx
  801640:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801648:	48 98                	cltq   
  80164a:	48 01 d0             	add    %rdx,%rax
  80164d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801651:	e9 5f ff ff ff       	jmpq   8015b5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801656:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801657:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80165c:	74 0b                	je     801669 <strtol+0x17c>
		*endptr = (char *) s;
  80165e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801662:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801666:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80166d:	74 09                	je     801678 <strtol+0x18b>
  80166f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801673:	48 f7 d8             	neg    %rax
  801676:	eb 04                	jmp    80167c <strtol+0x18f>
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80167c:	c9                   	leaveq 
  80167d:	c3                   	retq   

000000000080167e <strstr>:

char * strstr(const char *in, const char *str)
{
  80167e:	55                   	push   %rbp
  80167f:	48 89 e5             	mov    %rsp,%rbp
  801682:	48 83 ec 30          	sub    $0x30,%rsp
  801686:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80168a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80168e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	88 45 ff             	mov    %al,-0x1(%rbp)
  801698:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  80169d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016a1:	75 06                	jne    8016a9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	eb 68                	jmp    801711 <strstr+0x93>

	len = strlen(str);
  8016a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ad:	48 89 c7             	mov    %rax,%rdi
  8016b0:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  8016b7:	00 00 00 
  8016ba:	ff d0                	callq  *%rax
  8016bc:	48 98                	cltq   
  8016be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8016cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  8016d1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016d5:	75 07                	jne    8016de <strstr+0x60>
				return (char *) 0;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	eb 33                	jmp    801711 <strstr+0x93>
		} while (sc != c);
  8016de:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016e2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016e5:	75 db                	jne    8016c2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8016e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016eb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	48 89 ce             	mov    %rcx,%rsi
  8016f6:	48 89 c7             	mov    %rax,%rdi
  8016f9:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  801700:	00 00 00 
  801703:	ff d0                	callq  *%rax
  801705:	85 c0                	test   %eax,%eax
  801707:	75 b9                	jne    8016c2 <strstr+0x44>

	return (char *) (in - 1);
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	48 83 e8 01          	sub    $0x1,%rax
}
  801711:	c9                   	leaveq 
  801712:	c3                   	retq   
	...

0000000000801714 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	53                   	push   %rbx
  801719:	48 83 ec 58          	sub    $0x58,%rsp
  80171d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801720:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801723:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801727:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80172b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80172f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801733:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801736:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801739:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80173d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801741:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801745:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801749:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80174d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801750:	4c 89 c3             	mov    %r8,%rbx
  801753:	cd 30                	int    $0x30
  801755:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801759:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80175d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801761:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801765:	74 3e                	je     8017a5 <syscall+0x91>
  801767:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80176c:	7e 37                	jle    8017a5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80176e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801772:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801775:	49 89 d0             	mov    %rdx,%r8
  801778:	89 c1                	mov    %eax,%ecx
  80177a:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  801781:	00 00 00 
  801784:	be 23 00 00 00       	mov    $0x23,%esi
  801789:	48 bf 45 4d 80 00 00 	movabs $0x804d45,%rdi
  801790:	00 00 00 
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
  801798:	49 b9 b4 01 80 00 00 	movabs $0x8001b4,%r9
  80179f:	00 00 00 
  8017a2:	41 ff d1             	callq  *%r9

	return ret;
  8017a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017a9:	48 83 c4 58          	add    $0x58,%rsp
  8017ad:	5b                   	pop    %rbx
  8017ae:	5d                   	pop    %rbp
  8017af:	c3                   	retq   

00000000008017b0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 20          	sub    $0x20,%rsp
  8017b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cf:	00 
  8017d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dc:	48 89 d1             	mov    %rdx,%rcx
  8017df:	48 89 c2             	mov    %rax,%rdx
  8017e2:	be 00 00 00 00       	mov    $0x0,%esi
  8017e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ec:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  8017f3:	00 00 00 
  8017f6:	ff d0                	callq  *%rax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801802:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801809:	00 
  80180a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801810:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801816:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181b:	ba 00 00 00 00       	mov    $0x0,%edx
  801820:	be 00 00 00 00       	mov    $0x0,%esi
  801825:	bf 01 00 00 00       	mov    $0x1,%edi
  80182a:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801831:	00 00 00 
  801834:	ff d0                	callq  *%rax
}
  801836:	c9                   	leaveq 
  801837:	c3                   	retq   

0000000000801838 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 20          	sub    $0x20,%rsp
  801840:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801843:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801846:	48 98                	cltq   
  801848:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184f:	00 
  801850:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801856:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801861:	48 89 c2             	mov    %rax,%rdx
  801864:	be 01 00 00 00       	mov    $0x1,%esi
  801869:	bf 03 00 00 00       	mov    $0x3,%edi
  80186e:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801875:	00 00 00 
  801878:	ff d0                	callq  *%rax
}
  80187a:	c9                   	leaveq 
  80187b:	c3                   	retq   

000000000080187c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80187c:	55                   	push   %rbp
  80187d:	48 89 e5             	mov    %rsp,%rbp
  801880:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801884:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188b:	00 
  80188c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801892:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801898:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	be 00 00 00 00       	mov    $0x0,%esi
  8018a7:	bf 02 00 00 00       	mov    $0x2,%edi
  8018ac:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  8018b3:	00 00 00 
  8018b6:	ff d0                	callq  *%rax
}
  8018b8:	c9                   	leaveq 
  8018b9:	c3                   	retq   

00000000008018ba <sys_yield>:

void
sys_yield(void)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c9:	00 
  8018ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018db:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e0:	be 00 00 00 00       	mov    $0x0,%esi
  8018e5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018ea:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 20          	sub    $0x20,%rsp
  801900:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801903:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801907:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80190a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80190d:	48 63 c8             	movslq %eax,%rcx
  801910:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801917:	48 98                	cltq   
  801919:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801920:	00 
  801921:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801927:	49 89 c8             	mov    %rcx,%r8
  80192a:	48 89 d1             	mov    %rdx,%rcx
  80192d:	48 89 c2             	mov    %rax,%rdx
  801930:	be 01 00 00 00       	mov    $0x1,%esi
  801935:	bf 04 00 00 00       	mov    $0x4,%edi
  80193a:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
}
  801946:	c9                   	leaveq 
  801947:	c3                   	retq   

0000000000801948 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801948:	55                   	push   %rbp
  801949:	48 89 e5             	mov    %rsp,%rbp
  80194c:	48 83 ec 30          	sub    $0x30,%rsp
  801950:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801953:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801957:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80195a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80195e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801962:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801965:	48 63 c8             	movslq %eax,%rcx
  801968:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80196c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196f:	48 63 f0             	movslq %eax,%rsi
  801972:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801979:	48 98                	cltq   
  80197b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80197f:	49 89 f9             	mov    %rdi,%r9
  801982:	49 89 f0             	mov    %rsi,%r8
  801985:	48 89 d1             	mov    %rdx,%rcx
  801988:	48 89 c2             	mov    %rax,%rdx
  80198b:	be 01 00 00 00       	mov    $0x1,%esi
  801990:	bf 05 00 00 00       	mov    $0x5,%edi
  801995:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  80199c:	00 00 00 
  80199f:	ff d0                	callq  *%rax
}
  8019a1:	c9                   	leaveq 
  8019a2:	c3                   	retq   

00000000008019a3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	48 83 ec 20          	sub    $0x20,%rsp
  8019ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c2:	00 
  8019c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cf:	48 89 d1             	mov    %rdx,%rcx
  8019d2:	48 89 c2             	mov    %rax,%rdx
  8019d5:	be 01 00 00 00       	mov    $0x1,%esi
  8019da:	bf 06 00 00 00       	mov    $0x6,%edi
  8019df:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	callq  *%rax
}
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 20          	sub    $0x20,%rsp
  8019f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019fe:	48 63 d0             	movslq %eax,%rdx
  801a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a04:	48 98                	cltq   
  801a06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0d:	00 
  801a0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1a:	48 89 d1             	mov    %rdx,%rcx
  801a1d:	48 89 c2             	mov    %rax,%rdx
  801a20:	be 01 00 00 00       	mov    $0x1,%esi
  801a25:	bf 08 00 00 00       	mov    $0x8,%edi
  801a2a:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4e:	48 98                	cltq   
  801a50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a57:	00 
  801a58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a64:	48 89 d1             	mov    %rdx,%rcx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 09 00 00 00       	mov    $0x9,%edi
  801a74:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 20          	sub    $0x20,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a98:	48 98                	cltq   
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	48 89 d1             	mov    %rdx,%rcx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801abe:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 30          	sub    $0x30,%rsp
  801ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801adb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801adf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae5:	48 63 f0             	movslq %eax,%rsi
  801ae8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afc:	00 
  801afd:	49 89 f1             	mov    %rsi,%r9
  801b00:	49 89 c8             	mov    %rcx,%r8
  801b03:	48 89 d1             	mov    %rdx,%rcx
  801b06:	48 89 c2             	mov    %rax,%rdx
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
  801b0e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b13:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801b1a:	00 00 00 
  801b1d:	ff d0                	callq  *%rax
}
  801b1f:	c9                   	leaveq 
  801b20:	c3                   	retq   

0000000000801b21 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b21:	55                   	push   %rbp
  801b22:	48 89 e5             	mov    %rsp,%rbp
  801b25:	48 83 ec 20          	sub    $0x20,%rsp
  801b29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b38:	00 
  801b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b57:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b74:	00 
  801b75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	be 00 00 00 00       	mov    $0x0,%esi
  801b90:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b95:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 30          	sub    $0x30,%rsp
  801bab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bb5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bbd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc0:	48 63 c8             	movslq %eax,%rcx
  801bc3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bca:	48 63 f0             	movslq %eax,%rsi
  801bcd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd4:	48 98                	cltq   
  801bd6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bda:	49 89 f9             	mov    %rdi,%r9
  801bdd:	49 89 f0             	mov    %rsi,%r8
  801be0:	48 89 d1             	mov    %rdx,%rcx
  801be3:	48 89 c2             	mov    %rax,%rdx
  801be6:	be 00 00 00 00       	mov    $0x0,%esi
  801beb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bf0:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 20          	sub    $0x20,%rsp
  801c06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1d:	00 
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	48 89 d1             	mov    %rdx,%rcx
  801c2d:	48 89 c2             	mov    %rax,%rdx
  801c30:	be 00 00 00 00       	mov    $0x0,%esi
  801c35:	bf 10 00 00 00       	mov    $0x10,%edi
  801c3a:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
}
  801c46:	c9                   	leaveq 
  801c47:	c3                   	retq   

0000000000801c48 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 08          	sub    $0x8,%rsp
  801c50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c58:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c5f:	ff ff ff 
  801c62:	48 01 d0             	add    %rdx,%rax
  801c65:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c69:	c9                   	leaveq 
  801c6a:	c3                   	retq   

0000000000801c6b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c6b:	55                   	push   %rbp
  801c6c:	48 89 e5             	mov    %rsp,%rbp
  801c6f:	48 83 ec 08          	sub    $0x8,%rsp
  801c73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c7b:	48 89 c7             	mov    %rax,%rdi
  801c7e:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
  801c8a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c90:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c94:	c9                   	leaveq 
  801c95:	c3                   	retq   

0000000000801c96 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c96:	55                   	push   %rbp
  801c97:	48 89 e5             	mov    %rsp,%rbp
  801c9a:	48 83 ec 18          	sub    $0x18,%rsp
  801c9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ca2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ca9:	eb 6b                	jmp    801d16 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cae:	48 98                	cltq   
  801cb0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cb6:	48 c1 e0 0c          	shl    $0xc,%rax
  801cba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc2:	48 89 c2             	mov    %rax,%rdx
  801cc5:	48 c1 ea 15          	shr    $0x15,%rdx
  801cc9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cd0:	01 00 00 
  801cd3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd7:	83 e0 01             	and    $0x1,%eax
  801cda:	48 85 c0             	test   %rax,%rax
  801cdd:	74 21                	je     801d00 <fd_alloc+0x6a>
  801cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce3:	48 89 c2             	mov    %rax,%rdx
  801ce6:	48 c1 ea 0c          	shr    $0xc,%rdx
  801cea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cf1:	01 00 00 
  801cf4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cf8:	83 e0 01             	and    $0x1,%eax
  801cfb:	48 85 c0             	test   %rax,%rax
  801cfe:	75 12                	jne    801d12 <fd_alloc+0x7c>
			*fd_store = fd;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d08:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	eb 1a                	jmp    801d2c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d12:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d16:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d1a:	7e 8f                	jle    801cab <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d20:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d27:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d2c:	c9                   	leaveq 
  801d2d:	c3                   	retq   

0000000000801d2e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 83 ec 20          	sub    $0x20,%rsp
  801d36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d41:	78 06                	js     801d49 <fd_lookup+0x1b>
  801d43:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d47:	7e 07                	jle    801d50 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d4e:	eb 6c                	jmp    801dbc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d5b:	48 c1 e0 0c          	shl    $0xc,%rax
  801d5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d67:	48 89 c2             	mov    %rax,%rdx
  801d6a:	48 c1 ea 15          	shr    $0x15,%rdx
  801d6e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d75:	01 00 00 
  801d78:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d7c:	83 e0 01             	and    $0x1,%eax
  801d7f:	48 85 c0             	test   %rax,%rax
  801d82:	74 21                	je     801da5 <fd_lookup+0x77>
  801d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d88:	48 89 c2             	mov    %rax,%rdx
  801d8b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d96:	01 00 00 
  801d99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9d:	83 e0 01             	and    $0x1,%eax
  801da0:	48 85 c0             	test   %rax,%rax
  801da3:	75 07                	jne    801dac <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801da5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801daa:	eb 10                	jmp    801dbc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801dac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801db4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	c9                   	leaveq 
  801dbd:	c3                   	retq   

0000000000801dbe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801dbe:	55                   	push   %rbp
  801dbf:	48 89 e5             	mov    %rsp,%rbp
  801dc2:	48 83 ec 30          	sub    $0x30,%rsp
  801dc6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dca:	89 f0                	mov    %esi,%eax
  801dcc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd3:	48 89 c7             	mov    %rax,%rdi
  801dd6:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  801ddd:	00 00 00 
  801de0:	ff d0                	callq  *%rax
  801de2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801de6:	48 89 d6             	mov    %rdx,%rsi
  801de9:	89 c7                	mov    %eax,%edi
  801deb:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
  801df7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dfe:	78 0a                	js     801e0a <fd_close+0x4c>
	    || fd != fd2)
  801e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e04:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e08:	74 12                	je     801e1c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e0a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e0e:	74 05                	je     801e15 <fd_close+0x57>
  801e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e13:	eb 05                	jmp    801e1a <fd_close+0x5c>
  801e15:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1a:	eb 69                	jmp    801e85 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e20:	8b 00                	mov    (%rax),%eax
  801e22:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e26:	48 89 d6             	mov    %rdx,%rsi
  801e29:	89 c7                	mov    %eax,%edi
  801e2b:	48 b8 87 1e 80 00 00 	movabs $0x801e87,%rax
  801e32:	00 00 00 
  801e35:	ff d0                	callq  *%rax
  801e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3e:	78 2a                	js     801e6a <fd_close+0xac>
		if (dev->dev_close)
  801e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e44:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e48:	48 85 c0             	test   %rax,%rax
  801e4b:	74 16                	je     801e63 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e51:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801e55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e59:	48 89 c7             	mov    %rax,%rdi
  801e5c:	ff d2                	callq  *%rdx
  801e5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e61:	eb 07                	jmp    801e6a <fd_close+0xac>
		else
			r = 0;
  801e63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6e:	48 89 c6             	mov    %rax,%rsi
  801e71:	bf 00 00 00 00       	mov    $0x0,%edi
  801e76:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	callq  *%rax
	return r;
  801e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e85:	c9                   	leaveq 
  801e86:	c3                   	retq   

0000000000801e87 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e87:	55                   	push   %rbp
  801e88:	48 89 e5             	mov    %rsp,%rbp
  801e8b:	48 83 ec 20          	sub    $0x20,%rsp
  801e8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e9d:	eb 41                	jmp    801ee0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e9f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ea6:	00 00 00 
  801ea9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eac:	48 63 d2             	movslq %edx,%rdx
  801eaf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb3:	8b 00                	mov    (%rax),%eax
  801eb5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801eb8:	75 22                	jne    801edc <dev_lookup+0x55>
			*dev = devtab[i];
  801eba:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ec1:	00 00 00 
  801ec4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec7:	48 63 d2             	movslq %edx,%rdx
  801eca:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ece:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	eb 60                	jmp    801f3c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801edc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ee0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ee7:	00 00 00 
  801eea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eed:	48 63 d2             	movslq %edx,%rdx
  801ef0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef4:	48 85 c0             	test   %rax,%rax
  801ef7:	75 a6                	jne    801e9f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ef9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f00:	00 00 00 
  801f03:	48 8b 00             	mov    (%rax),%rax
  801f06:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f0c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f0f:	89 c6                	mov    %eax,%esi
  801f11:	48 bf 58 4d 80 00 00 	movabs $0x804d58,%rdi
  801f18:	00 00 00 
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801f27:	00 00 00 
  801f2a:	ff d1                	callq  *%rcx
	*dev = 0;
  801f2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f30:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <close>:

int
close(int fdnum)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 20          	sub    $0x20,%rsp
  801f46:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f49:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f50:	48 89 d6             	mov    %rdx,%rsi
  801f53:	89 c7                	mov    %eax,%edi
  801f55:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
  801f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f68:	79 05                	jns    801f6f <close+0x31>
		return r;
  801f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6d:	eb 18                	jmp    801f87 <close+0x49>
	else
		return fd_close(fd, 1);
  801f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f73:	be 01 00 00 00       	mov    $0x1,%esi
  801f78:	48 89 c7             	mov    %rax,%rdi
  801f7b:	48 b8 be 1d 80 00 00 	movabs $0x801dbe,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
}
  801f87:	c9                   	leaveq 
  801f88:	c3                   	retq   

0000000000801f89 <close_all>:

void
close_all(void)
{
  801f89:	55                   	push   %rbp
  801f8a:	48 89 e5             	mov    %rsp,%rbp
  801f8d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f98:	eb 15                	jmp    801faf <close_all+0x26>
		close(i);
  801f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9d:	89 c7                	mov    %eax,%edi
  801f9f:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801faf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fb3:	7e e5                	jle    801f9a <close_all+0x11>
		close(i);
}
  801fb5:	c9                   	leaveq 
  801fb6:	c3                   	retq   

0000000000801fb7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fb7:	55                   	push   %rbp
  801fb8:	48 89 e5             	mov    %rsp,%rbp
  801fbb:	48 83 ec 40          	sub    $0x40,%rsp
  801fbf:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fc2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fc5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fc9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fcc:	48 89 d6             	mov    %rdx,%rsi
  801fcf:	89 c7                	mov    %eax,%edi
  801fd1:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
  801fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fe4:	79 08                	jns    801fee <dup+0x37>
		return r;
  801fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe9:	e9 70 01 00 00       	jmpq   80215e <dup+0x1a7>
	close(newfdnum);
  801fee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ff1:	89 c7                	mov    %eax,%edi
  801ff3:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fff:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802002:	48 98                	cltq   
  802004:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80200a:	48 c1 e0 0c          	shl    $0xc,%rax
  80200e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802016:	48 89 c7             	mov    %rax,%rdi
  802019:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
  802025:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202d:	48 89 c7             	mov    %rax,%rdi
  802030:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
  80203c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802044:	48 89 c2             	mov    %rax,%rdx
  802047:	48 c1 ea 15          	shr    $0x15,%rdx
  80204b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802052:	01 00 00 
  802055:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802059:	83 e0 01             	and    $0x1,%eax
  80205c:	84 c0                	test   %al,%al
  80205e:	74 71                	je     8020d1 <dup+0x11a>
  802060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802064:	48 89 c2             	mov    %rax,%rdx
  802067:	48 c1 ea 0c          	shr    $0xc,%rdx
  80206b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802072:	01 00 00 
  802075:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802079:	83 e0 01             	and    $0x1,%eax
  80207c:	84 c0                	test   %al,%al
  80207e:	74 51                	je     8020d1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 89 c2             	mov    %rax,%rdx
  802087:	48 c1 ea 0c          	shr    $0xc,%rdx
  80208b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802092:	01 00 00 
  802095:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802099:	89 c1                	mov    %eax,%ecx
  80209b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8020a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a9:	41 89 c8             	mov    %ecx,%r8d
  8020ac:	48 89 d1             	mov    %rdx,%rcx
  8020af:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b4:	48 89 c6             	mov    %rax,%rsi
  8020b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020bc:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  8020c3:	00 00 00 
  8020c6:	ff d0                	callq  *%rax
  8020c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020cf:	78 56                	js     802127 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d5:	48 89 c2             	mov    %rax,%rdx
  8020d8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8020dc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e3:	01 00 00 
  8020e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ea:	89 c1                	mov    %eax,%ecx
  8020ec:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8020f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020fa:	41 89 c8             	mov    %ecx,%r8d
  8020fd:	48 89 d1             	mov    %rdx,%rcx
  802100:	ba 00 00 00 00       	mov    $0x0,%edx
  802105:	48 89 c6             	mov    %rax,%rsi
  802108:	bf 00 00 00 00       	mov    $0x0,%edi
  80210d:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
  802119:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802120:	78 08                	js     80212a <dup+0x173>
		goto err;

	return newfdnum;
  802122:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802125:	eb 37                	jmp    80215e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802127:	90                   	nop
  802128:	eb 01                	jmp    80212b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80212a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80212b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212f:	48 89 c6             	mov    %rax,%rsi
  802132:	bf 00 00 00 00       	mov    $0x0,%edi
  802137:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802147:	48 89 c6             	mov    %rax,%rsi
  80214a:	bf 00 00 00 00       	mov    $0x0,%edi
  80214f:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax
	return r;
  80215b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80215e:	c9                   	leaveq 
  80215f:	c3                   	retq   

0000000000802160 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	48 83 ec 40          	sub    $0x40,%rsp
  802168:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80216b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80216f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802173:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802177:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80217a:	48 89 d6             	mov    %rdx,%rsi
  80217d:	89 c7                	mov    %eax,%edi
  80217f:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  802186:	00 00 00 
  802189:	ff d0                	callq  *%rax
  80218b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802192:	78 24                	js     8021b8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802198:	8b 00                	mov    (%rax),%eax
  80219a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80219e:	48 89 d6             	mov    %rdx,%rsi
  8021a1:	89 c7                	mov    %eax,%edi
  8021a3:	48 b8 87 1e 80 00 00 	movabs $0x801e87,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax
  8021af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b6:	79 05                	jns    8021bd <read+0x5d>
		return r;
  8021b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bb:	eb 7a                	jmp    802237 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c1:	8b 40 08             	mov    0x8(%rax),%eax
  8021c4:	83 e0 03             	and    $0x3,%eax
  8021c7:	83 f8 01             	cmp    $0x1,%eax
  8021ca:	75 3a                	jne    802206 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021cc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021d3:	00 00 00 
  8021d6:	48 8b 00             	mov    (%rax),%rax
  8021d9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021e2:	89 c6                	mov    %eax,%esi
  8021e4:	48 bf 77 4d 80 00 00 	movabs $0x804d77,%rdi
  8021eb:	00 00 00 
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f3:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  8021fa:	00 00 00 
  8021fd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802204:	eb 31                	jmp    802237 <read+0xd7>
	}
	if (!dev->dev_read)
  802206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80220e:	48 85 c0             	test   %rax,%rax
  802211:	75 07                	jne    80221a <read+0xba>
		return -E_NOT_SUPP;
  802213:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802218:	eb 1d                	jmp    802237 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80221a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80221e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80222a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80222e:	48 89 ce             	mov    %rcx,%rsi
  802231:	48 89 c7             	mov    %rax,%rdi
  802234:	41 ff d0             	callq  *%r8
}
  802237:	c9                   	leaveq 
  802238:	c3                   	retq   

0000000000802239 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802239:	55                   	push   %rbp
  80223a:	48 89 e5             	mov    %rsp,%rbp
  80223d:	48 83 ec 30          	sub    $0x30,%rsp
  802241:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802244:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802248:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80224c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802253:	eb 46                	jmp    80229b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802258:	48 98                	cltq   
  80225a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80225e:	48 29 c2             	sub    %rax,%rdx
  802261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802264:	48 98                	cltq   
  802266:	48 89 c1             	mov    %rax,%rcx
  802269:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80226d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802270:	48 89 ce             	mov    %rcx,%rsi
  802273:	89 c7                	mov    %eax,%edi
  802275:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802284:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802288:	79 05                	jns    80228f <readn+0x56>
			return m;
  80228a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80228d:	eb 1d                	jmp    8022ac <readn+0x73>
		if (m == 0)
  80228f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802293:	74 13                	je     8022a8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802295:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802298:	01 45 fc             	add    %eax,-0x4(%rbp)
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229e:	48 98                	cltq   
  8022a0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022a4:	72 af                	jb     802255 <readn+0x1c>
  8022a6:	eb 01                	jmp    8022a9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8022a8:	90                   	nop
	}
	return tot;
  8022a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ac:	c9                   	leaveq 
  8022ad:	c3                   	retq   

00000000008022ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022ae:	55                   	push   %rbp
  8022af:	48 89 e5             	mov    %rsp,%rbp
  8022b2:	48 83 ec 40          	sub    $0x40,%rsp
  8022b6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022bd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c8:	48 89 d6             	mov    %rdx,%rsi
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	78 24                	js     802306 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	8b 00                	mov    (%rax),%eax
  8022e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ec:	48 89 d6             	mov    %rdx,%rsi
  8022ef:	89 c7                	mov    %eax,%edi
  8022f1:	48 b8 87 1e 80 00 00 	movabs $0x801e87,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	callq  *%rax
  8022fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802304:	79 05                	jns    80230b <write+0x5d>
		return r;
  802306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802309:	eb 79                	jmp    802384 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230f:	8b 40 08             	mov    0x8(%rax),%eax
  802312:	83 e0 03             	and    $0x3,%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	75 3a                	jne    802353 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802319:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802320:	00 00 00 
  802323:	48 8b 00             	mov    (%rax),%rax
  802326:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80232c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232f:	89 c6                	mov    %eax,%esi
  802331:	48 bf 93 4d 80 00 00 	movabs $0x804d93,%rdi
  802338:	00 00 00 
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  802347:	00 00 00 
  80234a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80234c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802351:	eb 31                	jmp    802384 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802357:	48 8b 40 18          	mov    0x18(%rax),%rax
  80235b:	48 85 c0             	test   %rax,%rax
  80235e:	75 07                	jne    802367 <write+0xb9>
		return -E_NOT_SUPP;
  802360:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802365:	eb 1d                	jmp    802384 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80236f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802373:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802377:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80237b:	48 89 ce             	mov    %rcx,%rsi
  80237e:	48 89 c7             	mov    %rax,%rdi
  802381:	41 ff d0             	callq  *%r8
}
  802384:	c9                   	leaveq 
  802385:	c3                   	retq   

0000000000802386 <seek>:

int
seek(int fdnum, off_t offset)
{
  802386:	55                   	push   %rbp
  802387:	48 89 e5             	mov    %rsp,%rbp
  80238a:	48 83 ec 18          	sub    $0x18,%rsp
  80238e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802391:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802394:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802398:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80239b:	48 89 d6             	mov    %rdx,%rsi
  80239e:	89 c7                	mov    %eax,%edi
  8023a0:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8023a7:	00 00 00 
  8023aa:	ff d0                	callq  *%rax
  8023ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b3:	79 05                	jns    8023ba <seek+0x34>
		return r;
  8023b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b8:	eb 0f                	jmp    8023c9 <seek+0x43>
	fd->fd_offset = offset;
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023c1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c9:	c9                   	leaveq 
  8023ca:	c3                   	retq   

00000000008023cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	48 83 ec 30          	sub    $0x30,%rsp
  8023d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	78 24                	js     80241e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	8b 00                	mov    (%rax),%eax
  802400:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802404:	48 89 d6             	mov    %rdx,%rsi
  802407:	89 c7                	mov    %eax,%edi
  802409:	48 b8 87 1e 80 00 00 	movabs $0x801e87,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241c:	79 05                	jns    802423 <ftruncate+0x58>
		return r;
  80241e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802421:	eb 72                	jmp    802495 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802427:	8b 40 08             	mov    0x8(%rax),%eax
  80242a:	83 e0 03             	and    $0x3,%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	75 3a                	jne    80246b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802431:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802438:	00 00 00 
  80243b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80243e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802444:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802447:	89 c6                	mov    %eax,%esi
  802449:	48 bf b0 4d 80 00 00 	movabs $0x804db0,%rdi
  802450:	00 00 00 
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  80245f:	00 00 00 
  802462:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802464:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802469:	eb 2a                	jmp    802495 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802473:	48 85 c0             	test   %rax,%rax
  802476:	75 07                	jne    80247f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802478:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80247d:	eb 16                	jmp    802495 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80247f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802483:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80248e:	89 d6                	mov    %edx,%esi
  802490:	48 89 c7             	mov    %rax,%rdi
  802493:	ff d1                	callq  *%rcx
}
  802495:	c9                   	leaveq 
  802496:	c3                   	retq   

0000000000802497 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802497:	55                   	push   %rbp
  802498:	48 89 e5             	mov    %rsp,%rbp
  80249b:	48 83 ec 30          	sub    $0x30,%rsp
  80249f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ad:	48 89 d6             	mov    %rdx,%rsi
  8024b0:	89 c7                	mov    %eax,%edi
  8024b2:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	callq  *%rax
  8024be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c5:	78 24                	js     8024eb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cb:	8b 00                	mov    (%rax),%eax
  8024cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d1:	48 89 d6             	mov    %rdx,%rsi
  8024d4:	89 c7                	mov    %eax,%edi
  8024d6:	48 b8 87 1e 80 00 00 	movabs $0x801e87,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	callq  *%rax
  8024e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e9:	79 05                	jns    8024f0 <fstat+0x59>
		return r;
  8024eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ee:	eb 5e                	jmp    80254e <fstat+0xb7>
	if (!dev->dev_stat)
  8024f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024f8:	48 85 c0             	test   %rax,%rax
  8024fb:	75 07                	jne    802504 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802502:	eb 4a                	jmp    80254e <fstat+0xb7>
	stat->st_name[0] = 0;
  802504:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802508:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80250b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80250f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802516:	00 00 00 
	stat->st_isdir = 0;
  802519:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80251d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802524:	00 00 00 
	stat->st_dev = dev;
  802527:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80252b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80252f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80253e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802542:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802546:	48 89 d6             	mov    %rdx,%rsi
  802549:	48 89 c7             	mov    %rax,%rdi
  80254c:	ff d1                	callq  *%rcx
}
  80254e:	c9                   	leaveq 
  80254f:	c3                   	retq   

0000000000802550 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802550:	55                   	push   %rbp
  802551:	48 89 e5             	mov    %rsp,%rbp
  802554:	48 83 ec 20          	sub    $0x20,%rsp
  802558:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80255c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802564:	be 00 00 00 00       	mov    $0x0,%esi
  802569:	48 89 c7             	mov    %rax,%rdi
  80256c:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257f:	79 05                	jns    802586 <stat+0x36>
		return fd;
  802581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802584:	eb 2f                	jmp    8025b5 <stat+0x65>
	r = fstat(fd, stat);
  802586:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80258a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258d:	48 89 d6             	mov    %rdx,%rsi
  802590:	89 c7                	mov    %eax,%edi
  802592:	48 b8 97 24 80 00 00 	movabs $0x802497,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
  80259e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a4:	89 c7                	mov    %eax,%edi
  8025a6:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  8025ad:	00 00 00 
  8025b0:	ff d0                	callq  *%rax
	return r;
  8025b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025b5:	c9                   	leaveq 
  8025b6:	c3                   	retq   
	...

00000000008025b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025b8:	55                   	push   %rbp
  8025b9:	48 89 e5             	mov    %rsp,%rbp
  8025bc:	48 83 ec 10          	sub    $0x10,%rsp
  8025c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025ce:	00 00 00 
  8025d1:	8b 00                	mov    (%rax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	75 1d                	jne    8025f4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8025dc:	48 b8 96 46 80 00 00 	movabs $0x804696,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
  8025e8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025ef:	00 00 00 
  8025f2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025fb:	00 00 00 
  8025fe:	8b 00                	mov    (%rax),%eax
  802600:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802603:	b9 07 00 00 00       	mov    $0x7,%ecx
  802608:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80260f:	00 00 00 
  802612:	89 c7                	mov    %eax,%edi
  802614:	48 b8 e7 45 80 00 00 	movabs $0x8045e7,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	ba 00 00 00 00       	mov    $0x0,%edx
  802629:	48 89 c6             	mov    %rax,%rsi
  80262c:	bf 00 00 00 00       	mov    $0x0,%edi
  802631:	48 b8 00 45 80 00 00 	movabs $0x804500,%rax
  802638:	00 00 00 
  80263b:	ff d0                	callq  *%rax
}
  80263d:	c9                   	leaveq 
  80263e:	c3                   	retq   

000000000080263f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
  802643:	48 83 ec 20          	sub    $0x20,%rsp
  802647:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	48 89 c7             	mov    %rax,%rdi
  802655:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
  802661:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802666:	7e 0a                	jle    802672 <open+0x33>
		return -E_BAD_PATH;
  802668:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80266d:	e9 a5 00 00 00       	jmpq   802717 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802672:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802676:	48 89 c7             	mov    %rax,%rdi
  802679:	48 b8 96 1c 80 00 00 	movabs $0x801c96,%rax
  802680:	00 00 00 
  802683:	ff d0                	callq  *%rax
  802685:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802688:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268c:	79 08                	jns    802696 <open+0x57>
		return r;
  80268e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802691:	e9 81 00 00 00       	jmpq   802717 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802696:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80269d:	00 00 00 
  8026a0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026a3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8026a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ad:	48 89 c6             	mov    %rax,%rsi
  8026b0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8026b7:	00 00 00 
  8026ba:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  8026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ca:	48 89 c6             	mov    %rax,%rsi
  8026cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8026d2:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
  8026de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8026e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e5:	79 1d                	jns    802704 <open+0xc5>
		fd_close(new_fd, 0);
  8026e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026eb:	be 00 00 00 00       	mov    $0x0,%esi
  8026f0:	48 89 c7             	mov    %rax,%rdi
  8026f3:	48 b8 be 1d 80 00 00 	movabs $0x801dbe,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax
		return r;	
  8026ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802702:	eb 13                	jmp    802717 <open+0xd8>
	}
	return fd2num(new_fd);
  802704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802708:	48 89 c7             	mov    %rax,%rdi
  80270b:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  802712:	00 00 00 
  802715:	ff d0                	callq  *%rax
}
  802717:	c9                   	leaveq 
  802718:	c3                   	retq   

0000000000802719 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802719:	55                   	push   %rbp
  80271a:	48 89 e5             	mov    %rsp,%rbp
  80271d:	48 83 ec 10          	sub    $0x10,%rsp
  802721:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802729:	8b 50 0c             	mov    0xc(%rax),%edx
  80272c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802733:	00 00 00 
  802736:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802738:	be 00 00 00 00       	mov    $0x0,%esi
  80273d:	bf 06 00 00 00       	mov    $0x6,%edi
  802742:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
}
  80274e:	c9                   	leaveq 
  80274f:	c3                   	retq   

0000000000802750 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802750:	55                   	push   %rbp
  802751:	48 89 e5             	mov    %rsp,%rbp
  802754:	48 83 ec 30          	sub    $0x30,%rsp
  802758:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80275c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802760:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802768:	8b 50 0c             	mov    0xc(%rax),%edx
  80276b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802772:	00 00 00 
  802775:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802777:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80277e:	00 00 00 
  802781:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802785:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802789:	be 00 00 00 00       	mov    $0x0,%esi
  80278e:	bf 03 00 00 00       	mov    $0x3,%edi
  802793:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	7e 23                	jle    8027cb <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	48 63 d0             	movslq %eax,%rdx
  8027ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027b9:	00 00 00 
  8027bc:	48 89 c7             	mov    %rax,%rdi
  8027bf:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
	}
	return nbytes;
  8027cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027ce:	c9                   	leaveq 
  8027cf:	c3                   	retq   

00000000008027d0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027d0:	55                   	push   %rbp
  8027d1:	48 89 e5             	mov    %rsp,%rbp
  8027d4:	48 83 ec 20          	sub    $0x20,%rsp
  8027d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ee:	00 00 00 
  8027f1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027f3:	be 00 00 00 00       	mov    $0x0,%esi
  8027f8:	bf 05 00 00 00       	mov    $0x5,%edi
  8027fd:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  802804:	00 00 00 
  802807:	ff d0                	callq  *%rax
  802809:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802810:	79 05                	jns    802817 <devfile_stat+0x47>
		return r;
  802812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802815:	eb 56                	jmp    80286d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802822:	00 00 00 
  802825:	48 89 c7             	mov    %rax,%rdi
  802828:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  80282f:	00 00 00 
  802832:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802834:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283b:	00 00 00 
  80283e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802844:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802848:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80284e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802855:	00 00 00 
  802858:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80285e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802862:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286d:	c9                   	leaveq 
  80286e:	c3                   	retq   
	...

0000000000802870 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802870:	55                   	push   %rbp
  802871:	48 89 e5             	mov    %rsp,%rbp
  802874:	53                   	push   %rbx
  802875:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  80287c:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  802883:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80288a:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802891:	be 00 00 00 00       	mov    $0x0,%esi
  802896:	48 89 c7             	mov    %rax,%rdi
  802899:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	callq  *%rax
  8028a5:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8028a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8028ac:	79 08                	jns    8028b6 <spawn+0x46>
		return r;
  8028ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8028b1:	e9 23 03 00 00       	jmpq   802bd9 <spawn+0x369>
	fd = r;
  8028b6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8028b9:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8028bc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  8028c3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8028c7:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  8028ce:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8028d1:	ba 00 02 00 00       	mov    $0x200,%edx
  8028d6:	48 89 ce             	mov    %rcx,%rsi
  8028d9:	89 c7                	mov    %eax,%edi
  8028db:	48 b8 39 22 80 00 00 	movabs $0x802239,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
  8028e7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8028ec:	75 0d                	jne    8028fb <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  8028ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028f2:	8b 00                	mov    (%rax),%eax
  8028f4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8028f9:	74 43                	je     80293e <spawn+0xce>
		close(fd);
  8028fb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8028fe:	89 c7                	mov    %eax,%edi
  802900:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80290c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802910:	8b 00                	mov    (%rax),%eax
  802912:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802917:	89 c6                	mov    %eax,%esi
  802919:	48 bf d8 4d 80 00 00 	movabs $0x804dd8,%rdi
  802920:	00 00 00 
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  80292f:	00 00 00 
  802932:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802939:	e9 9b 02 00 00       	jmpq   802bd9 <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80293e:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  802945:	00 00 00 
  802948:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  80294e:	cd 30                	int    $0x30
  802950:	89 c3                	mov    %eax,%ebx
  802952:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802955:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802958:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80295b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80295f:	79 08                	jns    802969 <spawn+0xf9>
		return r;
  802961:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802964:	e9 70 02 00 00       	jmpq   802bd9 <spawn+0x369>
	child = r;
  802969:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80296c:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80296f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802972:	25 ff 03 00 00       	and    $0x3ff,%eax
  802977:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80297e:	00 00 00 
  802981:	48 63 d0             	movslq %eax,%rdx
  802984:	48 89 d0             	mov    %rdx,%rax
  802987:	48 c1 e0 02          	shl    $0x2,%rax
  80298b:	48 01 d0             	add    %rdx,%rax
  80298e:	48 01 c0             	add    %rax,%rax
  802991:	48 01 d0             	add    %rdx,%rax
  802994:	48 c1 e0 05          	shl    $0x5,%rax
  802998:	48 01 c8             	add    %rcx,%rax
  80299b:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8029a2:	48 89 c6             	mov    %rax,%rsi
  8029a5:	b8 18 00 00 00       	mov    $0x18,%eax
  8029aa:	48 89 d7             	mov    %rdx,%rdi
  8029ad:	48 89 c1             	mov    %rax,%rcx
  8029b0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8029b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029bb:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8029c2:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  8029c9:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8029d0:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  8029d7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8029da:	48 89 ce             	mov    %rcx,%rsi
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
  8029eb:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8029ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8029f2:	79 08                	jns    8029fc <spawn+0x18c>
		return r;
  8029f4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8029f7:	e9 dd 01 00 00       	jmpq   802bd9 <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8029fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a00:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a04:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  802a0b:	48 01 d0             	add    %rdx,%rax
  802a0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802a19:	eb 7a                	jmp    802a95 <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  802a1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1f:	8b 00                	mov    (%rax),%eax
  802a21:	83 f8 01             	cmp    $0x1,%eax
  802a24:	75 65                	jne    802a8b <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  802a26:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a31:	8b 40 04             	mov    0x4(%rax),%eax
  802a34:	83 e0 02             	and    $0x2,%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 04                	je     802a3f <spawn+0x1cf>
			perm |= PTE_W;
  802a3b:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802a3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a43:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a47:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a4e:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a56:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802a5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5e:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802a62:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a68:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a6b:	89 3c 24             	mov    %edi,(%rsp)
  802a6e:	89 c7                	mov    %eax,%edi
  802a70:	48 b8 a1 30 80 00 00 	movabs $0x8030a1,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802a7f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802a83:	0f 88 2a 01 00 00    	js     802bb3 <spawn+0x343>
  802a89:	eb 01                	jmp    802a8c <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802a8b:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a8c:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802a90:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  802a95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a99:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802a9d:	0f b7 c0             	movzwl %ax,%eax
  802aa0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802aa3:	0f 8f 72 ff ff ff    	jg     802a1b <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802aa9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802aac:	89 c7                	mov    %eax,%edi
  802aae:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
	fd = -1;
  802aba:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802ac1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 88 32 80 00 00 	movabs $0x803288,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
  802ad2:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802ad5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ad9:	79 30                	jns    802b0b <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  802adb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ade:	89 c1                	mov    %eax,%ecx
  802ae0:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  802ae7:	00 00 00 
  802aea:	be 82 00 00 00       	mov    $0x82,%esi
  802aef:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  802af6:	00 00 00 
  802af9:	b8 00 00 00 00       	mov    $0x0,%eax
  802afe:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  802b05:	00 00 00 
  802b08:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b0b:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802b12:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b15:	48 89 d6             	mov    %rdx,%rsi
  802b18:	89 c7                	mov    %eax,%edi
  802b1a:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
  802b26:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b2d:	79 30                	jns    802b5f <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  802b2f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b32:	89 c1                	mov    %eax,%ecx
  802b34:	48 ba 14 4e 80 00 00 	movabs $0x804e14,%rdx
  802b3b:	00 00 00 
  802b3e:	be 85 00 00 00       	mov    $0x85,%esi
  802b43:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  802b4a:	00 00 00 
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  802b59:	00 00 00 
  802b5c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b5f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b62:	be 02 00 00 00       	mov    $0x2,%esi
  802b67:	89 c7                	mov    %eax,%edi
  802b69:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b78:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b7c:	79 30                	jns    802bae <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  802b7e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b81:	89 c1                	mov    %eax,%ecx
  802b83:	48 ba 2e 4e 80 00 00 	movabs $0x804e2e,%rdx
  802b8a:	00 00 00 
  802b8d:	be 88 00 00 00       	mov    $0x88,%esi
  802b92:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  802b99:	00 00 00 
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba1:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  802ba8:	00 00 00 
  802bab:	41 ff d0             	callq  *%r8

	return child;
  802bae:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802bb1:	eb 26                	jmp    802bd9 <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802bb3:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802bb4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802bb7:	89 c7                	mov    %eax,%edi
  802bb9:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	callq  *%rax
	close(fd);
  802bc5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bc8:	89 c7                	mov    %eax,%edi
  802bca:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	return r;
  802bd6:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  802bd9:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  802be0:	5b                   	pop    %rbx
  802be1:	5d                   	pop    %rbp
  802be2:	c3                   	retq   

0000000000802be3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802be3:	55                   	push   %rbp
  802be4:	48 89 e5             	mov    %rsp,%rbp
  802be7:	53                   	push   %rbx
  802be8:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  802bef:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802bf6:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  802bfd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802c04:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802c0b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802c12:	84 c0                	test   %al,%al
  802c14:	74 23                	je     802c39 <spawnl+0x56>
  802c16:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802c1d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802c21:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802c25:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802c29:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802c2d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802c31:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802c35:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802c39:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802c40:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  802c47:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802c4a:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802c51:	00 00 00 
  802c54:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802c5b:	00 00 00 
  802c5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c62:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802c69:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802c70:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802c77:	eb 07                	jmp    802c80 <spawnl+0x9d>
		argc++;
  802c79:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802c80:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802c86:	83 f8 30             	cmp    $0x30,%eax
  802c89:	73 23                	jae    802cae <spawnl+0xcb>
  802c8b:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802c92:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802c98:	89 c0                	mov    %eax,%eax
  802c9a:	48 01 d0             	add    %rdx,%rax
  802c9d:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802ca3:	83 c2 08             	add    $0x8,%edx
  802ca6:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802cac:	eb 15                	jmp    802cc3 <spawnl+0xe0>
  802cae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802cb5:	48 89 d0             	mov    %rdx,%rax
  802cb8:	48 83 c2 08          	add    $0x8,%rdx
  802cbc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802cc3:	48 8b 00             	mov    (%rax),%rax
  802cc6:	48 85 c0             	test   %rax,%rax
  802cc9:	75 ae                	jne    802c79 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ccb:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802cd1:	83 c0 02             	add    $0x2,%eax
  802cd4:	48 89 e2             	mov    %rsp,%rdx
  802cd7:	48 89 d3             	mov    %rdx,%rbx
  802cda:	48 63 d0             	movslq %eax,%rdx
  802cdd:	48 83 ea 01          	sub    $0x1,%rdx
  802ce1:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  802ce8:	48 98                	cltq   
  802cea:	48 c1 e0 03          	shl    $0x3,%rax
  802cee:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  802cf2:	b8 10 00 00 00       	mov    $0x10,%eax
  802cf7:	48 83 e8 01          	sub    $0x1,%rax
  802cfb:	48 01 d0             	add    %rdx,%rax
  802cfe:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  802d05:	10 00 00 00 
  802d09:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0e:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  802d15:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802d19:	48 29 c4             	sub    %rax,%rsp
  802d1c:	48 89 e0             	mov    %rsp,%rax
  802d1f:	48 83 c0 0f          	add    $0xf,%rax
  802d23:	48 c1 e8 04          	shr    $0x4,%rax
  802d27:	48 c1 e0 04          	shl    $0x4,%rax
  802d2b:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  802d32:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802d39:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  802d40:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802d43:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802d49:	8d 50 01             	lea    0x1(%rax),%edx
  802d4c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802d53:	48 63 d2             	movslq %edx,%rdx
  802d56:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802d5d:	00 

	va_start(vl, arg0);
  802d5e:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802d65:	00 00 00 
  802d68:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802d6f:	00 00 00 
  802d72:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d76:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802d7d:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802d84:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802d8b:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  802d92:	00 00 00 
  802d95:	eb 63                	jmp    802dfa <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  802d97:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  802d9d:	8d 70 01             	lea    0x1(%rax),%esi
  802da0:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802da6:	83 f8 30             	cmp    $0x30,%eax
  802da9:	73 23                	jae    802dce <spawnl+0x1eb>
  802dab:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802db2:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802db8:	89 c0                	mov    %eax,%eax
  802dba:	48 01 d0             	add    %rdx,%rax
  802dbd:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802dc3:	83 c2 08             	add    $0x8,%edx
  802dc6:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802dcc:	eb 15                	jmp    802de3 <spawnl+0x200>
  802dce:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802dd5:	48 89 d0             	mov    %rdx,%rax
  802dd8:	48 83 c2 08          	add    $0x8,%rdx
  802ddc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802de3:	48 8b 08             	mov    (%rax),%rcx
  802de6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ded:	89 f2                	mov    %esi,%edx
  802def:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802df3:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  802dfa:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802e00:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  802e06:	77 8f                	ja     802d97 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802e08:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  802e0f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802e16:	48 89 d6             	mov    %rdx,%rsi
  802e19:	48 89 c7             	mov    %rax,%rdi
  802e1c:	48 b8 70 28 80 00 00 	movabs $0x802870,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	48 89 dc             	mov    %rbx,%rsp
}
  802e2b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802e2f:	c9                   	leaveq 
  802e30:	c3                   	retq   

0000000000802e31 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  802e31:	55                   	push   %rbp
  802e32:	48 89 e5             	mov    %rsp,%rbp
  802e35:	48 83 ec 50          	sub    $0x50,%rsp
  802e39:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e3c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e40:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802e44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e4b:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  802e4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802e53:	eb 2c                	jmp    802e81 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  802e55:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e58:	48 98                	cltq   
  802e5a:	48 c1 e0 03          	shl    $0x3,%rax
  802e5e:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802e62:	48 8b 00             	mov    (%rax),%rax
  802e65:	48 89 c7             	mov    %rax,%rdi
  802e68:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
  802e74:	83 c0 01             	add    $0x1,%eax
  802e77:	48 98                	cltq   
  802e79:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802e7d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802e81:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e84:	48 98                	cltq   
  802e86:	48 c1 e0 03          	shl    $0x3,%rax
  802e8a:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802e8e:	48 8b 00             	mov    (%rax),%rax
  802e91:	48 85 c0             	test   %rax,%rax
  802e94:	75 bf                	jne    802e55 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9a:	48 f7 d8             	neg    %rax
  802e9d:	48 05 00 10 40 00    	add    $0x401000,%rax
  802ea3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  802ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eab:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802eaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb3:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  802eb7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802eba:	83 c2 01             	add    $0x1,%edx
  802ebd:	c1 e2 03             	shl    $0x3,%edx
  802ec0:	48 63 d2             	movslq %edx,%rdx
  802ec3:	48 f7 da             	neg    %rdx
  802ec6:	48 01 d0             	add    %rdx,%rax
  802ec9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802ecd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed1:	48 83 e8 10          	sub    $0x10,%rax
  802ed5:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802edb:	77 0a                	ja     802ee7 <init_stack+0xb6>
		return -E_NO_MEM;
  802edd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802ee2:	e9 b8 01 00 00       	jmpq   80309f <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802ee7:	ba 07 00 00 00       	mov    $0x7,%edx
  802eec:	be 00 00 40 00       	mov    $0x400000,%esi
  802ef1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef6:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
  802f02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f09:	79 08                	jns    802f13 <init_stack+0xe2>
		return r;
  802f0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0e:	e9 8c 01 00 00       	jmpq   80309f <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802f13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802f1a:	eb 73                	jmp    802f8f <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  802f1c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f1f:	48 98                	cltq   
  802f21:	48 c1 e0 03          	shl    $0x3,%rax
  802f25:	48 03 45 d0          	add    -0x30(%rbp),%rax
  802f29:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  802f2e:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  802f32:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  802f39:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  802f3c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f3f:	48 98                	cltq   
  802f41:	48 c1 e0 03          	shl    $0x3,%rax
  802f45:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802f49:	48 8b 10             	mov    (%rax),%rdx
  802f4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f50:	48 89 d6             	mov    %rdx,%rsi
  802f53:	48 89 c7             	mov    %rax,%rdi
  802f56:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  802f62:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f65:	48 98                	cltq   
  802f67:	48 c1 e0 03          	shl    $0x3,%rax
  802f6b:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802f6f:	48 8b 00             	mov    (%rax),%rax
  802f72:	48 89 c7             	mov    %rax,%rdi
  802f75:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
  802f81:	48 98                	cltq   
  802f83:	48 83 c0 01          	add    $0x1,%rax
  802f87:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802f8b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  802f8f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f92:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802f95:	7c 85                	jl     802f1c <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802f97:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f9a:	48 98                	cltq   
  802f9c:	48 c1 e0 03          	shl    $0x3,%rax
  802fa0:	48 03 45 d0          	add    -0x30(%rbp),%rax
  802fa4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802fab:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  802fb2:	00 
  802fb3:	74 35                	je     802fea <init_stack+0x1b9>
  802fb5:	48 b9 48 4e 80 00 00 	movabs $0x804e48,%rcx
  802fbc:	00 00 00 
  802fbf:	48 ba 6e 4e 80 00 00 	movabs $0x804e6e,%rdx
  802fc6:	00 00 00 
  802fc9:	be f1 00 00 00       	mov    $0xf1,%esi
  802fce:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  802fd5:	00 00 00 
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdd:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  802fe4:	00 00 00 
  802fe7:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802fea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fee:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  802ff2:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802ff7:	48 03 45 d0          	add    -0x30(%rbp),%rax
  802ffb:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803001:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803004:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803008:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80300c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80300f:	48 98                	cltq   
  803011:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803014:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803019:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80301d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803023:	48 89 c2             	mov    %rax,%rdx
  803026:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80302a:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80302d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803030:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803036:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80303b:	89 c2                	mov    %eax,%edx
  80303d:	be 00 00 40 00       	mov    $0x400000,%esi
  803042:	bf 00 00 00 00       	mov    $0x0,%edi
  803047:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
  803053:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803056:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80305a:	78 26                	js     803082 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80305c:	be 00 00 40 00       	mov    $0x400000,%esi
  803061:	bf 00 00 00 00       	mov    $0x0,%edi
  803066:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803075:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803079:	78 0a                	js     803085 <init_stack+0x254>
		goto error;

	return 0;
  80307b:	b8 00 00 00 00       	mov    $0x0,%eax
  803080:	eb 1d                	jmp    80309f <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803082:	90                   	nop
  803083:	eb 01                	jmp    803086 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803085:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803086:	be 00 00 40 00       	mov    $0x400000,%esi
  80308b:	bf 00 00 00 00       	mov    $0x0,%edi
  803090:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  803097:	00 00 00 
  80309a:	ff d0                	callq  *%rax
	return r;
  80309c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80309f:	c9                   	leaveq 
  8030a0:	c3                   	retq   

00000000008030a1 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8030a1:	55                   	push   %rbp
  8030a2:	48 89 e5             	mov    %rsp,%rbp
  8030a5:	48 83 ec 50          	sub    $0x50,%rsp
  8030a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030b0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8030b4:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8030b7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8030bb:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8030bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8030c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cf:	74 21                	je     8030f2 <map_segment+0x51>
		va -= i;
  8030d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d4:	48 98                	cltq   
  8030d6:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8030da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030dd:	48 98                	cltq   
  8030df:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8030e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e6:	48 98                	cltq   
  8030e8:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8030ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ef:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8030f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030f9:	e9 74 01 00 00       	jmpq   803272 <map_segment+0x1d1>
		if (i >= filesz) {
  8030fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803101:	48 98                	cltq   
  803103:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803107:	72 38                	jb     803141 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310c:	48 98                	cltq   
  80310e:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803112:	48 89 c1             	mov    %rax,%rcx
  803115:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803118:	8b 55 10             	mov    0x10(%rbp),%edx
  80311b:	48 89 ce             	mov    %rcx,%rsi
  80311e:	89 c7                	mov    %eax,%edi
  803120:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803127:	00 00 00 
  80312a:	ff d0                	callq  *%rax
  80312c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80312f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803133:	0f 89 32 01 00 00    	jns    80326b <map_segment+0x1ca>
				return r;
  803139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313c:	e9 45 01 00 00       	jmpq   803286 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803141:	ba 07 00 00 00       	mov    $0x7,%edx
  803146:	be 00 00 40 00       	mov    $0x400000,%esi
  80314b:	bf 00 00 00 00       	mov    $0x0,%edi
  803150:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
  80315c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80315f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803163:	79 08                	jns    80316d <map_segment+0xcc>
				return r;
  803165:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803168:	e9 19 01 00 00       	jmpq   803286 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80316d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803170:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803173:	01 c2                	add    %eax,%edx
  803175:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803178:	89 d6                	mov    %edx,%esi
  80317a:	89 c7                	mov    %eax,%edi
  80317c:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  803183:	00 00 00 
  803186:	ff d0                	callq  *%rax
  803188:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80318b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80318f:	79 08                	jns    803199 <map_segment+0xf8>
				return r;
  803191:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803194:	e9 ed 00 00 00       	jmpq   803286 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803199:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a3:	48 98                	cltq   
  8031a5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8031a9:	48 89 d1             	mov    %rdx,%rcx
  8031ac:	48 29 c1             	sub    %rax,%rcx
  8031af:	48 89 c8             	mov    %rcx,%rax
  8031b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8031b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031b9:	48 63 d0             	movslq %eax,%rdx
  8031bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c0:	48 39 c2             	cmp    %rax,%rdx
  8031c3:	48 0f 47 d0          	cmova  %rax,%rdx
  8031c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031ca:	be 00 00 40 00       	mov    $0x400000,%esi
  8031cf:	89 c7                	mov    %eax,%edi
  8031d1:	48 b8 39 22 80 00 00 	movabs $0x802239,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
  8031dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031e4:	79 08                	jns    8031ee <map_segment+0x14d>
				return r;
  8031e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e9:	e9 98 00 00 00       	jmpq   803286 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8031ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f1:	48 98                	cltq   
  8031f3:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8031f7:	48 89 c2             	mov    %rax,%rdx
  8031fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031fd:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803201:	48 89 d1             	mov    %rdx,%rcx
  803204:	89 c2                	mov    %eax,%edx
  803206:	be 00 00 40 00       	mov    $0x400000,%esi
  80320b:	bf 00 00 00 00       	mov    $0x0,%edi
  803210:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
  80321c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80321f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803223:	79 30                	jns    803255 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  803225:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803228:	89 c1                	mov    %eax,%ecx
  80322a:	48 ba 83 4e 80 00 00 	movabs $0x804e83,%rdx
  803231:	00 00 00 
  803234:	be 24 01 00 00       	mov    $0x124,%esi
  803239:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  803240:	00 00 00 
  803243:	b8 00 00 00 00       	mov    $0x0,%eax
  803248:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  80324f:	00 00 00 
  803252:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803255:	be 00 00 40 00       	mov    $0x400000,%esi
  80325a:	bf 00 00 00 00       	mov    $0x0,%edi
  80325f:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80326b:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803275:	48 98                	cltq   
  803277:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80327b:	0f 82 7d fe ff ff    	jb     8030fe <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803286:	c9                   	leaveq 
  803287:	c3                   	retq   

0000000000803288 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803288:	55                   	push   %rbp
  803289:	48 89 e5             	mov    %rsp,%rbp
  80328c:	48 83 ec 60          	sub    $0x60,%rsp
  803290:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  803293:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  80329a:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8032a1:	00 
    uint64_t each_pte = 0;
  8032a2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8032a9:	00 
    uint64_t each_pdpe = 0;
  8032aa:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8032b1:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8032b2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032b9:	00 
  8032ba:	e9 a5 01 00 00       	jmpq   803464 <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  8032bf:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8032c6:	01 00 00 
  8032c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8032cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032d1:	83 e0 01             	and    $0x1,%eax
  8032d4:	84 c0                	test   %al,%al
  8032d6:	0f 84 73 01 00 00    	je     80344f <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8032dc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8032e3:	00 
  8032e4:	e9 56 01 00 00       	jmpq   80343f <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  8032e9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8032f0:	01 00 00 
  8032f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8032f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032fb:	83 e0 01             	and    $0x1,%eax
  8032fe:	84 c0                	test   %al,%al
  803300:	0f 84 1f 01 00 00    	je     803425 <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  803306:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80330d:	00 
  80330e:	e9 02 01 00 00       	jmpq   803415 <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  803313:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80331a:	01 00 00 
  80331d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803321:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803325:	83 e0 01             	and    $0x1,%eax
  803328:	84 c0                	test   %al,%al
  80332a:	0f 84 cb 00 00 00    	je     8033fb <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803330:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803337:	00 
  803338:	e9 ae 00 00 00       	jmpq   8033eb <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  80333d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803344:	01 00 00 
  803347:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80334b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80334f:	25 00 04 00 00       	and    $0x400,%eax
  803354:	48 85 c0             	test   %rax,%rax
  803357:	0f 84 84 00 00 00    	je     8033e1 <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  80335d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803364:	01 00 00 
  803367:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80336b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80336f:	25 07 0e 00 00       	and    $0xe07,%eax
  803374:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  803377:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337b:	48 c1 e0 0c          	shl    $0xc,%rax
  80337f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  803383:	8b 75 c0             	mov    -0x40(%rbp),%esi
  803386:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  80338a:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80338d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803391:	41 89 f0             	mov    %esi,%r8d
  803394:	48 89 c6             	mov    %rax,%rsi
  803397:	bf 00 00 00 00       	mov    $0x0,%edi
  80339c:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
  8033a8:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  8033ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8033af:	79 30                	jns    8033e1 <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  8033b1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8033b4:	89 c1                	mov    %eax,%ecx
  8033b6:	48 ba a0 4e 80 00 00 	movabs $0x804ea0,%rdx
  8033bd:	00 00 00 
  8033c0:	be 48 01 00 00       	mov    $0x148,%esi
  8033c5:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  8033cc:	00 00 00 
  8033cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d4:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  8033db:	00 00 00 
  8033de:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8033e1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8033e6:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8033eb:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8033f2:	00 
  8033f3:	0f 86 44 ff ff ff    	jbe    80333d <copy_shared_pages+0xb5>
  8033f9:	eb 10                	jmp    80340b <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  8033fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ff:	48 83 c0 01          	add    $0x1,%rax
  803403:	48 c1 e0 09          	shl    $0x9,%rax
  803407:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80340b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803410:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803415:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  80341c:	00 
  80341d:	0f 86 f0 fe ff ff    	jbe    803313 <copy_shared_pages+0x8b>
  803423:	eb 10                	jmp    803435 <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  803425:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803429:	48 83 c0 01          	add    $0x1,%rax
  80342d:	48 c1 e0 09          	shl    $0x9,%rax
  803431:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803435:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  80343a:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80343f:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803446:	00 
  803447:	0f 86 9c fe ff ff    	jbe    8032e9 <copy_shared_pages+0x61>
  80344d:	eb 10                	jmp    80345f <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  80344f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803453:	48 83 c0 01          	add    $0x1,%rax
  803457:	48 c1 e0 09          	shl    $0x9,%rax
  80345b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  80345f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803464:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803469:	0f 84 50 fe ff ff    	je     8032bf <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  80346f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803474:	c9                   	leaveq 
  803475:	c3                   	retq   
	...

0000000000803478 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803478:	55                   	push   %rbp
  803479:	48 89 e5             	mov    %rsp,%rbp
  80347c:	48 83 ec 20          	sub    $0x20,%rsp
  803480:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803483:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803487:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348a:	48 89 d6             	mov    %rdx,%rsi
  80348d:	89 c7                	mov    %eax,%edi
  80348f:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  803496:	00 00 00 
  803499:	ff d0                	callq  *%rax
  80349b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a2:	79 05                	jns    8034a9 <fd2sockid+0x31>
		return r;
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	eb 24                	jmp    8034cd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ad:	8b 10                	mov    (%rax),%edx
  8034af:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8034b6:	00 00 00 
  8034b9:	8b 00                	mov    (%rax),%eax
  8034bb:	39 c2                	cmp    %eax,%edx
  8034bd:	74 07                	je     8034c6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034bf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034c4:	eb 07                	jmp    8034cd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ca:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034cd:	c9                   	leaveq 
  8034ce:	c3                   	retq   

00000000008034cf <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034cf:	55                   	push   %rbp
  8034d0:	48 89 e5             	mov    %rsp,%rbp
  8034d3:	48 83 ec 20          	sub    $0x20,%rsp
  8034d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034da:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034de:	48 89 c7             	mov    %rax,%rdi
  8034e1:	48 b8 96 1c 80 00 00 	movabs $0x801c96,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f4:	78 26                	js     80351c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8034ff:	48 89 c6             	mov    %rax,%rsi
  803502:	bf 00 00 00 00       	mov    $0x0,%edi
  803507:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
  803513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351a:	79 16                	jns    803532 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80351c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351f:	89 c7                	mov    %eax,%edi
  803521:	48 b8 dc 39 80 00 00 	movabs $0x8039dc,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
		return r;
  80352d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803530:	eb 3a                	jmp    80356c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803536:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80353d:	00 00 00 
  803540:	8b 12                	mov    (%rdx),%edx
  803542:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803556:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355d:	48 89 c7             	mov    %rax,%rdi
  803560:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
}
  80356c:	c9                   	leaveq 
  80356d:	c3                   	retq   

000000000080356e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80356e:	55                   	push   %rbp
  80356f:	48 89 e5             	mov    %rsp,%rbp
  803572:	48 83 ec 30          	sub    $0x30,%rsp
  803576:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80357d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803581:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 78 34 80 00 00 	movabs $0x803478,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803595:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803599:	79 05                	jns    8035a0 <accept+0x32>
		return r;
  80359b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359e:	eb 3b                	jmp    8035db <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ab:	48 89 ce             	mov    %rcx,%rsi
  8035ae:	89 c7                	mov    %eax,%edi
  8035b0:	48 b8 b9 38 80 00 00 	movabs $0x8038b9,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
  8035bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c3:	79 05                	jns    8035ca <accept+0x5c>
		return r;
  8035c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c8:	eb 11                	jmp    8035db <accept+0x6d>
	return alloc_sockfd(r);
  8035ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cd:	89 c7                	mov    %eax,%edi
  8035cf:	48 b8 cf 34 80 00 00 	movabs $0x8034cf,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
}
  8035db:	c9                   	leaveq 
  8035dc:	c3                   	retq   

00000000008035dd <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035dd:	55                   	push   %rbp
  8035de:	48 89 e5             	mov    %rsp,%rbp
  8035e1:	48 83 ec 20          	sub    $0x20,%rsp
  8035e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ec:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035f2:	89 c7                	mov    %eax,%edi
  8035f4:	48 b8 78 34 80 00 00 	movabs $0x803478,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803607:	79 05                	jns    80360e <bind+0x31>
		return r;
  803609:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360c:	eb 1b                	jmp    803629 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80360e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803611:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803618:	48 89 ce             	mov    %rcx,%rsi
  80361b:	89 c7                	mov    %eax,%edi
  80361d:	48 b8 38 39 80 00 00 	movabs $0x803938,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
}
  803629:	c9                   	leaveq 
  80362a:	c3                   	retq   

000000000080362b <shutdown>:

int
shutdown(int s, int how)
{
  80362b:	55                   	push   %rbp
  80362c:	48 89 e5             	mov    %rsp,%rbp
  80362f:	48 83 ec 20          	sub    $0x20,%rsp
  803633:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803636:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803639:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363c:	89 c7                	mov    %eax,%edi
  80363e:	48 b8 78 34 80 00 00 	movabs $0x803478,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	79 05                	jns    803658 <shutdown+0x2d>
		return r;
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	eb 16                	jmp    80366e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803658:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80365b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365e:	89 d6                	mov    %edx,%esi
  803660:	89 c7                	mov    %eax,%edi
  803662:	48 b8 9c 39 80 00 00 	movabs $0x80399c,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
}
  80366e:	c9                   	leaveq 
  80366f:	c3                   	retq   

0000000000803670 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803670:	55                   	push   %rbp
  803671:	48 89 e5             	mov    %rsp,%rbp
  803674:	48 83 ec 10          	sub    $0x10,%rsp
  803678:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80367c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803680:	48 89 c7             	mov    %rax,%rdi
  803683:	48 b8 24 47 80 00 00 	movabs $0x804724,%rax
  80368a:	00 00 00 
  80368d:	ff d0                	callq  *%rax
  80368f:	83 f8 01             	cmp    $0x1,%eax
  803692:	75 17                	jne    8036ab <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803698:	8b 40 0c             	mov    0xc(%rax),%eax
  80369b:	89 c7                	mov    %eax,%edi
  80369d:	48 b8 dc 39 80 00 00 	movabs $0x8039dc,%rax
  8036a4:	00 00 00 
  8036a7:	ff d0                	callq  *%rax
  8036a9:	eb 05                	jmp    8036b0 <devsock_close+0x40>
	else
		return 0;
  8036ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b0:	c9                   	leaveq 
  8036b1:	c3                   	retq   

00000000008036b2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036b2:	55                   	push   %rbp
  8036b3:	48 89 e5             	mov    %rsp,%rbp
  8036b6:	48 83 ec 20          	sub    $0x20,%rsp
  8036ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036c1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c7:	89 c7                	mov    %eax,%edi
  8036c9:	48 b8 78 34 80 00 00 	movabs $0x803478,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036dc:	79 05                	jns    8036e3 <connect+0x31>
		return r;
  8036de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e1:	eb 1b                	jmp    8036fe <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036e3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036e6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ed:	48 89 ce             	mov    %rcx,%rsi
  8036f0:	89 c7                	mov    %eax,%edi
  8036f2:	48 b8 09 3a 80 00 00 	movabs $0x803a09,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <listen>:

int
listen(int s, int backlog)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 20          	sub    $0x20,%rsp
  803708:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80370b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80370e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803711:	89 c7                	mov    %eax,%edi
  803713:	48 b8 78 34 80 00 00 	movabs $0x803478,%rax
  80371a:	00 00 00 
  80371d:	ff d0                	callq  *%rax
  80371f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803726:	79 05                	jns    80372d <listen+0x2d>
		return r;
  803728:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372b:	eb 16                	jmp    803743 <listen+0x43>
	return nsipc_listen(r, backlog);
  80372d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803733:	89 d6                	mov    %edx,%esi
  803735:	89 c7                	mov    %eax,%edi
  803737:	48 b8 6d 3a 80 00 00 	movabs $0x803a6d,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
}
  803743:	c9                   	leaveq 
  803744:	c3                   	retq   

0000000000803745 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 20          	sub    $0x20,%rsp
  80374d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803751:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803755:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375d:	89 c2                	mov    %eax,%edx
  80375f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803763:	8b 40 0c             	mov    0xc(%rax),%eax
  803766:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80376a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80376f:	89 c7                	mov    %eax,%edi
  803771:	48 b8 ad 3a 80 00 00 	movabs $0x803aad,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
}
  80377d:	c9                   	leaveq 
  80377e:	c3                   	retq   

000000000080377f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80377f:	55                   	push   %rbp
  803780:	48 89 e5             	mov    %rsp,%rbp
  803783:	48 83 ec 20          	sub    $0x20,%rsp
  803787:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80378b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80378f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803797:	89 c2                	mov    %eax,%edx
  803799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379d:	8b 40 0c             	mov    0xc(%rax),%eax
  8037a0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037a9:	89 c7                	mov    %eax,%edi
  8037ab:	48 b8 79 3b 80 00 00 	movabs $0x803b79,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
}
  8037b7:	c9                   	leaveq 
  8037b8:	c3                   	retq   

00000000008037b9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037b9:	55                   	push   %rbp
  8037ba:	48 89 e5             	mov    %rsp,%rbp
  8037bd:	48 83 ec 10          	sub    $0x10,%rsp
  8037c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cd:	48 be be 4e 80 00 00 	movabs $0x804ebe,%rsi
  8037d4:	00 00 00 
  8037d7:	48 89 c7             	mov    %rax,%rdi
  8037da:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
	return 0;
  8037e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037eb:	c9                   	leaveq 
  8037ec:	c3                   	retq   

00000000008037ed <socket>:

int
socket(int domain, int type, int protocol)
{
  8037ed:	55                   	push   %rbp
  8037ee:	48 89 e5             	mov    %rsp,%rbp
  8037f1:	48 83 ec 20          	sub    $0x20,%rsp
  8037f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037f8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037fb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037fe:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803801:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803804:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803807:	89 ce                	mov    %ecx,%esi
  803809:	89 c7                	mov    %eax,%edi
  80380b:	48 b8 31 3c 80 00 00 	movabs $0x803c31,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
  803817:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381e:	79 05                	jns    803825 <socket+0x38>
		return r;
  803820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803823:	eb 11                	jmp    803836 <socket+0x49>
	return alloc_sockfd(r);
  803825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803828:	89 c7                	mov    %eax,%edi
  80382a:	48 b8 cf 34 80 00 00 	movabs $0x8034cf,%rax
  803831:	00 00 00 
  803834:	ff d0                	callq  *%rax
}
  803836:	c9                   	leaveq 
  803837:	c3                   	retq   

0000000000803838 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803838:	55                   	push   %rbp
  803839:	48 89 e5             	mov    %rsp,%rbp
  80383c:	48 83 ec 10          	sub    $0x10,%rsp
  803840:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803843:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80384a:	00 00 00 
  80384d:	8b 00                	mov    (%rax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	75 1d                	jne    803870 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803853:	bf 02 00 00 00       	mov    $0x2,%edi
  803858:	48 b8 96 46 80 00 00 	movabs $0x804696,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80386b:	00 00 00 
  80386e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803870:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803877:	00 00 00 
  80387a:	8b 00                	mov    (%rax),%eax
  80387c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80387f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803884:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80388b:	00 00 00 
  80388e:	89 c7                	mov    %eax,%edi
  803890:	48 b8 e7 45 80 00 00 	movabs $0x8045e7,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80389c:	ba 00 00 00 00       	mov    $0x0,%edx
  8038a1:	be 00 00 00 00       	mov    $0x0,%esi
  8038a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ab:	48 b8 00 45 80 00 00 	movabs $0x804500,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
}
  8038b7:	c9                   	leaveq 
  8038b8:	c3                   	retq   

00000000008038b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038b9:	55                   	push   %rbp
  8038ba:	48 89 e5             	mov    %rsp,%rbp
  8038bd:	48 83 ec 30          	sub    $0x30,%rsp
  8038c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d3:	00 00 00 
  8038d6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038d9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038db:	bf 01 00 00 00       	mov    $0x1,%edi
  8038e0:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
  8038ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f3:	78 3e                	js     803933 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8038f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038fc:	00 00 00 
  8038ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803907:	8b 40 10             	mov    0x10(%rax),%eax
  80390a:	89 c2                	mov    %eax,%edx
  80390c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803910:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803914:	48 89 ce             	mov    %rcx,%rsi
  803917:	48 89 c7             	mov    %rax,%rdi
  80391a:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392a:	8b 50 10             	mov    0x10(%rax),%edx
  80392d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803931:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803933:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803936:	c9                   	leaveq 
  803937:	c3                   	retq   

0000000000803938 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803938:	55                   	push   %rbp
  803939:	48 89 e5             	mov    %rsp,%rbp
  80393c:	48 83 ec 10          	sub    $0x10,%rsp
  803940:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803943:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803947:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80394a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803951:	00 00 00 
  803954:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803957:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803959:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80395c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803960:	48 89 c6             	mov    %rax,%rsi
  803963:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80396a:	00 00 00 
  80396d:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803979:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803980:	00 00 00 
  803983:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803986:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803989:	bf 02 00 00 00       	mov    $0x2,%edi
  80398e:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
}
  80399a:	c9                   	leaveq 
  80399b:	c3                   	retq   

000000000080399c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80399c:	55                   	push   %rbp
  80399d:	48 89 e5             	mov    %rsp,%rbp
  8039a0:	48 83 ec 10          	sub    $0x10,%rsp
  8039a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b1:	00 00 00 
  8039b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c0:	00 00 00 
  8039c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039c6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039c9:	bf 03 00 00 00       	mov    $0x3,%edi
  8039ce:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
}
  8039da:	c9                   	leaveq 
  8039db:	c3                   	retq   

00000000008039dc <nsipc_close>:

int
nsipc_close(int s)
{
  8039dc:	55                   	push   %rbp
  8039dd:	48 89 e5             	mov    %rsp,%rbp
  8039e0:	48 83 ec 10          	sub    $0x10,%rsp
  8039e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8039e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ee:	00 00 00 
  8039f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039f4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8039f6:	bf 04 00 00 00       	mov    $0x4,%edi
  8039fb:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
}
  803a07:	c9                   	leaveq 
  803a08:	c3                   	retq   

0000000000803a09 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a09:	55                   	push   %rbp
  803a0a:	48 89 e5             	mov    %rsp,%rbp
  803a0d:	48 83 ec 10          	sub    $0x10,%rsp
  803a11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a18:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a1b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a22:	00 00 00 
  803a25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a28:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a2a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a31:	48 89 c6             	mov    %rax,%rsi
  803a34:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a3b:	00 00 00 
  803a3e:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a51:	00 00 00 
  803a54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a57:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a5a:	bf 05 00 00 00       	mov    $0x5,%edi
  803a5f:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
}
  803a6b:	c9                   	leaveq 
  803a6c:	c3                   	retq   

0000000000803a6d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a6d:	55                   	push   %rbp
  803a6e:	48 89 e5             	mov    %rsp,%rbp
  803a71:	48 83 ec 10          	sub    $0x10,%rsp
  803a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a7b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a82:	00 00 00 
  803a85:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a88:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a8a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a91:	00 00 00 
  803a94:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a97:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a9a:	bf 06 00 00 00       	mov    $0x6,%edi
  803a9f:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803aa6:	00 00 00 
  803aa9:	ff d0                	callq  *%rax
}
  803aab:	c9                   	leaveq 
  803aac:	c3                   	retq   

0000000000803aad <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803aad:	55                   	push   %rbp
  803aae:	48 89 e5             	mov    %rsp,%rbp
  803ab1:	48 83 ec 30          	sub    $0x30,%rsp
  803ab5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ab8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803abc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803abf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ac2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac9:	00 00 00 
  803acc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803acf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ad1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ad8:	00 00 00 
  803adb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ade:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ae1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ae8:	00 00 00 
  803aeb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803aee:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803af1:	bf 07 00 00 00       	mov    $0x7,%edi
  803af6:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803afd:	00 00 00 
  803b00:	ff d0                	callq  *%rax
  803b02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b09:	78 69                	js     803b74 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b0b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b12:	7f 08                	jg     803b1c <nsipc_recv+0x6f>
  803b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b17:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b1a:	7e 35                	jle    803b51 <nsipc_recv+0xa4>
  803b1c:	48 b9 c5 4e 80 00 00 	movabs $0x804ec5,%rcx
  803b23:	00 00 00 
  803b26:	48 ba da 4e 80 00 00 	movabs $0x804eda,%rdx
  803b2d:	00 00 00 
  803b30:	be 61 00 00 00       	mov    $0x61,%esi
  803b35:	48 bf ef 4e 80 00 00 	movabs $0x804eef,%rdi
  803b3c:	00 00 00 
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  803b4b:	00 00 00 
  803b4e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b54:	48 63 d0             	movslq %eax,%rdx
  803b57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b62:	00 00 00 
  803b65:	48 89 c7             	mov    %rax,%rdi
  803b68:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
	}

	return r;
  803b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b77:	c9                   	leaveq 
  803b78:	c3                   	retq   

0000000000803b79 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b79:	55                   	push   %rbp
  803b7a:	48 89 e5             	mov    %rsp,%rbp
  803b7d:	48 83 ec 20          	sub    $0x20,%rsp
  803b81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b88:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b8b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b8e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b95:	00 00 00 
  803b98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b9b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b9d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ba4:	7e 35                	jle    803bdb <nsipc_send+0x62>
  803ba6:	48 b9 fb 4e 80 00 00 	movabs $0x804efb,%rcx
  803bad:	00 00 00 
  803bb0:	48 ba da 4e 80 00 00 	movabs $0x804eda,%rdx
  803bb7:	00 00 00 
  803bba:	be 6c 00 00 00       	mov    $0x6c,%esi
  803bbf:	48 bf ef 4e 80 00 00 	movabs $0x804eef,%rdi
  803bc6:	00 00 00 
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	49 b8 b4 01 80 00 00 	movabs $0x8001b4,%r8
  803bd5:	00 00 00 
  803bd8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bde:	48 63 d0             	movslq %eax,%rdx
  803be1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be5:	48 89 c6             	mov    %rax,%rsi
  803be8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803bef:	00 00 00 
  803bf2:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803bfe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c05:	00 00 00 
  803c08:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c0b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c15:	00 00 00 
  803c18:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c1b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c1e:	bf 08 00 00 00       	mov    $0x8,%edi
  803c23:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803c2a:	00 00 00 
  803c2d:	ff d0                	callq  *%rax
}
  803c2f:	c9                   	leaveq 
  803c30:	c3                   	retq   

0000000000803c31 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c31:	55                   	push   %rbp
  803c32:	48 89 e5             	mov    %rsp,%rbp
  803c35:	48 83 ec 10          	sub    $0x10,%rsp
  803c39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c3c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c3f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c42:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c49:	00 00 00 
  803c4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c4f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c51:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c58:	00 00 00 
  803c5b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c5e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c61:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c68:	00 00 00 
  803c6b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c6e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c71:	bf 09 00 00 00       	mov    $0x9,%edi
  803c76:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
}
  803c82:	c9                   	leaveq 
  803c83:	c3                   	retq   

0000000000803c84 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c84:	55                   	push   %rbp
  803c85:	48 89 e5             	mov    %rsp,%rbp
  803c88:	53                   	push   %rbx
  803c89:	48 83 ec 38          	sub    $0x38,%rsp
  803c8d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c91:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c95:	48 89 c7             	mov    %rax,%rdi
  803c98:	48 b8 96 1c 80 00 00 	movabs $0x801c96,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ca7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cab:	0f 88 bf 01 00 00    	js     803e70 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb5:	ba 07 04 00 00       	mov    $0x407,%edx
  803cba:	48 89 c6             	mov    %rax,%rsi
  803cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc2:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd5:	0f 88 95 01 00 00    	js     803e70 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cdb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cdf:	48 89 c7             	mov    %rax,%rdi
  803ce2:	48 b8 96 1c 80 00 00 	movabs $0x801c96,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
  803cee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cf1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf5:	0f 88 5d 01 00 00    	js     803e58 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cff:	ba 07 04 00 00       	mov    $0x407,%edx
  803d04:	48 89 c6             	mov    %rax,%rsi
  803d07:	bf 00 00 00 00       	mov    $0x0,%edi
  803d0c:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803d13:	00 00 00 
  803d16:	ff d0                	callq  *%rax
  803d18:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d1f:	0f 88 33 01 00 00    	js     803e58 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d29:	48 89 c7             	mov    %rax,%rdi
  803d2c:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
  803d38:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d40:	ba 07 04 00 00       	mov    $0x407,%edx
  803d45:	48 89 c6             	mov    %rax,%rsi
  803d48:	bf 00 00 00 00       	mov    $0x0,%edi
  803d4d:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
  803d59:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d60:	0f 88 d9 00 00 00    	js     803e3f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d6a:	48 89 c7             	mov    %rax,%rdi
  803d6d:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803d74:	00 00 00 
  803d77:	ff d0                	callq  *%rax
  803d79:	48 89 c2             	mov    %rax,%rdx
  803d7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d80:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d86:	48 89 d1             	mov    %rdx,%rcx
  803d89:	ba 00 00 00 00       	mov    $0x0,%edx
  803d8e:	48 89 c6             	mov    %rax,%rsi
  803d91:	bf 00 00 00 00       	mov    $0x0,%edi
  803d96:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
  803da2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803da5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803da9:	78 79                	js     803e24 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803daf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803db6:	00 00 00 
  803db9:	8b 12                	mov    (%rdx),%edx
  803dbb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803dbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803dc8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dcc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803dd3:	00 00 00 
  803dd6:	8b 12                	mov    (%rdx),%edx
  803dd8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803dda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dde:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de9:	48 89 c7             	mov    %rax,%rdi
  803dec:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  803df3:	00 00 00 
  803df6:	ff d0                	callq  *%rax
  803df8:	89 c2                	mov    %eax,%edx
  803dfa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dfe:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e04:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0c:	48 89 c7             	mov    %rax,%rdi
  803e0f:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  803e16:	00 00 00 
  803e19:	ff d0                	callq  *%rax
  803e1b:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e22:	eb 4f                	jmp    803e73 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803e24:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e29:	48 89 c6             	mov    %rax,%rsi
  803e2c:	bf 00 00 00 00       	mov    $0x0,%edi
  803e31:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
  803e3d:	eb 01                	jmp    803e40 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803e3f:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e44:	48 89 c6             	mov    %rax,%rsi
  803e47:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4c:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  803e53:	00 00 00 
  803e56:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5c:	48 89 c6             	mov    %rax,%rsi
  803e5f:	bf 00 00 00 00       	mov    $0x0,%edi
  803e64:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  803e6b:	00 00 00 
  803e6e:	ff d0                	callq  *%rax
err:
	return r;
  803e70:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e73:	48 83 c4 38          	add    $0x38,%rsp
  803e77:	5b                   	pop    %rbx
  803e78:	5d                   	pop    %rbp
  803e79:	c3                   	retq   

0000000000803e7a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e7a:	55                   	push   %rbp
  803e7b:	48 89 e5             	mov    %rsp,%rbp
  803e7e:	53                   	push   %rbx
  803e7f:	48 83 ec 28          	sub    $0x28,%rsp
  803e83:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e87:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e8b:	eb 01                	jmp    803e8e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803e8d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e8e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e95:	00 00 00 
  803e98:	48 8b 00             	mov    (%rax),%rax
  803e9b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ea1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea8:	48 89 c7             	mov    %rax,%rdi
  803eab:	48 b8 24 47 80 00 00 	movabs $0x804724,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
  803eb7:	89 c3                	mov    %eax,%ebx
  803eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebd:	48 89 c7             	mov    %rax,%rdi
  803ec0:	48 b8 24 47 80 00 00 	movabs $0x804724,%rax
  803ec7:	00 00 00 
  803eca:	ff d0                	callq  *%rax
  803ecc:	39 c3                	cmp    %eax,%ebx
  803ece:	0f 94 c0             	sete   %al
  803ed1:	0f b6 c0             	movzbl %al,%eax
  803ed4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ed7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ede:	00 00 00 
  803ee1:	48 8b 00             	mov    (%rax),%rax
  803ee4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803eea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803eed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ef3:	75 0a                	jne    803eff <_pipeisclosed+0x85>
			return ret;
  803ef5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803ef8:	48 83 c4 28          	add    $0x28,%rsp
  803efc:	5b                   	pop    %rbx
  803efd:	5d                   	pop    %rbp
  803efe:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803eff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f02:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f05:	74 86                	je     803e8d <_pipeisclosed+0x13>
  803f07:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f0b:	75 80                	jne    803e8d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f0d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f14:	00 00 00 
  803f17:	48 8b 00             	mov    (%rax),%rax
  803f1a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f20:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f26:	89 c6                	mov    %eax,%esi
  803f28:	48 bf 0c 4f 80 00 00 	movabs $0x804f0c,%rdi
  803f2f:	00 00 00 
  803f32:	b8 00 00 00 00       	mov    $0x0,%eax
  803f37:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  803f3e:	00 00 00 
  803f41:	41 ff d0             	callq  *%r8
	}
  803f44:	e9 44 ff ff ff       	jmpq   803e8d <_pipeisclosed+0x13>

0000000000803f49 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803f49:	55                   	push   %rbp
  803f4a:	48 89 e5             	mov    %rsp,%rbp
  803f4d:	48 83 ec 30          	sub    $0x30,%rsp
  803f51:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f54:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f5b:	48 89 d6             	mov    %rdx,%rsi
  803f5e:	89 c7                	mov    %eax,%edi
  803f60:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  803f67:	00 00 00 
  803f6a:	ff d0                	callq  *%rax
  803f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f73:	79 05                	jns    803f7a <pipeisclosed+0x31>
		return r;
  803f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f78:	eb 31                	jmp    803fab <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7e:	48 89 c7             	mov    %rax,%rdi
  803f81:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
  803f8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f99:	48 89 d6             	mov    %rdx,%rsi
  803f9c:	48 89 c7             	mov    %rax,%rdi
  803f9f:	48 b8 7a 3e 80 00 00 	movabs $0x803e7a,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
}
  803fab:	c9                   	leaveq 
  803fac:	c3                   	retq   

0000000000803fad <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fad:	55                   	push   %rbp
  803fae:	48 89 e5             	mov    %rsp,%rbp
  803fb1:	48 83 ec 40          	sub    $0x40,%rsp
  803fb5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fbd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc5:	48 89 c7             	mov    %rax,%rdi
  803fc8:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803fcf:	00 00 00 
  803fd2:	ff d0                	callq  *%rax
  803fd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fe0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fe7:	00 
  803fe8:	e9 97 00 00 00       	jmpq   804084 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803fed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ff2:	74 09                	je     803ffd <devpipe_read+0x50>
				return i;
  803ff4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff8:	e9 95 00 00 00       	jmpq   804092 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ffd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804001:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804005:	48 89 d6             	mov    %rdx,%rsi
  804008:	48 89 c7             	mov    %rax,%rdi
  80400b:	48 b8 7a 3e 80 00 00 	movabs $0x803e7a,%rax
  804012:	00 00 00 
  804015:	ff d0                	callq  *%rax
  804017:	85 c0                	test   %eax,%eax
  804019:	74 07                	je     804022 <devpipe_read+0x75>
				return 0;
  80401b:	b8 00 00 00 00       	mov    $0x0,%eax
  804020:	eb 70                	jmp    804092 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804022:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	eb 01                	jmp    804031 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804030:	90                   	nop
  804031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804035:	8b 10                	mov    (%rax),%edx
  804037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403b:	8b 40 04             	mov    0x4(%rax),%eax
  80403e:	39 c2                	cmp    %eax,%edx
  804040:	74 ab                	je     803fed <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804046:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80404a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80404e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804052:	8b 00                	mov    (%rax),%eax
  804054:	89 c2                	mov    %eax,%edx
  804056:	c1 fa 1f             	sar    $0x1f,%edx
  804059:	c1 ea 1b             	shr    $0x1b,%edx
  80405c:	01 d0                	add    %edx,%eax
  80405e:	83 e0 1f             	and    $0x1f,%eax
  804061:	29 d0                	sub    %edx,%eax
  804063:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804067:	48 98                	cltq   
  804069:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80406e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804074:	8b 00                	mov    (%rax),%eax
  804076:	8d 50 01             	lea    0x1(%rax),%edx
  804079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80407d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80407f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804088:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80408c:	72 a2                	jb     804030 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80408e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804092:	c9                   	leaveq 
  804093:	c3                   	retq   

0000000000804094 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804094:	55                   	push   %rbp
  804095:	48 89 e5             	mov    %rsp,%rbp
  804098:	48 83 ec 40          	sub    $0x40,%rsp
  80409c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ac:	48 89 c7             	mov    %rax,%rdi
  8040af:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  8040b6:	00 00 00 
  8040b9:	ff d0                	callq  *%rax
  8040bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040ce:	00 
  8040cf:	e9 93 00 00 00       	jmpq   804167 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040dc:	48 89 d6             	mov    %rdx,%rsi
  8040df:	48 89 c7             	mov    %rax,%rdi
  8040e2:	48 b8 7a 3e 80 00 00 	movabs $0x803e7a,%rax
  8040e9:	00 00 00 
  8040ec:	ff d0                	callq  *%rax
  8040ee:	85 c0                	test   %eax,%eax
  8040f0:	74 07                	je     8040f9 <devpipe_write+0x65>
				return 0;
  8040f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f7:	eb 7c                	jmp    804175 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040f9:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  804100:	00 00 00 
  804103:	ff d0                	callq  *%rax
  804105:	eb 01                	jmp    804108 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804107:	90                   	nop
  804108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410c:	8b 40 04             	mov    0x4(%rax),%eax
  80410f:	48 63 d0             	movslq %eax,%rdx
  804112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804116:	8b 00                	mov    (%rax),%eax
  804118:	48 98                	cltq   
  80411a:	48 83 c0 20          	add    $0x20,%rax
  80411e:	48 39 c2             	cmp    %rax,%rdx
  804121:	73 b1                	jae    8040d4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804127:	8b 40 04             	mov    0x4(%rax),%eax
  80412a:	89 c2                	mov    %eax,%edx
  80412c:	c1 fa 1f             	sar    $0x1f,%edx
  80412f:	c1 ea 1b             	shr    $0x1b,%edx
  804132:	01 d0                	add    %edx,%eax
  804134:	83 e0 1f             	and    $0x1f,%eax
  804137:	29 d0                	sub    %edx,%eax
  804139:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80413d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804141:	48 01 ca             	add    %rcx,%rdx
  804144:	0f b6 0a             	movzbl (%rdx),%ecx
  804147:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80414b:	48 98                	cltq   
  80414d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804155:	8b 40 04             	mov    0x4(%rax),%eax
  804158:	8d 50 01             	lea    0x1(%rax),%edx
  80415b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80415f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804162:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80416f:	72 96                	jb     804107 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804175:	c9                   	leaveq 
  804176:	c3                   	retq   

0000000000804177 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804177:	55                   	push   %rbp
  804178:	48 89 e5             	mov    %rsp,%rbp
  80417b:	48 83 ec 20          	sub    $0x20,%rsp
  80417f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80418b:	48 89 c7             	mov    %rax,%rdi
  80418e:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
  80419a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80419e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a2:	48 be 1f 4f 80 00 00 	movabs $0x804f1f,%rsi
  8041a9:	00 00 00 
  8041ac:	48 89 c7             	mov    %rax,%rdi
  8041af:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8041b6:	00 00 00 
  8041b9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bf:	8b 50 04             	mov    0x4(%rax),%edx
  8041c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c6:	8b 00                	mov    (%rax),%eax
  8041c8:	29 c2                	sub    %eax,%edx
  8041ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ce:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041d8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041df:	00 00 00 
	stat->st_dev = &devpipe;
  8041e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041e6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8041ed:	00 00 00 
  8041f0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8041f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041fc:	c9                   	leaveq 
  8041fd:	c3                   	retq   

00000000008041fe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041fe:	55                   	push   %rbp
  8041ff:	48 89 e5             	mov    %rsp,%rbp
  804202:	48 83 ec 10          	sub    $0x10,%rsp
  804206:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80420a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420e:	48 89 c6             	mov    %rax,%rsi
  804211:	bf 00 00 00 00       	mov    $0x0,%edi
  804216:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  80421d:	00 00 00 
  804220:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804226:	48 89 c7             	mov    %rax,%rdi
  804229:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  804230:	00 00 00 
  804233:	ff d0                	callq  *%rax
  804235:	48 89 c6             	mov    %rax,%rsi
  804238:	bf 00 00 00 00       	mov    $0x0,%edi
  80423d:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  804244:	00 00 00 
  804247:	ff d0                	callq  *%rax
}
  804249:	c9                   	leaveq 
  80424a:	c3                   	retq   
	...

000000000080424c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80424c:	55                   	push   %rbp
  80424d:	48 89 e5             	mov    %rsp,%rbp
  804250:	48 83 ec 20          	sub    $0x20,%rsp
  804254:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804257:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80425a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80425d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804261:	be 01 00 00 00       	mov    $0x1,%esi
  804266:	48 89 c7             	mov    %rax,%rdi
  804269:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  804270:	00 00 00 
  804273:	ff d0                	callq  *%rax
}
  804275:	c9                   	leaveq 
  804276:	c3                   	retq   

0000000000804277 <getchar>:

int
getchar(void)
{
  804277:	55                   	push   %rbp
  804278:	48 89 e5             	mov    %rsp,%rbp
  80427b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80427f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804283:	ba 01 00 00 00       	mov    $0x1,%edx
  804288:	48 89 c6             	mov    %rax,%rsi
  80428b:	bf 00 00 00 00       	mov    $0x0,%edi
  804290:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  804297:	00 00 00 
  80429a:	ff d0                	callq  *%rax
  80429c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80429f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a3:	79 05                	jns    8042aa <getchar+0x33>
		return r;
  8042a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a8:	eb 14                	jmp    8042be <getchar+0x47>
	if (r < 1)
  8042aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ae:	7f 07                	jg     8042b7 <getchar+0x40>
		return -E_EOF;
  8042b0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042b5:	eb 07                	jmp    8042be <getchar+0x47>
	return c;
  8042b7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042bb:	0f b6 c0             	movzbl %al,%eax
}
  8042be:	c9                   	leaveq 
  8042bf:	c3                   	retq   

00000000008042c0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042c0:	55                   	push   %rbp
  8042c1:	48 89 e5             	mov    %rsp,%rbp
  8042c4:	48 83 ec 20          	sub    $0x20,%rsp
  8042c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042d2:	48 89 d6             	mov    %rdx,%rsi
  8042d5:	89 c7                	mov    %eax,%edi
  8042d7:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8042de:	00 00 00 
  8042e1:	ff d0                	callq  *%rax
  8042e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ea:	79 05                	jns    8042f1 <iscons+0x31>
		return r;
  8042ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ef:	eb 1a                	jmp    80430b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8042f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f5:	8b 10                	mov    (%rax),%edx
  8042f7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8042fe:	00 00 00 
  804301:	8b 00                	mov    (%rax),%eax
  804303:	39 c2                	cmp    %eax,%edx
  804305:	0f 94 c0             	sete   %al
  804308:	0f b6 c0             	movzbl %al,%eax
}
  80430b:	c9                   	leaveq 
  80430c:	c3                   	retq   

000000000080430d <opencons>:

int
opencons(void)
{
  80430d:	55                   	push   %rbp
  80430e:	48 89 e5             	mov    %rsp,%rbp
  804311:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804315:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804319:	48 89 c7             	mov    %rax,%rdi
  80431c:	48 b8 96 1c 80 00 00 	movabs $0x801c96,%rax
  804323:	00 00 00 
  804326:	ff d0                	callq  *%rax
  804328:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80432b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80432f:	79 05                	jns    804336 <opencons+0x29>
		return r;
  804331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804334:	eb 5b                	jmp    804391 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433a:	ba 07 04 00 00       	mov    $0x407,%edx
  80433f:	48 89 c6             	mov    %rax,%rsi
  804342:	bf 00 00 00 00       	mov    $0x0,%edi
  804347:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  80434e:	00 00 00 
  804351:	ff d0                	callq  *%rax
  804353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80435a:	79 05                	jns    804361 <opencons+0x54>
		return r;
  80435c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435f:	eb 30                	jmp    804391 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804365:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80436c:	00 00 00 
  80436f:	8b 12                	mov    (%rdx),%edx
  804371:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804377:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80437e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804382:	48 89 c7             	mov    %rax,%rdi
  804385:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  80438c:	00 00 00 
  80438f:	ff d0                	callq  *%rax
}
  804391:	c9                   	leaveq 
  804392:	c3                   	retq   

0000000000804393 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804393:	55                   	push   %rbp
  804394:	48 89 e5             	mov    %rsp,%rbp
  804397:	48 83 ec 30          	sub    $0x30,%rsp
  80439b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80439f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043ac:	75 13                	jne    8043c1 <devcons_read+0x2e>
		return 0;
  8043ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b3:	eb 49                	jmp    8043fe <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8043b5:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  8043bc:	00 00 00 
  8043bf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043c1:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  8043c8:	00 00 00 
  8043cb:	ff d0                	callq  *%rax
  8043cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d4:	74 df                	je     8043b5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8043d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043da:	79 05                	jns    8043e1 <devcons_read+0x4e>
		return c;
  8043dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043df:	eb 1d                	jmp    8043fe <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8043e1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8043e5:	75 07                	jne    8043ee <devcons_read+0x5b>
		return 0;
  8043e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ec:	eb 10                	jmp    8043fe <devcons_read+0x6b>
	*(char*)vbuf = c;
  8043ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f1:	89 c2                	mov    %eax,%edx
  8043f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f7:	88 10                	mov    %dl,(%rax)
	return 1;
  8043f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043fe:	c9                   	leaveq 
  8043ff:	c3                   	retq   

0000000000804400 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804400:	55                   	push   %rbp
  804401:	48 89 e5             	mov    %rsp,%rbp
  804404:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80440b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804412:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804419:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804427:	eb 77                	jmp    8044a0 <devcons_write+0xa0>
		m = n - tot;
  804429:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804430:	89 c2                	mov    %eax,%edx
  804432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804435:	89 d1                	mov    %edx,%ecx
  804437:	29 c1                	sub    %eax,%ecx
  804439:	89 c8                	mov    %ecx,%eax
  80443b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80443e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804441:	83 f8 7f             	cmp    $0x7f,%eax
  804444:	76 07                	jbe    80444d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804446:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80444d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804450:	48 63 d0             	movslq %eax,%rdx
  804453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804456:	48 98                	cltq   
  804458:	48 89 c1             	mov    %rax,%rcx
  80445b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804462:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804469:	48 89 ce             	mov    %rcx,%rsi
  80446c:	48 89 c7             	mov    %rax,%rdi
  80446f:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80447b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80447e:	48 63 d0             	movslq %eax,%rdx
  804481:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804488:	48 89 d6             	mov    %rdx,%rsi
  80448b:	48 89 c7             	mov    %rax,%rdi
  80448e:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  804495:	00 00 00 
  804498:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80449a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80449d:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a3:	48 98                	cltq   
  8044a5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044ac:	0f 82 77 ff ff ff    	jb     804429 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044b5:	c9                   	leaveq 
  8044b6:	c3                   	retq   

00000000008044b7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044b7:	55                   	push   %rbp
  8044b8:	48 89 e5             	mov    %rsp,%rbp
  8044bb:	48 83 ec 08          	sub    $0x8,%rsp
  8044bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044c8:	c9                   	leaveq 
  8044c9:	c3                   	retq   

00000000008044ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044ca:	55                   	push   %rbp
  8044cb:	48 89 e5             	mov    %rsp,%rbp
  8044ce:	48 83 ec 10          	sub    $0x10,%rsp
  8044d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044de:	48 be 2b 4f 80 00 00 	movabs $0x804f2b,%rsi
  8044e5:	00 00 00 
  8044e8:	48 89 c7             	mov    %rax,%rdi
  8044eb:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8044f2:	00 00 00 
  8044f5:	ff d0                	callq  *%rax
	return 0;
  8044f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044fc:	c9                   	leaveq 
  8044fd:	c3                   	retq   
	...

0000000000804500 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804500:	55                   	push   %rbp
  804501:	48 89 e5             	mov    %rsp,%rbp
  804504:	48 83 ec 30          	sub    $0x30,%rsp
  804508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80450c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804510:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80451b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804520:	74 18                	je     80453a <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  804522:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804526:	48 89 c7             	mov    %rax,%rdi
  804529:	48 b8 21 1b 80 00 00 	movabs $0x801b21,%rax
  804530:	00 00 00 
  804533:	ff d0                	callq  *%rax
  804535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804538:	eb 19                	jmp    804553 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80453a:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  804541:	00 00 00 
  804544:	48 b8 21 1b 80 00 00 	movabs $0x801b21,%rax
  80454b:	00 00 00 
  80454e:	ff d0                	callq  *%rax
  804550:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  804553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804557:	79 39                	jns    804592 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804559:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80455e:	75 08                	jne    804568 <ipc_recv+0x68>
  804560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804564:	8b 00                	mov    (%rax),%eax
  804566:	eb 05                	jmp    80456d <ipc_recv+0x6d>
  804568:	b8 00 00 00 00       	mov    $0x0,%eax
  80456d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804571:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  804573:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804578:	75 08                	jne    804582 <ipc_recv+0x82>
  80457a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80457e:	8b 00                	mov    (%rax),%eax
  804580:	eb 05                	jmp    804587 <ipc_recv+0x87>
  804582:	b8 00 00 00 00       	mov    $0x0,%eax
  804587:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80458b:	89 02                	mov    %eax,(%rdx)
		return r;
  80458d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804590:	eb 53                	jmp    8045e5 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  804592:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804597:	74 19                	je     8045b2 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804599:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045a0:	00 00 00 
  8045a3:	48 8b 00             	mov    (%rax),%rax
  8045a6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8045ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b0:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  8045b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045b7:	74 19                	je     8045d2 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  8045b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045c0:	00 00 00 
  8045c3:	48 8b 00             	mov    (%rax),%rax
  8045c6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8045cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045d0:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  8045d2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045d9:	00 00 00 
  8045dc:	48 8b 00             	mov    (%rax),%rax
  8045df:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8045e5:	c9                   	leaveq 
  8045e6:	c3                   	retq   

00000000008045e7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045e7:	55                   	push   %rbp
  8045e8:	48 89 e5             	mov    %rsp,%rbp
  8045eb:	48 83 ec 30          	sub    $0x30,%rsp
  8045ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045f2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045f5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045f9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8045fc:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  804603:	eb 59                	jmp    80465e <ipc_send+0x77>
		if(pg) {
  804605:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80460a:	74 20                	je     80462c <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  80460c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80460f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804612:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804616:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804619:	89 c7                	mov    %eax,%edi
  80461b:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  804622:	00 00 00 
  804625:	ff d0                	callq  *%rax
  804627:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80462a:	eb 26                	jmp    804652 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  80462c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80462f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804632:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804635:	89 d1                	mov    %edx,%ecx
  804637:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80463e:	00 00 00 
  804641:	89 c7                	mov    %eax,%edi
  804643:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80464a:	00 00 00 
  80464d:	ff d0                	callq  *%rax
  80464f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  804652:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  804659:	00 00 00 
  80465c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  80465e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804662:	74 a1                	je     804605 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804664:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804668:	74 2a                	je     804694 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  80466a:	48 ba 38 4f 80 00 00 	movabs $0x804f38,%rdx
  804671:	00 00 00 
  804674:	be 49 00 00 00       	mov    $0x49,%esi
  804679:	48 bf 63 4f 80 00 00 	movabs $0x804f63,%rdi
  804680:	00 00 00 
  804683:	b8 00 00 00 00       	mov    $0x0,%eax
  804688:	48 b9 b4 01 80 00 00 	movabs $0x8001b4,%rcx
  80468f:	00 00 00 
  804692:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804694:	c9                   	leaveq 
  804695:	c3                   	retq   

0000000000804696 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804696:	55                   	push   %rbp
  804697:	48 89 e5             	mov    %rsp,%rbp
  80469a:	48 83 ec 18          	sub    $0x18,%rsp
  80469e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8046a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046a8:	eb 6a                	jmp    804714 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  8046aa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046b1:	00 00 00 
  8046b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b7:	48 63 d0             	movslq %eax,%rdx
  8046ba:	48 89 d0             	mov    %rdx,%rax
  8046bd:	48 c1 e0 02          	shl    $0x2,%rax
  8046c1:	48 01 d0             	add    %rdx,%rax
  8046c4:	48 01 c0             	add    %rax,%rax
  8046c7:	48 01 d0             	add    %rdx,%rax
  8046ca:	48 c1 e0 05          	shl    $0x5,%rax
  8046ce:	48 01 c8             	add    %rcx,%rax
  8046d1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8046d7:	8b 00                	mov    (%rax),%eax
  8046d9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046dc:	75 32                	jne    804710 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8046de:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046e5:	00 00 00 
  8046e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046eb:	48 63 d0             	movslq %eax,%rdx
  8046ee:	48 89 d0             	mov    %rdx,%rax
  8046f1:	48 c1 e0 02          	shl    $0x2,%rax
  8046f5:	48 01 d0             	add    %rdx,%rax
  8046f8:	48 01 c0             	add    %rax,%rax
  8046fb:	48 01 d0             	add    %rdx,%rax
  8046fe:	48 c1 e0 05          	shl    $0x5,%rax
  804702:	48 01 c8             	add    %rcx,%rax
  804705:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80470b:	8b 40 08             	mov    0x8(%rax),%eax
  80470e:	eb 12                	jmp    804722 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804710:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804714:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80471b:	7e 8d                	jle    8046aa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80471d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804722:	c9                   	leaveq 
  804723:	c3                   	retq   

0000000000804724 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804724:	55                   	push   %rbp
  804725:	48 89 e5             	mov    %rsp,%rbp
  804728:	48 83 ec 18          	sub    $0x18,%rsp
  80472c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804734:	48 89 c2             	mov    %rax,%rdx
  804737:	48 c1 ea 15          	shr    $0x15,%rdx
  80473b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804742:	01 00 00 
  804745:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804749:	83 e0 01             	and    $0x1,%eax
  80474c:	48 85 c0             	test   %rax,%rax
  80474f:	75 07                	jne    804758 <pageref+0x34>
		return 0;
  804751:	b8 00 00 00 00       	mov    $0x0,%eax
  804756:	eb 53                	jmp    8047ab <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80475c:	48 89 c2             	mov    %rax,%rdx
  80475f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804763:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80476a:	01 00 00 
  80476d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804779:	83 e0 01             	and    $0x1,%eax
  80477c:	48 85 c0             	test   %rax,%rax
  80477f:	75 07                	jne    804788 <pageref+0x64>
		return 0;
  804781:	b8 00 00 00 00       	mov    $0x0,%eax
  804786:	eb 23                	jmp    8047ab <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80478c:	48 89 c2             	mov    %rax,%rdx
  80478f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804793:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80479a:	00 00 00 
  80479d:	48 c1 e2 04          	shl    $0x4,%rdx
  8047a1:	48 01 d0             	add    %rdx,%rax
  8047a4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8047a8:	0f b7 c0             	movzwl %ax,%eax
}
  8047ab:	c9                   	leaveq 
  8047ac:	c3                   	retq   
