
obj/user/icode.debug:     file format elf64-x86-64


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
  80003c:	e8 1b 02 00 00       	callq  80025c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#define MOTD "/motd"
#endif

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004f:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800055:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800063:	00 00 00 
  800066:	48 ba 40 49 80 00 00 	movabs $0x804940,%rdx
  80006d:	00 00 00 
  800070:	48 89 10             	mov    %rdx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf 46 49 80 00 00 	movabs $0x804946,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf 55 49 80 00 00 	movabs $0x804955,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 68 49 80 00 00 	movabs $0x804968,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 b3 27 80 00 00 	movabs $0x8027b3,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xb9>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 6e 49 80 00 00 	movabs $0x80496e,%rdx
  8000d9:	00 00 00 
  8000dc:	be 15 00 00 00       	mov    $0x15,%esi
  8000e1:	48 bf 84 49 80 00 00 	movabs $0x804984,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 91 49 80 00 00 	movabs $0x804991,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x110>
		cprintf("Writing MOTD\n");
  80011a:	48 bf a4 49 80 00 00 	movabs $0x8049a4,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80015b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 d4 22 80 00 00 	movabs $0x8022d4,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800177:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd6>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf b2 49 80 00 00 	movabs $0x8049b2,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf c6 49 80 00 00 	movabs $0x8049c6,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 df 49 80 00 00 	movabs $0x8049df,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  8001db:	00 00 00 
  8001de:	48 be f1 49 80 00 00 	movabs $0x8049f1,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf f6 49 80 00 00 	movabs $0x8049f6,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 57 2d 80 00 00 	movabs $0x802d57,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800207:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1f9>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 01 4a 80 00 00 	movabs $0x804a01,%rdx
  800219:	00 00 00 
  80021c:	be 22 00 00 00       	mov    $0x22,%esi
  800221:	48 bf 84 49 80 00 00 	movabs $0x804984,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf 1d 4a 80 00 00 	movabs $0x804a1d,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	c9                   	leaveq 
  800259:	c3                   	retq   
	...

000000000080025c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025c:	55                   	push   %rbp
  80025d:	48 89 e5             	mov    %rsp,%rbp
  800260:	48 83 ec 10          	sub    $0x10,%rsp
  800264:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800267:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80026b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800272:	00 00 00 
  800275:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80027c:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  800283:	00 00 00 
  800286:	ff d0                	callq  *%rax
  800288:	48 98                	cltq   
  80028a:	48 89 c2             	mov    %rax,%rdx
  80028d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800293:	48 89 d0             	mov    %rdx,%rax
  800296:	48 c1 e0 02          	shl    $0x2,%rax
  80029a:	48 01 d0             	add    %rdx,%rax
  80029d:	48 01 c0             	add    %rax,%rax
  8002a0:	48 01 d0             	add    %rdx,%rax
  8002a3:	48 c1 e0 05          	shl    $0x5,%rax
  8002a7:	48 89 c2             	mov    %rax,%rdx
  8002aa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002b1:	00 00 00 
  8002b4:	48 01 c2             	add    %rax,%rdx
  8002b7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002be:	00 00 00 
  8002c1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c8:	7e 14                	jle    8002de <libmain+0x82>
		binaryname = argv[0];
  8002ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ce:	48 8b 10             	mov    (%rax),%rdx
  8002d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002d8:	00 00 00 
  8002db:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e5:	48 89 d6             	mov    %rdx,%rsi
  8002e8:	89 c7                	mov    %eax,%edi
  8002ea:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002f6:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	callq  *%rax
}
  800302:	c9                   	leaveq 
  800303:	c3                   	retq   

0000000000800304 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800304:	55                   	push   %rbp
  800305:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800308:	48 b8 fd 20 80 00 00 	movabs $0x8020fd,%rax
  80030f:	00 00 00 
  800312:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800314:	bf 00 00 00 00       	mov    $0x0,%edi
  800319:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  800320:	00 00 00 
  800323:	ff d0                	callq  *%rax
}
  800325:	5d                   	pop    %rbp
  800326:	c3                   	retq   
	...

0000000000800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %rbp
  800329:	48 89 e5             	mov    %rsp,%rbp
  80032c:	53                   	push   %rbx
  80032d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800334:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80033b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800341:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800348:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80034f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800356:	84 c0                	test   %al,%al
  800358:	74 23                	je     80037d <_panic+0x55>
  80035a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800361:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800365:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800369:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80036d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800371:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800375:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800379:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80037d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800384:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80038b:	00 00 00 
  80038e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800395:	00 00 00 
  800398:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80039c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003a3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003aa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003b8:	00 00 00 
  8003bb:	48 8b 18             	mov    (%rax),%rbx
  8003be:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  8003c5:	00 00 00 
  8003c8:	ff d0                	callq  *%rax
  8003ca:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003d7:	41 89 c8             	mov    %ecx,%r8d
  8003da:	48 89 d1             	mov    %rdx,%rcx
  8003dd:	48 89 da             	mov    %rbx,%rdx
  8003e0:	89 c6                	mov    %eax,%esi
  8003e2:	48 bf 38 4a 80 00 00 	movabs $0x804a38,%rdi
  8003e9:	00 00 00 
  8003ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f1:	49 b9 63 05 80 00 00 	movabs $0x800563,%r9
  8003f8:	00 00 00 
  8003fb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003fe:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800405:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80040c:	48 89 d6             	mov    %rdx,%rsi
  80040f:	48 89 c7             	mov    %rax,%rdi
  800412:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  800419:	00 00 00 
  80041c:	ff d0                	callq  *%rax
	cprintf("\n");
  80041e:	48 bf 5b 4a 80 00 00 	movabs $0x804a5b,%rdi
  800425:	00 00 00 
  800428:	b8 00 00 00 00       	mov    $0x0,%eax
  80042d:	48 ba 63 05 80 00 00 	movabs $0x800563,%rdx
  800434:	00 00 00 
  800437:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800439:	cc                   	int3   
  80043a:	eb fd                	jmp    800439 <_panic+0x111>

000000000080043c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	48 83 ec 10          	sub    $0x10,%rsp
  800444:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800447:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80044b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044f:	8b 00                	mov    (%rax),%eax
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	89 d6                	mov    %edx,%esi
  800456:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80045a:	48 63 d0             	movslq %eax,%rdx
  80045d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800462:	8d 50 01             	lea    0x1(%rax),%edx
  800465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800469:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80046b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046f:	8b 00                	mov    (%rax),%eax
  800471:	3d ff 00 00 00       	cmp    $0xff,%eax
  800476:	75 2c                	jne    8004a4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047c:	8b 00                	mov    (%rax),%eax
  80047e:	48 98                	cltq   
  800480:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800484:	48 83 c2 08          	add    $0x8,%rdx
  800488:	48 89 c6             	mov    %rax,%rsi
  80048b:	48 89 d7             	mov    %rdx,%rdi
  80048e:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  800495:	00 00 00 
  800498:	ff d0                	callq  *%rax
        b->idx = 0;
  80049a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a8:	8b 40 04             	mov    0x4(%rax),%eax
  8004ab:	8d 50 01             	lea    0x1(%rax),%edx
  8004ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004b5:	c9                   	leaveq 
  8004b6:	c3                   	retq   

00000000008004b7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004c2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004c9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004d0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004d7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004de:	48 8b 0a             	mov    (%rdx),%rcx
  8004e1:	48 89 08             	mov    %rcx,(%rax)
  8004e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004fb:	00 00 00 
    b.cnt = 0;
  8004fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800505:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800508:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80050f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800516:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80051d:	48 89 c6             	mov    %rax,%rsi
  800520:	48 bf 3c 04 80 00 00 	movabs $0x80043c,%rdi
  800527:	00 00 00 
  80052a:	48 b8 14 09 80 00 00 	movabs $0x800914,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800536:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80053c:	48 98                	cltq   
  80053e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800545:	48 83 c2 08          	add    $0x8,%rdx
  800549:	48 89 c6             	mov    %rax,%rsi
  80054c:	48 89 d7             	mov    %rdx,%rdi
  80054f:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  800556:	00 00 00 
  800559:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80055b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800561:	c9                   	leaveq 
  800562:	c3                   	retq   

0000000000800563 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800563:	55                   	push   %rbp
  800564:	48 89 e5             	mov    %rsp,%rbp
  800567:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80056e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800575:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80057c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800583:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80058a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800591:	84 c0                	test   %al,%al
  800593:	74 20                	je     8005b5 <cprintf+0x52>
  800595:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800599:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80059d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005bc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005c3:	00 00 00 
  8005c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005cd:	00 00 00 
  8005d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005f7:	48 8b 0a             	mov    (%rdx),%rcx
  8005fa:	48 89 08             	mov    %rcx,(%rax)
  8005fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800601:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800605:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800609:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80060d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800614:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80061b:	48 89 d6             	mov    %rdx,%rsi
  80061e:	48 89 c7             	mov    %rax,%rdi
  800621:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  800628:	00 00 00 
  80062b:	ff d0                	callq  *%rax
  80062d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800633:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800639:	c9                   	leaveq 
  80063a:	c3                   	retq   
	...

000000000080063c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80063c:	55                   	push   %rbp
  80063d:	48 89 e5             	mov    %rsp,%rbp
  800640:	48 83 ec 30          	sub    $0x30,%rsp
  800644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80064c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800650:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800653:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800657:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80065b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80065e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800662:	77 52                	ja     8006b6 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800664:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800667:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80066b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80066e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	ba 00 00 00 00       	mov    $0x0,%edx
  80067b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80067f:	48 89 c2             	mov    %rax,%rdx
  800682:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800685:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800688:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80068c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800690:	41 89 f9             	mov    %edi,%r9d
  800693:	48 89 c7             	mov    %rax,%rdi
  800696:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  80069d:	00 00 00 
  8006a0:	ff d0                	callq  *%rax
  8006a2:	eb 1c                	jmp    8006c0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8006ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006af:	48 89 d6             	mov    %rdx,%rsi
  8006b2:	89 c7                	mov    %eax,%edi
  8006b4:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8006ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8006be:	7f e4                	jg     8006a4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	48 f7 f1             	div    %rcx
  8006cf:	48 89 d0             	mov    %rdx,%rax
  8006d2:	48 ba 50 4c 80 00 00 	movabs $0x804c50,%rdx
  8006d9:	00 00 00 
  8006dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006e0:	0f be c0             	movsbl %al,%eax
  8006e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006eb:	48 89 d6             	mov    %rdx,%rsi
  8006ee:	89 c7                	mov    %eax,%edi
  8006f0:	ff d1                	callq  *%rcx
}
  8006f2:	c9                   	leaveq 
  8006f3:	c3                   	retq   

00000000008006f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006f4:	55                   	push   %rbp
  8006f5:	48 89 e5             	mov    %rsp,%rbp
  8006f8:	48 83 ec 20          	sub    $0x20,%rsp
  8006fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800700:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800703:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800707:	7e 52                	jle    80075b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	83 f8 30             	cmp    $0x30,%eax
  800712:	73 24                	jae    800738 <getuint+0x44>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	89 c0                	mov    %eax,%eax
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	8b 12                	mov    (%rdx),%edx
  80072d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800734:	89 0a                	mov    %ecx,(%rdx)
  800736:	eb 17                	jmp    80074f <getuint+0x5b>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800740:	48 89 d0             	mov    %rdx,%rax
  800743:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074f:	48 8b 00             	mov    (%rax),%rax
  800752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800756:	e9 a3 00 00 00       	jmpq   8007fe <getuint+0x10a>
	else if (lflag)
  80075b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80075f:	74 4f                	je     8007b0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	8b 00                	mov    (%rax),%eax
  800767:	83 f8 30             	cmp    $0x30,%eax
  80076a:	73 24                	jae    800790 <getuint+0x9c>
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800778:	8b 00                	mov    (%rax),%eax
  80077a:	89 c0                	mov    %eax,%eax
  80077c:	48 01 d0             	add    %rdx,%rax
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	8b 12                	mov    (%rdx),%edx
  800785:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800788:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078c:	89 0a                	mov    %ecx,(%rdx)
  80078e:	eb 17                	jmp    8007a7 <getuint+0xb3>
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800798:	48 89 d0             	mov    %rdx,%rax
  80079b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a7:	48 8b 00             	mov    (%rax),%rax
  8007aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ae:	eb 4e                	jmp    8007fe <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	8b 00                	mov    (%rax),%eax
  8007b6:	83 f8 30             	cmp    $0x30,%eax
  8007b9:	73 24                	jae    8007df <getuint+0xeb>
  8007bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	8b 00                	mov    (%rax),%eax
  8007c9:	89 c0                	mov    %eax,%eax
  8007cb:	48 01 d0             	add    %rdx,%rax
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	8b 12                	mov    (%rdx),%edx
  8007d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007db:	89 0a                	mov    %ecx,(%rdx)
  8007dd:	eb 17                	jmp    8007f6 <getuint+0x102>
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e7:	48 89 d0             	mov    %rdx,%rax
  8007ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f6:	8b 00                	mov    (%rax),%eax
  8007f8:	89 c0                	mov    %eax,%eax
  8007fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 20          	sub    $0x20,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800813:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800817:	7e 52                	jle    80086b <getint+0x67>
		x=va_arg(*ap, long long);
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	83 f8 30             	cmp    $0x30,%eax
  800822:	73 24                	jae    800848 <getint+0x44>
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	8b 00                	mov    (%rax),%eax
  800832:	89 c0                	mov    %eax,%eax
  800834:	48 01 d0             	add    %rdx,%rax
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	8b 12                	mov    (%rdx),%edx
  80083d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	89 0a                	mov    %ecx,(%rdx)
  800846:	eb 17                	jmp    80085f <getint+0x5b>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800850:	48 89 d0             	mov    %rdx,%rax
  800853:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085f:	48 8b 00             	mov    (%rax),%rax
  800862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800866:	e9 a3 00 00 00       	jmpq   80090e <getint+0x10a>
	else if (lflag)
  80086b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80086f:	74 4f                	je     8008c0 <getint+0xbc>
		x=va_arg(*ap, long);
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	83 f8 30             	cmp    $0x30,%eax
  80087a:	73 24                	jae    8008a0 <getint+0x9c>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	8b 00                	mov    (%rax),%eax
  80088a:	89 c0                	mov    %eax,%eax
  80088c:	48 01 d0             	add    %rdx,%rax
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	8b 12                	mov    (%rdx),%edx
  800895:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089c:	89 0a                	mov    %ecx,(%rdx)
  80089e:	eb 17                	jmp    8008b7 <getint+0xb3>
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a8:	48 89 d0             	mov    %rdx,%rax
  8008ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b7:	48 8b 00             	mov    (%rax),%rax
  8008ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008be:	eb 4e                	jmp    80090e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c4:	8b 00                	mov    (%rax),%eax
  8008c6:	83 f8 30             	cmp    $0x30,%eax
  8008c9:	73 24                	jae    8008ef <getint+0xeb>
  8008cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	8b 00                	mov    (%rax),%eax
  8008d9:	89 c0                	mov    %eax,%eax
  8008db:	48 01 d0             	add    %rdx,%rax
  8008de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e2:	8b 12                	mov    (%rdx),%edx
  8008e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008eb:	89 0a                	mov    %ecx,(%rdx)
  8008ed:	eb 17                	jmp    800906 <getint+0x102>
  8008ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f7:	48 89 d0             	mov    %rdx,%rax
  8008fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800902:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800906:	8b 00                	mov    (%rax),%eax
  800908:	48 98                	cltq   
  80090a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80090e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800912:	c9                   	leaveq 
  800913:	c3                   	retq   

