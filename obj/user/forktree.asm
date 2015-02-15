
obj/user/forktree.debug:     file format elf64-x86-64


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
  80003c:	e8 2b 01 00 00       	callq  80016c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 f0                	mov    %esi,%eax
  800052:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	83 f8 02             	cmp    $0x2,%eax
  80006b:	7f 67                	jg     8000d4 <forkchild+0x90>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006d:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800071:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800075:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800079:	41 89 c8             	mov    %ecx,%r8d
  80007c:	48 89 d1             	mov    %rdx,%rcx
  80007f:	48 ba c0 44 80 00 00 	movabs $0x8044c0,%rdx
  800086:	00 00 00 
  800089:	be 04 00 00 00       	mov    $0x4,%esi
  80008e:	48 89 c7             	mov    %rax,%rdi
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	49 b9 e1 0d 80 00 00 	movabs $0x800de1,%r9
  80009d:	00 00 00 
  8000a0:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a3:	48 b8 7e 1f 80 00 00 	movabs $0x801f7e,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	75 22                	jne    8000d5 <forkchild+0x91>
		forktree(nxt);
  8000b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b7:	48 89 c7             	mov    %rax,%rdi
  8000ba:	48 b8 d7 00 80 00 00 	movabs $0x8000d7,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		exit();
  8000c6:	48 b8 14 02 80 00 00 	movabs $0x800214,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
  8000d2:	eb 01                	jmp    8000d5 <forkchild+0x91>
forkchild(const char *cur, char branch)
{
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
		return;
  8000d4:	90                   	nop
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}
  8000d5:	c9                   	leaveq 
  8000d6:	c3                   	retq   

00000000008000d7 <forktree>:

void
forktree(const char *cur)
{
  8000d7:	55                   	push   %rbp
  8000d8:	48 89 e5             	mov    %rsp,%rbp
  8000db:	48 83 ec 10          	sub    $0x10,%rsp
  8000df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000e3:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf c5 44 80 00 00 	movabs $0x8044c5,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 5f 03 80 00 00 	movabs $0x80035f,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  800110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800114:	be 30 00 00 00       	mov    $0x30,%esi
  800119:	48 89 c7             	mov    %rax,%rdi
  80011c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80012c:	be 31 00 00 00       	mov    $0x31,%esi
  800131:	48 89 c7             	mov    %rax,%rdi
  800134:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	callq  *%rax
}
  800140:	c9                   	leaveq 
  800141:	c3                   	retq   

0000000000800142 <umain>:

void
umain(int argc, char **argv)
{
  800142:	55                   	push   %rbp
  800143:	48 89 e5             	mov    %rsp,%rbp
  800146:	48 83 ec 10          	sub    $0x10,%rsp
  80014a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  800151:	48 bf d6 44 80 00 00 	movabs $0x8044d6,%rdi
  800158:	00 00 00 
  80015b:	48 b8 d7 00 80 00 00 	movabs $0x8000d7,%rax
  800162:	00 00 00 
  800165:	ff d0                	callq  *%rax
}
  800167:	c9                   	leaveq 
  800168:	c3                   	retq   
  800169:	00 00                	add    %al,(%rax)
	...

000000000080016c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %rbp
  80016d:	48 89 e5             	mov    %rsp,%rbp
  800170:	48 83 ec 10          	sub    $0x10,%rsp
  800174:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800177:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80017b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800182:	00 00 00 
  800185:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80018c:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
  800198:	48 98                	cltq   
  80019a:	48 89 c2             	mov    %rax,%rdx
  80019d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001a3:	48 89 d0             	mov    %rdx,%rax
  8001a6:	48 c1 e0 02          	shl    $0x2,%rax
  8001aa:	48 01 d0             	add    %rdx,%rax
  8001ad:	48 01 c0             	add    %rax,%rax
  8001b0:	48 01 d0             	add    %rdx,%rax
  8001b3:	48 c1 e0 05          	shl    $0x5,%rax
  8001b7:	48 89 c2             	mov    %rax,%rdx
  8001ba:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001c1:	00 00 00 
  8001c4:	48 01 c2             	add    %rax,%rdx
  8001c7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ce:	00 00 00 
  8001d1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d8:	7e 14                	jle    8001ee <libmain+0x82>
		binaryname = argv[0];
  8001da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001de:	48 8b 10             	mov    (%rax),%rdx
  8001e1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001e8:	00 00 00 
  8001eb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f5:	48 89 d6             	mov    %rdx,%rsi
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800206:	48 b8 14 02 80 00 00 	movabs $0x800214,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
}
  800212:	c9                   	leaveq 
  800213:	c3                   	retq   

0000000000800214 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800218:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800224:	bf 00 00 00 00       	mov    $0x0,%edi
  800229:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
}
  800235:	5d                   	pop    %rbp
  800236:	c3                   	retq   
	...

0000000000800238 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800238:	55                   	push   %rbp
  800239:	48 89 e5             	mov    %rsp,%rbp
  80023c:	48 83 ec 10          	sub    $0x10,%rsp
  800240:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800243:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024b:	8b 00                	mov    (%rax),%eax
  80024d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800250:	89 d6                	mov    %edx,%esi
  800252:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800256:	48 63 d0             	movslq %eax,%rdx
  800259:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80025e:	8d 50 01             	lea    0x1(%rax),%edx
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026b:	8b 00                	mov    (%rax),%eax
  80026d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800272:	75 2c                	jne    8002a0 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800278:	8b 00                	mov    (%rax),%eax
  80027a:	48 98                	cltq   
  80027c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800280:	48 83 c2 08          	add    $0x8,%rdx
  800284:	48 89 c6             	mov    %rax,%rsi
  800287:	48 89 d7             	mov    %rdx,%rdi
  80028a:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax
        b->idx = 0;
  800296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a4:	8b 40 04             	mov    0x4(%rax),%eax
  8002a7:	8d 50 01             	lea    0x1(%rax),%edx
  8002aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ae:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002b1:	c9                   	leaveq 
  8002b2:	c3                   	retq   

00000000008002b3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002b3:	55                   	push   %rbp
  8002b4:	48 89 e5             	mov    %rsp,%rbp
  8002b7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002be:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002c5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002cc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002d3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002da:	48 8b 0a             	mov    (%rdx),%rcx
  8002dd:	48 89 08             	mov    %rcx,(%rax)
  8002e0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ec:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002f7:	00 00 00 
    b.cnt = 0;
  8002fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800301:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800304:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80030b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800312:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800319:	48 89 c6             	mov    %rax,%rsi
  80031c:	48 bf 38 02 80 00 00 	movabs $0x800238,%rdi
  800323:	00 00 00 
  800326:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800332:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800338:	48 98                	cltq   
  80033a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800341:	48 83 c2 08          	add    $0x8,%rdx
  800345:	48 89 c6             	mov    %rax,%rsi
  800348:	48 89 d7             	mov    %rdx,%rdi
  80034b:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800357:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80035d:	c9                   	leaveq 
  80035e:	c3                   	retq   

000000000080035f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80035f:	55                   	push   %rbp
  800360:	48 89 e5             	mov    %rsp,%rbp
  800363:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80036a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800371:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800378:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80037f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800386:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80038d:	84 c0                	test   %al,%al
  80038f:	74 20                	je     8003b1 <cprintf+0x52>
  800391:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800395:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800399:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80039d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003b8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003bf:	00 00 00 
  8003c2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003c9:	00 00 00 
  8003cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003de:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003e5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003f3:	48 8b 0a             	mov    (%rdx),%rcx
  8003f6:	48 89 08             	mov    %rcx,(%rax)
  8003f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800401:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800405:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800409:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800410:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800417:	48 89 d6             	mov    %rdx,%rsi
  80041a:	48 89 c7             	mov    %rax,%rdi
  80041d:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
  800429:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80042f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   
	...

0000000000800438 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800438:	55                   	push   %rbp
  800439:	48 89 e5             	mov    %rsp,%rbp
  80043c:	48 83 ec 30          	sub    $0x30,%rsp
  800440:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800444:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800448:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80044c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80044f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800453:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800457:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80045a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80045e:	77 52                	ja     8004b2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800460:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800463:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800467:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80046a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80046e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
  800477:	48 f7 75 d0          	divq   -0x30(%rbp)
  80047b:	48 89 c2             	mov    %rax,%rdx
  80047e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800481:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800484:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80048c:	41 89 f9             	mov    %edi,%r9d
  80048f:	48 89 c7             	mov    %rax,%rdi
  800492:	48 b8 38 04 80 00 00 	movabs $0x800438,%rax
  800499:	00 00 00 
  80049c:	ff d0                	callq  *%rax
  80049e:	eb 1c                	jmp    8004bc <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004ab:	48 89 d6             	mov    %rdx,%rsi
  8004ae:	89 c7                	mov    %eax,%edi
  8004b0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8004b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8004ba:	7f e4                	jg     8004a0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c8:	48 f7 f1             	div    %rcx
  8004cb:	48 89 d0             	mov    %rdx,%rax
  8004ce:	48 ba f0 46 80 00 00 	movabs $0x8046f0,%rdx
  8004d5:	00 00 00 
  8004d8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004dc:	0f be c0             	movsbl %al,%eax
  8004df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004e7:	48 89 d6             	mov    %rdx,%rsi
  8004ea:	89 c7                	mov    %eax,%edi
  8004ec:	ff d1                	callq  *%rcx
}
  8004ee:	c9                   	leaveq 
  8004ef:	c3                   	retq   

00000000008004f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004f0:	55                   	push   %rbp
  8004f1:	48 89 e5             	mov    %rsp,%rbp
  8004f4:	48 83 ec 20          	sub    $0x20,%rsp
  8004f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800503:	7e 52                	jle    800557 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800509:	8b 00                	mov    (%rax),%eax
  80050b:	83 f8 30             	cmp    $0x30,%eax
  80050e:	73 24                	jae    800534 <getuint+0x44>
  800510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800514:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	8b 00                	mov    (%rax),%eax
  80051e:	89 c0                	mov    %eax,%eax
  800520:	48 01 d0             	add    %rdx,%rax
  800523:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800527:	8b 12                	mov    (%rdx),%edx
  800529:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80052c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800530:	89 0a                	mov    %ecx,(%rdx)
  800532:	eb 17                	jmp    80054b <getuint+0x5b>
  800534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800538:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80053c:	48 89 d0             	mov    %rdx,%rax
  80053f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800547:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054b:	48 8b 00             	mov    (%rax),%rax
  80054e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800552:	e9 a3 00 00 00       	jmpq   8005fa <getuint+0x10a>
	else if (lflag)
  800557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80055b:	74 4f                	je     8005ac <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80055d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800561:	8b 00                	mov    (%rax),%eax
  800563:	83 f8 30             	cmp    $0x30,%eax
  800566:	73 24                	jae    80058c <getuint+0x9c>
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800574:	8b 00                	mov    (%rax),%eax
  800576:	89 c0                	mov    %eax,%eax
  800578:	48 01 d0             	add    %rdx,%rax
  80057b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057f:	8b 12                	mov    (%rdx),%edx
  800581:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	89 0a                	mov    %ecx,(%rdx)
  80058a:	eb 17                	jmp    8005a3 <getuint+0xb3>
  80058c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800590:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800594:	48 89 d0             	mov    %rdx,%rax
  800597:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80059b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a3:	48 8b 00             	mov    (%rax),%rax
  8005a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005aa:	eb 4e                	jmp    8005fa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	8b 00                	mov    (%rax),%eax
  8005b2:	83 f8 30             	cmp    $0x30,%eax
  8005b5:	73 24                	jae    8005db <getuint+0xeb>
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	8b 00                	mov    (%rax),%eax
  8005c5:	89 c0                	mov    %eax,%eax
  8005c7:	48 01 d0             	add    %rdx,%rax
  8005ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ce:	8b 12                	mov    (%rdx),%edx
  8005d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d7:	89 0a                	mov    %ecx,(%rdx)
  8005d9:	eb 17                	jmp    8005f2 <getuint+0x102>
  8005db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e3:	48 89 d0             	mov    %rdx,%rax
  8005e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f2:	8b 00                	mov    (%rax),%eax
  8005f4:	89 c0                	mov    %eax,%eax
  8005f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005fe:	c9                   	leaveq 
  8005ff:	c3                   	retq   

0000000000800600 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	48 83 ec 20          	sub    $0x20,%rsp
  800608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80060f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800613:	7e 52                	jle    800667 <getint+0x67>
		x=va_arg(*ap, long long);
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	83 f8 30             	cmp    $0x30,%eax
  80061e:	73 24                	jae    800644 <getint+0x44>
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	89 c0                	mov    %eax,%eax
  800630:	48 01 d0             	add    %rdx,%rax
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	8b 12                	mov    (%rdx),%edx
  800639:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	89 0a                	mov    %ecx,(%rdx)
  800642:	eb 17                	jmp    80065b <getint+0x5b>
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064c:	48 89 d0             	mov    %rdx,%rax
  80064f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065b:	48 8b 00             	mov    (%rax),%rax
  80065e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800662:	e9 a3 00 00 00       	jmpq   80070a <getint+0x10a>
	else if (lflag)
  800667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066b:	74 4f                	je     8006bc <getint+0xbc>
		x=va_arg(*ap, long);
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	83 f8 30             	cmp    $0x30,%eax
  800676:	73 24                	jae    80069c <getint+0x9c>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	89 c0                	mov    %eax,%eax
  800688:	48 01 d0             	add    %rdx,%rax
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	8b 12                	mov    (%rdx),%edx
  800691:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800694:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800698:	89 0a                	mov    %ecx,(%rdx)
  80069a:	eb 17                	jmp    8006b3 <getint+0xb3>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a4:	48 89 d0             	mov    %rdx,%rax
  8006a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b3:	48 8b 00             	mov    (%rax),%rax
  8006b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ba:	eb 4e                	jmp    80070a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c0:	8b 00                	mov    (%rax),%eax
  8006c2:	83 f8 30             	cmp    $0x30,%eax
  8006c5:	73 24                	jae    8006eb <getint+0xeb>
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	8b 00                	mov    (%rax),%eax
  8006d5:	89 c0                	mov    %eax,%eax
  8006d7:	48 01 d0             	add    %rdx,%rax
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	8b 12                	mov    (%rdx),%edx
  8006e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	89 0a                	mov    %ecx,(%rdx)
  8006e9:	eb 17                	jmp    800702 <getint+0x102>
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f3:	48 89 d0             	mov    %rdx,%rax
  8006f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800702:	8b 00                	mov    (%rax),%eax
  800704:	48 98                	cltq   
  800706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80070a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80070e:	c9                   	leaveq 
  80070f:	c3                   	retq   

