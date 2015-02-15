
obj/user/testpteshare.debug:     file format elf64-x86-64


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
  80003c:	e8 6b 02 00 00       	callq  8002ac <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800053:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800057:	74 0c                	je     800065 <umain+0x21>
		childofspawn();
  800059:	48 b8 76 02 80 00 00 	movabs $0x800276,%rax
  800060:	00 00 00 
  800063:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800065:	ba 07 04 00 00       	mov    $0x407,%edx
  80006a:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
  800074:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800083:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba be 52 80 00 00 	movabs $0x8052be,%rdx
  800095:	00 00 00 
  800098:	be 13 00 00 00       	mov    $0x13,%esi
  80009d:	48 bf d1 52 80 00 00 	movabs $0x8052d1,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b9:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xba>
		panic("fork: %e", r);
  8000ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba e5 52 80 00 00 	movabs $0x8052e5,%rdx
  8000da:	00 00 00 
  8000dd:	be 17 00 00 00       	mov    $0x17,%esi
  8000e2:	48 bf d1 52 80 00 00 	movabs $0x8052d1,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800102:	75 2d                	jne    800131 <umain+0xed>
		strcpy(VA, msg);
  800104:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010b:	00 00 00 
  80010e:	48 8b 00             	mov    (%rax),%rax
  800111:	48 89 c6             	mov    %rax,%rsi
  800114:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800119:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
		exit();
  800125:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	callq  *%rax
	}
	wait(r);
  800131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800134:	89 c7                	mov    %eax,%edi
  800136:	48 b8 74 4b 80 00 00 	movabs $0x804b74,%rax
  80013d:	00 00 00 
  800140:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800142:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800149:	00 00 00 
  80014c:	48 8b 00             	mov    (%rax),%rax
  80014f:	48 89 c6             	mov    %rax,%rsi
  800152:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800157:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	85 c0                	test   %eax,%eax
  800165:	75 0c                	jne    800173 <umain+0x12f>
  800167:	48 b8 ee 52 80 00 00 	movabs $0x8052ee,%rax
  80016e:	00 00 00 
  800171:	eb 0a                	jmp    80017d <umain+0x139>
  800173:	48 b8 f4 52 80 00 00 	movabs $0x8052f4,%rax
  80017a:	00 00 00 
  80017d:	48 89 c6             	mov    %rax,%rsi
  800180:	48 bf fa 52 80 00 00 	movabs $0x8052fa,%rdi
  800187:	00 00 00 
  80018a:	b8 00 00 00 00       	mov    $0x0,%eax
  80018f:	48 ba b3 05 80 00 00 	movabs $0x8005b3,%rdx
  800196:	00 00 00 
  800199:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a0:	48 ba 15 53 80 00 00 	movabs $0x805315,%rdx
  8001a7:	00 00 00 
  8001aa:	48 be 19 53 80 00 00 	movabs $0x805319,%rsi
  8001b1:	00 00 00 
  8001b4:	48 bf 26 53 80 00 00 	movabs $0x805326,%rdi
  8001bb:	00 00 00 
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c3:	49 b8 0b 35 80 00 00 	movabs $0x80350b,%r8
  8001ca:	00 00 00 
  8001cd:	41 ff d0             	callq  *%r8
  8001d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d7:	79 30                	jns    800209 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dc:	89 c1                	mov    %eax,%ecx
  8001de:	48 ba 38 53 80 00 00 	movabs $0x805338,%rdx
  8001e5:	00 00 00 
  8001e8:	be 21 00 00 00       	mov    $0x21,%esi
  8001ed:	48 bf d1 52 80 00 00 	movabs $0x8052d1,%rdi
  8001f4:	00 00 00 
  8001f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fc:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  800203:	00 00 00 
  800206:	41 ff d0             	callq  *%r8
	wait(r);
  800209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020c:	89 c7                	mov    %eax,%edi
  80020e:	48 b8 74 4b 80 00 00 	movabs $0x804b74,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80021a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800221:	00 00 00 
  800224:	48 8b 00             	mov    (%rax),%rax
  800227:	48 89 c6             	mov    %rax,%rsi
  80022a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022f:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
  80023b:	85 c0                	test   %eax,%eax
  80023d:	75 0c                	jne    80024b <umain+0x207>
  80023f:	48 b8 ee 52 80 00 00 	movabs $0x8052ee,%rax
  800246:	00 00 00 
  800249:	eb 0a                	jmp    800255 <umain+0x211>
  80024b:	48 b8 f4 52 80 00 00 	movabs $0x8052f4,%rax
  800252:	00 00 00 
  800255:	48 89 c6             	mov    %rax,%rsi
  800258:	48 bf 42 53 80 00 00 	movabs $0x805342,%rdi
  80025f:	00 00 00 
  800262:	b8 00 00 00 00       	mov    $0x0,%eax
  800267:	48 ba b3 05 80 00 00 	movabs $0x8005b3,%rdx
  80026e:	00 00 00 
  800271:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800273:	cc                   	int3   

	breakpoint();
}
  800274:	c9                   	leaveq 
  800275:	c3                   	retq   

0000000000800276 <childofspawn>:

void
childofspawn(void)
{
  800276:	55                   	push   %rbp
  800277:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  80027a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800281:	00 00 00 
  800284:	48 8b 00             	mov    (%rax),%rax
  800287:	48 89 c6             	mov    %rax,%rsi
  80028a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028f:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
	exit();
  80029b:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
}
  8002a7:	5d                   	pop    %rbp
  8002a8:	c3                   	retq   
  8002a9:	00 00                	add    %al,(%rax)
	...

00000000008002ac <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002ac:	55                   	push   %rbp
  8002ad:	48 89 e5             	mov    %rsp,%rbp
  8002b0:	48 83 ec 10          	sub    $0x10,%rsp
  8002b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002bb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002c2:	00 00 00 
  8002c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8002cc:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	48 98                	cltq   
  8002da:	48 89 c2             	mov    %rax,%rdx
  8002dd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8002e3:	48 89 d0             	mov    %rdx,%rax
  8002e6:	48 c1 e0 02          	shl    $0x2,%rax
  8002ea:	48 01 d0             	add    %rdx,%rax
  8002ed:	48 01 c0             	add    %rax,%rax
  8002f0:	48 01 d0             	add    %rdx,%rax
  8002f3:	48 c1 e0 05          	shl    $0x5,%rax
  8002f7:	48 89 c2             	mov    %rax,%rdx
  8002fa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800301:	00 00 00 
  800304:	48 01 c2             	add    %rax,%rdx
  800307:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80030e:	00 00 00 
  800311:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800314:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800318:	7e 14                	jle    80032e <libmain+0x82>
		binaryname = argv[0];
  80031a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031e:	48 8b 10             	mov    (%rax),%rdx
  800321:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800328:	00 00 00 
  80032b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80032e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800335:	48 89 d6             	mov    %rdx,%rsi
  800338:	89 c7                	mov    %eax,%edi
  80033a:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800346:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  80034d:	00 00 00 
  800350:	ff d0                	callq  *%rax
}
  800352:	c9                   	leaveq 
  800353:	c3                   	retq   

0000000000800354 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800354:	55                   	push   %rbp
  800355:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800358:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800364:	bf 00 00 00 00       	mov    $0x0,%edi
  800369:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	5d                   	pop    %rbp
  800376:	c3                   	retq   
	...

0000000000800378 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	53                   	push   %rbx
  80037d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800384:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80038b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800391:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800398:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80039f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003a6:	84 c0                	test   %al,%al
  8003a8:	74 23                	je     8003cd <_panic+0x55>
  8003aa:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003b1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003b5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003b9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003bd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003c1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003c5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003c9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003cd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003d4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003db:	00 00 00 
  8003de:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003e5:	00 00 00 
  8003e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ec:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003f3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800401:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800408:	00 00 00 
  80040b:	48 8b 18             	mov    (%rax),%rbx
  80040e:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  800415:	00 00 00 
  800418:	ff d0                	callq  *%rax
  80041a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800420:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800427:	41 89 c8             	mov    %ecx,%r8d
  80042a:	48 89 d1             	mov    %rdx,%rcx
  80042d:	48 89 da             	mov    %rbx,%rdx
  800430:	89 c6                	mov    %eax,%esi
  800432:	48 bf 68 53 80 00 00 	movabs $0x805368,%rdi
  800439:	00 00 00 
  80043c:	b8 00 00 00 00       	mov    $0x0,%eax
  800441:	49 b9 b3 05 80 00 00 	movabs $0x8005b3,%r9
  800448:	00 00 00 
  80044b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80044e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800455:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80045c:	48 89 d6             	mov    %rdx,%rsi
  80045f:	48 89 c7             	mov    %rax,%rdi
  800462:	48 b8 07 05 80 00 00 	movabs $0x800507,%rax
  800469:	00 00 00 
  80046c:	ff d0                	callq  *%rax
	cprintf("\n");
  80046e:	48 bf 8b 53 80 00 00 	movabs $0x80538b,%rdi
  800475:	00 00 00 
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	48 ba b3 05 80 00 00 	movabs $0x8005b3,%rdx
  800484:	00 00 00 
  800487:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800489:	cc                   	int3   
  80048a:	eb fd                	jmp    800489 <_panic+0x111>

000000000080048c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80048c:	55                   	push   %rbp
  80048d:	48 89 e5             	mov    %rsp,%rbp
  800490:	48 83 ec 10          	sub    $0x10,%rsp
  800494:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800497:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80049b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049f:	8b 00                	mov    (%rax),%eax
  8004a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004a4:	89 d6                	mov    %edx,%esi
  8004a6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004aa:	48 63 d0             	movslq %eax,%rdx
  8004ad:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8004b2:	8d 50 01             	lea    0x1(%rax),%edx
  8004b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b9:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8004bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004bf:	8b 00                	mov    (%rax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8004c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	48 98                	cltq   
  8004d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d4:	48 83 c2 08          	add    $0x8,%rdx
  8004d8:	48 89 c6             	mov    %rax,%rsi
  8004db:	48 89 d7             	mov    %rdx,%rdi
  8004de:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8004e5:	00 00 00 
  8004e8:	ff d0                	callq  *%rax
        b->idx = 0;
  8004ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f8:	8b 40 04             	mov    0x4(%rax),%eax
  8004fb:	8d 50 01             	lea    0x1(%rax),%edx
  8004fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800502:	89 50 04             	mov    %edx,0x4(%rax)
}
  800505:	c9                   	leaveq 
  800506:	c3                   	retq   

0000000000800507 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800507:	55                   	push   %rbp
  800508:	48 89 e5             	mov    %rsp,%rbp
  80050b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800512:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800519:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800520:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800527:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80052e:	48 8b 0a             	mov    (%rdx),%rcx
  800531:	48 89 08             	mov    %rcx,(%rax)
  800534:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800538:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800540:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800544:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80054b:	00 00 00 
    b.cnt = 0;
  80054e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800555:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800558:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80055f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800566:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80056d:	48 89 c6             	mov    %rax,%rsi
  800570:	48 bf 8c 04 80 00 00 	movabs $0x80048c,%rdi
  800577:	00 00 00 
  80057a:	48 b8 64 09 80 00 00 	movabs $0x800964,%rax
  800581:	00 00 00 
  800584:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800586:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80058c:	48 98                	cltq   
  80058e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800595:	48 83 c2 08          	add    $0x8,%rdx
  800599:	48 89 c6             	mov    %rax,%rsi
  80059c:	48 89 d7             	mov    %rdx,%rdi
  80059f:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005b1:	c9                   	leaveq 
  8005b2:	c3                   	retq   

00000000008005b3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005b3:	55                   	push   %rbp
  8005b4:	48 89 e5             	mov    %rsp,%rbp
  8005b7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005be:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005c5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005cc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005d3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005da:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005e1:	84 c0                	test   %al,%al
  8005e3:	74 20                	je     800605 <cprintf+0x52>
  8005e5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005e9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005ed:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005f1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005f5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005f9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005fd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800601:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800605:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80060c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800613:	00 00 00 
  800616:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80061d:	00 00 00 
  800620:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800624:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80062b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800632:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800639:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800640:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800647:	48 8b 0a             	mov    (%rdx),%rcx
  80064a:	48 89 08             	mov    %rcx,(%rax)
  80064d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800651:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800655:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800659:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80065d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800664:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066b:	48 89 d6             	mov    %rdx,%rsi
  80066e:	48 89 c7             	mov    %rax,%rdi
  800671:	48 b8 07 05 80 00 00 	movabs $0x800507,%rax
  800678:	00 00 00 
  80067b:	ff d0                	callq  *%rax
  80067d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800683:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800689:	c9                   	leaveq 
  80068a:	c3                   	retq   
	...

000000000080068c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068c:	55                   	push   %rbp
  80068d:	48 89 e5             	mov    %rsp,%rbp
  800690:	48 83 ec 30          	sub    $0x30,%rsp
  800694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800698:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80069c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006a0:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006a3:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006a7:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006ae:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006b2:	77 52                	ja     800706 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006b7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006bb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006be:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	48 f7 75 d0          	divq   -0x30(%rbp)
  8006cf:	48 89 c2             	mov    %rax,%rdx
  8006d2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8006d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006d8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006e0:	41 89 f9             	mov    %edi,%r9d
  8006e3:	48 89 c7             	mov    %rax,%rdi
  8006e6:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8006ed:	00 00 00 
  8006f0:	ff d0                	callq  *%rax
  8006f2:	eb 1c                	jmp    800710 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8006fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006ff:	48 89 d6             	mov    %rdx,%rsi
  800702:	89 c7                	mov    %eax,%edi
  800704:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800706:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80070a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80070e:	7f e4                	jg     8006f4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800710:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	48 f7 f1             	div    %rcx
  80071f:	48 89 d0             	mov    %rdx,%rax
  800722:	48 ba 90 55 80 00 00 	movabs $0x805590,%rdx
  800729:	00 00 00 
  80072c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800730:	0f be c0             	movsbl %al,%eax
  800733:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800737:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80073b:	48 89 d6             	mov    %rdx,%rsi
  80073e:	89 c7                	mov    %eax,%edi
  800740:	ff d1                	callq  *%rcx
}
  800742:	c9                   	leaveq 
  800743:	c3                   	retq   

0000000000800744 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800744:	55                   	push   %rbp
  800745:	48 89 e5             	mov    %rsp,%rbp
  800748:	48 83 ec 20          	sub    $0x20,%rsp
  80074c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800750:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800753:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800757:	7e 52                	jle    8007ab <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	83 f8 30             	cmp    $0x30,%eax
  800762:	73 24                	jae    800788 <getuint+0x44>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	8b 00                	mov    (%rax),%eax
  800772:	89 c0                	mov    %eax,%eax
  800774:	48 01 d0             	add    %rdx,%rax
  800777:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077b:	8b 12                	mov    (%rdx),%edx
  80077d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800780:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800784:	89 0a                	mov    %ecx,(%rdx)
  800786:	eb 17                	jmp    80079f <getuint+0x5b>
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800790:	48 89 d0             	mov    %rdx,%rax
  800793:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079f:	48 8b 00             	mov    (%rax),%rax
  8007a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a6:	e9 a3 00 00 00       	jmpq   80084e <getuint+0x10a>
	else if (lflag)
  8007ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007af:	74 4f                	je     800800 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	8b 00                	mov    (%rax),%eax
  8007b7:	83 f8 30             	cmp    $0x30,%eax
  8007ba:	73 24                	jae    8007e0 <getuint+0x9c>
  8007bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	89 c0                	mov    %eax,%eax
  8007cc:	48 01 d0             	add    %rdx,%rax
  8007cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d3:	8b 12                	mov    (%rdx),%edx
  8007d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	89 0a                	mov    %ecx,(%rdx)
  8007de:	eb 17                	jmp    8007f7 <getuint+0xb3>
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e8:	48 89 d0             	mov    %rdx,%rax
  8007eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f7:	48 8b 00             	mov    (%rax),%rax
  8007fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fe:	eb 4e                	jmp    80084e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	83 f8 30             	cmp    $0x30,%eax
  800809:	73 24                	jae    80082f <getuint+0xeb>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	89 c0                	mov    %eax,%eax
  80081b:	48 01 d0             	add    %rdx,%rax
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	8b 12                	mov    (%rdx),%edx
  800824:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	89 0a                	mov    %ecx,(%rdx)
  80082d:	eb 17                	jmp    800846 <getuint+0x102>
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800837:	48 89 d0             	mov    %rdx,%rax
  80083a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800846:	8b 00                	mov    (%rax),%eax
  800848:	89 c0                	mov    %eax,%eax
  80084a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800852:	c9                   	leaveq 
  800853:	c3                   	retq   

0000000000800854 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800854:	55                   	push   %rbp
  800855:	48 89 e5             	mov    %rsp,%rbp
  800858:	48 83 ec 20          	sub    $0x20,%rsp
  80085c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800860:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800863:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800867:	7e 52                	jle    8008bb <getint+0x67>
		x=va_arg(*ap, long long);
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	83 f8 30             	cmp    $0x30,%eax
  800872:	73 24                	jae    800898 <getint+0x44>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	8b 00                	mov    (%rax),%eax
  800882:	89 c0                	mov    %eax,%eax
  800884:	48 01 d0             	add    %rdx,%rax
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	8b 12                	mov    (%rdx),%edx
  80088d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800890:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800894:	89 0a                	mov    %ecx,(%rdx)
  800896:	eb 17                	jmp    8008af <getint+0x5b>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a0:	48 89 d0             	mov    %rdx,%rax
  8008a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008af:	48 8b 00             	mov    (%rax),%rax
  8008b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b6:	e9 a3 00 00 00       	jmpq   80095e <getint+0x10a>
	else if (lflag)
  8008bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008bf:	74 4f                	je     800910 <getint+0xbc>
		x=va_arg(*ap, long);
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	8b 00                	mov    (%rax),%eax
  8008c7:	83 f8 30             	cmp    $0x30,%eax
  8008ca:	73 24                	jae    8008f0 <getint+0x9c>
  8008cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	8b 00                	mov    (%rax),%eax
  8008da:	89 c0                	mov    %eax,%eax
  8008dc:	48 01 d0             	add    %rdx,%rax
  8008df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e3:	8b 12                	mov    (%rdx),%edx
  8008e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ec:	89 0a                	mov    %ecx,(%rdx)
  8008ee:	eb 17                	jmp    800907 <getint+0xb3>
  8008f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f8:	48 89 d0             	mov    %rdx,%rax
  8008fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800903:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800907:	48 8b 00             	mov    (%rax),%rax
  80090a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80090e:	eb 4e                	jmp    80095e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800914:	8b 00                	mov    (%rax),%eax
  800916:	83 f8 30             	cmp    $0x30,%eax
  800919:	73 24                	jae    80093f <getint+0xeb>
  80091b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	8b 00                	mov    (%rax),%eax
  800929:	89 c0                	mov    %eax,%eax
  80092b:	48 01 d0             	add    %rdx,%rax
  80092e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800932:	8b 12                	mov    (%rdx),%edx
  800934:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800937:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093b:	89 0a                	mov    %ecx,(%rdx)
  80093d:	eb 17                	jmp    800956 <getint+0x102>
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800947:	48 89 d0             	mov    %rdx,%rax
  80094a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80094e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800952:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800956:	8b 00                	mov    (%rax),%eax
  800958:	48 98                	cltq   
  80095a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80095e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800962:	c9                   	leaveq 
  800963:	c3                   	retq   