0000000000800914 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800914:	55                   	push   %rbp
  800915:	48 89 e5             	mov    %rsp,%rbp
  800918:	41 54                	push   %r12
  80091a:	53                   	push   %rbx
  80091b:	48 83 ec 60          	sub    $0x60,%rsp
  80091f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800923:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800927:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80092b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80092f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800933:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800937:	48 8b 0a             	mov    (%rdx),%rcx
  80093a:	48 89 08             	mov    %rcx,(%rax)
  80093d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800941:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800945:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800949:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094d:	eb 17                	jmp    800966 <vprintfmt+0x52>
			if (ch == '\0')
  80094f:	85 db                	test   %ebx,%ebx
  800951:	0f 84 ea 04 00 00    	je     800e41 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800957:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80095b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80095f:	48 89 c6             	mov    %rax,%rsi
  800962:	89 df                	mov    %ebx,%edi
  800964:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800966:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80096a:	0f b6 00             	movzbl (%rax),%eax
  80096d:	0f b6 d8             	movzbl %al,%ebx
  800970:	83 fb 25             	cmp    $0x25,%ebx
  800973:	0f 95 c0             	setne  %al
  800976:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80097b:	84 c0                	test   %al,%al
  80097d:	75 d0                	jne    80094f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800983:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800991:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800998:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80099f:	eb 04                	jmp    8009a5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8009a1:	90                   	nop
  8009a2:	eb 01                	jmp    8009a5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8009a4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009a9:	0f b6 00             	movzbl (%rax),%eax
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	89 d8                	mov    %ebx,%eax
  8009b1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009b6:	83 e8 23             	sub    $0x23,%eax
  8009b9:	83 f8 55             	cmp    $0x55,%eax
  8009bc:	0f 87 4b 04 00 00    	ja     800e0d <vprintfmt+0x4f9>
  8009c2:	89 c0                	mov    %eax,%eax
  8009c4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009cb:	00 
  8009cc:	48 b8 78 4c 80 00 00 	movabs $0x804c78,%rax
  8009d3:	00 00 00 
  8009d6:	48 01 d0             	add    %rdx,%rax
  8009d9:	48 8b 00             	mov    (%rax),%rax
  8009dc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009de:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009e2:	eb c1                	jmp    8009a5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009e8:	eb bb                	jmp    8009a5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ea:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009f1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009f4:	89 d0                	mov    %edx,%eax
  8009f6:	c1 e0 02             	shl    $0x2,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	01 c0                	add    %eax,%eax
  8009fd:	01 d8                	add    %ebx,%eax
  8009ff:	83 e8 30             	sub    $0x30,%eax
  800a02:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a05:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a09:	0f b6 00             	movzbl (%rax),%eax
  800a0c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a12:	7e 63                	jle    800a77 <vprintfmt+0x163>
  800a14:	83 fb 39             	cmp    $0x39,%ebx
  800a17:	7f 5e                	jg     800a77 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a19:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a1e:	eb d1                	jmp    8009f1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a23:	83 f8 30             	cmp    $0x30,%eax
  800a26:	73 17                	jae    800a3f <vprintfmt+0x12b>
  800a28:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2f:	89 c0                	mov    %eax,%eax
  800a31:	48 01 d0             	add    %rdx,%rax
  800a34:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a37:	83 c2 08             	add    $0x8,%edx
  800a3a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a3d:	eb 0f                	jmp    800a4e <vprintfmt+0x13a>
  800a3f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a43:	48 89 d0             	mov    %rdx,%rax
  800a46:	48 83 c2 08          	add    $0x8,%rdx
  800a4a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a4e:	8b 00                	mov    (%rax),%eax
  800a50:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a53:	eb 23                	jmp    800a78 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a59:	0f 89 42 ff ff ff    	jns    8009a1 <vprintfmt+0x8d>
				width = 0;
  800a5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a66:	e9 36 ff ff ff       	jmpq   8009a1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a6b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a72:	e9 2e ff ff ff       	jmpq   8009a5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a77:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7c:	0f 89 22 ff ff ff    	jns    8009a4 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a82:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a85:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a88:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a8f:	e9 10 ff ff ff       	jmpq   8009a4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a94:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a98:	e9 08 ff ff ff       	jmpq   8009a5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	83 f8 30             	cmp    $0x30,%eax
  800aa3:	73 17                	jae    800abc <vprintfmt+0x1a8>
  800aa5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	89 c0                	mov    %eax,%eax
  800aae:	48 01 d0             	add    %rdx,%rax
  800ab1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab4:	83 c2 08             	add    $0x8,%edx
  800ab7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aba:	eb 0f                	jmp    800acb <vprintfmt+0x1b7>
  800abc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac0:	48 89 d0             	mov    %rdx,%rax
  800ac3:	48 83 c2 08          	add    $0x8,%rdx
  800ac7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800acb:	8b 00                	mov    (%rax),%eax
  800acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ad5:	48 89 d6             	mov    %rdx,%rsi
  800ad8:	89 c7                	mov    %eax,%edi
  800ada:	ff d1                	callq  *%rcx
			break;
  800adc:	e9 5a 03 00 00       	jmpq   800e3b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae4:	83 f8 30             	cmp    $0x30,%eax
  800ae7:	73 17                	jae    800b00 <vprintfmt+0x1ec>
  800ae9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af0:	89 c0                	mov    %eax,%eax
  800af2:	48 01 d0             	add    %rdx,%rax
  800af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af8:	83 c2 08             	add    $0x8,%edx
  800afb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afe:	eb 0f                	jmp    800b0f <vprintfmt+0x1fb>
  800b00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b04:	48 89 d0             	mov    %rdx,%rax
  800b07:	48 83 c2 08          	add    $0x8,%rdx
  800b0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b11:	85 db                	test   %ebx,%ebx
  800b13:	79 02                	jns    800b17 <vprintfmt+0x203>
				err = -err;
  800b15:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b17:	83 fb 15             	cmp    $0x15,%ebx
  800b1a:	7f 16                	jg     800b32 <vprintfmt+0x21e>
  800b1c:	48 b8 a0 4b 80 00 00 	movabs $0x804ba0,%rax
  800b23:	00 00 00 
  800b26:	48 63 d3             	movslq %ebx,%rdx
  800b29:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b2d:	4d 85 e4             	test   %r12,%r12
  800b30:	75 2e                	jne    800b60 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b32:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3a:	89 d9                	mov    %ebx,%ecx
  800b3c:	48 ba 61 4c 80 00 00 	movabs $0x804c61,%rdx
  800b43:	00 00 00 
  800b46:	48 89 c7             	mov    %rax,%rdi
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4e:	49 b8 4b 0e 80 00 00 	movabs $0x800e4b,%r8
  800b55:	00 00 00 
  800b58:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b5b:	e9 db 02 00 00       	jmpq   800e3b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b60:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b68:	4c 89 e1             	mov    %r12,%rcx
  800b6b:	48 ba 6a 4c 80 00 00 	movabs $0x804c6a,%rdx
  800b72:	00 00 00 
  800b75:	48 89 c7             	mov    %rax,%rdi
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7d:	49 b8 4b 0e 80 00 00 	movabs $0x800e4b,%r8
  800b84:	00 00 00 
  800b87:	41 ff d0             	callq  *%r8
			break;
  800b8a:	e9 ac 02 00 00       	jmpq   800e3b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b92:	83 f8 30             	cmp    $0x30,%eax
  800b95:	73 17                	jae    800bae <vprintfmt+0x29a>
  800b97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9e:	89 c0                	mov    %eax,%eax
  800ba0:	48 01 d0             	add    %rdx,%rax
  800ba3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba6:	83 c2 08             	add    $0x8,%edx
  800ba9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bac:	eb 0f                	jmp    800bbd <vprintfmt+0x2a9>
  800bae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb2:	48 89 d0             	mov    %rdx,%rax
  800bb5:	48 83 c2 08          	add    $0x8,%rdx
  800bb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbd:	4c 8b 20             	mov    (%rax),%r12
  800bc0:	4d 85 e4             	test   %r12,%r12
  800bc3:	75 0a                	jne    800bcf <vprintfmt+0x2bb>
				p = "(null)";
  800bc5:	49 bc 6d 4c 80 00 00 	movabs $0x804c6d,%r12
  800bcc:	00 00 00 
			if (width > 0 && padc != '-')
  800bcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd3:	7e 7a                	jle    800c4f <vprintfmt+0x33b>
  800bd5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bd9:	74 74                	je     800c4f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bde:	48 98                	cltq   
  800be0:	48 89 c6             	mov    %rax,%rsi
  800be3:	4c 89 e7             	mov    %r12,%rdi
  800be6:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  800bed:	00 00 00 
  800bf0:	ff d0                	callq  *%rax
  800bf2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bf5:	eb 17                	jmp    800c0e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bf7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bff:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c03:	48 89 d6             	mov    %rdx,%rsi
  800c06:	89 c7                	mov    %eax,%edi
  800c08:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c12:	7f e3                	jg     800bf7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c14:	eb 39                	jmp    800c4f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800c16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c1a:	74 1e                	je     800c3a <vprintfmt+0x326>
  800c1c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1f:	7e 05                	jle    800c26 <vprintfmt+0x312>
  800c21:	83 fb 7e             	cmp    $0x7e,%ebx
  800c24:	7e 14                	jle    800c3a <vprintfmt+0x326>
					putch('?', putdat);
  800c26:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c2a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c2e:	48 89 c6             	mov    %rax,%rsi
  800c31:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c36:	ff d2                	callq  *%rdx
  800c38:	eb 0f                	jmp    800c49 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c3a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c3e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c42:	48 89 c6             	mov    %rax,%rsi
  800c45:	89 df                	mov    %ebx,%edi
  800c47:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c49:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c4d:	eb 01                	jmp    800c50 <vprintfmt+0x33c>
  800c4f:	90                   	nop
  800c50:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c55:	0f be d8             	movsbl %al,%ebx
  800c58:	85 db                	test   %ebx,%ebx
  800c5a:	0f 95 c0             	setne  %al
  800c5d:	49 83 c4 01          	add    $0x1,%r12
  800c61:	84 c0                	test   %al,%al
  800c63:	74 28                	je     800c8d <vprintfmt+0x379>
  800c65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c69:	78 ab                	js     800c16 <vprintfmt+0x302>
  800c6b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c73:	79 a1                	jns    800c16 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c75:	eb 16                	jmp    800c8d <vprintfmt+0x379>
				putch(' ', putdat);
  800c77:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c7b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c7f:	48 89 c6             	mov    %rax,%rsi
  800c82:	bf 20 00 00 00       	mov    $0x20,%edi
  800c87:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c89:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c91:	7f e4                	jg     800c77 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c93:	e9 a3 01 00 00       	jmpq   800e3b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c9c:	be 03 00 00 00       	mov    $0x3,%esi
  800ca1:	48 89 c7             	mov    %rax,%rdi
  800ca4:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800cab:	00 00 00 
  800cae:	ff d0                	callq  *%rax
  800cb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb8:	48 85 c0             	test   %rax,%rax
  800cbb:	79 1d                	jns    800cda <vprintfmt+0x3c6>
				putch('-', putdat);
  800cbd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cc1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cc5:	48 89 c6             	mov    %rax,%rsi
  800cc8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ccd:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd3:	48 f7 d8             	neg    %rax
  800cd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ce1:	e9 e8 00 00 00       	jmpq   800dce <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ce6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cea:	be 03 00 00 00       	mov    $0x3,%esi
  800cef:	48 89 c7             	mov    %rax,%rdi
  800cf2:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	callq  *%rax
  800cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d09:	e9 c0 00 00 00       	jmpq   800dce <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d16:	48 89 c6             	mov    %rax,%rsi
  800d19:	bf 58 00 00 00       	mov    $0x58,%edi
  800d1e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d20:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d24:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d28:	48 89 c6             	mov    %rax,%rsi
  800d2b:	bf 58 00 00 00       	mov    $0x58,%edi
  800d30:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d32:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d36:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d3a:	48 89 c6             	mov    %rax,%rsi
  800d3d:	bf 58 00 00 00       	mov    $0x58,%edi
  800d42:	ff d2                	callq  *%rdx
			break;
  800d44:	e9 f2 00 00 00       	jmpq   800e3b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800d49:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d4d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d51:	48 89 c6             	mov    %rax,%rsi
  800d54:	bf 30 00 00 00       	mov    $0x30,%edi
  800d59:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d5b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d5f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d63:	48 89 c6             	mov    %rax,%rsi
  800d66:	bf 78 00 00 00       	mov    $0x78,%edi
  800d6b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d70:	83 f8 30             	cmp    $0x30,%eax
  800d73:	73 17                	jae    800d8c <vprintfmt+0x478>
  800d75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7c:	89 c0                	mov    %eax,%eax
  800d7e:	48 01 d0             	add    %rdx,%rax
  800d81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d84:	83 c2 08             	add    $0x8,%edx
  800d87:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d8a:	eb 0f                	jmp    800d9b <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800d8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d90:	48 89 d0             	mov    %rdx,%rax
  800d93:	48 83 c2 08          	add    $0x8,%rdx
  800d97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800da2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800da9:	eb 23                	jmp    800dce <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800daf:	be 03 00 00 00       	mov    $0x3,%esi
  800db4:	48 89 c7             	mov    %rax,%rdi
  800db7:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  800dbe:	00 00 00 
  800dc1:	ff d0                	callq  *%rax
  800dc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dc7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dce:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800dd3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dd6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ddd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de5:	45 89 c1             	mov    %r8d,%r9d
  800de8:	41 89 f8             	mov    %edi,%r8d
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800df5:	00 00 00 
  800df8:	ff d0                	callq  *%rax
			break;
  800dfa:	eb 3f                	jmp    800e3b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dfc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e00:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e04:	48 89 c6             	mov    %rax,%rsi
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	ff d2                	callq  *%rdx
			break;
  800e0b:	eb 2e                	jmp    800e3b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e15:	48 89 c6             	mov    %rax,%rsi
  800e18:	bf 25 00 00 00       	mov    $0x25,%edi
  800e1d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e24:	eb 05                	jmp    800e2b <vprintfmt+0x517>
  800e26:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e2f:	48 83 e8 01          	sub    $0x1,%rax
  800e33:	0f b6 00             	movzbl (%rax),%eax
  800e36:	3c 25                	cmp    $0x25,%al
  800e38:	75 ec                	jne    800e26 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800e3a:	90                   	nop
		}
	}
  800e3b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3c:	e9 25 fb ff ff       	jmpq   800966 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e41:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e42:	48 83 c4 60          	add    $0x60,%rsp
  800e46:	5b                   	pop    %rbx
  800e47:	41 5c                	pop    %r12
  800e49:	5d                   	pop    %rbp
  800e4a:	c3                   	retq   

0000000000800e4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e4b:	55                   	push   %rbp
  800e4c:	48 89 e5             	mov    %rsp,%rbp
  800e4f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e56:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e5d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e64:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e6b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e72:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e79:	84 c0                	test   %al,%al
  800e7b:	74 20                	je     800e9d <printfmt+0x52>
  800e7d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e81:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e85:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e89:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e8d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e91:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e95:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e99:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e9d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ea4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eab:	00 00 00 
  800eae:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800eb5:	00 00 00 
  800eb8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ebc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ec3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eca:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ed1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ed8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800edf:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ee6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eed:	48 89 c7             	mov    %rax,%rdi
  800ef0:	48 b8 14 09 80 00 00 	movabs $0x800914,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800efc:	c9                   	leaveq 
  800efd:	c3                   	retq   

0000000000800efe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800efe:	55                   	push   %rbp
  800eff:	48 89 e5             	mov    %rsp,%rbp
  800f02:	48 83 ec 10          	sub    $0x10,%rsp
  800f06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f11:	8b 40 10             	mov    0x10(%rax),%eax
  800f14:	8d 50 01             	lea    0x1(%rax),%edx
  800f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f22:	48 8b 10             	mov    (%rax),%rdx
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f29:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f2d:	48 39 c2             	cmp    %rax,%rdx
  800f30:	73 17                	jae    800f49 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f36:	48 8b 00             	mov    (%rax),%rax
  800f39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f3c:	88 10                	mov    %dl,(%rax)
  800f3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f46:	48 89 10             	mov    %rdx,(%rax)
}
  800f49:	c9                   	leaveq 
  800f4a:	c3                   	retq   

0000000000800f4b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f4b:	55                   	push   %rbp
  800f4c:	48 89 e5             	mov    %rsp,%rbp
  800f4f:	48 83 ec 50          	sub    $0x50,%rsp
  800f53:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f57:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f5a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f5e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f62:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f66:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f6a:	48 8b 0a             	mov    (%rdx),%rcx
  800f6d:	48 89 08             	mov    %rcx,(%rax)
  800f70:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f74:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f78:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f7c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f84:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f88:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f8b:	48 98                	cltq   
  800f8d:	48 83 e8 01          	sub    $0x1,%rax
  800f91:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f95:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fa0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fa5:	74 06                	je     800fad <vsnprintf+0x62>
  800fa7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fab:	7f 07                	jg     800fb4 <vsnprintf+0x69>
		return -E_INVAL;
  800fad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb2:	eb 2f                	jmp    800fe3 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fb4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fb8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fbc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fc0:	48 89 c6             	mov    %rax,%rsi
  800fc3:	48 bf fe 0e 80 00 00 	movabs $0x800efe,%rdi
  800fca:	00 00 00 
  800fcd:	48 b8 14 09 80 00 00 	movabs $0x800914,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fdd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fe0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fe3:	c9                   	leaveq 
  800fe4:	c3                   	retq   

0000000000800fe5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fe5:	55                   	push   %rbp
  800fe6:	48 89 e5             	mov    %rsp,%rbp
  800fe9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ff0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ff7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ffd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801004:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80100b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801012:	84 c0                	test   %al,%al
  801014:	74 20                	je     801036 <snprintf+0x51>
  801016:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80101a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80101e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801022:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801026:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80102a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80102e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801032:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801036:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80103d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801044:	00 00 00 
  801047:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80104e:	00 00 00 
  801051:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801055:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80105c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801063:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80106a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801071:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801078:	48 8b 0a             	mov    (%rdx),%rcx
  80107b:	48 89 08             	mov    %rcx,(%rax)
  80107e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801082:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801086:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80108a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80108e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801095:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80109c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010a9:	48 89 c7             	mov    %rax,%rdi
  8010ac:	48 b8 4b 0f 80 00 00 	movabs $0x800f4b,%rax
  8010b3:	00 00 00 
  8010b6:	ff d0                	callq  *%rax
  8010b8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010be:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   
	...

00000000008010c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 18          	sub    $0x18,%rsp
  8010d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010db:	eb 09                	jmp    8010e6 <strlen+0x1e>
		n++;
  8010dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	0f b6 00             	movzbl (%rax),%eax
  8010ed:	84 c0                	test   %al,%al
  8010ef:	75 ec                	jne    8010dd <strlen+0x15>
		n++;
	return n;
  8010f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 20          	sub    $0x20,%rsp
  8010fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801102:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80110d:	eb 0e                	jmp    80111d <strnlen+0x27>
		n++;
  80110f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801113:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801118:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80111d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801122:	74 0b                	je     80112f <strnlen+0x39>
  801124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801128:	0f b6 00             	movzbl (%rax),%eax
  80112b:	84 c0                	test   %al,%al
  80112d:	75 e0                	jne    80110f <strnlen+0x19>
		n++;
	return n;
  80112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 20          	sub    $0x20,%rsp
  80113c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801140:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801148:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80114c:	90                   	nop
  80114d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801151:	0f b6 10             	movzbl (%rax),%edx
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	88 10                	mov    %dl,(%rax)
  80115a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115e:	0f b6 00             	movzbl (%rax),%eax
  801161:	84 c0                	test   %al,%al
  801163:	0f 95 c0             	setne  %al
  801166:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80116b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801170:	84 c0                	test   %al,%al
  801172:	75 d9                	jne    80114d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801178:	c9                   	leaveq 
  801179:	c3                   	retq   

000000000080117a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80117a:	55                   	push   %rbp
  80117b:	48 89 e5             	mov    %rsp,%rbp
  80117e:	48 83 ec 20          	sub    $0x20,%rsp
  801182:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801186:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118e:	48 89 c7             	mov    %rax,%rdi
  801191:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  801198:	00 00 00 
  80119b:	ff d0                	callq  *%rax
  80119d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a3:	48 98                	cltq   
  8011a5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8011a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ad:	48 89 d6             	mov    %rdx,%rsi
  8011b0:	48 89 c7             	mov    %rax,%rdi
  8011b3:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8011ba:	00 00 00 
  8011bd:	ff d0                	callq  *%rax
	return dst;
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011c3:	c9                   	leaveq 
  8011c4:	c3                   	retq   

00000000008011c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011c5:	55                   	push   %rbp
  8011c6:	48 89 e5             	mov    %rsp,%rbp
  8011c9:	48 83 ec 28          	sub    $0x28,%rsp
  8011cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011e1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011e8:	00 
  8011e9:	eb 27                	jmp    801212 <strncpy+0x4d>
		*dst++ = *src;
  8011eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ef:	0f b6 10             	movzbl (%rax),%edx
  8011f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f6:	88 10                	mov    %dl,(%rax)
  8011f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	84 c0                	test   %al,%al
  801206:	74 05                	je     80120d <strncpy+0x48>
			src++;
  801208:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80120d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80121a:	72 cf                	jb     8011eb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80121c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801220:	c9                   	leaveq 
  801221:	c3                   	retq   

0000000000801222 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801222:	55                   	push   %rbp
  801223:	48 89 e5             	mov    %rsp,%rbp
  801226:	48 83 ec 28          	sub    $0x28,%rsp
  80122a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801232:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80123e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801243:	74 37                	je     80127c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801245:	eb 17                	jmp    80125e <strlcpy+0x3c>
			*dst++ = *src++;
  801247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124b:	0f b6 10             	movzbl (%rax),%edx
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	88 10                	mov    %dl,(%rax)
  801254:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801259:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80125e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801263:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801268:	74 0b                	je     801275 <strlcpy+0x53>
  80126a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126e:	0f b6 00             	movzbl (%rax),%eax
  801271:	84 c0                	test   %al,%al
  801273:	75 d2                	jne    801247 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801279:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80127c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	48 89 d1             	mov    %rdx,%rcx
  801287:	48 29 c1             	sub    %rax,%rcx
  80128a:	48 89 c8             	mov    %rcx,%rax
}
  80128d:	c9                   	leaveq 
  80128e:	c3                   	retq   

000000000080128f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80128f:	55                   	push   %rbp
  801290:	48 89 e5             	mov    %rsp,%rbp
  801293:	48 83 ec 10          	sub    $0x10,%rsp
  801297:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80129f:	eb 0a                	jmp    8012ab <strcmp+0x1c>
		p++, q++;
  8012a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	0f b6 00             	movzbl (%rax),%eax
  8012b2:	84 c0                	test   %al,%al
  8012b4:	74 12                	je     8012c8 <strcmp+0x39>
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	0f b6 10             	movzbl (%rax),%edx
  8012bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	38 c2                	cmp    %al,%dl
  8012c6:	74 d9                	je     8012a1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cc:	0f b6 00             	movzbl (%rax),%eax
  8012cf:	0f b6 d0             	movzbl %al,%edx
  8012d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	0f b6 c0             	movzbl %al,%eax
  8012dc:	89 d1                	mov    %edx,%ecx
  8012de:	29 c1                	sub    %eax,%ecx
  8012e0:	89 c8                	mov    %ecx,%eax
}
  8012e2:	c9                   	leaveq 
  8012e3:	c3                   	retq   