0000000000800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	41 54                	push   %r12
  800716:	53                   	push   %rbx
  800717:	48 83 ec 60          	sub    $0x60,%rsp
  80071b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80071f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800723:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800727:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80072b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80072f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800733:	48 8b 0a             	mov    (%rdx),%rcx
  800736:	48 89 08             	mov    %rcx,(%rax)
  800739:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80073d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800741:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800745:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800749:	eb 17                	jmp    800762 <vprintfmt+0x52>
			if (ch == '\0')
  80074b:	85 db                	test   %ebx,%ebx
  80074d:	0f 84 ea 04 00 00    	je     800c3d <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800753:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800757:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80075b:	48 89 c6             	mov    %rax,%rsi
  80075e:	89 df                	mov    %ebx,%edi
  800760:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800766:	0f b6 00             	movzbl (%rax),%eax
  800769:	0f b6 d8             	movzbl %al,%ebx
  80076c:	83 fb 25             	cmp    $0x25,%ebx
  80076f:	0f 95 c0             	setne  %al
  800772:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800777:	84 c0                	test   %al,%al
  800779:	75 d0                	jne    80074b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80077f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800786:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80078d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800794:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80079b:	eb 04                	jmp    8007a1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80079d:	90                   	nop
  80079e:	eb 01                	jmp    8007a1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8007a0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007a5:	0f b6 00             	movzbl (%rax),%eax
  8007a8:	0f b6 d8             	movzbl %al,%ebx
  8007ab:	89 d8                	mov    %ebx,%eax
  8007ad:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007b2:	83 e8 23             	sub    $0x23,%eax
  8007b5:	83 f8 55             	cmp    $0x55,%eax
  8007b8:	0f 87 4b 04 00 00    	ja     800c09 <vprintfmt+0x4f9>
  8007be:	89 c0                	mov    %eax,%eax
  8007c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007c7:	00 
  8007c8:	48 b8 18 47 80 00 00 	movabs $0x804718,%rax
  8007cf:	00 00 00 
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007da:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007de:	eb c1                	jmp    8007a1 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007e0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007e4:	eb bb                	jmp    8007a1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007ed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007f0:	89 d0                	mov    %edx,%eax
  8007f2:	c1 e0 02             	shl    $0x2,%eax
  8007f5:	01 d0                	add    %edx,%eax
  8007f7:	01 c0                	add    %eax,%eax
  8007f9:	01 d8                	add    %ebx,%eax
  8007fb:	83 e8 30             	sub    $0x30,%eax
  8007fe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800801:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800805:	0f b6 00             	movzbl (%rax),%eax
  800808:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80080b:	83 fb 2f             	cmp    $0x2f,%ebx
  80080e:	7e 63                	jle    800873 <vprintfmt+0x163>
  800810:	83 fb 39             	cmp    $0x39,%ebx
  800813:	7f 5e                	jg     800873 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800815:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80081a:	eb d1                	jmp    8007ed <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80081c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081f:	83 f8 30             	cmp    $0x30,%eax
  800822:	73 17                	jae    80083b <vprintfmt+0x12b>
  800824:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800828:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082b:	89 c0                	mov    %eax,%eax
  80082d:	48 01 d0             	add    %rdx,%rax
  800830:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800833:	83 c2 08             	add    $0x8,%edx
  800836:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x13a>
  80083b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80083f:	48 89 d0             	mov    %rdx,%rax
  800842:	48 83 c2 08          	add    $0x8,%rdx
  800846:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80084a:	8b 00                	mov    (%rax),%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80084f:	eb 23                	jmp    800874 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800851:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800855:	0f 89 42 ff ff ff    	jns    80079d <vprintfmt+0x8d>
				width = 0;
  80085b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800862:	e9 36 ff ff ff       	jmpq   80079d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800867:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80086e:	e9 2e ff ff ff       	jmpq   8007a1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800873:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800874:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800878:	0f 89 22 ff ff ff    	jns    8007a0 <vprintfmt+0x90>
				width = precision, precision = -1;
  80087e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800881:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800884:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80088b:	e9 10 ff ff ff       	jmpq   8007a0 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800890:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800894:	e9 08 ff ff ff       	jmpq   8007a1 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800899:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089c:	83 f8 30             	cmp    $0x30,%eax
  80089f:	73 17                	jae    8008b8 <vprintfmt+0x1a8>
  8008a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a8:	89 c0                	mov    %eax,%eax
  8008aa:	48 01 d0             	add    %rdx,%rax
  8008ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b0:	83 c2 08             	add    $0x8,%edx
  8008b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b6:	eb 0f                	jmp    8008c7 <vprintfmt+0x1b7>
  8008b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bc:	48 89 d0             	mov    %rdx,%rax
  8008bf:	48 83 c2 08          	add    $0x8,%rdx
  8008c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c7:	8b 00                	mov    (%rax),%eax
  8008c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008cd:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8008d1:	48 89 d6             	mov    %rdx,%rsi
  8008d4:	89 c7                	mov    %eax,%edi
  8008d6:	ff d1                	callq  *%rcx
			break;
  8008d8:	e9 5a 03 00 00       	jmpq   800c37 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e0:	83 f8 30             	cmp    $0x30,%eax
  8008e3:	73 17                	jae    8008fc <vprintfmt+0x1ec>
  8008e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ec:	89 c0                	mov    %eax,%eax
  8008ee:	48 01 d0             	add    %rdx,%rax
  8008f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f4:	83 c2 08             	add    $0x8,%edx
  8008f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008fa:	eb 0f                	jmp    80090b <vprintfmt+0x1fb>
  8008fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800900:	48 89 d0             	mov    %rdx,%rax
  800903:	48 83 c2 08          	add    $0x8,%rdx
  800907:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80090b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80090d:	85 db                	test   %ebx,%ebx
  80090f:	79 02                	jns    800913 <vprintfmt+0x203>
				err = -err;
  800911:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800913:	83 fb 15             	cmp    $0x15,%ebx
  800916:	7f 16                	jg     80092e <vprintfmt+0x21e>
  800918:	48 b8 40 46 80 00 00 	movabs $0x804640,%rax
  80091f:	00 00 00 
  800922:	48 63 d3             	movslq %ebx,%rdx
  800925:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800929:	4d 85 e4             	test   %r12,%r12
  80092c:	75 2e                	jne    80095c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80092e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800932:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800936:	89 d9                	mov    %ebx,%ecx
  800938:	48 ba 01 47 80 00 00 	movabs $0x804701,%rdx
  80093f:	00 00 00 
  800942:	48 89 c7             	mov    %rax,%rdi
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	49 b8 47 0c 80 00 00 	movabs $0x800c47,%r8
  800951:	00 00 00 
  800954:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800957:	e9 db 02 00 00       	jmpq   800c37 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80095c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800960:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800964:	4c 89 e1             	mov    %r12,%rcx
  800967:	48 ba 0a 47 80 00 00 	movabs $0x80470a,%rdx
  80096e:	00 00 00 
  800971:	48 89 c7             	mov    %rax,%rdi
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
  800979:	49 b8 47 0c 80 00 00 	movabs $0x800c47,%r8
  800980:	00 00 00 
  800983:	41 ff d0             	callq  *%r8
			break;
  800986:	e9 ac 02 00 00       	jmpq   800c37 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80098b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098e:	83 f8 30             	cmp    $0x30,%eax
  800991:	73 17                	jae    8009aa <vprintfmt+0x29a>
  800993:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800997:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a2:	83 c2 08             	add    $0x8,%edx
  8009a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x2a9>
  8009aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ae:	48 89 d0             	mov    %rdx,%rax
  8009b1:	48 83 c2 08          	add    $0x8,%rdx
  8009b5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b9:	4c 8b 20             	mov    (%rax),%r12
  8009bc:	4d 85 e4             	test   %r12,%r12
  8009bf:	75 0a                	jne    8009cb <vprintfmt+0x2bb>
				p = "(null)";
  8009c1:	49 bc 0d 47 80 00 00 	movabs $0x80470d,%r12
  8009c8:	00 00 00 
			if (width > 0 && padc != '-')
  8009cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cf:	7e 7a                	jle    800a4b <vprintfmt+0x33b>
  8009d1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009d5:	74 74                	je     800a4b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009da:	48 98                	cltq   
  8009dc:	48 89 c6             	mov    %rax,%rsi
  8009df:	4c 89 e7             	mov    %r12,%rdi
  8009e2:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009f1:	eb 17                	jmp    800a0a <vprintfmt+0x2fa>
					putch(padc, putdat);
  8009f3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8009f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009ff:	48 89 d6             	mov    %rdx,%rsi
  800a02:	89 c7                	mov    %eax,%edi
  800a04:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a06:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0e:	7f e3                	jg     8009f3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a10:	eb 39                	jmp    800a4b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a12:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a16:	74 1e                	je     800a36 <vprintfmt+0x326>
  800a18:	83 fb 1f             	cmp    $0x1f,%ebx
  800a1b:	7e 05                	jle    800a22 <vprintfmt+0x312>
  800a1d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a20:	7e 14                	jle    800a36 <vprintfmt+0x326>
					putch('?', putdat);
  800a22:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a26:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a32:	ff d2                	callq  *%rdx
  800a34:	eb 0f                	jmp    800a45 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800a36:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a3a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a3e:	48 89 c6             	mov    %rax,%rsi
  800a41:	89 df                	mov    %ebx,%edi
  800a43:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a49:	eb 01                	jmp    800a4c <vprintfmt+0x33c>
  800a4b:	90                   	nop
  800a4c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800a51:	0f be d8             	movsbl %al,%ebx
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	0f 95 c0             	setne  %al
  800a59:	49 83 c4 01          	add    $0x1,%r12
  800a5d:	84 c0                	test   %al,%al
  800a5f:	74 28                	je     800a89 <vprintfmt+0x379>
  800a61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a65:	78 ab                	js     800a12 <vprintfmt+0x302>
  800a67:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a6f:	79 a1                	jns    800a12 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a71:	eb 16                	jmp    800a89 <vprintfmt+0x379>
				putch(' ', putdat);
  800a73:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a77:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a7b:	48 89 c6             	mov    %rax,%rsi
  800a7e:	bf 20 00 00 00       	mov    $0x20,%edi
  800a83:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a85:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a89:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a8d:	7f e4                	jg     800a73 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800a8f:	e9 a3 01 00 00       	jmpq   800c37 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a98:	be 03 00 00 00       	mov    $0x3,%esi
  800a9d:	48 89 c7             	mov    %rax,%rdi
  800aa0:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800aa7:	00 00 00 
  800aaa:	ff d0                	callq  *%rax
  800aac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	48 85 c0             	test   %rax,%rax
  800ab7:	79 1d                	jns    800ad6 <vprintfmt+0x3c6>
				putch('-', putdat);
  800ab9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800abd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ac1:	48 89 c6             	mov    %rax,%rsi
  800ac4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ac9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acf:	48 f7 d8             	neg    %rax
  800ad2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ad6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800add:	e9 e8 00 00 00       	jmpq   800bca <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ae2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae6:	be 03 00 00 00       	mov    $0x3,%esi
  800aeb:	48 89 c7             	mov    %rax,%rdi
  800aee:	48 b8 f0 04 80 00 00 	movabs $0x8004f0,%rax
  800af5:	00 00 00 
  800af8:	ff d0                	callq  *%rax
  800afa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800afe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b05:	e9 c0 00 00 00       	jmpq   800bca <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b0a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b0e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b12:	48 89 c6             	mov    %rax,%rsi
  800b15:	bf 58 00 00 00       	mov    $0x58,%edi
  800b1a:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800b1c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b20:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b24:	48 89 c6             	mov    %rax,%rsi
  800b27:	bf 58 00 00 00       	mov    $0x58,%edi
  800b2c:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800b2e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b36:	48 89 c6             	mov    %rax,%rsi
  800b39:	bf 58 00 00 00       	mov    $0x58,%edi
  800b3e:	ff d2                	callq  *%rdx
			break;
  800b40:	e9 f2 00 00 00       	jmpq   800c37 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800b45:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b49:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b4d:	48 89 c6             	mov    %rax,%rsi
  800b50:	bf 30 00 00 00       	mov    $0x30,%edi
  800b55:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800b57:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b5b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b5f:	48 89 c6             	mov    %rax,%rsi
  800b62:	bf 78 00 00 00       	mov    $0x78,%edi
  800b67:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6c:	83 f8 30             	cmp    $0x30,%eax
  800b6f:	73 17                	jae    800b88 <vprintfmt+0x478>
  800b71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b78:	89 c0                	mov    %eax,%eax
  800b7a:	48 01 d0             	add    %rdx,%rax
  800b7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b80:	83 c2 08             	add    $0x8,%edx
  800b83:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b86:	eb 0f                	jmp    800b97 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800b88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b8c:	48 89 d0             	mov    %rdx,%rax
  800b8f:	48 83 c2 08          	add    $0x8,%rdx
  800b93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b97:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ba5:	eb 23                	jmp    800bca <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ba7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bab:	be 03 00 00 00       	mov    $0x3,%esi
  800bb0:	48 89 c7             	mov    %rax,%rdi
  800bb3:	48 b8 f0 04 80 00 00 	movabs $0x8004f0,%rax
  800bba:	00 00 00 
  800bbd:	ff d0                	callq  *%rax
  800bbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bc3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bca:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bcf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bd2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bd5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be1:	45 89 c1             	mov    %r8d,%r9d
  800be4:	41 89 f8             	mov    %edi,%r8d
  800be7:	48 89 c7             	mov    %rax,%rdi
  800bea:	48 b8 38 04 80 00 00 	movabs $0x800438,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	callq  *%rax
			break;
  800bf6:	eb 3f                	jmp    800c37 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bf8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bfc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c00:	48 89 c6             	mov    %rax,%rsi
  800c03:	89 df                	mov    %ebx,%edi
  800c05:	ff d2                	callq  *%rdx
			break;
  800c07:	eb 2e                	jmp    800c37 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c09:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c0d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c11:	48 89 c6             	mov    %rax,%rsi
  800c14:	bf 25 00 00 00       	mov    $0x25,%edi
  800c19:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c1b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c20:	eb 05                	jmp    800c27 <vprintfmt+0x517>
  800c22:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c27:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c2b:	48 83 e8 01          	sub    $0x1,%rax
  800c2f:	0f b6 00             	movzbl (%rax),%eax
  800c32:	3c 25                	cmp    $0x25,%al
  800c34:	75 ec                	jne    800c22 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800c36:	90                   	nop
		}
	}
  800c37:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c38:	e9 25 fb ff ff       	jmpq   800762 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800c3d:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c3e:	48 83 c4 60          	add    $0x60,%rsp
  800c42:	5b                   	pop    %rbx
  800c43:	41 5c                	pop    %r12
  800c45:	5d                   	pop    %rbp
  800c46:	c3                   	retq   

0000000000800c47 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c47:	55                   	push   %rbp
  800c48:	48 89 e5             	mov    %rsp,%rbp
  800c4b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c52:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c59:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c60:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c67:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c6e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c75:	84 c0                	test   %al,%al
  800c77:	74 20                	je     800c99 <printfmt+0x52>
  800c79:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c7d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c81:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c85:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c89:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c8d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c91:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c95:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c99:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ca0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ca7:	00 00 00 
  800caa:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cb1:	00 00 00 
  800cb4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cb8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cbf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cc6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ccd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cd4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cdb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ce2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ce9:	48 89 c7             	mov    %rax,%rdi
  800cec:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800cf3:	00 00 00 
  800cf6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cf8:	c9                   	leaveq 
  800cf9:	c3                   	retq   

0000000000800cfa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cfa:	55                   	push   %rbp
  800cfb:	48 89 e5             	mov    %rsp,%rbp
  800cfe:	48 83 ec 10          	sub    $0x10,%rsp
  800d02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d0d:	8b 40 10             	mov    0x10(%rax),%eax
  800d10:	8d 50 01             	lea    0x1(%rax),%edx
  800d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d17:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d1e:	48 8b 10             	mov    (%rax),%rdx
  800d21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d25:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d29:	48 39 c2             	cmp    %rax,%rdx
  800d2c:	73 17                	jae    800d45 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d32:	48 8b 00             	mov    (%rax),%rax
  800d35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d38:	88 10                	mov    %dl,(%rax)
  800d3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d42:	48 89 10             	mov    %rdx,(%rax)
}
  800d45:	c9                   	leaveq 
  800d46:	c3                   	retq   

0000000000800d47 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d47:	55                   	push   %rbp
  800d48:	48 89 e5             	mov    %rsp,%rbp
  800d4b:	48 83 ec 50          	sub    $0x50,%rsp
  800d4f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d53:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d56:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d5a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d5e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d62:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d66:	48 8b 0a             	mov    (%rdx),%rcx
  800d69:	48 89 08             	mov    %rcx,(%rax)
  800d6c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d70:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d74:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d78:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d80:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d84:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d87:	48 98                	cltq   
  800d89:	48 83 e8 01          	sub    $0x1,%rax
  800d8d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800d91:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d9c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800da1:	74 06                	je     800da9 <vsnprintf+0x62>
  800da3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800da7:	7f 07                	jg     800db0 <vsnprintf+0x69>
		return -E_INVAL;
  800da9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dae:	eb 2f                	jmp    800ddf <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800db0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800db4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800db8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dbc:	48 89 c6             	mov    %rax,%rsi
  800dbf:	48 bf fa 0c 80 00 00 	movabs $0x800cfa,%rdi
  800dc6:	00 00 00 
  800dc9:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800dd0:	00 00 00 
  800dd3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dd9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ddc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ddf:	c9                   	leaveq 
  800de0:	c3                   	retq   

0000000000800de1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de1:	55                   	push   %rbp
  800de2:	48 89 e5             	mov    %rsp,%rbp
  800de5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800df3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800df9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e00:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e07:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e0e:	84 c0                	test   %al,%al
  800e10:	74 20                	je     800e32 <snprintf+0x51>
  800e12:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e16:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e1a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e1e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e22:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e26:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e2a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e2e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e32:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e39:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e40:	00 00 00 
  800e43:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e4a:	00 00 00 
  800e4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e51:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e58:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e5f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e66:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e6d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e74:	48 8b 0a             	mov    (%rdx),%rcx
  800e77:	48 89 08             	mov    %rcx,(%rax)
  800e7a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e7e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e82:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e86:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e8a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e91:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e98:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e9e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ea5:	48 89 c7             	mov    %rax,%rdi
  800ea8:	48 b8 47 0d 80 00 00 	movabs $0x800d47,%rax
  800eaf:	00 00 00 
  800eb2:	ff d0                	callq  *%rax
  800eb4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800eba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ec0:	c9                   	leaveq 
  800ec1:	c3                   	retq   
	...

0000000000800ec4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ec4:	55                   	push   %rbp
  800ec5:	48 89 e5             	mov    %rsp,%rbp
  800ec8:	48 83 ec 18          	sub    $0x18,%rsp
  800ecc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ed7:	eb 09                	jmp    800ee2 <strlen+0x1e>
		n++;
  800ed9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800edd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	0f b6 00             	movzbl (%rax),%eax
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 ec                	jne    800ed9 <strlen+0x15>
		n++;
	return n;
  800eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ef0:	c9                   	leaveq 
  800ef1:	c3                   	retq   

0000000000800ef2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 83 ec 20          	sub    $0x20,%rsp
  800efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f09:	eb 0e                	jmp    800f19 <strnlen+0x27>
		n++;
  800f0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f14:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f19:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f1e:	74 0b                	je     800f2b <strnlen+0x39>
  800f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f24:	0f b6 00             	movzbl (%rax),%eax
  800f27:	84 c0                	test   %al,%al
  800f29:	75 e0                	jne    800f0b <strnlen+0x19>
		n++;
	return n;
  800f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f2e:	c9                   	leaveq 
  800f2f:	c3                   	retq   

0000000000800f30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f30:	55                   	push   %rbp
  800f31:	48 89 e5             	mov    %rsp,%rbp
  800f34:	48 83 ec 20          	sub    $0x20,%rsp
  800f38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f48:	90                   	nop
  800f49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4d:	0f b6 10             	movzbl (%rax),%edx
  800f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f54:	88 10                	mov    %dl,(%rax)
  800f56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5a:	0f b6 00             	movzbl (%rax),%eax
  800f5d:	84 c0                	test   %al,%al
  800f5f:	0f 95 c0             	setne  %al
  800f62:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f67:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800f6c:	84 c0                	test   %al,%al
  800f6e:	75 d9                	jne    800f49 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f74:	c9                   	leaveq 
  800f75:	c3                   	retq   

0000000000800f76 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f76:	55                   	push   %rbp
  800f77:	48 89 e5             	mov    %rsp,%rbp
  800f7a:	48 83 ec 20          	sub    $0x20,%rsp
  800f7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8a:	48 89 c7             	mov    %rax,%rdi
  800f8d:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  800f94:	00 00 00 
  800f97:	ff d0                	callq  *%rax
  800f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f9f:	48 98                	cltq   
  800fa1:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800fa5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa9:	48 89 d6             	mov    %rdx,%rsi
  800fac:	48 89 c7             	mov    %rax,%rdi
  800faf:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  800fb6:	00 00 00 
  800fb9:	ff d0                	callq  *%rax
	return dst;
  800fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 28          	sub    $0x28,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fdd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fe4:	00 
  800fe5:	eb 27                	jmp    80100e <strncpy+0x4d>
		*dst++ = *src;
  800fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800feb:	0f b6 10             	movzbl (%rax),%edx
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	88 10                	mov    %dl,(%rax)
  800ff4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ffd:	0f b6 00             	movzbl (%rax),%eax
  801000:	84 c0                	test   %al,%al
  801002:	74 05                	je     801009 <strncpy+0x48>
			src++;
  801004:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801009:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80100e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801012:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801016:	72 cf                	jb     800fe7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 83 ec 28          	sub    $0x28,%rsp
  801026:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80102e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80103a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80103f:	74 37                	je     801078 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801041:	eb 17                	jmp    80105a <strlcpy+0x3c>
			*dst++ = *src++;
  801043:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801047:	0f b6 10             	movzbl (%rax),%edx
  80104a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104e:	88 10                	mov    %dl,(%rax)
  801050:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801055:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80105a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80105f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801064:	74 0b                	je     801071 <strlcpy+0x53>
  801066:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106a:	0f b6 00             	movzbl (%rax),%eax
  80106d:	84 c0                	test   %al,%al
  80106f:	75 d2                	jne    801043 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801078:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801080:	48 89 d1             	mov    %rdx,%rcx
  801083:	48 29 c1             	sub    %rax,%rcx
  801086:	48 89 c8             	mov    %rcx,%rax
}
  801089:	c9                   	leaveq 
  80108a:	c3                   	retq   