0000000000800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %rbp
  800965:	48 89 e5             	mov    %rsp,%rbp
  800968:	41 54                	push   %r12
  80096a:	53                   	push   %rbx
  80096b:	48 83 ec 60          	sub    $0x60,%rsp
  80096f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800973:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800977:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80097b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80097f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800983:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800987:	48 8b 0a             	mov    (%rdx),%rcx
  80098a:	48 89 08             	mov    %rcx,(%rax)
  80098d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800991:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800995:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800999:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099d:	eb 17                	jmp    8009b6 <vprintfmt+0x52>
			if (ch == '\0')
  80099f:	85 db                	test   %ebx,%ebx
  8009a1:	0f 84 ea 04 00 00    	je     800e91 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8009a7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009ab:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009af:	48 89 c6             	mov    %rax,%rsi
  8009b2:	89 df                	mov    %ebx,%edi
  8009b4:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ba:	0f b6 00             	movzbl (%rax),%eax
  8009bd:	0f b6 d8             	movzbl %al,%ebx
  8009c0:	83 fb 25             	cmp    $0x25,%ebx
  8009c3:	0f 95 c0             	setne  %al
  8009c6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009cb:	84 c0                	test   %al,%al
  8009cd:	75 d0                	jne    80099f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009cf:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009d3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8009ef:	eb 04                	jmp    8009f5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8009f1:	90                   	nop
  8009f2:	eb 01                	jmp    8009f5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8009f4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f9:	0f b6 00             	movzbl (%rax),%eax
  8009fc:	0f b6 d8             	movzbl %al,%ebx
  8009ff:	89 d8                	mov    %ebx,%eax
  800a01:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a06:	83 e8 23             	sub    $0x23,%eax
  800a09:	83 f8 55             	cmp    $0x55,%eax
  800a0c:	0f 87 4b 04 00 00    	ja     800e5d <vprintfmt+0x4f9>
  800a12:	89 c0                	mov    %eax,%eax
  800a14:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a1b:	00 
  800a1c:	48 b8 b8 55 80 00 00 	movabs $0x8055b8,%rax
  800a23:	00 00 00 
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	48 8b 00             	mov    (%rax),%rax
  800a2c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a2e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a32:	eb c1                	jmp    8009f5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a34:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a38:	eb bb                	jmp    8009f5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a41:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a44:	89 d0                	mov    %edx,%eax
  800a46:	c1 e0 02             	shl    $0x2,%eax
  800a49:	01 d0                	add    %edx,%eax
  800a4b:	01 c0                	add    %eax,%eax
  800a4d:	01 d8                	add    %ebx,%eax
  800a4f:	83 e8 30             	sub    $0x30,%eax
  800a52:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a55:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a59:	0f b6 00             	movzbl (%rax),%eax
  800a5c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a62:	7e 63                	jle    800ac7 <vprintfmt+0x163>
  800a64:	83 fb 39             	cmp    $0x39,%ebx
  800a67:	7f 5e                	jg     800ac7 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a69:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6e:	eb d1                	jmp    800a41 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a73:	83 f8 30             	cmp    $0x30,%eax
  800a76:	73 17                	jae    800a8f <vprintfmt+0x12b>
  800a78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7f:	89 c0                	mov    %eax,%eax
  800a81:	48 01 d0             	add    %rdx,%rax
  800a84:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a87:	83 c2 08             	add    $0x8,%edx
  800a8a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8d:	eb 0f                	jmp    800a9e <vprintfmt+0x13a>
  800a8f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a93:	48 89 d0             	mov    %rdx,%rax
  800a96:	48 83 c2 08          	add    $0x8,%rdx
  800a9a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9e:	8b 00                	mov    (%rax),%eax
  800aa0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aa3:	eb 23                	jmp    800ac8 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800aa5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aa9:	0f 89 42 ff ff ff    	jns    8009f1 <vprintfmt+0x8d>
				width = 0;
  800aaf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ab6:	e9 36 ff ff ff       	jmpq   8009f1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800abb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ac2:	e9 2e ff ff ff       	jmpq   8009f5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acc:	0f 89 22 ff ff ff    	jns    8009f4 <vprintfmt+0x90>
				width = precision, precision = -1;
  800ad2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ad8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800adf:	e9 10 ff ff ff       	jmpq   8009f4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ae8:	e9 08 ff ff ff       	jmpq   8009f5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800aed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af0:	83 f8 30             	cmp    $0x30,%eax
  800af3:	73 17                	jae    800b0c <vprintfmt+0x1a8>
  800af5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afc:	89 c0                	mov    %eax,%eax
  800afe:	48 01 d0             	add    %rdx,%rax
  800b01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b04:	83 c2 08             	add    $0x8,%edx
  800b07:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0a:	eb 0f                	jmp    800b1b <vprintfmt+0x1b7>
  800b0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b10:	48 89 d0             	mov    %rdx,%rax
  800b13:	48 83 c2 08          	add    $0x8,%rdx
  800b17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1b:	8b 00                	mov    (%rax),%eax
  800b1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b21:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b25:	48 89 d6             	mov    %rdx,%rsi
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	ff d1                	callq  *%rcx
			break;
  800b2c:	e9 5a 03 00 00       	jmpq   800e8b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b34:	83 f8 30             	cmp    $0x30,%eax
  800b37:	73 17                	jae    800b50 <vprintfmt+0x1ec>
  800b39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b40:	89 c0                	mov    %eax,%eax
  800b42:	48 01 d0             	add    %rdx,%rax
  800b45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b48:	83 c2 08             	add    $0x8,%edx
  800b4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x1fb>
  800b50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b54:	48 89 d0             	mov    %rdx,%rax
  800b57:	48 83 c2 08          	add    $0x8,%rdx
  800b5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	79 02                	jns    800b67 <vprintfmt+0x203>
				err = -err;
  800b65:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b67:	83 fb 15             	cmp    $0x15,%ebx
  800b6a:	7f 16                	jg     800b82 <vprintfmt+0x21e>
  800b6c:	48 b8 e0 54 80 00 00 	movabs $0x8054e0,%rax
  800b73:	00 00 00 
  800b76:	48 63 d3             	movslq %ebx,%rdx
  800b79:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b7d:	4d 85 e4             	test   %r12,%r12
  800b80:	75 2e                	jne    800bb0 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	89 d9                	mov    %ebx,%ecx
  800b8c:	48 ba a1 55 80 00 00 	movabs $0x8055a1,%rdx
  800b93:	00 00 00 
  800b96:	48 89 c7             	mov    %rax,%rdi
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9e:	49 b8 9b 0e 80 00 00 	movabs $0x800e9b,%r8
  800ba5:	00 00 00 
  800ba8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 db 02 00 00       	jmpq   800e8b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb8:	4c 89 e1             	mov    %r12,%rcx
  800bbb:	48 ba aa 55 80 00 00 	movabs $0x8055aa,%rdx
  800bc2:	00 00 00 
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcd:	49 b8 9b 0e 80 00 00 	movabs $0x800e9b,%r8
  800bd4:	00 00 00 
  800bd7:	41 ff d0             	callq  *%r8
			break;
  800bda:	e9 ac 02 00 00       	jmpq   800e8b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be2:	83 f8 30             	cmp    $0x30,%eax
  800be5:	73 17                	jae    800bfe <vprintfmt+0x29a>
  800be7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800beb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bee:	89 c0                	mov    %eax,%eax
  800bf0:	48 01 d0             	add    %rdx,%rax
  800bf3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf6:	83 c2 08             	add    $0x8,%edx
  800bf9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfc:	eb 0f                	jmp    800c0d <vprintfmt+0x2a9>
  800bfe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c02:	48 89 d0             	mov    %rdx,%rax
  800c05:	48 83 c2 08          	add    $0x8,%rdx
  800c09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0d:	4c 8b 20             	mov    (%rax),%r12
  800c10:	4d 85 e4             	test   %r12,%r12
  800c13:	75 0a                	jne    800c1f <vprintfmt+0x2bb>
				p = "(null)";
  800c15:	49 bc ad 55 80 00 00 	movabs $0x8055ad,%r12
  800c1c:	00 00 00 
			if (width > 0 && padc != '-')
  800c1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c23:	7e 7a                	jle    800c9f <vprintfmt+0x33b>
  800c25:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c29:	74 74                	je     800c9f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c2e:	48 98                	cltq   
  800c30:	48 89 c6             	mov    %rax,%rsi
  800c33:	4c 89 e7             	mov    %r12,%rdi
  800c36:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  800c3d:	00 00 00 
  800c40:	ff d0                	callq  *%rax
  800c42:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c45:	eb 17                	jmp    800c5e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800c47:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800c4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c53:	48 89 d6             	mov    %rdx,%rsi
  800c56:	89 c7                	mov    %eax,%edi
  800c58:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c62:	7f e3                	jg     800c47 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c64:	eb 39                	jmp    800c9f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800c66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c6a:	74 1e                	je     800c8a <vprintfmt+0x326>
  800c6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c6f:	7e 05                	jle    800c76 <vprintfmt+0x312>
  800c71:	83 fb 7e             	cmp    $0x7e,%ebx
  800c74:	7e 14                	jle    800c8a <vprintfmt+0x326>
					putch('?', putdat);
  800c76:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c7a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c7e:	48 89 c6             	mov    %rax,%rsi
  800c81:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c86:	ff d2                	callq  *%rdx
  800c88:	eb 0f                	jmp    800c99 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c92:	48 89 c6             	mov    %rax,%rsi
  800c95:	89 df                	mov    %ebx,%edi
  800c97:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c9d:	eb 01                	jmp    800ca0 <vprintfmt+0x33c>
  800c9f:	90                   	nop
  800ca0:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ca5:	0f be d8             	movsbl %al,%ebx
  800ca8:	85 db                	test   %ebx,%ebx
  800caa:	0f 95 c0             	setne  %al
  800cad:	49 83 c4 01          	add    $0x1,%r12
  800cb1:	84 c0                	test   %al,%al
  800cb3:	74 28                	je     800cdd <vprintfmt+0x379>
  800cb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cb9:	78 ab                	js     800c66 <vprintfmt+0x302>
  800cbb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cbf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc3:	79 a1                	jns    800c66 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc5:	eb 16                	jmp    800cdd <vprintfmt+0x379>
				putch(' ', putdat);
  800cc7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ccb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ccf:	48 89 c6             	mov    %rax,%rsi
  800cd2:	bf 20 00 00 00       	mov    $0x20,%edi
  800cd7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cdd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce1:	7f e4                	jg     800cc7 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800ce3:	e9 a3 01 00 00       	jmpq   800e8b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ce8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cec:	be 03 00 00 00       	mov    $0x3,%esi
  800cf1:	48 89 c7             	mov    %rax,%rdi
  800cf4:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  800cfb:	00 00 00 
  800cfe:	ff d0                	callq  *%rax
  800d00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d08:	48 85 c0             	test   %rax,%rax
  800d0b:	79 1d                	jns    800d2a <vprintfmt+0x3c6>
				putch('-', putdat);
  800d0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d15:	48 89 c6             	mov    %rax,%rsi
  800d18:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d1d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d23:	48 f7 d8             	neg    %rax
  800d26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d31:	e9 e8 00 00 00       	jmpq   800e1e <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d36:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3a:	be 03 00 00 00       	mov    $0x3,%esi
  800d3f:	48 89 c7             	mov    %rax,%rdi
  800d42:	48 b8 44 07 80 00 00 	movabs $0x800744,%rax
  800d49:	00 00 00 
  800d4c:	ff d0                	callq  *%rax
  800d4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d52:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d59:	e9 c0 00 00 00       	jmpq   800e1e <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d66:	48 89 c6             	mov    %rax,%rsi
  800d69:	bf 58 00 00 00       	mov    $0x58,%edi
  800d6e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d70:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d74:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d78:	48 89 c6             	mov    %rax,%rsi
  800d7b:	bf 58 00 00 00       	mov    $0x58,%edi
  800d80:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800d82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d8a:	48 89 c6             	mov    %rax,%rsi
  800d8d:	bf 58 00 00 00       	mov    $0x58,%edi
  800d92:	ff d2                	callq  *%rdx
			break;
  800d94:	e9 f2 00 00 00       	jmpq   800e8b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800d99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800da1:	48 89 c6             	mov    %rax,%rsi
  800da4:	bf 30 00 00 00       	mov    $0x30,%edi
  800da9:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800dab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800daf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db3:	48 89 c6             	mov    %rax,%rsi
  800db6:	bf 78 00 00 00       	mov    $0x78,%edi
  800dbb:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc0:	83 f8 30             	cmp    $0x30,%eax
  800dc3:	73 17                	jae    800ddc <vprintfmt+0x478>
  800dc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dcc:	89 c0                	mov    %eax,%eax
  800dce:	48 01 d0             	add    %rdx,%rax
  800dd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dd4:	83 c2 08             	add    $0x8,%edx
  800dd7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dda:	eb 0f                	jmp    800deb <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800ddc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800de0:	48 89 d0             	mov    %rdx,%rax
  800de3:	48 83 c2 08          	add    $0x8,%rdx
  800de7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800deb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800df2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800df9:	eb 23                	jmp    800e1e <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dfb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dff:	be 03 00 00 00       	mov    $0x3,%esi
  800e04:	48 89 c7             	mov    %rax,%rdi
  800e07:	48 b8 44 07 80 00 00 	movabs $0x800744,%rax
  800e0e:	00 00 00 
  800e11:	ff d0                	callq  *%rax
  800e13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e1e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e23:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e26:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e35:	45 89 c1             	mov    %r8d,%r9d
  800e38:	41 89 f8             	mov    %edi,%r8d
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	callq  *%rax
			break;
  800e4a:	eb 3f                	jmp    800e8b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e4c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e50:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e54:	48 89 c6             	mov    %rax,%rsi
  800e57:	89 df                	mov    %ebx,%edi
  800e59:	ff d2                	callq  *%rdx
			break;
  800e5b:	eb 2e                	jmp    800e8b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e5d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e61:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e65:	48 89 c6             	mov    %rax,%rsi
  800e68:	bf 25 00 00 00       	mov    $0x25,%edi
  800e6d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e74:	eb 05                	jmp    800e7b <vprintfmt+0x517>
  800e76:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e7b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e7f:	48 83 e8 01          	sub    $0x1,%rax
  800e83:	0f b6 00             	movzbl (%rax),%eax
  800e86:	3c 25                	cmp    $0x25,%al
  800e88:	75 ec                	jne    800e76 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800e8a:	90                   	nop
		}
	}
  800e8b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e8c:	e9 25 fb ff ff       	jmpq   8009b6 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e91:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e92:	48 83 c4 60          	add    $0x60,%rsp
  800e96:	5b                   	pop    %rbx
  800e97:	41 5c                	pop    %r12
  800e99:	5d                   	pop    %rbp
  800e9a:	c3                   	retq   

0000000000800e9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e9b:	55                   	push   %rbp
  800e9c:	48 89 e5             	mov    %rsp,%rbp
  800e9f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ea6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ead:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800eb4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ebb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ec2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ec9:	84 c0                	test   %al,%al
  800ecb:	74 20                	je     800eed <printfmt+0x52>
  800ecd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ed1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ed5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ed9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800edd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ee1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ee5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ee9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eed:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ef4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800efb:	00 00 00 
  800efe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f05:	00 00 00 
  800f08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f13:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f1a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f21:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f28:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f2f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f3d:	48 89 c7             	mov    %rax,%rdi
  800f40:	48 b8 64 09 80 00 00 	movabs $0x800964,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f4c:	c9                   	leaveq 
  800f4d:	c3                   	retq   

0000000000800f4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4e:	55                   	push   %rbp
  800f4f:	48 89 e5             	mov    %rsp,%rbp
  800f52:	48 83 ec 10          	sub    $0x10,%rsp
  800f56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f61:	8b 40 10             	mov    0x10(%rax),%eax
  800f64:	8d 50 01             	lea    0x1(%rax),%edx
  800f67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f72:	48 8b 10             	mov    (%rax),%rdx
  800f75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f79:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f7d:	48 39 c2             	cmp    %rax,%rdx
  800f80:	73 17                	jae    800f99 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f86:	48 8b 00             	mov    (%rax),%rax
  800f89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f8c:	88 10                	mov    %dl,(%rax)
  800f8e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f96:	48 89 10             	mov    %rdx,(%rax)
}
  800f99:	c9                   	leaveq 
  800f9a:	c3                   	retq   

0000000000800f9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
  800f9f:	48 83 ec 50          	sub    $0x50,%rsp
  800fa3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fa7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800faa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fb2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fb6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fba:	48 8b 0a             	mov    (%rdx),%rcx
  800fbd:	48 89 08             	mov    %rcx,(%rax)
  800fc0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fd8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fdb:	48 98                	cltq   
  800fdd:	48 83 e8 01          	sub    $0x1,%rax
  800fe1:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800fe5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ff0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ff5:	74 06                	je     800ffd <vsnprintf+0x62>
  800ff7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ffb:	7f 07                	jg     801004 <vsnprintf+0x69>
		return -E_INVAL;
  800ffd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801002:	eb 2f                	jmp    801033 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801004:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801008:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80100c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801010:	48 89 c6             	mov    %rax,%rsi
  801013:	48 bf 4e 0f 80 00 00 	movabs $0x800f4e,%rdi
  80101a:	00 00 00 
  80101d:	48 b8 64 09 80 00 00 	movabs $0x800964,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801029:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80102d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801030:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801040:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801047:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80104d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801054:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80105b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801062:	84 c0                	test   %al,%al
  801064:	74 20                	je     801086 <snprintf+0x51>
  801066:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80106a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80106e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801072:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801076:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80107a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80107e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801082:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801086:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80108d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801094:	00 00 00 
  801097:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80109e:	00 00 00 
  8010a1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010ac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010b3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ba:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010c1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010c8:	48 8b 0a             	mov    (%rdx),%rcx
  8010cb:	48 89 08             	mov    %rcx,(%rax)
  8010ce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010d2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010d6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010da:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010de:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010e5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010ec:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010f2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f9:	48 89 c7             	mov    %rax,%rdi
  8010fc:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  801103:	00 00 00 
  801106:	ff d0                	callq  *%rax
  801108:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80110e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801114:	c9                   	leaveq 
  801115:	c3                   	retq   
	...

0000000000801118 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
  80111c:	48 83 ec 18          	sub    $0x18,%rsp
  801120:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80112b:	eb 09                	jmp    801136 <strlen+0x1e>
		n++;
  80112d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801131:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	0f b6 00             	movzbl (%rax),%eax
  80113d:	84 c0                	test   %al,%al
  80113f:	75 ec                	jne    80112d <strlen+0x15>
		n++;
	return n;
  801141:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801144:	c9                   	leaveq 
  801145:	c3                   	retq   

0000000000801146 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	48 83 ec 20          	sub    $0x20,%rsp
  80114e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80115d:	eb 0e                	jmp    80116d <strnlen+0x27>
		n++;
  80115f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801163:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801168:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80116d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801172:	74 0b                	je     80117f <strnlen+0x39>
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	0f b6 00             	movzbl (%rax),%eax
  80117b:	84 c0                	test   %al,%al
  80117d:	75 e0                	jne    80115f <strnlen+0x19>
		n++;
	return n;
  80117f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 20          	sub    $0x20,%rsp
  80118c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80119c:	90                   	nop
  80119d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a1:	0f b6 10             	movzbl (%rax),%edx
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	88 10                	mov    %dl,(%rax)
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	0f 95 c0             	setne  %al
  8011b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 d9                	jne    80119d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 83 ec 20          	sub    $0x20,%rsp
  8011d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011de:	48 89 c7             	mov    %rax,%rdi
  8011e1:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  8011e8:	00 00 00 
  8011eb:	ff d0                	callq  *%rax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f3:	48 98                	cltq   
  8011f5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8011f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011fd:	48 89 d6             	mov    %rdx,%rsi
  801200:	48 89 c7             	mov    %rax,%rdi
  801203:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  80120a:	00 00 00 
  80120d:	ff d0                	callq  *%rax
	return dst;
  80120f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801213:	c9                   	leaveq 
  801214:	c3                   	retq   

0000000000801215 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801215:	55                   	push   %rbp
  801216:	48 89 e5             	mov    %rsp,%rbp
  801219:	48 83 ec 28          	sub    $0x28,%rsp
  80121d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801221:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801225:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801231:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801238:	00 
  801239:	eb 27                	jmp    801262 <strncpy+0x4d>
		*dst++ = *src;
  80123b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123f:	0f b6 10             	movzbl (%rax),%edx
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	88 10                	mov    %dl,(%rax)
  801248:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80124d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801251:	0f b6 00             	movzbl (%rax),%eax
  801254:	84 c0                	test   %al,%al
  801256:	74 05                	je     80125d <strncpy+0x48>
			src++;
  801258:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80125d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80126a:	72 cf                	jb     80123b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80126c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 83 ec 28          	sub    $0x28,%rsp
  80127a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80128e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801293:	74 37                	je     8012cc <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801295:	eb 17                	jmp    8012ae <strlcpy+0x3c>
			*dst++ = *src++;
  801297:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129b:	0f b6 10             	movzbl (%rax),%edx
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	88 10                	mov    %dl,(%rax)
  8012a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012a9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b8:	74 0b                	je     8012c5 <strlcpy+0x53>
  8012ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	84 c0                	test   %al,%al
  8012c3:	75 d2                	jne    801297 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d4:	48 89 d1             	mov    %rdx,%rcx
  8012d7:	48 29 c1             	sub    %rax,%rcx
  8012da:	48 89 c8             	mov    %rcx,%rax
}
  8012dd:	c9                   	leaveq 
  8012de:	c3                   	retq   

00000000008012df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012df:	55                   	push   %rbp
  8012e0:	48 89 e5             	mov    %rsp,%rbp
  8012e3:	48 83 ec 10          	sub    $0x10,%rsp
  8012e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ef:	eb 0a                	jmp    8012fb <strcmp+0x1c>
		p++, q++;
  8012f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	84 c0                	test   %al,%al
  801304:	74 12                	je     801318 <strcmp+0x39>
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130a:	0f b6 10             	movzbl (%rax),%edx
  80130d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	38 c2                	cmp    %al,%dl
  801316:	74 d9                	je     8012f1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	0f b6 00             	movzbl (%rax),%eax
  80131f:	0f b6 d0             	movzbl %al,%edx
  801322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801326:	0f b6 00             	movzbl (%rax),%eax
  801329:	0f b6 c0             	movzbl %al,%eax
  80132c:	89 d1                	mov    %edx,%ecx
  80132e:	29 c1                	sub    %eax,%ecx
  801330:	89 c8                	mov    %ecx,%eax
}
  801332:	c9                   	leaveq 
  801333:	c3                   	retq   

0000000000801334 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801334:	55                   	push   %rbp
  801335:	48 89 e5             	mov    %rsp,%rbp
  801338:	48 83 ec 18          	sub    $0x18,%rsp
  80133c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801340:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801344:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801348:	eb 0f                	jmp    801359 <strncmp+0x25>
		n--, p++, q++;
  80134a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80134f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801354:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801359:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135e:	74 1d                	je     80137d <strncmp+0x49>
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	0f b6 00             	movzbl (%rax),%eax
  801367:	84 c0                	test   %al,%al
  801369:	74 12                	je     80137d <strncmp+0x49>
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	0f b6 10             	movzbl (%rax),%edx
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	38 c2                	cmp    %al,%dl
  80137b:	74 cd                	je     80134a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80137d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801382:	75 07                	jne    80138b <strncmp+0x57>
		return 0;
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	eb 1a                	jmp    8013a5 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	0f b6 d0             	movzbl %al,%edx
  801395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801399:	0f b6 00             	movzbl (%rax),%eax
  80139c:	0f b6 c0             	movzbl %al,%eax
  80139f:	89 d1                	mov    %edx,%ecx
  8013a1:	29 c1                	sub    %eax,%ecx
  8013a3:	89 c8                	mov    %ecx,%eax
}
  8013a5:	c9                   	leaveq 
  8013a6:	c3                   	retq   

00000000008013a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a7:	55                   	push   %rbp
  8013a8:	48 89 e5             	mov    %rsp,%rbp
  8013ab:	48 83 ec 10          	sub    $0x10,%rsp
  8013af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b3:	89 f0                	mov    %esi,%eax
  8013b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b8:	eb 17                	jmp    8013d1 <strchr+0x2a>
		if (*s == c)
  8013ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c4:	75 06                	jne    8013cc <strchr+0x25>
			return (char *) s;
  8013c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ca:	eb 15                	jmp    8013e1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	84 c0                	test   %al,%al
  8013da:	75 de                	jne    8013ba <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e1:	c9                   	leaveq 
  8013e2:	c3                   	retq   

00000000008013e3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013e3:	55                   	push   %rbp
  8013e4:	48 89 e5             	mov    %rsp,%rbp
  8013e7:	48 83 ec 10          	sub    $0x10,%rsp
  8013eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ef:	89 f0                	mov    %esi,%eax
  8013f1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013f4:	eb 11                	jmp    801407 <strfind+0x24>
		if (*s == c)
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801400:	74 12                	je     801414 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801402:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	84 c0                	test   %al,%al
  801410:	75 e4                	jne    8013f6 <strfind+0x13>
  801412:	eb 01                	jmp    801415 <strfind+0x32>
		if (*s == c)
			break;
  801414:	90                   	nop
	return (char *) s;
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801419:	c9                   	leaveq 
  80141a:	c3                   	retq   

000000000080141b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80141b:	55                   	push   %rbp
  80141c:	48 89 e5             	mov    %rsp,%rbp
  80141f:	48 83 ec 18          	sub    $0x18,%rsp
  801423:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801427:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80142a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80142e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801433:	75 06                	jne    80143b <memset+0x20>
		return v;
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	eb 69                	jmp    8014a4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 48                	jne    80148f <memset+0x74>
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 3c                	jne    80148f <memset+0x74>
		c &= 0xFF;
  801453:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80145a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145d:	89 c2                	mov    %eax,%edx
  80145f:	c1 e2 18             	shl    $0x18,%edx
  801462:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801465:	c1 e0 10             	shl    $0x10,%eax
  801468:	09 c2                	or     %eax,%edx
  80146a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80146d:	c1 e0 08             	shl    $0x8,%eax
  801470:	09 d0                	or     %edx,%eax
  801472:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	48 89 c1             	mov    %rax,%rcx
  80147c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801487:	48 89 d7             	mov    %rdx,%rdi
  80148a:	fc                   	cld    
  80148b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80148d:	eb 11                	jmp    8014a0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80148f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801493:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801496:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80149a:	48 89 d7             	mov    %rdx,%rdi
  80149d:	fc                   	cld    
  80149e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a4:	c9                   	leaveq 
  8014a5:	c3                   	retq   

