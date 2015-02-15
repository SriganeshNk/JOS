
obj/user/testtime.debug:     file format elf64-x86-64


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
  80003c:	e8 6b 01 00 00       	callq  8001ac <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004f:	48 b8 29 1c 80 00 00 	movabs $0x801c29,%rax
  800056:	00 00 00 
  800059:	ff d0                	callq  *%rax
  80005b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800061:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800067:	03 45 fc             	add    -0x4(%rbp),%eax
  80006a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  80006d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800070:	85 c0                	test   %eax,%eax
  800072:	79 38                	jns    8000ac <sleep+0x68>
  800074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800077:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007a:	7c 30                	jl     8000ac <sleep+0x68>
		panic("sys_time_msec: %e", (int)now);
  80007c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007f:	89 c1                	mov    %eax,%ecx
  800081:	48 ba 80 3c 80 00 00 	movabs $0x803c80,%rdx
  800088:	00 00 00 
  80008b:	be 0b 00 00 00       	mov    $0xb,%esi
  800090:	48 bf 92 3c 80 00 00 	movabs $0x803c92,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	49 b8 78 02 80 00 00 	movabs $0x800278,%r8
  8000a6:	00 00 00 
  8000a9:	41 ff d0             	callq  *%r8
	if (end < now)
  8000ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000af:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b2:	73 38                	jae    8000ec <sleep+0xa8>
		panic("sleep: wrap");
  8000b4:	48 ba a2 3c 80 00 00 	movabs $0x803ca2,%rdx
  8000bb:	00 00 00 
  8000be:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c3:	48 bf 92 3c 80 00 00 	movabs $0x803c92,%rdi
  8000ca:	00 00 00 
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  8000d9:	00 00 00 
  8000dc:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
		sys_yield();
  8000de:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	eb 01                	jmp    8000ed <sleep+0xa9>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ec:	90                   	nop
  8000ed:	48 b8 29 1c 80 00 00 	movabs $0x801c29,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
  8000f9:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fc:	72 e0                	jb     8000de <sleep+0x9a>
		sys_yield();
}
  8000fe:	c9                   	leaveq 
  8000ff:	c3                   	retq   

0000000000800100 <umain>:

void
umain(int argc, char **argv)
{
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
  800104:	48 83 ec 20          	sub    $0x20,%rsp
  800108:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  80010f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800116:	eb 10                	jmp    800128 <umain+0x28>
		sys_yield();
  800118:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800124:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800128:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012c:	7e ea                	jle    800118 <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  80012e:	48 bf ae 3c 80 00 00 	movabs $0x803cae,%rdi
  800135:	00 00 00 
  800138:	b8 00 00 00 00       	mov    $0x0,%eax
  80013d:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  800144:	00 00 00 
  800147:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  800149:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800150:	eb 35                	jmp    800187 <umain+0x87>
		cprintf("%d ", i);
  800152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800155:	89 c6                	mov    %eax,%esi
  800157:	48 bf c4 3c 80 00 00 	movabs $0x803cc4,%rdi
  80015e:	00 00 00 
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
  800166:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  80016d:	00 00 00 
  800170:	ff d2                	callq  *%rdx
		sleep(1);
  800172:	bf 01 00 00 00       	mov    $0x1,%edi
  800177:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800183:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018b:	79 c5                	jns    800152 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018d:	48 bf c8 3c 80 00 00 	movabs $0x803cc8,%rdi
  800194:	00 00 00 
  800197:	b8 00 00 00 00       	mov    $0x0,%eax
  80019c:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  8001a3:	00 00 00 
  8001a6:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  8001a8:	cc                   	int3   
	breakpoint();
}
  8001a9:	c9                   	leaveq 
  8001aa:	c3                   	retq   
	...

00000000008001ac <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
  8001b0:	48 83 ec 10          	sub    $0x10,%rsp
  8001b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001c2:	00 00 00 
  8001c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 40 19 80 00 00 	movabs $0x801940,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 98                	cltq   
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001e3:	48 89 d0             	mov    %rdx,%rax
  8001e6:	48 c1 e0 02          	shl    $0x2,%rax
  8001ea:	48 01 d0             	add    %rdx,%rax
  8001ed:	48 01 c0             	add    %rax,%rax
  8001f0:	48 01 d0             	add    %rdx,%rax
  8001f3:	48 c1 e0 05          	shl    $0x5,%rax
  8001f7:	48 89 c2             	mov    %rax,%rdx
  8001fa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800201:	00 00 00 
  800204:	48 01 c2             	add    %rax,%rdx
  800207:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80020e:	00 00 00 
  800211:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800214:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800218:	7e 14                	jle    80022e <libmain+0x82>
		binaryname = argv[0];
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	48 8b 10             	mov    (%rax),%rdx
  800221:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800228:	00 00 00 
  80022b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80022e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800232:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800235:	48 89 d6             	mov    %rdx,%rsi
  800238:	89 c7                	mov    %eax,%edi
  80023a:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800246:	48 b8 54 02 80 00 00 	movabs $0x800254,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
}
  800252:	c9                   	leaveq 
  800253:	c3                   	retq   

0000000000800254 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800254:	55                   	push   %rbp
  800255:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800258:	48 b8 4d 20 80 00 00 	movabs $0x80204d,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800264:	bf 00 00 00 00       	mov    $0x0,%edi
  800269:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
}
  800275:	5d                   	pop    %rbp
  800276:	c3                   	retq   
	...

0000000000800278 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	53                   	push   %rbx
  80027d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800284:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80028b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800291:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800298:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a6:	84 c0                	test   %al,%al
  8002a8:	74 23                	je     8002cd <_panic+0x55>
  8002aa:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002bd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002cd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002db:	00 00 00 
  8002de:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e5:	00 00 00 
  8002e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ec:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002f3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800301:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800308:	00 00 00 
  80030b:	48 8b 18             	mov    (%rax),%rbx
  80030e:	48 b8 40 19 80 00 00 	movabs $0x801940,%rax
  800315:	00 00 00 
  800318:	ff d0                	callq  *%rax
  80031a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800320:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800327:	41 89 c8             	mov    %ecx,%r8d
  80032a:	48 89 d1             	mov    %rdx,%rcx
  80032d:	48 89 da             	mov    %rbx,%rdx
  800330:	89 c6                	mov    %eax,%esi
  800332:	48 bf d8 3c 80 00 00 	movabs $0x803cd8,%rdi
  800339:	00 00 00 
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	49 b9 b3 04 80 00 00 	movabs $0x8004b3,%r9
  800348:	00 00 00 
  80034b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800355:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80035c:	48 89 d6             	mov    %rdx,%rsi
  80035f:	48 89 c7             	mov    %rax,%rdi
  800362:	48 b8 07 04 80 00 00 	movabs $0x800407,%rax
  800369:	00 00 00 
  80036c:	ff d0                	callq  *%rax
	cprintf("\n");
  80036e:	48 bf fb 3c 80 00 00 	movabs $0x803cfb,%rdi
  800375:	00 00 00 
  800378:	b8 00 00 00 00       	mov    $0x0,%eax
  80037d:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  800384:	00 00 00 
  800387:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800389:	cc                   	int3   
  80038a:	eb fd                	jmp    800389 <_panic+0x111>

000000000080038c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80038c:	55                   	push   %rbp
  80038d:	48 89 e5             	mov    %rsp,%rbp
  800390:	48 83 ec 10          	sub    $0x10,%rsp
  800394:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800397:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80039b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039f:	8b 00                	mov    (%rax),%eax
  8003a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a4:	89 d6                	mov    %edx,%esi
  8003a6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003aa:	48 63 d0             	movslq %eax,%rdx
  8003ad:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8003b2:	8d 50 01             	lea    0x1(%rax),%edx
  8003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b9:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8003bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bf:	8b 00                	mov    (%rax),%eax
  8003c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c6:	75 2c                	jne    8003f4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	8b 00                	mov    (%rax),%eax
  8003ce:	48 98                	cltq   
  8003d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d4:	48 83 c2 08          	add    $0x8,%rdx
  8003d8:	48 89 c6             	mov    %rax,%rsi
  8003db:	48 89 d7             	mov    %rdx,%rdi
  8003de:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
        b->idx = 0;
  8003ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	8b 40 04             	mov    0x4(%rax),%eax
  8003fb:	8d 50 01             	lea    0x1(%rax),%edx
  8003fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800402:	89 50 04             	mov    %edx,0x4(%rax)
}
  800405:	c9                   	leaveq 
  800406:	c3                   	retq   

0000000000800407 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800407:	55                   	push   %rbp
  800408:	48 89 e5             	mov    %rsp,%rbp
  80040b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800412:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800419:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800420:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800427:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80042e:	48 8b 0a             	mov    (%rdx),%rcx
  800431:	48 89 08             	mov    %rcx,(%rax)
  800434:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800438:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80043c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800440:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800444:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80044b:	00 00 00 
    b.cnt = 0;
  80044e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800455:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800458:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80045f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800466:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80046d:	48 89 c6             	mov    %rax,%rsi
  800470:	48 bf 8c 03 80 00 00 	movabs $0x80038c,%rdi
  800477:	00 00 00 
  80047a:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800486:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80048c:	48 98                	cltq   
  80048e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800495:	48 83 c2 08          	add    $0x8,%rdx
  800499:	48 89 c6             	mov    %rax,%rsi
  80049c:	48 89 d7             	mov    %rdx,%rdi
  80049f:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8004a6:	00 00 00 
  8004a9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b1:	c9                   	leaveq 
  8004b2:	c3                   	retq   

00000000008004b3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004be:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004cc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004da:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e1:	84 c0                	test   %al,%al
  8004e3:	74 20                	je     800505 <cprintf+0x52>
  8004e5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ed:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004fd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800501:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800505:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80050c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800513:	00 00 00 
  800516:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80051d:	00 00 00 
  800520:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800524:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80052b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800532:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800539:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800540:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800547:	48 8b 0a             	mov    (%rdx),%rcx
  80054a:	48 89 08             	mov    %rcx,(%rax)
  80054d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800551:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800555:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800559:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80055d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800564:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80056b:	48 89 d6             	mov    %rdx,%rsi
  80056e:	48 89 c7             	mov    %rax,%rdi
  800571:	48 b8 07 04 80 00 00 	movabs $0x800407,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800583:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800589:	c9                   	leaveq 
  80058a:	c3                   	retq   
	...

000000000080058c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058c:	55                   	push   %rbp
  80058d:	48 89 e5             	mov    %rsp,%rbp
  800590:	48 83 ec 30          	sub    $0x30,%rsp
  800594:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800598:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80059c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005a0:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005a3:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005a7:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005ae:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005b2:	77 52                	ja     800606 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005b7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005bb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005be:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005d8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e0:	41 89 f9             	mov    %edi,%r9d
  8005e3:	48 89 c7             	mov    %rax,%rdi
  8005e6:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
  8005f2:	eb 1c                	jmp    800610 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005ff:	48 89 d6             	mov    %rdx,%rsi
  800602:	89 c7                	mov    %eax,%edi
  800604:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800606:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80060a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80060e:	7f e4                	jg     8005f4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800610:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	48 f7 f1             	div    %rcx
  80061f:	48 89 d0             	mov    %rdx,%rax
  800622:	48 ba f0 3e 80 00 00 	movabs $0x803ef0,%rdx
  800629:	00 00 00 
  80062c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800630:	0f be c0             	movsbl %al,%eax
  800633:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800637:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80063b:	48 89 d6             	mov    %rdx,%rsi
  80063e:	89 c7                	mov    %eax,%edi
  800640:	ff d1                	callq  *%rcx
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 20          	sub    $0x20,%rsp
  80064c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800650:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800653:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800657:	7e 52                	jle    8006ab <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	83 f8 30             	cmp    $0x30,%eax
  800662:	73 24                	jae    800688 <getuint+0x44>
  800664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800668:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	89 c0                	mov    %eax,%eax
  800674:	48 01 d0             	add    %rdx,%rax
  800677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067b:	8b 12                	mov    (%rdx),%edx
  80067d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	89 0a                	mov    %ecx,(%rdx)
  800686:	eb 17                	jmp    80069f <getuint+0x5b>
  800688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800690:	48 89 d0             	mov    %rdx,%rax
  800693:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069f:	48 8b 00             	mov    (%rax),%rax
  8006a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a6:	e9 a3 00 00 00       	jmpq   80074e <getuint+0x10a>
	else if (lflag)
  8006ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006af:	74 4f                	je     800700 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	8b 00                	mov    (%rax),%eax
  8006b7:	83 f8 30             	cmp    $0x30,%eax
  8006ba:	73 24                	jae    8006e0 <getuint+0x9c>
  8006bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	8b 00                	mov    (%rax),%eax
  8006ca:	89 c0                	mov    %eax,%eax
  8006cc:	48 01 d0             	add    %rdx,%rax
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	8b 12                	mov    (%rdx),%edx
  8006d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dc:	89 0a                	mov    %ecx,(%rdx)
  8006de:	eb 17                	jmp    8006f7 <getuint+0xb3>
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e8:	48 89 d0             	mov    %rdx,%rax
  8006eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f7:	48 8b 00             	mov    (%rax),%rax
  8006fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fe:	eb 4e                	jmp    80074e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	8b 00                	mov    (%rax),%eax
  800706:	83 f8 30             	cmp    $0x30,%eax
  800709:	73 24                	jae    80072f <getuint+0xeb>
  80070b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	8b 00                	mov    (%rax),%eax
  800719:	89 c0                	mov    %eax,%eax
  80071b:	48 01 d0             	add    %rdx,%rax
  80071e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800722:	8b 12                	mov    (%rdx),%edx
  800724:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	89 0a                	mov    %ecx,(%rdx)
  80072d:	eb 17                	jmp    800746 <getuint+0x102>
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800737:	48 89 d0             	mov    %rdx,%rax
  80073a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800742:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800746:	8b 00                	mov    (%rax),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800752:	c9                   	leaveq 
  800753:	c3                   	retq   

0000000000800754 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 83 ec 20          	sub    $0x20,%rsp
  80075c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800760:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800763:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800767:	7e 52                	jle    8007bb <getint+0x67>
		x=va_arg(*ap, long long);
  800769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	83 f8 30             	cmp    $0x30,%eax
  800772:	73 24                	jae    800798 <getint+0x44>
  800774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800778:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	89 c0                	mov    %eax,%eax
  800784:	48 01 d0             	add    %rdx,%rax
  800787:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078b:	8b 12                	mov    (%rdx),%edx
  80078d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	89 0a                	mov    %ecx,(%rdx)
  800796:	eb 17                	jmp    8007af <getint+0x5b>
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a0:	48 89 d0             	mov    %rdx,%rax
  8007a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007af:	48 8b 00             	mov    (%rax),%rax
  8007b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b6:	e9 a3 00 00 00       	jmpq   80085e <getint+0x10a>
	else if (lflag)
  8007bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bf:	74 4f                	je     800810 <getint+0xbc>
		x=va_arg(*ap, long);
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	83 f8 30             	cmp    $0x30,%eax
  8007ca:	73 24                	jae    8007f0 <getint+0x9c>
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	89 c0                	mov    %eax,%eax
  8007dc:	48 01 d0             	add    %rdx,%rax
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	8b 12                	mov    (%rdx),%edx
  8007e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	89 0a                	mov    %ecx,(%rdx)
  8007ee:	eb 17                	jmp    800807 <getint+0xb3>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f8:	48 89 d0             	mov    %rdx,%rax
  8007fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080e:	eb 4e                	jmp    80085e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	83 f8 30             	cmp    $0x30,%eax
  800819:	73 24                	jae    80083f <getint+0xeb>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	8b 00                	mov    (%rax),%eax
  800829:	89 c0                	mov    %eax,%eax
  80082b:	48 01 d0             	add    %rdx,%rax
  80082e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800832:	8b 12                	mov    (%rdx),%edx
  800834:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	89 0a                	mov    %ecx,(%rdx)
  80083d:	eb 17                	jmp    800856 <getint+0x102>
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800847:	48 89 d0             	mov    %rdx,%rax
  80084a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800856:	8b 00                	mov    (%rax),%eax
  800858:	48 98                	cltq   
  80085a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800862:	c9                   	leaveq 
  800863:	c3                   	retq   