000000000080108b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	48 83 ec 10          	sub    $0x10,%rsp
  801093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801097:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80109b:	eb 0a                	jmp    8010a7 <strcmp+0x1c>
		p++, q++;
  80109d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ab:	0f b6 00             	movzbl (%rax),%eax
  8010ae:	84 c0                	test   %al,%al
  8010b0:	74 12                	je     8010c4 <strcmp+0x39>
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	0f b6 10             	movzbl (%rax),%edx
  8010b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bd:	0f b6 00             	movzbl (%rax),%eax
  8010c0:	38 c2                	cmp    %al,%dl
  8010c2:	74 d9                	je     80109d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c8:	0f b6 00             	movzbl (%rax),%eax
  8010cb:	0f b6 d0             	movzbl %al,%edx
  8010ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	0f b6 c0             	movzbl %al,%eax
  8010d8:	89 d1                	mov    %edx,%ecx
  8010da:	29 c1                	sub    %eax,%ecx
  8010dc:	89 c8                	mov    %ecx,%eax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 18          	sub    $0x18,%rsp
  8010e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010f4:	eb 0f                	jmp    801105 <strncmp+0x25>
		n--, p++, q++;
  8010f6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801100:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801105:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80110a:	74 1d                	je     801129 <strncmp+0x49>
  80110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801110:	0f b6 00             	movzbl (%rax),%eax
  801113:	84 c0                	test   %al,%al
  801115:	74 12                	je     801129 <strncmp+0x49>
  801117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111b:	0f b6 10             	movzbl (%rax),%edx
  80111e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	38 c2                	cmp    %al,%dl
  801127:	74 cd                	je     8010f6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801129:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80112e:	75 07                	jne    801137 <strncmp+0x57>
		return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	eb 1a                	jmp    801151 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	0f b6 d0             	movzbl %al,%edx
  801141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801145:	0f b6 00             	movzbl (%rax),%eax
  801148:	0f b6 c0             	movzbl %al,%eax
  80114b:	89 d1                	mov    %edx,%ecx
  80114d:	29 c1                	sub    %eax,%ecx
  80114f:	89 c8                	mov    %ecx,%eax
}
  801151:	c9                   	leaveq 
  801152:	c3                   	retq   

0000000000801153 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801153:	55                   	push   %rbp
  801154:	48 89 e5             	mov    %rsp,%rbp
  801157:	48 83 ec 10          	sub    $0x10,%rsp
  80115b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80115f:	89 f0                	mov    %esi,%eax
  801161:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801164:	eb 17                	jmp    80117d <strchr+0x2a>
		if (*s == c)
  801166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116a:	0f b6 00             	movzbl (%rax),%eax
  80116d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801170:	75 06                	jne    801178 <strchr+0x25>
			return (char *) s;
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	eb 15                	jmp    80118d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801178:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	84 c0                	test   %al,%al
  801186:	75 de                	jne    801166 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 83 ec 10          	sub    $0x10,%rsp
  801197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119b:	89 f0                	mov    %esi,%eax
  80119d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011a0:	eb 11                	jmp    8011b3 <strfind+0x24>
		if (*s == c)
  8011a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011ac:	74 12                	je     8011c0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b7:	0f b6 00             	movzbl (%rax),%eax
  8011ba:	84 c0                	test   %al,%al
  8011bc:	75 e4                	jne    8011a2 <strfind+0x13>
  8011be:	eb 01                	jmp    8011c1 <strfind+0x32>
		if (*s == c)
			break;
  8011c0:	90                   	nop
	return (char *) s;
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   

00000000008011c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 83 ec 18          	sub    $0x18,%rsp
  8011cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011df:	75 06                	jne    8011e7 <memset+0x20>
		return v;
  8011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e5:	eb 69                	jmp    801250 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011eb:	83 e0 03             	and    $0x3,%eax
  8011ee:	48 85 c0             	test   %rax,%rax
  8011f1:	75 48                	jne    80123b <memset+0x74>
  8011f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f7:	83 e0 03             	and    $0x3,%eax
  8011fa:	48 85 c0             	test   %rax,%rax
  8011fd:	75 3c                	jne    80123b <memset+0x74>
		c &= 0xFF;
  8011ff:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801206:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801209:	89 c2                	mov    %eax,%edx
  80120b:	c1 e2 18             	shl    $0x18,%edx
  80120e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801211:	c1 e0 10             	shl    $0x10,%eax
  801214:	09 c2                	or     %eax,%edx
  801216:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801219:	c1 e0 08             	shl    $0x8,%eax
  80121c:	09 d0                	or     %edx,%eax
  80121e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801225:	48 89 c1             	mov    %rax,%rcx
  801228:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80122c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801230:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801233:	48 89 d7             	mov    %rdx,%rdi
  801236:	fc                   	cld    
  801237:	f3 ab                	rep stos %eax,%es:(%rdi)
  801239:	eb 11                	jmp    80124c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80123b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801242:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801246:	48 89 d7             	mov    %rdx,%rdi
  801249:	fc                   	cld    
  80124a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801250:	c9                   	leaveq 
  801251:	c3                   	retq   

0000000000801252 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801252:	55                   	push   %rbp
  801253:	48 89 e5             	mov    %rsp,%rbp
  801256:	48 83 ec 28          	sub    $0x28,%rsp
  80125a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801262:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801266:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80126e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801272:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80127e:	0f 83 88 00 00 00    	jae    80130c <memmove+0xba>
  801284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801288:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128c:	48 01 d0             	add    %rdx,%rax
  80128f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801293:	76 77                	jbe    80130c <memmove+0xba>
		s += n;
  801295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801299:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80129d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	83 e0 03             	and    $0x3,%eax
  8012ac:	48 85 c0             	test   %rax,%rax
  8012af:	75 3b                	jne    8012ec <memmove+0x9a>
  8012b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b5:	83 e0 03             	and    $0x3,%eax
  8012b8:	48 85 c0             	test   %rax,%rax
  8012bb:	75 2f                	jne    8012ec <memmove+0x9a>
  8012bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c1:	83 e0 03             	and    $0x3,%eax
  8012c4:	48 85 c0             	test   %rax,%rax
  8012c7:	75 23                	jne    8012ec <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cd:	48 83 e8 04          	sub    $0x4,%rax
  8012d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d5:	48 83 ea 04          	sub    $0x4,%rdx
  8012d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012dd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012e1:	48 89 c7             	mov    %rax,%rdi
  8012e4:	48 89 d6             	mov    %rdx,%rsi
  8012e7:	fd                   	std    
  8012e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ea:	eb 1d                	jmp    801309 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	48 89 d7             	mov    %rdx,%rdi
  801303:	48 89 c1             	mov    %rax,%rcx
  801306:	fd                   	std    
  801307:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801309:	fc                   	cld    
  80130a:	eb 57                	jmp    801363 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801310:	83 e0 03             	and    $0x3,%eax
  801313:	48 85 c0             	test   %rax,%rax
  801316:	75 36                	jne    80134e <memmove+0xfc>
  801318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131c:	83 e0 03             	and    $0x3,%eax
  80131f:	48 85 c0             	test   %rax,%rax
  801322:	75 2a                	jne    80134e <memmove+0xfc>
  801324:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801328:	83 e0 03             	and    $0x3,%eax
  80132b:	48 85 c0             	test   %rax,%rax
  80132e:	75 1e                	jne    80134e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801334:	48 89 c1             	mov    %rax,%rcx
  801337:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80133b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801343:	48 89 c7             	mov    %rax,%rdi
  801346:	48 89 d6             	mov    %rdx,%rsi
  801349:	fc                   	cld    
  80134a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80134c:	eb 15                	jmp    801363 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80134e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801352:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801356:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80135a:	48 89 c7             	mov    %rax,%rdi
  80135d:	48 89 d6             	mov    %rdx,%rsi
  801360:	fc                   	cld    
  801361:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801367:	c9                   	leaveq 
  801368:	c3                   	retq   

0000000000801369 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801369:	55                   	push   %rbp
  80136a:	48 89 e5             	mov    %rsp,%rbp
  80136d:	48 83 ec 18          	sub    $0x18,%rsp
  801371:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801375:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801379:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80137d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801381:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801389:	48 89 ce             	mov    %rcx,%rsi
  80138c:	48 89 c7             	mov    %rax,%rdi
  80138f:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  801396:	00 00 00 
  801399:	ff d0                	callq  *%rax
}
  80139b:	c9                   	leaveq 
  80139c:	c3                   	retq   

000000000080139d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80139d:	55                   	push   %rbp
  80139e:	48 89 e5             	mov    %rsp,%rbp
  8013a1:	48 83 ec 28          	sub    $0x28,%rsp
  8013a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013c1:	eb 38                	jmp    8013fb <memcmp+0x5e>
		if (*s1 != *s2)
  8013c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c7:	0f b6 10             	movzbl (%rax),%edx
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	38 c2                	cmp    %al,%dl
  8013d3:	74 1c                	je     8013f1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8013d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	0f b6 d0             	movzbl %al,%edx
  8013df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e3:	0f b6 00             	movzbl (%rax),%eax
  8013e6:	0f b6 c0             	movzbl %al,%eax
  8013e9:	89 d1                	mov    %edx,%ecx
  8013eb:	29 c1                	sub    %eax,%ecx
  8013ed:	89 c8                	mov    %ecx,%eax
  8013ef:	eb 20                	jmp    801411 <memcmp+0x74>
		s1++, s2++;
  8013f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801400:	0f 95 c0             	setne  %al
  801403:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801408:	84 c0                	test   %al,%al
  80140a:	75 b7                	jne    8013c3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801411:	c9                   	leaveq 
  801412:	c3                   	retq   

0000000000801413 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801413:	55                   	push   %rbp
  801414:	48 89 e5             	mov    %rsp,%rbp
  801417:	48 83 ec 28          	sub    $0x28,%rsp
  80141b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801422:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80142e:	48 01 d0             	add    %rdx,%rax
  801431:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801435:	eb 13                	jmp    80144a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143b:	0f b6 10             	movzbl (%rax),%edx
  80143e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801441:	38 c2                	cmp    %al,%dl
  801443:	74 11                	je     801456 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801445:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801452:	72 e3                	jb     801437 <memfind+0x24>
  801454:	eb 01                	jmp    801457 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801456:	90                   	nop
	return (void *) s;
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 83 ec 38          	sub    $0x38,%rsp
  801465:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801469:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80146d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801477:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80147e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80147f:	eb 05                	jmp    801486 <strtol+0x29>
		s++;
  801481:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	3c 20                	cmp    $0x20,%al
  80148f:	74 f0                	je     801481 <strtol+0x24>
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	3c 09                	cmp    $0x9,%al
  80149a:	74 e5                	je     801481 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80149c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3c 2b                	cmp    $0x2b,%al
  8014a5:	75 07                	jne    8014ae <strtol+0x51>
		s++;
  8014a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ac:	eb 17                	jmp    8014c5 <strtol+0x68>
	else if (*s == '-')
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	0f b6 00             	movzbl (%rax),%eax
  8014b5:	3c 2d                	cmp    $0x2d,%al
  8014b7:	75 0c                	jne    8014c5 <strtol+0x68>
		s++, neg = 1;
  8014b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014be:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c9:	74 06                	je     8014d1 <strtol+0x74>
  8014cb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014cf:	75 28                	jne    8014f9 <strtol+0x9c>
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	3c 30                	cmp    $0x30,%al
  8014da:	75 1d                	jne    8014f9 <strtol+0x9c>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	48 83 c0 01          	add    $0x1,%rax
  8014e4:	0f b6 00             	movzbl (%rax),%eax
  8014e7:	3c 78                	cmp    $0x78,%al
  8014e9:	75 0e                	jne    8014f9 <strtol+0x9c>
		s += 2, base = 16;
  8014eb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014f0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014f7:	eb 2c                	jmp    801525 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014fd:	75 19                	jne    801518 <strtol+0xbb>
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	3c 30                	cmp    $0x30,%al
  801508:	75 0e                	jne    801518 <strtol+0xbb>
		s++, base = 8;
  80150a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80150f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801516:	eb 0d                	jmp    801525 <strtol+0xc8>
	else if (base == 0)
  801518:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80151c:	75 07                	jne    801525 <strtol+0xc8>
		base = 10;
  80151e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	3c 2f                	cmp    $0x2f,%al
  80152e:	7e 1d                	jle    80154d <strtol+0xf0>
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	3c 39                	cmp    $0x39,%al
  801539:	7f 12                	jg     80154d <strtol+0xf0>
			dig = *s - '0';
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	0f be c0             	movsbl %al,%eax
  801545:	83 e8 30             	sub    $0x30,%eax
  801548:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80154b:	eb 4e                	jmp    80159b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 60                	cmp    $0x60,%al
  801556:	7e 1d                	jle    801575 <strtol+0x118>
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 7a                	cmp    $0x7a,%al
  801561:	7f 12                	jg     801575 <strtol+0x118>
			dig = *s - 'a' + 10;
  801563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	0f be c0             	movsbl %al,%eax
  80156d:	83 e8 57             	sub    $0x57,%eax
  801570:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801573:	eb 26                	jmp    80159b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3c 40                	cmp    $0x40,%al
  80157e:	7e 47                	jle    8015c7 <strtol+0x16a>
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	3c 5a                	cmp    $0x5a,%al
  801589:	7f 3c                	jg     8015c7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80158b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	0f be c0             	movsbl %al,%eax
  801595:	83 e8 37             	sub    $0x37,%eax
  801598:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80159b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80159e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015a1:	7d 23                	jge    8015c6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8015a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015ab:	48 98                	cltq   
  8015ad:	48 89 c2             	mov    %rax,%rdx
  8015b0:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8015b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015b8:	48 98                	cltq   
  8015ba:	48 01 d0             	add    %rdx,%rax
  8015bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015c1:	e9 5f ff ff ff       	jmpq   801525 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015c6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015c7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015cc:	74 0b                	je     8015d9 <strtol+0x17c>
		*endptr = (char *) s;
  8015ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015d6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015dd:	74 09                	je     8015e8 <strtol+0x18b>
  8015df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e3:	48 f7 d8             	neg    %rax
  8015e6:	eb 04                	jmp    8015ec <strtol+0x18f>
  8015e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015ec:	c9                   	leaveq 
  8015ed:	c3                   	retq   

00000000008015ee <strstr>:

char * strstr(const char *in, const char *str)
{
  8015ee:	55                   	push   %rbp
  8015ef:	48 89 e5             	mov    %rsp,%rbp
  8015f2:	48 83 ec 30          	sub    $0x30,%rsp
  8015f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	88 45 ff             	mov    %al,-0x1(%rbp)
  801608:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  80160d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801611:	75 06                	jne    801619 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801617:	eb 68                	jmp    801681 <strstr+0x93>

	len = strlen(str);
  801619:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80161d:	48 89 c7             	mov    %rax,%rdi
  801620:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  801627:	00 00 00 
  80162a:	ff d0                	callq  *%rax
  80162c:	48 98                	cltq   
  80162e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	88 45 ef             	mov    %al,-0x11(%rbp)
  80163c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801641:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801645:	75 07                	jne    80164e <strstr+0x60>
				return (char *) 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	eb 33                	jmp    801681 <strstr+0x93>
		} while (sc != c);
  80164e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801652:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801655:	75 db                	jne    801632 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801657:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80165b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	48 89 ce             	mov    %rcx,%rsi
  801666:	48 89 c7             	mov    %rax,%rdi
  801669:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  801670:	00 00 00 
  801673:	ff d0                	callq  *%rax
  801675:	85 c0                	test   %eax,%eax
  801677:	75 b9                	jne    801632 <strstr+0x44>

	return (char *) (in - 1);
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	48 83 e8 01          	sub    $0x1,%rax
}
  801681:	c9                   	leaveq 
  801682:	c3                   	retq   
	...

0000000000801684 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801684:	55                   	push   %rbp
  801685:	48 89 e5             	mov    %rsp,%rbp
  801688:	53                   	push   %rbx
  801689:	48 83 ec 58          	sub    $0x58,%rsp
  80168d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801690:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801693:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801697:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80169b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80169f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016a6:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8016a9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016ad:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016b1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016b5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016b9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016bd:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8016c0:	4c 89 c3             	mov    %r8,%rbx
  8016c3:	cd 30                	int    $0x30
  8016c5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8016c9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8016cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016d5:	74 3e                	je     801715 <syscall+0x91>
  8016d7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016dc:	7e 37                	jle    801715 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016e5:	49 89 d0             	mov    %rdx,%r8
  8016e8:	89 c1                	mov    %eax,%ecx
  8016ea:	48 ba c8 49 80 00 00 	movabs $0x8049c8,%rdx
  8016f1:	00 00 00 
  8016f4:	be 23 00 00 00       	mov    $0x23,%esi
  8016f9:	48 bf e5 49 80 00 00 	movabs $0x8049e5,%rdi
  801700:	00 00 00 
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	49 b9 cc 3f 80 00 00 	movabs $0x803fcc,%r9
  80170f:	00 00 00 
  801712:	41 ff d1             	callq  *%r9

	return ret;
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801719:	48 83 c4 58          	add    $0x58,%rsp
  80171d:	5b                   	pop    %rbx
  80171e:	5d                   	pop    %rbp
  80171f:	c3                   	retq   

0000000000801720 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	48 83 ec 20          	sub    $0x20,%rsp
  801728:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80172c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801734:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801738:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80173f:	00 
  801740:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801746:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174c:	48 89 d1             	mov    %rdx,%rcx
  80174f:	48 89 c2             	mov    %rax,%rdx
  801752:	be 00 00 00 00       	mov    $0x0,%esi
  801757:	bf 00 00 00 00       	mov    $0x0,%edi
  80175c:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801763:	00 00 00 
  801766:	ff d0                	callq  *%rax
}
  801768:	c9                   	leaveq 
  801769:	c3                   	retq   

000000000080176a <sys_cgetc>:

int
sys_cgetc(void)
{
  80176a:	55                   	push   %rbp
  80176b:	48 89 e5             	mov    %rsp,%rbp
  80176e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801772:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801779:	00 
  80177a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801780:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	be 00 00 00 00       	mov    $0x0,%esi
  801795:	bf 01 00 00 00       	mov    $0x1,%edi
  80179a:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  8017a1:	00 00 00 
  8017a4:	ff d0                	callq  *%rax
}
  8017a6:	c9                   	leaveq 
  8017a7:	c3                   	retq   

00000000008017a8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017a8:	55                   	push   %rbp
  8017a9:	48 89 e5             	mov    %rsp,%rbp
  8017ac:	48 83 ec 20          	sub    $0x20,%rsp
  8017b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b6:	48 98                	cltq   
  8017b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bf:	00 
  8017c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d1:	48 89 c2             	mov    %rax,%rdx
  8017d4:	be 01 00 00 00       	mov    $0x1,%esi
  8017d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8017de:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
}
  8017ea:	c9                   	leaveq 
  8017eb:	c3                   	retq   

00000000008017ec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fb:	00 
  8017fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801802:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801808:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	be 00 00 00 00       	mov    $0x0,%esi
  801817:	bf 02 00 00 00       	mov    $0x2,%edi
  80181c:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <sys_yield>:

void
sys_yield(void)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801832:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801839:	00 
  80183a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801840:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801846:	b9 00 00 00 00       	mov    $0x0,%ecx
  80184b:	ba 00 00 00 00       	mov    $0x0,%edx
  801850:	be 00 00 00 00       	mov    $0x0,%esi
  801855:	bf 0b 00 00 00       	mov    $0xb,%edi
  80185a:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801861:	00 00 00 
  801864:	ff d0                	callq  *%rax
}
  801866:	c9                   	leaveq 
  801867:	c3                   	retq   