00000000008012e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012e4:	55                   	push   %rbp
  8012e5:	48 89 e5             	mov    %rsp,%rbp
  8012e8:	48 83 ec 18          	sub    $0x18,%rsp
  8012ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012f8:	eb 0f                	jmp    801309 <strncmp+0x25>
		n--, p++, q++;
  8012fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801304:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801309:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80130e:	74 1d                	je     80132d <strncmp+0x49>
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	0f b6 00             	movzbl (%rax),%eax
  801317:	84 c0                	test   %al,%al
  801319:	74 12                	je     80132d <strncmp+0x49>
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	0f b6 10             	movzbl (%rax),%edx
  801322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801326:	0f b6 00             	movzbl (%rax),%eax
  801329:	38 c2                	cmp    %al,%dl
  80132b:	74 cd                	je     8012fa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80132d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801332:	75 07                	jne    80133b <strncmp+0x57>
		return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
  801339:	eb 1a                	jmp    801355 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80133b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133f:	0f b6 00             	movzbl (%rax),%eax
  801342:	0f b6 d0             	movzbl %al,%edx
  801345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801349:	0f b6 00             	movzbl (%rax),%eax
  80134c:	0f b6 c0             	movzbl %al,%eax
  80134f:	89 d1                	mov    %edx,%ecx
  801351:	29 c1                	sub    %eax,%ecx
  801353:	89 c8                	mov    %ecx,%eax
}
  801355:	c9                   	leaveq 
  801356:	c3                   	retq   

0000000000801357 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	48 83 ec 10          	sub    $0x10,%rsp
  80135f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801363:	89 f0                	mov    %esi,%eax
  801365:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801368:	eb 17                	jmp    801381 <strchr+0x2a>
		if (*s == c)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	0f b6 00             	movzbl (%rax),%eax
  801371:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801374:	75 06                	jne    80137c <strchr+0x25>
			return (char *) s;
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	eb 15                	jmp    801391 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80137c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	84 c0                	test   %al,%al
  80138a:	75 de                	jne    80136a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801391:	c9                   	leaveq 
  801392:	c3                   	retq   

0000000000801393 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	48 83 ec 10          	sub    $0x10,%rsp
  80139b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013a4:	eb 11                	jmp    8013b7 <strfind+0x24>
		if (*s == c)
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013b0:	74 12                	je     8013c4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	0f b6 00             	movzbl (%rax),%eax
  8013be:	84 c0                	test   %al,%al
  8013c0:	75 e4                	jne    8013a6 <strfind+0x13>
  8013c2:	eb 01                	jmp    8013c5 <strfind+0x32>
		if (*s == c)
			break;
  8013c4:	90                   	nop
	return (char *) s;
  8013c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c9:	c9                   	leaveq 
  8013ca:	c3                   	retq   

00000000008013cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	48 83 ec 18          	sub    $0x18,%rsp
  8013d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013e3:	75 06                	jne    8013eb <memset+0x20>
		return v;
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	eb 69                	jmp    801454 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ef:	83 e0 03             	and    $0x3,%eax
  8013f2:	48 85 c0             	test   %rax,%rax
  8013f5:	75 48                	jne    80143f <memset+0x74>
  8013f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fb:	83 e0 03             	and    $0x3,%eax
  8013fe:	48 85 c0             	test   %rax,%rax
  801401:	75 3c                	jne    80143f <memset+0x74>
		c &= 0xFF;
  801403:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80140a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80140d:	89 c2                	mov    %eax,%edx
  80140f:	c1 e2 18             	shl    $0x18,%edx
  801412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801415:	c1 e0 10             	shl    $0x10,%eax
  801418:	09 c2                	or     %eax,%edx
  80141a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141d:	c1 e0 08             	shl    $0x8,%eax
  801420:	09 d0                	or     %edx,%eax
  801422:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801429:	48 89 c1             	mov    %rax,%rcx
  80142c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801430:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801434:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801437:	48 89 d7             	mov    %rdx,%rdi
  80143a:	fc                   	cld    
  80143b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80143d:	eb 11                	jmp    801450 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80143f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801443:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801446:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80144a:	48 89 d7             	mov    %rdx,%rdi
  80144d:	fc                   	cld    
  80144e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801454:	c9                   	leaveq 
  801455:	c3                   	retq   

0000000000801456 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801456:	55                   	push   %rbp
  801457:	48 89 e5             	mov    %rsp,%rbp
  80145a:	48 83 ec 28          	sub    $0x28,%rsp
  80145e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801462:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801466:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80146a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80146e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801482:	0f 83 88 00 00 00    	jae    801510 <memmove+0xba>
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801490:	48 01 d0             	add    %rdx,%rax
  801493:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801497:	76 77                	jbe    801510 <memmove+0xba>
		s += n;
  801499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ad:	83 e0 03             	and    $0x3,%eax
  8014b0:	48 85 c0             	test   %rax,%rax
  8014b3:	75 3b                	jne    8014f0 <memmove+0x9a>
  8014b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b9:	83 e0 03             	and    $0x3,%eax
  8014bc:	48 85 c0             	test   %rax,%rax
  8014bf:	75 2f                	jne    8014f0 <memmove+0x9a>
  8014c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c5:	83 e0 03             	and    $0x3,%eax
  8014c8:	48 85 c0             	test   %rax,%rax
  8014cb:	75 23                	jne    8014f0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	48 83 e8 04          	sub    $0x4,%rax
  8014d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d9:	48 83 ea 04          	sub    $0x4,%rdx
  8014dd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014e1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014e5:	48 89 c7             	mov    %rax,%rdi
  8014e8:	48 89 d6             	mov    %rdx,%rsi
  8014eb:	fd                   	std    
  8014ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ee:	eb 1d                	jmp    80150d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 89 d7             	mov    %rdx,%rdi
  801507:	48 89 c1             	mov    %rax,%rcx
  80150a:	fd                   	std    
  80150b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80150d:	fc                   	cld    
  80150e:	eb 57                	jmp    801567 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801514:	83 e0 03             	and    $0x3,%eax
  801517:	48 85 c0             	test   %rax,%rax
  80151a:	75 36                	jne    801552 <memmove+0xfc>
  80151c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801520:	83 e0 03             	and    $0x3,%eax
  801523:	48 85 c0             	test   %rax,%rax
  801526:	75 2a                	jne    801552 <memmove+0xfc>
  801528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152c:	83 e0 03             	and    $0x3,%eax
  80152f:	48 85 c0             	test   %rax,%rax
  801532:	75 1e                	jne    801552 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801538:	48 89 c1             	mov    %rax,%rcx
  80153b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80153f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801543:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801547:	48 89 c7             	mov    %rax,%rdi
  80154a:	48 89 d6             	mov    %rdx,%rsi
  80154d:	fc                   	cld    
  80154e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801550:	eb 15                	jmp    801567 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801556:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80155e:	48 89 c7             	mov    %rax,%rdi
  801561:	48 89 d6             	mov    %rdx,%rsi
  801564:	fc                   	cld    
  801565:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 18          	sub    $0x18,%rsp
  801575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801579:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80157d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801581:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801585:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	48 89 ce             	mov    %rcx,%rsi
  801590:	48 89 c7             	mov    %rax,%rdi
  801593:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  80159a:	00 00 00 
  80159d:	ff d0                	callq  *%rax
}
  80159f:	c9                   	leaveq 
  8015a0:	c3                   	retq   

00000000008015a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015a1:	55                   	push   %rbp
  8015a2:	48 89 e5             	mov    %rsp,%rbp
  8015a5:	48 83 ec 28          	sub    $0x28,%rsp
  8015a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015c5:	eb 38                	jmp    8015ff <memcmp+0x5e>
		if (*s1 != *s2)
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 10             	movzbl (%rax),%edx
  8015ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	38 c2                	cmp    %al,%dl
  8015d7:	74 1c                	je     8015f5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	0f b6 d0             	movzbl %al,%edx
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	0f b6 c0             	movzbl %al,%eax
  8015ed:	89 d1                	mov    %edx,%ecx
  8015ef:	29 c1                	sub    %eax,%ecx
  8015f1:	89 c8                	mov    %ecx,%eax
  8015f3:	eb 20                	jmp    801615 <memcmp+0x74>
		s1++, s2++;
  8015f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801604:	0f 95 c0             	setne  %al
  801607:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80160c:	84 c0                	test   %al,%al
  80160e:	75 b7                	jne    8015c7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801615:	c9                   	leaveq 
  801616:	c3                   	retq   

0000000000801617 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801617:	55                   	push   %rbp
  801618:	48 89 e5             	mov    %rsp,%rbp
  80161b:	48 83 ec 28          	sub    $0x28,%rsp
  80161f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801623:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801626:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801632:	48 01 d0             	add    %rdx,%rax
  801635:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801639:	eb 13                	jmp    80164e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80163b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163f:	0f b6 10             	movzbl (%rax),%edx
  801642:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801645:	38 c2                	cmp    %al,%dl
  801647:	74 11                	je     80165a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801649:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801652:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801656:	72 e3                	jb     80163b <memfind+0x24>
  801658:	eb 01                	jmp    80165b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80165a:	90                   	nop
	return (void *) s;
  80165b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80165f:	c9                   	leaveq 
  801660:	c3                   	retq   

0000000000801661 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801661:	55                   	push   %rbp
  801662:	48 89 e5             	mov    %rsp,%rbp
  801665:	48 83 ec 38          	sub    $0x38,%rsp
  801669:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80166d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801671:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801674:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80167b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801682:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801683:	eb 05                	jmp    80168a <strtol+0x29>
		s++;
  801685:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	3c 20                	cmp    $0x20,%al
  801693:	74 f0                	je     801685 <strtol+0x24>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 09                	cmp    $0x9,%al
  80169e:	74 e5                	je     801685 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 2b                	cmp    $0x2b,%al
  8016a9:	75 07                	jne    8016b2 <strtol+0x51>
		s++;
  8016ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b0:	eb 17                	jmp    8016c9 <strtol+0x68>
	else if (*s == '-')
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	3c 2d                	cmp    $0x2d,%al
  8016bb:	75 0c                	jne    8016c9 <strtol+0x68>
		s++, neg = 1;
  8016bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cd:	74 06                	je     8016d5 <strtol+0x74>
  8016cf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016d3:	75 28                	jne    8016fd <strtol+0x9c>
  8016d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	3c 30                	cmp    $0x30,%al
  8016de:	75 1d                	jne    8016fd <strtol+0x9c>
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	48 83 c0 01          	add    $0x1,%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 78                	cmp    $0x78,%al
  8016ed:	75 0e                	jne    8016fd <strtol+0x9c>
		s += 2, base = 16;
  8016ef:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016f4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016fb:	eb 2c                	jmp    801729 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801701:	75 19                	jne    80171c <strtol+0xbb>
  801703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801707:	0f b6 00             	movzbl (%rax),%eax
  80170a:	3c 30                	cmp    $0x30,%al
  80170c:	75 0e                	jne    80171c <strtol+0xbb>
		s++, base = 8;
  80170e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801713:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80171a:	eb 0d                	jmp    801729 <strtol+0xc8>
	else if (base == 0)
  80171c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801720:	75 07                	jne    801729 <strtol+0xc8>
		base = 10;
  801722:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	3c 2f                	cmp    $0x2f,%al
  801732:	7e 1d                	jle    801751 <strtol+0xf0>
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 39                	cmp    $0x39,%al
  80173d:	7f 12                	jg     801751 <strtol+0xf0>
			dig = *s - '0';
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	0f be c0             	movsbl %al,%eax
  801749:	83 e8 30             	sub    $0x30,%eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80174f:	eb 4e                	jmp    80179f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801755:	0f b6 00             	movzbl (%rax),%eax
  801758:	3c 60                	cmp    $0x60,%al
  80175a:	7e 1d                	jle    801779 <strtol+0x118>
  80175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801760:	0f b6 00             	movzbl (%rax),%eax
  801763:	3c 7a                	cmp    $0x7a,%al
  801765:	7f 12                	jg     801779 <strtol+0x118>
			dig = *s - 'a' + 10;
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	0f be c0             	movsbl %al,%eax
  801771:	83 e8 57             	sub    $0x57,%eax
  801774:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801777:	eb 26                	jmp    80179f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	3c 40                	cmp    $0x40,%al
  801782:	7e 47                	jle    8017cb <strtol+0x16a>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 5a                	cmp    $0x5a,%al
  80178d:	7f 3c                	jg     8017cb <strtol+0x16a>
			dig = *s - 'A' + 10;
  80178f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 37             	sub    $0x37,%eax
  80179c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80179f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017a5:	7d 23                	jge    8017ca <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8017a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ac:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017af:	48 98                	cltq   
  8017b1:	48 89 c2             	mov    %rax,%rdx
  8017b4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8017b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017bc:	48 98                	cltq   
  8017be:	48 01 d0             	add    %rdx,%rax
  8017c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017c5:	e9 5f ff ff ff       	jmpq   801729 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017d0:	74 0b                	je     8017dd <strtol+0x17c>
		*endptr = (char *) s;
  8017d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e1:	74 09                	je     8017ec <strtol+0x18b>
  8017e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e7:	48 f7 d8             	neg    %rax
  8017ea:	eb 04                	jmp    8017f0 <strtol+0x18f>
  8017ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 30          	sub    $0x30,%rsp
  8017fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801802:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	88 45 ff             	mov    %al,-0x1(%rbp)
  80180c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801811:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801815:	75 06                	jne    80181d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	eb 68                	jmp    801885 <strstr+0x93>

	len = strlen(str);
  80181d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801821:	48 89 c7             	mov    %rax,%rdi
  801824:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
  801830:	48 98                	cltq   
  801832:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801840:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801845:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801849:	75 07                	jne    801852 <strstr+0x60>
				return (char *) 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	eb 33                	jmp    801885 <strstr+0x93>
		} while (sc != c);
  801852:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801856:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801859:	75 db                	jne    801836 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80185b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	48 89 ce             	mov    %rcx,%rsi
  80186a:	48 89 c7             	mov    %rax,%rdi
  80186d:	48 b8 e4 12 80 00 00 	movabs $0x8012e4,%rax
  801874:	00 00 00 
  801877:	ff d0                	callq  *%rax
  801879:	85 c0                	test   %eax,%eax
  80187b:	75 b9                	jne    801836 <strstr+0x44>

	return (char *) (in - 1);
  80187d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801881:	48 83 e8 01          	sub    $0x1,%rax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   
	...

0000000000801888 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	53                   	push   %rbx
  80188d:	48 83 ec 58          	sub    $0x58,%rsp
  801891:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801894:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801897:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80189b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80189f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018a3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018aa:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8018ad:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018b1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018b5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018b9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018bd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018c1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8018c4:	4c 89 c3             	mov    %r8,%rbx
  8018c7:	cd 30                	int    $0x30
  8018c9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8018cd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8018d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018d9:	74 3e                	je     801919 <syscall+0x91>
  8018db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018e0:	7e 37                	jle    801919 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e9:	49 89 d0             	mov    %rdx,%r8
  8018ec:	89 c1                	mov    %eax,%ecx
  8018ee:	48 ba 28 4f 80 00 00 	movabs $0x804f28,%rdx
  8018f5:	00 00 00 
  8018f8:	be 23 00 00 00       	mov    $0x23,%esi
  8018fd:	48 bf 45 4f 80 00 00 	movabs $0x804f45,%rdi
  801904:	00 00 00 
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	49 b9 28 03 80 00 00 	movabs $0x800328,%r9
  801913:	00 00 00 
  801916:	41 ff d1             	callq  *%r9

	return ret;
  801919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191d:	48 83 c4 58          	add    $0x58,%rsp
  801921:	5b                   	pop    %rbx
  801922:	5d                   	pop    %rbp
  801923:	c3                   	retq   

0000000000801924 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 20          	sub    $0x20,%rsp
  80192c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801930:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801943:	00 
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	48 89 d1             	mov    %rdx,%rcx
  801953:	48 89 c2             	mov    %rax,%rdx
  801956:	be 00 00 00 00       	mov    $0x0,%esi
  80195b:	bf 00 00 00 00       	mov    $0x0,%edi
  801960:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801967:	00 00 00 
  80196a:	ff d0                	callq  *%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <sys_cgetc>:

int
sys_cgetc(void)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801976:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197d:	00 
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	be 00 00 00 00       	mov    $0x0,%esi
  801999:	bf 01 00 00 00       	mov    $0x1,%edi
  80199e:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 20          	sub    $0x20,%rsp
  8019b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ba:	48 98                	cltq   
  8019bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c3:	00 
  8019c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d5:	48 89 c2             	mov    %rax,%rdx
  8019d8:	be 01 00 00 00       	mov    $0x1,%esi
  8019dd:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e2:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ff:	00 
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	be 00 00 00 00       	mov    $0x0,%esi
  801a1b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a20:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_yield>:

void
sys_yield(void)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3d:	00 
  801a3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a54:	be 00 00 00 00       	mov    $0x0,%esi
  801a59:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a5e:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a81:	48 63 c8             	movslq %eax,%rcx
  801a84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8b:	48 98                	cltq   
  801a8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a94:	00 
  801a95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9b:	49 89 c8             	mov    %rcx,%r8
  801a9e:	48 89 d1             	mov    %rdx,%rcx
  801aa1:	48 89 c2             	mov    %rax,%rdx
  801aa4:	be 01 00 00 00       	mov    $0x1,%esi
  801aa9:	bf 04 00 00 00       	mov    $0x4,%edi
  801aae:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 30          	sub    $0x30,%rsp
  801ac4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ace:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ad6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad9:	48 63 c8             	movslq %eax,%rcx
  801adc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ae0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae3:	48 63 f0             	movslq %eax,%rsi
  801ae6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aed:	48 98                	cltq   
  801aef:	48 89 0c 24          	mov    %rcx,(%rsp)
  801af3:	49 89 f9             	mov    %rdi,%r9
  801af6:	49 89 f0             	mov    %rsi,%r8
  801af9:	48 89 d1             	mov    %rdx,%rcx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 01 00 00 00       	mov    $0x1,%esi
  801b04:	bf 05 00 00 00       	mov    $0x5,%edi
  801b09:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 20          	sub    $0x20,%rsp
  801b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b36:	00 
  801b37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b43:	48 89 d1             	mov    %rdx,%rcx
  801b46:	48 89 c2             	mov    %rax,%rdx
  801b49:	be 01 00 00 00       	mov    $0x1,%esi
  801b4e:	bf 06 00 00 00       	mov    $0x6,%edi
  801b53:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 20          	sub    $0x20,%rsp
  801b69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 d0             	movslq %eax,%rdx
  801b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b78:	48 98                	cltq   
  801b7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b81:	00 
  801b82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8e:	48 89 d1             	mov    %rdx,%rcx
  801b91:	48 89 c2             	mov    %rax,%rdx
  801b94:	be 01 00 00 00       	mov    $0x1,%esi
  801b99:	bf 08 00 00 00       	mov    $0x8,%edi
  801b9e:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801ba5:	00 00 00 
  801ba8:	ff d0                	callq  *%rax
}
  801baa:	c9                   	leaveq 
  801bab:	c3                   	retq   

0000000000801bac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bac:	55                   	push   %rbp
  801bad:	48 89 e5             	mov    %rsp,%rbp
  801bb0:	48 83 ec 20          	sub    $0x20,%rsp
  801bb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc2:	48 98                	cltq   
  801bc4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcb:	00 
  801bcc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd8:	48 89 d1             	mov    %rdx,%rcx
  801bdb:	48 89 c2             	mov    %rax,%rdx
  801bde:	be 01 00 00 00       	mov    $0x1,%esi
  801be3:	bf 09 00 00 00       	mov    $0x9,%edi
  801be8:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 20          	sub    $0x20,%rsp
  801bfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0c:	48 98                	cltq   
  801c0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c15:	00 
  801c16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c22:	48 89 d1             	mov    %rdx,%rcx
  801c25:	48 89 c2             	mov    %rax,%rdx
  801c28:	be 01 00 00 00       	mov    $0x1,%esi
  801c2d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c32:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
}
  801c3e:	c9                   	leaveq 
  801c3f:	c3                   	retq   

0000000000801c40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 30          	sub    $0x30,%rsp
  801c48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c53:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c56:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c59:	48 63 f0             	movslq %eax,%rsi
  801c5c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c63:	48 98                	cltq   
  801c65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c70:	00 
  801c71:	49 89 f1             	mov    %rsi,%r9
  801c74:	49 89 c8             	mov    %rcx,%r8
  801c77:	48 89 d1             	mov    %rdx,%rcx
  801c7a:	48 89 c2             	mov    %rax,%rdx
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c87:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 20          	sub    $0x20,%rsp
  801c9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cac:	00 
  801cad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cbe:	48 89 c2             	mov    %rax,%rdx
  801cc1:	be 01 00 00 00       	mov    $0x1,%esi
  801cc6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ccb:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
}
  801cd7:	c9                   	leaveq 
  801cd8:	c3                   	retq   