0000000000800864 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	41 54                	push   %r12
  80086a:	53                   	push   %rbx
  80086b:	48 83 ec 60          	sub    $0x60,%rsp
  80086f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800873:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800877:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80087b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800883:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800887:	48 8b 0a             	mov    (%rdx),%rcx
  80088a:	48 89 08             	mov    %rcx,(%rax)
  80088d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800891:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800895:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800899:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089d:	eb 17                	jmp    8008b6 <vprintfmt+0x52>
			if (ch == '\0')
  80089f:	85 db                	test   %ebx,%ebx
  8008a1:	0f 84 ea 04 00 00    	je     800d91 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8008a7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008ab:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8008af:	48 89 c6             	mov    %rax,%rsi
  8008b2:	89 df                	mov    %ebx,%edi
  8008b4:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ba:	0f b6 00             	movzbl (%rax),%eax
  8008bd:	0f b6 d8             	movzbl %al,%ebx
  8008c0:	83 fb 25             	cmp    $0x25,%ebx
  8008c3:	0f 95 c0             	setne  %al
  8008c6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008cb:	84 c0                	test   %al,%al
  8008cd:	75 d0                	jne    80089f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cf:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008d3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8008ef:	eb 04                	jmp    8008f5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8008f1:	90                   	nop
  8008f2:	eb 01                	jmp    8008f5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8008f4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f9:	0f b6 00             	movzbl (%rax),%eax
  8008fc:	0f b6 d8             	movzbl %al,%ebx
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800906:	83 e8 23             	sub    $0x23,%eax
  800909:	83 f8 55             	cmp    $0x55,%eax
  80090c:	0f 87 4b 04 00 00    	ja     800d5d <vprintfmt+0x4f9>
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80091b:	00 
  80091c:	48 b8 18 3f 80 00 00 	movabs $0x803f18,%rax
  800923:	00 00 00 
  800926:	48 01 d0             	add    %rdx,%rax
  800929:	48 8b 00             	mov    (%rax),%rax
  80092c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80092e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800932:	eb c1                	jmp    8008f5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800934:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800938:	eb bb                	jmp    8008f5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800941:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800944:	89 d0                	mov    %edx,%eax
  800946:	c1 e0 02             	shl    $0x2,%eax
  800949:	01 d0                	add    %edx,%eax
  80094b:	01 c0                	add    %eax,%eax
  80094d:	01 d8                	add    %ebx,%eax
  80094f:	83 e8 30             	sub    $0x30,%eax
  800952:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800955:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800959:	0f b6 00             	movzbl (%rax),%eax
  80095c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80095f:	83 fb 2f             	cmp    $0x2f,%ebx
  800962:	7e 63                	jle    8009c7 <vprintfmt+0x163>
  800964:	83 fb 39             	cmp    $0x39,%ebx
  800967:	7f 5e                	jg     8009c7 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800969:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096e:	eb d1                	jmp    800941 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800970:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800973:	83 f8 30             	cmp    $0x30,%eax
  800976:	73 17                	jae    80098f <vprintfmt+0x12b>
  800978:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80097c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097f:	89 c0                	mov    %eax,%eax
  800981:	48 01 d0             	add    %rdx,%rax
  800984:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800987:	83 c2 08             	add    $0x8,%edx
  80098a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80098d:	eb 0f                	jmp    80099e <vprintfmt+0x13a>
  80098f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800993:	48 89 d0             	mov    %rdx,%rax
  800996:	48 83 c2 08          	add    $0x8,%rdx
  80099a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099e:	8b 00                	mov    (%rax),%eax
  8009a0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009a3:	eb 23                	jmp    8009c8 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a9:	0f 89 42 ff ff ff    	jns    8008f1 <vprintfmt+0x8d>
				width = 0;
  8009af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b6:	e9 36 ff ff ff       	jmpq   8008f1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8009bb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009c2:	e9 2e ff ff ff       	jmpq   8008f5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cc:	0f 89 22 ff ff ff    	jns    8008f4 <vprintfmt+0x90>
				width = precision, precision = -1;
  8009d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009df:	e9 10 ff ff ff       	jmpq   8008f4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e8:	e9 08 ff ff ff       	jmpq   8008f5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f0:	83 f8 30             	cmp    $0x30,%eax
  8009f3:	73 17                	jae    800a0c <vprintfmt+0x1a8>
  8009f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fc:	89 c0                	mov    %eax,%eax
  8009fe:	48 01 d0             	add    %rdx,%rax
  800a01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a04:	83 c2 08             	add    $0x8,%edx
  800a07:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0a:	eb 0f                	jmp    800a1b <vprintfmt+0x1b7>
  800a0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a10:	48 89 d0             	mov    %rdx,%rax
  800a13:	48 83 c2 08          	add    $0x8,%rdx
  800a17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1b:	8b 00                	mov    (%rax),%eax
  800a1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a21:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a25:	48 89 d6             	mov    %rdx,%rsi
  800a28:	89 c7                	mov    %eax,%edi
  800a2a:	ff d1                	callq  *%rcx
			break;
  800a2c:	e9 5a 03 00 00       	jmpq   800d8b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	83 f8 30             	cmp    $0x30,%eax
  800a37:	73 17                	jae    800a50 <vprintfmt+0x1ec>
  800a39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a40:	89 c0                	mov    %eax,%eax
  800a42:	48 01 d0             	add    %rdx,%rax
  800a45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a48:	83 c2 08             	add    $0x8,%edx
  800a4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a4e:	eb 0f                	jmp    800a5f <vprintfmt+0x1fb>
  800a50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a54:	48 89 d0             	mov    %rdx,%rax
  800a57:	48 83 c2 08          	add    $0x8,%rdx
  800a5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a61:	85 db                	test   %ebx,%ebx
  800a63:	79 02                	jns    800a67 <vprintfmt+0x203>
				err = -err;
  800a65:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a67:	83 fb 15             	cmp    $0x15,%ebx
  800a6a:	7f 16                	jg     800a82 <vprintfmt+0x21e>
  800a6c:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  800a73:	00 00 00 
  800a76:	48 63 d3             	movslq %ebx,%rdx
  800a79:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a7d:	4d 85 e4             	test   %r12,%r12
  800a80:	75 2e                	jne    800ab0 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8a:	89 d9                	mov    %ebx,%ecx
  800a8c:	48 ba 01 3f 80 00 00 	movabs $0x803f01,%rdx
  800a93:	00 00 00 
  800a96:	48 89 c7             	mov    %rax,%rdi
  800a99:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9e:	49 b8 9b 0d 80 00 00 	movabs $0x800d9b,%r8
  800aa5:	00 00 00 
  800aa8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aab:	e9 db 02 00 00       	jmpq   800d8b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab8:	4c 89 e1             	mov    %r12,%rcx
  800abb:	48 ba 0a 3f 80 00 00 	movabs $0x803f0a,%rdx
  800ac2:	00 00 00 
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	49 b8 9b 0d 80 00 00 	movabs $0x800d9b,%r8
  800ad4:	00 00 00 
  800ad7:	41 ff d0             	callq  *%r8
			break;
  800ada:	e9 ac 02 00 00       	jmpq   800d8b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae2:	83 f8 30             	cmp    $0x30,%eax
  800ae5:	73 17                	jae    800afe <vprintfmt+0x29a>
  800ae7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	89 c0                	mov    %eax,%eax
  800af0:	48 01 d0             	add    %rdx,%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	83 c2 08             	add    $0x8,%edx
  800af9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afc:	eb 0f                	jmp    800b0d <vprintfmt+0x2a9>
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0d:	4c 8b 20             	mov    (%rax),%r12
  800b10:	4d 85 e4             	test   %r12,%r12
  800b13:	75 0a                	jne    800b1f <vprintfmt+0x2bb>
				p = "(null)";
  800b15:	49 bc 0d 3f 80 00 00 	movabs $0x803f0d,%r12
  800b1c:	00 00 00 
			if (width > 0 && padc != '-')
  800b1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b23:	7e 7a                	jle    800b9f <vprintfmt+0x33b>
  800b25:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b29:	74 74                	je     800b9f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2e:	48 98                	cltq   
  800b30:	48 89 c6             	mov    %rax,%rsi
  800b33:	4c 89 e7             	mov    %r12,%rdi
  800b36:	48 b8 46 10 80 00 00 	movabs $0x801046,%rax
  800b3d:	00 00 00 
  800b40:	ff d0                	callq  *%rax
  800b42:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b45:	eb 17                	jmp    800b5e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b47:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b53:	48 89 d6             	mov    %rdx,%rsi
  800b56:	89 c7                	mov    %eax,%edi
  800b58:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b62:	7f e3                	jg     800b47 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b64:	eb 39                	jmp    800b9f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b6a:	74 1e                	je     800b8a <vprintfmt+0x326>
  800b6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6f:	7e 05                	jle    800b76 <vprintfmt+0x312>
  800b71:	83 fb 7e             	cmp    $0x7e,%ebx
  800b74:	7e 14                	jle    800b8a <vprintfmt+0x326>
					putch('?', putdat);
  800b76:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b7a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b7e:	48 89 c6             	mov    %rax,%rsi
  800b81:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b86:	ff d2                	callq  *%rdx
  800b88:	eb 0f                	jmp    800b99 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b92:	48 89 c6             	mov    %rax,%rsi
  800b95:	89 df                	mov    %ebx,%edi
  800b97:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9d:	eb 01                	jmp    800ba0 <vprintfmt+0x33c>
  800b9f:	90                   	nop
  800ba0:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ba5:	0f be d8             	movsbl %al,%ebx
  800ba8:	85 db                	test   %ebx,%ebx
  800baa:	0f 95 c0             	setne  %al
  800bad:	49 83 c4 01          	add    $0x1,%r12
  800bb1:	84 c0                	test   %al,%al
  800bb3:	74 28                	je     800bdd <vprintfmt+0x379>
  800bb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb9:	78 ab                	js     800b66 <vprintfmt+0x302>
  800bbb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bbf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc3:	79 a1                	jns    800b66 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc5:	eb 16                	jmp    800bdd <vprintfmt+0x379>
				putch(' ', putdat);
  800bc7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bcb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bcf:	48 89 c6             	mov    %rax,%rsi
  800bd2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bdd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be1:	7f e4                	jg     800bc7 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800be3:	e9 a3 01 00 00       	jmpq   800d8b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bec:	be 03 00 00 00       	mov    $0x3,%esi
  800bf1:	48 89 c7             	mov    %rax,%rdi
  800bf4:	48 b8 54 07 80 00 00 	movabs $0x800754,%rax
  800bfb:	00 00 00 
  800bfe:	ff d0                	callq  *%rax
  800c00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c08:	48 85 c0             	test   %rax,%rax
  800c0b:	79 1d                	jns    800c2a <vprintfmt+0x3c6>
				putch('-', putdat);
  800c0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c15:	48 89 c6             	mov    %rax,%rsi
  800c18:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c1d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c23:	48 f7 d8             	neg    %rax
  800c26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c31:	e9 e8 00 00 00       	jmpq   800d1e <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c36:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3a:	be 03 00 00 00       	mov    $0x3,%esi
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800c49:	00 00 00 
  800c4c:	ff d0                	callq  *%rax
  800c4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c52:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c59:	e9 c0 00 00 00       	jmpq   800d1e <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c66:	48 89 c6             	mov    %rax,%rsi
  800c69:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800c70:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c74:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c78:	48 89 c6             	mov    %rax,%rsi
  800c7b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c80:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800c82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8a:	48 89 c6             	mov    %rax,%rsi
  800c8d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c92:	ff d2                	callq  *%rdx
			break;
  800c94:	e9 f2 00 00 00       	jmpq   800d8b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800c99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca1:	48 89 c6             	mov    %rax,%rsi
  800ca4:	bf 30 00 00 00       	mov    $0x30,%edi
  800ca9:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800cab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800caf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cb3:	48 89 c6             	mov    %rax,%rsi
  800cb6:	bf 78 00 00 00       	mov    $0x78,%edi
  800cbb:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc0:	83 f8 30             	cmp    $0x30,%eax
  800cc3:	73 17                	jae    800cdc <vprintfmt+0x478>
  800cc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccc:	89 c0                	mov    %eax,%eax
  800cce:	48 01 d0             	add    %rdx,%rax
  800cd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd4:	83 c2 08             	add    $0x8,%edx
  800cd7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cda:	eb 0f                	jmp    800ceb <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800cdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce0:	48 89 d0             	mov    %rdx,%rax
  800ce3:	48 83 c2 08          	add    $0x8,%rdx
  800ce7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ceb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cf2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cf9:	eb 23                	jmp    800d1e <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cfb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cff:	be 03 00 00 00       	mov    $0x3,%esi
  800d04:	48 89 c7             	mov    %rax,%rdi
  800d07:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800d0e:	00 00 00 
  800d11:	ff d0                	callq  *%rax
  800d13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d23:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d26:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d35:	45 89 c1             	mov    %r8d,%r9d
  800d38:	41 89 f8             	mov    %edi,%r8d
  800d3b:	48 89 c7             	mov    %rax,%rdi
  800d3e:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
			break;
  800d4a:	eb 3f                	jmp    800d8b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d50:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d54:	48 89 c6             	mov    %rax,%rsi
  800d57:	89 df                	mov    %ebx,%edi
  800d59:	ff d2                	callq  *%rdx
			break;
  800d5b:	eb 2e                	jmp    800d8b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d5d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d61:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d65:	48 89 c6             	mov    %rax,%rsi
  800d68:	bf 25 00 00 00       	mov    $0x25,%edi
  800d6d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d74:	eb 05                	jmp    800d7b <vprintfmt+0x517>
  800d76:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d7b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d7f:	48 83 e8 01          	sub    $0x1,%rax
  800d83:	0f b6 00             	movzbl (%rax),%eax
  800d86:	3c 25                	cmp    $0x25,%al
  800d88:	75 ec                	jne    800d76 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800d8a:	90                   	nop
		}
	}
  800d8b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8c:	e9 25 fb ff ff       	jmpq   8008b6 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d91:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d92:	48 83 c4 60          	add    $0x60,%rsp
  800d96:	5b                   	pop    %rbx
  800d97:	41 5c                	pop    %r12
  800d99:	5d                   	pop    %rbp
  800d9a:	c3                   	retq   

0000000000800d9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9b:	55                   	push   %rbp
  800d9c:	48 89 e5             	mov    %rsp,%rbp
  800d9f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800da6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dad:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800db4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc9:	84 c0                	test   %al,%al
  800dcb:	74 20                	je     800ded <printfmt+0x52>
  800dcd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ddd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ded:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800df4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dfb:	00 00 00 
  800dfe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e05:	00 00 00 
  800e08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e13:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e21:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e28:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e2f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e3d:	48 89 c7             	mov    %rax,%rdi
  800e40:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800e47:	00 00 00 
  800e4a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e4c:	c9                   	leaveq 
  800e4d:	c3                   	retq   

0000000000800e4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
  800e52:	48 83 ec 10          	sub    $0x10,%rsp
  800e56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e61:	8b 40 10             	mov    0x10(%rax),%eax
  800e64:	8d 50 01             	lea    0x1(%rax),%edx
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	48 8b 10             	mov    (%rax),%rdx
  800e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e79:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e7d:	48 39 c2             	cmp    %rax,%rdx
  800e80:	73 17                	jae    800e99 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e86:	48 8b 00             	mov    (%rax),%rax
  800e89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e8c:	88 10                	mov    %dl,(%rax)
  800e8e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e96:	48 89 10             	mov    %rdx,(%rax)
}
  800e99:	c9                   	leaveq 
  800e9a:	c3                   	retq   