0000000000801868 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 20          	sub    $0x20,%rsp
  801870:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801873:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801877:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80187a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187d:	48 63 c8             	movslq %eax,%rcx
  801880:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801890:	00 
  801891:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801897:	49 89 c8             	mov    %rcx,%r8
  80189a:	48 89 d1             	mov    %rdx,%rcx
  80189d:	48 89 c2             	mov    %rax,%rdx
  8018a0:	be 01 00 00 00       	mov    $0x1,%esi
  8018a5:	bf 04 00 00 00       	mov    $0x4,%edi
  8018aa:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
}
  8018b6:	c9                   	leaveq 
  8018b7:	c3                   	retq   

00000000008018b8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 30          	sub    $0x30,%rsp
  8018c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018ca:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018ce:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018d2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018d5:	48 63 c8             	movslq %eax,%rcx
  8018d8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018df:	48 63 f0             	movslq %eax,%rsi
  8018e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e9:	48 98                	cltq   
  8018eb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018ef:	49 89 f9             	mov    %rdi,%r9
  8018f2:	49 89 f0             	mov    %rsi,%r8
  8018f5:	48 89 d1             	mov    %rdx,%rcx
  8018f8:	48 89 c2             	mov    %rax,%rdx
  8018fb:	be 01 00 00 00       	mov    $0x1,%esi
  801900:	bf 05 00 00 00       	mov    $0x5,%edi
  801905:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  80190c:	00 00 00 
  80190f:	ff d0                	callq  *%rax
}
  801911:	c9                   	leaveq 
  801912:	c3                   	retq   

0000000000801913 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801913:	55                   	push   %rbp
  801914:	48 89 e5             	mov    %rsp,%rbp
  801917:	48 83 ec 20          	sub    $0x20,%rsp
  80191b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80191e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801922:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801929:	48 98                	cltq   
  80192b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801932:	00 
  801933:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801939:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193f:	48 89 d1             	mov    %rdx,%rcx
  801942:	48 89 c2             	mov    %rax,%rdx
  801945:	be 01 00 00 00       	mov    $0x1,%esi
  80194a:	bf 06 00 00 00       	mov    $0x6,%edi
  80194f:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 20          	sub    $0x20,%rsp
  801965:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801968:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80196b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196e:	48 63 d0             	movslq %eax,%rdx
  801971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197d:	00 
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	48 89 d1             	mov    %rdx,%rcx
  80198d:	48 89 c2             	mov    %rax,%rdx
  801990:	be 01 00 00 00       	mov    $0x1,%esi
  801995:	bf 08 00 00 00       	mov    $0x8,%edi
  80199a:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 20          	sub    $0x20,%rsp
  8019b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019be:	48 98                	cltq   
  8019c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c7:	00 
  8019c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d4:	48 89 d1             	mov    %rdx,%rcx
  8019d7:	48 89 c2             	mov    %rax,%rdx
  8019da:	be 01 00 00 00       	mov    $0x1,%esi
  8019df:	bf 09 00 00 00       	mov    $0x9,%edi
  8019e4:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	callq  *%rax
}
  8019f0:	c9                   	leaveq 
  8019f1:	c3                   	retq   

00000000008019f2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
  8019f6:	48 83 ec 20          	sub    $0x20,%rsp
  8019fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a08:	48 98                	cltq   
  801a0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a11:	00 
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a2e:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 30          	sub    $0x30,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a4f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a55:	48 63 f0             	movslq %eax,%rsi
  801a58:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5f:	48 98                	cltq   
  801a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6c:	00 
  801a6d:	49 89 f1             	mov    %rsi,%r9
  801a70:	49 89 c8             	mov    %rcx,%r8
  801a73:	48 89 d1             	mov    %rdx,%rcx
  801a76:	48 89 c2             	mov    %rax,%rdx
  801a79:	be 00 00 00 00       	mov    $0x0,%esi
  801a7e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a83:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801a8a:	00 00 00 
  801a8d:	ff d0                	callq  *%rax
}
  801a8f:	c9                   	leaveq 
  801a90:	c3                   	retq   

0000000000801a91 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	48 83 ec 20          	sub    $0x20,%rsp
  801a99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa8:	00 
  801aa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aba:	48 89 c2             	mov    %rax,%rdx
  801abd:	be 01 00 00 00       	mov    $0x1,%esi
  801ac2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ac7:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801ace:	00 00 00 
  801ad1:	ff d0                	callq  *%rax
}
  801ad3:	c9                   	leaveq 
  801ad4:	c3                   	retq   

0000000000801ad5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ad5:	55                   	push   %rbp
  801ad6:	48 89 e5             	mov    %rsp,%rbp
  801ad9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af6:	ba 00 00 00 00       	mov    $0x0,%edx
  801afb:	be 00 00 00 00       	mov    $0x0,%esi
  801b00:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b05:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801b0c:	00 00 00 
  801b0f:	ff d0                	callq  *%rax
}
  801b11:	c9                   	leaveq 
  801b12:	c3                   	retq   

0000000000801b13 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b13:	55                   	push   %rbp
  801b14:	48 89 e5             	mov    %rsp,%rbp
  801b17:	48 83 ec 30          	sub    $0x30,%rsp
  801b1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b22:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b25:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b29:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b2d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b30:	48 63 c8             	movslq %eax,%rcx
  801b33:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3a:	48 63 f0             	movslq %eax,%rsi
  801b3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b44:	48 98                	cltq   
  801b46:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b4a:	49 89 f9             	mov    %rdi,%r9
  801b4d:	49 89 f0             	mov    %rsi,%r8
  801b50:	48 89 d1             	mov    %rdx,%rcx
  801b53:	48 89 c2             	mov    %rax,%rdx
  801b56:	be 00 00 00 00       	mov    $0x0,%esi
  801b5b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b60:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801b6c:	c9                   	leaveq 
  801b6d:	c3                   	retq   

0000000000801b6e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801b6e:	55                   	push   %rbp
  801b6f:	48 89 e5             	mov    %rsp,%rbp
  801b72:	48 83 ec 20          	sub    $0x20,%rsp
  801b76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8d:	00 
  801b8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9a:	48 89 d1             	mov    %rdx,%rcx
  801b9d:	48 89 c2             	mov    %rax,%rdx
  801ba0:	be 00 00 00 00       	mov    $0x0,%esi
  801ba5:	bf 10 00 00 00       	mov    $0x10,%edi
  801baa:	48 b8 84 16 80 00 00 	movabs $0x801684,%rax
  801bb1:	00 00 00 
  801bb4:	ff d0                	callq  *%rax
}
  801bb6:	c9                   	leaveq 
  801bb7:	c3                   	retq   

0000000000801bb8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 40          	sub    $0x40,%rsp
  801bc0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bc4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bc8:	48 8b 00             	mov    (%rax),%rax
  801bcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801bcf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bd3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bd7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801bda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bde:	48 89 c2             	mov    %rax,%rdx
  801be1:	48 c1 ea 0c          	shr    $0xc,%rdx
  801be5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bec:	01 00 00 
  801bef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801bf7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bfa:	83 e0 02             	and    $0x2,%eax
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	0f 84 4f 01 00 00    	je     801d54 <pgfault+0x19c>
  801c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c09:	48 89 c2             	mov    %rax,%rdx
  801c0c:	48 c1 ea 0c          	shr    $0xc,%rdx
  801c10:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c17:	01 00 00 
  801c1a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c1e:	25 00 08 00 00       	and    $0x800,%eax
  801c23:	48 85 c0             	test   %rax,%rax
  801c26:	0f 84 28 01 00 00    	je     801d54 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801c2c:	ba 07 00 00 00       	mov    $0x7,%edx
  801c31:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c36:	bf 00 00 00 00       	mov    $0x0,%edi
  801c3b:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801c42:	00 00 00 
  801c45:	ff d0                	callq  *%rax
  801c47:	85 c0                	test   %eax,%eax
  801c49:	0f 85 db 00 00 00    	jne    801d2a <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c53:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801c57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801c65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c69:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c6e:	48 89 c6             	mov    %rax,%rsi
  801c71:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c76:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801c82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c86:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c8c:	48 89 c1             	mov    %rax,%rcx
  801c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c94:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c99:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9e:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  801ca5:	00 00 00 
  801ca8:	ff d0                	callq  *%rax
  801caa:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801cad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801cb1:	79 2a                	jns    801cdd <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801cb3:	48 ba f8 49 80 00 00 	movabs $0x8049f8,%rdx
  801cba:	00 00 00 
  801cbd:	be 28 00 00 00       	mov    $0x28,%esi
  801cc2:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801cc9:	00 00 00 
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  801cd8:	00 00 00 
  801cdb:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  801cdd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ce2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce7:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  801cee:	00 00 00 
  801cf1:	ff d0                	callq  *%rax
  801cf3:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801cf6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801cfa:	0f 89 84 00 00 00    	jns    801d84 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  801d00:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  801d07:	00 00 00 
  801d0a:	be 2c 00 00 00       	mov    $0x2c,%esi
  801d0f:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801d16:	00 00 00 
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  801d25:	00 00 00 
  801d28:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  801d2a:	48 ba 60 4a 80 00 00 	movabs $0x804a60,%rdx
  801d31:	00 00 00 
  801d34:	be 31 00 00 00       	mov    $0x31,%esi
  801d39:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801d40:	00 00 00 
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  801d4f:	00 00 00 
  801d52:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  801d54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d57:	89 c1                	mov    %eax,%ecx
  801d59:	48 ba 8a 4a 80 00 00 	movabs $0x804a8a,%rdx
  801d60:	00 00 00 
  801d63:	be 35 00 00 00       	mov    $0x35,%esi
  801d68:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801d6f:	00 00 00 
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801d7e:	00 00 00 
  801d81:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  801d84:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  801d85:	c9                   	leaveq 
  801d86:	c3                   	retq   

0000000000801d87 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d87:	55                   	push   %rbp
  801d88:	48 89 e5             	mov    %rsp,%rbp
  801d8b:	48 83 ec 30          	sub    $0x30,%rsp
  801d8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d92:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  801d95:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9c:	01 00 00 
  801d9f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801da2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  801daa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801dad:	48 c1 e0 0c          	shl    $0xc,%rax
  801db1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  801db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db9:	25 07 0e 00 00       	and    $0xe07,%eax
  801dbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  801dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dc4:	25 00 04 00 00       	and    $0x400,%eax
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	74 62                	je     801e2f <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  801dcd:	8b 75 ec             	mov    -0x14(%rbp),%esi
  801dd0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dd4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddb:	41 89 f0             	mov    %esi,%r8d
  801dde:	48 89 c6             	mov    %rax,%rsi
  801de1:	bf 00 00 00 00       	mov    $0x0,%edi
  801de6:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
  801df2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801df5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801df9:	0f 89 78 01 00 00    	jns    801f77 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  801dff:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e02:	89 c1                	mov    %eax,%ecx
  801e04:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  801e0b:	00 00 00 
  801e0e:	be 4f 00 00 00       	mov    $0x4f,%esi
  801e13:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801e1a:	00 00 00 
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801e29:	00 00 00 
  801e2c:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  801e2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e32:	25 00 08 00 00       	and    $0x800,%eax
  801e37:	85 c0                	test   %eax,%eax
  801e39:	75 0e                	jne    801e49 <duppage+0xc2>
  801e3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e3e:	83 e0 02             	and    $0x2,%eax
  801e41:	85 c0                	test   %eax,%eax
  801e43:	0f 84 d0 00 00 00    	je     801f19 <duppage+0x192>
		perm &= ~PTE_W;
  801e49:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  801e4d:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  801e54:	8b 75 ec             	mov    -0x14(%rbp),%esi
  801e57:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e5b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e62:	41 89 f0             	mov    %esi,%r8d
  801e65:	48 89 c6             	mov    %rax,%rsi
  801e68:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6d:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
  801e79:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801e7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801e80:	79 30                	jns    801eb2 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  801e82:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e85:	89 c1                	mov    %eax,%ecx
  801e87:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  801e8e:	00 00 00 
  801e91:	be 57 00 00 00       	mov    $0x57,%esi
  801e96:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801e9d:	00 00 00 
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea5:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801eac:	00 00 00 
  801eaf:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  801eb2:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  801eb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebd:	41 89 c8             	mov    %ecx,%r8d
  801ec0:	48 89 d1             	mov    %rdx,%rcx
  801ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec8:	48 89 c6             	mov    %rax,%rsi
  801ecb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed0:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
  801edc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801edf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801ee3:	0f 89 8e 00 00 00    	jns    801f77 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  801ee9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801eec:	89 c1                	mov    %eax,%ecx
  801eee:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  801ef5:	00 00 00 
  801ef8:	be 5b 00 00 00       	mov    $0x5b,%esi
  801efd:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801f04:	00 00 00 
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801f13:	00 00 00 
  801f16:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  801f19:	8b 75 ec             	mov    -0x14(%rbp),%esi
  801f1c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f20:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f27:	41 89 f0             	mov    %esi,%r8d
  801f2a:	48 89 c6             	mov    %rax,%rsi
  801f2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f32:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
  801f3e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801f41:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f45:	79 30                	jns    801f77 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  801f47:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f4a:	89 c1                	mov    %eax,%ecx
  801f4c:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  801f53:	00 00 00 
  801f56:	be 61 00 00 00       	mov    $0x61,%esi
  801f5b:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801f62:	00 00 00 
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801f71:	00 00 00 
  801f74:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7c:	c9                   	leaveq 
  801f7d:	c3                   	retq   

0000000000801f7e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f7e:	55                   	push   %rbp
  801f7f:	48 89 e5             	mov    %rsp,%rbp
  801f82:	53                   	push   %rbx
  801f83:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  801f87:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  801f8e:	48 bf b8 1b 80 00 00 	movabs $0x801bb8,%rdi
  801f95:	00 00 00 
  801f98:	48 b8 e0 40 80 00 00 	movabs $0x8040e0,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fa4:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  801fab:	8b 45 9c             	mov    -0x64(%rbp),%eax
  801fae:	cd 30                	int    $0x30
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fb5:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  801fb8:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  801fbb:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  801fbf:	79 30                	jns    801ff1 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  801fc1:	8b 45 b0             	mov    -0x50(%rbp),%eax
  801fc4:	89 c1                	mov    %eax,%ecx
  801fc6:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  801fcd:	00 00 00 
  801fd0:	be 80 00 00 00       	mov    $0x80,%esi
  801fd5:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  801fdc:	00 00 00 
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  801feb:	00 00 00 
  801fee:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  801ff1:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  801ff5:	75 52                	jne    802049 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  801ff7:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801ffe:	00 00 00 
  802001:	ff d0                	callq  *%rax
  802003:	48 98                	cltq   
  802005:	48 89 c2             	mov    %rax,%rdx
  802008:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80200e:	48 89 d0             	mov    %rdx,%rax
  802011:	48 c1 e0 02          	shl    $0x2,%rax
  802015:	48 01 d0             	add    %rdx,%rax
  802018:	48 01 c0             	add    %rax,%rax
  80201b:	48 01 d0             	add    %rdx,%rax
  80201e:	48 c1 e0 05          	shl    $0x5,%rax
  802022:	48 89 c2             	mov    %rax,%rdx
  802025:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80202c:	00 00 00 
  80202f:	48 01 c2             	add    %rax,%rdx
  802032:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802039:	00 00 00 
  80203c:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	e9 9d 02 00 00       	jmpq   8022e6 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  802049:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80204c:	ba 07 00 00 00       	mov    $0x7,%edx
  802051:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802056:	89 c7                	mov    %eax,%edi
  802058:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  80205f:	00 00 00 
  802062:	ff d0                	callq  *%rax
  802064:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802067:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80206b:	79 30                	jns    80209d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  80206d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802070:	89 c1                	mov    %eax,%ecx
  802072:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  802079:	00 00 00 
  80207c:	be 88 00 00 00       	mov    $0x88,%esi
  802081:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  802088:	00 00 00 
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  802097:	00 00 00 
  80209a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80209d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8020a4:	00 
	uint64_t each_pte = 0;
  8020a5:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8020ac:	00 
	uint64_t each_pdpe = 0;
  8020ad:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8020b4:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8020b5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8020bc:	00 
  8020bd:	e9 73 01 00 00       	jmpq   802235 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  8020c2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020c9:	01 00 00 
  8020cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d4:	83 e0 01             	and    $0x1,%eax
  8020d7:	84 c0                	test   %al,%al
  8020d9:	0f 84 41 01 00 00    	je     802220 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8020df:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8020e6:	00 
  8020e7:	e9 24 01 00 00       	jmpq   802210 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  8020ec:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020f3:	01 00 00 
  8020f6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8020fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fe:	83 e0 01             	and    $0x1,%eax
  802101:	84 c0                	test   %al,%al
  802103:	0f 84 ed 00 00 00    	je     8021f6 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802109:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802110:	00 
  802111:	e9 d0 00 00 00       	jmpq   8021e6 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  802116:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80211d:	01 00 00 
  802120:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802124:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802128:	83 e0 01             	and    $0x1,%eax
  80212b:	84 c0                	test   %al,%al
  80212d:	0f 84 99 00 00 00    	je     8021cc <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802133:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80213a:	00 
  80213b:	eb 7f                	jmp    8021bc <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  80213d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802144:	01 00 00 
  802147:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80214b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214f:	83 e0 01             	and    $0x1,%eax
  802152:	84 c0                	test   %al,%al
  802154:	74 5c                	je     8021b2 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  802156:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  80215d:	00 
  80215e:	74 52                	je     8021b2 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802160:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802164:	89 c2                	mov    %eax,%edx
  802166:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802169:	89 d6                	mov    %edx,%esi
  80216b:	89 c7                	mov    %eax,%edi
  80216d:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  80217c:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802180:	79 30                	jns    8021b2 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802182:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802185:	89 c1                	mov    %eax,%ecx
  802187:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  80218e:	00 00 00 
  802191:	be a0 00 00 00       	mov    $0xa0,%esi
  802196:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  80219d:	00 00 00 
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a5:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  8021ac:	00 00 00 
  8021af:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8021b2:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8021b7:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  8021bc:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8021c3:	00 
  8021c4:	0f 86 73 ff ff ff    	jbe    80213d <fork+0x1bf>
  8021ca:	eb 10                	jmp    8021dc <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  8021cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021d0:	48 83 c0 01          	add    $0x1,%rax
  8021d4:	48 c1 e0 09          	shl    $0x9,%rax
  8021d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8021dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8021e1:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8021e6:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8021ed:	00 
  8021ee:	0f 86 22 ff ff ff    	jbe    802116 <fork+0x198>
  8021f4:	eb 10                	jmp    802206 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8021f6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8021fa:	48 83 c0 01          	add    $0x1,%rax
  8021fe:	48 c1 e0 09          	shl    $0x9,%rax
  802202:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802206:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80220b:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  802210:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802217:	00 
  802218:	0f 86 ce fe ff ff    	jbe    8020ec <fork+0x16e>
  80221e:	eb 10                	jmp    802230 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802224:	48 83 c0 01          	add    $0x1,%rax
  802228:	48 c1 e0 09          	shl    $0x9,%rax
  80222c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802230:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802235:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80223a:	0f 84 82 fe ff ff    	je     8020c2 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802240:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802243:	48 be 78 41 80 00 00 	movabs $0x804178,%rsi
  80224a:	00 00 00 
  80224d:	89 c7                	mov    %eax,%edi
  80224f:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
  80225b:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80225e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802262:	79 30                	jns    802294 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802264:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802267:	89 c1                	mov    %eax,%ecx
  802269:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  802270:	00 00 00 
  802273:	be bd 00 00 00       	mov    $0xbd,%esi
  802278:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  80227f:	00 00 00 
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  80228e:	00 00 00 
  802291:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802294:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802297:	be 02 00 00 00       	mov    $0x2,%esi
  80229c:	89 c7                	mov    %eax,%edi
  80229e:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
  8022aa:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8022ad:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8022b1:	79 30                	jns    8022e3 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  8022b3:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8022b6:	89 c1                	mov    %eax,%ecx
  8022b8:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  8022bf:	00 00 00 
  8022c2:	be c1 00 00 00       	mov    $0xc1,%esi
  8022c7:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  8022ce:	00 00 00 
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  8022dd:	00 00 00 
  8022e0:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  8022e3:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  8022e6:	48 83 c4 68          	add    $0x68,%rsp
  8022ea:	5b                   	pop    %rbx
  8022eb:	5d                   	pop    %rbp
  8022ec:	c3                   	retq   