0000000000801cd9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ce1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce8:	00 
  801ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801cff:	be 00 00 00 00       	mov    $0x0,%esi
  801d04:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d09:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 30          	sub    $0x30,%rsp
  801d1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d26:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d29:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d2d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d31:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d34:	48 63 c8             	movslq %eax,%rcx
  801d37:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d3e:	48 63 f0             	movslq %eax,%rsi
  801d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d48:	48 98                	cltq   
  801d4a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d4e:	49 89 f9             	mov    %rdi,%r9
  801d51:	49 89 f0             	mov    %rsi,%r8
  801d54:	48 89 d1             	mov    %rdx,%rcx
  801d57:	48 89 c2             	mov    %rax,%rdx
  801d5a:	be 00 00 00 00       	mov    $0x0,%esi
  801d5f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d64:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d70:	c9                   	leaveq 
  801d71:	c3                   	retq   

0000000000801d72 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d72:	55                   	push   %rbp
  801d73:	48 89 e5             	mov    %rsp,%rbp
  801d76:	48 83 ec 20          	sub    $0x20,%rsp
  801d7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d91:	00 
  801d92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9e:	48 89 d1             	mov    %rdx,%rcx
  801da1:	48 89 c2             	mov    %rax,%rdx
  801da4:	be 00 00 00 00       	mov    $0x0,%esi
  801da9:	bf 10 00 00 00       	mov    $0x10,%edi
  801dae:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  801db5:	00 00 00 
  801db8:	ff d0                	callq  *%rax
}
  801dba:	c9                   	leaveq 
  801dbb:	c3                   	retq   

0000000000801dbc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dbc:	55                   	push   %rbp
  801dbd:	48 89 e5             	mov    %rsp,%rbp
  801dc0:	48 83 ec 08          	sub    $0x8,%rsp
  801dc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dc8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dcc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dd3:	ff ff ff 
  801dd6:	48 01 d0             	add    %rdx,%rax
  801dd9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 08          	sub    $0x8,%rsp
  801de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801def:	48 89 c7             	mov    %rax,%rdi
  801df2:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
  801dfe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e04:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e08:	c9                   	leaveq 
  801e09:	c3                   	retq   

0000000000801e0a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e0a:	55                   	push   %rbp
  801e0b:	48 89 e5             	mov    %rsp,%rbp
  801e0e:	48 83 ec 18          	sub    $0x18,%rsp
  801e12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e1d:	eb 6b                	jmp    801e8a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e22:	48 98                	cltq   
  801e24:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e2a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e36:	48 89 c2             	mov    %rax,%rdx
  801e39:	48 c1 ea 15          	shr    $0x15,%rdx
  801e3d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e44:	01 00 00 
  801e47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4b:	83 e0 01             	and    $0x1,%eax
  801e4e:	48 85 c0             	test   %rax,%rax
  801e51:	74 21                	je     801e74 <fd_alloc+0x6a>
  801e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e57:	48 89 c2             	mov    %rax,%rdx
  801e5a:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e5e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e65:	01 00 00 
  801e68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6c:	83 e0 01             	and    $0x1,%eax
  801e6f:	48 85 c0             	test   %rax,%rax
  801e72:	75 12                	jne    801e86 <fd_alloc+0x7c>
			*fd_store = fd;
  801e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	eb 1a                	jmp    801ea0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e8a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e8e:	7e 8f                	jle    801e1f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e94:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e9b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ea0:	c9                   	leaveq 
  801ea1:	c3                   	retq   

0000000000801ea2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ea2:	55                   	push   %rbp
  801ea3:	48 89 e5             	mov    %rsp,%rbp
  801ea6:	48 83 ec 20          	sub    $0x20,%rsp
  801eaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ead:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801eb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eb5:	78 06                	js     801ebd <fd_lookup+0x1b>
  801eb7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ebb:	7e 07                	jle    801ec4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ebd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec2:	eb 6c                	jmp    801f30 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ec7:	48 98                	cltq   
  801ec9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ecf:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edb:	48 89 c2             	mov    %rax,%rdx
  801ede:	48 c1 ea 15          	shr    $0x15,%rdx
  801ee2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee9:	01 00 00 
  801eec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef0:	83 e0 01             	and    $0x1,%eax
  801ef3:	48 85 c0             	test   %rax,%rax
  801ef6:	74 21                	je     801f19 <fd_lookup+0x77>
  801ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efc:	48 89 c2             	mov    %rax,%rdx
  801eff:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0a:	01 00 00 
  801f0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f11:	83 e0 01             	and    $0x1,%eax
  801f14:	48 85 c0             	test   %rax,%rax
  801f17:	75 07                	jne    801f20 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f1e:	eb 10                	jmp    801f30 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f28:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f30:	c9                   	leaveq 
  801f31:	c3                   	retq   

0000000000801f32 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f32:	55                   	push   %rbp
  801f33:	48 89 e5             	mov    %rsp,%rbp
  801f36:	48 83 ec 30          	sub    $0x30,%rsp
  801f3a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f3e:	89 f0                	mov    %esi,%eax
  801f40:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f47:	48 89 c7             	mov    %rax,%rdi
  801f4a:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
  801f56:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f5a:	48 89 d6             	mov    %rdx,%rsi
  801f5d:	89 c7                	mov    %eax,%edi
  801f5f:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
  801f6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f72:	78 0a                	js     801f7e <fd_close+0x4c>
	    || fd != fd2)
  801f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f78:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f7c:	74 12                	je     801f90 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f7e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f82:	74 05                	je     801f89 <fd_close+0x57>
  801f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f87:	eb 05                	jmp    801f8e <fd_close+0x5c>
  801f89:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8e:	eb 69                	jmp    801ff9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f94:	8b 00                	mov    (%rax),%eax
  801f96:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f9a:	48 89 d6             	mov    %rdx,%rsi
  801f9d:	89 c7                	mov    %eax,%edi
  801f9f:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
  801fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb2:	78 2a                	js     801fde <fd_close+0xac>
		if (dev->dev_close)
  801fb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fbc:	48 85 c0             	test   %rax,%rax
  801fbf:	74 16                	je     801fd7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcd:	48 89 c7             	mov    %rax,%rdi
  801fd0:	ff d2                	callq  *%rdx
  801fd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd5:	eb 07                	jmp    801fde <fd_close+0xac>
		else
			r = 0;
  801fd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe2:	48 89 c6             	mov    %rax,%rsi
  801fe5:	bf 00 00 00 00       	mov    $0x0,%edi
  801fea:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	callq  *%rax
	return r;
  801ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ff9:	c9                   	leaveq 
  801ffa:	c3                   	retq   

0000000000801ffb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ffb:	55                   	push   %rbp
  801ffc:	48 89 e5             	mov    %rsp,%rbp
  801fff:	48 83 ec 20          	sub    $0x20,%rsp
  802003:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802006:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80200a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802011:	eb 41                	jmp    802054 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802013:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80201a:	00 00 00 
  80201d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802020:	48 63 d2             	movslq %edx,%rdx
  802023:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802027:	8b 00                	mov    (%rax),%eax
  802029:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80202c:	75 22                	jne    802050 <dev_lookup+0x55>
			*dev = devtab[i];
  80202e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802035:	00 00 00 
  802038:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203b:	48 63 d2             	movslq %edx,%rdx
  80203e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802042:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802046:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	eb 60                	jmp    8020b0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802050:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802054:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80205b:	00 00 00 
  80205e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802061:	48 63 d2             	movslq %edx,%rdx
  802064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802068:	48 85 c0             	test   %rax,%rax
  80206b:	75 a6                	jne    802013 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80206d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802074:	00 00 00 
  802077:	48 8b 00             	mov    (%rax),%rax
  80207a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802080:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802083:	89 c6                	mov    %eax,%esi
  802085:	48 bf 58 4f 80 00 00 	movabs $0x804f58,%rdi
  80208c:	00 00 00 
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	48 b9 63 05 80 00 00 	movabs $0x800563,%rcx
  80209b:	00 00 00 
  80209e:	ff d1                	callq  *%rcx
	*dev = 0;
  8020a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020b0:	c9                   	leaveq 
  8020b1:	c3                   	retq   

00000000008020b2 <close>:

int
close(int fdnum)
{
  8020b2:	55                   	push   %rbp
  8020b3:	48 89 e5             	mov    %rsp,%rbp
  8020b6:	48 83 ec 20          	sub    $0x20,%rsp
  8020ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c4:	48 89 d6             	mov    %rdx,%rsi
  8020c7:	89 c7                	mov    %eax,%edi
  8020c9:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020dc:	79 05                	jns    8020e3 <close+0x31>
		return r;
  8020de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e1:	eb 18                	jmp    8020fb <close+0x49>
	else
		return fd_close(fd, 1);
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	be 01 00 00 00       	mov    $0x1,%esi
  8020ec:	48 89 c7             	mov    %rax,%rdi
  8020ef:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  8020f6:	00 00 00 
  8020f9:	ff d0                	callq  *%rax
}
  8020fb:	c9                   	leaveq 
  8020fc:	c3                   	retq   

00000000008020fd <close_all>:

void
close_all(void)
{
  8020fd:	55                   	push   %rbp
  8020fe:	48 89 e5             	mov    %rsp,%rbp
  802101:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802105:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80210c:	eb 15                	jmp    802123 <close_all+0x26>
		close(i);
  80210e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802111:	89 c7                	mov    %eax,%edi
  802113:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80211f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802123:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802127:	7e e5                	jle    80210e <close_all+0x11>
		close(i);
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 40          	sub    $0x40,%rsp
  802133:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802136:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802139:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80213d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802140:	48 89 d6             	mov    %rdx,%rsi
  802143:	89 c7                	mov    %eax,%edi
  802145:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax
  802151:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802154:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802158:	79 08                	jns    802162 <dup+0x37>
		return r;
  80215a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215d:	e9 70 01 00 00       	jmpq   8022d2 <dup+0x1a7>
	close(newfdnum);
  802162:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802165:	89 c7                	mov    %eax,%edi
  802167:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802173:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802176:	48 98                	cltq   
  802178:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80217e:	48 c1 e0 0c          	shl    $0xc,%rax
  802182:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802186:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218a:	48 89 c7             	mov    %rax,%rdi
  80218d:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  802194:	00 00 00 
  802197:	ff d0                	callq  *%rax
  802199:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80219d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a1:	48 89 c7             	mov    %rax,%rdi
  8021a4:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8021ab:	00 00 00 
  8021ae:	ff d0                	callq  *%rax
  8021b0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b8:	48 89 c2             	mov    %rax,%rdx
  8021bb:	48 c1 ea 15          	shr    $0x15,%rdx
  8021bf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021c6:	01 00 00 
  8021c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cd:	83 e0 01             	and    $0x1,%eax
  8021d0:	84 c0                	test   %al,%al
  8021d2:	74 71                	je     802245 <dup+0x11a>
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 89 c2             	mov    %rax,%rdx
  8021db:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e6:	01 00 00 
  8021e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ed:	83 e0 01             	and    $0x1,%eax
  8021f0:	84 c0                	test   %al,%al
  8021f2:	74 51                	je     802245 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	48 89 c2             	mov    %rax,%rdx
  8021fb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802206:	01 00 00 
  802209:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220d:	89 c1                	mov    %eax,%ecx
  80220f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802215:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221d:	41 89 c8             	mov    %ecx,%r8d
  802220:	48 89 d1             	mov    %rdx,%rcx
  802223:	ba 00 00 00 00       	mov    $0x0,%edx
  802228:	48 89 c6             	mov    %rax,%rsi
  80222b:	bf 00 00 00 00       	mov    $0x0,%edi
  802230:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
  80223c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802243:	78 56                	js     80229b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802249:	48 89 c2             	mov    %rax,%rdx
  80224c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802250:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802257:	01 00 00 
  80225a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225e:	89 c1                	mov    %eax,%ecx
  802260:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802266:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80226e:	41 89 c8             	mov    %ecx,%r8d
  802271:	48 89 d1             	mov    %rdx,%rcx
  802274:	ba 00 00 00 00       	mov    $0x0,%edx
  802279:	48 89 c6             	mov    %rax,%rsi
  80227c:	bf 00 00 00 00       	mov    $0x0,%edi
  802281:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802294:	78 08                	js     80229e <dup+0x173>
		goto err;

	return newfdnum;
  802296:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802299:	eb 37                	jmp    8022d2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80229b:	90                   	nop
  80229c:	eb 01                	jmp    80229f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80229e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a3:	48 89 c6             	mov    %rax,%rsi
  8022a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ab:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022bb:	48 89 c6             	mov    %rax,%rsi
  8022be:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c3:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
	return r;
  8022cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022d2:	c9                   	leaveq 
  8022d3:	c3                   	retq   

00000000008022d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022d4:	55                   	push   %rbp
  8022d5:	48 89 e5             	mov    %rsp,%rbp
  8022d8:	48 83 ec 40          	sub    $0x40,%rsp
  8022dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ee:	48 89 d6             	mov    %rdx,%rsi
  8022f1:	89 c7                	mov    %eax,%edi
  8022f3:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	callq  *%rax
  8022ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802302:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802306:	78 24                	js     80232c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230c:	8b 00                	mov    (%rax),%eax
  80230e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802312:	48 89 d6             	mov    %rdx,%rsi
  802315:	89 c7                	mov    %eax,%edi
  802317:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
  802323:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802326:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232a:	79 05                	jns    802331 <read+0x5d>
		return r;
  80232c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232f:	eb 7a                	jmp    8023ab <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802335:	8b 40 08             	mov    0x8(%rax),%eax
  802338:	83 e0 03             	and    $0x3,%eax
  80233b:	83 f8 01             	cmp    $0x1,%eax
  80233e:	75 3a                	jne    80237a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802340:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802347:	00 00 00 
  80234a:	48 8b 00             	mov    (%rax),%rax
  80234d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802353:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802356:	89 c6                	mov    %eax,%esi
  802358:	48 bf 77 4f 80 00 00 	movabs $0x804f77,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	48 b9 63 05 80 00 00 	movabs $0x800563,%rcx
  80236e:	00 00 00 
  802371:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802378:	eb 31                	jmp    8023ab <read+0xd7>
	}
	if (!dev->dev_read)
  80237a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802382:	48 85 c0             	test   %rax,%rax
  802385:	75 07                	jne    80238e <read+0xba>
		return -E_NOT_SUPP;
  802387:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80238c:	eb 1d                	jmp    8023ab <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80238e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802392:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80239e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023a2:	48 89 ce             	mov    %rcx,%rsi
  8023a5:	48 89 c7             	mov    %rax,%rdi
  8023a8:	41 ff d0             	callq  *%r8
}
  8023ab:	c9                   	leaveq 
  8023ac:	c3                   	retq   

00000000008023ad <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023ad:	55                   	push   %rbp
  8023ae:	48 89 e5             	mov    %rsp,%rbp
  8023b1:	48 83 ec 30          	sub    $0x30,%rsp
  8023b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c7:	eb 46                	jmp    80240f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cc:	48 98                	cltq   
  8023ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d2:	48 29 c2             	sub    %rax,%rdx
  8023d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d8:	48 98                	cltq   
  8023da:	48 89 c1             	mov    %rax,%rcx
  8023dd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8023e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e4:	48 89 ce             	mov    %rcx,%rsi
  8023e7:	89 c7                	mov    %eax,%edi
  8023e9:	48 b8 d4 22 80 00 00 	movabs $0x8022d4,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023fc:	79 05                	jns    802403 <readn+0x56>
			return m;
  8023fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802401:	eb 1d                	jmp    802420 <readn+0x73>
		if (m == 0)
  802403:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802407:	74 13                	je     80241c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802409:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80240f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802412:	48 98                	cltq   
  802414:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802418:	72 af                	jb     8023c9 <readn+0x1c>
  80241a:	eb 01                	jmp    80241d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80241c:	90                   	nop
	}
	return tot;
  80241d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802420:	c9                   	leaveq 
  802421:	c3                   	retq   

0000000000802422 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802422:	55                   	push   %rbp
  802423:	48 89 e5             	mov    %rsp,%rbp
  802426:	48 83 ec 40          	sub    $0x40,%rsp
  80242a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80242d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802431:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802435:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802439:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243c:	48 89 d6             	mov    %rdx,%rsi
  80243f:	89 c7                	mov    %eax,%edi
  802441:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802450:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802454:	78 24                	js     80247a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245a:	8b 00                	mov    (%rax),%eax
  80245c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802460:	48 89 d6             	mov    %rdx,%rsi
  802463:	89 c7                	mov    %eax,%edi
  802465:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	callq  *%rax
  802471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802478:	79 05                	jns    80247f <write+0x5d>
		return r;
  80247a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247d:	eb 79                	jmp    8024f8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80247f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802483:	8b 40 08             	mov    0x8(%rax),%eax
  802486:	83 e0 03             	and    $0x3,%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	75 3a                	jne    8024c7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80248d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802494:	00 00 00 
  802497:	48 8b 00             	mov    (%rax),%rax
  80249a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a3:	89 c6                	mov    %eax,%esi
  8024a5:	48 bf 93 4f 80 00 00 	movabs $0x804f93,%rdi
  8024ac:	00 00 00 
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	48 b9 63 05 80 00 00 	movabs $0x800563,%rcx
  8024bb:	00 00 00 
  8024be:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c5:	eb 31                	jmp    8024f8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024cf:	48 85 c0             	test   %rax,%rax
  8024d2:	75 07                	jne    8024db <write+0xb9>
		return -E_NOT_SUPP;
  8024d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d9:	eb 1d                	jmp    8024f8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8024db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024df:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8024e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024eb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024ef:	48 89 ce             	mov    %rcx,%rsi
  8024f2:	48 89 c7             	mov    %rax,%rdi
  8024f5:	41 ff d0             	callq  *%r8
}
  8024f8:	c9                   	leaveq 
  8024f9:	c3                   	retq   

00000000008024fa <seek>:

int
seek(int fdnum, off_t offset)
{
  8024fa:	55                   	push   %rbp
  8024fb:	48 89 e5             	mov    %rsp,%rbp
  8024fe:	48 83 ec 18          	sub    $0x18,%rsp
  802502:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802505:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802508:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80250c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250f:	48 89 d6             	mov    %rdx,%rsi
  802512:	89 c7                	mov    %eax,%edi
  802514:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax
  802520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802527:	79 05                	jns    80252e <seek+0x34>
		return r;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252c:	eb 0f                	jmp    80253d <seek+0x43>
	fd->fd_offset = offset;
  80252e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802532:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802535:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 30          	sub    $0x30,%rsp
  802547:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802551:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802554:	48 89 d6             	mov    %rdx,%rsi
  802557:	89 c7                	mov    %eax,%edi
  802559:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  802560:	00 00 00 
  802563:	ff d0                	callq  *%rax
  802565:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256c:	78 24                	js     802592 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802572:	8b 00                	mov    (%rax),%eax
  802574:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802578:	48 89 d6             	mov    %rdx,%rsi
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
  802589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802590:	79 05                	jns    802597 <ftruncate+0x58>
		return r;
  802592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802595:	eb 72                	jmp    802609 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259b:	8b 40 08             	mov    0x8(%rax),%eax
  80259e:	83 e0 03             	and    $0x3,%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	75 3a                	jne    8025df <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025ac:	00 00 00 
  8025af:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025bb:	89 c6                	mov    %eax,%esi
  8025bd:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  8025c4:	00 00 00 
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	48 b9 63 05 80 00 00 	movabs $0x800563,%rcx
  8025d3:	00 00 00 
  8025d6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025dd:	eb 2a                	jmp    802609 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e7:	48 85 c0             	test   %rax,%rax
  8025ea:	75 07                	jne    8025f3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025ec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f1:	eb 16                	jmp    802609 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ff:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802602:	89 d6                	mov    %edx,%esi
  802604:	48 89 c7             	mov    %rax,%rdi
  802607:	ff d1                	callq  *%rcx
}
  802609:	c9                   	leaveq 
  80260a:	c3                   	retq   