0000000000800e9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9b:	55                   	push   %rbp
  800e9c:	48 89 e5             	mov    %rsp,%rbp
  800e9f:	48 83 ec 50          	sub    $0x50,%rsp
  800ea3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ea7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eaa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eb2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eb6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eba:	48 8b 0a             	mov    (%rdx),%rcx
  800ebd:	48 89 08             	mov    %rcx,(%rax)
  800ec0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ec4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ecc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ed0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ed8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800edb:	48 98                	cltq   
  800edd:	48 83 e8 01          	sub    $0x1,%rax
  800ee1:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800ee5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ee9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ef0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ef5:	74 06                	je     800efd <vsnprintf+0x62>
  800ef7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800efb:	7f 07                	jg     800f04 <vsnprintf+0x69>
		return -E_INVAL;
  800efd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f02:	eb 2f                	jmp    800f33 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f04:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f08:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f0c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f10:	48 89 c6             	mov    %rax,%rsi
  800f13:	48 bf 4e 0e 80 00 00 	movabs $0x800e4e,%rdi
  800f1a:	00 00 00 
  800f1d:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f30:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f40:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f47:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f4d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f54:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f5b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f62:	84 c0                	test   %al,%al
  800f64:	74 20                	je     800f86 <snprintf+0x51>
  800f66:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f6a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f6e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f72:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f76:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f7a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f7e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f82:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f86:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f8d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f94:	00 00 00 
  800f97:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f9e:	00 00 00 
  800fa1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fb3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fba:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fc1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fc8:	48 8b 0a             	mov    (%rdx),%rcx
  800fcb:	48 89 08             	mov    %rcx,(%rax)
  800fce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fda:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fde:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fe5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fec:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ff2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 9b 0e 80 00 00 	movabs $0x800e9b,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
  801008:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80100e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   
	...

0000000000801018 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801018:	55                   	push   %rbp
  801019:	48 89 e5             	mov    %rsp,%rbp
  80101c:	48 83 ec 18          	sub    $0x18,%rsp
  801020:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102b:	eb 09                	jmp    801036 <strlen+0x1e>
		n++;
  80102d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801031:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103a:	0f b6 00             	movzbl (%rax),%eax
  80103d:	84 c0                	test   %al,%al
  80103f:	75 ec                	jne    80102d <strlen+0x15>
		n++;
	return n;
  801041:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801044:	c9                   	leaveq 
  801045:	c3                   	retq   

0000000000801046 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801046:	55                   	push   %rbp
  801047:	48 89 e5             	mov    %rsp,%rbp
  80104a:	48 83 ec 20          	sub    $0x20,%rsp
  80104e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105d:	eb 0e                	jmp    80106d <strnlen+0x27>
		n++;
  80105f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801063:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801068:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80106d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801072:	74 0b                	je     80107f <strnlen+0x39>
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	0f b6 00             	movzbl (%rax),%eax
  80107b:	84 c0                	test   %al,%al
  80107d:	75 e0                	jne    80105f <strnlen+0x19>
		n++;
	return n;
  80107f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 20          	sub    $0x20,%rsp
  80108c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801090:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80109c:	90                   	nop
  80109d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a1:	0f b6 10             	movzbl (%rax),%edx
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	88 10                	mov    %dl,(%rax)
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	0f b6 00             	movzbl (%rax),%eax
  8010b1:	84 c0                	test   %al,%al
  8010b3:	0f 95 c0             	setne  %al
  8010b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010bb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8010c0:	84 c0                	test   %al,%al
  8010c2:	75 d9                	jne    80109d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c8:	c9                   	leaveq 
  8010c9:	c3                   	retq   

00000000008010ca <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ca:	55                   	push   %rbp
  8010cb:	48 89 e5             	mov    %rsp,%rbp
  8010ce:	48 83 ec 20          	sub    $0x20,%rsp
  8010d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 89 c7             	mov    %rax,%rdi
  8010e1:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  8010e8:	00 00 00 
  8010eb:	ff d0                	callq  *%rax
  8010ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010f3:	48 98                	cltq   
  8010f5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010fd:	48 89 d6             	mov    %rdx,%rsi
  801100:	48 89 c7             	mov    %rax,%rdi
  801103:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  80110a:	00 00 00 
  80110d:	ff d0                	callq  *%rax
	return dst;
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 28          	sub    $0x28,%rsp
  80111d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801121:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801125:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801131:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801138:	00 
  801139:	eb 27                	jmp    801162 <strncpy+0x4d>
		*dst++ = *src;
  80113b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113f:	0f b6 10             	movzbl (%rax),%edx
  801142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801146:	88 10                	mov    %dl,(%rax)
  801148:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80114d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801151:	0f b6 00             	movzbl (%rax),%eax
  801154:	84 c0                	test   %al,%al
  801156:	74 05                	je     80115d <strncpy+0x48>
			src++;
  801158:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80115d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801166:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80116a:	72 cf                	jb     80113b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80116c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801170:	c9                   	leaveq 
  801171:	c3                   	retq   

0000000000801172 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801172:	55                   	push   %rbp
  801173:	48 89 e5             	mov    %rsp,%rbp
  801176:	48 83 ec 28          	sub    $0x28,%rsp
  80117a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801182:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80118e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801193:	74 37                	je     8011cc <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801195:	eb 17                	jmp    8011ae <strlcpy+0x3c>
			*dst++ = *src++;
  801197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119b:	0f b6 10             	movzbl (%rax),%edx
  80119e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a2:	88 10                	mov    %dl,(%rax)
  8011a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011a9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b8:	74 0b                	je     8011c5 <strlcpy+0x53>
  8011ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	75 d2                	jne    801197 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d4:	48 89 d1             	mov    %rdx,%rcx
  8011d7:	48 29 c1             	sub    %rax,%rcx
  8011da:	48 89 c8             	mov    %rcx,%rax
}
  8011dd:	c9                   	leaveq 
  8011de:	c3                   	retq   

00000000008011df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011df:	55                   	push   %rbp
  8011e0:	48 89 e5             	mov    %rsp,%rbp
  8011e3:	48 83 ec 10          	sub    $0x10,%rsp
  8011e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ef:	eb 0a                	jmp    8011fb <strcmp+0x1c>
		p++, q++;
  8011f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	84 c0                	test   %al,%al
  801204:	74 12                	je     801218 <strcmp+0x39>
  801206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120a:	0f b6 10             	movzbl (%rax),%edx
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	38 c2                	cmp    %al,%dl
  801216:	74 d9                	je     8011f1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	0f b6 00             	movzbl (%rax),%eax
  80121f:	0f b6 d0             	movzbl %al,%edx
  801222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	0f b6 c0             	movzbl %al,%eax
  80122c:	89 d1                	mov    %edx,%ecx
  80122e:	29 c1                	sub    %eax,%ecx
  801230:	89 c8                	mov    %ecx,%eax
}
  801232:	c9                   	leaveq 
  801233:	c3                   	retq   

0000000000801234 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	48 83 ec 18          	sub    $0x18,%rsp
  80123c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801240:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801244:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801248:	eb 0f                	jmp    801259 <strncmp+0x25>
		n--, p++, q++;
  80124a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80124f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801254:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801259:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80125e:	74 1d                	je     80127d <strncmp+0x49>
  801260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801264:	0f b6 00             	movzbl (%rax),%eax
  801267:	84 c0                	test   %al,%al
  801269:	74 12                	je     80127d <strncmp+0x49>
  80126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126f:	0f b6 10             	movzbl (%rax),%edx
  801272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801276:	0f b6 00             	movzbl (%rax),%eax
  801279:	38 c2                	cmp    %al,%dl
  80127b:	74 cd                	je     80124a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80127d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801282:	75 07                	jne    80128b <strncmp+0x57>
		return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	eb 1a                	jmp    8012a5 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80128b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128f:	0f b6 00             	movzbl (%rax),%eax
  801292:	0f b6 d0             	movzbl %al,%edx
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	0f b6 c0             	movzbl %al,%eax
  80129f:	89 d1                	mov    %edx,%ecx
  8012a1:	29 c1                	sub    %eax,%ecx
  8012a3:	89 c8                	mov    %ecx,%eax
}
  8012a5:	c9                   	leaveq 
  8012a6:	c3                   	retq   

00000000008012a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	48 83 ec 10          	sub    $0x10,%rsp
  8012af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b3:	89 f0                	mov    %esi,%eax
  8012b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b8:	eb 17                	jmp    8012d1 <strchr+0x2a>
		if (*s == c)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c4:	75 06                	jne    8012cc <strchr+0x25>
			return (char *) s;
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	eb 15                	jmp    8012e1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 de                	jne    8012ba <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e1:	c9                   	leaveq 
  8012e2:	c3                   	retq   

00000000008012e3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e3:	55                   	push   %rbp
  8012e4:	48 89 e5             	mov    %rsp,%rbp
  8012e7:	48 83 ec 10          	sub    $0x10,%rsp
  8012eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ef:	89 f0                	mov    %esi,%eax
  8012f1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f4:	eb 11                	jmp    801307 <strfind+0x24>
		if (*s == c)
  8012f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801300:	74 12                	je     801314 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 e4                	jne    8012f6 <strfind+0x13>
  801312:	eb 01                	jmp    801315 <strfind+0x32>
		if (*s == c)
			break;
  801314:	90                   	nop
	return (char *) s;
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 18          	sub    $0x18,%rsp
  801323:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801327:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80132a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80132e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801333:	75 06                	jne    80133b <memset+0x20>
		return v;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	eb 69                	jmp    8013a4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80133b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133f:	83 e0 03             	and    $0x3,%eax
  801342:	48 85 c0             	test   %rax,%rax
  801345:	75 48                	jne    80138f <memset+0x74>
  801347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134b:	83 e0 03             	and    $0x3,%eax
  80134e:	48 85 c0             	test   %rax,%rax
  801351:	75 3c                	jne    80138f <memset+0x74>
		c &= 0xFF;
  801353:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80135a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	c1 e2 18             	shl    $0x18,%edx
  801362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801365:	c1 e0 10             	shl    $0x10,%eax
  801368:	09 c2                	or     %eax,%edx
  80136a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136d:	c1 e0 08             	shl    $0x8,%eax
  801370:	09 d0                	or     %edx,%eax
  801372:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 89 c1             	mov    %rax,%rcx
  80137c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801380:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801384:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801387:	48 89 d7             	mov    %rdx,%rdi
  80138a:	fc                   	cld    
  80138b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80138d:	eb 11                	jmp    8013a0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80138f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801393:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801396:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80139a:	48 89 d7             	mov    %rdx,%rdi
  80139d:	fc                   	cld    
  80139e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 28          	sub    $0x28,%rsp
  8013ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d2:	0f 83 88 00 00 00    	jae    801460 <memmove+0xba>
  8013d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e0:	48 01 d0             	add    %rdx,%rax
  8013e3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e7:	76 77                	jbe    801460 <memmove+0xba>
		s += n;
  8013e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ed:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 3b                	jne    801440 <memmove+0x9a>
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	83 e0 03             	and    $0x3,%eax
  80140c:	48 85 c0             	test   %rax,%rax
  80140f:	75 2f                	jne    801440 <memmove+0x9a>
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	83 e0 03             	and    $0x3,%eax
  801418:	48 85 c0             	test   %rax,%rax
  80141b:	75 23                	jne    801440 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80141d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801421:	48 83 e8 04          	sub    $0x4,%rax
  801425:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801429:	48 83 ea 04          	sub    $0x4,%rdx
  80142d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801431:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801435:	48 89 c7             	mov    %rax,%rdi
  801438:	48 89 d6             	mov    %rdx,%rsi
  80143b:	fd                   	std    
  80143c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143e:	eb 1d                	jmp    80145d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801444:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801454:	48 89 d7             	mov    %rdx,%rdi
  801457:	48 89 c1             	mov    %rax,%rcx
  80145a:	fd                   	std    
  80145b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80145d:	fc                   	cld    
  80145e:	eb 57                	jmp    8014b7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 36                	jne    8014a2 <memmove+0xfc>
  80146c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801470:	83 e0 03             	and    $0x3,%eax
  801473:	48 85 c0             	test   %rax,%rax
  801476:	75 2a                	jne    8014a2 <memmove+0xfc>
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	83 e0 03             	and    $0x3,%eax
  80147f:	48 85 c0             	test   %rax,%rax
  801482:	75 1e                	jne    8014a2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801488:	48 89 c1             	mov    %rax,%rcx
  80148b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80148f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801493:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801497:	48 89 c7             	mov    %rax,%rdi
  80149a:	48 89 d6             	mov    %rdx,%rsi
  80149d:	fc                   	cld    
  80149e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a0:	eb 15                	jmp    8014b7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ae:	48 89 c7             	mov    %rax,%rdi
  8014b1:	48 89 d6             	mov    %rdx,%rsi
  8014b4:	fc                   	cld    
  8014b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014bb:	c9                   	leaveq 
  8014bc:	c3                   	retq   

00000000008014bd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014bd:	55                   	push   %rbp
  8014be:	48 89 e5             	mov    %rsp,%rbp
  8014c1:	48 83 ec 18          	sub    $0x18,%rsp
  8014c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014d5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	48 89 ce             	mov    %rcx,%rsi
  8014e0:	48 89 c7             	mov    %rax,%rdi
  8014e3:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  8014ea:	00 00 00 
  8014ed:	ff d0                	callq  *%rax
}
  8014ef:	c9                   	leaveq 
  8014f0:	c3                   	retq   

00000000008014f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014f1:	55                   	push   %rbp
  8014f2:	48 89 e5             	mov    %rsp,%rbp
  8014f5:	48 83 ec 28          	sub    $0x28,%rsp
  8014f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801501:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801509:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80150d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801511:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801515:	eb 38                	jmp    80154f <memcmp+0x5e>
		if (*s1 != *s2)
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151b:	0f b6 10             	movzbl (%rax),%edx
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	38 c2                	cmp    %al,%dl
  801527:	74 1c                	je     801545 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f b6 d0             	movzbl %al,%edx
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	0f b6 c0             	movzbl %al,%eax
  80153d:	89 d1                	mov    %edx,%ecx
  80153f:	29 c1                	sub    %eax,%ecx
  801541:	89 c8                	mov    %ecx,%eax
  801543:	eb 20                	jmp    801565 <memcmp+0x74>
		s1++, s2++;
  801545:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80154f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801554:	0f 95 c0             	setne  %al
  801557:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80155c:	84 c0                	test   %al,%al
  80155e:	75 b7                	jne    801517 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801565:	c9                   	leaveq 
  801566:	c3                   	retq   

0000000000801567 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801567:	55                   	push   %rbp
  801568:	48 89 e5             	mov    %rsp,%rbp
  80156b:	48 83 ec 28          	sub    $0x28,%rsp
  80156f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801573:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801576:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801582:	48 01 d0             	add    %rdx,%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801589:	eb 13                	jmp    80159e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80158b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158f:	0f b6 10             	movzbl (%rax),%edx
  801592:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801595:	38 c2                	cmp    %al,%dl
  801597:	74 11                	je     8015aa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801599:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015a6:	72 e3                	jb     80158b <memfind+0x24>
  8015a8:	eb 01                	jmp    8015ab <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015aa:	90                   	nop
	return (void *) s;
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015af:	c9                   	leaveq 
  8015b0:	c3                   	retq   