00000000008014a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014a6:	55                   	push   %rbp
  8014a7:	48 89 e5             	mov    %rsp,%rbp
  8014aa:	48 83 ec 28          	sub    $0x28,%rsp
  8014ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014d2:	0f 83 88 00 00 00    	jae    801560 <memmove+0xba>
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e0:	48 01 d0             	add    %rdx,%rax
  8014e3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e7:	76 77                	jbe    801560 <memmove+0xba>
		s += n;
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	83 e0 03             	and    $0x3,%eax
  801500:	48 85 c0             	test   %rax,%rax
  801503:	75 3b                	jne    801540 <memmove+0x9a>
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	83 e0 03             	and    $0x3,%eax
  80150c:	48 85 c0             	test   %rax,%rax
  80150f:	75 2f                	jne    801540 <memmove+0x9a>
  801511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801515:	83 e0 03             	and    $0x3,%eax
  801518:	48 85 c0             	test   %rax,%rax
  80151b:	75 23                	jne    801540 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80151d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801521:	48 83 e8 04          	sub    $0x4,%rax
  801525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801529:	48 83 ea 04          	sub    $0x4,%rdx
  80152d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801531:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801535:	48 89 c7             	mov    %rax,%rdi
  801538:	48 89 d6             	mov    %rdx,%rsi
  80153b:	fd                   	std    
  80153c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80153e:	eb 1d                	jmp    80155d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801544:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801554:	48 89 d7             	mov    %rdx,%rdi
  801557:	48 89 c1             	mov    %rax,%rcx
  80155a:	fd                   	std    
  80155b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80155d:	fc                   	cld    
  80155e:	eb 57                	jmp    8015b7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801564:	83 e0 03             	and    $0x3,%eax
  801567:	48 85 c0             	test   %rax,%rax
  80156a:	75 36                	jne    8015a2 <memmove+0xfc>
  80156c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801570:	83 e0 03             	and    $0x3,%eax
  801573:	48 85 c0             	test   %rax,%rax
  801576:	75 2a                	jne    8015a2 <memmove+0xfc>
  801578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157c:	83 e0 03             	and    $0x3,%eax
  80157f:	48 85 c0             	test   %rax,%rax
  801582:	75 1e                	jne    8015a2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	48 89 c1             	mov    %rax,%rcx
  80158b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80158f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801593:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801597:	48 89 c7             	mov    %rax,%rdi
  80159a:	48 89 d6             	mov    %rdx,%rsi
  80159d:	fc                   	cld    
  80159e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015a0:	eb 15                	jmp    8015b7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015ae:	48 89 c7             	mov    %rax,%rdi
  8015b1:	48 89 d6             	mov    %rdx,%rsi
  8015b4:	fc                   	cld    
  8015b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015bb:	c9                   	leaveq 
  8015bc:	c3                   	retq   

00000000008015bd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015bd:	55                   	push   %rbp
  8015be:	48 89 e5             	mov    %rsp,%rbp
  8015c1:	48 83 ec 18          	sub    $0x18,%rsp
  8015c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	48 89 ce             	mov    %rcx,%rsi
  8015e0:	48 89 c7             	mov    %rax,%rdi
  8015e3:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  8015ea:	00 00 00 
  8015ed:	ff d0                	callq  *%rax
}
  8015ef:	c9                   	leaveq 
  8015f0:	c3                   	retq   

00000000008015f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015f1:	55                   	push   %rbp
  8015f2:	48 89 e5             	mov    %rsp,%rbp
  8015f5:	48 83 ec 28          	sub    $0x28,%rsp
  8015f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801601:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80160d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801611:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801615:	eb 38                	jmp    80164f <memcmp+0x5e>
		if (*s1 != *s2)
  801617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161b:	0f b6 10             	movzbl (%rax),%edx
  80161e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	38 c2                	cmp    %al,%dl
  801627:	74 1c                	je     801645 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	0f b6 d0             	movzbl %al,%edx
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	0f b6 c0             	movzbl %al,%eax
  80163d:	89 d1                	mov    %edx,%ecx
  80163f:	29 c1                	sub    %eax,%ecx
  801641:	89 c8                	mov    %ecx,%eax
  801643:	eb 20                	jmp    801665 <memcmp+0x74>
		s1++, s2++;
  801645:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80164a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80164f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801654:	0f 95 c0             	setne  %al
  801657:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80165c:	84 c0                	test   %al,%al
  80165e:	75 b7                	jne    801617 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 28          	sub    $0x28,%rsp
  80166f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801673:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801676:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801682:	48 01 d0             	add    %rdx,%rax
  801685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801689:	eb 13                	jmp    80169e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	0f b6 10             	movzbl (%rax),%edx
  801692:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801695:	38 c2                	cmp    %al,%dl
  801697:	74 11                	je     8016aa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801699:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80169e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016a6:	72 e3                	jb     80168b <memfind+0x24>
  8016a8:	eb 01                	jmp    8016ab <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016aa:	90                   	nop
	return (void *) s;
  8016ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016af:	c9                   	leaveq 
  8016b0:	c3                   	retq   

00000000008016b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	48 83 ec 38          	sub    $0x38,%rsp
  8016b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d3:	eb 05                	jmp    8016da <strtol+0x29>
		s++;
  8016d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	3c 20                	cmp    $0x20,%al
  8016e3:	74 f0                	je     8016d5 <strtol+0x24>
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	3c 09                	cmp    $0x9,%al
  8016ee:	74 e5                	je     8016d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	3c 2b                	cmp    $0x2b,%al
  8016f9:	75 07                	jne    801702 <strtol+0x51>
		s++;
  8016fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801700:	eb 17                	jmp    801719 <strtol+0x68>
	else if (*s == '-')
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	3c 2d                	cmp    $0x2d,%al
  80170b:	75 0c                	jne    801719 <strtol+0x68>
		s++, neg = 1;
  80170d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801712:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801719:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80171d:	74 06                	je     801725 <strtol+0x74>
  80171f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801723:	75 28                	jne    80174d <strtol+0x9c>
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 30                	cmp    $0x30,%al
  80172e:	75 1d                	jne    80174d <strtol+0x9c>
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	48 83 c0 01          	add    $0x1,%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 78                	cmp    $0x78,%al
  80173d:	75 0e                	jne    80174d <strtol+0x9c>
		s += 2, base = 16;
  80173f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801744:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80174b:	eb 2c                	jmp    801779 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80174d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801751:	75 19                	jne    80176c <strtol+0xbb>
  801753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801757:	0f b6 00             	movzbl (%rax),%eax
  80175a:	3c 30                	cmp    $0x30,%al
  80175c:	75 0e                	jne    80176c <strtol+0xbb>
		s++, base = 8;
  80175e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801763:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80176a:	eb 0d                	jmp    801779 <strtol+0xc8>
	else if (base == 0)
  80176c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801770:	75 07                	jne    801779 <strtol+0xc8>
		base = 10;
  801772:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	3c 2f                	cmp    $0x2f,%al
  801782:	7e 1d                	jle    8017a1 <strtol+0xf0>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 39                	cmp    $0x39,%al
  80178d:	7f 12                	jg     8017a1 <strtol+0xf0>
			dig = *s - '0';
  80178f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 30             	sub    $0x30,%eax
  80179c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80179f:	eb 4e                	jmp    8017ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	3c 60                	cmp    $0x60,%al
  8017aa:	7e 1d                	jle    8017c9 <strtol+0x118>
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	0f b6 00             	movzbl (%rax),%eax
  8017b3:	3c 7a                	cmp    $0x7a,%al
  8017b5:	7f 12                	jg     8017c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	0f be c0             	movsbl %al,%eax
  8017c1:	83 e8 57             	sub    $0x57,%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017c7:	eb 26                	jmp    8017ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 40                	cmp    $0x40,%al
  8017d2:	7e 47                	jle    80181b <strtol+0x16a>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	3c 5a                	cmp    $0x5a,%al
  8017dd:	7f 3c                	jg     80181b <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	0f be c0             	movsbl %al,%eax
  8017e9:	83 e8 37             	sub    $0x37,%eax
  8017ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017f5:	7d 23                	jge    80181a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8017f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017ff:	48 98                	cltq   
  801801:	48 89 c2             	mov    %rax,%rdx
  801804:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801809:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80180c:	48 98                	cltq   
  80180e:	48 01 d0             	add    %rdx,%rax
  801811:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801815:	e9 5f ff ff ff       	jmpq   801779 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80181a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80181b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801820:	74 0b                	je     80182d <strtol+0x17c>
		*endptr = (char *) s;
  801822:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801826:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80182a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80182d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801831:	74 09                	je     80183c <strtol+0x18b>
  801833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801837:	48 f7 d8             	neg    %rax
  80183a:	eb 04                	jmp    801840 <strtol+0x18f>
  80183c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801840:	c9                   	leaveq 
  801841:	c3                   	retq   

0000000000801842 <strstr>:

char * strstr(const char *in, const char *str)
{
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 30          	sub    $0x30,%rsp
  80184a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80184e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801852:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801856:	0f b6 00             	movzbl (%rax),%eax
  801859:	88 45 ff             	mov    %al,-0x1(%rbp)
  80185c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801861:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801865:	75 06                	jne    80186d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	eb 68                	jmp    8018d5 <strstr+0x93>

	len = strlen(str);
  80186d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801871:	48 89 c7             	mov    %rax,%rdi
  801874:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
  801880:	48 98                	cltq   
  801882:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801890:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801895:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801899:	75 07                	jne    8018a2 <strstr+0x60>
				return (char *) 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	eb 33                	jmp    8018d5 <strstr+0x93>
		} while (sc != c);
  8018a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a9:	75 db                	jne    801886 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8018ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b7:	48 89 ce             	mov    %rcx,%rsi
  8018ba:	48 89 c7             	mov    %rax,%rdi
  8018bd:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	callq  *%rax
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	75 b9                	jne    801886 <strstr+0x44>

	return (char *) (in - 1);
  8018cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   
	...

00000000008018d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d8:	55                   	push   %rbp
  8018d9:	48 89 e5             	mov    %rsp,%rbp
  8018dc:	53                   	push   %rbx
  8018dd:	48 83 ec 58          	sub    $0x58,%rsp
  8018e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018fa:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8018fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801901:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801905:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801909:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80190d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801911:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801914:	4c 89 c3             	mov    %r8,%rbx
  801917:	cd 30                	int    $0x30
  801919:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80191d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801921:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801925:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801929:	74 3e                	je     801969 <syscall+0x91>
  80192b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801930:	7e 37                	jle    801969 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801936:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801939:	49 89 d0             	mov    %rdx,%r8
  80193c:	89 c1                	mov    %eax,%ecx
  80193e:	48 ba 68 58 80 00 00 	movabs $0x805868,%rdx
  801945:	00 00 00 
  801948:	be 23 00 00 00       	mov    $0x23,%esi
  80194d:	48 bf 85 58 80 00 00 	movabs $0x805885,%rdi
  801954:	00 00 00 
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	49 b9 78 03 80 00 00 	movabs $0x800378,%r9
  801963:	00 00 00 
  801966:	41 ff d1             	callq  *%r9

	return ret;
  801969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80196d:	48 83 c4 58          	add    $0x58,%rsp
  801971:	5b                   	pop    %rbx
  801972:	5d                   	pop    %rbp
  801973:	c3                   	retq   

0000000000801974 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801974:	55                   	push   %rbp
  801975:	48 89 e5             	mov    %rsp,%rbp
  801978:	48 83 ec 20          	sub    $0x20,%rsp
  80197c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801980:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801993:	00 
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a0:	48 89 d1             	mov    %rdx,%rcx
  8019a3:	48 89 c2             	mov    %rax,%rdx
  8019a6:	be 00 00 00 00       	mov    $0x0,%esi
  8019ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b0:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  8019b7:	00 00 00 
  8019ba:	ff d0                	callq  *%rax
}
  8019bc:	c9                   	leaveq 
  8019bd:	c3                   	retq   

00000000008019be <sys_cgetc>:

int
sys_cgetc(void)
{
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cd:	00 
  8019ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e4:	be 00 00 00 00       	mov    $0x0,%esi
  8019e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ee:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
}
  8019fa:	c9                   	leaveq 
  8019fb:	c3                   	retq   

00000000008019fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019fc:	55                   	push   %rbp
  8019fd:	48 89 e5             	mov    %rsp,%rbp
  801a00:	48 83 ec 20          	sub    $0x20,%rsp
  801a04:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0a:	48 98                	cltq   
  801a0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a13:	00 
  801a14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a25:	48 89 c2             	mov    %rax,%rdx
  801a28:	be 01 00 00 00       	mov    $0x1,%esi
  801a2d:	bf 03 00 00 00       	mov    $0x3,%edi
  801a32:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4f:	00 
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	be 00 00 00 00       	mov    $0x0,%esi
  801a6b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a70:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
}
  801a7c:	c9                   	leaveq 
  801a7d:	c3                   	retq   

0000000000801a7e <sys_yield>:

void
sys_yield(void)
{
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	be 00 00 00 00       	mov    $0x0,%esi
  801aa9:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aae:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 20          	sub    $0x20,%rsp
  801ac4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ace:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad1:	48 63 c8             	movslq %eax,%rcx
  801ad4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	49 89 c8             	mov    %rcx,%r8
  801aee:	48 89 d1             	mov    %rdx,%rcx
  801af1:	48 89 c2             	mov    %rax,%rdx
  801af4:	be 01 00 00 00       	mov    $0x1,%esi
  801af9:	bf 04 00 00 00       	mov    $0x4,%edi
  801afe:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
}
  801b0a:	c9                   	leaveq 
  801b0b:	c3                   	retq   

0000000000801b0c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b0c:	55                   	push   %rbp
  801b0d:	48 89 e5             	mov    %rsp,%rbp
  801b10:	48 83 ec 30          	sub    $0x30,%rsp
  801b14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b1e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b22:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b26:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b29:	48 63 c8             	movslq %eax,%rcx
  801b2c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b33:	48 63 f0             	movslq %eax,%rsi
  801b36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3d:	48 98                	cltq   
  801b3f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b43:	49 89 f9             	mov    %rdi,%r9
  801b46:	49 89 f0             	mov    %rsi,%r8
  801b49:	48 89 d1             	mov    %rdx,%rcx
  801b4c:	48 89 c2             	mov    %rax,%rdx
  801b4f:	be 01 00 00 00       	mov    $0x1,%esi
  801b54:	bf 05 00 00 00       	mov    $0x5,%edi
  801b59:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	48 83 ec 20          	sub    $0x20,%rsp
  801b6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7d:	48 98                	cltq   
  801b7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b86:	00 
  801b87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b93:	48 89 d1             	mov    %rdx,%rcx
  801b96:	48 89 c2             	mov    %rax,%rdx
  801b99:	be 01 00 00 00       	mov    $0x1,%esi
  801b9e:	bf 06 00 00 00       	mov    $0x6,%edi
  801ba3:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
}
  801baf:	c9                   	leaveq 
  801bb0:	c3                   	retq   

0000000000801bb1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
  801bb5:	48 83 ec 20          	sub    $0x20,%rsp
  801bb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc2:	48 63 d0             	movslq %eax,%rdx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bde:	48 89 d1             	mov    %rdx,%rcx
  801be1:	48 89 c2             	mov    %rax,%rdx
  801be4:	be 01 00 00 00       	mov    $0x1,%esi
  801be9:	bf 08 00 00 00       	mov    $0x8,%edi
  801bee:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
}
  801bfa:	c9                   	leaveq 
  801bfb:	c3                   	retq   

0000000000801bfc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	48 83 ec 20          	sub    $0x20,%rsp
  801c04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1b:	00 
  801c1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c28:	48 89 d1             	mov    %rdx,%rcx
  801c2b:	48 89 c2             	mov    %rax,%rdx
  801c2e:	be 01 00 00 00       	mov    $0x1,%esi
  801c33:	bf 09 00 00 00       	mov    $0x9,%edi
  801c38:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	48 83 ec 20          	sub    $0x20,%rsp
  801c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5c:	48 98                	cltq   
  801c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c65:	00 
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	48 89 d1             	mov    %rdx,%rcx
  801c75:	48 89 c2             	mov    %rax,%rdx
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c82:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 30          	sub    $0x30,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ca3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca9:	48 63 f0             	movslq %eax,%rsi
  801cac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb3:	48 98                	cltq   
  801cb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc0:	00 
  801cc1:	49 89 f1             	mov    %rsi,%r9
  801cc4:	49 89 c8             	mov    %rcx,%r8
  801cc7:	48 89 d1             	mov    %rdx,%rcx
  801cca:	48 89 c2             	mov    %rax,%rdx
  801ccd:	be 00 00 00 00       	mov    $0x0,%esi
  801cd2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cd7:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
}
  801ce3:	c9                   	leaveq 
  801ce4:	c3                   	retq   

0000000000801ce5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ce5:	55                   	push   %rbp
  801ce6:	48 89 e5             	mov    %rsp,%rbp
  801ce9:	48 83 ec 20          	sub    $0x20,%rsp
  801ced:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfc:	00 
  801cfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d0e:	48 89 c2             	mov    %rax,%rdx
  801d11:	be 01 00 00 00       	mov    $0x1,%esi
  801d16:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d1b:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801d22:	00 00 00 
  801d25:	ff d0                	callq  *%rax
}
  801d27:	c9                   	leaveq 
  801d28:	c3                   	retq   

0000000000801d29 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d29:	55                   	push   %rbp
  801d2a:	48 89 e5             	mov    %rsp,%rbp
  801d2d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d38:	00 
  801d39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4f:	be 00 00 00 00       	mov    $0x0,%esi
  801d54:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d59:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801d60:	00 00 00 
  801d63:	ff d0                	callq  *%rax
}
  801d65:	c9                   	leaveq 
  801d66:	c3                   	retq   

0000000000801d67 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d67:	55                   	push   %rbp
  801d68:	48 89 e5             	mov    %rsp,%rbp
  801d6b:	48 83 ec 30          	sub    $0x30,%rsp
  801d6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d76:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d79:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d7d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d84:	48 63 c8             	movslq %eax,%rcx
  801d87:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d8e:	48 63 f0             	movslq %eax,%rsi
  801d91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d98:	48 98                	cltq   
  801d9a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d9e:	49 89 f9             	mov    %rdi,%r9
  801da1:	49 89 f0             	mov    %rsi,%r8
  801da4:	48 89 d1             	mov    %rdx,%rcx
  801da7:	48 89 c2             	mov    %rax,%rdx
  801daa:	be 00 00 00 00       	mov    $0x0,%esi
  801daf:	bf 0f 00 00 00       	mov    $0xf,%edi
  801db4:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801dbb:	00 00 00 
  801dbe:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 20          	sub    $0x20,%rsp
  801dca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de1:	00 
  801de2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dee:	48 89 d1             	mov    %rdx,%rcx
  801df1:	48 89 c2             	mov    %rax,%rdx
  801df4:	be 00 00 00 00       	mov    $0x0,%esi
  801df9:	bf 10 00 00 00       	mov    $0x10,%edi
  801dfe:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	callq  *%rax
}
  801e0a:	c9                   	leaveq 
  801e0b:	c3                   	retq   