000000000080260b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80260b:	55                   	push   %rbp
  80260c:	48 89 e5             	mov    %rsp,%rbp
  80260f:	48 83 ec 30          	sub    $0x30,%rsp
  802613:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802616:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80261e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802621:	48 89 d6             	mov    %rdx,%rsi
  802624:	89 c7                	mov    %eax,%edi
  802626:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
  802632:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802639:	78 24                	js     80265f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263f:	8b 00                	mov    (%rax),%eax
  802641:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802645:	48 89 d6             	mov    %rdx,%rsi
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 fb 1f 80 00 00 	movabs $0x801ffb,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265d:	79 05                	jns    802664 <fstat+0x59>
		return r;
  80265f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802662:	eb 5e                	jmp    8026c2 <fstat+0xb7>
	if (!dev->dev_stat)
  802664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802668:	48 8b 40 28          	mov    0x28(%rax),%rax
  80266c:	48 85 c0             	test   %rax,%rax
  80266f:	75 07                	jne    802678 <fstat+0x6d>
		return -E_NOT_SUPP;
  802671:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802676:	eb 4a                	jmp    8026c2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80267f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802683:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80268a:	00 00 00 
	stat->st_isdir = 0;
  80268d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802691:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802698:	00 00 00 
	stat->st_dev = dev;
  80269b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ae:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026ba:	48 89 d6             	mov    %rdx,%rsi
  8026bd:	48 89 c7             	mov    %rax,%rdi
  8026c0:	ff d1                	callq  *%rcx
}
  8026c2:	c9                   	leaveq 
  8026c3:	c3                   	retq   

00000000008026c4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026c4:	55                   	push   %rbp
  8026c5:	48 89 e5             	mov    %rsp,%rbp
  8026c8:	48 83 ec 20          	sub    $0x20,%rsp
  8026cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d8:	be 00 00 00 00       	mov    $0x0,%esi
  8026dd:	48 89 c7             	mov    %rax,%rdi
  8026e0:	48 b8 b3 27 80 00 00 	movabs $0x8027b3,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f3:	79 05                	jns    8026fa <stat+0x36>
		return fd;
  8026f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f8:	eb 2f                	jmp    802729 <stat+0x65>
	r = fstat(fd, stat);
  8026fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802701:	48 89 d6             	mov    %rdx,%rsi
  802704:	89 c7                	mov    %eax,%edi
  802706:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
  802712:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802718:	89 c7                	mov    %eax,%edi
  80271a:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
	return r;
  802726:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802729:	c9                   	leaveq 
  80272a:	c3                   	retq   
	...

000000000080272c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80272c:	55                   	push   %rbp
  80272d:	48 89 e5             	mov    %rsp,%rbp
  802730:	48 83 ec 10          	sub    $0x10,%rsp
  802734:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802737:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80273b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802742:	00 00 00 
  802745:	8b 00                	mov    (%rax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	75 1d                	jne    802768 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80274b:	bf 01 00 00 00       	mov    $0x1,%edi
  802750:	48 b8 0a 48 80 00 00 	movabs $0x80480a,%rax
  802757:	00 00 00 
  80275a:	ff d0                	callq  *%rax
  80275c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802763:	00 00 00 
  802766:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802768:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80276f:	00 00 00 
  802772:	8b 00                	mov    (%rax),%eax
  802774:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802777:	b9 07 00 00 00       	mov    $0x7,%ecx
  80277c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802783:	00 00 00 
  802786:	89 c7                	mov    %eax,%edi
  802788:	48 b8 5b 47 80 00 00 	movabs $0x80475b,%rax
  80278f:	00 00 00 
  802792:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802798:	ba 00 00 00 00       	mov    $0x0,%edx
  80279d:	48 89 c6             	mov    %rax,%rsi
  8027a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a5:	48 b8 74 46 80 00 00 	movabs $0x804674,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	callq  *%rax
}
  8027b1:	c9                   	leaveq 
  8027b2:	c3                   	retq   

00000000008027b3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8027b3:	55                   	push   %rbp
  8027b4:	48 89 e5             	mov    %rsp,%rbp
  8027b7:	48 83 ec 20          	sub    $0x20,%rsp
  8027bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8027c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c6:	48 89 c7             	mov    %rax,%rdi
  8027c9:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  8027d0:	00 00 00 
  8027d3:	ff d0                	callq  *%rax
  8027d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027da:	7e 0a                	jle    8027e6 <open+0x33>
		return -E_BAD_PATH;
  8027dc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027e1:	e9 a5 00 00 00       	jmpq   80288b <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8027e6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027ea:	48 89 c7             	mov    %rax,%rdi
  8027ed:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
  8027f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8027fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802800:	79 08                	jns    80280a <open+0x57>
		return r;
  802802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802805:	e9 81 00 00 00       	jmpq   80288b <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80280a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802811:	00 00 00 
  802814:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802817:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80281d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802821:	48 89 c6             	mov    %rax,%rsi
  802824:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80282b:	00 00 00 
  80282e:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  802835:	00 00 00 
  802838:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80283a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283e:	48 89 c6             	mov    %rax,%rsi
  802841:	bf 01 00 00 00       	mov    $0x1,%edi
  802846:	48 b8 2c 27 80 00 00 	movabs $0x80272c,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
  802852:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802855:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802859:	79 1d                	jns    802878 <open+0xc5>
		fd_close(new_fd, 0);
  80285b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285f:	be 00 00 00 00       	mov    $0x0,%esi
  802864:	48 89 c7             	mov    %rax,%rdi
  802867:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  80286e:	00 00 00 
  802871:	ff d0                	callq  *%rax
		return r;	
  802873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802876:	eb 13                	jmp    80288b <open+0xd8>
	}
	return fd2num(new_fd);
  802878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287c:	48 89 c7             	mov    %rax,%rdi
  80287f:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
}
  80288b:	c9                   	leaveq 
  80288c:	c3                   	retq   

000000000080288d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80288d:	55                   	push   %rbp
  80288e:	48 89 e5             	mov    %rsp,%rbp
  802891:	48 83 ec 10          	sub    $0x10,%rsp
  802895:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289d:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028a7:	00 00 00 
  8028aa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028ac:	be 00 00 00 00       	mov    $0x0,%esi
  8028b1:	bf 06 00 00 00       	mov    $0x6,%edi
  8028b6:	48 b8 2c 27 80 00 00 	movabs $0x80272c,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
}
  8028c2:	c9                   	leaveq 
  8028c3:	c3                   	retq   

00000000008028c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028c4:	55                   	push   %rbp
  8028c5:	48 89 e5             	mov    %rsp,%rbp
  8028c8:	48 83 ec 30          	sub    $0x30,%rsp
  8028cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8028d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dc:	8b 50 0c             	mov    0xc(%rax),%edx
  8028df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028e6:	00 00 00 
  8028e9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028f2:	00 00 00 
  8028f5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8028fd:	be 00 00 00 00       	mov    $0x0,%esi
  802902:	bf 03 00 00 00       	mov    $0x3,%edi
  802907:	48 b8 2c 27 80 00 00 	movabs $0x80272c,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax
  802913:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291a:	7e 23                	jle    80293f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80291c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291f:	48 63 d0             	movslq %eax,%rdx
  802922:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802926:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80292d:	00 00 00 
  802930:	48 89 c7             	mov    %rax,%rdi
  802933:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80293f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802942:	c9                   	leaveq 
  802943:	c3                   	retq   

0000000000802944 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802944:	55                   	push   %rbp
  802945:	48 89 e5             	mov    %rsp,%rbp
  802948:	48 83 ec 20          	sub    $0x20,%rsp
  80294c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802950:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	8b 50 0c             	mov    0xc(%rax),%edx
  80295b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802962:	00 00 00 
  802965:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802967:	be 00 00 00 00       	mov    $0x0,%esi
  80296c:	bf 05 00 00 00       	mov    $0x5,%edi
  802971:	48 b8 2c 27 80 00 00 	movabs $0x80272c,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
  80297d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802984:	79 05                	jns    80298b <devfile_stat+0x47>
		return r;
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	eb 56                	jmp    8029e1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80298b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802996:	00 00 00 
  802999:	48 89 c7             	mov    %rax,%rdi
  80299c:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029a8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029af:	00 00 00 
  8029b2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029bc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029c2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029c9:	00 00 00 
  8029cc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e1:	c9                   	leaveq 
  8029e2:	c3                   	retq   
	...

00000000008029e4 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	53                   	push   %rbx
  8029e9:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  8029f0:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  8029f7:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8029fe:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802a05:	be 00 00 00 00       	mov    $0x0,%esi
  802a0a:	48 89 c7             	mov    %rax,%rdi
  802a0d:	48 b8 b3 27 80 00 00 	movabs $0x8027b3,%rax
  802a14:	00 00 00 
  802a17:	ff d0                	callq  *%rax
  802a19:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802a1c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802a20:	79 08                	jns    802a2a <spawn+0x46>
		return r;
  802a22:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802a25:	e9 23 03 00 00       	jmpq   802d4d <spawn+0x369>
	fd = r;
  802a2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802a2d:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802a30:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  802a37:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a3b:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  802a42:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a45:	ba 00 02 00 00       	mov    $0x200,%edx
  802a4a:	48 89 ce             	mov    %rcx,%rsi
  802a4d:	89 c7                	mov    %eax,%edi
  802a4f:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	callq  *%rax
  802a5b:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a60:	75 0d                	jne    802a6f <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  802a62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a66:	8b 00                	mov    (%rax),%eax
  802a68:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802a6d:	74 43                	je     802ab2 <spawn+0xce>
		close(fd);
  802a6f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a72:	89 c7                	mov    %eax,%edi
  802a74:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802a80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a84:	8b 00                	mov    (%rax),%eax
  802a86:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802a8b:	89 c6                	mov    %eax,%esi
  802a8d:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  802a94:	00 00 00 
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9c:	48 b9 63 05 80 00 00 	movabs $0x800563,%rcx
  802aa3:	00 00 00 
  802aa6:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802aa8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802aad:	e9 9b 02 00 00       	jmpq   802d4d <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802ab2:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  802ab9:	00 00 00 
  802abc:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  802ac2:	cd 30                	int    $0x30
  802ac4:	89 c3                	mov    %eax,%ebx
  802ac6:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802ac9:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802acc:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802acf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ad3:	79 08                	jns    802add <spawn+0xf9>
		return r;
  802ad5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ad8:	e9 70 02 00 00       	jmpq   802d4d <spawn+0x369>
	child = r;
  802add:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ae0:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ae3:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802ae6:	25 ff 03 00 00       	and    $0x3ff,%eax
  802aeb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802af2:	00 00 00 
  802af5:	48 63 d0             	movslq %eax,%rdx
  802af8:	48 89 d0             	mov    %rdx,%rax
  802afb:	48 c1 e0 02          	shl    $0x2,%rax
  802aff:	48 01 d0             	add    %rdx,%rax
  802b02:	48 01 c0             	add    %rax,%rax
  802b05:	48 01 d0             	add    %rdx,%rax
  802b08:	48 c1 e0 05          	shl    $0x5,%rax
  802b0c:	48 01 c8             	add    %rcx,%rax
  802b0f:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802b16:	48 89 c6             	mov    %rax,%rsi
  802b19:	b8 18 00 00 00       	mov    $0x18,%eax
  802b1e:	48 89 d7             	mov    %rdx,%rdi
  802b21:	48 89 c1             	mov    %rax,%rcx
  802b24:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802b27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b2b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b2f:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802b36:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  802b3d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802b44:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  802b4b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b4e:	48 89 ce             	mov    %rcx,%rsi
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	48 b8 a5 2f 80 00 00 	movabs $0x802fa5,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
  802b5f:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b62:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b66:	79 08                	jns    802b70 <spawn+0x18c>
		return r;
  802b68:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b6b:	e9 dd 01 00 00       	jmpq   802d4d <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b70:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b74:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b78:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  802b7f:	48 01 d0             	add    %rdx,%rax
  802b82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802b8d:	eb 7a                	jmp    802c09 <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  802b8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b93:	8b 00                	mov    (%rax),%eax
  802b95:	83 f8 01             	cmp    $0x1,%eax
  802b98:	75 65                	jne    802bff <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  802b9a:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba5:	8b 40 04             	mov    0x4(%rax),%eax
  802ba8:	83 e0 02             	and    $0x2,%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 04                	je     802bb3 <spawn+0x1cf>
			perm |= PTE_W;
  802baf:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802bb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb7:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802bbb:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802bc2:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802bc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bca:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802bce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd2:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802bd6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802bd9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802bdc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802bdf:	89 3c 24             	mov    %edi,(%rsp)
  802be2:	89 c7                	mov    %eax,%edi
  802be4:	48 b8 15 32 80 00 00 	movabs $0x803215,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
  802bf0:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802bf3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802bf7:	0f 88 2a 01 00 00    	js     802d27 <spawn+0x343>
  802bfd:	eb 01                	jmp    802c00 <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802bff:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c00:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802c04:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  802c09:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c0d:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802c11:	0f b7 c0             	movzwl %ax,%eax
  802c14:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c17:	0f 8f 72 ff ff ff    	jg     802b8f <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802c1d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c20:	89 c7                	mov    %eax,%edi
  802c22:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
	fd = -1;
  802c2e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802c35:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c38:	89 c7                	mov    %eax,%edi
  802c3a:	48 b8 fc 33 80 00 00 	movabs $0x8033fc,%rax
  802c41:	00 00 00 
  802c44:	ff d0                	callq  *%rax
  802c46:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802c49:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802c4d:	79 30                	jns    802c7f <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  802c4f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802c52:	89 c1                	mov    %eax,%ecx
  802c54:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  802c5b:	00 00 00 
  802c5e:	be 82 00 00 00       	mov    $0x82,%esi
  802c63:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  802c6a:	00 00 00 
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c72:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  802c79:	00 00 00 
  802c7c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802c7f:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802c86:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c89:	48 89 d6             	mov    %rdx,%rsi
  802c8c:	89 c7                	mov    %eax,%edi
  802c8e:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
  802c9a:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802c9d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ca1:	79 30                	jns    802cd3 <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  802ca3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ca6:	89 c1                	mov    %eax,%ecx
  802ca8:	48 ba 14 50 80 00 00 	movabs $0x805014,%rdx
  802caf:	00 00 00 
  802cb2:	be 85 00 00 00       	mov    $0x85,%esi
  802cb7:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  802cbe:	00 00 00 
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc6:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  802ccd:	00 00 00 
  802cd0:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802cd3:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802cd6:	be 02 00 00 00       	mov    $0x2,%esi
  802cdb:	89 c7                	mov    %eax,%edi
  802cdd:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
  802ce9:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802cec:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802cf0:	79 30                	jns    802d22 <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  802cf2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802cf5:	89 c1                	mov    %eax,%ecx
  802cf7:	48 ba 2e 50 80 00 00 	movabs $0x80502e,%rdx
  802cfe:	00 00 00 
  802d01:	be 88 00 00 00       	mov    $0x88,%esi
  802d06:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  802d0d:	00 00 00 
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  802d1c:	00 00 00 
  802d1f:	41 ff d0             	callq  *%r8

	return child;
  802d22:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802d25:	eb 26                	jmp    802d4d <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802d27:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802d28:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802d2b:	89 c7                	mov    %eax,%edi
  802d2d:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
	close(fd);
  802d39:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d3c:	89 c7                	mov    %eax,%edi
  802d3e:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	return r;
  802d4a:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  802d4d:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  802d54:	5b                   	pop    %rbx
  802d55:	5d                   	pop    %rbp
  802d56:	c3                   	retq   

0000000000802d57 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802d57:	55                   	push   %rbp
  802d58:	48 89 e5             	mov    %rsp,%rbp
  802d5b:	53                   	push   %rbx
  802d5c:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  802d63:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802d6a:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  802d71:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802d78:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802d7f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802d86:	84 c0                	test   %al,%al
  802d88:	74 23                	je     802dad <spawnl+0x56>
  802d8a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802d91:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802d95:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802d99:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802d9d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802da1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802da5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802da9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802dad:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802db4:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  802dbb:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802dbe:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802dc5:	00 00 00 
  802dc8:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802dcf:	00 00 00 
  802dd2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dd6:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802ddd:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802de4:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802deb:	eb 07                	jmp    802df4 <spawnl+0x9d>
		argc++;
  802ded:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802df4:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802dfa:	83 f8 30             	cmp    $0x30,%eax
  802dfd:	73 23                	jae    802e22 <spawnl+0xcb>
  802dff:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802e06:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802e0c:	89 c0                	mov    %eax,%eax
  802e0e:	48 01 d0             	add    %rdx,%rax
  802e11:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802e17:	83 c2 08             	add    $0x8,%edx
  802e1a:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802e20:	eb 15                	jmp    802e37 <spawnl+0xe0>
  802e22:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802e29:	48 89 d0             	mov    %rdx,%rax
  802e2c:	48 83 c2 08          	add    $0x8,%rdx
  802e30:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802e37:	48 8b 00             	mov    (%rax),%rax
  802e3a:	48 85 c0             	test   %rax,%rax
  802e3d:	75 ae                	jne    802ded <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802e3f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802e45:	83 c0 02             	add    $0x2,%eax
  802e48:	48 89 e2             	mov    %rsp,%rdx
  802e4b:	48 89 d3             	mov    %rdx,%rbx
  802e4e:	48 63 d0             	movslq %eax,%rdx
  802e51:	48 83 ea 01          	sub    $0x1,%rdx
  802e55:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  802e5c:	48 98                	cltq   
  802e5e:	48 c1 e0 03          	shl    $0x3,%rax
  802e62:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  802e66:	b8 10 00 00 00       	mov    $0x10,%eax
  802e6b:	48 83 e8 01          	sub    $0x1,%rax
  802e6f:	48 01 d0             	add    %rdx,%rax
  802e72:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  802e79:	10 00 00 00 
  802e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e82:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  802e89:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802e8d:	48 29 c4             	sub    %rax,%rsp
  802e90:	48 89 e0             	mov    %rsp,%rax
  802e93:	48 83 c0 0f          	add    $0xf,%rax
  802e97:	48 c1 e8 04          	shr    $0x4,%rax
  802e9b:	48 c1 e0 04          	shl    $0x4,%rax
  802e9f:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  802ea6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ead:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  802eb4:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802eb7:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802ebd:	8d 50 01             	lea    0x1(%rax),%edx
  802ec0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ec7:	48 63 d2             	movslq %edx,%rdx
  802eca:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802ed1:	00 

	va_start(vl, arg0);
  802ed2:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802ed9:	00 00 00 
  802edc:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802ee3:	00 00 00 
  802ee6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802eea:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802ef1:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802ef8:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802eff:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  802f06:	00 00 00 
  802f09:	eb 63                	jmp    802f6e <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  802f0b:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  802f11:	8d 70 01             	lea    0x1(%rax),%esi
  802f14:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802f1a:	83 f8 30             	cmp    $0x30,%eax
  802f1d:	73 23                	jae    802f42 <spawnl+0x1eb>
  802f1f:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802f26:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802f2c:	89 c0                	mov    %eax,%eax
  802f2e:	48 01 d0             	add    %rdx,%rax
  802f31:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802f37:	83 c2 08             	add    $0x8,%edx
  802f3a:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802f40:	eb 15                	jmp    802f57 <spawnl+0x200>
  802f42:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802f49:	48 89 d0             	mov    %rdx,%rax
  802f4c:	48 83 c2 08          	add    $0x8,%rdx
  802f50:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802f57:	48 8b 08             	mov    (%rax),%rcx
  802f5a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f61:	89 f2                	mov    %esi,%edx
  802f63:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802f67:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  802f6e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802f74:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  802f7a:	77 8f                	ja     802f0b <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802f7c:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  802f83:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f8a:	48 89 d6             	mov    %rdx,%rsi
  802f8d:	48 89 c7             	mov    %rax,%rdi
  802f90:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	48 89 dc             	mov    %rbx,%rsp
}
  802f9f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802fa3:	c9                   	leaveq 
  802fa4:	c3                   	retq   