00000000008015b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015b1:	55                   	push   %rbp
  8015b2:	48 89 e5             	mov    %rsp,%rbp
  8015b5:	48 83 ec 38          	sub    $0x38,%rsp
  8015b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d3:	eb 05                	jmp    8015da <strtol+0x29>
		s++;
  8015d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 20                	cmp    $0x20,%al
  8015e3:	74 f0                	je     8015d5 <strtol+0x24>
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	3c 09                	cmp    $0x9,%al
  8015ee:	74 e5                	je     8015d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3c 2b                	cmp    $0x2b,%al
  8015f9:	75 07                	jne    801602 <strtol+0x51>
		s++;
  8015fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801600:	eb 17                	jmp    801619 <strtol+0x68>
	else if (*s == '-')
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 2d                	cmp    $0x2d,%al
  80160b:	75 0c                	jne    801619 <strtol+0x68>
		s++, neg = 1;
  80160d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801612:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801619:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161d:	74 06                	je     801625 <strtol+0x74>
  80161f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801623:	75 28                	jne    80164d <strtol+0x9c>
  801625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801629:	0f b6 00             	movzbl (%rax),%eax
  80162c:	3c 30                	cmp    $0x30,%al
  80162e:	75 1d                	jne    80164d <strtol+0x9c>
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	48 83 c0 01          	add    $0x1,%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 78                	cmp    $0x78,%al
  80163d:	75 0e                	jne    80164d <strtol+0x9c>
		s += 2, base = 16;
  80163f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801644:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80164b:	eb 2c                	jmp    801679 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80164d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801651:	75 19                	jne    80166c <strtol+0xbb>
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 30                	cmp    $0x30,%al
  80165c:	75 0e                	jne    80166c <strtol+0xbb>
		s++, base = 8;
  80165e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801663:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80166a:	eb 0d                	jmp    801679 <strtol+0xc8>
	else if (base == 0)
  80166c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801670:	75 07                	jne    801679 <strtol+0xc8>
		base = 10;
  801672:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 2f                	cmp    $0x2f,%al
  801682:	7e 1d                	jle    8016a1 <strtol+0xf0>
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 39                	cmp    $0x39,%al
  80168d:	7f 12                	jg     8016a1 <strtol+0xf0>
			dig = *s - '0';
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	0f be c0             	movsbl %al,%eax
  801699:	83 e8 30             	sub    $0x30,%eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169f:	eb 4e                	jmp    8016ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 60                	cmp    $0x60,%al
  8016aa:	7e 1d                	jle    8016c9 <strtol+0x118>
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	3c 7a                	cmp    $0x7a,%al
  8016b5:	7f 12                	jg     8016c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f be c0             	movsbl %al,%eax
  8016c1:	83 e8 57             	sub    $0x57,%eax
  8016c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c7:	eb 26                	jmp    8016ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 40                	cmp    $0x40,%al
  8016d2:	7e 47                	jle    80171b <strtol+0x16a>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 5a                	cmp    $0x5a,%al
  8016dd:	7f 3c                	jg     80171b <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	0f be c0             	movsbl %al,%eax
  8016e9:	83 e8 37             	sub    $0x37,%eax
  8016ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016f5:	7d 23                	jge    80171a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016ff:	48 98                	cltq   
  801701:	48 89 c2             	mov    %rax,%rdx
  801704:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801709:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170c:	48 98                	cltq   
  80170e:	48 01 d0             	add    %rdx,%rax
  801711:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801715:	e9 5f ff ff ff       	jmpq   801679 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80171a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80171b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801720:	74 0b                	je     80172d <strtol+0x17c>
		*endptr = (char *) s;
  801722:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801726:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80172a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80172d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801731:	74 09                	je     80173c <strtol+0x18b>
  801733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801737:	48 f7 d8             	neg    %rax
  80173a:	eb 04                	jmp    801740 <strtol+0x18f>
  80173c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801740:	c9                   	leaveq 
  801741:	c3                   	retq   

0000000000801742 <strstr>:

char * strstr(const char *in, const char *str)
{
  801742:	55                   	push   %rbp
  801743:	48 89 e5             	mov    %rsp,%rbp
  801746:	48 83 ec 30          	sub    $0x30,%rsp
  80174a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	88 45 ff             	mov    %al,-0x1(%rbp)
  80175c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801761:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801765:	75 06                	jne    80176d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	eb 68                	jmp    8017d5 <strstr+0x93>

	len = strlen(str);
  80176d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801771:	48 89 c7             	mov    %rax,%rdi
  801774:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
  801780:	48 98                	cltq   
  801782:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	0f b6 00             	movzbl (%rax),%eax
  80178d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801790:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801795:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801799:	75 07                	jne    8017a2 <strstr+0x60>
				return (char *) 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a0:	eb 33                	jmp    8017d5 <strstr+0x93>
		} while (sc != c);
  8017a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017a9:	75 db                	jne    801786 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8017ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	48 89 ce             	mov    %rcx,%rsi
  8017ba:	48 89 c7             	mov    %rax,%rdi
  8017bd:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8017c4:	00 00 00 
  8017c7:	ff d0                	callq  *%rax
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	75 b9                	jne    801786 <strstr+0x44>

	return (char *) (in - 1);
  8017cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8017d5:	c9                   	leaveq 
  8017d6:	c3                   	retq   
	...

00000000008017d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017d8:	55                   	push   %rbp
  8017d9:	48 89 e5             	mov    %rsp,%rbp
  8017dc:	53                   	push   %rbx
  8017dd:	48 83 ec 58          	sub    $0x58,%rsp
  8017e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fa:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8017fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801801:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801805:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801809:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80180d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801811:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801814:	4c 89 c3             	mov    %r8,%rbx
  801817:	cd 30                	int    $0x30
  801819:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80181d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801821:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801825:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801829:	74 3e                	je     801869 <syscall+0x91>
  80182b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801830:	7e 37                	jle    801869 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801836:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801839:	49 89 d0             	mov    %rdx,%r8
  80183c:	89 c1                	mov    %eax,%ecx
  80183e:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  801845:	00 00 00 
  801848:	be 23 00 00 00       	mov    $0x23,%esi
  80184d:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801854:	00 00 00 
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
  80185c:	49 b9 78 02 80 00 00 	movabs $0x800278,%r9
  801863:	00 00 00 
  801866:	41 ff d1             	callq  *%r9

	return ret;
  801869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80186d:	48 83 c4 58          	add    $0x58,%rsp
  801871:	5b                   	pop    %rbx
  801872:	5d                   	pop    %rbp
  801873:	c3                   	retq   

0000000000801874 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 20          	sub    $0x20,%rsp
  80187c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801884:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801888:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801893:	00 
  801894:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a0:	48 89 d1             	mov    %rdx,%rcx
  8018a3:	48 89 c2             	mov    %rax,%rdx
  8018a6:	be 00 00 00 00       	mov    $0x0,%esi
  8018ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b0:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
}
  8018bc:	c9                   	leaveq 
  8018bd:	c3                   	retq   

00000000008018be <sys_cgetc>:

int
sys_cgetc(void)
{
  8018be:	55                   	push   %rbp
  8018bf:	48 89 e5             	mov    %rsp,%rbp
  8018c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cd:	00 
  8018ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	be 00 00 00 00       	mov    $0x0,%esi
  8018e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8018ee:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	callq  *%rax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 20          	sub    $0x20,%rsp
  801904:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	48 98                	cltq   
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	b9 00 00 00 00       	mov    $0x0,%ecx
  801925:	48 89 c2             	mov    %rax,%rdx
  801928:	be 01 00 00 00       	mov    $0x1,%esi
  80192d:	bf 03 00 00 00       	mov    $0x3,%edi
  801932:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801939:	00 00 00 
  80193c:	ff d0                	callq  *%rax
}
  80193e:	c9                   	leaveq 
  80193f:	c3                   	retq   

0000000000801940 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801940:	55                   	push   %rbp
  801941:	48 89 e5             	mov    %rsp,%rbp
  801944:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801948:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194f:	00 
  801950:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801956:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801961:	ba 00 00 00 00       	mov    $0x0,%edx
  801966:	be 00 00 00 00       	mov    $0x0,%esi
  80196b:	bf 02 00 00 00       	mov    $0x2,%edi
  801970:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801977:	00 00 00 
  80197a:	ff d0                	callq  *%rax
}
  80197c:	c9                   	leaveq 
  80197d:	c3                   	retq   

000000000080197e <sys_yield>:

void
sys_yield(void)
{
  80197e:	55                   	push   %rbp
  80197f:	48 89 e5             	mov    %rsp,%rbp
  801982:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801986:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198d:	00 
  80198e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801994:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	be 00 00 00 00       	mov    $0x0,%esi
  8019a9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019ae:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 20          	sub    $0x20,%rsp
  8019c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d1:	48 63 c8             	movslq %eax,%rcx
  8019d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019db:	48 98                	cltq   
  8019dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e4:	00 
  8019e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019eb:	49 89 c8             	mov    %rcx,%r8
  8019ee:	48 89 d1             	mov    %rdx,%rcx
  8019f1:	48 89 c2             	mov    %rax,%rdx
  8019f4:	be 01 00 00 00       	mov    $0x1,%esi
  8019f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8019fe:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
}
  801a0a:	c9                   	leaveq 
  801a0b:	c3                   	retq   

0000000000801a0c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a0c:	55                   	push   %rbp
  801a0d:	48 89 e5             	mov    %rsp,%rbp
  801a10:	48 83 ec 30          	sub    $0x30,%rsp
  801a14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a1e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a22:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a26:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a29:	48 63 c8             	movslq %eax,%rcx
  801a2c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a33:	48 63 f0             	movslq %eax,%rsi
  801a36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3d:	48 98                	cltq   
  801a3f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a43:	49 89 f9             	mov    %rdi,%r9
  801a46:	49 89 f0             	mov    %rsi,%r8
  801a49:	48 89 d1             	mov    %rdx,%rcx
  801a4c:	48 89 c2             	mov    %rax,%rdx
  801a4f:	be 01 00 00 00       	mov    $0x1,%esi
  801a54:	bf 05 00 00 00       	mov    $0x5,%edi
  801a59:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801a60:	00 00 00 
  801a63:	ff d0                	callq  *%rax
}
  801a65:	c9                   	leaveq 
  801a66:	c3                   	retq   

0000000000801a67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a67:	55                   	push   %rbp
  801a68:	48 89 e5             	mov    %rsp,%rbp
  801a6b:	48 83 ec 20          	sub    $0x20,%rsp
  801a6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7d:	48 98                	cltq   
  801a7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a86:	00 
  801a87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a93:	48 89 d1             	mov    %rdx,%rcx
  801a96:	48 89 c2             	mov    %rax,%rdx
  801a99:	be 01 00 00 00       	mov    $0x1,%esi
  801a9e:	bf 06 00 00 00       	mov    $0x6,%edi
  801aa3:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801aaa:	00 00 00 
  801aad:	ff d0                	callq  *%rax
}
  801aaf:	c9                   	leaveq 
  801ab0:	c3                   	retq   

0000000000801ab1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	48 83 ec 20          	sub    $0x20,%rsp
  801ab9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801abf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac2:	48 63 d0             	movslq %eax,%rdx
  801ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac8:	48 98                	cltq   
  801aca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad1:	00 
  801ad2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ade:	48 89 d1             	mov    %rdx,%rcx
  801ae1:	48 89 c2             	mov    %rax,%rdx
  801ae4:	be 01 00 00 00       	mov    $0x1,%esi
  801ae9:	bf 08 00 00 00       	mov    $0x8,%edi
  801aee:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
  801b00:	48 83 ec 20          	sub    $0x20,%rsp
  801b04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b12:	48 98                	cltq   
  801b14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1b:	00 
  801b1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b28:	48 89 d1             	mov    %rdx,%rcx
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	be 01 00 00 00       	mov    $0x1,%esi
  801b33:	bf 09 00 00 00       	mov    $0x9,%edi
  801b38:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 20          	sub    $0x20,%rsp
  801b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5c:	48 98                	cltq   
  801b5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b65:	00 
  801b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b72:	48 89 d1             	mov    %rdx,%rcx
  801b75:	48 89 c2             	mov    %rax,%rdx
  801b78:	be 01 00 00 00       	mov    $0x1,%esi
  801b7d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b82:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 30          	sub    $0x30,%rsp
  801b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ba3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ba6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba9:	48 63 f0             	movslq %eax,%rsi
  801bac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb3:	48 98                	cltq   
  801bb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc0:	00 
  801bc1:	49 89 f1             	mov    %rsi,%r9
  801bc4:	49 89 c8             	mov    %rcx,%r8
  801bc7:	48 89 d1             	mov    %rdx,%rcx
  801bca:	48 89 c2             	mov    %rax,%rdx
  801bcd:	be 00 00 00 00       	mov    $0x0,%esi
  801bd2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bd7:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 20          	sub    $0x20,%rsp
  801bed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfc:	00 
  801bfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0e:	48 89 c2             	mov    %rax,%rdx
  801c11:	be 01 00 00 00       	mov    $0x1,%esi
  801c16:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c1b:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
}
  801c27:	c9                   	leaveq 
  801c28:	c3                   	retq   

0000000000801c29 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c29:	55                   	push   %rbp
  801c2a:	48 89 e5             	mov    %rsp,%rbp
  801c2d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c38:	00 
  801c39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4f:	be 00 00 00 00       	mov    $0x0,%esi
  801c54:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c59:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
}
  801c65:	c9                   	leaveq 
  801c66:	c3                   	retq   

0000000000801c67 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c67:	55                   	push   %rbp
  801c68:	48 89 e5             	mov    %rsp,%rbp
  801c6b:	48 83 ec 30          	sub    $0x30,%rsp
  801c6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c76:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c79:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c7d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c84:	48 63 c8             	movslq %eax,%rcx
  801c87:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8e:	48 63 f0             	movslq %eax,%rsi
  801c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	48 98                	cltq   
  801c9a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c9e:	49 89 f9             	mov    %rdi,%r9
  801ca1:	49 89 f0             	mov    %rsi,%r8
  801ca4:	48 89 d1             	mov    %rdx,%rcx
  801ca7:	48 89 c2             	mov    %rax,%rdx
  801caa:	be 00 00 00 00       	mov    $0x0,%esi
  801caf:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cb4:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801cc0:	c9                   	leaveq 
  801cc1:	c3                   	retq   

0000000000801cc2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801cc2:	55                   	push   %rbp
  801cc3:	48 89 e5             	mov    %rsp,%rbp
  801cc6:	48 83 ec 20          	sub    $0x20,%rsp
  801cca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce1:	00 
  801ce2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cee:	48 89 d1             	mov    %rdx,%rcx
  801cf1:	48 89 c2             	mov    %rax,%rdx
  801cf4:	be 00 00 00 00       	mov    $0x0,%esi
  801cf9:	bf 10 00 00 00       	mov    $0x10,%edi
  801cfe:	48 b8 d8 17 80 00 00 	movabs $0x8017d8,%rax
  801d05:	00 00 00 
  801d08:	ff d0                	callq  *%rax
}
  801d0a:	c9                   	leaveq 
  801d0b:	c3                   	retq   

0000000000801d0c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d0c:	55                   	push   %rbp
  801d0d:	48 89 e5             	mov    %rsp,%rbp
  801d10:	48 83 ec 08          	sub    $0x8,%rsp
  801d14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d1c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d23:	ff ff ff 
  801d26:	48 01 d0             	add    %rdx,%rax
  801d29:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	48 83 ec 08          	sub    $0x8,%rsp
  801d37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	48 89 c7             	mov    %rax,%rdi
  801d42:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
  801d4e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d54:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d58:	c9                   	leaveq 
  801d59:	c3                   	retq   

0000000000801d5a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
  801d5e:	48 83 ec 18          	sub    $0x18,%rsp
  801d62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d6d:	eb 6b                	jmp    801dda <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d72:	48 98                	cltq   
  801d74:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d7a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d86:	48 89 c2             	mov    %rax,%rdx
  801d89:	48 c1 ea 15          	shr    $0x15,%rdx
  801d8d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d94:	01 00 00 
  801d97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9b:	83 e0 01             	and    $0x1,%eax
  801d9e:	48 85 c0             	test   %rax,%rax
  801da1:	74 21                	je     801dc4 <fd_alloc+0x6a>
  801da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da7:	48 89 c2             	mov    %rax,%rdx
  801daa:	48 c1 ea 0c          	shr    $0xc,%rdx
  801dae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db5:	01 00 00 
  801db8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dbc:	83 e0 01             	and    $0x1,%eax
  801dbf:	48 85 c0             	test   %rax,%rax
  801dc2:	75 12                	jne    801dd6 <fd_alloc+0x7c>
			*fd_store = fd;
  801dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	eb 1a                	jmp    801df0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dd6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dda:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dde:	7e 8f                	jle    801d6f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801deb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801df0:	c9                   	leaveq 
  801df1:	c3                   	retq   

0000000000801df2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801df2:	55                   	push   %rbp
  801df3:	48 89 e5             	mov    %rsp,%rbp
  801df6:	48 83 ec 20          	sub    $0x20,%rsp
  801dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e05:	78 06                	js     801e0d <fd_lookup+0x1b>
  801e07:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e0b:	7e 07                	jle    801e14 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e12:	eb 6c                	jmp    801e80 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e17:	48 98                	cltq   
  801e19:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e1f:	48 c1 e0 0c          	shl    $0xc,%rax
  801e23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2b:	48 89 c2             	mov    %rax,%rdx
  801e2e:	48 c1 ea 15          	shr    $0x15,%rdx
  801e32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e39:	01 00 00 
  801e3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e40:	83 e0 01             	and    $0x1,%eax
  801e43:	48 85 c0             	test   %rax,%rax
  801e46:	74 21                	je     801e69 <fd_lookup+0x77>
  801e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4c:	48 89 c2             	mov    %rax,%rdx
  801e4f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5a:	01 00 00 
  801e5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e61:	83 e0 01             	and    $0x1,%eax
  801e64:	48 85 c0             	test   %rax,%rax
  801e67:	75 07                	jne    801e70 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6e:	eb 10                	jmp    801e80 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e78:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e80:	c9                   	leaveq 
  801e81:	c3                   	retq   