0000000000801e0c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e0c:	55                   	push   %rbp
  801e0d:	48 89 e5             	mov    %rsp,%rbp
  801e10:	48 83 ec 40          	sub    $0x40,%rsp
  801e14:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e1c:	48 8b 00             	mov    (%rax),%rax
  801e1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e27:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e2b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e32:	48 89 c2             	mov    %rax,%rdx
  801e35:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e40:	01 00 00 
  801e43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801e4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e4e:	83 e0 02             	and    $0x2,%eax
  801e51:	85 c0                	test   %eax,%eax
  801e53:	0f 84 4f 01 00 00    	je     801fa8 <pgfault+0x19c>
  801e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6b:	01 00 00 
  801e6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e72:	25 00 08 00 00       	and    $0x800,%eax
  801e77:	48 85 c0             	test   %rax,%rax
  801e7a:	0f 84 28 01 00 00    	je     801fa8 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801e80:	ba 07 00 00 00       	mov    $0x7,%edx
  801e85:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e8a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8f:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	0f 85 db 00 00 00    	jne    801f7e <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801eab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eaf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801eb5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebd:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ec2:	48 89 c6             	mov    %rax,%rsi
  801ec5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801eca:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eda:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ee0:	48 89 c1             	mov    %rax,%rcx
  801ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eed:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef2:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801f01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f05:	79 2a                	jns    801f31 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801f07:	48 ba 98 58 80 00 00 	movabs $0x805898,%rdx
  801f0e:	00 00 00 
  801f11:	be 28 00 00 00       	mov    $0x28,%esi
  801f16:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  801f1d:	00 00 00 
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  801f2c:	00 00 00 
  801f2f:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  801f31:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f36:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3b:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  801f42:	00 00 00 
  801f45:	ff d0                	callq  *%rax
  801f47:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801f4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f4e:	0f 89 84 00 00 00    	jns    801fd8 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  801f54:	48 ba d0 58 80 00 00 	movabs $0x8058d0,%rdx
  801f5b:	00 00 00 
  801f5e:	be 2c 00 00 00       	mov    $0x2c,%esi
  801f63:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  801f6a:	00 00 00 
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  801f79:	00 00 00 
  801f7c:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  801f7e:	48 ba 00 59 80 00 00 	movabs $0x805900,%rdx
  801f85:	00 00 00 
  801f88:	be 31 00 00 00       	mov    $0x31,%esi
  801f8d:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  801f94:	00 00 00 
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  801fa3:	00 00 00 
  801fa6:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  801fa8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fab:	89 c1                	mov    %eax,%ecx
  801fad:	48 ba 2a 59 80 00 00 	movabs $0x80592a,%rdx
  801fb4:	00 00 00 
  801fb7:	be 35 00 00 00       	mov    $0x35,%esi
  801fbc:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  801fc3:	00 00 00 
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  801fd2:	00 00 00 
  801fd5:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  801fd8:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 30          	sub    $0x30,%rsp
  801fe3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801fe6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  801fe9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ff0:	01 00 00 
  801ff3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801ff6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  801ffe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802001:	48 c1 e0 0c          	shl    $0xc,%rax
  802005:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200d:	25 07 0e 00 00       	and    $0xe07,%eax
  802012:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  802015:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802018:	25 00 04 00 00       	and    $0x400,%eax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	74 62                	je     802083 <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  802021:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802024:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802028:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80202b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202f:	41 89 f0             	mov    %esi,%r8d
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 00 00 00       	mov    $0x0,%edi
  80203a:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802049:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80204d:	0f 89 78 01 00 00    	jns    8021cb <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802053:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802056:	89 c1                	mov    %eax,%ecx
  802058:	48 ba 48 59 80 00 00 	movabs $0x805948,%rdx
  80205f:	00 00 00 
  802062:	be 4f 00 00 00       	mov    $0x4f,%esi
  802067:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  80206e:	00 00 00 
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  80207d:	00 00 00 
  802080:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  802083:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802086:	25 00 08 00 00       	and    $0x800,%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	75 0e                	jne    80209d <duppage+0xc2>
  80208f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802092:	83 e0 02             	and    $0x2,%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	0f 84 d0 00 00 00    	je     80216d <duppage+0x192>
		perm &= ~PTE_W;
  80209d:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  8020a1:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  8020a8:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8020ab:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020af:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b6:	41 89 f0             	mov    %esi,%r8d
  8020b9:	48 89 c6             	mov    %rax,%rsi
  8020bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c1:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	callq  *%rax
  8020cd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8020d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020d4:	79 30                	jns    802106 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  8020d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020d9:	89 c1                	mov    %eax,%ecx
  8020db:	48 ba 48 59 80 00 00 	movabs $0x805948,%rdx
  8020e2:	00 00 00 
  8020e5:	be 57 00 00 00       	mov    $0x57,%esi
  8020ea:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  8020f1:	00 00 00 
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  802100:	00 00 00 
  802103:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802106:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80210d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802111:	41 89 c8             	mov    %ecx,%r8d
  802114:	48 89 d1             	mov    %rdx,%rcx
  802117:	ba 00 00 00 00       	mov    $0x0,%edx
  80211c:	48 89 c6             	mov    %rax,%rsi
  80211f:	bf 00 00 00 00       	mov    $0x0,%edi
  802124:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802133:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802137:	0f 89 8e 00 00 00    	jns    8021cb <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80213d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802140:	89 c1                	mov    %eax,%ecx
  802142:	48 ba 48 59 80 00 00 	movabs $0x805948,%rdx
  802149:	00 00 00 
  80214c:	be 5b 00 00 00       	mov    $0x5b,%esi
  802151:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  802158:	00 00 00 
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
  802160:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  802167:	00 00 00 
  80216a:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  80216d:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802170:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802174:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217b:	41 89 f0             	mov    %esi,%r8d
  80217e:	48 89 c6             	mov    %rax,%rsi
  802181:	bf 00 00 00 00       	mov    $0x0,%edi
  802186:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  80218d:	00 00 00 
  802190:	ff d0                	callq  *%rax
  802192:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802195:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802199:	79 30                	jns    8021cb <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80219b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80219e:	89 c1                	mov    %eax,%ecx
  8021a0:	48 ba 48 59 80 00 00 	movabs $0x805948,%rdx
  8021a7:	00 00 00 
  8021aa:	be 61 00 00 00       	mov    $0x61,%esi
  8021af:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  8021b6:	00 00 00 
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8021c5:	00 00 00 
  8021c8:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	53                   	push   %rbx
  8021d7:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  8021db:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  8021e2:	48 bf 0c 1e 80 00 00 	movabs $0x801e0c,%rdi
  8021e9:	00 00 00 
  8021ec:	48 b8 d4 4e 80 00 00 	movabs $0x804ed4,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021f8:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  8021ff:	8b 45 9c             	mov    -0x64(%rbp),%eax
  802202:	cd 30                	int    $0x30
  802204:	89 c3                	mov    %eax,%ebx
  802206:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802209:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  80220c:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80220f:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802213:	79 30                	jns    802245 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  802215:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802218:	89 c1                	mov    %eax,%ecx
  80221a:	48 ba 6b 59 80 00 00 	movabs $0x80596b,%rdx
  802221:	00 00 00 
  802224:	be 80 00 00 00       	mov    $0x80,%esi
  802229:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  802230:	00 00 00 
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  80223f:	00 00 00 
  802242:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  802245:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802249:	75 52                	jne    80229d <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  80224b:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  802252:	00 00 00 
  802255:	ff d0                	callq  *%rax
  802257:	48 98                	cltq   
  802259:	48 89 c2             	mov    %rax,%rdx
  80225c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802262:	48 89 d0             	mov    %rdx,%rax
  802265:	48 c1 e0 02          	shl    $0x2,%rax
  802269:	48 01 d0             	add    %rdx,%rax
  80226c:	48 01 c0             	add    %rax,%rax
  80226f:	48 01 d0             	add    %rdx,%rax
  802272:	48 c1 e0 05          	shl    $0x5,%rax
  802276:	48 89 c2             	mov    %rax,%rdx
  802279:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802280:	00 00 00 
  802283:	48 01 c2             	add    %rax,%rdx
  802286:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80228d:	00 00 00 
  802290:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	e9 9d 02 00 00       	jmpq   80253a <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  80229d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8022a0:	ba 07 00 00 00       	mov    $0x7,%edx
  8022a5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022aa:	89 c7                	mov    %eax,%edi
  8022ac:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8022bb:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8022bf:	79 30                	jns    8022f1 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  8022c1:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8022c4:	89 c1                	mov    %eax,%ecx
  8022c6:	48 ba 6b 59 80 00 00 	movabs $0x80596b,%rdx
  8022cd:	00 00 00 
  8022d0:	be 88 00 00 00       	mov    $0x88,%esi
  8022d5:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  8022dc:	00 00 00 
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8022eb:	00 00 00 
  8022ee:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  8022f1:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8022f8:	00 
	uint64_t each_pte = 0;
  8022f9:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802300:	00 
	uint64_t each_pdpe = 0;
  802301:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802308:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802309:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802310:	00 
  802311:	e9 73 01 00 00       	jmpq   802489 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  802316:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80231d:	01 00 00 
  802320:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802324:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802328:	83 e0 01             	and    $0x1,%eax
  80232b:	84 c0                	test   %al,%al
  80232d:	0f 84 41 01 00 00    	je     802474 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802333:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80233a:	00 
  80233b:	e9 24 01 00 00       	jmpq   802464 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  802340:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802347:	01 00 00 
  80234a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80234e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802352:	83 e0 01             	and    $0x1,%eax
  802355:	84 c0                	test   %al,%al
  802357:	0f 84 ed 00 00 00    	je     80244a <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80235d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802364:	00 
  802365:	e9 d0 00 00 00       	jmpq   80243a <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  80236a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802371:	01 00 00 
  802374:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802378:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237c:	83 e0 01             	and    $0x1,%eax
  80237f:	84 c0                	test   %al,%al
  802381:	0f 84 99 00 00 00    	je     802420 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802387:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80238e:	00 
  80238f:	eb 7f                	jmp    802410 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802391:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802398:	01 00 00 
  80239b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80239f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a3:	83 e0 01             	and    $0x1,%eax
  8023a6:	84 c0                	test   %al,%al
  8023a8:	74 5c                	je     802406 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  8023aa:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  8023b1:	00 
  8023b2:	74 52                	je     802406 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  8023b4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8023b8:	89 c2                	mov    %eax,%edx
  8023ba:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8023bd:	89 d6                	mov    %edx,%esi
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
  8023cd:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8023d0:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8023d4:	79 30                	jns    802406 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  8023d6:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8023d9:	89 c1                	mov    %eax,%ecx
  8023db:	48 ba 6b 59 80 00 00 	movabs $0x80596b,%rdx
  8023e2:	00 00 00 
  8023e5:	be a0 00 00 00       	mov    $0xa0,%esi
  8023ea:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  8023f1:	00 00 00 
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  802400:	00 00 00 
  802403:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802406:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80240b:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  802410:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802417:	00 
  802418:	0f 86 73 ff ff ff    	jbe    802391 <fork+0x1bf>
  80241e:	eb 10                	jmp    802430 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  802420:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802424:	48 83 c0 01          	add    $0x1,%rax
  802428:	48 c1 e0 09          	shl    $0x9,%rax
  80242c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802430:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802435:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80243a:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802441:	00 
  802442:	0f 86 22 ff ff ff    	jbe    80236a <fork+0x198>
  802448:	eb 10                	jmp    80245a <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  80244a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80244e:	48 83 c0 01          	add    $0x1,%rax
  802452:	48 c1 e0 09          	shl    $0x9,%rax
  802456:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80245a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80245f:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  802464:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80246b:	00 
  80246c:	0f 86 ce fe ff ff    	jbe    802340 <fork+0x16e>
  802472:	eb 10                	jmp    802484 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802478:	48 83 c0 01          	add    $0x1,%rax
  80247c:	48 c1 e0 09          	shl    $0x9,%rax
  802480:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802484:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802489:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80248e:	0f 84 82 fe ff ff    	je     802316 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802494:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802497:	48 be 6c 4f 80 00 00 	movabs $0x804f6c,%rsi
  80249e:	00 00 00 
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	48 b8 46 1c 80 00 00 	movabs $0x801c46,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
  8024af:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8024b2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8024b6:	79 30                	jns    8024e8 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  8024b8:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8024bb:	89 c1                	mov    %eax,%ecx
  8024bd:	48 ba 6b 59 80 00 00 	movabs $0x80596b,%rdx
  8024c4:	00 00 00 
  8024c7:	be bd 00 00 00       	mov    $0xbd,%esi
  8024cc:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  8024d3:	00 00 00 
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8024e2:	00 00 00 
  8024e5:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8024e8:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8024eb:	be 02 00 00 00       	mov    $0x2,%esi
  8024f0:	89 c7                	mov    %eax,%edi
  8024f2:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
  8024fe:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802501:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802505:	79 30                	jns    802537 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802507:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80250a:	89 c1                	mov    %eax,%ecx
  80250c:	48 ba 6b 59 80 00 00 	movabs $0x80596b,%rdx
  802513:	00 00 00 
  802516:	be c1 00 00 00       	mov    $0xc1,%esi
  80251b:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  802522:	00 00 00 
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
  80252a:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  802531:	00 00 00 
  802534:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  802537:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  80253a:	48 83 c4 68          	add    $0x68,%rsp
  80253e:	5b                   	pop    %rbx
  80253f:	5d                   	pop    %rbp
  802540:	c3                   	retq   

0000000000802541 <sfork>:

// Challenge!
int
sfork(void)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802545:	48 ba 84 59 80 00 00 	movabs $0x805984,%rdx
  80254c:	00 00 00 
  80254f:	be cc 00 00 00       	mov    $0xcc,%esi
  802554:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  80255b:	00 00 00 
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  80256a:	00 00 00 
  80256d:	ff d1                	callq  *%rcx
	...

0000000000802570 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802570:	55                   	push   %rbp
  802571:	48 89 e5             	mov    %rsp,%rbp
  802574:	48 83 ec 08          	sub    $0x8,%rsp
  802578:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80257c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802580:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802587:	ff ff ff 
  80258a:	48 01 d0             	add    %rdx,%rax
  80258d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802591:	c9                   	leaveq 
  802592:	c3                   	retq   

0000000000802593 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802593:	55                   	push   %rbp
  802594:	48 89 e5             	mov    %rsp,%rbp
  802597:	48 83 ec 08          	sub    $0x8,%rsp
  80259b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80259f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a3:	48 89 c7             	mov    %rax,%rdi
  8025a6:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  8025ad:	00 00 00 
  8025b0:	ff d0                	callq  *%rax
  8025b2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025b8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025bc:	c9                   	leaveq 
  8025bd:	c3                   	retq   

00000000008025be <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025be:	55                   	push   %rbp
  8025bf:	48 89 e5             	mov    %rsp,%rbp
  8025c2:	48 83 ec 18          	sub    $0x18,%rsp
  8025c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025d1:	eb 6b                	jmp    80263e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d6:	48 98                	cltq   
  8025d8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025de:	48 c1 e0 0c          	shl    $0xc,%rax
  8025e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ea:	48 89 c2             	mov    %rax,%rdx
  8025ed:	48 c1 ea 15          	shr    $0x15,%rdx
  8025f1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f8:	01 00 00 
  8025fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ff:	83 e0 01             	and    $0x1,%eax
  802602:	48 85 c0             	test   %rax,%rax
  802605:	74 21                	je     802628 <fd_alloc+0x6a>
  802607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260b:	48 89 c2             	mov    %rax,%rdx
  80260e:	48 c1 ea 0c          	shr    $0xc,%rdx
  802612:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802619:	01 00 00 
  80261c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802620:	83 e0 01             	and    $0x1,%eax
  802623:	48 85 c0             	test   %rax,%rax
  802626:	75 12                	jne    80263a <fd_alloc+0x7c>
			*fd_store = fd;
  802628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802630:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
  802638:	eb 1a                	jmp    802654 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80263a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80263e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802642:	7e 8f                	jle    8025d3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802648:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80264f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 20          	sub    $0x20,%rsp
  80265e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802661:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802665:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802669:	78 06                	js     802671 <fd_lookup+0x1b>
  80266b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80266f:	7e 07                	jle    802678 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802671:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802676:	eb 6c                	jmp    8026e4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802678:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80267b:	48 98                	cltq   
  80267d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802683:	48 c1 e0 0c          	shl    $0xc,%rax
  802687:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80268b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80268f:	48 89 c2             	mov    %rax,%rdx
  802692:	48 c1 ea 15          	shr    $0x15,%rdx
  802696:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80269d:	01 00 00 
  8026a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a4:	83 e0 01             	and    $0x1,%eax
  8026a7:	48 85 c0             	test   %rax,%rax
  8026aa:	74 21                	je     8026cd <fd_lookup+0x77>
  8026ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b0:	48 89 c2             	mov    %rax,%rdx
  8026b3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026be:	01 00 00 
  8026c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c5:	83 e0 01             	and    $0x1,%eax
  8026c8:	48 85 c0             	test   %rax,%rax
  8026cb:	75 07                	jne    8026d4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026d2:	eb 10                	jmp    8026e4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026dc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e4:	c9                   	leaveq 
  8026e5:	c3                   	retq   

00000000008026e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026e6:	55                   	push   %rbp
  8026e7:	48 89 e5             	mov    %rsp,%rbp
  8026ea:	48 83 ec 30          	sub    $0x30,%rsp
  8026ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026f2:	89 f0                	mov    %esi,%eax
  8026f4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026fb:	48 89 c7             	mov    %rax,%rdi
  8026fe:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802705:	00 00 00 
  802708:	ff d0                	callq  *%rax
  80270a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80270e:	48 89 d6             	mov    %rdx,%rsi
  802711:	89 c7                	mov    %eax,%edi
  802713:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
  80271f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802726:	78 0a                	js     802732 <fd_close+0x4c>
	    || fd != fd2)
  802728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802730:	74 12                	je     802744 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802732:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802736:	74 05                	je     80273d <fd_close+0x57>
  802738:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273b:	eb 05                	jmp    802742 <fd_close+0x5c>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	eb 69                	jmp    8027ad <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802748:	8b 00                	mov    (%rax),%eax
  80274a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	89 c7                	mov    %eax,%edi
  802753:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802766:	78 2a                	js     802792 <fd_close+0xac>
		if (dev->dev_close)
  802768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802770:	48 85 c0             	test   %rax,%rax
  802773:	74 16                	je     80278b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802779:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80277d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802781:	48 89 c7             	mov    %rax,%rdi
  802784:	ff d2                	callq  *%rdx
  802786:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802789:	eb 07                	jmp    802792 <fd_close+0xac>
		else
			r = 0;
  80278b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802796:	48 89 c6             	mov    %rax,%rsi
  802799:	bf 00 00 00 00       	mov    $0x0,%edi
  80279e:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	callq  *%rax
	return r;
  8027aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027ad:	c9                   	leaveq 
  8027ae:	c3                   	retq   

00000000008027af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027af:	55                   	push   %rbp
  8027b0:	48 89 e5             	mov    %rsp,%rbp
  8027b3:	48 83 ec 20          	sub    $0x20,%rsp
  8027b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027c5:	eb 41                	jmp    802808 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027ce:	00 00 00 
  8027d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027d4:	48 63 d2             	movslq %edx,%rdx
  8027d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027db:	8b 00                	mov    (%rax),%eax
  8027dd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027e0:	75 22                	jne    802804 <dev_lookup+0x55>
			*dev = devtab[i];
  8027e2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027e9:	00 00 00 
  8027ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ef:	48 63 d2             	movslq %edx,%rdx
  8027f2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027fa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	eb 60                	jmp    802864 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802804:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802808:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80280f:	00 00 00 
  802812:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802815:	48 63 d2             	movslq %edx,%rdx
  802818:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281c:	48 85 c0             	test   %rax,%rax
  80281f:	75 a6                	jne    8027c7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802821:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802828:	00 00 00 
  80282b:	48 8b 00             	mov    (%rax),%rax
  80282e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802834:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802837:	89 c6                	mov    %eax,%esi
  802839:	48 bf a0 59 80 00 00 	movabs $0x8059a0,%rdi
  802840:	00 00 00 
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
  802848:	48 b9 b3 05 80 00 00 	movabs $0x8005b3,%rcx
  80284f:	00 00 00 
  802852:	ff d1                	callq  *%rcx
	*dev = 0;
  802854:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802858:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80285f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <close>:

int
close(int fdnum)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 83 ec 20          	sub    $0x20,%rsp
  80286e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802871:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802875:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802878:	48 89 d6             	mov    %rdx,%rsi
  80287b:	89 c7                	mov    %eax,%edi
  80287d:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802884:	00 00 00 
  802887:	ff d0                	callq  *%rax
  802889:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802890:	79 05                	jns    802897 <close+0x31>
		return r;
  802892:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802895:	eb 18                	jmp    8028af <close+0x49>
	else
		return fd_close(fd, 1);
  802897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289b:	be 01 00 00 00       	mov    $0x1,%esi
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
}
  8028af:	c9                   	leaveq 
  8028b0:	c3                   	retq   

00000000008028b1 <close_all>:

void
close_all(void)
{
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028c0:	eb 15                	jmp    8028d7 <close_all+0x26>
		close(i);
  8028c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c5:	89 c7                	mov    %eax,%edi
  8028c7:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028d7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028db:	7e e5                	jle    8028c2 <close_all+0x11>
		close(i);
}
  8028dd:	c9                   	leaveq 
  8028de:	c3                   	retq   

00000000008028df <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 40          	sub    $0x40,%rsp
  8028e7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028ea:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028ed:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028f1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028f4:	48 89 d6             	mov    %rdx,%rsi
  8028f7:	89 c7                	mov    %eax,%edi
  8028f9:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802900:	00 00 00 
  802903:	ff d0                	callq  *%rax
  802905:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802908:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290c:	79 08                	jns    802916 <dup+0x37>
		return r;
  80290e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802911:	e9 70 01 00 00       	jmpq   802a86 <dup+0x1a7>
	close(newfdnum);
  802916:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802919:	89 c7                	mov    %eax,%edi
  80291b:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802927:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80292a:	48 98                	cltq   
  80292c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802932:	48 c1 e0 0c          	shl    $0xc,%rax
  802936:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80293a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293e:	48 89 c7             	mov    %rax,%rdi
  802941:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax
  80294d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802955:	48 89 c7             	mov    %rax,%rdi
  802958:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296c:	48 89 c2             	mov    %rax,%rdx
  80296f:	48 c1 ea 15          	shr    $0x15,%rdx
  802973:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80297a:	01 00 00 
  80297d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802981:	83 e0 01             	and    $0x1,%eax
  802984:	84 c0                	test   %al,%al
  802986:	74 71                	je     8029f9 <dup+0x11a>
  802988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298c:	48 89 c2             	mov    %rax,%rdx
  80298f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802993:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80299a:	01 00 00 
  80299d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a1:	83 e0 01             	and    $0x1,%eax
  8029a4:	84 c0                	test   %al,%al
  8029a6:	74 51                	je     8029f9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ac:	48 89 c2             	mov    %rax,%rdx
  8029af:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ba:	01 00 00 
  8029bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c1:	89 c1                	mov    %eax,%ecx
  8029c3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8029c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d1:	41 89 c8             	mov    %ecx,%r8d
  8029d4:	48 89 d1             	mov    %rdx,%rcx
  8029d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029dc:	48 89 c6             	mov    %rax,%rsi
  8029df:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e4:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	callq  *%rax
  8029f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f7:	78 56                	js     802a4f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029fd:	48 89 c2             	mov    %rax,%rdx
  802a00:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a0b:	01 00 00 
  802a0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a12:	89 c1                	mov    %eax,%ecx
  802a14:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a22:	41 89 c8             	mov    %ecx,%r8d
  802a25:	48 89 d1             	mov    %rdx,%rcx
  802a28:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2d:	48 89 c6             	mov    %rax,%rsi
  802a30:	bf 00 00 00 00       	mov    $0x0,%edi
  802a35:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
  802a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a48:	78 08                	js     802a52 <dup+0x173>
		goto err;

	return newfdnum;
  802a4a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a4d:	eb 37                	jmp    802a86 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802a4f:	90                   	nop
  802a50:	eb 01                	jmp    802a53 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802a52:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a57:	48 89 c6             	mov    %rax,%rsi
  802a5a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a5f:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6f:	48 89 c6             	mov    %rax,%rsi
  802a72:	bf 00 00 00 00       	mov    $0x0,%edi
  802a77:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
	return r;
  802a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a86:	c9                   	leaveq 
  802a87:	c3                   	retq   

0000000000802a88 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a88:	55                   	push   %rbp
  802a89:	48 89 e5             	mov    %rsp,%rbp
  802a8c:	48 83 ec 40          	sub    $0x40,%rsp
  802a90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a93:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a97:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a9b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a9f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aa2:	48 89 d6             	mov    %rdx,%rsi
  802aa5:	89 c7                	mov    %eax,%edi
  802aa7:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
  802ab3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aba:	78 24                	js     802ae0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac0:	8b 00                	mov    (%rax),%eax
  802ac2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac6:	48 89 d6             	mov    %rdx,%rsi
  802ac9:	89 c7                	mov    %eax,%edi
  802acb:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	79 05                	jns    802ae5 <read+0x5d>
		return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	eb 7a                	jmp    802b5f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae9:	8b 40 08             	mov    0x8(%rax),%eax
  802aec:	83 e0 03             	and    $0x3,%eax
  802aef:	83 f8 01             	cmp    $0x1,%eax
  802af2:	75 3a                	jne    802b2e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802af4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802afb:	00 00 00 
  802afe:	48 8b 00             	mov    (%rax),%rax
  802b01:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b07:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b0a:	89 c6                	mov    %eax,%esi
  802b0c:	48 bf bf 59 80 00 00 	movabs $0x8059bf,%rdi
  802b13:	00 00 00 
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	48 b9 b3 05 80 00 00 	movabs $0x8005b3,%rcx
  802b22:	00 00 00 
  802b25:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b2c:	eb 31                	jmp    802b5f <read+0xd7>
	}
	if (!dev->dev_read)
  802b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b32:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b36:	48 85 c0             	test   %rax,%rax
  802b39:	75 07                	jne    802b42 <read+0xba>
		return -E_NOT_SUPP;
  802b3b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b40:	eb 1d                	jmp    802b5f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b52:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b56:	48 89 ce             	mov    %rcx,%rsi
  802b59:	48 89 c7             	mov    %rax,%rdi
  802b5c:	41 ff d0             	callq  *%r8
}
  802b5f:	c9                   	leaveq 
  802b60:	c3                   	retq   

0000000000802b61 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 30          	sub    $0x30,%rsp
  802b69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b70:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b7b:	eb 46                	jmp    802bc3 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b80:	48 98                	cltq   
  802b82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b86:	48 29 c2             	sub    %rax,%rdx
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8c:	48 98                	cltq   
  802b8e:	48 89 c1             	mov    %rax,%rcx
  802b91:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802b95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b98:	48 89 ce             	mov    %rcx,%rsi
  802b9b:	89 c7                	mov    %eax,%edi
  802b9d:	48 b8 88 2a 80 00 00 	movabs $0x802a88,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
  802ba9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bb0:	79 05                	jns    802bb7 <readn+0x56>
			return m;
  802bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb5:	eb 1d                	jmp    802bd4 <readn+0x73>
		if (m == 0)
  802bb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bbb:	74 13                	je     802bd0 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc0:	01 45 fc             	add    %eax,-0x4(%rbp)
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc6:	48 98                	cltq   
  802bc8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bcc:	72 af                	jb     802b7d <readn+0x1c>
  802bce:	eb 01                	jmp    802bd1 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802bd0:	90                   	nop
	}
	return tot;
  802bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd4:	c9                   	leaveq 
  802bd5:	c3                   	retq   