00000000008022ed <sfork>:

// Challenge!
int
sfork(void)
{
  8022ed:	55                   	push   %rbp
  8022ee:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022f1:	48 ba e4 4a 80 00 00 	movabs $0x804ae4,%rdx
  8022f8:	00 00 00 
  8022fb:	be cc 00 00 00       	mov    $0xcc,%esi
  802300:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  802307:	00 00 00 
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  802316:	00 00 00 
  802319:	ff d1                	callq  *%rcx
	...

000000000080231c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80231c:	55                   	push   %rbp
  80231d:	48 89 e5             	mov    %rsp,%rbp
  802320:	48 83 ec 08          	sub    $0x8,%rsp
  802324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802328:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80232c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802333:	ff ff ff 
  802336:	48 01 d0             	add    %rdx,%rax
  802339:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80233d:	c9                   	leaveq 
  80233e:	c3                   	retq   

000000000080233f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	48 83 ec 08          	sub    $0x8,%rsp
  802347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80234b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234f:	48 89 c7             	mov    %rax,%rdi
  802352:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax
  80235e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802364:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802368:	c9                   	leaveq 
  802369:	c3                   	retq   

000000000080236a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80236a:	55                   	push   %rbp
  80236b:	48 89 e5             	mov    %rsp,%rbp
  80236e:	48 83 ec 18          	sub    $0x18,%rsp
  802372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80237d:	eb 6b                	jmp    8023ea <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80237f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802382:	48 98                	cltq   
  802384:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80238a:	48 c1 e0 0c          	shl    $0xc,%rax
  80238e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802396:	48 89 c2             	mov    %rax,%rdx
  802399:	48 c1 ea 15          	shr    $0x15,%rdx
  80239d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023a4:	01 00 00 
  8023a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ab:	83 e0 01             	and    $0x1,%eax
  8023ae:	48 85 c0             	test   %rax,%rax
  8023b1:	74 21                	je     8023d4 <fd_alloc+0x6a>
  8023b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b7:	48 89 c2             	mov    %rax,%rdx
  8023ba:	48 c1 ea 0c          	shr    $0xc,%rdx
  8023be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023c5:	01 00 00 
  8023c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cc:	83 e0 01             	and    $0x1,%eax
  8023cf:	48 85 c0             	test   %rax,%rax
  8023d2:	75 12                	jne    8023e6 <fd_alloc+0x7c>
			*fd_store = fd;
  8023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023dc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	eb 1a                	jmp    802400 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023ee:	7e 8f                	jle    80237f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023fb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802400:	c9                   	leaveq 
  802401:	c3                   	retq   

0000000000802402 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
  802406:	48 83 ec 20          	sub    $0x20,%rsp
  80240a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80240d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802411:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802415:	78 06                	js     80241d <fd_lookup+0x1b>
  802417:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80241b:	7e 07                	jle    802424 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80241d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802422:	eb 6c                	jmp    802490 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802427:	48 98                	cltq   
  802429:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80242f:	48 c1 e0 0c          	shl    $0xc,%rax
  802433:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243b:	48 89 c2             	mov    %rax,%rdx
  80243e:	48 c1 ea 15          	shr    $0x15,%rdx
  802442:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802449:	01 00 00 
  80244c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802450:	83 e0 01             	and    $0x1,%eax
  802453:	48 85 c0             	test   %rax,%rax
  802456:	74 21                	je     802479 <fd_lookup+0x77>
  802458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245c:	48 89 c2             	mov    %rax,%rdx
  80245f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802463:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80246a:	01 00 00 
  80246d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802471:	83 e0 01             	and    $0x1,%eax
  802474:	48 85 c0             	test   %rax,%rax
  802477:	75 07                	jne    802480 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80247e:	eb 10                	jmp    802490 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802480:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802484:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802488:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 30          	sub    $0x30,%rsp
  80249a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80249e:	89 f0                	mov    %esi,%eax
  8024a0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a7:	48 89 c7             	mov    %rax,%rdi
  8024aa:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
  8024b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ba:	48 89 d6             	mov    %rdx,%rsi
  8024bd:	89 c7                	mov    %eax,%edi
  8024bf:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
  8024cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d2:	78 0a                	js     8024de <fd_close+0x4c>
	    || fd != fd2)
  8024d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024dc:	74 12                	je     8024f0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024de:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024e2:	74 05                	je     8024e9 <fd_close+0x57>
  8024e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e7:	eb 05                	jmp    8024ee <fd_close+0x5c>
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	eb 69                	jmp    802559 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f4:	8b 00                	mov    (%rax),%eax
  8024f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024fa:	48 89 d6             	mov    %rdx,%rsi
  8024fd:	89 c7                	mov    %eax,%edi
  8024ff:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
  80250b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802512:	78 2a                	js     80253e <fd_close+0xac>
		if (dev->dev_close)
  802514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802518:	48 8b 40 20          	mov    0x20(%rax),%rax
  80251c:	48 85 c0             	test   %rax,%rax
  80251f:	74 16                	je     802537 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802525:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252d:	48 89 c7             	mov    %rax,%rdi
  802530:	ff d2                	callq  *%rdx
  802532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802535:	eb 07                	jmp    80253e <fd_close+0xac>
		else
			r = 0;
  802537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80253e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802542:	48 89 c6             	mov    %rax,%rsi
  802545:	bf 00 00 00 00       	mov    $0x0,%edi
  80254a:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  802551:	00 00 00 
  802554:	ff d0                	callq  *%rax
	return r;
  802556:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802559:	c9                   	leaveq 
  80255a:	c3                   	retq   

000000000080255b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80255b:	55                   	push   %rbp
  80255c:	48 89 e5             	mov    %rsp,%rbp
  80255f:	48 83 ec 20          	sub    $0x20,%rsp
  802563:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802566:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80256a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802571:	eb 41                	jmp    8025b4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802573:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80257a:	00 00 00 
  80257d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802580:	48 63 d2             	movslq %edx,%rdx
  802583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802587:	8b 00                	mov    (%rax),%eax
  802589:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80258c:	75 22                	jne    8025b0 <dev_lookup+0x55>
			*dev = devtab[i];
  80258e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802595:	00 00 00 
  802598:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80259b:	48 63 d2             	movslq %edx,%rdx
  80259e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	eb 60                	jmp    802610 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025bb:	00 00 00 
  8025be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025c1:	48 63 d2             	movslq %edx,%rdx
  8025c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c8:	48 85 c0             	test   %rax,%rax
  8025cb:	75 a6                	jne    802573 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025cd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025d4:	00 00 00 
  8025d7:	48 8b 00             	mov    (%rax),%rax
  8025da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025e3:	89 c6                	mov    %eax,%esi
  8025e5:	48 bf 00 4b 80 00 00 	movabs $0x804b00,%rdi
  8025ec:	00 00 00 
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	48 b9 5f 03 80 00 00 	movabs $0x80035f,%rcx
  8025fb:	00 00 00 
  8025fe:	ff d1                	callq  *%rcx
	*dev = 0;
  802600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802604:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80260b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802610:	c9                   	leaveq 
  802611:	c3                   	retq   

0000000000802612 <close>:

int
close(int fdnum)
{
  802612:	55                   	push   %rbp
  802613:	48 89 e5             	mov    %rsp,%rbp
  802616:	48 83 ec 20          	sub    $0x20,%rsp
  80261a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80261d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802621:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802624:	48 89 d6             	mov    %rdx,%rsi
  802627:	89 c7                	mov    %eax,%edi
  802629:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
  802635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263c:	79 05                	jns    802643 <close+0x31>
		return r;
  80263e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802641:	eb 18                	jmp    80265b <close+0x49>
	else
		return fd_close(fd, 1);
  802643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802647:	be 01 00 00 00       	mov    $0x1,%esi
  80264c:	48 89 c7             	mov    %rax,%rdi
  80264f:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  802656:	00 00 00 
  802659:	ff d0                	callq  *%rax
}
  80265b:	c9                   	leaveq 
  80265c:	c3                   	retq   

000000000080265d <close_all>:

void
close_all(void)
{
  80265d:	55                   	push   %rbp
  80265e:	48 89 e5             	mov    %rsp,%rbp
  802661:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802665:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80266c:	eb 15                	jmp    802683 <close_all+0x26>
		close(i);
  80266e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802671:	89 c7                	mov    %eax,%edi
  802673:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  80267a:	00 00 00 
  80267d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80267f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802683:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802687:	7e e5                	jle    80266e <close_all+0x11>
		close(i);
}
  802689:	c9                   	leaveq 
  80268a:	c3                   	retq   

000000000080268b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80268b:	55                   	push   %rbp
  80268c:	48 89 e5             	mov    %rsp,%rbp
  80268f:	48 83 ec 40          	sub    $0x40,%rsp
  802693:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802696:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802699:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80269d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026a0:	48 89 d6             	mov    %rdx,%rsi
  8026a3:	89 c7                	mov    %eax,%edi
  8026a5:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	callq  *%rax
  8026b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b8:	79 08                	jns    8026c2 <dup+0x37>
		return r;
  8026ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bd:	e9 70 01 00 00       	jmpq   802832 <dup+0x1a7>
	close(newfdnum);
  8026c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026c5:	89 c7                	mov    %eax,%edi
  8026c7:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  8026ce:	00 00 00 
  8026d1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d6:	48 98                	cltq   
  8026d8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026de:	48 c1 e0 0c          	shl    $0xc,%rax
  8026e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ea:	48 89 c7             	mov    %rax,%rdi
  8026ed:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802701:	48 89 c7             	mov    %rax,%rdi
  802704:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802718:	48 89 c2             	mov    %rax,%rdx
  80271b:	48 c1 ea 15          	shr    $0x15,%rdx
  80271f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802726:	01 00 00 
  802729:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272d:	83 e0 01             	and    $0x1,%eax
  802730:	84 c0                	test   %al,%al
  802732:	74 71                	je     8027a5 <dup+0x11a>
  802734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802738:	48 89 c2             	mov    %rax,%rdx
  80273b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80273f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802746:	01 00 00 
  802749:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274d:	83 e0 01             	and    $0x1,%eax
  802750:	84 c0                	test   %al,%al
  802752:	74 51                	je     8027a5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802758:	48 89 c2             	mov    %rax,%rdx
  80275b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80275f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802766:	01 00 00 
  802769:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802775:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277d:	41 89 c8             	mov    %ecx,%r8d
  802780:	48 89 d1             	mov    %rdx,%rcx
  802783:	ba 00 00 00 00       	mov    $0x0,%edx
  802788:	48 89 c6             	mov    %rax,%rsi
  80278b:	bf 00 00 00 00       	mov    $0x0,%edi
  802790:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  802797:	00 00 00 
  80279a:	ff d0                	callq  *%rax
  80279c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a3:	78 56                	js     8027fb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	48 89 c2             	mov    %rax,%rdx
  8027ac:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b7:	01 00 00 
  8027ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027be:	89 c1                	mov    %eax,%ecx
  8027c0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8027c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027ce:	41 89 c8             	mov    %ecx,%r8d
  8027d1:	48 89 d1             	mov    %rdx,%rcx
  8027d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d9:	48 89 c6             	mov    %rax,%rsi
  8027dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e1:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
  8027ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f4:	78 08                	js     8027fe <dup+0x173>
		goto err;

	return newfdnum;
  8027f6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f9:	eb 37                	jmp    802832 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8027fb:	90                   	nop
  8027fc:	eb 01                	jmp    8027ff <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8027fe:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8027ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802803:	48 89 c6             	mov    %rax,%rsi
  802806:	bf 00 00 00 00       	mov    $0x0,%edi
  80280b:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281b:	48 89 c6             	mov    %rax,%rsi
  80281e:	bf 00 00 00 00       	mov    $0x0,%edi
  802823:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  80282a:	00 00 00 
  80282d:	ff d0                	callq  *%rax
	return r;
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802832:	c9                   	leaveq 
  802833:	c3                   	retq   

0000000000802834 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802834:	55                   	push   %rbp
  802835:	48 89 e5             	mov    %rsp,%rbp
  802838:	48 83 ec 40          	sub    $0x40,%rsp
  80283c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80283f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802843:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802847:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80284b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80284e:	48 89 d6             	mov    %rdx,%rsi
  802851:	89 c7                	mov    %eax,%edi
  802853:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
  80285f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802866:	78 24                	js     80288c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286c:	8b 00                	mov    (%rax),%eax
  80286e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802872:	48 89 d6             	mov    %rdx,%rsi
  802875:	89 c7                	mov    %eax,%edi
  802877:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
  802883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288a:	79 05                	jns    802891 <read+0x5d>
		return r;
  80288c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288f:	eb 7a                	jmp    80290b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802895:	8b 40 08             	mov    0x8(%rax),%eax
  802898:	83 e0 03             	and    $0x3,%eax
  80289b:	83 f8 01             	cmp    $0x1,%eax
  80289e:	75 3a                	jne    8028da <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a7:	00 00 00 
  8028aa:	48 8b 00             	mov    (%rax),%rax
  8028ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028b6:	89 c6                	mov    %eax,%esi
  8028b8:	48 bf 1f 4b 80 00 00 	movabs $0x804b1f,%rdi
  8028bf:	00 00 00 
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c7:	48 b9 5f 03 80 00 00 	movabs $0x80035f,%rcx
  8028ce:	00 00 00 
  8028d1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d8:	eb 31                	jmp    80290b <read+0xd7>
	}
	if (!dev->dev_read)
  8028da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028e2:	48 85 c0             	test   %rax,%rax
  8028e5:	75 07                	jne    8028ee <read+0xba>
		return -E_NOT_SUPP;
  8028e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028ec:	eb 1d                	jmp    80290b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8028ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8028f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028fe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802902:	48 89 ce             	mov    %rcx,%rsi
  802905:	48 89 c7             	mov    %rax,%rdi
  802908:	41 ff d0             	callq  *%r8
}
  80290b:	c9                   	leaveq 
  80290c:	c3                   	retq   

000000000080290d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80290d:	55                   	push   %rbp
  80290e:	48 89 e5             	mov    %rsp,%rbp
  802911:	48 83 ec 30          	sub    $0x30,%rsp
  802915:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802918:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80291c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802920:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802927:	eb 46                	jmp    80296f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292c:	48 98                	cltq   
  80292e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802932:	48 29 c2             	sub    %rax,%rdx
  802935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802938:	48 98                	cltq   
  80293a:	48 89 c1             	mov    %rax,%rcx
  80293d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802941:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802944:	48 89 ce             	mov    %rcx,%rsi
  802947:	89 c7                	mov    %eax,%edi
  802949:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
  802955:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802958:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80295c:	79 05                	jns    802963 <readn+0x56>
			return m;
  80295e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802961:	eb 1d                	jmp    802980 <readn+0x73>
		if (m == 0)
  802963:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802967:	74 13                	je     80297c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802969:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80296f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802972:	48 98                	cltq   
  802974:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802978:	72 af                	jb     802929 <readn+0x1c>
  80297a:	eb 01                	jmp    80297d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80297c:	90                   	nop
	}
	return tot;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802980:	c9                   	leaveq 
  802981:	c3                   	retq   

0000000000802982 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802982:	55                   	push   %rbp
  802983:	48 89 e5             	mov    %rsp,%rbp
  802986:	48 83 ec 40          	sub    $0x40,%rsp
  80298a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802991:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802995:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802999:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299c:	48 89 d6             	mov    %rdx,%rsi
  80299f:	89 c7                	mov    %eax,%edi
  8029a1:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b4:	78 24                	js     8029da <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ba:	8b 00                	mov    (%rax),%eax
  8029bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c0:	48 89 d6             	mov    %rdx,%rsi
  8029c3:	89 c7                	mov    %eax,%edi
  8029c5:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
  8029d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d8:	79 05                	jns    8029df <write+0x5d>
		return r;
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dd:	eb 79                	jmp    802a58 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e3:	8b 40 08             	mov    0x8(%rax),%eax
  8029e6:	83 e0 03             	and    $0x3,%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 3a                	jne    802a27 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029f4:	00 00 00 
  8029f7:	48 8b 00             	mov    (%rax),%rax
  8029fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a03:	89 c6                	mov    %eax,%esi
  802a05:	48 bf 3b 4b 80 00 00 	movabs $0x804b3b,%rdi
  802a0c:	00 00 00 
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a14:	48 b9 5f 03 80 00 00 	movabs $0x80035f,%rcx
  802a1b:	00 00 00 
  802a1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a25:	eb 31                	jmp    802a58 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a2f:	48 85 c0             	test   %rax,%rax
  802a32:	75 07                	jne    802a3b <write+0xb9>
		return -E_NOT_SUPP;
  802a34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a39:	eb 1d                	jmp    802a58 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802a43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a4b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a4f:	48 89 ce             	mov    %rcx,%rsi
  802a52:	48 89 c7             	mov    %rax,%rdi
  802a55:	41 ff d0             	callq  *%r8
}
  802a58:	c9                   	leaveq 
  802a59:	c3                   	retq   

0000000000802a5a <seek>:

int
seek(int fdnum, off_t offset)
{
  802a5a:	55                   	push   %rbp
  802a5b:	48 89 e5             	mov    %rsp,%rbp
  802a5e:	48 83 ec 18          	sub    $0x18,%rsp
  802a62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a65:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a68:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a6f:	48 89 d6             	mov    %rdx,%rsi
  802a72:	89 c7                	mov    %eax,%edi
  802a74:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a87:	79 05                	jns    802a8e <seek+0x34>
		return r;
  802a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8c:	eb 0f                	jmp    802a9d <seek+0x43>
	fd->fd_offset = offset;
  802a8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a92:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a95:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9d:	c9                   	leaveq 
  802a9e:	c3                   	retq   

0000000000802a9f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a9f:	55                   	push   %rbp
  802aa0:	48 89 e5             	mov    %rsp,%rbp
  802aa3:	48 83 ec 30          	sub    $0x30,%rsp
  802aa7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aaa:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ab1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ab4:	48 89 d6             	mov    %rdx,%rsi
  802ab7:	89 c7                	mov    %eax,%edi
  802ab9:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acc:	78 24                	js     802af2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad2:	8b 00                	mov    (%rax),%eax
  802ad4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad8:	48 89 d6             	mov    %rdx,%rsi
  802adb:	89 c7                	mov    %eax,%edi
  802add:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
  802ae9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af0:	79 05                	jns    802af7 <ftruncate+0x58>
		return r;
  802af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af5:	eb 72                	jmp    802b69 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afb:	8b 40 08             	mov    0x8(%rax),%eax
  802afe:	83 e0 03             	and    $0x3,%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	75 3a                	jne    802b3f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b05:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b0c:	00 00 00 
  802b0f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b18:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b1b:	89 c6                	mov    %eax,%esi
  802b1d:	48 bf 58 4b 80 00 00 	movabs $0x804b58,%rdi
  802b24:	00 00 00 
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2c:	48 b9 5f 03 80 00 00 	movabs $0x80035f,%rcx
  802b33:	00 00 00 
  802b36:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b3d:	eb 2a                	jmp    802b69 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b43:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b47:	48 85 c0             	test   %rax,%rax
  802b4a:	75 07                	jne    802b53 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b51:	eb 16                	jmp    802b69 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b57:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802b62:	89 d6                	mov    %edx,%esi
  802b64:	48 89 c7             	mov    %rax,%rdi
  802b67:	ff d1                	callq  *%rcx
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 30          	sub    $0x30,%rsp
  802b73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b7a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b81:	48 89 d6             	mov    %rdx,%rsi
  802b84:	89 c7                	mov    %eax,%edi
  802b86:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
  802b92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b99:	78 24                	js     802bbf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9f:	8b 00                	mov    (%rax),%eax
  802ba1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba5:	48 89 d6             	mov    %rdx,%rsi
  802ba8:	89 c7                	mov    %eax,%edi
  802baa:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
  802bb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbd:	79 05                	jns    802bc4 <fstat+0x59>
		return r;
  802bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc2:	eb 5e                	jmp    802c22 <fstat+0xb7>
	if (!dev->dev_stat)
  802bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bcc:	48 85 c0             	test   %rax,%rax
  802bcf:	75 07                	jne    802bd8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bd1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bd6:	eb 4a                	jmp    802c22 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bdc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bea:	00 00 00 
	stat->st_isdir = 0;
  802bed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bf8:	00 00 00 
	stat->st_dev = dev;
  802bfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c03:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c16:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802c1a:	48 89 d6             	mov    %rdx,%rsi
  802c1d:	48 89 c7             	mov    %rax,%rdi
  802c20:	ff d1                	callq  *%rcx
}
  802c22:	c9                   	leaveq 
  802c23:	c3                   	retq   

0000000000802c24 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	48 83 ec 20          	sub    $0x20,%rsp
  802c2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c38:	be 00 00 00 00       	mov    $0x0,%esi
  802c3d:	48 89 c7             	mov    %rax,%rdi
  802c40:	48 b8 13 2d 80 00 00 	movabs $0x802d13,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	callq  *%rax
  802c4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c53:	79 05                	jns    802c5a <stat+0x36>
		return fd;
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	eb 2f                	jmp    802c89 <stat+0x65>
	r = fstat(fd, stat);
  802c5a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	48 89 d6             	mov    %rdx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c78:	89 c7                	mov    %eax,%edi
  802c7a:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
	return r;
  802c86:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c89:	c9                   	leaveq 
  802c8a:	c3                   	retq   
	...

0000000000802c8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c8c:	55                   	push   %rbp
  802c8d:	48 89 e5             	mov    %rsp,%rbp
  802c90:	48 83 ec 10          	sub    $0x10,%rsp
  802c94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c9b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ca2:	00 00 00 
  802ca5:	8b 00                	mov    (%rax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	75 1d                	jne    802cc8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cab:	bf 01 00 00 00       	mov    $0x1,%edi
  802cb0:	48 b8 92 43 80 00 00 	movabs $0x804392,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802cc3:	00 00 00 
  802cc6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cc8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ccf:	00 00 00 
  802cd2:	8b 00                	mov    (%rax),%eax
  802cd4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cd7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cdc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ce3:	00 00 00 
  802ce6:	89 c7                	mov    %eax,%edi
  802ce8:	48 b8 e3 42 80 00 00 	movabs $0x8042e3,%rax
  802cef:	00 00 00 
  802cf2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfd:	48 89 c6             	mov    %rax,%rsi
  802d00:	bf 00 00 00 00       	mov    $0x0,%edi
  802d05:	48 b8 fc 41 80 00 00 	movabs $0x8041fc,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
}
  802d11:	c9                   	leaveq 
  802d12:	c3                   	retq   

0000000000802d13 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802d13:	55                   	push   %rbp
  802d14:	48 89 e5             	mov    %rsp,%rbp
  802d17:	48 83 ec 20          	sub    $0x20,%rsp
  802d1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d26:	48 89 c7             	mov    %rax,%rdi
  802d29:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d3a:	7e 0a                	jle    802d46 <open+0x33>
		return -E_BAD_PATH;
  802d3c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d41:	e9 a5 00 00 00       	jmpq   802deb <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802d46:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d4a:	48 89 c7             	mov    %rax,%rdi
  802d4d:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d60:	79 08                	jns    802d6a <open+0x57>
		return r;
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	e9 81 00 00 00       	jmpq   802deb <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802d6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d71:	00 00 00 
  802d74:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d77:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d81:	48 89 c6             	mov    %rax,%rsi
  802d84:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d8b:	00 00 00 
  802d8e:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9e:	48 89 c6             	mov    %rax,%rsi
  802da1:	bf 01 00 00 00       	mov    $0x1,%edi
  802da6:	48 b8 8c 2c 80 00 00 	movabs $0x802c8c,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 1d                	jns    802dd8 <open+0xc5>
		fd_close(new_fd, 0);
  802dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbf:	be 00 00 00 00       	mov    $0x0,%esi
  802dc4:	48 89 c7             	mov    %rax,%rdi
  802dc7:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax
		return r;	
  802dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd6:	eb 13                	jmp    802deb <open+0xd8>
	}
	return fd2num(new_fd);
  802dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddc:	48 89 c7             	mov    %rax,%rdi
  802ddf:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax
}
  802deb:	c9                   	leaveq 
  802dec:	c3                   	retq   

0000000000802ded <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ded:	55                   	push   %rbp
  802dee:	48 89 e5             	mov    %rsp,%rbp
  802df1:	48 83 ec 10          	sub    $0x10,%rsp
  802df5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802df9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfd:	8b 50 0c             	mov    0xc(%rax),%edx
  802e00:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e07:	00 00 00 
  802e0a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e0c:	be 00 00 00 00       	mov    $0x0,%esi
  802e11:	bf 06 00 00 00       	mov    $0x6,%edi
  802e16:	48 b8 8c 2c 80 00 00 	movabs $0x802c8c,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
}
  802e22:	c9                   	leaveq 
  802e23:	c3                   	retq   

0000000000802e24 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e24:	55                   	push   %rbp
  802e25:	48 89 e5             	mov    %rsp,%rbp
  802e28:	48 83 ec 30          	sub    $0x30,%rsp
  802e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3c:	8b 50 0c             	mov    0xc(%rax),%edx
  802e3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e46:	00 00 00 
  802e49:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e4b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e52:	00 00 00 
  802e55:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e59:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802e5d:	be 00 00 00 00       	mov    $0x0,%esi
  802e62:	bf 03 00 00 00       	mov    $0x3,%edi
  802e67:	48 b8 8c 2c 80 00 00 	movabs $0x802c8c,%rax
  802e6e:	00 00 00 
  802e71:	ff d0                	callq  *%rax
  802e73:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7a:	7e 23                	jle    802e9f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7f:	48 63 d0             	movslq %eax,%rdx
  802e82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e86:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e8d:	00 00 00 
  802e90:	48 89 c7             	mov    %rax,%rdi
  802e93:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  802e9a:	00 00 00 
  802e9d:	ff d0                	callq  *%rax
	}
	return nbytes;
  802e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 20          	sub    $0x20,%rsp
  802eac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb8:	8b 50 0c             	mov    0xc(%rax),%edx
  802ebb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec2:	00 00 00 
  802ec5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ec7:	be 00 00 00 00       	mov    $0x0,%esi
  802ecc:	bf 05 00 00 00       	mov    $0x5,%edi
  802ed1:	48 b8 8c 2c 80 00 00 	movabs $0x802c8c,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
  802edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee4:	79 05                	jns    802eeb <devfile_stat+0x47>
		return r;
  802ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee9:	eb 56                	jmp    802f41 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802eeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eef:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ef6:	00 00 00 
  802ef9:	48 89 c7             	mov    %rax,%rdi
  802efc:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f0f:	00 00 00 
  802f12:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f1c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f22:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f29:	00 00 00 
  802f2c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f36:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f41:	c9                   	leaveq 
  802f42:	c3                   	retq   
	...

0000000000802f44 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802f44:	55                   	push   %rbp
  802f45:	48 89 e5             	mov    %rsp,%rbp
  802f48:	48 83 ec 20          	sub    $0x20,%rsp
  802f4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802f4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f56:	48 89 d6             	mov    %rdx,%rsi
  802f59:	89 c7                	mov    %eax,%edi
  802f5b:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6e:	79 05                	jns    802f75 <fd2sockid+0x31>
		return r;
  802f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f73:	eb 24                	jmp    802f99 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f79:	8b 10                	mov    (%rax),%edx
  802f7b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f82:	00 00 00 
  802f85:	8b 00                	mov    (%rax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	74 07                	je     802f92 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f8b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f90:	eb 07                	jmp    802f99 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f96:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f99:	c9                   	leaveq 
  802f9a:	c3                   	retq   

0000000000802f9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f9b:	55                   	push   %rbp
  802f9c:	48 89 e5             	mov    %rsp,%rbp
  802f9f:	48 83 ec 20          	sub    $0x20,%rsp
  802fa3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802fa6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802faa:	48 89 c7             	mov    %rax,%rdi
  802fad:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
  802fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc0:	78 26                	js     802fe8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	ba 07 04 00 00       	mov    $0x407,%edx
  802fcb:	48 89 c6             	mov    %rax,%rsi
  802fce:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd3:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe6:	79 16                	jns    802ffe <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802fe8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802feb:	89 c7                	mov    %eax,%edi
  802fed:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
		return r;
  802ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffc:	eb 3a                	jmp    803038 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803002:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803009:	00 00 00 
  80300c:	8b 12                	mov    (%rdx),%edx
  80300e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803014:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80301b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803022:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803029:	48 89 c7             	mov    %rax,%rdi
  80302c:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  803033:	00 00 00 
  803036:	ff d0                	callq  *%rax
}
  803038:	c9                   	leaveq 
  803039:	c3                   	retq   

000000000080303a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80303a:	55                   	push   %rbp
  80303b:	48 89 e5             	mov    %rsp,%rbp
  80303e:	48 83 ec 30          	sub    $0x30,%rsp
  803042:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803049:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80304d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803050:	89 c7                	mov    %eax,%edi
  803052:	48 b8 44 2f 80 00 00 	movabs $0x802f44,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
  80305e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803061:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803065:	79 05                	jns    80306c <accept+0x32>
		return r;
  803067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306a:	eb 3b                	jmp    8030a7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80306c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803070:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803077:	48 89 ce             	mov    %rcx,%rsi
  80307a:	89 c7                	mov    %eax,%edi
  80307c:	48 b8 85 33 80 00 00 	movabs $0x803385,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
  803088:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308f:	79 05                	jns    803096 <accept+0x5c>
		return r;
  803091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803094:	eb 11                	jmp    8030a7 <accept+0x6d>
	return alloc_sockfd(r);
  803096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803099:	89 c7                	mov    %eax,%edi
  80309b:	48 b8 9b 2f 80 00 00 	movabs $0x802f9b,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
}
  8030a7:	c9                   	leaveq 
  8030a8:	c3                   	retq   

00000000008030a9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8030a9:	55                   	push   %rbp
  8030aa:	48 89 e5             	mov    %rsp,%rbp
  8030ad:	48 83 ec 20          	sub    $0x20,%rsp
  8030b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030be:	89 c7                	mov    %eax,%edi
  8030c0:	48 b8 44 2f 80 00 00 	movabs $0x802f44,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d3:	79 05                	jns    8030da <bind+0x31>
		return r;
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	eb 1b                	jmp    8030f5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8030da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030dd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e4:	48 89 ce             	mov    %rcx,%rsi
  8030e7:	89 c7                	mov    %eax,%edi
  8030e9:	48 b8 04 34 80 00 00 	movabs $0x803404,%rax
  8030f0:	00 00 00 
  8030f3:	ff d0                	callq  *%rax
}
  8030f5:	c9                   	leaveq 
  8030f6:	c3                   	retq   

00000000008030f7 <shutdown>:

int
shutdown(int s, int how)
{
  8030f7:	55                   	push   %rbp
  8030f8:	48 89 e5             	mov    %rsp,%rbp
  8030fb:	48 83 ec 20          	sub    $0x20,%rsp
  8030ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803102:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803105:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803108:	89 c7                	mov    %eax,%edi
  80310a:	48 b8 44 2f 80 00 00 	movabs $0x802f44,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
  803116:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311d:	79 05                	jns    803124 <shutdown+0x2d>
		return r;
  80311f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803122:	eb 16                	jmp    80313a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803124:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	89 d6                	mov    %edx,%esi
  80312c:	89 c7                	mov    %eax,%edi
  80312e:	48 b8 68 34 80 00 00 	movabs $0x803468,%rax
  803135:	00 00 00 
  803138:	ff d0                	callq  *%rax
}
  80313a:	c9                   	leaveq 
  80313b:	c3                   	retq   

000000000080313c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80313c:	55                   	push   %rbp
  80313d:	48 89 e5             	mov    %rsp,%rbp
  803140:	48 83 ec 10          	sub    $0x10,%rsp
  803144:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80314c:	48 89 c7             	mov    %rax,%rdi
  80314f:	48 b8 20 44 80 00 00 	movabs $0x804420,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
  80315b:	83 f8 01             	cmp    $0x1,%eax
  80315e:	75 17                	jne    803177 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803164:	8b 40 0c             	mov    0xc(%rax),%eax
  803167:	89 c7                	mov    %eax,%edi
  803169:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  803170:	00 00 00 
  803173:	ff d0                	callq  *%rax
  803175:	eb 05                	jmp    80317c <devsock_close+0x40>
	else
		return 0;
  803177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80317c:	c9                   	leaveq 
  80317d:	c3                   	retq   

000000000080317e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80317e:	55                   	push   %rbp
  80317f:	48 89 e5             	mov    %rsp,%rbp
  803182:	48 83 ec 20          	sub    $0x20,%rsp
  803186:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803189:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80318d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803190:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803193:	89 c7                	mov    %eax,%edi
  803195:	48 b8 44 2f 80 00 00 	movabs $0x802f44,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
  8031a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a8:	79 05                	jns    8031af <connect+0x31>
		return r;
  8031aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ad:	eb 1b                	jmp    8031ca <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8031af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b9:	48 89 ce             	mov    %rcx,%rsi
  8031bc:	89 c7                	mov    %eax,%edi
  8031be:	48 b8 d5 34 80 00 00 	movabs $0x8034d5,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
}
  8031ca:	c9                   	leaveq 
  8031cb:	c3                   	retq   

00000000008031cc <listen>:

int
listen(int s, int backlog)
{
  8031cc:	55                   	push   %rbp
  8031cd:	48 89 e5             	mov    %rsp,%rbp
  8031d0:	48 83 ec 20          	sub    $0x20,%rsp
  8031d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031dd:	89 c7                	mov    %eax,%edi
  8031df:	48 b8 44 2f 80 00 00 	movabs $0x802f44,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
  8031eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f2:	79 05                	jns    8031f9 <listen+0x2d>
		return r;
  8031f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f7:	eb 16                	jmp    80320f <listen+0x43>
	return nsipc_listen(r, backlog);
  8031f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ff:	89 d6                	mov    %edx,%esi
  803201:	89 c7                	mov    %eax,%edi
  803203:	48 b8 39 35 80 00 00 	movabs $0x803539,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
}
  80320f:	c9                   	leaveq 
  803210:	c3                   	retq   

0000000000803211 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803211:	55                   	push   %rbp
  803212:	48 89 e5             	mov    %rsp,%rbp
  803215:	48 83 ec 20          	sub    $0x20,%rsp
  803219:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80321d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803221:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803229:	89 c2                	mov    %eax,%edx
  80322b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80322f:	8b 40 0c             	mov    0xc(%rax),%eax
  803232:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803236:	b9 00 00 00 00       	mov    $0x0,%ecx
  80323b:	89 c7                	mov    %eax,%edi
  80323d:	48 b8 79 35 80 00 00 	movabs $0x803579,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
}
  803249:	c9                   	leaveq 
  80324a:	c3                   	retq   

000000000080324b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80324b:	55                   	push   %rbp
  80324c:	48 89 e5             	mov    %rsp,%rbp
  80324f:	48 83 ec 20          	sub    $0x20,%rsp
  803253:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803257:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80325b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80325f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803263:	89 c2                	mov    %eax,%edx
  803265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803269:	8b 40 0c             	mov    0xc(%rax),%eax
  80326c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803270:	b9 00 00 00 00       	mov    $0x0,%ecx
  803275:	89 c7                	mov    %eax,%edi
  803277:	48 b8 45 36 80 00 00 	movabs $0x803645,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	48 83 ec 10          	sub    $0x10,%rsp
  80328d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803291:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803299:	48 be 83 4b 80 00 00 	movabs $0x804b83,%rsi
  8032a0:	00 00 00 
  8032a3:	48 89 c7             	mov    %rax,%rdi
  8032a6:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
	return 0;
  8032b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b7:	c9                   	leaveq 
  8032b8:	c3                   	retq   

00000000008032b9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 83 ec 20          	sub    $0x20,%rsp
  8032c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032c4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8032c7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032ca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032cd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032d3:	89 ce                	mov    %ecx,%esi
  8032d5:	89 c7                	mov    %eax,%edi
  8032d7:	48 b8 fd 36 80 00 00 	movabs $0x8036fd,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ea:	79 05                	jns    8032f1 <socket+0x38>
		return r;
  8032ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ef:	eb 11                	jmp    803302 <socket+0x49>
	return alloc_sockfd(r);
  8032f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f4:	89 c7                	mov    %eax,%edi
  8032f6:	48 b8 9b 2f 80 00 00 	movabs $0x802f9b,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
}
  803302:	c9                   	leaveq 
  803303:	c3                   	retq   