0000000000802fa5 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  802fa5:	55                   	push   %rbp
  802fa6:	48 89 e5             	mov    %rsp,%rbp
  802fa9:	48 83 ec 50          	sub    $0x50,%rsp
  802fad:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802fb0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802fb4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802fb8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fbf:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  802fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802fc7:	eb 2c                	jmp    802ff5 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  802fc9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fcc:	48 98                	cltq   
  802fce:	48 c1 e0 03          	shl    $0x3,%rax
  802fd2:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802fd6:	48 8b 00             	mov    (%rax),%rax
  802fd9:	48 89 c7             	mov    %rax,%rdi
  802fdc:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802fe3:	00 00 00 
  802fe6:	ff d0                	callq  *%rax
  802fe8:	83 c0 01             	add    $0x1,%eax
  802feb:	48 98                	cltq   
  802fed:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802ff1:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802ff5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ff8:	48 98                	cltq   
  802ffa:	48 c1 e0 03          	shl    $0x3,%rax
  802ffe:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803002:	48 8b 00             	mov    (%rax),%rax
  803005:	48 85 c0             	test   %rax,%rax
  803008:	75 bf                	jne    802fc9 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300e:	48 f7 d8             	neg    %rax
  803011:	48 05 00 10 40 00    	add    $0x401000,%rax
  803017:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80301b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803023:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803027:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80302b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80302e:	83 c2 01             	add    $0x1,%edx
  803031:	c1 e2 03             	shl    $0x3,%edx
  803034:	48 63 d2             	movslq %edx,%rdx
  803037:	48 f7 da             	neg    %rdx
  80303a:	48 01 d0             	add    %rdx,%rax
  80303d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803041:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803045:	48 83 e8 10          	sub    $0x10,%rax
  803049:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80304f:	77 0a                	ja     80305b <init_stack+0xb6>
		return -E_NO_MEM;
  803051:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803056:	e9 b8 01 00 00       	jmpq   803213 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80305b:	ba 07 00 00 00       	mov    $0x7,%edx
  803060:	be 00 00 40 00       	mov    $0x400000,%esi
  803065:	bf 00 00 00 00       	mov    $0x0,%edi
  80306a:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
  803076:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803079:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80307d:	79 08                	jns    803087 <init_stack+0xe2>
		return r;
  80307f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803082:	e9 8c 01 00 00       	jmpq   803213 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803087:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80308e:	eb 73                	jmp    803103 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803090:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803093:	48 98                	cltq   
  803095:	48 c1 e0 03          	shl    $0x3,%rax
  803099:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80309d:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  8030a2:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  8030a6:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8030ad:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  8030b0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030b3:	48 98                	cltq   
  8030b5:	48 c1 e0 03          	shl    $0x3,%rax
  8030b9:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8030bd:	48 8b 10             	mov    (%rax),%rdx
  8030c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c4:	48 89 d6             	mov    %rdx,%rsi
  8030c7:	48 89 c7             	mov    %rax,%rdi
  8030ca:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8030d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030d9:	48 98                	cltq   
  8030db:	48 c1 e0 03          	shl    $0x3,%rax
  8030df:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8030e3:	48 8b 00             	mov    (%rax),%rax
  8030e6:	48 89 c7             	mov    %rax,%rdi
  8030e9:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  8030f0:	00 00 00 
  8030f3:	ff d0                	callq  *%rax
  8030f5:	48 98                	cltq   
  8030f7:	48 83 c0 01          	add    $0x1,%rax
  8030fb:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8030ff:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803103:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803106:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803109:	7c 85                	jl     803090 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80310b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80310e:	48 98                	cltq   
  803110:	48 c1 e0 03          	shl    $0x3,%rax
  803114:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803118:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80311f:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803126:	00 
  803127:	74 35                	je     80315e <init_stack+0x1b9>
  803129:	48 b9 48 50 80 00 00 	movabs $0x805048,%rcx
  803130:	00 00 00 
  803133:	48 ba 6e 50 80 00 00 	movabs $0x80506e,%rdx
  80313a:	00 00 00 
  80313d:	be f1 00 00 00       	mov    $0xf1,%esi
  803142:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  803149:	00 00 00 
  80314c:	b8 00 00 00 00       	mov    $0x0,%eax
  803151:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  803158:	00 00 00 
  80315b:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80315e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803162:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803166:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80316b:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80316f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803175:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803178:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80317c:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803180:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803183:	48 98                	cltq   
  803185:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803188:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  80318d:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803191:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803197:	48 89 c2             	mov    %rax,%rdx
  80319a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80319e:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8031a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031a4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8031aa:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8031af:	89 c2                	mov    %eax,%edx
  8031b1:	be 00 00 40 00       	mov    $0x400000,%esi
  8031b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031bb:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	callq  *%rax
  8031c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ce:	78 26                	js     8031f6 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8031d0:	be 00 00 40 00       	mov    $0x400000,%esi
  8031d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031da:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
  8031e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ed:	78 0a                	js     8031f9 <init_stack+0x254>
		goto error;

	return 0;
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f4:	eb 1d                	jmp    803213 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8031f6:	90                   	nop
  8031f7:	eb 01                	jmp    8031fa <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8031f9:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8031fa:	be 00 00 40 00       	mov    $0x400000,%esi
  8031ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803204:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
	return r;
  803210:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803213:	c9                   	leaveq 
  803214:	c3                   	retq   

0000000000803215 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 50          	sub    $0x50,%rsp
  80321d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803220:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803224:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803228:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80322b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80322f:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803237:	25 ff 0f 00 00       	and    $0xfff,%eax
  80323c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803243:	74 21                	je     803266 <map_segment+0x51>
		va -= i;
  803245:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803248:	48 98                	cltq   
  80324a:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80324e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803251:	48 98                	cltq   
  803253:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325a:	48 98                	cltq   
  80325c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803263:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80326d:	e9 74 01 00 00       	jmpq   8033e6 <map_segment+0x1d1>
		if (i >= filesz) {
  803272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803275:	48 98                	cltq   
  803277:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80327b:	72 38                	jb     8032b5 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80327d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803280:	48 98                	cltq   
  803282:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803286:	48 89 c1             	mov    %rax,%rcx
  803289:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80328c:	8b 55 10             	mov    0x10(%rbp),%edx
  80328f:	48 89 ce             	mov    %rcx,%rsi
  803292:	89 c7                	mov    %eax,%edi
  803294:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
  8032a0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032a7:	0f 89 32 01 00 00    	jns    8033df <map_segment+0x1ca>
				return r;
  8032ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b0:	e9 45 01 00 00       	jmpq   8033fa <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8032b5:	ba 07 00 00 00       	mov    $0x7,%edx
  8032ba:	be 00 00 40 00       	mov    $0x400000,%esi
  8032bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c4:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032d7:	79 08                	jns    8032e1 <map_segment+0xcc>
				return r;
  8032d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032dc:	e9 19 01 00 00       	jmpq   8033fa <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8032e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e4:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8032e7:	01 c2                	add    %eax,%edx
  8032e9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8032ec:	89 d6                	mov    %edx,%esi
  8032ee:	89 c7                	mov    %eax,%edi
  8032f0:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
  8032fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803303:	79 08                	jns    80330d <map_segment+0xf8>
				return r;
  803305:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803308:	e9 ed 00 00 00       	jmpq   8033fa <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80330d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803317:	48 98                	cltq   
  803319:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80331d:	48 89 d1             	mov    %rdx,%rcx
  803320:	48 29 c1             	sub    %rax,%rcx
  803323:	48 89 c8             	mov    %rcx,%rax
  803326:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80332a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80332d:	48 63 d0             	movslq %eax,%rdx
  803330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803334:	48 39 c2             	cmp    %rax,%rdx
  803337:	48 0f 47 d0          	cmova  %rax,%rdx
  80333b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80333e:	be 00 00 40 00       	mov    $0x400000,%esi
  803343:	89 c7                	mov    %eax,%edi
  803345:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  80334c:	00 00 00 
  80334f:	ff d0                	callq  *%rax
  803351:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803354:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803358:	79 08                	jns    803362 <map_segment+0x14d>
				return r;
  80335a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80335d:	e9 98 00 00 00       	jmpq   8033fa <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	48 98                	cltq   
  803367:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80336b:	48 89 c2             	mov    %rax,%rdx
  80336e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803371:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803375:	48 89 d1             	mov    %rdx,%rcx
  803378:	89 c2                	mov    %eax,%edx
  80337a:	be 00 00 40 00       	mov    $0x400000,%esi
  80337f:	bf 00 00 00 00       	mov    $0x0,%edi
  803384:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
  803390:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803393:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803397:	79 30                	jns    8033c9 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  803399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80339c:	89 c1                	mov    %eax,%ecx
  80339e:	48 ba 83 50 80 00 00 	movabs $0x805083,%rdx
  8033a5:	00 00 00 
  8033a8:	be 24 01 00 00       	mov    $0x124,%esi
  8033ad:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  8033b4:	00 00 00 
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bc:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  8033c3:	00 00 00 
  8033c6:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8033c9:	be 00 00 40 00       	mov    $0x400000,%esi
  8033ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d3:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8033df:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8033e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e9:	48 98                	cltq   
  8033eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033ef:	0f 82 7d fe ff ff    	jb     803272 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8033f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033fa:	c9                   	leaveq 
  8033fb:	c3                   	retq   

00000000008033fc <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8033fc:	55                   	push   %rbp
  8033fd:	48 89 e5             	mov    %rsp,%rbp
  803400:	48 83 ec 60          	sub    $0x60,%rsp
  803404:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  803407:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  80340e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803415:	00 
    uint64_t each_pte = 0;
  803416:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80341d:	00 
    uint64_t each_pdpe = 0;
  80341e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803425:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  803426:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80342d:	00 
  80342e:	e9 a5 01 00 00       	jmpq   8035d8 <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  803433:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80343a:	01 00 00 
  80343d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803441:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803445:	83 e0 01             	and    $0x1,%eax
  803448:	84 c0                	test   %al,%al
  80344a:	0f 84 73 01 00 00    	je     8035c3 <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803450:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803457:	00 
  803458:	e9 56 01 00 00       	jmpq   8035b3 <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  80345d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803464:	01 00 00 
  803467:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80346b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80346f:	83 e0 01             	and    $0x1,%eax
  803472:	84 c0                	test   %al,%al
  803474:	0f 84 1f 01 00 00    	je     803599 <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80347a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803481:	00 
  803482:	e9 02 01 00 00       	jmpq   803589 <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  803487:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80348e:	01 00 00 
  803491:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803495:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803499:	83 e0 01             	and    $0x1,%eax
  80349c:	84 c0                	test   %al,%al
  80349e:	0f 84 cb 00 00 00    	je     80356f <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8034a4:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8034ab:	00 
  8034ac:	e9 ae 00 00 00       	jmpq   80355f <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  8034b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034b8:	01 00 00 
  8034bb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8034bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034c3:	25 00 04 00 00       	and    $0x400,%eax
  8034c8:	48 85 c0             	test   %rax,%rax
  8034cb:	0f 84 84 00 00 00    	je     803555 <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  8034d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034d8:	01 00 00 
  8034db:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8034df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8034e8:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  8034eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8034f3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  8034f7:	8b 75 c0             	mov    -0x40(%rbp),%esi
  8034fa:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8034fe:	8b 55 ac             	mov    -0x54(%rbp),%edx
  803501:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803505:	41 89 f0             	mov    %esi,%r8d
  803508:	48 89 c6             	mov    %rax,%rsi
  80350b:	bf 00 00 00 00       	mov    $0x0,%edi
  803510:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
  80351c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  80351f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803523:	79 30                	jns    803555 <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  803525:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803528:	89 c1                	mov    %eax,%ecx
  80352a:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  803531:	00 00 00 
  803534:	be 48 01 00 00       	mov    $0x148,%esi
  803539:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  803540:	00 00 00 
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
  803548:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  80354f:	00 00 00 
  803552:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803555:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80355a:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80355f:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803566:	00 
  803567:	0f 86 44 ff ff ff    	jbe    8034b1 <copy_shared_pages+0xb5>
  80356d:	eb 10                	jmp    80357f <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  80356f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803573:	48 83 c0 01          	add    $0x1,%rax
  803577:	48 c1 e0 09          	shl    $0x9,%rax
  80357b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80357f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803584:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803589:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803590:	00 
  803591:	0f 86 f0 fe ff ff    	jbe    803487 <copy_shared_pages+0x8b>
  803597:	eb 10                	jmp    8035a9 <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  803599:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80359d:	48 83 c0 01          	add    $0x1,%rax
  8035a1:	48 c1 e0 09          	shl    $0x9,%rax
  8035a5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8035a9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8035ae:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8035b3:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8035ba:	00 
  8035bb:	0f 86 9c fe ff ff    	jbe    80345d <copy_shared_pages+0x61>
  8035c1:	eb 10                	jmp    8035d3 <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  8035c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c7:	48 83 c0 01          	add    $0x1,%rax
  8035cb:	48 c1 e0 09          	shl    $0x9,%rax
  8035cf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8035d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035d8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035dd:	0f 84 50 fe ff ff    	je     803433 <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  8035e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e8:	c9                   	leaveq 
  8035e9:	c3                   	retq   
	...

00000000008035ec <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8035ec:	55                   	push   %rbp
  8035ed:	48 89 e5             	mov    %rsp,%rbp
  8035f0:	48 83 ec 20          	sub    $0x20,%rsp
  8035f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035fe:	48 89 d6             	mov    %rdx,%rsi
  803601:	89 c7                	mov    %eax,%edi
  803603:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803616:	79 05                	jns    80361d <fd2sockid+0x31>
		return r;
  803618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361b:	eb 24                	jmp    803641 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80361d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803621:	8b 10                	mov    (%rax),%edx
  803623:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80362a:	00 00 00 
  80362d:	8b 00                	mov    (%rax),%eax
  80362f:	39 c2                	cmp    %eax,%edx
  803631:	74 07                	je     80363a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803633:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803638:	eb 07                	jmp    803641 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80363a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803641:	c9                   	leaveq 
  803642:	c3                   	retq   

0000000000803643 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803643:	55                   	push   %rbp
  803644:	48 89 e5             	mov    %rsp,%rbp
  803647:	48 83 ec 20          	sub    $0x20,%rsp
  80364b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80364e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803652:	48 89 c7             	mov    %rax,%rdi
  803655:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
  803661:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803664:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803668:	78 26                	js     803690 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	ba 07 04 00 00       	mov    $0x407,%edx
  803673:	48 89 c6             	mov    %rax,%rsi
  803676:	bf 00 00 00 00       	mov    $0x0,%edi
  80367b:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80368a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368e:	79 16                	jns    8036a6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803690:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803693:	89 c7                	mov    %eax,%edi
  803695:	48 b8 50 3b 80 00 00 	movabs $0x803b50,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
		return r;
  8036a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a4:	eb 3a                	jmp    8036e0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036aa:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036b1:	00 00 00 
  8036b4:	8b 12                	mov    (%rdx),%edx
  8036b6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036ca:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d1:	48 89 c7             	mov    %rax,%rdi
  8036d4:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
}
  8036e0:	c9                   	leaveq 
  8036e1:	c3                   	retq   

00000000008036e2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036e2:	55                   	push   %rbp
  8036e3:	48 89 e5             	mov    %rsp,%rbp
  8036e6:	48 83 ec 30          	sub    $0x30,%rsp
  8036ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f8:	89 c7                	mov    %eax,%edi
  8036fa:	48 b8 ec 35 80 00 00 	movabs $0x8035ec,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370d:	79 05                	jns    803714 <accept+0x32>
		return r;
  80370f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803712:	eb 3b                	jmp    80374f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803714:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803718:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80371c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371f:	48 89 ce             	mov    %rcx,%rsi
  803722:	89 c7                	mov    %eax,%edi
  803724:	48 b8 2d 3a 80 00 00 	movabs $0x803a2d,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
  803730:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803733:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803737:	79 05                	jns    80373e <accept+0x5c>
		return r;
  803739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373c:	eb 11                	jmp    80374f <accept+0x6d>
	return alloc_sockfd(r);
  80373e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803741:	89 c7                	mov    %eax,%edi
  803743:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  80374a:	00 00 00 
  80374d:	ff d0                	callq  *%rax
}
  80374f:	c9                   	leaveq 
  803750:	c3                   	retq   

0000000000803751 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803751:	55                   	push   %rbp
  803752:	48 89 e5             	mov    %rsp,%rbp
  803755:	48 83 ec 20          	sub    $0x20,%rsp
  803759:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80375c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803760:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803763:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803766:	89 c7                	mov    %eax,%edi
  803768:	48 b8 ec 35 80 00 00 	movabs $0x8035ec,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
  803774:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803777:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377b:	79 05                	jns    803782 <bind+0x31>
		return r;
  80377d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803780:	eb 1b                	jmp    80379d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803782:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803785:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378c:	48 89 ce             	mov    %rcx,%rsi
  80378f:	89 c7                	mov    %eax,%edi
  803791:	48 b8 ac 3a 80 00 00 	movabs $0x803aac,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   

000000000080379f <shutdown>:

int
shutdown(int s, int how)
{
  80379f:	55                   	push   %rbp
  8037a0:	48 89 e5             	mov    %rsp,%rbp
  8037a3:	48 83 ec 20          	sub    $0x20,%rsp
  8037a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b0:	89 c7                	mov    %eax,%edi
  8037b2:	48 b8 ec 35 80 00 00 	movabs $0x8035ec,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
  8037be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c5:	79 05                	jns    8037cc <shutdown+0x2d>
		return r;
  8037c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ca:	eb 16                	jmp    8037e2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d2:	89 d6                	mov    %edx,%esi
  8037d4:	89 c7                	mov    %eax,%edi
  8037d6:	48 b8 10 3b 80 00 00 	movabs $0x803b10,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
}
  8037e2:	c9                   	leaveq 
  8037e3:	c3                   	retq   

00000000008037e4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8037e4:	55                   	push   %rbp
  8037e5:	48 89 e5             	mov    %rsp,%rbp
  8037e8:	48 83 ec 10          	sub    $0x10,%rsp
  8037ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8037f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f4:	48 89 c7             	mov    %rax,%rdi
  8037f7:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
  803803:	83 f8 01             	cmp    $0x1,%eax
  803806:	75 17                	jne    80381f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380c:	8b 40 0c             	mov    0xc(%rax),%eax
  80380f:	89 c7                	mov    %eax,%edi
  803811:	48 b8 50 3b 80 00 00 	movabs $0x803b50,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	eb 05                	jmp    803824 <devsock_close+0x40>
	else
		return 0;
  80381f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803824:	c9                   	leaveq 
  803825:	c3                   	retq   

0000000000803826 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803826:	55                   	push   %rbp
  803827:	48 89 e5             	mov    %rsp,%rbp
  80382a:	48 83 ec 20          	sub    $0x20,%rsp
  80382e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803831:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803835:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803838:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80383b:	89 c7                	mov    %eax,%edi
  80383d:	48 b8 ec 35 80 00 00 	movabs $0x8035ec,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
  803849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803850:	79 05                	jns    803857 <connect+0x31>
		return r;
  803852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803855:	eb 1b                	jmp    803872 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803857:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80385a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80385e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803861:	48 89 ce             	mov    %rcx,%rsi
  803864:	89 c7                	mov    %eax,%edi
  803866:	48 b8 7d 3b 80 00 00 	movabs $0x803b7d,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
}
  803872:	c9                   	leaveq 
  803873:	c3                   	retq   