0000000000802bd6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bd6:	55                   	push   %rbp
  802bd7:	48 89 e5             	mov    %rsp,%rbp
  802bda:	48 83 ec 40          	sub    $0x40,%rsp
  802bde:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802be5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802be9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf0:	48 89 d6             	mov    %rdx,%rsi
  802bf3:	89 c7                	mov    %eax,%edi
  802bf5:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
  802c01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c08:	78 24                	js     802c2e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0e:	8b 00                	mov    (%rax),%eax
  802c10:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c14:	48 89 d6             	mov    %rdx,%rsi
  802c17:	89 c7                	mov    %eax,%edi
  802c19:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
  802c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2c:	79 05                	jns    802c33 <write+0x5d>
		return r;
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c31:	eb 79                	jmp    802cac <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c37:	8b 40 08             	mov    0x8(%rax),%eax
  802c3a:	83 e0 03             	and    $0x3,%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	75 3a                	jne    802c7b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c41:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c48:	00 00 00 
  802c4b:	48 8b 00             	mov    (%rax),%rax
  802c4e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c54:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c57:	89 c6                	mov    %eax,%esi
  802c59:	48 bf db 59 80 00 00 	movabs $0x8059db,%rdi
  802c60:	00 00 00 
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
  802c68:	48 b9 b3 05 80 00 00 	movabs $0x8005b3,%rcx
  802c6f:	00 00 00 
  802c72:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c79:	eb 31                	jmp    802cac <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c83:	48 85 c0             	test   %rax,%rax
  802c86:	75 07                	jne    802c8f <write+0xb9>
		return -E_NOT_SUPP;
  802c88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c8d:	eb 1d                	jmp    802cac <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c93:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c9f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ca3:	48 89 ce             	mov    %rcx,%rsi
  802ca6:	48 89 c7             	mov    %rax,%rdi
  802ca9:	41 ff d0             	callq  *%r8
}
  802cac:	c9                   	leaveq 
  802cad:	c3                   	retq   

0000000000802cae <seek>:

int
seek(int fdnum, off_t offset)
{
  802cae:	55                   	push   %rbp
  802caf:	48 89 e5             	mov    %rsp,%rbp
  802cb2:	48 83 ec 18          	sub    $0x18,%rsp
  802cb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cb9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cbc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc3:	48 89 d6             	mov    %rdx,%rsi
  802cc6:	89 c7                	mov    %eax,%edi
  802cc8:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdb:	79 05                	jns    802ce2 <seek+0x34>
		return r;
  802cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce0:	eb 0f                	jmp    802cf1 <seek+0x43>
	fd->fd_offset = offset;
  802ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf1:	c9                   	leaveq 
  802cf2:	c3                   	retq   

0000000000802cf3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802cf3:	55                   	push   %rbp
  802cf4:	48 89 e5             	mov    %rsp,%rbp
  802cf7:	48 83 ec 30          	sub    $0x30,%rsp
  802cfb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cfe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d08:	48 89 d6             	mov    %rdx,%rsi
  802d0b:	89 c7                	mov    %eax,%edi
  802d0d:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d20:	78 24                	js     802d46 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d26:	8b 00                	mov    (%rax),%eax
  802d28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2c:	48 89 d6             	mov    %rdx,%rsi
  802d2f:	89 c7                	mov    %eax,%edi
  802d31:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
  802d3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d44:	79 05                	jns    802d4b <ftruncate+0x58>
		return r;
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	eb 72                	jmp    802dbd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4f:	8b 40 08             	mov    0x8(%rax),%eax
  802d52:	83 e0 03             	and    $0x3,%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	75 3a                	jne    802d93 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d59:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d60:	00 00 00 
  802d63:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d66:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d6c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d6f:	89 c6                	mov    %eax,%esi
  802d71:	48 bf f8 59 80 00 00 	movabs $0x8059f8,%rdi
  802d78:	00 00 00 
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	48 b9 b3 05 80 00 00 	movabs $0x8005b3,%rcx
  802d87:	00 00 00 
  802d8a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d91:	eb 2a                	jmp    802dbd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d97:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d9b:	48 85 c0             	test   %rax,%rax
  802d9e:	75 07                	jne    802da7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802da0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802da5:	eb 16                	jmp    802dbd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dab:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802db6:	89 d6                	mov    %edx,%esi
  802db8:	48 89 c7             	mov    %rax,%rdi
  802dbb:	ff d1                	callq  *%rcx
}
  802dbd:	c9                   	leaveq 
  802dbe:	c3                   	retq   

0000000000802dbf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dbf:	55                   	push   %rbp
  802dc0:	48 89 e5             	mov    %rsp,%rbp
  802dc3:	48 83 ec 30          	sub    $0x30,%rsp
  802dc7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dd2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dd5:	48 89 d6             	mov    %rdx,%rsi
  802dd8:	89 c7                	mov    %eax,%edi
  802dda:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802de1:	00 00 00 
  802de4:	ff d0                	callq  *%rax
  802de6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ded:	78 24                	js     802e13 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df3:	8b 00                	mov    (%rax),%eax
  802df5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df9:	48 89 d6             	mov    %rdx,%rsi
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
  802e0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e11:	79 05                	jns    802e18 <fstat+0x59>
		return r;
  802e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e16:	eb 5e                	jmp    802e76 <fstat+0xb7>
	if (!dev->dev_stat)
  802e18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e20:	48 85 c0             	test   %rax,%rax
  802e23:	75 07                	jne    802e2c <fstat+0x6d>
		return -E_NOT_SUPP;
  802e25:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e2a:	eb 4a                	jmp    802e76 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e30:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e37:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e3e:	00 00 00 
	stat->st_isdir = 0;
  802e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e45:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e4c:	00 00 00 
	stat->st_dev = dev;
  802e4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e57:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e62:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802e6e:	48 89 d6             	mov    %rdx,%rsi
  802e71:	48 89 c7             	mov    %rax,%rdi
  802e74:	ff d1                	callq  *%rcx
}
  802e76:	c9                   	leaveq 
  802e77:	c3                   	retq   

0000000000802e78 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e78:	55                   	push   %rbp
  802e79:	48 89 e5             	mov    %rsp,%rbp
  802e7c:	48 83 ec 20          	sub    $0x20,%rsp
  802e80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8c:	be 00 00 00 00       	mov    $0x0,%esi
  802e91:	48 89 c7             	mov    %rax,%rdi
  802e94:	48 b8 67 2f 80 00 00 	movabs $0x802f67,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 05                	jns    802eae <stat+0x36>
		return fd;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 2f                	jmp    802edd <stat+0x65>
	r = fstat(fd, stat);
  802eae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb5:	48 89 d6             	mov    %rdx,%rsi
  802eb8:	89 c7                	mov    %eax,%edi
  802eba:	48 b8 bf 2d 80 00 00 	movabs $0x802dbf,%rax
  802ec1:	00 00 00 
  802ec4:	ff d0                	callq  *%rax
  802ec6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecc:	89 c7                	mov    %eax,%edi
  802ece:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
	return r;
  802eda:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802edd:	c9                   	leaveq 
  802ede:	c3                   	retq   
	...

0000000000802ee0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ee0:	55                   	push   %rbp
  802ee1:	48 89 e5             	mov    %rsp,%rbp
  802ee4:	48 83 ec 10          	sub    $0x10,%rsp
  802ee8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802eeb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802eef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef6:	00 00 00 
  802ef9:	8b 00                	mov    (%rax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	75 1d                	jne    802f1c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802eff:	bf 01 00 00 00       	mov    $0x1,%edi
  802f04:	48 b8 86 51 80 00 00 	movabs $0x805186,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f17:	00 00 00 
  802f1a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f23:	00 00 00 
  802f26:	8b 00                	mov    (%rax),%eax
  802f28:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f2b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f30:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802f37:	00 00 00 
  802f3a:	89 c7                	mov    %eax,%edi
  802f3c:	48 b8 d7 50 80 00 00 	movabs $0x8050d7,%rax
  802f43:	00 00 00 
  802f46:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f51:	48 89 c6             	mov    %rax,%rsi
  802f54:	bf 00 00 00 00       	mov    $0x0,%edi
  802f59:	48 b8 f0 4f 80 00 00 	movabs $0x804ff0,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
}
  802f65:	c9                   	leaveq 
  802f66:	c3                   	retq   

0000000000802f67 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802f67:	55                   	push   %rbp
  802f68:	48 89 e5             	mov    %rsp,%rbp
  802f6b:	48 83 ec 20          	sub    $0x20,%rsp
  802f6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f73:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7a:	48 89 c7             	mov    %rax,%rdi
  802f7d:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  802f84:	00 00 00 
  802f87:	ff d0                	callq  *%rax
  802f89:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f8e:	7e 0a                	jle    802f9a <open+0x33>
		return -E_BAD_PATH;
  802f90:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f95:	e9 a5 00 00 00       	jmpq   80303f <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802f9a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f9e:	48 89 c7             	mov    %rax,%rdi
  802fa1:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  802fa8:	00 00 00 
  802fab:	ff d0                	callq  *%rax
  802fad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802fb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb4:	79 08                	jns    802fbe <open+0x57>
		return r;
  802fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb9:	e9 81 00 00 00       	jmpq   80303f <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802fbe:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc5:	00 00 00 
  802fc8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fcb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd5:	48 89 c6             	mov    %rax,%rsi
  802fd8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802fdf:	00 00 00 
  802fe2:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  802fe9:	00 00 00 
  802fec:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	48 89 c6             	mov    %rax,%rsi
  802ff5:	bf 01 00 00 00       	mov    $0x1,%edi
  802ffa:	48 b8 e0 2e 80 00 00 	movabs $0x802ee0,%rax
  803001:	00 00 00 
  803004:	ff d0                	callq  *%rax
  803006:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300d:	79 1d                	jns    80302c <open+0xc5>
		fd_close(new_fd, 0);
  80300f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803013:	be 00 00 00 00       	mov    $0x0,%esi
  803018:	48 89 c7             	mov    %rax,%rdi
  80301b:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
		return r;	
  803027:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302a:	eb 13                	jmp    80303f <open+0xd8>
	}
	return fd2num(new_fd);
  80302c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803030:	48 89 c7             	mov    %rax,%rdi
  803033:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
}
  80303f:	c9                   	leaveq 
  803040:	c3                   	retq   

0000000000803041 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803041:	55                   	push   %rbp
  803042:	48 89 e5             	mov    %rsp,%rbp
  803045:	48 83 ec 10          	sub    $0x10,%rsp
  803049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80304d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803051:	8b 50 0c             	mov    0xc(%rax),%edx
  803054:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80305b:	00 00 00 
  80305e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803060:	be 00 00 00 00       	mov    $0x0,%esi
  803065:	bf 06 00 00 00       	mov    $0x6,%edi
  80306a:	48 b8 e0 2e 80 00 00 	movabs $0x802ee0,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
}
  803076:	c9                   	leaveq 
  803077:	c3                   	retq   

0000000000803078 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803078:	55                   	push   %rbp
  803079:	48 89 e5             	mov    %rsp,%rbp
  80307c:	48 83 ec 30          	sub    $0x30,%rsp
  803080:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803084:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803088:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  80308c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803090:	8b 50 0c             	mov    0xc(%rax),%edx
  803093:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80309a:	00 00 00 
  80309d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80309f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030a6:	00 00 00 
  8030a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ad:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8030b1:	be 00 00 00 00       	mov    $0x0,%esi
  8030b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8030bb:	48 b8 e0 2e 80 00 00 	movabs $0x802ee0,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
  8030c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8030ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ce:	7e 23                	jle    8030f3 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8030d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d3:	48 63 d0             	movslq %eax,%rdx
  8030d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030da:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030e1:	00 00 00 
  8030e4:	48 89 c7             	mov    %rax,%rdi
  8030e7:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
	}
	return nbytes;
  8030f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030f6:	c9                   	leaveq 
  8030f7:	c3                   	retq   

00000000008030f8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030f8:	55                   	push   %rbp
  8030f9:	48 89 e5             	mov    %rsp,%rbp
  8030fc:	48 83 ec 20          	sub    $0x20,%rsp
  803100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	8b 50 0c             	mov    0xc(%rax),%edx
  80310f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803116:	00 00 00 
  803119:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80311b:	be 00 00 00 00       	mov    $0x0,%esi
  803120:	bf 05 00 00 00       	mov    $0x5,%edi
  803125:	48 b8 e0 2e 80 00 00 	movabs $0x802ee0,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	79 05                	jns    80313f <devfile_stat+0x47>
		return r;
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	eb 56                	jmp    803195 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80313f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803143:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80314a:	00 00 00 
  80314d:	48 89 c7             	mov    %rax,%rdi
  803150:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80315c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803163:	00 00 00 
  803166:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80316c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803170:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803176:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80317d:	00 00 00 
  803180:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803186:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80318a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803195:	c9                   	leaveq 
  803196:	c3                   	retq   
	...

0000000000803198 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803198:	55                   	push   %rbp
  803199:	48 89 e5             	mov    %rsp,%rbp
  80319c:	53                   	push   %rbx
  80319d:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  8031a4:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  8031ab:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8031b2:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  8031b9:	be 00 00 00 00       	mov    $0x0,%esi
  8031be:	48 89 c7             	mov    %rax,%rdi
  8031c1:	48 b8 67 2f 80 00 00 	movabs $0x802f67,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
  8031cd:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8031d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8031d4:	79 08                	jns    8031de <spawn+0x46>
		return r;
  8031d6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031d9:	e9 23 03 00 00       	jmpq   803501 <spawn+0x369>
	fd = r;
  8031de:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031e1:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031e4:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  8031eb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8031ef:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  8031f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031f9:	ba 00 02 00 00       	mov    $0x200,%edx
  8031fe:	48 89 ce             	mov    %rcx,%rsi
  803201:	89 c7                	mov    %eax,%edi
  803203:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
  80320f:	3d 00 02 00 00       	cmp    $0x200,%eax
  803214:	75 0d                	jne    803223 <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  803216:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80321a:	8b 00                	mov    (%rax),%eax
  80321c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803221:	74 43                	je     803266 <spawn+0xce>
		close(fd);
  803223:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803226:	89 c7                	mov    %eax,%edi
  803228:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803234:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803238:	8b 00                	mov    (%rax),%eax
  80323a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80323f:	89 c6                	mov    %eax,%esi
  803241:	48 bf 20 5a 80 00 00 	movabs $0x805a20,%rdi
  803248:	00 00 00 
  80324b:	b8 00 00 00 00       	mov    $0x0,%eax
  803250:	48 b9 b3 05 80 00 00 	movabs $0x8005b3,%rcx
  803257:	00 00 00 
  80325a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80325c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803261:	e9 9b 02 00 00       	jmpq   803501 <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803266:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  80326d:	00 00 00 
  803270:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  803276:	cd 30                	int    $0x30
  803278:	89 c3                	mov    %eax,%ebx
  80327a:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80327d:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803280:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803283:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803287:	79 08                	jns    803291 <spawn+0xf9>
		return r;
  803289:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80328c:	e9 70 02 00 00       	jmpq   803501 <spawn+0x369>
	child = r;
  803291:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803294:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803297:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80329a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80329f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032a6:	00 00 00 
  8032a9:	48 63 d0             	movslq %eax,%rdx
  8032ac:	48 89 d0             	mov    %rdx,%rax
  8032af:	48 c1 e0 02          	shl    $0x2,%rax
  8032b3:	48 01 d0             	add    %rdx,%rax
  8032b6:	48 01 c0             	add    %rax,%rax
  8032b9:	48 01 d0             	add    %rdx,%rax
  8032bc:	48 c1 e0 05          	shl    $0x5,%rax
  8032c0:	48 01 c8             	add    %rcx,%rax
  8032c3:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8032ca:	48 89 c6             	mov    %rax,%rsi
  8032cd:	b8 18 00 00 00       	mov    $0x18,%eax
  8032d2:	48 89 d7             	mov    %rdx,%rdi
  8032d5:	48 89 c1             	mov    %rax,%rcx
  8032d8:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032db:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032df:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032e3:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032ea:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  8032f1:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032f8:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  8032ff:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803302:	48 89 ce             	mov    %rcx,%rsi
  803305:	89 c7                	mov    %eax,%edi
  803307:	48 b8 59 37 80 00 00 	movabs $0x803759,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
  803313:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803316:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80331a:	79 08                	jns    803324 <spawn+0x18c>
		return r;
  80331c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80331f:	e9 dd 01 00 00       	jmpq   803501 <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803324:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803328:	48 8b 40 20          	mov    0x20(%rax),%rax
  80332c:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  803333:	48 01 d0             	add    %rdx,%rax
  803336:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80333a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  803341:	eb 7a                	jmp    8033bd <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  803343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803347:	8b 00                	mov    (%rax),%eax
  803349:	83 f8 01             	cmp    $0x1,%eax
  80334c:	75 65                	jne    8033b3 <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  80334e:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803359:	8b 40 04             	mov    0x4(%rax),%eax
  80335c:	83 e0 02             	and    $0x2,%eax
  80335f:	85 c0                	test   %eax,%eax
  803361:	74 04                	je     803367 <spawn+0x1cf>
			perm |= PTE_W;
  803363:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80336b:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80336f:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803376:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337e:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803386:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80338a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80338d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803390:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803393:	89 3c 24             	mov    %edi,(%rsp)
  803396:	89 c7                	mov    %eax,%edi
  803398:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8033a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8033ab:	0f 88 2a 01 00 00    	js     8034db <spawn+0x343>
  8033b1:	eb 01                	jmp    8033b4 <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8033b3:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033b4:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8033b8:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  8033bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033c1:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033c5:	0f b7 c0             	movzwl %ax,%eax
  8033c8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8033cb:	0f 8f 72 ff ff ff    	jg     803343 <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033d1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033d4:	89 c7                	mov    %eax,%edi
  8033d6:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
	fd = -1;
  8033e2:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033e9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8033ec:	89 c7                	mov    %eax,%edi
  8033ee:	48 b8 b0 3b 80 00 00 	movabs $0x803bb0,%rax
  8033f5:	00 00 00 
  8033f8:	ff d0                	callq  *%rax
  8033fa:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8033fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803401:	79 30                	jns    803433 <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  803403:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803406:	89 c1                	mov    %eax,%ecx
  803408:	48 ba 3a 5a 80 00 00 	movabs $0x805a3a,%rdx
  80340f:	00 00 00 
  803412:	be 82 00 00 00       	mov    $0x82,%esi
  803417:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  80341e:	00 00 00 
  803421:	b8 00 00 00 00       	mov    $0x0,%eax
  803426:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  80342d:	00 00 00 
  803430:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803433:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  80343a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80343d:	48 89 d6             	mov    %rdx,%rsi
  803440:	89 c7                	mov    %eax,%edi
  803442:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  803449:	00 00 00 
  80344c:	ff d0                	callq  *%rax
  80344e:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803451:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803455:	79 30                	jns    803487 <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  803457:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80345a:	89 c1                	mov    %eax,%ecx
  80345c:	48 ba 5c 5a 80 00 00 	movabs $0x805a5c,%rdx
  803463:	00 00 00 
  803466:	be 85 00 00 00       	mov    $0x85,%esi
  80346b:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  803472:	00 00 00 
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
  80347a:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  803481:	00 00 00 
  803484:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803487:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80348a:	be 02 00 00 00       	mov    $0x2,%esi
  80348f:	89 c7                	mov    %eax,%edi
  803491:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
  80349d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8034a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8034a4:	79 30                	jns    8034d6 <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  8034a6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034a9:	89 c1                	mov    %eax,%ecx
  8034ab:	48 ba 76 5a 80 00 00 	movabs $0x805a76,%rdx
  8034b2:	00 00 00 
  8034b5:	be 88 00 00 00       	mov    $0x88,%esi
  8034ba:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  8034c1:	00 00 00 
  8034c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c9:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8034d0:	00 00 00 
  8034d3:	41 ff d0             	callq  *%r8

	return child;
  8034d6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8034d9:	eb 26                	jmp    803501 <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8034db:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8034dc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8034df:	89 c7                	mov    %eax,%edi
  8034e1:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
	close(fd);
  8034ed:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034f0:	89 c7                	mov    %eax,%edi
  8034f2:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
	return r;
  8034fe:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  803501:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  803508:	5b                   	pop    %rbx
  803509:	5d                   	pop    %rbp
  80350a:	c3                   	retq   

000000000080350b <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80350b:	55                   	push   %rbp
  80350c:	48 89 e5             	mov    %rsp,%rbp
  80350f:	53                   	push   %rbx
  803510:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  803517:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80351e:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  803525:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80352c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803533:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80353a:	84 c0                	test   %al,%al
  80353c:	74 23                	je     803561 <spawnl+0x56>
  80353e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803545:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803549:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80354d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803551:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803555:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803559:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80355d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803561:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803568:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  80356f:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803572:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803579:	00 00 00 
  80357c:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803583:	00 00 00 
  803586:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80358a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803591:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803598:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80359f:	eb 07                	jmp    8035a8 <spawnl+0x9d>
		argc++;
  8035a1:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8035a8:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8035ae:	83 f8 30             	cmp    $0x30,%eax
  8035b1:	73 23                	jae    8035d6 <spawnl+0xcb>
  8035b3:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  8035ba:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8035c0:	89 c0                	mov    %eax,%eax
  8035c2:	48 01 d0             	add    %rdx,%rax
  8035c5:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  8035cb:	83 c2 08             	add    $0x8,%edx
  8035ce:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  8035d4:	eb 15                	jmp    8035eb <spawnl+0xe0>
  8035d6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035dd:	48 89 d0             	mov    %rdx,%rax
  8035e0:	48 83 c2 08          	add    $0x8,%rdx
  8035e4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8035eb:	48 8b 00             	mov    (%rax),%rax
  8035ee:	48 85 c0             	test   %rax,%rax
  8035f1:	75 ae                	jne    8035a1 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035f3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  8035f9:	83 c0 02             	add    $0x2,%eax
  8035fc:	48 89 e2             	mov    %rsp,%rdx
  8035ff:	48 89 d3             	mov    %rdx,%rbx
  803602:	48 63 d0             	movslq %eax,%rdx
  803605:	48 83 ea 01          	sub    $0x1,%rdx
  803609:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  803610:	48 98                	cltq   
  803612:	48 c1 e0 03          	shl    $0x3,%rax
  803616:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  80361a:	b8 10 00 00 00       	mov    $0x10,%eax
  80361f:	48 83 e8 01          	sub    $0x1,%rax
  803623:	48 01 d0             	add    %rdx,%rax
  803626:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  80362d:	10 00 00 00 
  803631:	ba 00 00 00 00       	mov    $0x0,%edx
  803636:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  80363d:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803641:	48 29 c4             	sub    %rax,%rsp
  803644:	48 89 e0             	mov    %rsp,%rax
  803647:	48 83 c0 0f          	add    $0xf,%rax
  80364b:	48 c1 e8 04          	shr    $0x4,%rax
  80364f:	48 c1 e0 04          	shl    $0x4,%rax
  803653:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  80365a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803661:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  803668:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80366b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803671:	8d 50 01             	lea    0x1(%rax),%edx
  803674:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80367b:	48 63 d2             	movslq %edx,%rdx
  80367e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803685:	00 

	va_start(vl, arg0);
  803686:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  80368d:	00 00 00 
  803690:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803697:	00 00 00 
  80369a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80369e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  8036a5:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8036ac:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8036b3:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  8036ba:	00 00 00 
  8036bd:	eb 63                	jmp    803722 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  8036bf:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  8036c5:	8d 70 01             	lea    0x1(%rax),%esi
  8036c8:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8036ce:	83 f8 30             	cmp    $0x30,%eax
  8036d1:	73 23                	jae    8036f6 <spawnl+0x1eb>
  8036d3:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  8036da:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8036e0:	89 c0                	mov    %eax,%eax
  8036e2:	48 01 d0             	add    %rdx,%rax
  8036e5:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  8036eb:	83 c2 08             	add    $0x8,%edx
  8036ee:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  8036f4:	eb 15                	jmp    80370b <spawnl+0x200>
  8036f6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8036fd:	48 89 d0             	mov    %rdx,%rax
  803700:	48 83 c2 08          	add    $0x8,%rdx
  803704:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80370b:	48 8b 08             	mov    (%rax),%rcx
  80370e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803715:	89 f2                	mov    %esi,%edx
  803717:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80371b:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  803722:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803728:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  80372e:	77 8f                	ja     8036bf <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803730:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803737:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80373e:	48 89 d6             	mov    %rdx,%rsi
  803741:	48 89 c7             	mov    %rax,%rdi
  803744:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
  803750:	48 89 dc             	mov    %rbx,%rsp
}
  803753:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803757:	c9                   	leaveq 
  803758:	c3                   	retq   