0000000000803304 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803304:	55                   	push   %rbp
  803305:	48 89 e5             	mov    %rsp,%rbp
  803308:	48 83 ec 10          	sub    $0x10,%rsp
  80330c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80330f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803316:	00 00 00 
  803319:	8b 00                	mov    (%rax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	75 1d                	jne    80333c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80331f:	bf 02 00 00 00       	mov    $0x2,%edi
  803324:	48 b8 92 43 80 00 00 	movabs $0x804392,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803337:	00 00 00 
  80333a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80333c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803343:	00 00 00 
  803346:	8b 00                	mov    (%rax),%eax
  803348:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80334b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803350:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803357:	00 00 00 
  80335a:	89 c7                	mov    %eax,%edi
  80335c:	48 b8 e3 42 80 00 00 	movabs $0x8042e3,%rax
  803363:	00 00 00 
  803366:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803368:	ba 00 00 00 00       	mov    $0x0,%edx
  80336d:	be 00 00 00 00       	mov    $0x0,%esi
  803372:	bf 00 00 00 00       	mov    $0x0,%edi
  803377:	48 b8 fc 41 80 00 00 	movabs $0x8041fc,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 30          	sub    $0x30,%rsp
  80338d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803390:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803394:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803398:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339f:	00 00 00 
  8033a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033a5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8033a7:	bf 01 00 00 00       	mov    $0x1,%edi
  8033ac:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  8033b3:	00 00 00 
  8033b6:	ff d0                	callq  *%rax
  8033b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033bf:	78 3e                	js     8033ff <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8033c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c8:	00 00 00 
  8033cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8033cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d3:	8b 40 10             	mov    0x10(%rax),%eax
  8033d6:	89 c2                	mov    %eax,%edx
  8033d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8033dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e0:	48 89 ce             	mov    %rcx,%rsi
  8033e3:	48 89 c7             	mov    %rax,%rdi
  8033e6:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8033f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f6:	8b 50 10             	mov    0x10(%rax),%edx
  8033f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8033ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803402:	c9                   	leaveq 
  803403:	c3                   	retq   

0000000000803404 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803404:	55                   	push   %rbp
  803405:	48 89 e5             	mov    %rsp,%rbp
  803408:	48 83 ec 10          	sub    $0x10,%rsp
  80340c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80340f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803413:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803416:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80341d:	00 00 00 
  803420:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803423:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803425:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342c:	48 89 c6             	mov    %rax,%rsi
  80342f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803436:	00 00 00 
  803439:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803445:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80344c:	00 00 00 
  80344f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803452:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803455:	bf 02 00 00 00       	mov    $0x2,%edi
  80345a:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
}
  803466:	c9                   	leaveq 
  803467:	c3                   	retq   

0000000000803468 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803468:	55                   	push   %rbp
  803469:	48 89 e5             	mov    %rsp,%rbp
  80346c:	48 83 ec 10          	sub    $0x10,%rsp
  803470:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803473:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803476:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347d:	00 00 00 
  803480:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803483:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803485:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348c:	00 00 00 
  80348f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803492:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803495:	bf 03 00 00 00       	mov    $0x3,%edi
  80349a:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
}
  8034a6:	c9                   	leaveq 
  8034a7:	c3                   	retq   

00000000008034a8 <nsipc_close>:

int
nsipc_close(int s)
{
  8034a8:	55                   	push   %rbp
  8034a9:	48 89 e5             	mov    %rsp,%rbp
  8034ac:	48 83 ec 10          	sub    $0x10,%rsp
  8034b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8034b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ba:	00 00 00 
  8034bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034c0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8034c2:	bf 04 00 00 00       	mov    $0x4,%edi
  8034c7:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  8034ce:	00 00 00 
  8034d1:	ff d0                	callq  *%rax
}
  8034d3:	c9                   	leaveq 
  8034d4:	c3                   	retq   

00000000008034d5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034d5:	55                   	push   %rbp
  8034d6:	48 89 e5             	mov    %rsp,%rbp
  8034d9:	48 83 ec 10          	sub    $0x10,%rsp
  8034dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8034e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ee:	00 00 00 
  8034f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034f4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8034f6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034fd:	48 89 c6             	mov    %rax,%rsi
  803500:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803507:	00 00 00 
  80350a:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803516:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80351d:	00 00 00 
  803520:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803523:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803526:	bf 05 00 00 00       	mov    $0x5,%edi
  80352b:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
}
  803537:	c9                   	leaveq 
  803538:	c3                   	retq   

0000000000803539 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803539:	55                   	push   %rbp
  80353a:	48 89 e5             	mov    %rsp,%rbp
  80353d:	48 83 ec 10          	sub    $0x10,%rsp
  803541:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803544:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803547:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80354e:	00 00 00 
  803551:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803554:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803556:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355d:	00 00 00 
  803560:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803563:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803566:	bf 06 00 00 00       	mov    $0x6,%edi
  80356b:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
}
  803577:	c9                   	leaveq 
  803578:	c3                   	retq   

0000000000803579 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803579:	55                   	push   %rbp
  80357a:	48 89 e5             	mov    %rsp,%rbp
  80357d:	48 83 ec 30          	sub    $0x30,%rsp
  803581:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803584:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803588:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80358b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80358e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803595:	00 00 00 
  803598:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80359b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80359d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a4:	00 00 00 
  8035a7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035aa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8035ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b4:	00 00 00 
  8035b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8035ba:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8035bd:	bf 07 00 00 00       	mov    $0x7,%edi
  8035c2:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
  8035ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d5:	78 69                	js     803640 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8035d7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8035de:	7f 08                	jg     8035e8 <nsipc_recv+0x6f>
  8035e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8035e6:	7e 35                	jle    80361d <nsipc_recv+0xa4>
  8035e8:	48 b9 8a 4b 80 00 00 	movabs $0x804b8a,%rcx
  8035ef:	00 00 00 
  8035f2:	48 ba 9f 4b 80 00 00 	movabs $0x804b9f,%rdx
  8035f9:	00 00 00 
  8035fc:	be 61 00 00 00       	mov    $0x61,%esi
  803601:	48 bf b4 4b 80 00 00 	movabs $0x804bb4,%rdi
  803608:	00 00 00 
  80360b:	b8 00 00 00 00       	mov    $0x0,%eax
  803610:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  803617:	00 00 00 
  80361a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80361d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803620:	48 63 d0             	movslq %eax,%rdx
  803623:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803627:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80362e:	00 00 00 
  803631:	48 89 c7             	mov    %rax,%rdi
  803634:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
	}

	return r;
  803640:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803643:	c9                   	leaveq 
  803644:	c3                   	retq   

0000000000803645 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803645:	55                   	push   %rbp
  803646:	48 89 e5             	mov    %rsp,%rbp
  803649:	48 83 ec 20          	sub    $0x20,%rsp
  80364d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803650:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803654:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803657:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80365a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803661:	00 00 00 
  803664:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803667:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803669:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803670:	7e 35                	jle    8036a7 <nsipc_send+0x62>
  803672:	48 b9 c0 4b 80 00 00 	movabs $0x804bc0,%rcx
  803679:	00 00 00 
  80367c:	48 ba 9f 4b 80 00 00 	movabs $0x804b9f,%rdx
  803683:	00 00 00 
  803686:	be 6c 00 00 00       	mov    $0x6c,%esi
  80368b:	48 bf b4 4b 80 00 00 	movabs $0x804bb4,%rdi
  803692:	00 00 00 
  803695:	b8 00 00 00 00       	mov    $0x0,%eax
  80369a:	49 b8 cc 3f 80 00 00 	movabs $0x803fcc,%r8
  8036a1:	00 00 00 
  8036a4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8036a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036aa:	48 63 d0             	movslq %eax,%rdx
  8036ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b1:	48 89 c6             	mov    %rax,%rsi
  8036b4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8036bb:	00 00 00 
  8036be:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8036ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d1:	00 00 00 
  8036d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8036da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e1:	00 00 00 
  8036e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036e7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8036ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8036ef:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
}
  8036fb:	c9                   	leaveq 
  8036fc:	c3                   	retq   

00000000008036fd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8036fd:	55                   	push   %rbp
  8036fe:	48 89 e5             	mov    %rsp,%rbp
  803701:	48 83 ec 10          	sub    $0x10,%rsp
  803705:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803708:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80370b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80370e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803715:	00 00 00 
  803718:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80371b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80371d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803724:	00 00 00 
  803727:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80372a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80372d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803734:	00 00 00 
  803737:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80373a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80373d:	bf 09 00 00 00       	mov    $0x9,%edi
  803742:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
}
  80374e:	c9                   	leaveq 
  80374f:	c3                   	retq   

0000000000803750 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803750:	55                   	push   %rbp
  803751:	48 89 e5             	mov    %rsp,%rbp
  803754:	53                   	push   %rbx
  803755:	48 83 ec 38          	sub    $0x38,%rsp
  803759:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80375d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803761:	48 89 c7             	mov    %rax,%rdi
  803764:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
  803770:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803773:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803777:	0f 88 bf 01 00 00    	js     80393c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80377d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803781:	ba 07 04 00 00       	mov    $0x407,%edx
  803786:	48 89 c6             	mov    %rax,%rsi
  803789:	bf 00 00 00 00       	mov    $0x0,%edi
  80378e:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
  80379a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80379d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037a1:	0f 88 95 01 00 00    	js     80393c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037a7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
  8037ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037c1:	0f 88 5d 01 00 00    	js     803924 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8037d0:	48 89 c6             	mov    %rax,%rsi
  8037d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d8:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
  8037e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037eb:	0f 88 33 01 00 00    	js     803924 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f5:	48 89 c7             	mov    %rax,%rdi
  8037f8:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803808:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80380c:	ba 07 04 00 00       	mov    $0x407,%edx
  803811:	48 89 c6             	mov    %rax,%rsi
  803814:	bf 00 00 00 00       	mov    $0x0,%edi
  803819:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803828:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80382c:	0f 88 d9 00 00 00    	js     80390b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803832:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
  803845:	48 89 c2             	mov    %rax,%rdx
  803848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80384c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803852:	48 89 d1             	mov    %rdx,%rcx
  803855:	ba 00 00 00 00       	mov    $0x0,%edx
  80385a:	48 89 c6             	mov    %rax,%rsi
  80385d:	bf 00 00 00 00       	mov    $0x0,%edi
  803862:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  803869:	00 00 00 
  80386c:	ff d0                	callq  *%rax
  80386e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803871:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803875:	78 79                	js     8038f0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803882:	00 00 00 
  803885:	8b 12                	mov    (%rdx),%edx
  803887:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803894:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803898:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80389f:	00 00 00 
  8038a2:	8b 12                	mov    (%rdx),%edx
  8038a4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038aa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b5:	48 89 c7             	mov    %rax,%rdi
  8038b8:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
  8038c4:	89 c2                	mov    %eax,%edx
  8038c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038ca:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038d0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8038d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d8:	48 89 c7             	mov    %rax,%rdi
  8038db:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
  8038e7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ee:	eb 4f                	jmp    80393f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8038f0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f5:	48 89 c6             	mov    %rax,%rsi
  8038f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038fd:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	eb 01                	jmp    80390c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80390b:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80390c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803910:	48 89 c6             	mov    %rax,%rsi
  803913:	bf 00 00 00 00       	mov    $0x0,%edi
  803918:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803928:	48 89 c6             	mov    %rax,%rsi
  80392b:	bf 00 00 00 00       	mov    $0x0,%edi
  803930:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
err:
	return r;
  80393c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80393f:	48 83 c4 38          	add    $0x38,%rsp
  803943:	5b                   	pop    %rbx
  803944:	5d                   	pop    %rbp
  803945:	c3                   	retq   

0000000000803946 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803946:	55                   	push   %rbp
  803947:	48 89 e5             	mov    %rsp,%rbp
  80394a:	53                   	push   %rbx
  80394b:	48 83 ec 28          	sub    $0x28,%rsp
  80394f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803953:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803957:	eb 01                	jmp    80395a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803959:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80395a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803961:	00 00 00 
  803964:	48 8b 00             	mov    (%rax),%rax
  803967:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80396d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803974:	48 89 c7             	mov    %rax,%rdi
  803977:	48 b8 20 44 80 00 00 	movabs $0x804420,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
  803983:	89 c3                	mov    %eax,%ebx
  803985:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803989:	48 89 c7             	mov    %rax,%rdi
  80398c:	48 b8 20 44 80 00 00 	movabs $0x804420,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
  803998:	39 c3                	cmp    %eax,%ebx
  80399a:	0f 94 c0             	sete   %al
  80399d:	0f b6 c0             	movzbl %al,%eax
  8039a0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039aa:	00 00 00 
  8039ad:	48 8b 00             	mov    (%rax),%rax
  8039b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039b6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039bc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039bf:	75 0a                	jne    8039cb <_pipeisclosed+0x85>
			return ret;
  8039c1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8039c4:	48 83 c4 28          	add    $0x28,%rsp
  8039c8:	5b                   	pop    %rbx
  8039c9:	5d                   	pop    %rbp
  8039ca:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8039cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ce:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039d1:	74 86                	je     803959 <_pipeisclosed+0x13>
  8039d3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039d7:	75 80                	jne    803959 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039d9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039e0:	00 00 00 
  8039e3:	48 8b 00             	mov    (%rax),%rax
  8039e6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8039ec:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f2:	89 c6                	mov    %eax,%esi
  8039f4:	48 bf d1 4b 80 00 00 	movabs $0x804bd1,%rdi
  8039fb:	00 00 00 
  8039fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803a03:	49 b8 5f 03 80 00 00 	movabs $0x80035f,%r8
  803a0a:	00 00 00 
  803a0d:	41 ff d0             	callq  *%r8
	}
  803a10:	e9 44 ff ff ff       	jmpq   803959 <_pipeisclosed+0x13>

0000000000803a15 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803a15:	55                   	push   %rbp
  803a16:	48 89 e5             	mov    %rsp,%rbp
  803a19:	48 83 ec 30          	sub    $0x30,%rsp
  803a1d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a20:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a24:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a27:	48 89 d6             	mov    %rdx,%rsi
  803a2a:	89 c7                	mov    %eax,%edi
  803a2c:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3f:	79 05                	jns    803a46 <pipeisclosed+0x31>
		return r;
  803a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a44:	eb 31                	jmp    803a77 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a4a:	48 89 c7             	mov    %rax,%rdi
  803a4d:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803a54:	00 00 00 
  803a57:	ff d0                	callq  *%rax
  803a59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a65:	48 89 d6             	mov    %rdx,%rsi
  803a68:	48 89 c7             	mov    %rax,%rdi
  803a6b:	48 b8 46 39 80 00 00 	movabs $0x803946,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
}
  803a77:	c9                   	leaveq 
  803a78:	c3                   	retq   

0000000000803a79 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a79:	55                   	push   %rbp
  803a7a:	48 89 e5             	mov    %rsp,%rbp
  803a7d:	48 83 ec 40          	sub    $0x40,%rsp
  803a81:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a85:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a89:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a91:	48 89 c7             	mov    %rax,%rdi
  803a94:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803a9b:	00 00 00 
  803a9e:	ff d0                	callq  *%rax
  803aa0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803aa4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aa8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ab3:	00 
  803ab4:	e9 97 00 00 00       	jmpq   803b50 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ab9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803abe:	74 09                	je     803ac9 <devpipe_read+0x50>
				return i;
  803ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac4:	e9 95 00 00 00       	jmpq   803b5e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ac9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad1:	48 89 d6             	mov    %rdx,%rsi
  803ad4:	48 89 c7             	mov    %rax,%rdi
  803ad7:	48 b8 46 39 80 00 00 	movabs $0x803946,%rax
  803ade:	00 00 00 
  803ae1:	ff d0                	callq  *%rax
  803ae3:	85 c0                	test   %eax,%eax
  803ae5:	74 07                	je     803aee <devpipe_read+0x75>
				return 0;
  803ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  803aec:	eb 70                	jmp    803b5e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803aee:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
  803afa:	eb 01                	jmp    803afd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803afc:	90                   	nop
  803afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b01:	8b 10                	mov    (%rax),%edx
  803b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b07:	8b 40 04             	mov    0x4(%rax),%eax
  803b0a:	39 c2                	cmp    %eax,%edx
  803b0c:	74 ab                	je     803ab9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b16:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1e:	8b 00                	mov    (%rax),%eax
  803b20:	89 c2                	mov    %eax,%edx
  803b22:	c1 fa 1f             	sar    $0x1f,%edx
  803b25:	c1 ea 1b             	shr    $0x1b,%edx
  803b28:	01 d0                	add    %edx,%eax
  803b2a:	83 e0 1f             	and    $0x1f,%eax
  803b2d:	29 d0                	sub    %edx,%eax
  803b2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b33:	48 98                	cltq   
  803b35:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b3a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b40:	8b 00                	mov    (%rax),%eax
  803b42:	8d 50 01             	lea    0x1(%rax),%edx
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b54:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b58:	72 a2                	jb     803afc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b5e:	c9                   	leaveq 
  803b5f:	c3                   	retq   

0000000000803b60 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b60:	55                   	push   %rbp
  803b61:	48 89 e5             	mov    %rsp,%rbp
  803b64:	48 83 ec 40          	sub    $0x40,%rsp
  803b68:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b6c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b70:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b78:	48 89 c7             	mov    %rax,%rdi
  803b7b:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803b82:	00 00 00 
  803b85:	ff d0                	callq  *%rax
  803b87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b93:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b9a:	00 
  803b9b:	e9 93 00 00 00       	jmpq   803c33 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ba0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ba4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba8:	48 89 d6             	mov    %rdx,%rsi
  803bab:	48 89 c7             	mov    %rax,%rdi
  803bae:	48 b8 46 39 80 00 00 	movabs $0x803946,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	74 07                	je     803bc5 <devpipe_write+0x65>
				return 0;
  803bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc3:	eb 7c                	jmp    803c41 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bc5:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
  803bd1:	eb 01                	jmp    803bd4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bd3:	90                   	nop
  803bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd8:	8b 40 04             	mov    0x4(%rax),%eax
  803bdb:	48 63 d0             	movslq %eax,%rdx
  803bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be2:	8b 00                	mov    (%rax),%eax
  803be4:	48 98                	cltq   
  803be6:	48 83 c0 20          	add    $0x20,%rax
  803bea:	48 39 c2             	cmp    %rax,%rdx
  803bed:	73 b1                	jae    803ba0 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf3:	8b 40 04             	mov    0x4(%rax),%eax
  803bf6:	89 c2                	mov    %eax,%edx
  803bf8:	c1 fa 1f             	sar    $0x1f,%edx
  803bfb:	c1 ea 1b             	shr    $0x1b,%edx
  803bfe:	01 d0                	add    %edx,%eax
  803c00:	83 e0 1f             	and    $0x1f,%eax
  803c03:	29 d0                	sub    %edx,%eax
  803c05:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c09:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c0d:	48 01 ca             	add    %rcx,%rdx
  803c10:	0f b6 0a             	movzbl (%rdx),%ecx
  803c13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c17:	48 98                	cltq   
  803c19:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c21:	8b 40 04             	mov    0x4(%rax),%eax
  803c24:	8d 50 01             	lea    0x1(%rax),%edx
  803c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c2e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c37:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c3b:	72 96                	jb     803bd3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c41:	c9                   	leaveq 
  803c42:	c3                   	retq   