0000000000801e82 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e82:	55                   	push   %rbp
  801e83:	48 89 e5             	mov    %rsp,%rbp
  801e86:	48 83 ec 30          	sub    $0x30,%rsp
  801e8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e8e:	89 f0                	mov    %esi,%eax
  801e90:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e97:	48 89 c7             	mov    %rax,%rdi
  801e9a:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  801ea1:	00 00 00 
  801ea4:	ff d0                	callq  *%rax
  801ea6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eaa:	48 89 d6             	mov    %rdx,%rsi
  801ead:	89 c7                	mov    %eax,%edi
  801eaf:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
  801ebb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec2:	78 0a                	js     801ece <fd_close+0x4c>
	    || fd != fd2)
  801ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ecc:	74 12                	je     801ee0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ece:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ed2:	74 05                	je     801ed9 <fd_close+0x57>
  801ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed7:	eb 05                	jmp    801ede <fd_close+0x5c>
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	eb 69                	jmp    801f49 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee4:	8b 00                	mov    (%rax),%eax
  801ee6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801eea:	48 89 d6             	mov    %rdx,%rsi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 4b 1f 80 00 00 	movabs $0x801f4b,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	callq  *%rax
  801efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f02:	78 2a                	js     801f2e <fd_close+0xac>
		if (dev->dev_close)
  801f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f08:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f0c:	48 85 c0             	test   %rax,%rax
  801f0f:	74 16                	je     801f27 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f15:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1d:	48 89 c7             	mov    %rax,%rdi
  801f20:	ff d2                	callq  *%rdx
  801f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f25:	eb 07                	jmp    801f2e <fd_close+0xac>
		else
			r = 0;
  801f27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f32:	48 89 c6             	mov    %rax,%rsi
  801f35:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3a:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
	return r;
  801f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f49:	c9                   	leaveq 
  801f4a:	c3                   	retq   

0000000000801f4b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f4b:	55                   	push   %rbp
  801f4c:	48 89 e5             	mov    %rsp,%rbp
  801f4f:	48 83 ec 20          	sub    $0x20,%rsp
  801f53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f61:	eb 41                	jmp    801fa4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f63:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f6a:	00 00 00 
  801f6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f70:	48 63 d2             	movslq %edx,%rdx
  801f73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f77:	8b 00                	mov    (%rax),%eax
  801f79:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f7c:	75 22                	jne    801fa0 <dev_lookup+0x55>
			*dev = devtab[i];
  801f7e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f85:	00 00 00 
  801f88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f8b:	48 63 d2             	movslq %edx,%rdx
  801f8e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f96:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	eb 60                	jmp    802000 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fa0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fa4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fab:	00 00 00 
  801fae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb1:	48 63 d2             	movslq %edx,%rdx
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	48 85 c0             	test   %rax,%rax
  801fbb:	75 a6                	jne    801f63 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fbd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fc4:	00 00 00 
  801fc7:	48 8b 00             	mov    (%rax),%rax
  801fca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fd0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fd3:	89 c6                	mov    %eax,%esi
  801fd5:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  801fdc:	00 00 00 
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  801feb:	00 00 00 
  801fee:	ff d1                	callq  *%rcx
	*dev = 0;
  801ff0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ffb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <close>:

int
close(int fdnum)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 20          	sub    $0x20,%rsp
  80200a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80200d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802011:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802014:	48 89 d6             	mov    %rdx,%rsi
  802017:	89 c7                	mov    %eax,%edi
  802019:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
  802025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202c:	79 05                	jns    802033 <close+0x31>
		return r;
  80202e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802031:	eb 18                	jmp    80204b <close+0x49>
	else
		return fd_close(fd, 1);
  802033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802037:	be 01 00 00 00       	mov    $0x1,%esi
  80203c:	48 89 c7             	mov    %rax,%rdi
  80203f:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  802046:	00 00 00 
  802049:	ff d0                	callq  *%rax
}
  80204b:	c9                   	leaveq 
  80204c:	c3                   	retq   

000000000080204d <close_all>:

void
close_all(void)
{
  80204d:	55                   	push   %rbp
  80204e:	48 89 e5             	mov    %rsp,%rbp
  802051:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80205c:	eb 15                	jmp    802073 <close_all+0x26>
		close(i);
  80205e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802061:	89 c7                	mov    %eax,%edi
  802063:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80206f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802073:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802077:	7e e5                	jle    80205e <close_all+0x11>
		close(i);
}
  802079:	c9                   	leaveq 
  80207a:	c3                   	retq   

000000000080207b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80207b:	55                   	push   %rbp
  80207c:	48 89 e5             	mov    %rsp,%rbp
  80207f:	48 83 ec 40          	sub    $0x40,%rsp
  802083:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802086:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802089:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80208d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802090:	48 89 d6             	mov    %rdx,%rsi
  802093:	89 c7                	mov    %eax,%edi
  802095:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80209c:	00 00 00 
  80209f:	ff d0                	callq  *%rax
  8020a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a8:	79 08                	jns    8020b2 <dup+0x37>
		return r;
  8020aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ad:	e9 70 01 00 00       	jmpq   802222 <dup+0x1a7>
	close(newfdnum);
  8020b2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b5:	89 c7                	mov    %eax,%edi
  8020b7:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020c3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c6:	48 98                	cltq   
  8020c8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ce:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020da:	48 89 c7             	mov    %rax,%rdi
  8020dd:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	callq  *%rax
  8020e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f1:	48 89 c7             	mov    %rax,%rdi
  8020f4:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8020fb:	00 00 00 
  8020fe:	ff d0                	callq  *%rax
  802100:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802104:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802108:	48 89 c2             	mov    %rax,%rdx
  80210b:	48 c1 ea 15          	shr    $0x15,%rdx
  80210f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802116:	01 00 00 
  802119:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211d:	83 e0 01             	and    $0x1,%eax
  802120:	84 c0                	test   %al,%al
  802122:	74 71                	je     802195 <dup+0x11a>
  802124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802128:	48 89 c2             	mov    %rax,%rdx
  80212b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80212f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802136:	01 00 00 
  802139:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213d:	83 e0 01             	and    $0x1,%eax
  802140:	84 c0                	test   %al,%al
  802142:	74 51                	je     802195 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802148:	48 89 c2             	mov    %rax,%rdx
  80214b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80214f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802156:	01 00 00 
  802159:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215d:	89 c1                	mov    %eax,%ecx
  80215f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802165:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216d:	41 89 c8             	mov    %ecx,%r8d
  802170:	48 89 d1             	mov    %rdx,%rcx
  802173:	ba 00 00 00 00       	mov    $0x0,%edx
  802178:	48 89 c6             	mov    %rax,%rsi
  80217b:	bf 00 00 00 00       	mov    $0x0,%edi
  802180:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  802187:	00 00 00 
  80218a:	ff d0                	callq  *%rax
  80218c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802193:	78 56                	js     8021eb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802195:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802199:	48 89 c2             	mov    %rax,%rdx
  80219c:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a7:	01 00 00 
  8021aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ae:	89 c1                	mov    %eax,%ecx
  8021b0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021be:	41 89 c8             	mov    %ecx,%r8d
  8021c1:	48 89 d1             	mov    %rdx,%rcx
  8021c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c9:	48 89 c6             	mov    %rax,%rsi
  8021cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d1:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e4:	78 08                	js     8021ee <dup+0x173>
		goto err;

	return newfdnum;
  8021e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021e9:	eb 37                	jmp    802222 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8021eb:	90                   	nop
  8021ec:	eb 01                	jmp    8021ef <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8021ee:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8021ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f3:	48 89 c6             	mov    %rax,%rsi
  8021f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fb:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  802202:	00 00 00 
  802205:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220b:	48 89 c6             	mov    %rax,%rsi
  80220e:	bf 00 00 00 00       	mov    $0x0,%edi
  802213:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  80221a:	00 00 00 
  80221d:	ff d0                	callq  *%rax
	return r;
  80221f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802222:	c9                   	leaveq 
  802223:	c3                   	retq   

0000000000802224 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802224:	55                   	push   %rbp
  802225:	48 89 e5             	mov    %rsp,%rbp
  802228:	48 83 ec 40          	sub    $0x40,%rsp
  80222c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80222f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802233:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802237:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80223b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80223e:	48 89 d6             	mov    %rdx,%rsi
  802241:	89 c7                	mov    %eax,%edi
  802243:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
  80224f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802256:	78 24                	js     80227c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225c:	8b 00                	mov    (%rax),%eax
  80225e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802262:	48 89 d6             	mov    %rdx,%rsi
  802265:	89 c7                	mov    %eax,%edi
  802267:	48 b8 4b 1f 80 00 00 	movabs $0x801f4b,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
  802273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227a:	79 05                	jns    802281 <read+0x5d>
		return r;
  80227c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227f:	eb 7a                	jmp    8022fb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802285:	8b 40 08             	mov    0x8(%rax),%eax
  802288:	83 e0 03             	and    $0x3,%eax
  80228b:	83 f8 01             	cmp    $0x1,%eax
  80228e:	75 3a                	jne    8022ca <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802290:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802297:	00 00 00 
  80229a:	48 8b 00             	mov    (%rax),%rax
  80229d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a6:	89 c6                	mov    %eax,%esi
  8022a8:	48 bf 17 42 80 00 00 	movabs $0x804217,%rdi
  8022af:	00 00 00 
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  8022be:	00 00 00 
  8022c1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c8:	eb 31                	jmp    8022fb <read+0xd7>
	}
	if (!dev->dev_read)
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d2:	48 85 c0             	test   %rax,%rax
  8022d5:	75 07                	jne    8022de <read+0xba>
		return -E_NOT_SUPP;
  8022d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022dc:	eb 1d                	jmp    8022fb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8022de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8022e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022ee:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022f2:	48 89 ce             	mov    %rcx,%rsi
  8022f5:	48 89 c7             	mov    %rax,%rdi
  8022f8:	41 ff d0             	callq  *%r8
}
  8022fb:	c9                   	leaveq 
  8022fc:	c3                   	retq   

00000000008022fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022fd:	55                   	push   %rbp
  8022fe:	48 89 e5             	mov    %rsp,%rbp
  802301:	48 83 ec 30          	sub    $0x30,%rsp
  802305:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802308:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80230c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802317:	eb 46                	jmp    80235f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	48 98                	cltq   
  80231e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802322:	48 29 c2             	sub    %rax,%rdx
  802325:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802328:	48 98                	cltq   
  80232a:	48 89 c1             	mov    %rax,%rcx
  80232d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802334:	48 89 ce             	mov    %rcx,%rsi
  802337:	89 c7                	mov    %eax,%edi
  802339:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
  802345:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802348:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80234c:	79 05                	jns    802353 <readn+0x56>
			return m;
  80234e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802351:	eb 1d                	jmp    802370 <readn+0x73>
		if (m == 0)
  802353:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802357:	74 13                	je     80236c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802359:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80235f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802362:	48 98                	cltq   
  802364:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802368:	72 af                	jb     802319 <readn+0x1c>
  80236a:	eb 01                	jmp    80236d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80236c:	90                   	nop
	}
	return tot;
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802370:	c9                   	leaveq 
  802371:	c3                   	retq   

0000000000802372 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802372:	55                   	push   %rbp
  802373:	48 89 e5             	mov    %rsp,%rbp
  802376:	48 83 ec 40          	sub    $0x40,%rsp
  80237a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80237d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802381:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802385:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802389:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80238c:	48 89 d6             	mov    %rdx,%rsi
  80238f:	89 c7                	mov    %eax,%edi
  802391:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a4:	78 24                	js     8023ca <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	8b 00                	mov    (%rax),%eax
  8023ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b0:	48 89 d6             	mov    %rdx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 4b 1f 80 00 00 	movabs $0x801f4b,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c8:	79 05                	jns    8023cf <write+0x5d>
		return r;
  8023ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cd:	eb 79                	jmp    802448 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d3:	8b 40 08             	mov    0x8(%rax),%eax
  8023d6:	83 e0 03             	and    $0x3,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 3a                	jne    802417 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023e4:	00 00 00 
  8023e7:	48 8b 00             	mov    (%rax),%rax
  8023ea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f3:	89 c6                	mov    %eax,%esi
  8023f5:	48 bf 33 42 80 00 00 	movabs $0x804233,%rdi
  8023fc:	00 00 00 
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802404:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  80240b:	00 00 00 
  80240e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802410:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802415:	eb 31                	jmp    802448 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241f:	48 85 c0             	test   %rax,%rax
  802422:	75 07                	jne    80242b <write+0xb9>
		return -E_NOT_SUPP;
  802424:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802429:	eb 1d                	jmp    802448 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80242b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802437:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80243b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80243f:	48 89 ce             	mov    %rcx,%rsi
  802442:	48 89 c7             	mov    %rax,%rdi
  802445:	41 ff d0             	callq  *%r8
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <seek>:

int
seek(int fdnum, off_t offset)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 18          	sub    $0x18,%rsp
  802452:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802455:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802458:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80245f:	48 89 d6             	mov    %rdx,%rsi
  802462:	89 c7                	mov    %eax,%edi
  802464:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80246b:	00 00 00 
  80246e:	ff d0                	callq  *%rax
  802470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802477:	79 05                	jns    80247e <seek+0x34>
		return r;
  802479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247c:	eb 0f                	jmp    80248d <seek+0x43>
	fd->fd_offset = offset;
  80247e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802482:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802485:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248d:	c9                   	leaveq 
  80248e:	c3                   	retq   

000000000080248f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	48 83 ec 30          	sub    $0x30,%rsp
  802497:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80249a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80249d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a4:	48 89 d6             	mov    %rdx,%rsi
  8024a7:	89 c7                	mov    %eax,%edi
  8024a9:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	callq  *%rax
  8024b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bc:	78 24                	js     8024e2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c2:	8b 00                	mov    (%rax),%eax
  8024c4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c8:	48 89 d6             	mov    %rdx,%rsi
  8024cb:	89 c7                	mov    %eax,%edi
  8024cd:	48 b8 4b 1f 80 00 00 	movabs $0x801f4b,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	callq  *%rax
  8024d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e0:	79 05                	jns    8024e7 <ftruncate+0x58>
		return r;
  8024e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e5:	eb 72                	jmp    802559 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024eb:	8b 40 08             	mov    0x8(%rax),%eax
  8024ee:	83 e0 03             	and    $0x3,%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	75 3a                	jne    80252f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024f5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024fc:	00 00 00 
  8024ff:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802502:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802508:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80250b:	89 c6                	mov    %eax,%esi
  80250d:	48 bf 50 42 80 00 00 	movabs $0x804250,%rdi
  802514:	00 00 00 
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  802523:	00 00 00 
  802526:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802528:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80252d:	eb 2a                	jmp    802559 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80252f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802533:	48 8b 40 30          	mov    0x30(%rax),%rax
  802537:	48 85 c0             	test   %rax,%rax
  80253a:	75 07                	jne    802543 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80253c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802541:	eb 16                	jmp    802559 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802547:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80254b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802552:	89 d6                	mov    %edx,%esi
  802554:	48 89 c7             	mov    %rax,%rdi
  802557:	ff d1                	callq  *%rcx
}
  802559:	c9                   	leaveq 
  80255a:	c3                   	retq   

000000000080255b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80255b:	55                   	push   %rbp
  80255c:	48 89 e5             	mov    %rsp,%rbp
  80255f:	48 83 ec 30          	sub    $0x30,%rsp
  802563:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802566:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80256a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80256e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802571:	48 89 d6             	mov    %rdx,%rsi
  802574:	89 c7                	mov    %eax,%edi
  802576:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802589:	78 24                	js     8025af <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	8b 00                	mov    (%rax),%eax
  802591:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802595:	48 89 d6             	mov    %rdx,%rsi
  802598:	89 c7                	mov    %eax,%edi
  80259a:	48 b8 4b 1f 80 00 00 	movabs $0x801f4b,%rax
  8025a1:	00 00 00 
  8025a4:	ff d0                	callq  *%rax
  8025a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ad:	79 05                	jns    8025b4 <fstat+0x59>
		return r;
  8025af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b2:	eb 5e                	jmp    802612 <fstat+0xb7>
	if (!dev->dev_stat)
  8025b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025bc:	48 85 c0             	test   %rax,%rax
  8025bf:	75 07                	jne    8025c8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c6:	eb 4a                	jmp    802612 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025da:	00 00 00 
	stat->st_isdir = 0;
  8025dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025e8:	00 00 00 
	stat->st_dev = dev;
  8025eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fe:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802606:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80260a:	48 89 d6             	mov    %rdx,%rsi
  80260d:	48 89 c7             	mov    %rax,%rdi
  802610:	ff d1                	callq  *%rcx
}
  802612:	c9                   	leaveq 
  802613:	c3                   	retq   