0000000000803759 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803759:	55                   	push   %rbp
  80375a:	48 89 e5             	mov    %rsp,%rbp
  80375d:	48 83 ec 50          	sub    $0x50,%rsp
  803761:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803764:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803768:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80376c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803773:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803774:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80377b:	eb 2c                	jmp    8037a9 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  80377d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803780:	48 98                	cltq   
  803782:	48 c1 e0 03          	shl    $0x3,%rax
  803786:	48 03 45 c0          	add    -0x40(%rbp),%rax
  80378a:	48 8b 00             	mov    (%rax),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	83 c0 01             	add    $0x1,%eax
  80379f:	48 98                	cltq   
  8037a1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8037a5:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8037a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037ac:	48 98                	cltq   
  8037ae:	48 c1 e0 03          	shl    $0x3,%rax
  8037b2:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8037b6:	48 8b 00             	mov    (%rax),%rax
  8037b9:	48 85 c0             	test   %rax,%rax
  8037bc:	75 bf                	jne    80377d <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c2:	48 f7 d8             	neg    %rax
  8037c5:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037db:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037df:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037e2:	83 c2 01             	add    $0x1,%edx
  8037e5:	c1 e2 03             	shl    $0x3,%edx
  8037e8:	48 63 d2             	movslq %edx,%rdx
  8037eb:	48 f7 da             	neg    %rdx
  8037ee:	48 01 d0             	add    %rdx,%rax
  8037f1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8037f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f9:	48 83 e8 10          	sub    $0x10,%rax
  8037fd:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803803:	77 0a                	ja     80380f <init_stack+0xb6>
		return -E_NO_MEM;
  803805:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80380a:	e9 b8 01 00 00       	jmpq   8039c7 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80380f:	ba 07 00 00 00       	mov    $0x7,%edx
  803814:	be 00 00 40 00       	mov    $0x400000,%esi
  803819:	bf 00 00 00 00       	mov    $0x0,%edi
  80381e:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803825:	00 00 00 
  803828:	ff d0                	callq  *%rax
  80382a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80382d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803831:	79 08                	jns    80383b <init_stack+0xe2>
		return r;
  803833:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803836:	e9 8c 01 00 00       	jmpq   8039c7 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80383b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803842:	eb 73                	jmp    8038b7 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803844:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803847:	48 98                	cltq   
  803849:	48 c1 e0 03          	shl    $0x3,%rax
  80384d:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803851:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803856:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  80385a:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803861:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803864:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803867:	48 98                	cltq   
  803869:	48 c1 e0 03          	shl    $0x3,%rax
  80386d:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803871:	48 8b 10             	mov    (%rax),%rdx
  803874:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803878:	48 89 d6             	mov    %rdx,%rsi
  80387b:	48 89 c7             	mov    %rax,%rdi
  80387e:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80388a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80388d:	48 98                	cltq   
  80388f:	48 c1 e0 03          	shl    $0x3,%rax
  803893:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803897:	48 8b 00             	mov    (%rax),%rax
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	48 98                	cltq   
  8038ab:	48 83 c0 01          	add    $0x1,%rax
  8038af:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038b3:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038b7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038ba:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038bd:	7c 85                	jl     803844 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038c2:	48 98                	cltq   
  8038c4:	48 c1 e0 03          	shl    $0x3,%rax
  8038c8:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8038cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038d3:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038da:	00 
  8038db:	74 35                	je     803912 <init_stack+0x1b9>
  8038dd:	48 b9 90 5a 80 00 00 	movabs $0x805a90,%rcx
  8038e4:	00 00 00 
  8038e7:	48 ba b6 5a 80 00 00 	movabs $0x805ab6,%rdx
  8038ee:	00 00 00 
  8038f1:	be f1 00 00 00       	mov    $0xf1,%esi
  8038f6:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  8038fd:	00 00 00 
  803900:	b8 00 00 00 00       	mov    $0x0,%eax
  803905:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  80390c:	00 00 00 
  80390f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803912:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803916:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80391a:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80391f:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803923:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803929:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80392c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803930:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803934:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803937:	48 98                	cltq   
  803939:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80393c:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803941:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803945:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80394b:	48 89 c2             	mov    %rax,%rdx
  80394e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803952:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803955:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803958:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80395e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803963:	89 c2                	mov    %eax,%edx
  803965:	be 00 00 40 00       	mov    $0x400000,%esi
  80396a:	bf 00 00 00 00       	mov    $0x0,%edi
  80396f:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
  80397b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80397e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803982:	78 26                	js     8039aa <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803984:	be 00 00 40 00       	mov    $0x400000,%esi
  803989:	bf 00 00 00 00       	mov    $0x0,%edi
  80398e:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
  80399a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80399d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a1:	78 0a                	js     8039ad <init_stack+0x254>
		goto error;

	return 0;
  8039a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a8:	eb 1d                	jmp    8039c7 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8039aa:	90                   	nop
  8039ab:	eb 01                	jmp    8039ae <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8039ad:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8039ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8039b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b8:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
	return r;
  8039c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 50          	sub    $0x50,%rsp
  8039d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8039dc:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8039df:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8039e3:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8039e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039eb:	25 ff 0f 00 00       	and    $0xfff,%eax
  8039f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f7:	74 21                	je     803a1a <map_segment+0x51>
		va -= i;
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	48 98                	cltq   
  8039fe:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a05:	48 98                	cltq   
  803a07:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0e:	48 98                	cltq   
  803a10:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a17:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a21:	e9 74 01 00 00       	jmpq   803b9a <map_segment+0x1d1>
		if (i >= filesz) {
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a29:	48 98                	cltq   
  803a2b:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a2f:	72 38                	jb     803a69 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a34:	48 98                	cltq   
  803a36:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803a3a:	48 89 c1             	mov    %rax,%rcx
  803a3d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a40:	8b 55 10             	mov    0x10(%rbp),%edx
  803a43:	48 89 ce             	mov    %rcx,%rsi
  803a46:	89 c7                	mov    %eax,%edi
  803a48:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803a4f:	00 00 00 
  803a52:	ff d0                	callq  *%rax
  803a54:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a57:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a5b:	0f 89 32 01 00 00    	jns    803b93 <map_segment+0x1ca>
				return r;
  803a61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a64:	e9 45 01 00 00       	jmpq   803bae <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a69:	ba 07 00 00 00       	mov    $0x7,%edx
  803a6e:	be 00 00 40 00       	mov    $0x400000,%esi
  803a73:	bf 00 00 00 00       	mov    $0x0,%edi
  803a78:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803a7f:	00 00 00 
  803a82:	ff d0                	callq  *%rax
  803a84:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a87:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a8b:	79 08                	jns    803a95 <map_segment+0xcc>
				return r;
  803a8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a90:	e9 19 01 00 00       	jmpq   803bae <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a98:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803a9b:	01 c2                	add    %eax,%edx
  803a9d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803aa0:	89 d6                	mov    %edx,%esi
  803aa2:	89 c7                	mov    %eax,%edi
  803aa4:	48 b8 ae 2c 80 00 00 	movabs $0x802cae,%rax
  803aab:	00 00 00 
  803aae:	ff d0                	callq  *%rax
  803ab0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ab3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ab7:	79 08                	jns    803ac1 <map_segment+0xf8>
				return r;
  803ab9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abc:	e9 ed 00 00 00       	jmpq   803bae <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ac1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803acb:	48 98                	cltq   
  803acd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ad1:	48 89 d1             	mov    %rdx,%rcx
  803ad4:	48 29 c1             	sub    %rax,%rcx
  803ad7:	48 89 c8             	mov    %rcx,%rax
  803ada:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803ade:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ae1:	48 63 d0             	movslq %eax,%rdx
  803ae4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae8:	48 39 c2             	cmp    %rax,%rdx
  803aeb:	48 0f 47 d0          	cmova  %rax,%rdx
  803aef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803af2:	be 00 00 40 00       	mov    $0x400000,%esi
  803af7:	89 c7                	mov    %eax,%edi
  803af9:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
  803b05:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b08:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b0c:	79 08                	jns    803b16 <map_segment+0x14d>
				return r;
  803b0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b11:	e9 98 00 00 00       	jmpq   803bae <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b19:	48 98                	cltq   
  803b1b:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803b1f:	48 89 c2             	mov    %rax,%rdx
  803b22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b25:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b29:	48 89 d1             	mov    %rdx,%rcx
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	be 00 00 40 00       	mov    $0x400000,%esi
  803b33:	bf 00 00 00 00       	mov    $0x0,%edi
  803b38:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803b3f:	00 00 00 
  803b42:	ff d0                	callq  *%rax
  803b44:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b47:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b4b:	79 30                	jns    803b7d <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  803b4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b50:	89 c1                	mov    %eax,%ecx
  803b52:	48 ba cb 5a 80 00 00 	movabs $0x805acb,%rdx
  803b59:	00 00 00 
  803b5c:	be 24 01 00 00       	mov    $0x124,%esi
  803b61:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  803b68:	00 00 00 
  803b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b70:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  803b77:	00 00 00 
  803b7a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803b7d:	be 00 00 40 00       	mov    $0x400000,%esi
  803b82:	bf 00 00 00 00       	mov    $0x0,%edi
  803b87:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803b93:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9d:	48 98                	cltq   
  803b9f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ba3:	0f 82 7d fe ff ff    	jb     803a26 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bae:	c9                   	leaveq 
  803baf:	c3                   	retq   

0000000000803bb0 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bb0:	55                   	push   %rbp
  803bb1:	48 89 e5             	mov    %rsp,%rbp
  803bb4:	48 83 ec 60          	sub    $0x60,%rsp
  803bb8:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  803bbb:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  803bc2:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803bc9:	00 
    uint64_t each_pte = 0;
  803bca:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803bd1:	00 
    uint64_t each_pdpe = 0;
  803bd2:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803bd9:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  803bda:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803be1:	00 
  803be2:	e9 a5 01 00 00       	jmpq   803d8c <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  803be7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803bee:	01 00 00 
  803bf1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803bf5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bf9:	83 e0 01             	and    $0x1,%eax
  803bfc:	84 c0                	test   %al,%al
  803bfe:	0f 84 73 01 00 00    	je     803d77 <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803c04:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803c0b:	00 
  803c0c:	e9 56 01 00 00       	jmpq   803d67 <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  803c11:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c18:	01 00 00 
  803c1b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c23:	83 e0 01             	and    $0x1,%eax
  803c26:	84 c0                	test   %al,%al
  803c28:	0f 84 1f 01 00 00    	je     803d4d <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  803c2e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803c35:	00 
  803c36:	e9 02 01 00 00       	jmpq   803d3d <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  803c3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c42:	01 00 00 
  803c45:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4d:	83 e0 01             	and    $0x1,%eax
  803c50:	84 c0                	test   %al,%al
  803c52:	0f 84 cb 00 00 00    	je     803d23 <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803c58:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803c5f:	00 
  803c60:	e9 ae 00 00 00       	jmpq   803d13 <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  803c65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c6c:	01 00 00 
  803c6f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c77:	25 00 04 00 00       	and    $0x400,%eax
  803c7c:	48 85 c0             	test   %rax,%rax
  803c7f:	0f 84 84 00 00 00    	je     803d09 <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  803c85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c8c:	01 00 00 
  803c8f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c97:	25 07 0e 00 00       	and    $0xe07,%eax
  803c9c:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  803c9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca3:	48 c1 e0 0c          	shl    $0xc,%rax
  803ca7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  803cab:	8b 75 c0             	mov    -0x40(%rbp),%esi
  803cae:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  803cb2:	8b 55 ac             	mov    -0x54(%rbp),%edx
  803cb5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803cb9:	41 89 f0             	mov    %esi,%r8d
  803cbc:	48 89 c6             	mov    %rax,%rsi
  803cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc4:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  803cd3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803cd7:	79 30                	jns    803d09 <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  803cd9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803cdc:	89 c1                	mov    %eax,%ecx
  803cde:	48 ba e8 5a 80 00 00 	movabs $0x805ae8,%rdx
  803ce5:	00 00 00 
  803ce8:	be 48 01 00 00       	mov    $0x148,%esi
  803ced:	48 bf 50 5a 80 00 00 	movabs $0x805a50,%rdi
  803cf4:	00 00 00 
  803cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfc:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  803d03:	00 00 00 
  803d06:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803d09:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803d0e:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  803d13:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803d1a:	00 
  803d1b:	0f 86 44 ff ff ff    	jbe    803c65 <copy_shared_pages+0xb5>
  803d21:	eb 10                	jmp    803d33 <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  803d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d27:	48 83 c0 01          	add    $0x1,%rax
  803d2b:	48 c1 e0 09          	shl    $0x9,%rax
  803d2f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  803d33:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803d38:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803d3d:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803d44:	00 
  803d45:	0f 86 f0 fe ff ff    	jbe    803c3b <copy_shared_pages+0x8b>
  803d4b:	eb 10                	jmp    803d5d <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  803d4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d51:	48 83 c0 01          	add    $0x1,%rax
  803d55:	48 c1 e0 09          	shl    $0x9,%rax
  803d59:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803d5d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803d62:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  803d67:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803d6e:	00 
  803d6f:	0f 86 9c fe ff ff    	jbe    803c11 <copy_shared_pages+0x61>
  803d75:	eb 10                	jmp    803d87 <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  803d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d7b:	48 83 c0 01          	add    $0x1,%rax
  803d7f:	48 c1 e0 09          	shl    $0x9,%rax
  803d83:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  803d87:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d8c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d91:	0f 84 50 fe ff ff    	je     803be7 <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d9c:	c9                   	leaveq 
  803d9d:	c3                   	retq   
	...

0000000000803da0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803da0:	55                   	push   %rbp
  803da1:	48 89 e5             	mov    %rsp,%rbp
  803da4:	48 83 ec 20          	sub    $0x20,%rsp
  803da8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803dab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803daf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db2:	48 89 d6             	mov    %rdx,%rsi
  803db5:	89 c7                	mov    %eax,%edi
  803db7:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
  803dc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dca:	79 05                	jns    803dd1 <fd2sockid+0x31>
		return r;
  803dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcf:	eb 24                	jmp    803df5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd5:	8b 10                	mov    (%rax),%edx
  803dd7:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803dde:	00 00 00 
  803de1:	8b 00                	mov    (%rax),%eax
  803de3:	39 c2                	cmp    %eax,%edx
  803de5:	74 07                	je     803dee <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803de7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803dec:	eb 07                	jmp    803df5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803df5:	c9                   	leaveq 
  803df6:	c3                   	retq   

0000000000803df7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803df7:	55                   	push   %rbp
  803df8:	48 89 e5             	mov    %rsp,%rbp
  803dfb:	48 83 ec 20          	sub    $0x20,%rsp
  803dff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803e02:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e06:	48 89 c7             	mov    %rax,%rdi
  803e09:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	callq  *%rax
  803e15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1c:	78 26                	js     803e44 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e22:	ba 07 04 00 00       	mov    $0x407,%edx
  803e27:	48 89 c6             	mov    %rax,%rsi
  803e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2f:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
  803e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e42:	79 16                	jns    803e5a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e47:	89 c7                	mov    %eax,%edi
  803e49:	48 b8 04 43 80 00 00 	movabs $0x804304,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
		return r;
  803e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e58:	eb 3a                	jmp    803e94 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5e:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803e65:	00 00 00 
  803e68:	8b 12                	mov    (%rdx),%edx
  803e6a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e70:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e7e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e85:	48 89 c7             	mov    %rax,%rdi
  803e88:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  803e8f:	00 00 00 
  803e92:	ff d0                	callq  *%rax
}
  803e94:	c9                   	leaveq 
  803e95:	c3                   	retq   

0000000000803e96 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803e96:	55                   	push   %rbp
  803e97:	48 89 e5             	mov    %rsp,%rbp
  803e9a:	48 83 ec 30          	sub    $0x30,%rsp
  803e9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ea1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ea9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eac:	89 c7                	mov    %eax,%edi
  803eae:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
  803eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec1:	79 05                	jns    803ec8 <accept+0x32>
		return r;
  803ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec6:	eb 3b                	jmp    803f03 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803ec8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ecc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed3:	48 89 ce             	mov    %rcx,%rsi
  803ed6:	89 c7                	mov    %eax,%edi
  803ed8:	48 b8 e1 41 80 00 00 	movabs $0x8041e1,%rax
  803edf:	00 00 00 
  803ee2:	ff d0                	callq  *%rax
  803ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eeb:	79 05                	jns    803ef2 <accept+0x5c>
		return r;
  803eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef0:	eb 11                	jmp    803f03 <accept+0x6d>
	return alloc_sockfd(r);
  803ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef5:	89 c7                	mov    %eax,%edi
  803ef7:	48 b8 f7 3d 80 00 00 	movabs $0x803df7,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
}
  803f03:	c9                   	leaveq 
  803f04:	c3                   	retq   

0000000000803f05 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f05:	55                   	push   %rbp
  803f06:	48 89 e5             	mov    %rsp,%rbp
  803f09:	48 83 ec 20          	sub    $0x20,%rsp
  803f0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f14:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1a:	89 c7                	mov    %eax,%edi
  803f1c:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
  803f28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2f:	79 05                	jns    803f36 <bind+0x31>
		return r;
  803f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f34:	eb 1b                	jmp    803f51 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803f36:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f39:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f40:	48 89 ce             	mov    %rcx,%rsi
  803f43:	89 c7                	mov    %eax,%edi
  803f45:	48 b8 60 42 80 00 00 	movabs $0x804260,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
}
  803f51:	c9                   	leaveq 
  803f52:	c3                   	retq   

0000000000803f53 <shutdown>:

int
shutdown(int s, int how)
{
  803f53:	55                   	push   %rbp
  803f54:	48 89 e5             	mov    %rsp,%rbp
  803f57:	48 83 ec 20          	sub    $0x20,%rsp
  803f5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f5e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f64:	89 c7                	mov    %eax,%edi
  803f66:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  803f6d:	00 00 00 
  803f70:	ff d0                	callq  *%rax
  803f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f79:	79 05                	jns    803f80 <shutdown+0x2d>
		return r;
  803f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7e:	eb 16                	jmp    803f96 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803f80:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f86:	89 d6                	mov    %edx,%esi
  803f88:	89 c7                	mov    %eax,%edi
  803f8a:	48 b8 c4 42 80 00 00 	movabs $0x8042c4,%rax
  803f91:	00 00 00 
  803f94:	ff d0                	callq  *%rax
}
  803f96:	c9                   	leaveq 
  803f97:	c3                   	retq   

0000000000803f98 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803f98:	55                   	push   %rbp
  803f99:	48 89 e5             	mov    %rsp,%rbp
  803f9c:	48 83 ec 10          	sub    $0x10,%rsp
  803fa0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa8:	48 89 c7             	mov    %rax,%rdi
  803fab:	48 b8 14 52 80 00 00 	movabs $0x805214,%rax
  803fb2:	00 00 00 
  803fb5:	ff d0                	callq  *%rax
  803fb7:	83 f8 01             	cmp    $0x1,%eax
  803fba:	75 17                	jne    803fd3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc0:	8b 40 0c             	mov    0xc(%rax),%eax
  803fc3:	89 c7                	mov    %eax,%edi
  803fc5:	48 b8 04 43 80 00 00 	movabs $0x804304,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
  803fd1:	eb 05                	jmp    803fd8 <devsock_close+0x40>
	else
		return 0;
  803fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fd8:	c9                   	leaveq 
  803fd9:	c3                   	retq   

0000000000803fda <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fda:	55                   	push   %rbp
  803fdb:	48 89 e5             	mov    %rsp,%rbp
  803fde:	48 83 ec 20          	sub    $0x20,%rsp
  803fe2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fe5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fe9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803fec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fef:	89 c7                	mov    %eax,%edi
  803ff1:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  803ff8:	00 00 00 
  803ffb:	ff d0                	callq  *%rax
  803ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804004:	79 05                	jns    80400b <connect+0x31>
		return r;
  804006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804009:	eb 1b                	jmp    804026 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80400b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80400e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804015:	48 89 ce             	mov    %rcx,%rsi
  804018:	89 c7                	mov    %eax,%edi
  80401a:	48 b8 31 43 80 00 00 	movabs $0x804331,%rax
  804021:	00 00 00 
  804024:	ff d0                	callq  *%rax
}
  804026:	c9                   	leaveq 
  804027:	c3                   	retq   

0000000000804028 <listen>:

int
listen(int s, int backlog)
{
  804028:	55                   	push   %rbp
  804029:	48 89 e5             	mov    %rsp,%rbp
  80402c:	48 83 ec 20          	sub    $0x20,%rsp
  804030:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804033:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804039:	89 c7                	mov    %eax,%edi
  80403b:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  804042:	00 00 00 
  804045:	ff d0                	callq  *%rax
  804047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404e:	79 05                	jns    804055 <listen+0x2d>
		return r;
  804050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804053:	eb 16                	jmp    80406b <listen+0x43>
	return nsipc_listen(r, backlog);
  804055:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405b:	89 d6                	mov    %edx,%esi
  80405d:	89 c7                	mov    %eax,%edi
  80405f:	48 b8 95 43 80 00 00 	movabs $0x804395,%rax
  804066:	00 00 00 
  804069:	ff d0                	callq  *%rax
}
  80406b:	c9                   	leaveq 
  80406c:	c3                   	retq   