0000000000803c43 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c43:	55                   	push   %rbp
  803c44:	48 89 e5             	mov    %rsp,%rbp
  803c47:	48 83 ec 20          	sub    $0x20,%rsp
  803c4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c4f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c57:	48 89 c7             	mov    %rax,%rdi
  803c5a:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
  803c66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c6e:	48 be e4 4b 80 00 00 	movabs $0x804be4,%rsi
  803c75:	00 00 00 
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8b:	8b 50 04             	mov    0x4(%rax),%edx
  803c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c92:	8b 00                	mov    (%rax),%eax
  803c94:	29 c2                	sub    %eax,%edx
  803c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c9a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ca0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cab:	00 00 00 
	stat->st_dev = &devpipe;
  803cae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cb9:	00 00 00 
  803cbc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc8:	c9                   	leaveq 
  803cc9:	c3                   	retq   

0000000000803cca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803cca:	55                   	push   %rbp
  803ccb:	48 89 e5             	mov    %rsp,%rbp
  803cce:	48 83 ec 10          	sub    $0x10,%rsp
  803cd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cda:	48 89 c6             	mov    %rax,%rsi
  803cdd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce2:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf2:	48 89 c7             	mov    %rax,%rdi
  803cf5:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  803cfc:	00 00 00 
  803cff:	ff d0                	callq  *%rax
  803d01:	48 89 c6             	mov    %rax,%rsi
  803d04:	bf 00 00 00 00       	mov    $0x0,%edi
  803d09:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
}
  803d15:	c9                   	leaveq 
  803d16:	c3                   	retq   
	...

0000000000803d18 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d18:	55                   	push   %rbp
  803d19:	48 89 e5             	mov    %rsp,%rbp
  803d1c:	48 83 ec 20          	sub    $0x20,%rsp
  803d20:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d26:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d29:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d2d:	be 01 00 00 00       	mov    $0x1,%esi
  803d32:	48 89 c7             	mov    %rax,%rdi
  803d35:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
}
  803d41:	c9                   	leaveq 
  803d42:	c3                   	retq   

0000000000803d43 <getchar>:

int
getchar(void)
{
  803d43:	55                   	push   %rbp
  803d44:	48 89 e5             	mov    %rsp,%rbp
  803d47:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d4b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d4f:	ba 01 00 00 00       	mov    $0x1,%edx
  803d54:	48 89 c6             	mov    %rax,%rsi
  803d57:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5c:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  803d63:	00 00 00 
  803d66:	ff d0                	callq  *%rax
  803d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6f:	79 05                	jns    803d76 <getchar+0x33>
		return r;
  803d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d74:	eb 14                	jmp    803d8a <getchar+0x47>
	if (r < 1)
  803d76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7a:	7f 07                	jg     803d83 <getchar+0x40>
		return -E_EOF;
  803d7c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d81:	eb 07                	jmp    803d8a <getchar+0x47>
	return c;
  803d83:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d87:	0f b6 c0             	movzbl %al,%eax
}
  803d8a:	c9                   	leaveq 
  803d8b:	c3                   	retq   

0000000000803d8c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d8c:	55                   	push   %rbp
  803d8d:	48 89 e5             	mov    %rsp,%rbp
  803d90:	48 83 ec 20          	sub    $0x20,%rsp
  803d94:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d9e:	48 89 d6             	mov    %rdx,%rsi
  803da1:	89 c7                	mov    %eax,%edi
  803da3:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
  803daf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db6:	79 05                	jns    803dbd <iscons+0x31>
		return r;
  803db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbb:	eb 1a                	jmp    803dd7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc1:	8b 10                	mov    (%rax),%edx
  803dc3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803dca:	00 00 00 
  803dcd:	8b 00                	mov    (%rax),%eax
  803dcf:	39 c2                	cmp    %eax,%edx
  803dd1:	0f 94 c0             	sete   %al
  803dd4:	0f b6 c0             	movzbl %al,%eax
}
  803dd7:	c9                   	leaveq 
  803dd8:	c3                   	retq   

0000000000803dd9 <opencons>:

int
opencons(void)
{
  803dd9:	55                   	push   %rbp
  803dda:	48 89 e5             	mov    %rsp,%rbp
  803ddd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803de1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803de5:	48 89 c7             	mov    %rax,%rdi
  803de8:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  803def:	00 00 00 
  803df2:	ff d0                	callq  *%rax
  803df4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dfb:	79 05                	jns    803e02 <opencons+0x29>
		return r;
  803dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e00:	eb 5b                	jmp    803e5d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e06:	ba 07 04 00 00       	mov    $0x407,%edx
  803e0b:	48 89 c6             	mov    %rax,%rsi
  803e0e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e13:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
  803e1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e26:	79 05                	jns    803e2d <opencons+0x54>
		return r;
  803e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2b:	eb 30                	jmp    803e5d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e31:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e38:	00 00 00 
  803e3b:	8b 12                	mov    (%rdx),%edx
  803e3d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e43:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4e:	48 89 c7             	mov    %rax,%rdi
  803e51:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  803e58:	00 00 00 
  803e5b:	ff d0                	callq  *%rax
}
  803e5d:	c9                   	leaveq 
  803e5e:	c3                   	retq   

0000000000803e5f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e5f:	55                   	push   %rbp
  803e60:	48 89 e5             	mov    %rsp,%rbp
  803e63:	48 83 ec 30          	sub    $0x30,%rsp
  803e67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e73:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e78:	75 13                	jne    803e8d <devcons_read+0x2e>
		return 0;
  803e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7f:	eb 49                	jmp    803eca <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e81:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  803e88:	00 00 00 
  803e8b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e8d:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  803e94:	00 00 00 
  803e97:	ff d0                	callq  *%rax
  803e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea0:	74 df                	je     803e81 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea6:	79 05                	jns    803ead <devcons_read+0x4e>
		return c;
  803ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eab:	eb 1d                	jmp    803eca <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ead:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803eb1:	75 07                	jne    803eba <devcons_read+0x5b>
		return 0;
  803eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb8:	eb 10                	jmp    803eca <devcons_read+0x6b>
	*(char*)vbuf = c;
  803eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebd:	89 c2                	mov    %eax,%edx
  803ebf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec3:	88 10                	mov    %dl,(%rax)
	return 1;
  803ec5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803eca:	c9                   	leaveq 
  803ecb:	c3                   	retq   

0000000000803ecc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ecc:	55                   	push   %rbp
  803ecd:	48 89 e5             	mov    %rsp,%rbp
  803ed0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ed7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ede:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ee5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ef3:	eb 77                	jmp    803f6c <devcons_write+0xa0>
		m = n - tot;
  803ef5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803efc:	89 c2                	mov    %eax,%edx
  803efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f01:	89 d1                	mov    %edx,%ecx
  803f03:	29 c1                	sub    %eax,%ecx
  803f05:	89 c8                	mov    %ecx,%eax
  803f07:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f0d:	83 f8 7f             	cmp    $0x7f,%eax
  803f10:	76 07                	jbe    803f19 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803f12:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f1c:	48 63 d0             	movslq %eax,%rdx
  803f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f22:	48 98                	cltq   
  803f24:	48 89 c1             	mov    %rax,%rcx
  803f27:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803f2e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f35:	48 89 ce             	mov    %rcx,%rsi
  803f38:	48 89 c7             	mov    %rax,%rdi
  803f3b:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f4a:	48 63 d0             	movslq %eax,%rdx
  803f4d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f54:	48 89 d6             	mov    %rdx,%rsi
  803f57:	48 89 c7             	mov    %rax,%rdi
  803f5a:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f69:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6f:	48 98                	cltq   
  803f71:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f78:	0f 82 77 ff ff ff    	jb     803ef5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f81:	c9                   	leaveq 
  803f82:	c3                   	retq   

0000000000803f83 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f83:	55                   	push   %rbp
  803f84:	48 89 e5             	mov    %rsp,%rbp
  803f87:	48 83 ec 08          	sub    $0x8,%rsp
  803f8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f94:	c9                   	leaveq 
  803f95:	c3                   	retq   

0000000000803f96 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f96:	55                   	push   %rbp
  803f97:	48 89 e5             	mov    %rsp,%rbp
  803f9a:	48 83 ec 10          	sub    $0x10,%rsp
  803f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803faa:	48 be f0 4b 80 00 00 	movabs $0x804bf0,%rsi
  803fb1:	00 00 00 
  803fb4:	48 89 c7             	mov    %rax,%rdi
  803fb7:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
	return 0;
  803fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc8:	c9                   	leaveq 
  803fc9:	c3                   	retq   
	...

0000000000803fcc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803fcc:	55                   	push   %rbp
  803fcd:	48 89 e5             	mov    %rsp,%rbp
  803fd0:	53                   	push   %rbx
  803fd1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803fd8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803fdf:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803fe5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803fec:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ff3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ffa:	84 c0                	test   %al,%al
  803ffc:	74 23                	je     804021 <_panic+0x55>
  803ffe:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804005:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804009:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80400d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804011:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804015:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804019:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80401d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804021:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804028:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80402f:	00 00 00 
  804032:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804039:	00 00 00 
  80403c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804040:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804047:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80404e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804055:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80405c:	00 00 00 
  80405f:	48 8b 18             	mov    (%rax),%rbx
  804062:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
  80406e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804074:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80407b:	41 89 c8             	mov    %ecx,%r8d
  80407e:	48 89 d1             	mov    %rdx,%rcx
  804081:	48 89 da             	mov    %rbx,%rdx
  804084:	89 c6                	mov    %eax,%esi
  804086:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  80408d:	00 00 00 
  804090:	b8 00 00 00 00       	mov    $0x0,%eax
  804095:	49 b9 5f 03 80 00 00 	movabs $0x80035f,%r9
  80409c:	00 00 00 
  80409f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8040a2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8040a9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8040b0:	48 89 d6             	mov    %rdx,%rsi
  8040b3:	48 89 c7             	mov    %rax,%rdi
  8040b6:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  8040bd:	00 00 00 
  8040c0:	ff d0                	callq  *%rax
	cprintf("\n");
  8040c2:	48 bf 1b 4c 80 00 00 	movabs $0x804c1b,%rdi
  8040c9:	00 00 00 
  8040cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d1:	48 ba 5f 03 80 00 00 	movabs $0x80035f,%rdx
  8040d8:	00 00 00 
  8040db:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8040dd:	cc                   	int3   
  8040de:	eb fd                	jmp    8040dd <_panic+0x111>

00000000008040e0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040e0:	55                   	push   %rbp
  8040e1:	48 89 e5             	mov    %rsp,%rbp
  8040e4:	48 83 ec 10          	sub    $0x10,%rsp
  8040e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8040ec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040f3:	00 00 00 
  8040f6:	48 8b 00             	mov    (%rax),%rax
  8040f9:	48 85 c0             	test   %rax,%rax
  8040fc:	75 66                	jne    804164 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8040fe:	ba 07 00 00 00       	mov    $0x7,%edx
  804103:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804108:	bf 00 00 00 00       	mov    $0x0,%edi
  80410d:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  804114:	00 00 00 
  804117:	ff d0                	callq  *%rax
  804119:	85 c0                	test   %eax,%eax
  80411b:	75 1d                	jne    80413a <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80411d:	48 be 78 41 80 00 00 	movabs $0x804178,%rsi
  804124:	00 00 00 
  804127:	bf 00 00 00 00       	mov    $0x0,%edi
  80412c:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  804133:	00 00 00 
  804136:	ff d0                	callq  *%rax
  804138:	eb 2a                	jmp    804164 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  80413a:	48 ba 1d 4c 80 00 00 	movabs $0x804c1d,%rdx
  804141:	00 00 00 
  804144:	be 23 00 00 00       	mov    $0x23,%esi
  804149:	48 bf 3b 4c 80 00 00 	movabs $0x804c3b,%rdi
  804150:	00 00 00 
  804153:	b8 00 00 00 00       	mov    $0x0,%eax
  804158:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  80415f:	00 00 00 
  804162:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804164:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80416b:	00 00 00 
  80416e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804172:	48 89 10             	mov    %rdx,(%rax)
}
  804175:	c9                   	leaveq 
  804176:	c3                   	retq   
	...

0000000000804178 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804178:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80417b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804182:	00 00 00 
call *%rax
  804185:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804187:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  80418b:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804190:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804197:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804198:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  80419c:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80419f:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  8041a6:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  8041a7:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041ab:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041b0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041b5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041ba:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8041bf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8041c4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8041c9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8041ce:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8041d3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8041d8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8041dd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8041e2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8041e7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8041ec:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8041f1:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8041f5:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8041f9:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8041fa:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8041fb:	c3                   	retq   

00000000008041fc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041fc:	55                   	push   %rbp
  8041fd:	48 89 e5             	mov    %rsp,%rbp
  804200:	48 83 ec 30          	sub    $0x30,%rsp
  804204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804208:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80420c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  804217:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80421c:	74 18                	je     804236 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  80421e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804222:	48 89 c7             	mov    %rax,%rdi
  804225:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  80422c:	00 00 00 
  80422f:	ff d0                	callq  *%rax
  804231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804234:	eb 19                	jmp    80424f <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  804236:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  80423d:	00 00 00 
  804240:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  804247:	00 00 00 
  80424a:	ff d0                	callq  *%rax
  80424c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80424f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804253:	79 39                	jns    80428e <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804255:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80425a:	75 08                	jne    804264 <ipc_recv+0x68>
  80425c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804260:	8b 00                	mov    (%rax),%eax
  804262:	eb 05                	jmp    804269 <ipc_recv+0x6d>
  804264:	b8 00 00 00 00       	mov    $0x0,%eax
  804269:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80426d:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80426f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804274:	75 08                	jne    80427e <ipc_recv+0x82>
  804276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80427a:	8b 00                	mov    (%rax),%eax
  80427c:	eb 05                	jmp    804283 <ipc_recv+0x87>
  80427e:	b8 00 00 00 00       	mov    $0x0,%eax
  804283:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804287:	89 02                	mov    %eax,(%rdx)
		return r;
  804289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80428c:	eb 53                	jmp    8042e1 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80428e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804293:	74 19                	je     8042ae <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804295:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80429c:	00 00 00 
  80429f:	48 8b 00             	mov    (%rax),%rax
  8042a2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ac:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  8042ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042b3:	74 19                	je     8042ce <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  8042b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042bc:	00 00 00 
  8042bf:	48 8b 00             	mov    (%rax),%rax
  8042c2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042cc:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  8042ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8042d5:	00 00 00 
  8042d8:	48 8b 00             	mov    (%rax),%rax
  8042db:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8042e1:	c9                   	leaveq 
  8042e2:	c3                   	retq   

00000000008042e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042e3:	55                   	push   %rbp
  8042e4:	48 89 e5             	mov    %rsp,%rbp
  8042e7:	48 83 ec 30          	sub    $0x30,%rsp
  8042eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042ee:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042f1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042f5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8042f8:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8042ff:	eb 59                	jmp    80435a <ipc_send+0x77>
		if(pg) {
  804301:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804306:	74 20                	je     804328 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804308:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80430b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80430e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804312:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804315:	89 c7                	mov    %eax,%edi
  804317:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  80431e:	00 00 00 
  804321:	ff d0                	callq  *%rax
  804323:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804326:	eb 26                	jmp    80434e <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  804328:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80432b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80432e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804331:	89 d1                	mov    %edx,%ecx
  804333:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80433a:	00 00 00 
  80433d:	89 c7                	mov    %eax,%edi
  80433f:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
  80434b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80434e:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  80435a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80435e:	74 a1                	je     804301 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804360:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804364:	74 2a                	je     804390 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804366:	48 ba 50 4c 80 00 00 	movabs $0x804c50,%rdx
  80436d:	00 00 00 
  804370:	be 49 00 00 00       	mov    $0x49,%esi
  804375:	48 bf 7b 4c 80 00 00 	movabs $0x804c7b,%rdi
  80437c:	00 00 00 
  80437f:	b8 00 00 00 00       	mov    $0x0,%eax
  804384:	48 b9 cc 3f 80 00 00 	movabs $0x803fcc,%rcx
  80438b:	00 00 00 
  80438e:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 83 ec 18          	sub    $0x18,%rsp
  80439a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80439d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043a4:	eb 6a                	jmp    804410 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  8043a6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043ad:	00 00 00 
  8043b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b3:	48 63 d0             	movslq %eax,%rdx
  8043b6:	48 89 d0             	mov    %rdx,%rax
  8043b9:	48 c1 e0 02          	shl    $0x2,%rax
  8043bd:	48 01 d0             	add    %rdx,%rax
  8043c0:	48 01 c0             	add    %rax,%rax
  8043c3:	48 01 d0             	add    %rdx,%rax
  8043c6:	48 c1 e0 05          	shl    $0x5,%rax
  8043ca:	48 01 c8             	add    %rcx,%rax
  8043cd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043d3:	8b 00                	mov    (%rax),%eax
  8043d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043d8:	75 32                	jne    80440c <ipc_find_env+0x7a>
			return envs[i].env_id;
  8043da:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043e1:	00 00 00 
  8043e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e7:	48 63 d0             	movslq %eax,%rdx
  8043ea:	48 89 d0             	mov    %rdx,%rax
  8043ed:	48 c1 e0 02          	shl    $0x2,%rax
  8043f1:	48 01 d0             	add    %rdx,%rax
  8043f4:	48 01 c0             	add    %rax,%rax
  8043f7:	48 01 d0             	add    %rdx,%rax
  8043fa:	48 c1 e0 05          	shl    $0x5,%rax
  8043fe:	48 01 c8             	add    %rcx,%rax
  804401:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804407:	8b 40 08             	mov    0x8(%rax),%eax
  80440a:	eb 12                	jmp    80441e <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80440c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804410:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804417:	7e 8d                	jle    8043a6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80441e:	c9                   	leaveq 
  80441f:	c3                   	retq   

0000000000804420 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804420:	55                   	push   %rbp
  804421:	48 89 e5             	mov    %rsp,%rbp
  804424:	48 83 ec 18          	sub    $0x18,%rsp
  804428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80442c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804430:	48 89 c2             	mov    %rax,%rdx
  804433:	48 c1 ea 15          	shr    $0x15,%rdx
  804437:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80443e:	01 00 00 
  804441:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804445:	83 e0 01             	and    $0x1,%eax
  804448:	48 85 c0             	test   %rax,%rax
  80444b:	75 07                	jne    804454 <pageref+0x34>
		return 0;
  80444d:	b8 00 00 00 00       	mov    $0x0,%eax
  804452:	eb 53                	jmp    8044a7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804458:	48 89 c2             	mov    %rax,%rdx
  80445b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80445f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804466:	01 00 00 
  804469:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80446d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804475:	83 e0 01             	and    $0x1,%eax
  804478:	48 85 c0             	test   %rax,%rax
  80447b:	75 07                	jne    804484 <pageref+0x64>
		return 0;
  80447d:	b8 00 00 00 00       	mov    $0x0,%eax
  804482:	eb 23                	jmp    8044a7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804488:	48 89 c2             	mov    %rax,%rdx
  80448b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80448f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804496:	00 00 00 
  804499:	48 c1 e2 04          	shl    $0x4,%rdx
  80449d:	48 01 d0             	add    %rdx,%rax
  8044a0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044a4:	0f b7 c0             	movzwl %ax,%eax
}
  8044a7:	c9                   	leaveq 
  8044a8:	c3                   	retq   