0000000000802614 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802614:	55                   	push   %rbp
  802615:	48 89 e5             	mov    %rsp,%rbp
  802618:	48 83 ec 20          	sub    $0x20,%rsp
  80261c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802628:	be 00 00 00 00       	mov    $0x0,%esi
  80262d:	48 89 c7             	mov    %rax,%rdi
  802630:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802643:	79 05                	jns    80264a <stat+0x36>
		return fd;
  802645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802648:	eb 2f                	jmp    802679 <stat+0x65>
	r = fstat(fd, stat);
  80264a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80264e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802651:	48 89 d6             	mov    %rdx,%rsi
  802654:	89 c7                	mov    %eax,%edi
  802656:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802668:	89 c7                	mov    %eax,%edi
  80266a:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
	return r;
  802676:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802679:	c9                   	leaveq 
  80267a:	c3                   	retq   
	...

000000000080267c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 10          	sub    $0x10,%rsp
  802684:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802687:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80268b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802692:	00 00 00 
  802695:	8b 00                	mov    (%rax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	75 1d                	jne    8026b8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80269b:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a0:	48 b8 52 3b 80 00 00 	movabs $0x803b52,%rax
  8026a7:	00 00 00 
  8026aa:	ff d0                	callq  *%rax
  8026ac:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026b3:	00 00 00 
  8026b6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026bf:	00 00 00 
  8026c2:	8b 00                	mov    (%rax),%eax
  8026c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026c7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026cc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026d3:	00 00 00 
  8026d6:	89 c7                	mov    %eax,%edi
  8026d8:	48 b8 a3 3a 80 00 00 	movabs $0x803aa3,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ed:	48 89 c6             	mov    %rax,%rsi
  8026f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f5:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
}
  802701:	c9                   	leaveq 
  802702:	c3                   	retq   

0000000000802703 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802703:	55                   	push   %rbp
  802704:	48 89 e5             	mov    %rsp,%rbp
  802707:	48 83 ec 20          	sub    $0x20,%rsp
  80270b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80272a:	7e 0a                	jle    802736 <open+0x33>
		return -E_BAD_PATH;
  80272c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802731:	e9 a5 00 00 00       	jmpq   8027db <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802736:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80273a:	48 89 c7             	mov    %rax,%rdi
  80273d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80274c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802750:	79 08                	jns    80275a <open+0x57>
		return r;
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	e9 81 00 00 00       	jmpq   8027db <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80275a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802761:	00 00 00 
  802764:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802767:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80276d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80277b:	00 00 00 
  80277e:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80278a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278e:	48 89 c6             	mov    %rax,%rsi
  802791:	bf 01 00 00 00       	mov    $0x1,%edi
  802796:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a9:	79 1d                	jns    8027c8 <open+0xc5>
		fd_close(new_fd, 0);
  8027ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027af:	be 00 00 00 00       	mov    $0x0,%esi
  8027b4:	48 89 c7             	mov    %rax,%rdi
  8027b7:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax
		return r;	
  8027c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c6:	eb 13                	jmp    8027db <open+0xd8>
	}
	return fd2num(new_fd);
  8027c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cc:	48 89 c7             	mov    %rax,%rdi
  8027cf:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
}
  8027db:	c9                   	leaveq 
  8027dc:	c3                   	retq   

00000000008027dd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027dd:	55                   	push   %rbp
  8027de:	48 89 e5             	mov    %rsp,%rbp
  8027e1:	48 83 ec 10          	sub    $0x10,%rsp
  8027e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f7:	00 00 00 
  8027fa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027fc:	be 00 00 00 00       	mov    $0x0,%esi
  802801:	bf 06 00 00 00       	mov    $0x6,%edi
  802806:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
}
  802812:	c9                   	leaveq 
  802813:	c3                   	retq   

0000000000802814 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802814:	55                   	push   %rbp
  802815:	48 89 e5             	mov    %rsp,%rbp
  802818:	48 83 ec 30          	sub    $0x30,%rsp
  80281c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802820:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802824:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282c:	8b 50 0c             	mov    0xc(%rax),%edx
  80282f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802836:	00 00 00 
  802839:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80283b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802842:	00 00 00 
  802845:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802849:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  80284d:	be 00 00 00 00       	mov    $0x0,%esi
  802852:	bf 03 00 00 00       	mov    $0x3,%edi
  802857:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802866:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286a:	7e 23                	jle    80288f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80286c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286f:	48 63 d0             	movslq %eax,%rdx
  802872:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802876:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80287d:	00 00 00 
  802880:	48 89 c7             	mov    %rax,%rdi
  802883:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80288f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802892:	c9                   	leaveq 
  802893:	c3                   	retq   

0000000000802894 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802894:	55                   	push   %rbp
  802895:	48 89 e5             	mov    %rsp,%rbp
  802898:	48 83 ec 20          	sub    $0x20,%rsp
  80289c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b2:	00 00 00 
  8028b5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028b7:	be 00 00 00 00       	mov    $0x0,%esi
  8028bc:	bf 05 00 00 00       	mov    $0x5,%edi
  8028c1:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	callq  *%rax
  8028cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d4:	79 05                	jns    8028db <devfile_stat+0x47>
		return r;
  8028d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d9:	eb 56                	jmp    802931 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028df:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028e6:	00 00 00 
  8028e9:	48 89 c7             	mov    %rax,%rdi
  8028ec:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028ff:	00 00 00 
  802902:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802908:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802912:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802919:	00 00 00 
  80291c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802922:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802926:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802931:	c9                   	leaveq 
  802932:	c3                   	retq   
	...

0000000000802934 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802934:	55                   	push   %rbp
  802935:	48 89 e5             	mov    %rsp,%rbp
  802938:	48 83 ec 20          	sub    $0x20,%rsp
  80293c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80293f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802943:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802946:	48 89 d6             	mov    %rdx,%rsi
  802949:	89 c7                	mov    %eax,%edi
  80294b:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  802952:	00 00 00 
  802955:	ff d0                	callq  *%rax
  802957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295e:	79 05                	jns    802965 <fd2sockid+0x31>
		return r;
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802963:	eb 24                	jmp    802989 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802969:	8b 10                	mov    (%rax),%edx
  80296b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802972:	00 00 00 
  802975:	8b 00                	mov    (%rax),%eax
  802977:	39 c2                	cmp    %eax,%edx
  802979:	74 07                	je     802982 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80297b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802980:	eb 07                	jmp    802989 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802986:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802989:	c9                   	leaveq 
  80298a:	c3                   	retq   

000000000080298b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80298b:	55                   	push   %rbp
  80298c:	48 89 e5             	mov    %rsp,%rbp
  80298f:	48 83 ec 20          	sub    $0x20,%rsp
  802993:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802996:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80299a:	48 89 c7             	mov    %rax,%rdi
  80299d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	callq  *%rax
  8029a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b0:	78 26                	js     8029d8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8029bb:	48 89 c6             	mov    %rax,%rsi
  8029be:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c3:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
  8029cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d6:	79 16                	jns    8029ee <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8029d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029db:	89 c7                	mov    %eax,%edi
  8029dd:	48 b8 98 2e 80 00 00 	movabs $0x802e98,%rax
  8029e4:	00 00 00 
  8029e7:	ff d0                	callq  *%rax
		return r;
  8029e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ec:	eb 3a                	jmp    802a28 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8029f9:	00 00 00 
  8029fc:	8b 12                	mov    (%rdx),%edx
  8029fe:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a04:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a12:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a19:	48 89 c7             	mov    %rax,%rdi
  802a1c:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
}
  802a28:	c9                   	leaveq 
  802a29:	c3                   	retq   

0000000000802a2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a2a:	55                   	push   %rbp
  802a2b:	48 89 e5             	mov    %rsp,%rbp
  802a2e:	48 83 ec 30          	sub    $0x30,%rsp
  802a32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a40:	89 c7                	mov    %eax,%edi
  802a42:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802a49:	00 00 00 
  802a4c:	ff d0                	callq  *%rax
  802a4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a55:	79 05                	jns    802a5c <accept+0x32>
		return r;
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5a:	eb 3b                	jmp    802a97 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	48 89 ce             	mov    %rcx,%rsi
  802a6a:	89 c7                	mov    %eax,%edi
  802a6c:	48 b8 75 2d 80 00 00 	movabs $0x802d75,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
  802a78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7f:	79 05                	jns    802a86 <accept+0x5c>
		return r;
  802a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a84:	eb 11                	jmp    802a97 <accept+0x6d>
	return alloc_sockfd(r);
  802a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a89:	89 c7                	mov    %eax,%edi
  802a8b:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	48 83 ec 20          	sub    $0x20,%rsp
  802aa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802aa8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802aab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aae:	89 c7                	mov    %eax,%edi
  802ab0:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
  802abc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac3:	79 05                	jns    802aca <bind+0x31>
		return r;
  802ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac8:	eb 1b                	jmp    802ae5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802aca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802acd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	48 89 ce             	mov    %rcx,%rsi
  802ad7:	89 c7                	mov    %eax,%edi
  802ad9:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  802ae0:	00 00 00 
  802ae3:	ff d0                	callq  *%rax
}
  802ae5:	c9                   	leaveq 
  802ae6:	c3                   	retq   

0000000000802ae7 <shutdown>:

int
shutdown(int s, int how)
{
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 83 ec 20          	sub    $0x20,%rsp
  802aef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802af2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802af5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802af8:	89 c7                	mov    %eax,%edi
  802afa:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0d:	79 05                	jns    802b14 <shutdown+0x2d>
		return r;
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b12:	eb 16                	jmp    802b2a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802b14:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	89 d6                	mov    %edx,%esi
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	48 b8 58 2e 80 00 00 	movabs $0x802e58,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
}
  802b2a:	c9                   	leaveq 
  802b2b:	c3                   	retq   

0000000000802b2c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802b2c:	55                   	push   %rbp
  802b2d:	48 89 e5             	mov    %rsp,%rbp
  802b30:	48 83 ec 10          	sub    $0x10,%rsp
  802b34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3c:	48 89 c7             	mov    %rax,%rdi
  802b3f:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
  802b4b:	83 f8 01             	cmp    $0x1,%eax
  802b4e:	75 17                	jne    802b67 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b54:	8b 40 0c             	mov    0xc(%rax),%eax
  802b57:	89 c7                	mov    %eax,%edi
  802b59:	48 b8 98 2e 80 00 00 	movabs $0x802e98,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	eb 05                	jmp    802b6c <devsock_close+0x40>
	else
		return 0;
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6c:	c9                   	leaveq 
  802b6d:	c3                   	retq   

0000000000802b6e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b6e:	55                   	push   %rbp
  802b6f:	48 89 e5             	mov    %rsp,%rbp
  802b72:	48 83 ec 20          	sub    $0x20,%rsp
  802b76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b7d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b83:	89 c7                	mov    %eax,%edi
  802b85:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	79 05                	jns    802b9f <connect+0x31>
		return r;
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	eb 1b                	jmp    802bba <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802b9f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ba2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	48 89 ce             	mov    %rcx,%rsi
  802bac:	89 c7                	mov    %eax,%edi
  802bae:	48 b8 c5 2e 80 00 00 	movabs $0x802ec5,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
}
  802bba:	c9                   	leaveq 
  802bbb:	c3                   	retq   

0000000000802bbc <listen>:

int
listen(int s, int backlog)
{
  802bbc:	55                   	push   %rbp
  802bbd:	48 89 e5             	mov    %rsp,%rbp
  802bc0:	48 83 ec 20          	sub    $0x20,%rsp
  802bc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bc7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bcd:	89 c7                	mov    %eax,%edi
  802bcf:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
  802bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be2:	79 05                	jns    802be9 <listen+0x2d>
		return r;
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	eb 16                	jmp    802bff <listen+0x43>
	return nsipc_listen(r, backlog);
  802be9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bef:	89 d6                	mov    %edx,%esi
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 29 2f 80 00 00 	movabs $0x802f29,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
}
  802bff:	c9                   	leaveq 
  802c00:	c3                   	retq   

0000000000802c01 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802c01:	55                   	push   %rbp
  802c02:	48 89 e5             	mov    %rsp,%rbp
  802c05:	48 83 ec 20          	sub    $0x20,%rsp
  802c09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c11:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c19:	89 c2                	mov    %eax,%edx
  802c1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1f:	8b 40 0c             	mov    0xc(%rax),%eax
  802c22:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802c26:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c2b:	89 c7                	mov    %eax,%edi
  802c2d:	48 b8 69 2f 80 00 00 	movabs $0x802f69,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
}
  802c39:	c9                   	leaveq 
  802c3a:	c3                   	retq   

0000000000802c3b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802c3b:	55                   	push   %rbp
  802c3c:	48 89 e5             	mov    %rsp,%rbp
  802c3f:	48 83 ec 20          	sub    $0x20,%rsp
  802c43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c53:	89 c2                	mov    %eax,%edx
  802c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c59:	8b 40 0c             	mov    0xc(%rax),%eax
  802c5c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802c60:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c65:	89 c7                	mov    %eax,%edi
  802c67:	48 b8 35 30 80 00 00 	movabs $0x803035,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
}
  802c73:	c9                   	leaveq 
  802c74:	c3                   	retq   

0000000000802c75 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802c75:	55                   	push   %rbp
  802c76:	48 89 e5             	mov    %rsp,%rbp
  802c79:	48 83 ec 10          	sub    $0x10,%rsp
  802c7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	48 be 7b 42 80 00 00 	movabs $0x80427b,%rsi
  802c90:	00 00 00 
  802c93:	48 89 c7             	mov    %rax,%rdi
  802c96:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
	return 0;
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca7:	c9                   	leaveq 
  802ca8:	c3                   	retq   

0000000000802ca9 <socket>:

int
socket(int domain, int type, int protocol)
{
  802ca9:	55                   	push   %rbp
  802caa:	48 89 e5             	mov    %rsp,%rbp
  802cad:	48 83 ec 20          	sub    $0x20,%rsp
  802cb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cb4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802cb7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802cba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cbd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802cc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc3:	89 ce                	mov    %ecx,%esi
  802cc5:	89 c7                	mov    %eax,%edi
  802cc7:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cda:	79 05                	jns    802ce1 <socket+0x38>
		return r;
  802cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdf:	eb 11                	jmp    802cf2 <socket+0x49>
	return alloc_sockfd(r);
  802ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce4:	89 c7                	mov    %eax,%edi
  802ce6:	48 b8 8b 29 80 00 00 	movabs $0x80298b,%rax
  802ced:	00 00 00 
  802cf0:	ff d0                	callq  *%rax
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 10          	sub    $0x10,%rsp
  802cfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802cff:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d06:	00 00 00 
  802d09:	8b 00                	mov    (%rax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	75 1d                	jne    802d2c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802d0f:	bf 02 00 00 00       	mov    $0x2,%edi
  802d14:	48 b8 52 3b 80 00 00 	movabs $0x803b52,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
  802d20:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802d27:	00 00 00 
  802d2a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802d2c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d33:	00 00 00 
  802d36:	8b 00                	mov    (%rax),%eax
  802d38:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d3b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d40:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802d47:	00 00 00 
  802d4a:	89 c7                	mov    %eax,%edi
  802d4c:	48 b8 a3 3a 80 00 00 	movabs $0x803aa3,%rax
  802d53:	00 00 00 
  802d56:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802d58:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5d:	be 00 00 00 00       	mov    $0x0,%esi
  802d62:	bf 00 00 00 00       	mov    $0x0,%edi
  802d67:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
}
  802d73:	c9                   	leaveq 
  802d74:	c3                   	retq   

0000000000802d75 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	48 83 ec 30          	sub    $0x30,%rsp
  802d7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802d88:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d8f:	00 00 00 
  802d92:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d95:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802d97:	bf 01 00 00 00       	mov    $0x1,%edi
  802d9c:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802da3:	00 00 00 
  802da6:	ff d0                	callq  *%rax
  802da8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802daf:	78 3e                	js     802def <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802db1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802db8:	00 00 00 
  802dbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc3:	8b 40 10             	mov    0x10(%rax),%eax
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802dcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd0:	48 89 ce             	mov    %rcx,%rsi
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	8b 50 10             	mov    0x10(%rax),%edx
  802de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ded:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802def:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802df2:	c9                   	leaveq 
  802df3:	c3                   	retq   

0000000000802df4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 10          	sub    $0x10,%rsp
  802dfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e03:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802e06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e0d:	00 00 00 
  802e10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e13:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e15:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1c:	48 89 c6             	mov    %rax,%rsi
  802e1f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802e26:	00 00 00 
  802e29:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  802e30:	00 00 00 
  802e33:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802e35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e3c:	00 00 00 
  802e3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e42:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802e45:	bf 02 00 00 00       	mov    $0x2,%edi
  802e4a:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
}
  802e56:	c9                   	leaveq 
  802e57:	c3                   	retq   