000000000080406d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80406d:	55                   	push   %rbp
  80406e:	48 89 e5             	mov    %rsp,%rbp
  804071:	48 83 ec 20          	sub    $0x20,%rsp
  804075:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804079:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80407d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804085:	89 c2                	mov    %eax,%edx
  804087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408b:	8b 40 0c             	mov    0xc(%rax),%eax
  80408e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804092:	b9 00 00 00 00       	mov    $0x0,%ecx
  804097:	89 c7                	mov    %eax,%edi
  804099:	48 b8 d5 43 80 00 00 	movabs $0x8043d5,%rax
  8040a0:	00 00 00 
  8040a3:	ff d0                	callq  *%rax
}
  8040a5:	c9                   	leaveq 
  8040a6:	c3                   	retq   

00000000008040a7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8040a7:	55                   	push   %rbp
  8040a8:	48 89 e5             	mov    %rsp,%rbp
  8040ab:	48 83 ec 20          	sub    $0x20,%rsp
  8040af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8040bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040bf:	89 c2                	mov    %eax,%edx
  8040c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c5:	8b 40 0c             	mov    0xc(%rax),%eax
  8040c8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8040cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8040d1:	89 c7                	mov    %eax,%edi
  8040d3:	48 b8 a1 44 80 00 00 	movabs $0x8044a1,%rax
  8040da:	00 00 00 
  8040dd:	ff d0                	callq  *%rax
}
  8040df:	c9                   	leaveq 
  8040e0:	c3                   	retq   

00000000008040e1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8040e1:	55                   	push   %rbp
  8040e2:	48 89 e5             	mov    %rsp,%rbp
  8040e5:	48 83 ec 10          	sub    $0x10,%rsp
  8040e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8040f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f5:	48 be 06 5b 80 00 00 	movabs $0x805b06,%rsi
  8040fc:	00 00 00 
  8040ff:	48 89 c7             	mov    %rax,%rdi
  804102:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  804109:	00 00 00 
  80410c:	ff d0                	callq  *%rax
	return 0;
  80410e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804113:	c9                   	leaveq 
  804114:	c3                   	retq   

0000000000804115 <socket>:

int
socket(int domain, int type, int protocol)
{
  804115:	55                   	push   %rbp
  804116:	48 89 e5             	mov    %rsp,%rbp
  804119:	48 83 ec 20          	sub    $0x20,%rsp
  80411d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804120:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804123:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804126:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804129:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80412c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80412f:	89 ce                	mov    %ecx,%esi
  804131:	89 c7                	mov    %eax,%edi
  804133:	48 b8 59 45 80 00 00 	movabs $0x804559,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
  80413f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804146:	79 05                	jns    80414d <socket+0x38>
		return r;
  804148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414b:	eb 11                	jmp    80415e <socket+0x49>
	return alloc_sockfd(r);
  80414d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804150:	89 c7                	mov    %eax,%edi
  804152:	48 b8 f7 3d 80 00 00 	movabs $0x803df7,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
}
  80415e:	c9                   	leaveq 
  80415f:	c3                   	retq   

0000000000804160 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804160:	55                   	push   %rbp
  804161:	48 89 e5             	mov    %rsp,%rbp
  804164:	48 83 ec 10          	sub    $0x10,%rsp
  804168:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80416b:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  804172:	00 00 00 
  804175:	8b 00                	mov    (%rax),%eax
  804177:	85 c0                	test   %eax,%eax
  804179:	75 1d                	jne    804198 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80417b:	bf 02 00 00 00       	mov    $0x2,%edi
  804180:	48 b8 86 51 80 00 00 	movabs $0x805186,%rax
  804187:	00 00 00 
  80418a:	ff d0                	callq  *%rax
  80418c:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  804193:	00 00 00 
  804196:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804198:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80419f:	00 00 00 
  8041a2:	8b 00                	mov    (%rax),%eax
  8041a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8041a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8041ac:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8041b3:	00 00 00 
  8041b6:	89 c7                	mov    %eax,%edi
  8041b8:	48 b8 d7 50 80 00 00 	movabs $0x8050d7,%rax
  8041bf:	00 00 00 
  8041c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8041c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8041c9:	be 00 00 00 00       	mov    $0x0,%esi
  8041ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d3:	48 b8 f0 4f 80 00 00 	movabs $0x804ff0,%rax
  8041da:	00 00 00 
  8041dd:	ff d0                	callq  *%rax
}
  8041df:	c9                   	leaveq 
  8041e0:	c3                   	retq   

00000000008041e1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8041e1:	55                   	push   %rbp
  8041e2:	48 89 e5             	mov    %rsp,%rbp
  8041e5:	48 83 ec 30          	sub    $0x30,%rsp
  8041e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8041f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fb:	00 00 00 
  8041fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804201:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804203:	bf 01 00 00 00       	mov    $0x1,%edi
  804208:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  80420f:	00 00 00 
  804212:	ff d0                	callq  *%rax
  804214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80421b:	78 3e                	js     80425b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80421d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804224:	00 00 00 
  804227:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80422b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422f:	8b 40 10             	mov    0x10(%rax),%eax
  804232:	89 c2                	mov    %eax,%edx
  804234:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804238:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80423c:	48 89 ce             	mov    %rcx,%rsi
  80423f:	48 89 c7             	mov    %rax,%rdi
  804242:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  804249:	00 00 00 
  80424c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80424e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804252:	8b 50 10             	mov    0x10(%rax),%edx
  804255:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804259:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80425b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80425e:	c9                   	leaveq 
  80425f:	c3                   	retq   

0000000000804260 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804260:	55                   	push   %rbp
  804261:	48 89 e5             	mov    %rsp,%rbp
  804264:	48 83 ec 10          	sub    $0x10,%rsp
  804268:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80426b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80426f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804272:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804279:	00 00 00 
  80427c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80427f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804281:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804288:	48 89 c6             	mov    %rax,%rsi
  80428b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804292:	00 00 00 
  804295:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8042a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042a8:	00 00 00 
  8042ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8042b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8042b6:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
}
  8042c2:	c9                   	leaveq 
  8042c3:	c3                   	retq   

00000000008042c4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8042c4:	55                   	push   %rbp
  8042c5:	48 89 e5             	mov    %rsp,%rbp
  8042c8:	48 83 ec 10          	sub    $0x10,%rsp
  8042cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8042d2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d9:	00 00 00 
  8042dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8042e1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e8:	00 00 00 
  8042eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8042f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8042f6:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8042fd:	00 00 00 
  804300:	ff d0                	callq  *%rax
}
  804302:	c9                   	leaveq 
  804303:	c3                   	retq   

0000000000804304 <nsipc_close>:

int
nsipc_close(int s)
{
  804304:	55                   	push   %rbp
  804305:	48 89 e5             	mov    %rsp,%rbp
  804308:	48 83 ec 10          	sub    $0x10,%rsp
  80430c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80430f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804316:	00 00 00 
  804319:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80431c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80431e:	bf 04 00 00 00       	mov    $0x4,%edi
  804323:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
}
  80432f:	c9                   	leaveq 
  804330:	c3                   	retq   

0000000000804331 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804331:	55                   	push   %rbp
  804332:	48 89 e5             	mov    %rsp,%rbp
  804335:	48 83 ec 10          	sub    $0x10,%rsp
  804339:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80433c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804340:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804343:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80434a:	00 00 00 
  80434d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804350:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804352:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804359:	48 89 c6             	mov    %rax,%rsi
  80435c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804363:	00 00 00 
  804366:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  80436d:	00 00 00 
  804370:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804372:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804379:	00 00 00 
  80437c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80437f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804382:	bf 05 00 00 00       	mov    $0x5,%edi
  804387:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  80438e:	00 00 00 
  804391:	ff d0                	callq  *%rax
}
  804393:	c9                   	leaveq 
  804394:	c3                   	retq   

0000000000804395 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804395:	55                   	push   %rbp
  804396:	48 89 e5             	mov    %rsp,%rbp
  804399:	48 83 ec 10          	sub    $0x10,%rsp
  80439d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043a0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8043a3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043aa:	00 00 00 
  8043ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043b0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8043b2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043b9:	00 00 00 
  8043bc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043bf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8043c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8043c7:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8043ce:	00 00 00 
  8043d1:	ff d0                	callq  *%rax
}
  8043d3:	c9                   	leaveq 
  8043d4:	c3                   	retq   

00000000008043d5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8043d5:	55                   	push   %rbp
  8043d6:	48 89 e5             	mov    %rsp,%rbp
  8043d9:	48 83 ec 30          	sub    $0x30,%rsp
  8043dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043e4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8043e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8043ea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f1:	00 00 00 
  8043f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043f7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8043f9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804400:	00 00 00 
  804403:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804406:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804409:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804410:	00 00 00 
  804413:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804416:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804419:	bf 07 00 00 00       	mov    $0x7,%edi
  80441e:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  804425:	00 00 00 
  804428:	ff d0                	callq  *%rax
  80442a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80442d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804431:	78 69                	js     80449c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804433:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80443a:	7f 08                	jg     804444 <nsipc_recv+0x6f>
  80443c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804442:	7e 35                	jle    804479 <nsipc_recv+0xa4>
  804444:	48 b9 0d 5b 80 00 00 	movabs $0x805b0d,%rcx
  80444b:	00 00 00 
  80444e:	48 ba 22 5b 80 00 00 	movabs $0x805b22,%rdx
  804455:	00 00 00 
  804458:	be 61 00 00 00       	mov    $0x61,%esi
  80445d:	48 bf 37 5b 80 00 00 	movabs $0x805b37,%rdi
  804464:	00 00 00 
  804467:	b8 00 00 00 00       	mov    $0x0,%eax
  80446c:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  804473:	00 00 00 
  804476:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447c:	48 63 d0             	movslq %eax,%rdx
  80447f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804483:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80448a:	00 00 00 
  80448d:	48 89 c7             	mov    %rax,%rdi
  804490:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax
	}

	return r;
  80449c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80449f:	c9                   	leaveq 
  8044a0:	c3                   	retq   

00000000008044a1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8044a1:	55                   	push   %rbp
  8044a2:	48 89 e5             	mov    %rsp,%rbp
  8044a5:	48 83 ec 20          	sub    $0x20,%rsp
  8044a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8044b3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8044b6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044bd:	00 00 00 
  8044c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044c3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8044c5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8044cc:	7e 35                	jle    804503 <nsipc_send+0x62>
  8044ce:	48 b9 43 5b 80 00 00 	movabs $0x805b43,%rcx
  8044d5:	00 00 00 
  8044d8:	48 ba 22 5b 80 00 00 	movabs $0x805b22,%rdx
  8044df:	00 00 00 
  8044e2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8044e7:	48 bf 37 5b 80 00 00 	movabs $0x805b37,%rdi
  8044ee:	00 00 00 
  8044f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f6:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  8044fd:	00 00 00 
  804500:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804503:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804506:	48 63 d0             	movslq %eax,%rdx
  804509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450d:	48 89 c6             	mov    %rax,%rsi
  804510:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804517:	00 00 00 
  80451a:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  804521:	00 00 00 
  804524:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804526:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80452d:	00 00 00 
  804530:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804533:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804536:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80453d:	00 00 00 
  804540:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804543:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804546:	bf 08 00 00 00       	mov    $0x8,%edi
  80454b:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  804552:	00 00 00 
  804555:	ff d0                	callq  *%rax
}
  804557:	c9                   	leaveq 
  804558:	c3                   	retq   

0000000000804559 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804559:	55                   	push   %rbp
  80455a:	48 89 e5             	mov    %rsp,%rbp
  80455d:	48 83 ec 10          	sub    $0x10,%rsp
  804561:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804564:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804567:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80456a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804571:	00 00 00 
  804574:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804577:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804579:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804580:	00 00 00 
  804583:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804586:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804589:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804590:	00 00 00 
  804593:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804596:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804599:	bf 09 00 00 00       	mov    $0x9,%edi
  80459e:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8045a5:	00 00 00 
  8045a8:	ff d0                	callq  *%rax
}
  8045aa:	c9                   	leaveq 
  8045ab:	c3                   	retq   

00000000008045ac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8045ac:	55                   	push   %rbp
  8045ad:	48 89 e5             	mov    %rsp,%rbp
  8045b0:	53                   	push   %rbx
  8045b1:	48 83 ec 38          	sub    $0x38,%rsp
  8045b5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8045b9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8045bd:	48 89 c7             	mov    %rax,%rdi
  8045c0:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  8045c7:	00 00 00 
  8045ca:	ff d0                	callq  *%rax
  8045cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045d3:	0f 88 bf 01 00 00    	js     804798 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045dd:	ba 07 04 00 00       	mov    $0x407,%edx
  8045e2:	48 89 c6             	mov    %rax,%rsi
  8045e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8045ea:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8045f1:	00 00 00 
  8045f4:	ff d0                	callq  *%rax
  8045f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045fd:	0f 88 95 01 00 00    	js     804798 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804603:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804607:	48 89 c7             	mov    %rax,%rdi
  80460a:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  804611:	00 00 00 
  804614:	ff d0                	callq  *%rax
  804616:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804619:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80461d:	0f 88 5d 01 00 00    	js     804780 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804623:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804627:	ba 07 04 00 00       	mov    $0x407,%edx
  80462c:	48 89 c6             	mov    %rax,%rsi
  80462f:	bf 00 00 00 00       	mov    $0x0,%edi
  804634:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80463b:	00 00 00 
  80463e:	ff d0                	callq  *%rax
  804640:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804643:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804647:	0f 88 33 01 00 00    	js     804780 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80464d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804651:	48 89 c7             	mov    %rax,%rdi
  804654:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80465b:	00 00 00 
  80465e:	ff d0                	callq  *%rax
  804660:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804664:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804668:	ba 07 04 00 00       	mov    $0x407,%edx
  80466d:	48 89 c6             	mov    %rax,%rsi
  804670:	bf 00 00 00 00       	mov    $0x0,%edi
  804675:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80467c:	00 00 00 
  80467f:	ff d0                	callq  *%rax
  804681:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804684:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804688:	0f 88 d9 00 00 00    	js     804767 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80468e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804692:	48 89 c7             	mov    %rax,%rdi
  804695:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80469c:	00 00 00 
  80469f:	ff d0                	callq  *%rax
  8046a1:	48 89 c2             	mov    %rax,%rdx
  8046a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046a8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8046ae:	48 89 d1             	mov    %rdx,%rcx
  8046b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8046b6:	48 89 c6             	mov    %rax,%rsi
  8046b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8046be:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8046c5:	00 00 00 
  8046c8:	ff d0                	callq  *%rax
  8046ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046d1:	78 79                	js     80474c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8046d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d7:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8046de:	00 00 00 
  8046e1:	8b 12                	mov    (%rdx),%edx
  8046e3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8046e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8046f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046f4:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8046fb:	00 00 00 
  8046fe:	8b 12                	mov    (%rdx),%edx
  804700:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804706:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80470d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804711:	48 89 c7             	mov    %rax,%rdi
  804714:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80471b:	00 00 00 
  80471e:	ff d0                	callq  *%rax
  804720:	89 c2                	mov    %eax,%edx
  804722:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804726:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804728:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80472c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804730:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804734:	48 89 c7             	mov    %rax,%rdi
  804737:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80473e:	00 00 00 
  804741:	ff d0                	callq  *%rax
  804743:	89 03                	mov    %eax,(%rbx)
	return 0;
  804745:	b8 00 00 00 00       	mov    $0x0,%eax
  80474a:	eb 4f                	jmp    80479b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80474c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80474d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804751:	48 89 c6             	mov    %rax,%rsi
  804754:	bf 00 00 00 00       	mov    $0x0,%edi
  804759:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  804760:	00 00 00 
  804763:	ff d0                	callq  *%rax
  804765:	eb 01                	jmp    804768 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804767:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804768:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80476c:	48 89 c6             	mov    %rax,%rsi
  80476f:	bf 00 00 00 00       	mov    $0x0,%edi
  804774:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  80477b:	00 00 00 
  80477e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804784:	48 89 c6             	mov    %rax,%rsi
  804787:	bf 00 00 00 00       	mov    $0x0,%edi
  80478c:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  804793:	00 00 00 
  804796:	ff d0                	callq  *%rax
err:
	return r;
  804798:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80479b:	48 83 c4 38          	add    $0x38,%rsp
  80479f:	5b                   	pop    %rbx
  8047a0:	5d                   	pop    %rbp
  8047a1:	c3                   	retq   

00000000008047a2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8047a2:	55                   	push   %rbp
  8047a3:	48 89 e5             	mov    %rsp,%rbp
  8047a6:	53                   	push   %rbx
  8047a7:	48 83 ec 28          	sub    $0x28,%rsp
  8047ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8047b3:	eb 01                	jmp    8047b6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8047b5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8047b6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8047bd:	00 00 00 
  8047c0:	48 8b 00             	mov    (%rax),%rax
  8047c3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8047c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8047cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047d0:	48 89 c7             	mov    %rax,%rdi
  8047d3:	48 b8 14 52 80 00 00 	movabs $0x805214,%rax
  8047da:	00 00 00 
  8047dd:	ff d0                	callq  *%rax
  8047df:	89 c3                	mov    %eax,%ebx
  8047e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047e5:	48 89 c7             	mov    %rax,%rdi
  8047e8:	48 b8 14 52 80 00 00 	movabs $0x805214,%rax
  8047ef:	00 00 00 
  8047f2:	ff d0                	callq  *%rax
  8047f4:	39 c3                	cmp    %eax,%ebx
  8047f6:	0f 94 c0             	sete   %al
  8047f9:	0f b6 c0             	movzbl %al,%eax
  8047fc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8047ff:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804806:	00 00 00 
  804809:	48 8b 00             	mov    (%rax),%rax
  80480c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804812:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804815:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804818:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80481b:	75 0a                	jne    804827 <_pipeisclosed+0x85>
			return ret;
  80481d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  804820:	48 83 c4 28          	add    $0x28,%rsp
  804824:	5b                   	pop    %rbx
  804825:	5d                   	pop    %rbp
  804826:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804827:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80482a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80482d:	74 86                	je     8047b5 <_pipeisclosed+0x13>
  80482f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804833:	75 80                	jne    8047b5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804835:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80483c:	00 00 00 
  80483f:	48 8b 00             	mov    (%rax),%rax
  804842:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804848:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80484b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80484e:	89 c6                	mov    %eax,%esi
  804850:	48 bf 54 5b 80 00 00 	movabs $0x805b54,%rdi
  804857:	00 00 00 
  80485a:	b8 00 00 00 00       	mov    $0x0,%eax
  80485f:	49 b8 b3 05 80 00 00 	movabs $0x8005b3,%r8
  804866:	00 00 00 
  804869:	41 ff d0             	callq  *%r8
	}
  80486c:	e9 44 ff ff ff       	jmpq   8047b5 <_pipeisclosed+0x13>

0000000000804871 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804871:	55                   	push   %rbp
  804872:	48 89 e5             	mov    %rsp,%rbp
  804875:	48 83 ec 30          	sub    $0x30,%rsp
  804879:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80487c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804880:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804883:	48 89 d6             	mov    %rdx,%rsi
  804886:	89 c7                	mov    %eax,%edi
  804888:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80488f:	00 00 00 
  804892:	ff d0                	callq  *%rax
  804894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80489b:	79 05                	jns    8048a2 <pipeisclosed+0x31>
		return r;
  80489d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048a0:	eb 31                	jmp    8048d3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8048a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a6:	48 89 c7             	mov    %rax,%rdi
  8048a9:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8048b0:	00 00 00 
  8048b3:	ff d0                	callq  *%rax
  8048b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8048b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048c1:	48 89 d6             	mov    %rdx,%rsi
  8048c4:	48 89 c7             	mov    %rax,%rdi
  8048c7:	48 b8 a2 47 80 00 00 	movabs $0x8047a2,%rax
  8048ce:	00 00 00 
  8048d1:	ff d0                	callq  *%rax
}
  8048d3:	c9                   	leaveq 
  8048d4:	c3                   	retq   

00000000008048d5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048d5:	55                   	push   %rbp
  8048d6:	48 89 e5             	mov    %rsp,%rbp
  8048d9:	48 83 ec 40          	sub    $0x40,%rsp
  8048dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8048e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8048e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ed:	48 89 c7             	mov    %rax,%rdi
  8048f0:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8048f7:	00 00 00 
  8048fa:	ff d0                	callq  *%rax
  8048fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804900:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804904:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804908:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80490f:	00 
  804910:	e9 97 00 00 00       	jmpq   8049ac <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804915:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80491a:	74 09                	je     804925 <devpipe_read+0x50>
				return i;
  80491c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804920:	e9 95 00 00 00       	jmpq   8049ba <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804925:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80492d:	48 89 d6             	mov    %rdx,%rsi
  804930:	48 89 c7             	mov    %rax,%rdi
  804933:	48 b8 a2 47 80 00 00 	movabs $0x8047a2,%rax
  80493a:	00 00 00 
  80493d:	ff d0                	callq  *%rax
  80493f:	85 c0                	test   %eax,%eax
  804941:	74 07                	je     80494a <devpipe_read+0x75>
				return 0;
  804943:	b8 00 00 00 00       	mov    $0x0,%eax
  804948:	eb 70                	jmp    8049ba <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80494a:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  804951:	00 00 00 
  804954:	ff d0                	callq  *%rax
  804956:	eb 01                	jmp    804959 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804958:	90                   	nop
  804959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80495d:	8b 10                	mov    (%rax),%edx
  80495f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804963:	8b 40 04             	mov    0x4(%rax),%eax
  804966:	39 c2                	cmp    %eax,%edx
  804968:	74 ab                	je     804915 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80496a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80496e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804972:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80497a:	8b 00                	mov    (%rax),%eax
  80497c:	89 c2                	mov    %eax,%edx
  80497e:	c1 fa 1f             	sar    $0x1f,%edx
  804981:	c1 ea 1b             	shr    $0x1b,%edx
  804984:	01 d0                	add    %edx,%eax
  804986:	83 e0 1f             	and    $0x1f,%eax
  804989:	29 d0                	sub    %edx,%eax
  80498b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80498f:	48 98                	cltq   
  804991:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804996:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499c:	8b 00                	mov    (%rax),%eax
  80499e:	8d 50 01             	lea    0x1(%rax),%edx
  8049a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049a5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049b0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049b4:	72 a2                	jb     804958 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8049b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8049ba:	c9                   	leaveq 
  8049bb:	c3                   	retq   