0000000000803874 <listen>:

int
listen(int s, int backlog)
{
  803874:	55                   	push   %rbp
  803875:	48 89 e5             	mov    %rsp,%rbp
  803878:	48 83 ec 20          	sub    $0x20,%rsp
  80387c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80387f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803882:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803885:	89 c7                	mov    %eax,%edi
  803887:	48 b8 ec 35 80 00 00 	movabs $0x8035ec,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
  803893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389a:	79 05                	jns    8038a1 <listen+0x2d>
		return r;
  80389c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389f:	eb 16                	jmp    8038b7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8038a1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a7:	89 d6                	mov    %edx,%esi
  8038a9:	89 c7                	mov    %eax,%edi
  8038ab:	48 b8 e1 3b 80 00 00 	movabs $0x803be1,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
}
  8038b7:	c9                   	leaveq 
  8038b8:	c3                   	retq   

00000000008038b9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038b9:	55                   	push   %rbp
  8038ba:	48 89 e5             	mov    %rsp,%rbp
  8038bd:	48 83 ec 20          	sub    $0x20,%rsp
  8038c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d1:	89 c2                	mov    %eax,%edx
  8038d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d7:	8b 40 0c             	mov    0xc(%rax),%eax
  8038da:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038e3:	89 c7                	mov    %eax,%edi
  8038e5:	48 b8 21 3c 80 00 00 	movabs $0x803c21,%rax
  8038ec:	00 00 00 
  8038ef:	ff d0                	callq  *%rax
}
  8038f1:	c9                   	leaveq 
  8038f2:	c3                   	retq   

00000000008038f3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8038f3:	55                   	push   %rbp
  8038f4:	48 89 e5             	mov    %rsp,%rbp
  8038f7:	48 83 ec 20          	sub    $0x20,%rsp
  8038fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803903:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390b:	89 c2                	mov    %eax,%edx
  80390d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803911:	8b 40 0c             	mov    0xc(%rax),%eax
  803914:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80391d:	89 c7                	mov    %eax,%edi
  80391f:	48 b8 ed 3c 80 00 00 	movabs $0x803ced,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 10          	sub    $0x10,%rsp
  803935:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803939:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	48 be be 50 80 00 00 	movabs $0x8050be,%rsi
  803948:	00 00 00 
  80394b:	48 89 c7             	mov    %rax,%rdi
  80394e:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
	return 0;
  80395a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80395f:	c9                   	leaveq 
  803960:	c3                   	retq   

0000000000803961 <socket>:

int
socket(int domain, int type, int protocol)
{
  803961:	55                   	push   %rbp
  803962:	48 89 e5             	mov    %rsp,%rbp
  803965:	48 83 ec 20          	sub    $0x20,%rsp
  803969:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80396c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80396f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803972:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803975:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803978:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80397b:	89 ce                	mov    %ecx,%esi
  80397d:	89 c7                	mov    %eax,%edi
  80397f:	48 b8 a5 3d 80 00 00 	movabs $0x803da5,%rax
  803986:	00 00 00 
  803989:	ff d0                	callq  *%rax
  80398b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803992:	79 05                	jns    803999 <socket+0x38>
		return r;
  803994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803997:	eb 11                	jmp    8039aa <socket+0x49>
	return alloc_sockfd(r);
  803999:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399c:	89 c7                	mov    %eax,%edi
  80399e:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
}
  8039aa:	c9                   	leaveq 
  8039ab:	c3                   	retq   

00000000008039ac <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039ac:	55                   	push   %rbp
  8039ad:	48 89 e5             	mov    %rsp,%rbp
  8039b0:	48 83 ec 10          	sub    $0x10,%rsp
  8039b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039b7:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039be:	00 00 00 
  8039c1:	8b 00                	mov    (%rax),%eax
  8039c3:	85 c0                	test   %eax,%eax
  8039c5:	75 1d                	jne    8039e4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039c7:	bf 02 00 00 00       	mov    $0x2,%edi
  8039cc:	48 b8 0a 48 80 00 00 	movabs $0x80480a,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8039df:	00 00 00 
  8039e2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039e4:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039eb:	00 00 00 
  8039ee:	8b 00                	mov    (%rax),%eax
  8039f0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8039f3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8039f8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8039ff:	00 00 00 
  803a02:	89 c7                	mov    %eax,%edi
  803a04:	48 b8 5b 47 80 00 00 	movabs $0x80475b,%rax
  803a0b:	00 00 00 
  803a0e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a10:	ba 00 00 00 00       	mov    $0x0,%edx
  803a15:	be 00 00 00 00       	mov    $0x0,%esi
  803a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1f:	48 b8 74 46 80 00 00 	movabs $0x804674,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 30          	sub    $0x30,%rsp
  803a35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a40:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a47:	00 00 00 
  803a4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a4d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a4f:	bf 01 00 00 00       	mov    $0x1,%edi
  803a54:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803a5b:	00 00 00 
  803a5e:	ff d0                	callq  *%rax
  803a60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a67:	78 3e                	js     803aa7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a69:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a70:	00 00 00 
  803a73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7b:	8b 40 10             	mov    0x10(%rax),%eax
  803a7e:	89 c2                	mov    %eax,%edx
  803a80:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a88:	48 89 ce             	mov    %rcx,%rsi
  803a8b:	48 89 c7             	mov    %rax,%rdi
  803a8e:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9e:	8b 50 10             	mov    0x10(%rax),%edx
  803aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 10          	sub    $0x10,%rsp
  803ab4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ab7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803abb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803abe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ac5:	00 00 00 
  803ac8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803acb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803acd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad4:	48 89 c6             	mov    %rax,%rsi
  803ad7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ade:	00 00 00 
  803ae1:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803aed:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af4:	00 00 00 
  803af7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803afa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803afd:	bf 02 00 00 00       	mov    $0x2,%edi
  803b02:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
}
  803b0e:	c9                   	leaveq 
  803b0f:	c3                   	retq   

0000000000803b10 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b10:	55                   	push   %rbp
  803b11:	48 89 e5             	mov    %rsp,%rbp
  803b14:	48 83 ec 10          	sub    $0x10,%rsp
  803b18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b1b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b1e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b25:	00 00 00 
  803b28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b2d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b34:	00 00 00 
  803b37:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b3a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b3d:	bf 03 00 00 00       	mov    $0x3,%edi
  803b42:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
}
  803b4e:	c9                   	leaveq 
  803b4f:	c3                   	retq   

0000000000803b50 <nsipc_close>:

int
nsipc_close(int s)
{
  803b50:	55                   	push   %rbp
  803b51:	48 89 e5             	mov    %rsp,%rbp
  803b54:	48 83 ec 10          	sub    $0x10,%rsp
  803b58:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b5b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b62:	00 00 00 
  803b65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b68:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b6a:	bf 04 00 00 00       	mov    $0x4,%edi
  803b6f:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803b76:	00 00 00 
  803b79:	ff d0                	callq  *%rax
}
  803b7b:	c9                   	leaveq 
  803b7c:	c3                   	retq   

0000000000803b7d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b7d:	55                   	push   %rbp
  803b7e:	48 89 e5             	mov    %rsp,%rbp
  803b81:	48 83 ec 10          	sub    $0x10,%rsp
  803b85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803b8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b96:	00 00 00 
  803b99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b9c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b9e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba5:	48 89 c6             	mov    %rax,%rsi
  803ba8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803baf:	00 00 00 
  803bb2:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803bbe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc5:	00 00 00 
  803bc8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bcb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803bce:	bf 05 00 00 00       	mov    $0x5,%edi
  803bd3:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
}
  803bdf:	c9                   	leaveq 
  803be0:	c3                   	retq   

0000000000803be1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803be1:	55                   	push   %rbp
  803be2:	48 89 e5             	mov    %rsp,%rbp
  803be5:	48 83 ec 10          	sub    $0x10,%rsp
  803be9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bec:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803bef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf6:	00 00 00 
  803bf9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bfc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803bfe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c05:	00 00 00 
  803c08:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c0b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c0e:	bf 06 00 00 00       	mov    $0x6,%edi
  803c13:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803c1a:	00 00 00 
  803c1d:	ff d0                	callq  *%rax
}
  803c1f:	c9                   	leaveq 
  803c20:	c3                   	retq   

0000000000803c21 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c21:	55                   	push   %rbp
  803c22:	48 89 e5             	mov    %rsp,%rbp
  803c25:	48 83 ec 30          	sub    $0x30,%rsp
  803c29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c30:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c33:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c36:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3d:	00 00 00 
  803c40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c43:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4c:	00 00 00 
  803c4f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c52:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c55:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5c:	00 00 00 
  803c5f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c62:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c65:	bf 07 00 00 00       	mov    $0x7,%edi
  803c6a:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803c71:	00 00 00 
  803c74:	ff d0                	callq  *%rax
  803c76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7d:	78 69                	js     803ce8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c7f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803c86:	7f 08                	jg     803c90 <nsipc_recv+0x6f>
  803c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803c8e:	7e 35                	jle    803cc5 <nsipc_recv+0xa4>
  803c90:	48 b9 c5 50 80 00 00 	movabs $0x8050c5,%rcx
  803c97:	00 00 00 
  803c9a:	48 ba da 50 80 00 00 	movabs $0x8050da,%rdx
  803ca1:	00 00 00 
  803ca4:	be 61 00 00 00       	mov    $0x61,%esi
  803ca9:	48 bf ef 50 80 00 00 	movabs $0x8050ef,%rdi
  803cb0:	00 00 00 
  803cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb8:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  803cbf:	00 00 00 
  803cc2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc8:	48 63 d0             	movslq %eax,%rdx
  803ccb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ccf:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cd6:	00 00 00 
  803cd9:	48 89 c7             	mov    %rax,%rdi
  803cdc:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
	}

	return r;
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ceb:	c9                   	leaveq 
  803cec:	c3                   	retq   

0000000000803ced <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ced:	55                   	push   %rbp
  803cee:	48 89 e5             	mov    %rsp,%rbp
  803cf1:	48 83 ec 20          	sub    $0x20,%rsp
  803cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cfc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803cff:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d09:	00 00 00 
  803d0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d0f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d11:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d18:	7e 35                	jle    803d4f <nsipc_send+0x62>
  803d1a:	48 b9 fb 50 80 00 00 	movabs $0x8050fb,%rcx
  803d21:	00 00 00 
  803d24:	48 ba da 50 80 00 00 	movabs $0x8050da,%rdx
  803d2b:	00 00 00 
  803d2e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803d33:	48 bf ef 50 80 00 00 	movabs $0x8050ef,%rdi
  803d3a:	00 00 00 
  803d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d42:	49 b8 28 03 80 00 00 	movabs $0x800328,%r8
  803d49:	00 00 00 
  803d4c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d52:	48 63 d0             	movslq %eax,%rdx
  803d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d59:	48 89 c6             	mov    %rax,%rsi
  803d5c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d63:	00 00 00 
  803d66:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  803d6d:	00 00 00 
  803d70:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d79:	00 00 00 
  803d7c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d7f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d89:	00 00 00 
  803d8c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d8f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803d92:	bf 08 00 00 00       	mov    $0x8,%edi
  803d97:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803d9e:	00 00 00 
  803da1:	ff d0                	callq  *%rax
}
  803da3:	c9                   	leaveq 
  803da4:	c3                   	retq   

0000000000803da5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803da5:	55                   	push   %rbp
  803da6:	48 89 e5             	mov    %rsp,%rbp
  803da9:	48 83 ec 10          	sub    $0x10,%rsp
  803dad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803db0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803db3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803db6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dbd:	00 00 00 
  803dc0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803dc3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803dc5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dcc:	00 00 00 
  803dcf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dd2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803dd5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ddc:	00 00 00 
  803ddf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803de2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803de5:	bf 09 00 00 00       	mov    $0x9,%edi
  803dea:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
}
  803df6:	c9                   	leaveq 
  803df7:	c3                   	retq   

0000000000803df8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803df8:	55                   	push   %rbp
  803df9:	48 89 e5             	mov    %rsp,%rbp
  803dfc:	53                   	push   %rbx
  803dfd:	48 83 ec 38          	sub    $0x38,%rsp
  803e01:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e05:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e09:	48 89 c7             	mov    %rax,%rdi
  803e0c:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e1f:	0f 88 bf 01 00 00    	js     803fe4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e29:	ba 07 04 00 00       	mov    $0x407,%edx
  803e2e:	48 89 c6             	mov    %rax,%rsi
  803e31:	bf 00 00 00 00       	mov    $0x0,%edi
  803e36:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803e3d:	00 00 00 
  803e40:	ff d0                	callq  *%rax
  803e42:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e45:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e49:	0f 88 95 01 00 00    	js     803fe4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e4f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e53:	48 89 c7             	mov    %rax,%rdi
  803e56:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  803e5d:	00 00 00 
  803e60:	ff d0                	callq  *%rax
  803e62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e69:	0f 88 5d 01 00 00    	js     803fcc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e73:	ba 07 04 00 00       	mov    $0x407,%edx
  803e78:	48 89 c6             	mov    %rax,%rsi
  803e7b:	bf 00 00 00 00       	mov    $0x0,%edi
  803e80:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
  803e8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e93:	0f 88 33 01 00 00    	js     803fcc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9d:	48 89 c7             	mov    %rax,%rdi
  803ea0:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb4:	ba 07 04 00 00       	mov    $0x407,%edx
  803eb9:	48 89 c6             	mov    %rax,%rsi
  803ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec1:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
  803ecd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ed4:	0f 88 d9 00 00 00    	js     803fb3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ede:	48 89 c7             	mov    %rax,%rdi
  803ee1:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803ee8:	00 00 00 
  803eeb:	ff d0                	callq  *%rax
  803eed:	48 89 c2             	mov    %rax,%rdx
  803ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803efa:	48 89 d1             	mov    %rdx,%rcx
  803efd:	ba 00 00 00 00       	mov    $0x0,%edx
  803f02:	48 89 c6             	mov    %rax,%rsi
  803f05:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0a:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803f11:	00 00 00 
  803f14:	ff d0                	callq  *%rax
  803f16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f1d:	78 79                	js     803f98 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f23:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f2a:	00 00 00 
  803f2d:	8b 12                	mov    (%rdx),%edx
  803f2f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f40:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f47:	00 00 00 
  803f4a:	8b 12                	mov    (%rdx),%edx
  803f4c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f52:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5d:	48 89 c7             	mov    %rax,%rdi
  803f60:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  803f67:	00 00 00 
  803f6a:	ff d0                	callq  *%rax
  803f6c:	89 c2                	mov    %eax,%edx
  803f6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f72:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f74:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f78:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f80:	48 89 c7             	mov    %rax,%rdi
  803f83:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  803f8a:	00 00 00 
  803f8d:	ff d0                	callq  *%rax
  803f8f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f91:	b8 00 00 00 00       	mov    $0x0,%eax
  803f96:	eb 4f                	jmp    803fe7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803f98:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f9d:	48 89 c6             	mov    %rax,%rsi
  803fa0:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa5:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803fac:	00 00 00 
  803faf:	ff d0                	callq  *%rax
  803fb1:	eb 01                	jmp    803fb4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803fb3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803fb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fb8:	48 89 c6             	mov    %rax,%rsi
  803fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc0:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803fc7:	00 00 00 
  803fca:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd0:	48 89 c6             	mov    %rax,%rsi
  803fd3:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd8:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803fdf:	00 00 00 
  803fe2:	ff d0                	callq  *%rax
err:
	return r;
  803fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fe7:	48 83 c4 38          	add    $0x38,%rsp
  803feb:	5b                   	pop    %rbx
  803fec:	5d                   	pop    %rbp
  803fed:	c3                   	retq   

0000000000803fee <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fee:	55                   	push   %rbp
  803fef:	48 89 e5             	mov    %rsp,%rbp
  803ff2:	53                   	push   %rbx
  803ff3:	48 83 ec 28          	sub    $0x28,%rsp
  803ff7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ffb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fff:	eb 01                	jmp    804002 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804001:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804002:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804009:	00 00 00 
  80400c:	48 8b 00             	mov    (%rax),%rax
  80400f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804015:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804018:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80401c:	48 89 c7             	mov    %rax,%rdi
  80401f:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
  804026:	00 00 00 
  804029:	ff d0                	callq  *%rax
  80402b:	89 c3                	mov    %eax,%ebx
  80402d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804031:	48 89 c7             	mov    %rax,%rdi
  804034:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
  80403b:	00 00 00 
  80403e:	ff d0                	callq  *%rax
  804040:	39 c3                	cmp    %eax,%ebx
  804042:	0f 94 c0             	sete   %al
  804045:	0f b6 c0             	movzbl %al,%eax
  804048:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80404b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804052:	00 00 00 
  804055:	48 8b 00             	mov    (%rax),%rax
  804058:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80405e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804061:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804064:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804067:	75 0a                	jne    804073 <_pipeisclosed+0x85>
			return ret;
  804069:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80406c:	48 83 c4 28          	add    $0x28,%rsp
  804070:	5b                   	pop    %rbx
  804071:	5d                   	pop    %rbp
  804072:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804073:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804076:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804079:	74 86                	je     804001 <_pipeisclosed+0x13>
  80407b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80407f:	75 80                	jne    804001 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804081:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804088:	00 00 00 
  80408b:	48 8b 00             	mov    (%rax),%rax
  80408e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804094:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804097:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80409a:	89 c6                	mov    %eax,%esi
  80409c:	48 bf 0c 51 80 00 00 	movabs $0x80510c,%rdi
  8040a3:	00 00 00 
  8040a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ab:	49 b8 63 05 80 00 00 	movabs $0x800563,%r8
  8040b2:	00 00 00 
  8040b5:	41 ff d0             	callq  *%r8
	}
  8040b8:	e9 44 ff ff ff       	jmpq   804001 <_pipeisclosed+0x13>

00000000008040bd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8040bd:	55                   	push   %rbp
  8040be:	48 89 e5             	mov    %rsp,%rbp
  8040c1:	48 83 ec 30          	sub    $0x30,%rsp
  8040c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040c8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040cf:	48 89 d6             	mov    %rdx,%rsi
  8040d2:	89 c7                	mov    %eax,%edi
  8040d4:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
  8040e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e7:	79 05                	jns    8040ee <pipeisclosed+0x31>
		return r;
  8040e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ec:	eb 31                	jmp    80411f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f2:	48 89 c7             	mov    %rax,%rdi
  8040f5:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
  804101:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80410d:	48 89 d6             	mov    %rdx,%rsi
  804110:	48 89 c7             	mov    %rax,%rdi
  804113:	48 b8 ee 3f 80 00 00 	movabs $0x803fee,%rax
  80411a:	00 00 00 
  80411d:	ff d0                	callq  *%rax
}
  80411f:	c9                   	leaveq 
  804120:	c3                   	retq   