0000000000802e58 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802e58:	55                   	push   %rbp
  802e59:	48 89 e5             	mov    %rsp,%rbp
  802e5c:	48 83 ec 10          	sub    $0x10,%rsp
  802e60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e63:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802e66:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e6d:	00 00 00 
  802e70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e73:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802e75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e7c:	00 00 00 
  802e7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802e85:	bf 03 00 00 00       	mov    $0x3,%edi
  802e8a:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
}
  802e96:	c9                   	leaveq 
  802e97:	c3                   	retq   

0000000000802e98 <nsipc_close>:

int
nsipc_close(int s)
{
  802e98:	55                   	push   %rbp
  802e99:	48 89 e5             	mov    %rsp,%rbp
  802e9c:	48 83 ec 10          	sub    $0x10,%rsp
  802ea0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802ea3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eaa:	00 00 00 
  802ead:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802eb0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802eb2:	bf 04 00 00 00       	mov    $0x4,%edi
  802eb7:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802ebe:	00 00 00 
  802ec1:	ff d0                	callq  *%rax
}
  802ec3:	c9                   	leaveq 
  802ec4:	c3                   	retq   

0000000000802ec5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ec5:	55                   	push   %rbp
  802ec6:	48 89 e5             	mov    %rsp,%rbp
  802ec9:	48 83 ec 10          	sub    $0x10,%rsp
  802ecd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ed0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ed4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802ed7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ede:	00 00 00 
  802ee1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ee4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802ee6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eed:	48 89 c6             	mov    %rax,%rsi
  802ef0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802ef7:	00 00 00 
  802efa:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  802f01:	00 00 00 
  802f04:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802f06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f0d:	00 00 00 
  802f10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f13:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802f16:	bf 05 00 00 00       	mov    $0x5,%edi
  802f1b:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	callq  *%rax
}
  802f27:	c9                   	leaveq 
  802f28:	c3                   	retq   

0000000000802f29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802f29:	55                   	push   %rbp
  802f2a:	48 89 e5             	mov    %rsp,%rbp
  802f2d:	48 83 ec 10          	sub    $0x10,%rsp
  802f31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802f37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f3e:	00 00 00 
  802f41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f44:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802f46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f4d:	00 00 00 
  802f50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802f56:	bf 06 00 00 00       	mov    $0x6,%edi
  802f5b:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
}
  802f67:	c9                   	leaveq 
  802f68:	c3                   	retq   

0000000000802f69 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802f69:	55                   	push   %rbp
  802f6a:	48 89 e5             	mov    %rsp,%rbp
  802f6d:	48 83 ec 30          	sub    $0x30,%rsp
  802f71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f78:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802f7b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802f7e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f85:	00 00 00 
  802f88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f8b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802f8d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f94:	00 00 00 
  802f97:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802f9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fa4:	00 00 00 
  802fa7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802faa:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802fad:	bf 07 00 00 00       	mov    $0x7,%edi
  802fb2:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802fb9:	00 00 00 
  802fbc:	ff d0                	callq  *%rax
  802fbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc5:	78 69                	js     803030 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802fc7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802fce:	7f 08                	jg     802fd8 <nsipc_recv+0x6f>
  802fd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802fd6:	7e 35                	jle    80300d <nsipc_recv+0xa4>
  802fd8:	48 b9 82 42 80 00 00 	movabs $0x804282,%rcx
  802fdf:	00 00 00 
  802fe2:	48 ba 97 42 80 00 00 	movabs $0x804297,%rdx
  802fe9:	00 00 00 
  802fec:	be 61 00 00 00       	mov    $0x61,%esi
  802ff1:	48 bf ac 42 80 00 00 	movabs $0x8042ac,%rdi
  802ff8:	00 00 00 
  802ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  803000:	49 b8 78 02 80 00 00 	movabs $0x800278,%r8
  803007:	00 00 00 
  80300a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80300d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803010:	48 63 d0             	movslq %eax,%rdx
  803013:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803017:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80301e:	00 00 00 
  803021:	48 89 c7             	mov    %rax,%rdi
  803024:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
	}

	return r;
  803030:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803033:	c9                   	leaveq 
  803034:	c3                   	retq   

0000000000803035 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803035:	55                   	push   %rbp
  803036:	48 89 e5             	mov    %rsp,%rbp
  803039:	48 83 ec 20          	sub    $0x20,%rsp
  80303d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803040:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803044:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803047:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80304a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803051:	00 00 00 
  803054:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803057:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803059:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803060:	7e 35                	jle    803097 <nsipc_send+0x62>
  803062:	48 b9 b8 42 80 00 00 	movabs $0x8042b8,%rcx
  803069:	00 00 00 
  80306c:	48 ba 97 42 80 00 00 	movabs $0x804297,%rdx
  803073:	00 00 00 
  803076:	be 6c 00 00 00       	mov    $0x6c,%esi
  80307b:	48 bf ac 42 80 00 00 	movabs $0x8042ac,%rdi
  803082:	00 00 00 
  803085:	b8 00 00 00 00       	mov    $0x0,%eax
  80308a:	49 b8 78 02 80 00 00 	movabs $0x800278,%r8
  803091:	00 00 00 
  803094:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80309a:	48 63 d0             	movslq %eax,%rdx
  80309d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a1:	48 89 c6             	mov    %rax,%rsi
  8030a4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8030ab:	00 00 00 
  8030ae:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8030ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c1:	00 00 00 
  8030c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8030ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030d1:	00 00 00 
  8030d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030d7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8030da:	bf 08 00 00 00       	mov    $0x8,%edi
  8030df:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 10          	sub    $0x10,%rsp
  8030f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8030fb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8030fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803105:	00 00 00 
  803108:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80310b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80310d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803114:	00 00 00 
  803117:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80311d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803124:	00 00 00 
  803127:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80312a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80312d:	bf 09 00 00 00       	mov    $0x9,%edi
  803132:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
}
  80313e:	c9                   	leaveq 
  80313f:	c3                   	retq   

0000000000803140 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803140:	55                   	push   %rbp
  803141:	48 89 e5             	mov    %rsp,%rbp
  803144:	53                   	push   %rbx
  803145:	48 83 ec 38          	sub    $0x38,%rsp
  803149:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80314d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803151:	48 89 c7             	mov    %rax,%rdi
  803154:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
  803160:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803163:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803167:	0f 88 bf 01 00 00    	js     80332c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80316d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803171:	ba 07 04 00 00       	mov    $0x407,%edx
  803176:	48 89 c6             	mov    %rax,%rsi
  803179:	bf 00 00 00 00       	mov    $0x0,%edi
  80317e:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
  80318a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803191:	0f 88 95 01 00 00    	js     80332c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803197:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
  8031aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031b1:	0f 88 5d 01 00 00    	js     803314 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8031c0:	48 89 c6             	mov    %rax,%rsi
  8031c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031c8:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  8031cf:	00 00 00 
  8031d2:	ff d0                	callq  *%rax
  8031d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031db:	0f 88 33 01 00 00    	js     803314 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e5:	48 89 c7             	mov    %rax,%rdi
  8031e8:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031fc:	ba 07 04 00 00       	mov    $0x407,%edx
  803201:	48 89 c6             	mov    %rax,%rsi
  803204:	bf 00 00 00 00       	mov    $0x0,%edi
  803209:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  803210:	00 00 00 
  803213:	ff d0                	callq  *%rax
  803215:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803218:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80321c:	0f 88 d9 00 00 00    	js     8032fb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803222:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803226:	48 89 c7             	mov    %rax,%rdi
  803229:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	48 89 c2             	mov    %rax,%rdx
  803238:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803242:	48 89 d1             	mov    %rdx,%rcx
  803245:	ba 00 00 00 00       	mov    $0x0,%edx
  80324a:	48 89 c6             	mov    %rax,%rsi
  80324d:	bf 00 00 00 00       	mov    $0x0,%edi
  803252:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
  80325e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803261:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803265:	78 79                	js     8032e0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803267:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803272:	00 00 00 
  803275:	8b 12                	mov    (%rdx),%edx
  803277:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803279:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803284:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803288:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80328f:	00 00 00 
  803292:	8b 12                	mov    (%rdx),%edx
  803294:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803296:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80329a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a5:	48 89 c7             	mov    %rax,%rdi
  8032a8:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	89 c2                	mov    %eax,%edx
  8032b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032ba:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8032bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032c0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8032c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c8:	48 89 c7             	mov    %rax,%rdi
  8032cb:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032de:	eb 4f                	jmp    80332f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8032e0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e5:	48 89 c6             	mov    %rax,%rsi
  8032e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ed:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax
  8032f9:	eb 01                	jmp    8032fc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8032fb:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8032fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803300:	48 89 c6             	mov    %rax,%rsi
  803303:	bf 00 00 00 00       	mov    $0x0,%edi
  803308:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803318:	48 89 c6             	mov    %rax,%rsi
  80331b:	bf 00 00 00 00       	mov    $0x0,%edi
  803320:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
err:
	return r;
  80332c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80332f:	48 83 c4 38          	add    $0x38,%rsp
  803333:	5b                   	pop    %rbx
  803334:	5d                   	pop    %rbp
  803335:	c3                   	retq   

0000000000803336 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803336:	55                   	push   %rbp
  803337:	48 89 e5             	mov    %rsp,%rbp
  80333a:	53                   	push   %rbx
  80333b:	48 83 ec 28          	sub    $0x28,%rsp
  80333f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803343:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803347:	eb 01                	jmp    80334a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803349:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80334a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803351:	00 00 00 
  803354:	48 8b 00             	mov    (%rax),%rax
  803357:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80335d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803364:	48 89 c7             	mov    %rax,%rdi
  803367:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	89 c3                	mov    %eax,%ebx
  803375:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803379:	48 89 c7             	mov    %rax,%rdi
  80337c:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
  803388:	39 c3                	cmp    %eax,%ebx
  80338a:	0f 94 c0             	sete   %al
  80338d:	0f b6 c0             	movzbl %al,%eax
  803390:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803393:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80339a:	00 00 00 
  80339d:	48 8b 00             	mov    (%rax),%rax
  8033a0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033a6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8033a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033af:	75 0a                	jne    8033bb <_pipeisclosed+0x85>
			return ret;
  8033b1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8033b4:	48 83 c4 28          	add    $0x28,%rsp
  8033b8:	5b                   	pop    %rbx
  8033b9:	5d                   	pop    %rbp
  8033ba:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8033bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033be:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033c1:	74 86                	je     803349 <_pipeisclosed+0x13>
  8033c3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033c7:	75 80                	jne    803349 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033c9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033d0:	00 00 00 
  8033d3:	48 8b 00             	mov    (%rax),%rax
  8033d6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8033dc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e2:	89 c6                	mov    %eax,%esi
  8033e4:	48 bf c9 42 80 00 00 	movabs $0x8042c9,%rdi
  8033eb:	00 00 00 
  8033ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f3:	49 b8 b3 04 80 00 00 	movabs $0x8004b3,%r8
  8033fa:	00 00 00 
  8033fd:	41 ff d0             	callq  *%r8
	}
  803400:	e9 44 ff ff ff       	jmpq   803349 <_pipeisclosed+0x13>

0000000000803405 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 30          	sub    $0x30,%rsp
  80340d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803410:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803414:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803417:	48 89 d6             	mov    %rdx,%rsi
  80341a:	89 c7                	mov    %eax,%edi
  80341c:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342f:	79 05                	jns    803436 <pipeisclosed+0x31>
		return r;
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	eb 31                	jmp    803467 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80344d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803451:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803455:	48 89 d6             	mov    %rdx,%rsi
  803458:	48 89 c7             	mov    %rax,%rdi
  80345b:	48 b8 36 33 80 00 00 	movabs $0x803336,%rax
  803462:	00 00 00 
  803465:	ff d0                	callq  *%rax
}
  803467:	c9                   	leaveq 
  803468:	c3                   	retq   

0000000000803469 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803469:	55                   	push   %rbp
  80346a:	48 89 e5             	mov    %rsp,%rbp
  80346d:	48 83 ec 40          	sub    $0x40,%rsp
  803471:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803479:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80347d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803481:	48 89 c7             	mov    %rax,%rdi
  803484:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  80348b:	00 00 00 
  80348e:	ff d0                	callq  *%rax
  803490:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803494:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803498:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80349c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034a3:	00 
  8034a4:	e9 97 00 00 00       	jmpq   803540 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8034a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034ae:	74 09                	je     8034b9 <devpipe_read+0x50>
				return i;
  8034b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b4:	e9 95 00 00 00       	jmpq   80354e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c1:	48 89 d6             	mov    %rdx,%rsi
  8034c4:	48 89 c7             	mov    %rax,%rdi
  8034c7:	48 b8 36 33 80 00 00 	movabs $0x803336,%rax
  8034ce:	00 00 00 
  8034d1:	ff d0                	callq  *%rax
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	74 07                	je     8034de <devpipe_read+0x75>
				return 0;
  8034d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dc:	eb 70                	jmp    80354e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8034de:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  8034e5:	00 00 00 
  8034e8:	ff d0                	callq  *%rax
  8034ea:	eb 01                	jmp    8034ed <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034ec:	90                   	nop
  8034ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f1:	8b 10                	mov    (%rax),%edx
  8034f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f7:	8b 40 04             	mov    0x4(%rax),%eax
  8034fa:	39 c2                	cmp    %eax,%edx
  8034fc:	74 ab                	je     8034a9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803502:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803506:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80350a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350e:	8b 00                	mov    (%rax),%eax
  803510:	89 c2                	mov    %eax,%edx
  803512:	c1 fa 1f             	sar    $0x1f,%edx
  803515:	c1 ea 1b             	shr    $0x1b,%edx
  803518:	01 d0                	add    %edx,%eax
  80351a:	83 e0 1f             	and    $0x1f,%eax
  80351d:	29 d0                	sub    %edx,%eax
  80351f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803523:	48 98                	cltq   
  803525:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80352a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80352c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803530:	8b 00                	mov    (%rax),%eax
  803532:	8d 50 01             	lea    0x1(%rax),%edx
  803535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803539:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80353b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803544:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803548:	72 a2                	jb     8034ec <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80354a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80354e:	c9                   	leaveq 
  80354f:	c3                   	retq   

0000000000803550 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803550:	55                   	push   %rbp
  803551:	48 89 e5             	mov    %rsp,%rbp
  803554:	48 83 ec 40          	sub    $0x40,%rsp
  803558:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80355c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803560:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
  803577:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80357b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80357f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803583:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80358a:	00 
  80358b:	e9 93 00 00 00       	jmpq   803623 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803590:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803598:	48 89 d6             	mov    %rdx,%rsi
  80359b:	48 89 c7             	mov    %rax,%rdi
  80359e:	48 b8 36 33 80 00 00 	movabs $0x803336,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	74 07                	je     8035b5 <devpipe_write+0x65>
				return 0;
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b3:	eb 7c                	jmp    803631 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035b5:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  8035bc:	00 00 00 
  8035bf:	ff d0                	callq  *%rax
  8035c1:	eb 01                	jmp    8035c4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035c3:	90                   	nop
  8035c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c8:	8b 40 04             	mov    0x4(%rax),%eax
  8035cb:	48 63 d0             	movslq %eax,%rdx
  8035ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d2:	8b 00                	mov    (%rax),%eax
  8035d4:	48 98                	cltq   
  8035d6:	48 83 c0 20          	add    $0x20,%rax
  8035da:	48 39 c2             	cmp    %rax,%rdx
  8035dd:	73 b1                	jae    803590 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e3:	8b 40 04             	mov    0x4(%rax),%eax
  8035e6:	89 c2                	mov    %eax,%edx
  8035e8:	c1 fa 1f             	sar    $0x1f,%edx
  8035eb:	c1 ea 1b             	shr    $0x1b,%edx
  8035ee:	01 d0                	add    %edx,%eax
  8035f0:	83 e0 1f             	and    $0x1f,%eax
  8035f3:	29 d0                	sub    %edx,%eax
  8035f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035fd:	48 01 ca             	add    %rcx,%rdx
  803600:	0f b6 0a             	movzbl (%rdx),%ecx
  803603:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803607:	48 98                	cltq   
  803609:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803611:	8b 40 04             	mov    0x4(%rax),%eax
  803614:	8d 50 01             	lea    0x1(%rax),%edx
  803617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80361e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803627:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80362b:	72 96                	jb     8035c3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80362d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803631:	c9                   	leaveq 
  803632:	c3                   	retq   