00000000008049bc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8049bc:	55                   	push   %rbp
  8049bd:	48 89 e5             	mov    %rsp,%rbp
  8049c0:	48 83 ec 40          	sub    $0x40,%rsp
  8049c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8049cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8049d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d4:	48 89 c7             	mov    %rax,%rdi
  8049d7:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8049de:	00 00 00 
  8049e1:	ff d0                	callq  *%rax
  8049e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8049e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8049ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8049f6:	00 
  8049f7:	e9 93 00 00 00       	jmpq   804a8f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8049fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a04:	48 89 d6             	mov    %rdx,%rsi
  804a07:	48 89 c7             	mov    %rax,%rdi
  804a0a:	48 b8 a2 47 80 00 00 	movabs $0x8047a2,%rax
  804a11:	00 00 00 
  804a14:	ff d0                	callq  *%rax
  804a16:	85 c0                	test   %eax,%eax
  804a18:	74 07                	je     804a21 <devpipe_write+0x65>
				return 0;
  804a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  804a1f:	eb 7c                	jmp    804a9d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804a21:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  804a28:	00 00 00 
  804a2b:	ff d0                	callq  *%rax
  804a2d:	eb 01                	jmp    804a30 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a2f:	90                   	nop
  804a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a34:	8b 40 04             	mov    0x4(%rax),%eax
  804a37:	48 63 d0             	movslq %eax,%rdx
  804a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a3e:	8b 00                	mov    (%rax),%eax
  804a40:	48 98                	cltq   
  804a42:	48 83 c0 20          	add    $0x20,%rax
  804a46:	48 39 c2             	cmp    %rax,%rdx
  804a49:	73 b1                	jae    8049fc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a4f:	8b 40 04             	mov    0x4(%rax),%eax
  804a52:	89 c2                	mov    %eax,%edx
  804a54:	c1 fa 1f             	sar    $0x1f,%edx
  804a57:	c1 ea 1b             	shr    $0x1b,%edx
  804a5a:	01 d0                	add    %edx,%eax
  804a5c:	83 e0 1f             	and    $0x1f,%eax
  804a5f:	29 d0                	sub    %edx,%eax
  804a61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a65:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804a69:	48 01 ca             	add    %rcx,%rdx
  804a6c:	0f b6 0a             	movzbl (%rdx),%ecx
  804a6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a73:	48 98                	cltq   
  804a75:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a7d:	8b 40 04             	mov    0x4(%rax),%eax
  804a80:	8d 50 01             	lea    0x1(%rax),%edx
  804a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a87:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804a8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a93:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804a97:	72 96                	jb     804a2f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804a9d:	c9                   	leaveq 
  804a9e:	c3                   	retq   

0000000000804a9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804a9f:	55                   	push   %rbp
  804aa0:	48 89 e5             	mov    %rsp,%rbp
  804aa3:	48 83 ec 20          	sub    $0x20,%rsp
  804aa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804aab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ab3:	48 89 c7             	mov    %rax,%rdi
  804ab6:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  804abd:	00 00 00 
  804ac0:	ff d0                	callq  *%rax
  804ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804ac6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804aca:	48 be 67 5b 80 00 00 	movabs $0x805b67,%rsi
  804ad1:	00 00 00 
  804ad4:	48 89 c7             	mov    %rax,%rdi
  804ad7:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  804ade:	00 00 00 
  804ae1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ae7:	8b 50 04             	mov    0x4(%rax),%edx
  804aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aee:	8b 00                	mov    (%rax),%eax
  804af0:	29 c2                	sub    %eax,%edx
  804af2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804af6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b00:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804b07:	00 00 00 
	stat->st_dev = &devpipe;
  804b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b0e:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804b15:	00 00 00 
  804b18:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b24:	c9                   	leaveq 
  804b25:	c3                   	retq   

0000000000804b26 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804b26:	55                   	push   %rbp
  804b27:	48 89 e5             	mov    %rsp,%rbp
  804b2a:	48 83 ec 10          	sub    $0x10,%rsp
  804b2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b36:	48 89 c6             	mov    %rax,%rsi
  804b39:	bf 00 00 00 00       	mov    $0x0,%edi
  804b3e:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  804b45:	00 00 00 
  804b48:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b4e:	48 89 c7             	mov    %rax,%rdi
  804b51:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  804b58:	00 00 00 
  804b5b:	ff d0                	callq  *%rax
  804b5d:	48 89 c6             	mov    %rax,%rsi
  804b60:	bf 00 00 00 00       	mov    $0x0,%edi
  804b65:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  804b6c:	00 00 00 
  804b6f:	ff d0                	callq  *%rax
}
  804b71:	c9                   	leaveq 
  804b72:	c3                   	retq   
	...

0000000000804b74 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804b74:	55                   	push   %rbp
  804b75:	48 89 e5             	mov    %rsp,%rbp
  804b78:	48 83 ec 20          	sub    $0x20,%rsp
  804b7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804b7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b83:	75 35                	jne    804bba <wait+0x46>
  804b85:	48 b9 6e 5b 80 00 00 	movabs $0x805b6e,%rcx
  804b8c:	00 00 00 
  804b8f:	48 ba 79 5b 80 00 00 	movabs $0x805b79,%rdx
  804b96:	00 00 00 
  804b99:	be 09 00 00 00       	mov    $0x9,%esi
  804b9e:	48 bf 8e 5b 80 00 00 	movabs $0x805b8e,%rdi
  804ba5:	00 00 00 
  804ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bad:	49 b8 78 03 80 00 00 	movabs $0x800378,%r8
  804bb4:	00 00 00 
  804bb7:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804bba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bbd:	48 98                	cltq   
  804bbf:	48 89 c2             	mov    %rax,%rdx
  804bc2:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804bc8:	48 89 d0             	mov    %rdx,%rax
  804bcb:	48 c1 e0 02          	shl    $0x2,%rax
  804bcf:	48 01 d0             	add    %rdx,%rax
  804bd2:	48 01 c0             	add    %rax,%rax
  804bd5:	48 01 d0             	add    %rdx,%rax
  804bd8:	48 c1 e0 05          	shl    $0x5,%rax
  804bdc:	48 89 c2             	mov    %rax,%rdx
  804bdf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804be6:	00 00 00 
  804be9:	48 01 d0             	add    %rdx,%rax
  804bec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804bf0:	eb 0c                	jmp    804bfe <wait+0x8a>
		sys_yield();
  804bf2:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  804bf9:	00 00 00 
  804bfc:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c02:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804c08:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c0b:	75 0e                	jne    804c1b <wait+0xa7>
  804c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c11:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804c17:	85 c0                	test   %eax,%eax
  804c19:	75 d7                	jne    804bf2 <wait+0x7e>
		sys_yield();
}
  804c1b:	c9                   	leaveq 
  804c1c:	c3                   	retq   
  804c1d:	00 00                	add    %al,(%rax)
	...

0000000000804c20 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804c20:	55                   	push   %rbp
  804c21:	48 89 e5             	mov    %rsp,%rbp
  804c24:	48 83 ec 20          	sub    $0x20,%rsp
  804c28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804c2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c2e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804c31:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804c35:	be 01 00 00 00       	mov    $0x1,%esi
  804c3a:	48 89 c7             	mov    %rax,%rdi
  804c3d:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  804c44:	00 00 00 
  804c47:	ff d0                	callq  *%rax
}
  804c49:	c9                   	leaveq 
  804c4a:	c3                   	retq   

0000000000804c4b <getchar>:

int
getchar(void)
{
  804c4b:	55                   	push   %rbp
  804c4c:	48 89 e5             	mov    %rsp,%rbp
  804c4f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804c53:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804c57:	ba 01 00 00 00       	mov    $0x1,%edx
  804c5c:	48 89 c6             	mov    %rax,%rsi
  804c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  804c64:	48 b8 88 2a 80 00 00 	movabs $0x802a88,%rax
  804c6b:	00 00 00 
  804c6e:	ff d0                	callq  *%rax
  804c70:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804c73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c77:	79 05                	jns    804c7e <getchar+0x33>
		return r;
  804c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c7c:	eb 14                	jmp    804c92 <getchar+0x47>
	if (r < 1)
  804c7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c82:	7f 07                	jg     804c8b <getchar+0x40>
		return -E_EOF;
  804c84:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804c89:	eb 07                	jmp    804c92 <getchar+0x47>
	return c;
  804c8b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804c8f:	0f b6 c0             	movzbl %al,%eax
}
  804c92:	c9                   	leaveq 
  804c93:	c3                   	retq   

0000000000804c94 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804c94:	55                   	push   %rbp
  804c95:	48 89 e5             	mov    %rsp,%rbp
  804c98:	48 83 ec 20          	sub    $0x20,%rsp
  804c9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804c9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804ca3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ca6:	48 89 d6             	mov    %rdx,%rsi
  804ca9:	89 c7                	mov    %eax,%edi
  804cab:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  804cb2:	00 00 00 
  804cb5:	ff d0                	callq  *%rax
  804cb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804cba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cbe:	79 05                	jns    804cc5 <iscons+0x31>
		return r;
  804cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cc3:	eb 1a                	jmp    804cdf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cc9:	8b 10                	mov    (%rax),%edx
  804ccb:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804cd2:	00 00 00 
  804cd5:	8b 00                	mov    (%rax),%eax
  804cd7:	39 c2                	cmp    %eax,%edx
  804cd9:	0f 94 c0             	sete   %al
  804cdc:	0f b6 c0             	movzbl %al,%eax
}
  804cdf:	c9                   	leaveq 
  804ce0:	c3                   	retq   

0000000000804ce1 <opencons>:

int
opencons(void)
{
  804ce1:	55                   	push   %rbp
  804ce2:	48 89 e5             	mov    %rsp,%rbp
  804ce5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804ce9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804ced:	48 89 c7             	mov    %rax,%rdi
  804cf0:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  804cf7:	00 00 00 
  804cfa:	ff d0                	callq  *%rax
  804cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d03:	79 05                	jns    804d0a <opencons+0x29>
		return r;
  804d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d08:	eb 5b                	jmp    804d65 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d0e:	ba 07 04 00 00       	mov    $0x407,%edx
  804d13:	48 89 c6             	mov    %rax,%rsi
  804d16:	bf 00 00 00 00       	mov    $0x0,%edi
  804d1b:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  804d22:	00 00 00 
  804d25:	ff d0                	callq  *%rax
  804d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d2e:	79 05                	jns    804d35 <opencons+0x54>
		return r;
  804d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d33:	eb 30                	jmp    804d65 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d39:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804d40:	00 00 00 
  804d43:	8b 12                	mov    (%rdx),%edx
  804d45:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d4b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d56:	48 89 c7             	mov    %rax,%rdi
  804d59:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  804d60:	00 00 00 
  804d63:	ff d0                	callq  *%rax
}
  804d65:	c9                   	leaveq 
  804d66:	c3                   	retq   

0000000000804d67 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804d67:	55                   	push   %rbp
  804d68:	48 89 e5             	mov    %rsp,%rbp
  804d6b:	48 83 ec 30          	sub    $0x30,%rsp
  804d6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804d77:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804d7b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d80:	75 13                	jne    804d95 <devcons_read+0x2e>
		return 0;
  804d82:	b8 00 00 00 00       	mov    $0x0,%eax
  804d87:	eb 49                	jmp    804dd2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804d89:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  804d90:	00 00 00 
  804d93:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804d95:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  804d9c:	00 00 00 
  804d9f:	ff d0                	callq  *%rax
  804da1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804da8:	74 df                	je     804d89 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dae:	79 05                	jns    804db5 <devcons_read+0x4e>
		return c;
  804db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804db3:	eb 1d                	jmp    804dd2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804db5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804db9:	75 07                	jne    804dc2 <devcons_read+0x5b>
		return 0;
  804dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  804dc0:	eb 10                	jmp    804dd2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dc5:	89 c2                	mov    %eax,%edx
  804dc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804dcb:	88 10                	mov    %dl,(%rax)
	return 1;
  804dcd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804dd2:	c9                   	leaveq 
  804dd3:	c3                   	retq   

0000000000804dd4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804dd4:	55                   	push   %rbp
  804dd5:	48 89 e5             	mov    %rsp,%rbp
  804dd8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804ddf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804de6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804ded:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804df4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804dfb:	eb 77                	jmp    804e74 <devcons_write+0xa0>
		m = n - tot;
  804dfd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804e04:	89 c2                	mov    %eax,%edx
  804e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e09:	89 d1                	mov    %edx,%ecx
  804e0b:	29 c1                	sub    %eax,%ecx
  804e0d:	89 c8                	mov    %ecx,%eax
  804e0f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804e12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e15:	83 f8 7f             	cmp    $0x7f,%eax
  804e18:	76 07                	jbe    804e21 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804e1a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804e21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e24:	48 63 d0             	movslq %eax,%rdx
  804e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e2a:	48 98                	cltq   
  804e2c:	48 89 c1             	mov    %rax,%rcx
  804e2f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804e36:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e3d:	48 89 ce             	mov    %rcx,%rsi
  804e40:	48 89 c7             	mov    %rax,%rdi
  804e43:	48 b8 a6 14 80 00 00 	movabs $0x8014a6,%rax
  804e4a:	00 00 00 
  804e4d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804e4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e52:	48 63 d0             	movslq %eax,%rdx
  804e55:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e5c:	48 89 d6             	mov    %rdx,%rsi
  804e5f:	48 89 c7             	mov    %rax,%rdi
  804e62:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  804e69:	00 00 00 
  804e6c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804e6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e71:	01 45 fc             	add    %eax,-0x4(%rbp)
  804e74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e77:	48 98                	cltq   
  804e79:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804e80:	0f 82 77 ff ff ff    	jb     804dfd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804e89:	c9                   	leaveq 
  804e8a:	c3                   	retq   

0000000000804e8b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804e8b:	55                   	push   %rbp
  804e8c:	48 89 e5             	mov    %rsp,%rbp
  804e8f:	48 83 ec 08          	sub    $0x8,%rsp
  804e93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e9c:	c9                   	leaveq 
  804e9d:	c3                   	retq   

0000000000804e9e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804e9e:	55                   	push   %rbp
  804e9f:	48 89 e5             	mov    %rsp,%rbp
  804ea2:	48 83 ec 10          	sub    $0x10,%rsp
  804ea6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804eaa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eb2:	48 be 9e 5b 80 00 00 	movabs $0x805b9e,%rsi
  804eb9:	00 00 00 
  804ebc:	48 89 c7             	mov    %rax,%rdi
  804ebf:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  804ec6:	00 00 00 
  804ec9:	ff d0                	callq  *%rax
	return 0;
  804ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ed0:	c9                   	leaveq 
  804ed1:	c3                   	retq   
	...

0000000000804ed4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804ed4:	55                   	push   %rbp
  804ed5:	48 89 e5             	mov    %rsp,%rbp
  804ed8:	48 83 ec 10          	sub    $0x10,%rsp
  804edc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804ee0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ee7:	00 00 00 
  804eea:	48 8b 00             	mov    (%rax),%rax
  804eed:	48 85 c0             	test   %rax,%rax
  804ef0:	75 66                	jne    804f58 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  804ef2:	ba 07 00 00 00       	mov    $0x7,%edx
  804ef7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804efc:	bf 00 00 00 00       	mov    $0x0,%edi
  804f01:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  804f08:	00 00 00 
  804f0b:	ff d0                	callq  *%rax
  804f0d:	85 c0                	test   %eax,%eax
  804f0f:	75 1d                	jne    804f2e <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804f11:	48 be 6c 4f 80 00 00 	movabs $0x804f6c,%rsi
  804f18:	00 00 00 
  804f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  804f20:	48 b8 46 1c 80 00 00 	movabs $0x801c46,%rax
  804f27:	00 00 00 
  804f2a:	ff d0                	callq  *%rax
  804f2c:	eb 2a                	jmp    804f58 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  804f2e:	48 ba a5 5b 80 00 00 	movabs $0x805ba5,%rdx
  804f35:	00 00 00 
  804f38:	be 23 00 00 00       	mov    $0x23,%esi
  804f3d:	48 bf c3 5b 80 00 00 	movabs $0x805bc3,%rdi
  804f44:	00 00 00 
  804f47:	b8 00 00 00 00       	mov    $0x0,%eax
  804f4c:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  804f53:	00 00 00 
  804f56:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804f58:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804f5f:	00 00 00 
  804f62:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804f66:	48 89 10             	mov    %rdx,(%rax)
}
  804f69:	c9                   	leaveq 
  804f6a:	c3                   	retq   
	...

0000000000804f6c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804f6c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804f6f:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804f76:	00 00 00 
call *%rax
  804f79:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804f7b:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  804f7f:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804f84:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804f8b:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804f8c:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804f90:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  804f93:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804f9a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804f9b:	4c 8b 3c 24          	mov    (%rsp),%r15
  804f9f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804fa4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804fa9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804fae:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804fb3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804fb8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804fbd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804fc2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804fc7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804fcc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804fd1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804fd6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804fdb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804fe0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804fe5:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  804fe9:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804fed:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  804fee:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  804fef:	c3                   	retq   

0000000000804ff0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804ff0:	55                   	push   %rbp
  804ff1:	48 89 e5             	mov    %rsp,%rbp
  804ff4:	48 83 ec 30          	sub    $0x30,%rsp
  804ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ffc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  805004:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80500b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805010:	74 18                	je     80502a <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  805012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805016:	48 89 c7             	mov    %rax,%rdi
  805019:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  805020:	00 00 00 
  805023:	ff d0                	callq  *%rax
  805025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805028:	eb 19                	jmp    805043 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80502a:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  805031:	00 00 00 
  805034:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  80503b:	00 00 00 
  80503e:	ff d0                	callq  *%rax
  805040:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  805043:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805047:	79 39                	jns    805082 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  805049:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80504e:	75 08                	jne    805058 <ipc_recv+0x68>
  805050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805054:	8b 00                	mov    (%rax),%eax
  805056:	eb 05                	jmp    80505d <ipc_recv+0x6d>
  805058:	b8 00 00 00 00       	mov    $0x0,%eax
  80505d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805061:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  805063:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805068:	75 08                	jne    805072 <ipc_recv+0x82>
  80506a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80506e:	8b 00                	mov    (%rax),%eax
  805070:	eb 05                	jmp    805077 <ipc_recv+0x87>
  805072:	b8 00 00 00 00       	mov    $0x0,%eax
  805077:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80507b:	89 02                	mov    %eax,(%rdx)
		return r;
  80507d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805080:	eb 53                	jmp    8050d5 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  805082:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805087:	74 19                	je     8050a2 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  805089:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805090:	00 00 00 
  805093:	48 8b 00             	mov    (%rax),%rax
  805096:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80509c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050a0:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  8050a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8050a7:	74 19                	je     8050c2 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  8050a9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8050b0:	00 00 00 
  8050b3:	48 8b 00             	mov    (%rax),%rax
  8050b6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8050bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050c0:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  8050c2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8050c9:	00 00 00 
  8050cc:	48 8b 00             	mov    (%rax),%rax
  8050cf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8050d5:	c9                   	leaveq 
  8050d6:	c3                   	retq   

00000000008050d7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8050d7:	55                   	push   %rbp
  8050d8:	48 89 e5             	mov    %rsp,%rbp
  8050db:	48 83 ec 30          	sub    $0x30,%rsp
  8050df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8050e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8050e5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8050e9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8050ec:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8050f3:	eb 59                	jmp    80514e <ipc_send+0x77>
		if(pg) {
  8050f5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8050fa:	74 20                	je     80511c <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8050fc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8050ff:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805102:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805106:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805109:	89 c7                	mov    %eax,%edi
  80510b:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  805112:	00 00 00 
  805115:	ff d0                	callq  *%rax
  805117:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80511a:	eb 26                	jmp    805142 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  80511c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80511f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805122:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805125:	89 d1                	mov    %edx,%ecx
  805127:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80512e:	00 00 00 
  805131:	89 c7                	mov    %eax,%edi
  805133:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  80513a:	00 00 00 
  80513d:	ff d0                	callq  *%rax
  80513f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  805142:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  805149:	00 00 00 
  80514c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  80514e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805152:	74 a1                	je     8050f5 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  805154:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805158:	74 2a                	je     805184 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  80515a:	48 ba d8 5b 80 00 00 	movabs $0x805bd8,%rdx
  805161:	00 00 00 
  805164:	be 49 00 00 00       	mov    $0x49,%esi
  805169:	48 bf 03 5c 80 00 00 	movabs $0x805c03,%rdi
  805170:	00 00 00 
  805173:	b8 00 00 00 00       	mov    $0x0,%eax
  805178:	48 b9 78 03 80 00 00 	movabs $0x800378,%rcx
  80517f:	00 00 00 
  805182:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  805184:	c9                   	leaveq 
  805185:	c3                   	retq   

0000000000805186 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805186:	55                   	push   %rbp
  805187:	48 89 e5             	mov    %rsp,%rbp
  80518a:	48 83 ec 18          	sub    $0x18,%rsp
  80518e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805198:	eb 6a                	jmp    805204 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80519a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8051a1:	00 00 00 
  8051a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a7:	48 63 d0             	movslq %eax,%rdx
  8051aa:	48 89 d0             	mov    %rdx,%rax
  8051ad:	48 c1 e0 02          	shl    $0x2,%rax
  8051b1:	48 01 d0             	add    %rdx,%rax
  8051b4:	48 01 c0             	add    %rax,%rax
  8051b7:	48 01 d0             	add    %rdx,%rax
  8051ba:	48 c1 e0 05          	shl    $0x5,%rax
  8051be:	48 01 c8             	add    %rcx,%rax
  8051c1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8051c7:	8b 00                	mov    (%rax),%eax
  8051c9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8051cc:	75 32                	jne    805200 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8051ce:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8051d5:	00 00 00 
  8051d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051db:	48 63 d0             	movslq %eax,%rdx
  8051de:	48 89 d0             	mov    %rdx,%rax
  8051e1:	48 c1 e0 02          	shl    $0x2,%rax
  8051e5:	48 01 d0             	add    %rdx,%rax
  8051e8:	48 01 c0             	add    %rax,%rax
  8051eb:	48 01 d0             	add    %rdx,%rax
  8051ee:	48 c1 e0 05          	shl    $0x5,%rax
  8051f2:	48 01 c8             	add    %rcx,%rax
  8051f5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8051fb:	8b 40 08             	mov    0x8(%rax),%eax
  8051fe:	eb 12                	jmp    805212 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805200:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805204:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80520b:	7e 8d                	jle    80519a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80520d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805212:	c9                   	leaveq 
  805213:	c3                   	retq   

0000000000805214 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805214:	55                   	push   %rbp
  805215:	48 89 e5             	mov    %rsp,%rbp
  805218:	48 83 ec 18          	sub    $0x18,%rsp
  80521c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805224:	48 89 c2             	mov    %rax,%rdx
  805227:	48 c1 ea 15          	shr    $0x15,%rdx
  80522b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805232:	01 00 00 
  805235:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805239:	83 e0 01             	and    $0x1,%eax
  80523c:	48 85 c0             	test   %rax,%rax
  80523f:	75 07                	jne    805248 <pageref+0x34>
		return 0;
  805241:	b8 00 00 00 00       	mov    $0x0,%eax
  805246:	eb 53                	jmp    80529b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80524c:	48 89 c2             	mov    %rax,%rdx
  80524f:	48 c1 ea 0c          	shr    $0xc,%rdx
  805253:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80525a:	01 00 00 
  80525d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805261:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805269:	83 e0 01             	and    $0x1,%eax
  80526c:	48 85 c0             	test   %rax,%rax
  80526f:	75 07                	jne    805278 <pageref+0x64>
		return 0;
  805271:	b8 00 00 00 00       	mov    $0x0,%eax
  805276:	eb 23                	jmp    80529b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527c:	48 89 c2             	mov    %rax,%rdx
  80527f:	48 c1 ea 0c          	shr    $0xc,%rdx
  805283:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80528a:	00 00 00 
  80528d:	48 c1 e2 04          	shl    $0x4,%rdx
  805291:	48 01 d0             	add    %rdx,%rax
  805294:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805298:	0f b7 c0             	movzwl %ax,%eax
}
  80529b:	c9                   	leaveq 
  80529c:	c3                   	retq   