0000000000804121 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804121:	55                   	push   %rbp
  804122:	48 89 e5             	mov    %rsp,%rbp
  804125:	48 83 ec 40          	sub    $0x40,%rsp
  804129:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80412d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804131:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804135:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804139:	48 89 c7             	mov    %rax,%rdi
  80413c:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  804143:	00 00 00 
  804146:	ff d0                	callq  *%rax
  804148:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80414c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804150:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804154:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80415b:	00 
  80415c:	e9 97 00 00 00       	jmpq   8041f8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804161:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804166:	74 09                	je     804171 <devpipe_read+0x50>
				return i;
  804168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416c:	e9 95 00 00 00       	jmpq   804206 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804171:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804179:	48 89 d6             	mov    %rdx,%rsi
  80417c:	48 89 c7             	mov    %rax,%rdi
  80417f:	48 b8 ee 3f 80 00 00 	movabs $0x803fee,%rax
  804186:	00 00 00 
  804189:	ff d0                	callq  *%rax
  80418b:	85 c0                	test   %eax,%eax
  80418d:	74 07                	je     804196 <devpipe_read+0x75>
				return 0;
  80418f:	b8 00 00 00 00       	mov    $0x0,%eax
  804194:	eb 70                	jmp    804206 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804196:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  80419d:	00 00 00 
  8041a0:	ff d0                	callq  *%rax
  8041a2:	eb 01                	jmp    8041a5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041a4:	90                   	nop
  8041a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a9:	8b 10                	mov    (%rax),%edx
  8041ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041af:	8b 40 04             	mov    0x4(%rax),%eax
  8041b2:	39 c2                	cmp    %eax,%edx
  8041b4:	74 ab                	je     804161 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041be:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c6:	8b 00                	mov    (%rax),%eax
  8041c8:	89 c2                	mov    %eax,%edx
  8041ca:	c1 fa 1f             	sar    $0x1f,%edx
  8041cd:	c1 ea 1b             	shr    $0x1b,%edx
  8041d0:	01 d0                	add    %edx,%eax
  8041d2:	83 e0 1f             	and    $0x1f,%eax
  8041d5:	29 d0                	sub    %edx,%eax
  8041d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041db:	48 98                	cltq   
  8041dd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041e2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e8:	8b 00                	mov    (%rax),%eax
  8041ea:	8d 50 01             	lea    0x1(%rax),%edx
  8041ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804200:	72 a2                	jb     8041a4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804206:	c9                   	leaveq 
  804207:	c3                   	retq   

0000000000804208 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804208:	55                   	push   %rbp
  804209:	48 89 e5             	mov    %rsp,%rbp
  80420c:	48 83 ec 40          	sub    $0x40,%rsp
  804210:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804214:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804218:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80421c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804220:	48 89 c7             	mov    %rax,%rdi
  804223:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  80422a:	00 00 00 
  80422d:	ff d0                	callq  *%rax
  80422f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804237:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80423b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804242:	00 
  804243:	e9 93 00 00 00       	jmpq   8042db <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804248:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80424c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804250:	48 89 d6             	mov    %rdx,%rsi
  804253:	48 89 c7             	mov    %rax,%rdi
  804256:	48 b8 ee 3f 80 00 00 	movabs $0x803fee,%rax
  80425d:	00 00 00 
  804260:	ff d0                	callq  *%rax
  804262:	85 c0                	test   %eax,%eax
  804264:	74 07                	je     80426d <devpipe_write+0x65>
				return 0;
  804266:	b8 00 00 00 00       	mov    $0x0,%eax
  80426b:	eb 7c                	jmp    8042e9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80426d:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  804274:	00 00 00 
  804277:	ff d0                	callq  *%rax
  804279:	eb 01                	jmp    80427c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80427b:	90                   	nop
  80427c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804280:	8b 40 04             	mov    0x4(%rax),%eax
  804283:	48 63 d0             	movslq %eax,%rdx
  804286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80428a:	8b 00                	mov    (%rax),%eax
  80428c:	48 98                	cltq   
  80428e:	48 83 c0 20          	add    $0x20,%rax
  804292:	48 39 c2             	cmp    %rax,%rdx
  804295:	73 b1                	jae    804248 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429b:	8b 40 04             	mov    0x4(%rax),%eax
  80429e:	89 c2                	mov    %eax,%edx
  8042a0:	c1 fa 1f             	sar    $0x1f,%edx
  8042a3:	c1 ea 1b             	shr    $0x1b,%edx
  8042a6:	01 d0                	add    %edx,%eax
  8042a8:	83 e0 1f             	and    $0x1f,%eax
  8042ab:	29 d0                	sub    %edx,%eax
  8042ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042b1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8042b5:	48 01 ca             	add    %rcx,%rdx
  8042b8:	0f b6 0a             	movzbl (%rdx),%ecx
  8042bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042bf:	48 98                	cltq   
  8042c1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c9:	8b 40 04             	mov    0x4(%rax),%eax
  8042cc:	8d 50 01             	lea    0x1(%rax),%edx
  8042cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042df:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042e3:	72 96                	jb     80427b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042e9:	c9                   	leaveq 
  8042ea:	c3                   	retq   

00000000008042eb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042eb:	55                   	push   %rbp
  8042ec:	48 89 e5             	mov    %rsp,%rbp
  8042ef:	48 83 ec 20          	sub    $0x20,%rsp
  8042f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ff:	48 89 c7             	mov    %rax,%rdi
  804302:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  804309:	00 00 00 
  80430c:	ff d0                	callq  *%rax
  80430e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804312:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804316:	48 be 1f 51 80 00 00 	movabs $0x80511f,%rsi
  80431d:	00 00 00 
  804320:	48 89 c7             	mov    %rax,%rdi
  804323:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80432f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804333:	8b 50 04             	mov    0x4(%rax),%edx
  804336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433a:	8b 00                	mov    (%rax),%eax
  80433c:	29 c2                	sub    %eax,%edx
  80433e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804342:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804348:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80434c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804353:	00 00 00 
	stat->st_dev = &devpipe;
  804356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804361:	00 00 00 
  804364:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80436b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804370:	c9                   	leaveq 
  804371:	c3                   	retq   

0000000000804372 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804372:	55                   	push   %rbp
  804373:	48 89 e5             	mov    %rsp,%rbp
  804376:	48 83 ec 10          	sub    $0x10,%rsp
  80437a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80437e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804382:	48 89 c6             	mov    %rax,%rsi
  804385:	bf 00 00 00 00       	mov    $0x0,%edi
  80438a:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  804391:	00 00 00 
  804394:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80439a:	48 89 c7             	mov    %rax,%rdi
  80439d:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8043a4:	00 00 00 
  8043a7:	ff d0                	callq  *%rax
  8043a9:	48 89 c6             	mov    %rax,%rsi
  8043ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8043b1:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8043b8:	00 00 00 
  8043bb:	ff d0                	callq  *%rax
}
  8043bd:	c9                   	leaveq 
  8043be:	c3                   	retq   
	...

00000000008043c0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043c0:	55                   	push   %rbp
  8043c1:	48 89 e5             	mov    %rsp,%rbp
  8043c4:	48 83 ec 20          	sub    $0x20,%rsp
  8043c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ce:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043d1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043d5:	be 01 00 00 00       	mov    $0x1,%esi
  8043da:	48 89 c7             	mov    %rax,%rdi
  8043dd:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8043e4:	00 00 00 
  8043e7:	ff d0                	callq  *%rax
}
  8043e9:	c9                   	leaveq 
  8043ea:	c3                   	retq   

00000000008043eb <getchar>:

int
getchar(void)
{
  8043eb:	55                   	push   %rbp
  8043ec:	48 89 e5             	mov    %rsp,%rbp
  8043ef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043f3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8043fc:	48 89 c6             	mov    %rax,%rsi
  8043ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804404:	48 b8 d4 22 80 00 00 	movabs $0x8022d4,%rax
  80440b:	00 00 00 
  80440e:	ff d0                	callq  *%rax
  804410:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804417:	79 05                	jns    80441e <getchar+0x33>
		return r;
  804419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441c:	eb 14                	jmp    804432 <getchar+0x47>
	if (r < 1)
  80441e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804422:	7f 07                	jg     80442b <getchar+0x40>
		return -E_EOF;
  804424:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804429:	eb 07                	jmp    804432 <getchar+0x47>
	return c;
  80442b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80442f:	0f b6 c0             	movzbl %al,%eax
}
  804432:	c9                   	leaveq 
  804433:	c3                   	retq   

0000000000804434 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804434:	55                   	push   %rbp
  804435:	48 89 e5             	mov    %rsp,%rbp
  804438:	48 83 ec 20          	sub    $0x20,%rsp
  80443c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80443f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804443:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804446:	48 89 d6             	mov    %rdx,%rsi
  804449:	89 c7                	mov    %eax,%edi
  80444b:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  804452:	00 00 00 
  804455:	ff d0                	callq  *%rax
  804457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80445a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80445e:	79 05                	jns    804465 <iscons+0x31>
		return r;
  804460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804463:	eb 1a                	jmp    80447f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804469:	8b 10                	mov    (%rax),%edx
  80446b:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804472:	00 00 00 
  804475:	8b 00                	mov    (%rax),%eax
  804477:	39 c2                	cmp    %eax,%edx
  804479:	0f 94 c0             	sete   %al
  80447c:	0f b6 c0             	movzbl %al,%eax
}
  80447f:	c9                   	leaveq 
  804480:	c3                   	retq   

0000000000804481 <opencons>:

int
opencons(void)
{
  804481:	55                   	push   %rbp
  804482:	48 89 e5             	mov    %rsp,%rbp
  804485:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804489:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80448d:	48 89 c7             	mov    %rax,%rdi
  804490:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax
  80449c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80449f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044a3:	79 05                	jns    8044aa <opencons+0x29>
		return r;
  8044a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a8:	eb 5b                	jmp    804505 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8044b3:	48 89 c6             	mov    %rax,%rsi
  8044b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8044bb:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8044c2:	00 00 00 
  8044c5:	ff d0                	callq  *%rax
  8044c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ce:	79 05                	jns    8044d5 <opencons+0x54>
		return r;
  8044d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d3:	eb 30                	jmp    804505 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d9:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044e0:	00 00 00 
  8044e3:	8b 12                	mov    (%rdx),%edx
  8044e5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f6:	48 89 c7             	mov    %rax,%rdi
  8044f9:	48 b8 bc 1d 80 00 00 	movabs $0x801dbc,%rax
  804500:	00 00 00 
  804503:	ff d0                	callq  *%rax
}
  804505:	c9                   	leaveq 
  804506:	c3                   	retq   

0000000000804507 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804507:	55                   	push   %rbp
  804508:	48 89 e5             	mov    %rsp,%rbp
  80450b:	48 83 ec 30          	sub    $0x30,%rsp
  80450f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804513:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804517:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80451b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804520:	75 13                	jne    804535 <devcons_read+0x2e>
		return 0;
  804522:	b8 00 00 00 00       	mov    $0x0,%eax
  804527:	eb 49                	jmp    804572 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804529:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  804530:	00 00 00 
  804533:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804535:	48 b8 6e 19 80 00 00 	movabs $0x80196e,%rax
  80453c:	00 00 00 
  80453f:	ff d0                	callq  *%rax
  804541:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804548:	74 df                	je     804529 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80454a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80454e:	79 05                	jns    804555 <devcons_read+0x4e>
		return c;
  804550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804553:	eb 1d                	jmp    804572 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804555:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804559:	75 07                	jne    804562 <devcons_read+0x5b>
		return 0;
  80455b:	b8 00 00 00 00       	mov    $0x0,%eax
  804560:	eb 10                	jmp    804572 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804565:	89 c2                	mov    %eax,%edx
  804567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80456b:	88 10                	mov    %dl,(%rax)
	return 1;
  80456d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804572:	c9                   	leaveq 
  804573:	c3                   	retq   

0000000000804574 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804574:	55                   	push   %rbp
  804575:	48 89 e5             	mov    %rsp,%rbp
  804578:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80457f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804586:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80458d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80459b:	eb 77                	jmp    804614 <devcons_write+0xa0>
		m = n - tot;
  80459d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045a4:	89 c2                	mov    %eax,%edx
  8045a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a9:	89 d1                	mov    %edx,%ecx
  8045ab:	29 c1                	sub    %eax,%ecx
  8045ad:	89 c8                	mov    %ecx,%eax
  8045af:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045b5:	83 f8 7f             	cmp    $0x7f,%eax
  8045b8:	76 07                	jbe    8045c1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8045ba:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045c4:	48 63 d0             	movslq %eax,%rdx
  8045c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ca:	48 98                	cltq   
  8045cc:	48 89 c1             	mov    %rax,%rcx
  8045cf:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8045d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045dd:	48 89 ce             	mov    %rcx,%rsi
  8045e0:	48 89 c7             	mov    %rax,%rdi
  8045e3:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8045ea:	00 00 00 
  8045ed:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045f2:	48 63 d0             	movslq %eax,%rdx
  8045f5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045fc:	48 89 d6             	mov    %rdx,%rsi
  8045ff:	48 89 c7             	mov    %rax,%rdi
  804602:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  804609:	00 00 00 
  80460c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80460e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804611:	01 45 fc             	add    %eax,-0x4(%rbp)
  804614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804617:	48 98                	cltq   
  804619:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804620:	0f 82 77 ff ff ff    	jb     80459d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804626:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804629:	c9                   	leaveq 
  80462a:	c3                   	retq   

000000000080462b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80462b:	55                   	push   %rbp
  80462c:	48 89 e5             	mov    %rsp,%rbp
  80462f:	48 83 ec 08          	sub    $0x8,%rsp
  804633:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80463c:	c9                   	leaveq 
  80463d:	c3                   	retq   

000000000080463e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80463e:	55                   	push   %rbp
  80463f:	48 89 e5             	mov    %rsp,%rbp
  804642:	48 83 ec 10          	sub    $0x10,%rsp
  804646:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80464a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80464e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804652:	48 be 2b 51 80 00 00 	movabs $0x80512b,%rsi
  804659:	00 00 00 
  80465c:	48 89 c7             	mov    %rax,%rdi
  80465f:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  804666:	00 00 00 
  804669:	ff d0                	callq  *%rax
	return 0;
  80466b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804670:	c9                   	leaveq 
  804671:	c3                   	retq   
	...

0000000000804674 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804674:	55                   	push   %rbp
  804675:	48 89 e5             	mov    %rsp,%rbp
  804678:	48 83 ec 30          	sub    $0x30,%rsp
  80467c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804680:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804684:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804688:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80468f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804694:	74 18                	je     8046ae <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  804696:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80469a:	48 89 c7             	mov    %rax,%rdi
  80469d:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  8046a4:	00 00 00 
  8046a7:	ff d0                	callq  *%rax
  8046a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ac:	eb 19                	jmp    8046c7 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8046ae:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8046b5:	00 00 00 
  8046b8:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  8046bf:	00 00 00 
  8046c2:	ff d0                	callq  *%rax
  8046c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8046c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046cb:	79 39                	jns    804706 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8046cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046d2:	75 08                	jne    8046dc <ipc_recv+0x68>
  8046d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d8:	8b 00                	mov    (%rax),%eax
  8046da:	eb 05                	jmp    8046e1 <ipc_recv+0x6d>
  8046dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046e5:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8046e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046ec:	75 08                	jne    8046f6 <ipc_recv+0x82>
  8046ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f2:	8b 00                	mov    (%rax),%eax
  8046f4:	eb 05                	jmp    8046fb <ipc_recv+0x87>
  8046f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8046ff:	89 02                	mov    %eax,(%rdx)
		return r;
  804701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804704:	eb 53                	jmp    804759 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  804706:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80470b:	74 19                	je     804726 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  80470d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804714:	00 00 00 
  804717:	48 8b 00             	mov    (%rax),%rax
  80471a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804724:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  804726:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80472b:	74 19                	je     804746 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  80472d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804734:	00 00 00 
  804737:	48 8b 00             	mov    (%rax),%rax
  80473a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804744:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  804746:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80474d:	00 00 00 
  804750:	48 8b 00             	mov    (%rax),%rax
  804753:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804759:	c9                   	leaveq 
  80475a:	c3                   	retq   

000000000080475b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80475b:	55                   	push   %rbp
  80475c:	48 89 e5             	mov    %rsp,%rbp
  80475f:	48 83 ec 30          	sub    $0x30,%rsp
  804763:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804766:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804769:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80476d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  804770:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  804777:	eb 59                	jmp    8047d2 <ipc_send+0x77>
		if(pg) {
  804779:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80477e:	74 20                	je     8047a0 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804780:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804783:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804786:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80478a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80478d:	89 c7                	mov    %eax,%edi
  80478f:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  804796:	00 00 00 
  804799:	ff d0                	callq  *%rax
  80479b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80479e:	eb 26                	jmp    8047c6 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8047a0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8047a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047a9:	89 d1                	mov    %edx,%ecx
  8047ab:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8047b2:	00 00 00 
  8047b5:	89 c7                	mov    %eax,%edi
  8047b7:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  8047be:	00 00 00 
  8047c1:	ff d0                	callq  *%rax
  8047c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8047c6:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  8047cd:	00 00 00 
  8047d0:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8047d2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047d6:	74 a1                	je     804779 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8047d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047dc:	74 2a                	je     804808 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8047de:	48 ba 38 51 80 00 00 	movabs $0x805138,%rdx
  8047e5:	00 00 00 
  8047e8:	be 49 00 00 00       	mov    $0x49,%esi
  8047ed:	48 bf 63 51 80 00 00 	movabs $0x805163,%rdi
  8047f4:	00 00 00 
  8047f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8047fc:	48 b9 28 03 80 00 00 	movabs $0x800328,%rcx
  804803:	00 00 00 
  804806:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804808:	c9                   	leaveq 
  804809:	c3                   	retq   

000000000080480a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80480a:	55                   	push   %rbp
  80480b:	48 89 e5             	mov    %rsp,%rbp
  80480e:	48 83 ec 18          	sub    $0x18,%rsp
  804812:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80481c:	eb 6a                	jmp    804888 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80481e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804825:	00 00 00 
  804828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482b:	48 63 d0             	movslq %eax,%rdx
  80482e:	48 89 d0             	mov    %rdx,%rax
  804831:	48 c1 e0 02          	shl    $0x2,%rax
  804835:	48 01 d0             	add    %rdx,%rax
  804838:	48 01 c0             	add    %rax,%rax
  80483b:	48 01 d0             	add    %rdx,%rax
  80483e:	48 c1 e0 05          	shl    $0x5,%rax
  804842:	48 01 c8             	add    %rcx,%rax
  804845:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80484b:	8b 00                	mov    (%rax),%eax
  80484d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804850:	75 32                	jne    804884 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804852:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804859:	00 00 00 
  80485c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80485f:	48 63 d0             	movslq %eax,%rdx
  804862:	48 89 d0             	mov    %rdx,%rax
  804865:	48 c1 e0 02          	shl    $0x2,%rax
  804869:	48 01 d0             	add    %rdx,%rax
  80486c:	48 01 c0             	add    %rax,%rax
  80486f:	48 01 d0             	add    %rdx,%rax
  804872:	48 c1 e0 05          	shl    $0x5,%rax
  804876:	48 01 c8             	add    %rcx,%rax
  804879:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80487f:	8b 40 08             	mov    0x8(%rax),%eax
  804882:	eb 12                	jmp    804896 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804884:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804888:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80488f:	7e 8d                	jle    80481e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804891:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804896:	c9                   	leaveq 
  804897:	c3                   	retq   

0000000000804898 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804898:	55                   	push   %rbp
  804899:	48 89 e5             	mov    %rsp,%rbp
  80489c:	48 83 ec 18          	sub    $0x18,%rsp
  8048a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8048a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a8:	48 89 c2             	mov    %rax,%rdx
  8048ab:	48 c1 ea 15          	shr    $0x15,%rdx
  8048af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8048b6:	01 00 00 
  8048b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048bd:	83 e0 01             	and    $0x1,%eax
  8048c0:	48 85 c0             	test   %rax,%rax
  8048c3:	75 07                	jne    8048cc <pageref+0x34>
		return 0;
  8048c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ca:	eb 53                	jmp    80491f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048d0:	48 89 c2             	mov    %rax,%rdx
  8048d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048de:	01 00 00 
  8048e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048ed:	83 e0 01             	and    $0x1,%eax
  8048f0:	48 85 c0             	test   %rax,%rax
  8048f3:	75 07                	jne    8048fc <pageref+0x64>
		return 0;
  8048f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8048fa:	eb 23                	jmp    80491f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804900:	48 89 c2             	mov    %rax,%rdx
  804903:	48 c1 ea 0c          	shr    $0xc,%rdx
  804907:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80490e:	00 00 00 
  804911:	48 c1 e2 04          	shl    $0x4,%rdx
  804915:	48 01 d0             	add    %rdx,%rax
  804918:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80491c:	0f b7 c0             	movzwl %ax,%eax
}
  80491f:	c9                   	leaveq 
  804920:	c3                   	retq   