0000000000803633 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803633:	55                   	push   %rbp
  803634:	48 89 e5             	mov    %rsp,%rbp
  803637:	48 83 ec 20          	sub    $0x20,%rsp
  80363b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80363f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803647:	48 89 c7             	mov    %rax,%rdi
  80364a:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
  803656:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80365a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80365e:	48 be dc 42 80 00 00 	movabs $0x8042dc,%rsi
  803665:	00 00 00 
  803668:	48 89 c7             	mov    %rax,%rdi
  80366b:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367b:	8b 50 04             	mov    0x4(%rax),%edx
  80367e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803682:	8b 00                	mov    (%rax),%eax
  803684:	29 c2                	sub    %eax,%edx
  803686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803690:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803694:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80369b:	00 00 00 
	stat->st_dev = &devpipe;
  80369e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036a9:	00 00 00 
  8036ac:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8036b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b8:	c9                   	leaveq 
  8036b9:	c3                   	retq   

00000000008036ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036ba:	55                   	push   %rbp
  8036bb:	48 89 e5             	mov    %rsp,%rbp
  8036be:	48 83 ec 10          	sub    $0x10,%rsp
  8036c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ca:	48 89 c6             	mov    %rax,%rsi
  8036cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d2:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8036de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e2:	48 89 c7             	mov    %rax,%rdi
  8036e5:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	48 89 c6             	mov    %rax,%rsi
  8036f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f9:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  803700:	00 00 00 
  803703:	ff d0                	callq  *%rax
}
  803705:	c9                   	leaveq 
  803706:	c3                   	retq   
	...

0000000000803708 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803708:	55                   	push   %rbp
  803709:	48 89 e5             	mov    %rsp,%rbp
  80370c:	48 83 ec 20          	sub    $0x20,%rsp
  803710:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803713:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803716:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803719:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80371d:	be 01 00 00 00       	mov    $0x1,%esi
  803722:	48 89 c7             	mov    %rax,%rdi
  803725:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  80372c:	00 00 00 
  80372f:	ff d0                	callq  *%rax
}
  803731:	c9                   	leaveq 
  803732:	c3                   	retq   

0000000000803733 <getchar>:

int
getchar(void)
{
  803733:	55                   	push   %rbp
  803734:	48 89 e5             	mov    %rsp,%rbp
  803737:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80373b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80373f:	ba 01 00 00 00       	mov    $0x1,%edx
  803744:	48 89 c6             	mov    %rax,%rsi
  803747:	bf 00 00 00 00       	mov    $0x0,%edi
  80374c:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
  803758:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80375b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375f:	79 05                	jns    803766 <getchar+0x33>
		return r;
  803761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803764:	eb 14                	jmp    80377a <getchar+0x47>
	if (r < 1)
  803766:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376a:	7f 07                	jg     803773 <getchar+0x40>
		return -E_EOF;
  80376c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803771:	eb 07                	jmp    80377a <getchar+0x47>
	return c;
  803773:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803777:	0f b6 c0             	movzbl %al,%eax
}
  80377a:	c9                   	leaveq 
  80377b:	c3                   	retq   

000000000080377c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80377c:	55                   	push   %rbp
  80377d:	48 89 e5             	mov    %rsp,%rbp
  803780:	48 83 ec 20          	sub    $0x20,%rsp
  803784:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803787:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80378b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378e:	48 89 d6             	mov    %rdx,%rsi
  803791:	89 c7                	mov    %eax,%edi
  803793:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
  80379f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a6:	79 05                	jns    8037ad <iscons+0x31>
		return r;
  8037a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ab:	eb 1a                	jmp    8037c7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8037ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b1:	8b 10                	mov    (%rax),%edx
  8037b3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8037ba:	00 00 00 
  8037bd:	8b 00                	mov    (%rax),%eax
  8037bf:	39 c2                	cmp    %eax,%edx
  8037c1:	0f 94 c0             	sete   %al
  8037c4:	0f b6 c0             	movzbl %al,%eax
}
  8037c7:	c9                   	leaveq 
  8037c8:	c3                   	retq   

00000000008037c9 <opencons>:

int
opencons(void)
{
  8037c9:	55                   	push   %rbp
  8037ca:	48 89 e5             	mov    %rsp,%rbp
  8037cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8037d1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037d5:	48 89 c7             	mov    %rax,%rdi
  8037d8:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
  8037e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037eb:	79 05                	jns    8037f2 <opencons+0x29>
		return r;
  8037ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f0:	eb 5b                	jmp    80384d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8037fb:	48 89 c6             	mov    %rax,%rsi
  8037fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803803:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  80380a:	00 00 00 
  80380d:	ff d0                	callq  *%rax
  80380f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803812:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803816:	79 05                	jns    80381d <opencons+0x54>
		return r;
  803818:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381b:	eb 30                	jmp    80384d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80381d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803821:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803828:	00 00 00 
  80382b:	8b 12                	mov    (%rdx),%edx
  80382d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80382f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803833:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80383a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383e:	48 89 c7             	mov    %rax,%rdi
  803841:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  803848:	00 00 00 
  80384b:	ff d0                	callq  *%rax
}
  80384d:	c9                   	leaveq 
  80384e:	c3                   	retq   

000000000080384f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80384f:	55                   	push   %rbp
  803850:	48 89 e5             	mov    %rsp,%rbp
  803853:	48 83 ec 30          	sub    $0x30,%rsp
  803857:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80385b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80385f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803863:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803868:	75 13                	jne    80387d <devcons_read+0x2e>
		return 0;
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	eb 49                	jmp    8038ba <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803871:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80387d:	48 b8 be 18 80 00 00 	movabs $0x8018be,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
  803889:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803890:	74 df                	je     803871 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803892:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803896:	79 05                	jns    80389d <devcons_read+0x4e>
		return c;
  803898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389b:	eb 1d                	jmp    8038ba <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80389d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038a1:	75 07                	jne    8038aa <devcons_read+0x5b>
		return 0;
  8038a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a8:	eb 10                	jmp    8038ba <devcons_read+0x6b>
	*(char*)vbuf = c;
  8038aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ad:	89 c2                	mov    %eax,%edx
  8038af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b3:	88 10                	mov    %dl,(%rax)
	return 1;
  8038b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038ba:	c9                   	leaveq 
  8038bb:	c3                   	retq   

00000000008038bc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038bc:	55                   	push   %rbp
  8038bd:	48 89 e5             	mov    %rsp,%rbp
  8038c0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8038c7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8038ce:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8038d5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038e3:	eb 77                	jmp    80395c <devcons_write+0xa0>
		m = n - tot;
  8038e5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038ec:	89 c2                	mov    %eax,%edx
  8038ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f1:	89 d1                	mov    %edx,%ecx
  8038f3:	29 c1                	sub    %eax,%ecx
  8038f5:	89 c8                	mov    %ecx,%eax
  8038f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fd:	83 f8 7f             	cmp    $0x7f,%eax
  803900:	76 07                	jbe    803909 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803902:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803909:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80390c:	48 63 d0             	movslq %eax,%rdx
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803912:	48 98                	cltq   
  803914:	48 89 c1             	mov    %rax,%rcx
  803917:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80391e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803925:	48 89 ce             	mov    %rcx,%rsi
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803937:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80393a:	48 63 d0             	movslq %eax,%rdx
  80393d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803944:	48 89 d6             	mov    %rdx,%rsi
  803947:	48 89 c7             	mov    %rax,%rdi
  80394a:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803956:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803959:	01 45 fc             	add    %eax,-0x4(%rbp)
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	48 98                	cltq   
  803961:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803968:	0f 82 77 ff ff ff    	jb     8038e5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80396e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803971:	c9                   	leaveq 
  803972:	c3                   	retq   

0000000000803973 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803973:	55                   	push   %rbp
  803974:	48 89 e5             	mov    %rsp,%rbp
  803977:	48 83 ec 08          	sub    $0x8,%rsp
  80397b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80397f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803984:	c9                   	leaveq 
  803985:	c3                   	retq   

0000000000803986 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803986:	55                   	push   %rbp
  803987:	48 89 e5             	mov    %rsp,%rbp
  80398a:	48 83 ec 10          	sub    $0x10,%rsp
  80398e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803992:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399a:	48 be e8 42 80 00 00 	movabs $0x8042e8,%rsi
  8039a1:	00 00 00 
  8039a4:	48 89 c7             	mov    %rax,%rdi
  8039a7:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  8039ae:	00 00 00 
  8039b1:	ff d0                	callq  *%rax
	return 0;
  8039b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039b8:	c9                   	leaveq 
  8039b9:	c3                   	retq   
	...

00000000008039bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039bc:	55                   	push   %rbp
  8039bd:	48 89 e5             	mov    %rsp,%rbp
  8039c0:	48 83 ec 30          	sub    $0x30,%rsp
  8039c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8039d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8039d7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039dc:	74 18                	je     8039f6 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8039de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e2:	48 89 c7             	mov    %rax,%rdi
  8039e5:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
  8039f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f4:	eb 19                	jmp    803a0f <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8039f6:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8039fd:	00 00 00 
  803a00:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  803a07:	00 00 00 
  803a0a:	ff d0                	callq  *%rax
  803a0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803a0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a13:	79 39                	jns    803a4e <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803a15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a1a:	75 08                	jne    803a24 <ipc_recv+0x68>
  803a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a20:	8b 00                	mov    (%rax),%eax
  803a22:	eb 05                	jmp    803a29 <ipc_recv+0x6d>
  803a24:	b8 00 00 00 00       	mov    $0x0,%eax
  803a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a2d:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803a2f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a34:	75 08                	jne    803a3e <ipc_recv+0x82>
  803a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3a:	8b 00                	mov    (%rax),%eax
  803a3c:	eb 05                	jmp    803a43 <ipc_recv+0x87>
  803a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a43:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a47:	89 02                	mov    %eax,(%rdx)
		return r;
  803a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4c:	eb 53                	jmp    803aa1 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803a4e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a53:	74 19                	je     803a6e <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803a55:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a5c:	00 00 00 
  803a5f:	48 8b 00             	mov    (%rax),%rax
  803a62:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a6c:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803a6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a73:	74 19                	je     803a8e <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803a75:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a7c:	00 00 00 
  803a7f:	48 8b 00             	mov    (%rax),%rax
  803a82:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a8c:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803a8e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a95:	00 00 00 
  803a98:	48 8b 00             	mov    (%rax),%rax
  803a9b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803aa1:	c9                   	leaveq 
  803aa2:	c3                   	retq   

0000000000803aa3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803aa3:	55                   	push   %rbp
  803aa4:	48 89 e5             	mov    %rsp,%rbp
  803aa7:	48 83 ec 30          	sub    $0x30,%rsp
  803aab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aae:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ab1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ab5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803ab8:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803abf:	eb 59                	jmp    803b1a <ipc_send+0x77>
		if(pg) {
  803ac1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ac6:	74 20                	je     803ae8 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803ac8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803acb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ace:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ad2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad5:	89 c7                	mov    %eax,%edi
  803ad7:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  803ade:	00 00 00 
  803ae1:	ff d0                	callq  *%rax
  803ae3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae6:	eb 26                	jmp    803b0e <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803ae8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803aeb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af1:	89 d1                	mov    %edx,%ecx
  803af3:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803afa:	00 00 00 
  803afd:	89 c7                	mov    %eax,%edi
  803aff:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
  803b0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803b0e:	48 b8 7e 19 80 00 00 	movabs $0x80197e,%rax
  803b15:	00 00 00 
  803b18:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803b1a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b1e:	74 a1                	je     803ac1 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b24:	74 2a                	je     803b50 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803b26:	48 ba f0 42 80 00 00 	movabs $0x8042f0,%rdx
  803b2d:	00 00 00 
  803b30:	be 49 00 00 00       	mov    $0x49,%esi
  803b35:	48 bf 1b 43 80 00 00 	movabs $0x80431b,%rdi
  803b3c:	00 00 00 
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  803b4b:	00 00 00 
  803b4e:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803b50:	c9                   	leaveq 
  803b51:	c3                   	retq   

0000000000803b52 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b52:	55                   	push   %rbp
  803b53:	48 89 e5             	mov    %rsp,%rbp
  803b56:	48 83 ec 18          	sub    $0x18,%rsp
  803b5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b64:	eb 6a                	jmp    803bd0 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803b66:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b6d:	00 00 00 
  803b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b73:	48 63 d0             	movslq %eax,%rdx
  803b76:	48 89 d0             	mov    %rdx,%rax
  803b79:	48 c1 e0 02          	shl    $0x2,%rax
  803b7d:	48 01 d0             	add    %rdx,%rax
  803b80:	48 01 c0             	add    %rax,%rax
  803b83:	48 01 d0             	add    %rdx,%rax
  803b86:	48 c1 e0 05          	shl    $0x5,%rax
  803b8a:	48 01 c8             	add    %rcx,%rax
  803b8d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b93:	8b 00                	mov    (%rax),%eax
  803b95:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b98:	75 32                	jne    803bcc <ipc_find_env+0x7a>
			return envs[i].env_id;
  803b9a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ba1:	00 00 00 
  803ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba7:	48 63 d0             	movslq %eax,%rdx
  803baa:	48 89 d0             	mov    %rdx,%rax
  803bad:	48 c1 e0 02          	shl    $0x2,%rax
  803bb1:	48 01 d0             	add    %rdx,%rax
  803bb4:	48 01 c0             	add    %rax,%rax
  803bb7:	48 01 d0             	add    %rdx,%rax
  803bba:	48 c1 e0 05          	shl    $0x5,%rax
  803bbe:	48 01 c8             	add    %rcx,%rax
  803bc1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bc7:	8b 40 08             	mov    0x8(%rax),%eax
  803bca:	eb 12                	jmp    803bde <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803bcc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bd0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bd7:	7e 8d                	jle    803b66 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803bd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bde:	c9                   	leaveq 
  803bdf:	c3                   	retq   

0000000000803be0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803be0:	55                   	push   %rbp
  803be1:	48 89 e5             	mov    %rsp,%rbp
  803be4:	48 83 ec 18          	sub    $0x18,%rsp
  803be8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf0:	48 89 c2             	mov    %rax,%rdx
  803bf3:	48 c1 ea 15          	shr    $0x15,%rdx
  803bf7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bfe:	01 00 00 
  803c01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c05:	83 e0 01             	and    $0x1,%eax
  803c08:	48 85 c0             	test   %rax,%rax
  803c0b:	75 07                	jne    803c14 <pageref+0x34>
		return 0;
  803c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c12:	eb 53                	jmp    803c67 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c18:	48 89 c2             	mov    %rax,%rdx
  803c1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c26:	01 00 00 
  803c29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c35:	83 e0 01             	and    $0x1,%eax
  803c38:	48 85 c0             	test   %rax,%rax
  803c3b:	75 07                	jne    803c44 <pageref+0x64>
		return 0;
  803c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c42:	eb 23                	jmp    803c67 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c48:	48 89 c2             	mov    %rax,%rdx
  803c4b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c4f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c56:	00 00 00 
  803c59:	48 c1 e2 04          	shl    $0x4,%rdx
  803c5d:	48 01 d0             	add    %rdx,%rax
  803c60:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c64:	0f b7 c0             	movzwl %ax,%eax
}
  803c67:	c9                   	leaveq 
  803c68:	c3                   	retq   
