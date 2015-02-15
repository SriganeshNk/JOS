
obj/user/testfdsharing.debug:     file format elf64-x86-64


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
  80003c:	e8 fb 02 00 00       	callq  80033c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800053:	be 00 00 00 00       	mov    $0x0,%esi
  800058:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  80005f:	00 00 00 
  800062:	48 b8 f7 2f 80 00 00 	movabs $0x802ff7,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
  80006e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800075:	79 30                	jns    8000a7 <umain+0x63>
		panic("open motd: %e", fd);
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	89 c1                	mov    %eax,%ecx
  80007c:	48 ba 45 47 80 00 00 	movabs $0x804745,%rdx
  800083:	00 00 00 
  800086:	be 0c 00 00 00       	mov    $0xc,%esi
  80008b:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  800092:	00 00 00 
  800095:	b8 00 00 00 00       	mov    $0x0,%eax
  80009a:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8000a1:	00 00 00 
  8000a4:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000aa:	be 00 00 00 00       	mov    $0x0,%esi
  8000af:	89 c7                	mov    %eax,%edi
  8000b1:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  8000b8:	00 00 00 
  8000bb:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c0:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c5:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cc:	00 00 00 
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 f1 2b 80 00 00 	movabs $0x802bf1,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax
  8000dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e4:	7f 30                	jg     800116 <umain+0xd2>
		panic("readn: %e", n);
  8000e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e9:	89 c1                	mov    %eax,%ecx
  8000eb:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8000f2:	00 00 00 
  8000f5:	be 0f 00 00 00       	mov    $0xf,%esi
  8000fa:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  800101:	00 00 00 
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  800110:	00 00 00 
  800113:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800116:	48 b8 62 22 80 00 00 	movabs $0x802262,%rax
  80011d:	00 00 00 
  800120:	ff d0                	callq  *%rax
  800122:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800125:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800129:	79 30                	jns    80015b <umain+0x117>
		panic("fork: %e", r);
  80012b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012e:	89 c1                	mov    %eax,%ecx
  800130:	48 ba 72 47 80 00 00 	movabs $0x804772,%rdx
  800137:	00 00 00 
  80013a:	be 12 00 00 00       	mov    $0x12,%esi
  80013f:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  800146:	00 00 00 
  800149:	b8 00 00 00 00       	mov    $0x0,%eax
  80014e:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  800155:	00 00 00 
  800158:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015f:	0f 85 36 01 00 00    	jne    80029b <umain+0x257>
		seek(fd, 0);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	be 00 00 00 00       	mov    $0x0,%esi
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  800176:	00 00 00 
  800179:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017b:	48 bf 80 47 80 00 00 	movabs $0x804780,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 43 06 80 00 00 	movabs $0x800643,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800199:	ba 00 02 00 00       	mov    $0x200,%edx
  80019e:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a5:	00 00 00 
  8001a8:	89 c7                	mov    %eax,%edi
  8001aa:	48 b8 f1 2b 80 00 00 	movabs $0x802bf1,%rax
  8001b1:	00 00 00 
  8001b4:	ff d0                	callq  *%rax
  8001b6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bc:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001bf:	74 36                	je     8001f7 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c7:	41 89 d0             	mov    %edx,%r8d
  8001ca:	89 c1                	mov    %eax,%ecx
  8001cc:	48 ba c8 47 80 00 00 	movabs $0x8047c8,%rdx
  8001d3:	00 00 00 
  8001d6:	be 17 00 00 00       	mov    $0x17,%esi
  8001db:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  8001e2:	00 00 00 
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	49 b9 08 04 80 00 00 	movabs $0x800408,%r9
  8001f1:	00 00 00 
  8001f4:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001fa:	48 98                	cltq   
  8001fc:	48 89 c2             	mov    %rax,%rdx
  8001ff:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800206:	00 00 00 
  800209:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  800210:	00 00 00 
  800213:	48 b8 81 16 80 00 00 	movabs $0x801681,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
  80021f:	85 c0                	test   %eax,%eax
  800221:	74 2a                	je     80024d <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800223:	48 ba f8 47 80 00 00 	movabs $0x8047f8,%rdx
  80022a:	00 00 00 
  80022d:	be 19 00 00 00       	mov    $0x19,%esi
  800232:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  800239:	00 00 00 
  80023c:	b8 00 00 00 00       	mov    $0x0,%eax
  800241:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  800248:	00 00 00 
  80024b:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024d:	48 bf 2e 48 80 00 00 	movabs $0x80482e,%rdi
  800254:	00 00 00 
  800257:	b8 00 00 00 00       	mov    $0x0,%eax
  80025c:	48 ba 43 06 80 00 00 	movabs $0x800643,%rdx
  800263:	00 00 00 
  800266:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	89 c7                	mov    %eax,%edi
  800272:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  800279:	00 00 00 
  80027c:	ff d0                	callq  *%rax
		close(fd);
  80027e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800281:	89 c7                	mov    %eax,%edi
  800283:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  80028a:	00 00 00 
  80028d:	ff d0                	callq  *%rax
		exit();
  80028f:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
	}
	wait(r);
  80029b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029e:	89 c7                	mov    %eax,%edi
  8002a0:	48 b8 fc 3f 80 00 00 	movabs $0x803ffc,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002af:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b4:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002bb:	00 00 00 
  8002be:	89 c7                	mov    %eax,%edi
  8002c0:	48 b8 f1 2b 80 00 00 	movabs $0x802bf1,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax
  8002cc:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002cf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d2:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d5:	74 36                	je     80030d <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d7:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dd:	41 89 d0             	mov    %edx,%r8d
  8002e0:	89 c1                	mov    %eax,%ecx
  8002e2:	48 ba 48 48 80 00 00 	movabs $0x804848,%rdx
  8002e9:	00 00 00 
  8002ec:	be 21 00 00 00       	mov    $0x21,%esi
  8002f1:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  8002f8:	00 00 00 
  8002fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800300:	49 b9 08 04 80 00 00 	movabs $0x800408,%r9
  800307:	00 00 00 
  80030a:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030d:	48 bf 6b 48 80 00 00 	movabs $0x80486b,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	48 ba 43 06 80 00 00 	movabs $0x800643,%rdx
  800323:	00 00 00 
  800326:	ff d2                	callq  *%rdx
	close(fd);
  800328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032b:	89 c7                	mov    %eax,%edi
  80032d:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  800334:	00 00 00 
  800337:	ff d0                	callq  *%rax


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800339:	cc                   	int3   

	breakpoint();
}
  80033a:	c9                   	leaveq 
  80033b:	c3                   	retq   

000000000080033c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 10          	sub    $0x10,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80034b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800352:	00 00 00 
  800355:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80035c:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
  800368:	48 98                	cltq   
  80036a:	48 89 c2             	mov    %rax,%rdx
  80036d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800373:	48 89 d0             	mov    %rdx,%rax
  800376:	48 c1 e0 02          	shl    $0x2,%rax
  80037a:	48 01 d0             	add    %rdx,%rax
  80037d:	48 01 c0             	add    %rax,%rax
  800380:	48 01 d0             	add    %rdx,%rax
  800383:	48 c1 e0 05          	shl    $0x5,%rax
  800387:	48 89 c2             	mov    %rax,%rdx
  80038a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800391:	00 00 00 
  800394:	48 01 c2             	add    %rax,%rdx
  800397:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80039e:	00 00 00 
  8003a1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a8:	7e 14                	jle    8003be <libmain+0x82>
		binaryname = argv[0];
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	48 8b 10             	mov    (%rax),%rdx
  8003b1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b8:	00 00 00 
  8003bb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c5:	48 89 d6             	mov    %rdx,%rsi
  8003c8:	89 c7                	mov    %eax,%edi
  8003ca:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003d6:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  8003dd:	00 00 00 
  8003e0:	ff d0                	callq  *%rax
}
  8003e2:	c9                   	leaveq 
  8003e3:	c3                   	retq   

00000000008003e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e8:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f9:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
}
  800405:	5d                   	pop    %rbp
  800406:	c3                   	retq   
	...

0000000000800408 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	53                   	push   %rbx
  80040d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800414:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80041b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800421:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800428:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80042f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800436:	84 c0                	test   %al,%al
  800438:	74 23                	je     80045d <_panic+0x55>
  80043a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800441:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800445:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800449:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80044d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800451:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800455:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800459:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80045d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800464:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80046b:	00 00 00 
  80046e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800475:	00 00 00 
  800478:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80047c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800483:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80048a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800491:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800498:	00 00 00 
  80049b:	48 8b 18             	mov    (%rax),%rbx
  80049e:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8004a5:	00 00 00 
  8004a8:	ff d0                	callq  *%rax
  8004aa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004b7:	41 89 c8             	mov    %ecx,%r8d
  8004ba:	48 89 d1             	mov    %rdx,%rcx
  8004bd:	48 89 da             	mov    %rbx,%rdx
  8004c0:	89 c6                	mov    %eax,%esi
  8004c2:	48 bf 90 48 80 00 00 	movabs $0x804890,%rdi
  8004c9:	00 00 00 
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	49 b9 43 06 80 00 00 	movabs $0x800643,%r9
  8004d8:	00 00 00 
  8004db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ec:	48 89 d6             	mov    %rdx,%rsi
  8004ef:	48 89 c7             	mov    %rax,%rdi
  8004f2:	48 b8 97 05 80 00 00 	movabs $0x800597,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8004fe:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  800505:	00 00 00 
  800508:	b8 00 00 00 00       	mov    $0x0,%eax
  80050d:	48 ba 43 06 80 00 00 	movabs $0x800643,%rdx
  800514:	00 00 00 
  800517:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800519:	cc                   	int3   
  80051a:	eb fd                	jmp    800519 <_panic+0x111>

000000000080051c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	48 83 ec 10          	sub    $0x10,%rsp
  800524:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800527:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80052b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052f:	8b 00                	mov    (%rax),%eax
  800531:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800534:	89 d6                	mov    %edx,%esi
  800536:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80053a:	48 63 d0             	movslq %eax,%rdx
  80053d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800542:	8d 50 01             	lea    0x1(%rax),%edx
  800545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800549:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80054b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	3d ff 00 00 00       	cmp    $0xff,%eax
  800556:	75 2c                	jne    800584 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055c:	8b 00                	mov    (%rax),%eax
  80055e:	48 98                	cltq   
  800560:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800564:	48 83 c2 08          	add    $0x8,%rdx
  800568:	48 89 c6             	mov    %rax,%rsi
  80056b:	48 89 d7             	mov    %rdx,%rdi
  80056e:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  800575:	00 00 00 
  800578:	ff d0                	callq  *%rax
        b->idx = 0;
  80057a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800588:	8b 40 04             	mov    0x4(%rax),%eax
  80058b:	8d 50 01             	lea    0x1(%rax),%edx
  80058e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800592:	89 50 04             	mov    %edx,0x4(%rax)
}
  800595:	c9                   	leaveq 
  800596:	c3                   	retq   

0000000000800597 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800597:	55                   	push   %rbp
  800598:	48 89 e5             	mov    %rsp,%rbp
  80059b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005be:	48 8b 0a             	mov    (%rdx),%rcx
  8005c1:	48 89 08             	mov    %rcx,(%rax)
  8005c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005db:	00 00 00 
    b.cnt = 0;
  8005de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005fd:	48 89 c6             	mov    %rax,%rsi
  800600:	48 bf 1c 05 80 00 00 	movabs $0x80051c,%rdi
  800607:	00 00 00 
  80060a:	48 b8 f4 09 80 00 00 	movabs $0x8009f4,%rax
  800611:	00 00 00 
  800614:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800616:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80061c:	48 98                	cltq   
  80061e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800625:	48 83 c2 08          	add    $0x8,%rdx
  800629:	48 89 c6             	mov    %rax,%rsi
  80062c:	48 89 d7             	mov    %rdx,%rdi
  80062f:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  800636:	00 00 00 
  800639:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80063b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800641:	c9                   	leaveq 
  800642:	c3                   	retq   

0000000000800643 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800643:	55                   	push   %rbp
  800644:	48 89 e5             	mov    %rsp,%rbp
  800647:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800655:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80065c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800663:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80066a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800671:	84 c0                	test   %al,%al
  800673:	74 20                	je     800695 <cprintf+0x52>
  800675:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800679:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80067d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800681:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800685:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800689:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80068d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800691:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800695:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80069c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a3:	00 00 00 
  8006a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ad:	00 00 00 
  8006b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d7:	48 8b 0a             	mov    (%rdx),%rcx
  8006da:	48 89 08             	mov    %rcx,(%rax)
  8006dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006fb:	48 89 d6             	mov    %rdx,%rsi
  8006fe:	48 89 c7             	mov    %rax,%rdi
  800701:	48 b8 97 05 80 00 00 	movabs $0x800597,%rax
  800708:	00 00 00 
  80070b:	ff d0                	callq  *%rax
  80070d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800713:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800719:	c9                   	leaveq 
  80071a:	c3                   	retq   
	...

000000000080071c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071c:	55                   	push   %rbp
  80071d:	48 89 e5             	mov    %rsp,%rbp
  800720:	48 83 ec 30          	sub    $0x30,%rsp
  800724:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800728:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80072c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800730:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800733:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800737:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80073b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80073e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800742:	77 52                	ja     800796 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800744:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800747:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80074b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80074e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	ba 00 00 00 00       	mov    $0x0,%edx
  80075b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80075f:	48 89 c2             	mov    %rax,%rdx
  800762:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800765:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800768:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80076c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800770:	41 89 f9             	mov    %edi,%r9d
  800773:	48 89 c7             	mov    %rax,%rdi
  800776:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  80077d:	00 00 00 
  800780:	ff d0                	callq  *%rax
  800782:	eb 1c                	jmp    8007a0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800784:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800788:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80078b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80078f:	48 89 d6             	mov    %rdx,%rsi
  800792:	89 c7                	mov    %eax,%edi
  800794:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800796:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80079a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80079e:	7f e4                	jg     800784 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	48 f7 f1             	div    %rcx
  8007af:	48 89 d0             	mov    %rdx,%rax
  8007b2:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  8007b9:	00 00 00 
  8007bc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007c0:	0f be c0             	movsbl %al,%eax
  8007c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007c7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007cb:	48 89 d6             	mov    %rdx,%rsi
  8007ce:	89 c7                	mov    %eax,%edi
  8007d0:	ff d1                	callq  *%rcx
}
  8007d2:	c9                   	leaveq 
  8007d3:	c3                   	retq   

00000000008007d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d4:	55                   	push   %rbp
  8007d5:	48 89 e5             	mov    %rsp,%rbp
  8007d8:	48 83 ec 20          	sub    $0x20,%rsp
  8007dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e7:	7e 52                	jle    80083b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	83 f8 30             	cmp    $0x30,%eax
  8007f2:	73 24                	jae    800818 <getuint+0x44>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	8b 00                	mov    (%rax),%eax
  800802:	89 c0                	mov    %eax,%eax
  800804:	48 01 d0             	add    %rdx,%rax
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	8b 12                	mov    (%rdx),%edx
  80080d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	89 0a                	mov    %ecx,(%rdx)
  800816:	eb 17                	jmp    80082f <getuint+0x5b>
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800820:	48 89 d0             	mov    %rdx,%rax
  800823:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082f:	48 8b 00             	mov    (%rax),%rax
  800832:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800836:	e9 a3 00 00 00       	jmpq   8008de <getuint+0x10a>
	else if (lflag)
  80083b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083f:	74 4f                	je     800890 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	8b 00                	mov    (%rax),%eax
  800847:	83 f8 30             	cmp    $0x30,%eax
  80084a:	73 24                	jae    800870 <getuint+0x9c>
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	8b 00                	mov    (%rax),%eax
  80085a:	89 c0                	mov    %eax,%eax
  80085c:	48 01 d0             	add    %rdx,%rax
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	8b 12                	mov    (%rdx),%edx
  800865:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800868:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086c:	89 0a                	mov    %ecx,(%rdx)
  80086e:	eb 17                	jmp    800887 <getuint+0xb3>
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800878:	48 89 d0             	mov    %rdx,%rax
  80087b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800887:	48 8b 00             	mov    (%rax),%rax
  80088a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088e:	eb 4e                	jmp    8008de <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	83 f8 30             	cmp    $0x30,%eax
  800899:	73 24                	jae    8008bf <getuint+0xeb>
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 01 d0             	add    %rdx,%rax
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	8b 12                	mov    (%rdx),%edx
  8008b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	89 0a                	mov    %ecx,(%rdx)
  8008bd:	eb 17                	jmp    8008d6 <getuint+0x102>
  8008bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c7:	48 89 d0             	mov    %rdx,%rax
  8008ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	89 c0                	mov    %eax,%eax
  8008da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e2:	c9                   	leaveq 
  8008e3:	c3                   	retq   

00000000008008e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	48 83 ec 20          	sub    $0x20,%rsp
  8008ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f7:	7e 52                	jle    80094b <getint+0x67>
		x=va_arg(*ap, long long);
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	83 f8 30             	cmp    $0x30,%eax
  800902:	73 24                	jae    800928 <getint+0x44>
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	8b 00                	mov    (%rax),%eax
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091b:	8b 12                	mov    (%rdx),%edx
  80091d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800920:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800924:	89 0a                	mov    %ecx,(%rdx)
  800926:	eb 17                	jmp    80093f <getint+0x5b>
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800930:	48 89 d0             	mov    %rdx,%rax
  800933:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800937:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093f:	48 8b 00             	mov    (%rax),%rax
  800942:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800946:	e9 a3 00 00 00       	jmpq   8009ee <getint+0x10a>
	else if (lflag)
  80094b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094f:	74 4f                	je     8009a0 <getint+0xbc>
		x=va_arg(*ap, long);
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	8b 00                	mov    (%rax),%eax
  800957:	83 f8 30             	cmp    $0x30,%eax
  80095a:	73 24                	jae    800980 <getint+0x9c>
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	8b 00                	mov    (%rax),%eax
  80096a:	89 c0                	mov    %eax,%eax
  80096c:	48 01 d0             	add    %rdx,%rax
  80096f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800973:	8b 12                	mov    (%rdx),%edx
  800975:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800978:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097c:	89 0a                	mov    %ecx,(%rdx)
  80097e:	eb 17                	jmp    800997 <getint+0xb3>
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800988:	48 89 d0             	mov    %rdx,%rax
  80098b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800997:	48 8b 00             	mov    (%rax),%rax
  80099a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099e:	eb 4e                	jmp    8009ee <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	8b 00                	mov    (%rax),%eax
  8009a6:	83 f8 30             	cmp    $0x30,%eax
  8009a9:	73 24                	jae    8009cf <getint+0xeb>
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	89 c0                	mov    %eax,%eax
  8009bb:	48 01 d0             	add    %rdx,%rax
  8009be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c2:	8b 12                	mov    (%rdx),%edx
  8009c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	89 0a                	mov    %ecx,(%rdx)
  8009cd:	eb 17                	jmp    8009e6 <getint+0x102>
  8009cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d7:	48 89 d0             	mov    %rdx,%rax
  8009da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e6:	8b 00                	mov    (%rax),%eax
  8009e8:	48 98                	cltq   
  8009ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f2:	c9                   	leaveq 
  8009f3:	c3                   	retq   

00000000008009f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f4:	55                   	push   %rbp
  8009f5:	48 89 e5             	mov    %rsp,%rbp
  8009f8:	41 54                	push   %r12
  8009fa:	53                   	push   %rbx
  8009fb:	48 83 ec 60          	sub    $0x60,%rsp
  8009ff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a03:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a07:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a13:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a17:	48 8b 0a             	mov    (%rdx),%rcx
  800a1a:	48 89 08             	mov    %rcx,(%rax)
  800a1d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a21:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a25:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a29:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2d:	eb 17                	jmp    800a46 <vprintfmt+0x52>
			if (ch == '\0')
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	0f 84 ea 04 00 00    	je     800f21 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800a37:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a3b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a3f:	48 89 c6             	mov    %rax,%rsi
  800a42:	89 df                	mov    %ebx,%edi
  800a44:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a46:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a4a:	0f b6 00             	movzbl (%rax),%eax
  800a4d:	0f b6 d8             	movzbl %al,%ebx
  800a50:	83 fb 25             	cmp    $0x25,%ebx
  800a53:	0f 95 c0             	setne  %al
  800a56:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a5b:	84 c0                	test   %al,%al
  800a5d:	75 d0                	jne    800a2f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a63:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a6a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a78:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800a7f:	eb 04                	jmp    800a85 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a81:	90                   	nop
  800a82:	eb 01                	jmp    800a85 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a84:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a89:	0f b6 00             	movzbl (%rax),%eax
  800a8c:	0f b6 d8             	movzbl %al,%ebx
  800a8f:	89 d8                	mov    %ebx,%eax
  800a91:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a96:	83 e8 23             	sub    $0x23,%eax
  800a99:	83 f8 55             	cmp    $0x55,%eax
  800a9c:	0f 87 4b 04 00 00    	ja     800eed <vprintfmt+0x4f9>
  800aa2:	89 c0                	mov    %eax,%eax
  800aa4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aab:	00 
  800aac:	48 b8 d8 4a 80 00 00 	movabs $0x804ad8,%rax
  800ab3:	00 00 00 
  800ab6:	48 01 d0             	add    %rdx,%rax
  800ab9:	48 8b 00             	mov    (%rax),%rax
  800abc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800abe:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ac2:	eb c1                	jmp    800a85 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac8:	eb bb                	jmp    800a85 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aca:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ad1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	c1 e0 02             	shl    $0x2,%eax
  800ad9:	01 d0                	add    %edx,%eax
  800adb:	01 c0                	add    %eax,%eax
  800add:	01 d8                	add    %ebx,%eax
  800adf:	83 e8 30             	sub    $0x30,%eax
  800ae2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae9:	0f b6 00             	movzbl (%rax),%eax
  800aec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aef:	83 fb 2f             	cmp    $0x2f,%ebx
  800af2:	7e 63                	jle    800b57 <vprintfmt+0x163>
  800af4:	83 fb 39             	cmp    $0x39,%ebx
  800af7:	7f 5e                	jg     800b57 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afe:	eb d1                	jmp    800ad1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	83 f8 30             	cmp    $0x30,%eax
  800b06:	73 17                	jae    800b1f <vprintfmt+0x12b>
  800b08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	89 c0                	mov    %eax,%eax
  800b11:	48 01 d0             	add    %rdx,%rax
  800b14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b17:	83 c2 08             	add    $0x8,%edx
  800b1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x13a>
  800b1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b23:	48 89 d0             	mov    %rdx,%rax
  800b26:	48 83 c2 08          	add    $0x8,%rdx
  800b2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2e:	8b 00                	mov    (%rax),%eax
  800b30:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b33:	eb 23                	jmp    800b58 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b39:	0f 89 42 ff ff ff    	jns    800a81 <vprintfmt+0x8d>
				width = 0;
  800b3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b46:	e9 36 ff ff ff       	jmpq   800a81 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800b4b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b52:	e9 2e ff ff ff       	jmpq   800a85 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b57:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5c:	0f 89 22 ff ff ff    	jns    800a84 <vprintfmt+0x90>
				width = precision, precision = -1;
  800b62:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b65:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b6f:	e9 10 ff ff ff       	jmpq   800a84 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b74:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b78:	e9 08 ff ff ff       	jmpq   800a85 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b80:	83 f8 30             	cmp    $0x30,%eax
  800b83:	73 17                	jae    800b9c <vprintfmt+0x1a8>
  800b85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8c:	89 c0                	mov    %eax,%eax
  800b8e:	48 01 d0             	add    %rdx,%rax
  800b91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b94:	83 c2 08             	add    $0x8,%edx
  800b97:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b9a:	eb 0f                	jmp    800bab <vprintfmt+0x1b7>
  800b9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba0:	48 89 d0             	mov    %rdx,%rax
  800ba3:	48 83 c2 08          	add    $0x8,%rdx
  800ba7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bab:	8b 00                	mov    (%rax),%eax
  800bad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bb5:	48 89 d6             	mov    %rdx,%rsi
  800bb8:	89 c7                	mov    %eax,%edi
  800bba:	ff d1                	callq  *%rcx
			break;
  800bbc:	e9 5a 03 00 00       	jmpq   800f1b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc4:	83 f8 30             	cmp    $0x30,%eax
  800bc7:	73 17                	jae    800be0 <vprintfmt+0x1ec>
  800bc9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd0:	89 c0                	mov    %eax,%eax
  800bd2:	48 01 d0             	add    %rdx,%rax
  800bd5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd8:	83 c2 08             	add    $0x8,%edx
  800bdb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bde:	eb 0f                	jmp    800bef <vprintfmt+0x1fb>
  800be0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be4:	48 89 d0             	mov    %rdx,%rax
  800be7:	48 83 c2 08          	add    $0x8,%rdx
  800beb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bef:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	79 02                	jns    800bf7 <vprintfmt+0x203>
				err = -err;
  800bf5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf7:	83 fb 15             	cmp    $0x15,%ebx
  800bfa:	7f 16                	jg     800c12 <vprintfmt+0x21e>
  800bfc:	48 b8 00 4a 80 00 00 	movabs $0x804a00,%rax
  800c03:	00 00 00 
  800c06:	48 63 d3             	movslq %ebx,%rdx
  800c09:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0d:	4d 85 e4             	test   %r12,%r12
  800c10:	75 2e                	jne    800c40 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c12:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1a:	89 d9                	mov    %ebx,%ecx
  800c1c:	48 ba c1 4a 80 00 00 	movabs $0x804ac1,%rdx
  800c23:	00 00 00 
  800c26:	48 89 c7             	mov    %rax,%rdi
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2e:	49 b8 2b 0f 80 00 00 	movabs $0x800f2b,%r8
  800c35:	00 00 00 
  800c38:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c3b:	e9 db 02 00 00       	jmpq   800f1b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c40:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c48:	4c 89 e1             	mov    %r12,%rcx
  800c4b:	48 ba ca 4a 80 00 00 	movabs $0x804aca,%rdx
  800c52:	00 00 00 
  800c55:	48 89 c7             	mov    %rax,%rdi
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	49 b8 2b 0f 80 00 00 	movabs $0x800f2b,%r8
  800c64:	00 00 00 
  800c67:	41 ff d0             	callq  *%r8
			break;
  800c6a:	e9 ac 02 00 00       	jmpq   800f1b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c72:	83 f8 30             	cmp    $0x30,%eax
  800c75:	73 17                	jae    800c8e <vprintfmt+0x29a>
  800c77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	89 c0                	mov    %eax,%eax
  800c80:	48 01 d0             	add    %rdx,%rax
  800c83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c86:	83 c2 08             	add    $0x8,%edx
  800c89:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8c:	eb 0f                	jmp    800c9d <vprintfmt+0x2a9>
  800c8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c92:	48 89 d0             	mov    %rdx,%rax
  800c95:	48 83 c2 08          	add    $0x8,%rdx
  800c99:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9d:	4c 8b 20             	mov    (%rax),%r12
  800ca0:	4d 85 e4             	test   %r12,%r12
  800ca3:	75 0a                	jne    800caf <vprintfmt+0x2bb>
				p = "(null)";
  800ca5:	49 bc cd 4a 80 00 00 	movabs $0x804acd,%r12
  800cac:	00 00 00 
			if (width > 0 && padc != '-')
  800caf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb3:	7e 7a                	jle    800d2f <vprintfmt+0x33b>
  800cb5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb9:	74 74                	je     800d2f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cbe:	48 98                	cltq   
  800cc0:	48 89 c6             	mov    %rax,%rsi
  800cc3:	4c 89 e7             	mov    %r12,%rdi
  800cc6:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  800ccd:	00 00 00 
  800cd0:	ff d0                	callq  *%rax
  800cd2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd5:	eb 17                	jmp    800cee <vprintfmt+0x2fa>
					putch(padc, putdat);
  800cd7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800cdb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdf:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ce3:	48 89 d6             	mov    %rdx,%rsi
  800ce6:	89 c7                	mov    %eax,%edi
  800ce8:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf2:	7f e3                	jg     800cd7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf4:	eb 39                	jmp    800d2f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cfa:	74 1e                	je     800d1a <vprintfmt+0x326>
  800cfc:	83 fb 1f             	cmp    $0x1f,%ebx
  800cff:	7e 05                	jle    800d06 <vprintfmt+0x312>
  800d01:	83 fb 7e             	cmp    $0x7e,%ebx
  800d04:	7e 14                	jle    800d1a <vprintfmt+0x326>
					putch('?', putdat);
  800d06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0e:	48 89 c6             	mov    %rax,%rsi
  800d11:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d16:	ff d2                	callq  *%rdx
  800d18:	eb 0f                	jmp    800d29 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d1a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d1e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d22:	48 89 c6             	mov    %rax,%rsi
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d29:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2d:	eb 01                	jmp    800d30 <vprintfmt+0x33c>
  800d2f:	90                   	nop
  800d30:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d35:	0f be d8             	movsbl %al,%ebx
  800d38:	85 db                	test   %ebx,%ebx
  800d3a:	0f 95 c0             	setne  %al
  800d3d:	49 83 c4 01          	add    $0x1,%r12
  800d41:	84 c0                	test   %al,%al
  800d43:	74 28                	je     800d6d <vprintfmt+0x379>
  800d45:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d49:	78 ab                	js     800cf6 <vprintfmt+0x302>
  800d4b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d53:	79 a1                	jns    800cf6 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d55:	eb 16                	jmp    800d6d <vprintfmt+0x379>
				putch(' ', putdat);
  800d57:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d5b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d5f:	48 89 c6             	mov    %rax,%rsi
  800d62:	bf 20 00 00 00       	mov    $0x20,%edi
  800d67:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d71:	7f e4                	jg     800d57 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800d73:	e9 a3 01 00 00       	jmpq   800f1b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7c:	be 03 00 00 00       	mov    $0x3,%esi
  800d81:	48 89 c7             	mov    %rax,%rdi
  800d84:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
  800d90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d98:	48 85 c0             	test   %rax,%rax
  800d9b:	79 1d                	jns    800dba <vprintfmt+0x3c6>
				putch('-', putdat);
  800d9d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800da1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800da5:	48 89 c6             	mov    %rax,%rsi
  800da8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dad:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db3:	48 f7 d8             	neg    %rax
  800db6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dc1:	e9 e8 00 00 00       	jmpq   800eae <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dca:	be 03 00 00 00       	mov    $0x3,%esi
  800dcf:	48 89 c7             	mov    %rax,%rdi
  800dd2:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800dd9:	00 00 00 
  800ddc:	ff d0                	callq  *%rax
  800dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800de2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de9:	e9 c0 00 00 00       	jmpq   800eae <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800df2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800df6:	48 89 c6             	mov    %rax,%rsi
  800df9:	bf 58 00 00 00       	mov    $0x58,%edi
  800dfe:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e00:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e04:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e08:	48 89 c6             	mov    %rax,%rsi
  800e0b:	bf 58 00 00 00       	mov    $0x58,%edi
  800e10:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800e12:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e16:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e1a:	48 89 c6             	mov    %rax,%rsi
  800e1d:	bf 58 00 00 00       	mov    $0x58,%edi
  800e22:	ff d2                	callq  *%rdx
			break;
  800e24:	e9 f2 00 00 00       	jmpq   800f1b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800e29:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e2d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e31:	48 89 c6             	mov    %rax,%rsi
  800e34:	bf 30 00 00 00       	mov    $0x30,%edi
  800e39:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e3b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e43:	48 89 c6             	mov    %rax,%rsi
  800e46:	bf 78 00 00 00       	mov    $0x78,%edi
  800e4b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e50:	83 f8 30             	cmp    $0x30,%eax
  800e53:	73 17                	jae    800e6c <vprintfmt+0x478>
  800e55:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5c:	89 c0                	mov    %eax,%eax
  800e5e:	48 01 d0             	add    %rdx,%rax
  800e61:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e64:	83 c2 08             	add    $0x8,%edx
  800e67:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e6a:	eb 0f                	jmp    800e7b <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800e6c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e70:	48 89 d0             	mov    %rdx,%rax
  800e73:	48 83 c2 08          	add    $0x8,%rdx
  800e77:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e82:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e89:	eb 23                	jmp    800eae <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e8b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8f:	be 03 00 00 00       	mov    $0x3,%esi
  800e94:	48 89 c7             	mov    %rax,%rdi
  800e97:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	callq  *%rax
  800ea3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eae:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec5:	45 89 c1             	mov    %r8d,%r9d
  800ec8:	41 89 f8             	mov    %edi,%r8d
  800ecb:	48 89 c7             	mov    %rax,%rdi
  800ece:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800ed5:	00 00 00 
  800ed8:	ff d0                	callq  *%rax
			break;
  800eda:	eb 3f                	jmp    800f1b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800edc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ee0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ee4:	48 89 c6             	mov    %rax,%rsi
  800ee7:	89 df                	mov    %ebx,%edi
  800ee9:	ff d2                	callq  *%rdx
			break;
  800eeb:	eb 2e                	jmp    800f1b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eed:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ef1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ef5:	48 89 c6             	mov    %rax,%rsi
  800ef8:	bf 25 00 00 00       	mov    $0x25,%edi
  800efd:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f04:	eb 05                	jmp    800f0b <vprintfmt+0x517>
  800f06:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f0b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0f:	48 83 e8 01          	sub    $0x1,%rax
  800f13:	0f b6 00             	movzbl (%rax),%eax
  800f16:	3c 25                	cmp    $0x25,%al
  800f18:	75 ec                	jne    800f06 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800f1a:	90                   	nop
		}
	}
  800f1b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1c:	e9 25 fb ff ff       	jmpq   800a46 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f21:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f22:	48 83 c4 60          	add    $0x60,%rsp
  800f26:	5b                   	pop    %rbx
  800f27:	41 5c                	pop    %r12
  800f29:	5d                   	pop    %rbp
  800f2a:	c3                   	retq   

0000000000800f2b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f2b:	55                   	push   %rbp
  800f2c:	48 89 e5             	mov    %rsp,%rbp
  800f2f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f36:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f3d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f44:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f52:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f59:	84 c0                	test   %al,%al
  800f5b:	74 20                	je     800f7d <printfmt+0x52>
  800f5d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f61:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f65:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f69:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f71:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f75:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f79:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f84:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f8b:	00 00 00 
  800f8e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f95:	00 00 00 
  800f98:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800faa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbf:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fcd:	48 89 c7             	mov    %rax,%rdi
  800fd0:	48 b8 f4 09 80 00 00 	movabs $0x8009f4,%rax
  800fd7:	00 00 00 
  800fda:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fdc:	c9                   	leaveq 
  800fdd:	c3                   	retq   

0000000000800fde <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fde:	55                   	push   %rbp
  800fdf:	48 89 e5             	mov    %rsp,%rbp
  800fe2:	48 83 ec 10          	sub    $0x10,%rsp
  800fe6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	8b 40 10             	mov    0x10(%rax),%eax
  800ff4:	8d 50 01             	lea    0x1(%rax),%edx
  800ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801002:	48 8b 10             	mov    (%rax),%rdx
  801005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801009:	48 8b 40 08          	mov    0x8(%rax),%rax
  80100d:	48 39 c2             	cmp    %rax,%rdx
  801010:	73 17                	jae    801029 <sprintputch+0x4b>
		*b->buf++ = ch;
  801012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801016:	48 8b 00             	mov    (%rax),%rax
  801019:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80101c:	88 10                	mov    %dl,(%rax)
  80101e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801022:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801026:	48 89 10             	mov    %rdx,(%rax)
}
  801029:	c9                   	leaveq 
  80102a:	c3                   	retq   

000000000080102b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102b:	55                   	push   %rbp
  80102c:	48 89 e5             	mov    %rsp,%rbp
  80102f:	48 83 ec 50          	sub    $0x50,%rsp
  801033:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801037:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80103a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801042:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801046:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80104a:	48 8b 0a             	mov    (%rdx),%rcx
  80104d:	48 89 08             	mov    %rcx,(%rax)
  801050:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801054:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801058:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801060:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801064:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801068:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80106b:	48 98                	cltq   
  80106d:	48 83 e8 01          	sub    $0x1,%rax
  801071:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801075:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801079:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801080:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801085:	74 06                	je     80108d <vsnprintf+0x62>
  801087:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80108b:	7f 07                	jg     801094 <vsnprintf+0x69>
		return -E_INVAL;
  80108d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801092:	eb 2f                	jmp    8010c3 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801094:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801098:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a0:	48 89 c6             	mov    %rax,%rsi
  8010a3:	48 bf de 0f 80 00 00 	movabs $0x800fde,%rdi
  8010aa:	00 00 00 
  8010ad:	48 b8 f4 09 80 00 00 	movabs $0x8009f4,%rax
  8010b4:	00 00 00 
  8010b7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010bd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c3:	c9                   	leaveq 
  8010c4:	c3                   	retq   

00000000008010c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f2:	84 c0                	test   %al,%al
  8010f4:	74 20                	je     801116 <snprintf+0x51>
  8010f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801102:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801106:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801112:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801116:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801124:	00 00 00 
  801127:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112e:	00 00 00 
  801131:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801135:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801143:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80114a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801151:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801158:	48 8b 0a             	mov    (%rdx),%rcx
  80115b:	48 89 08             	mov    %rcx,(%rax)
  80115e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801162:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801166:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80116a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801175:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801182:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801189:	48 89 c7             	mov    %rax,%rdi
  80118c:	48 b8 2b 10 80 00 00 	movabs $0x80102b,%rax
  801193:	00 00 00 
  801196:	ff d0                	callq  *%rax
  801198:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a4:	c9                   	leaveq 
  8011a5:	c3                   	retq   
	...

00000000008011a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a8:	55                   	push   %rbp
  8011a9:	48 89 e5             	mov    %rsp,%rbp
  8011ac:	48 83 ec 18          	sub    $0x18,%rsp
  8011b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011bb:	eb 09                	jmp    8011c6 <strlen+0x1e>
		n++;
  8011bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	84 c0                	test   %al,%al
  8011cf:	75 ec                	jne    8011bd <strlen+0x15>
		n++;
	return n;
  8011d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 20          	sub    $0x20,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ed:	eb 0e                	jmp    8011fd <strnlen+0x27>
		n++;
  8011ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801202:	74 0b                	je     80120f <strnlen+0x39>
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	0f b6 00             	movzbl (%rax),%eax
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e0                	jne    8011ef <strnlen+0x19>
		n++;
	return n;
  80120f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801212:	c9                   	leaveq 
  801213:	c3                   	retq   

0000000000801214 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	48 83 ec 20          	sub    $0x20,%rsp
  80121c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801220:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80122c:	90                   	nop
  80122d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801231:	0f b6 10             	movzbl (%rax),%edx
  801234:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801238:	88 10                	mov    %dl,(%rax)
  80123a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123e:	0f b6 00             	movzbl (%rax),%eax
  801241:	84 c0                	test   %al,%al
  801243:	0f 95 c0             	setne  %al
  801246:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80124b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801250:	84 c0                	test   %al,%al
  801252:	75 d9                	jne    80122d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 20          	sub    $0x20,%rsp
  801262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80126a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126e:	48 89 c7             	mov    %rax,%rdi
  801271:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  801278:	00 00 00 
  80127b:	ff d0                	callq  *%rax
  80127d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801283:	48 98                	cltq   
  801285:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801289:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80128d:	48 89 d6             	mov    %rdx,%rsi
  801290:	48 89 c7             	mov    %rax,%rdi
  801293:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  80129a:	00 00 00 
  80129d:	ff d0                	callq  *%rax
	return dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 28          	sub    $0x28,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c8:	00 
  8012c9:	eb 27                	jmp    8012f2 <strncpy+0x4d>
		*dst++ = *src;
  8012cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cf:	0f b6 10             	movzbl (%rax),%edx
  8012d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d6:	88 10                	mov    %dl,(%rax)
  8012d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	84 c0                	test   %al,%al
  8012e6:	74 05                	je     8012ed <strncpy+0x48>
			src++;
  8012e8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fa:	72 cf                	jb     8012cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801300:	c9                   	leaveq 
  801301:	c3                   	retq   

0000000000801302 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801302:	55                   	push   %rbp
  801303:	48 89 e5             	mov    %rsp,%rbp
  801306:	48 83 ec 28          	sub    $0x28,%rsp
  80130a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801312:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80131e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801323:	74 37                	je     80135c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801325:	eb 17                	jmp    80133e <strlcpy+0x3c>
			*dst++ = *src++;
  801327:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132b:	0f b6 10             	movzbl (%rax),%edx
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	88 10                	mov    %dl,(%rax)
  801334:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801339:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80133e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801343:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801348:	74 0b                	je     801355 <strlcpy+0x53>
  80134a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134e:	0f b6 00             	movzbl (%rax),%eax
  801351:	84 c0                	test   %al,%al
  801353:	75 d2                	jne    801327 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80135c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	48 89 d1             	mov    %rdx,%rcx
  801367:	48 29 c1             	sub    %rax,%rcx
  80136a:	48 89 c8             	mov    %rcx,%rax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 10          	sub    $0x10,%rsp
  801377:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80137b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80137f:	eb 0a                	jmp    80138b <strcmp+0x1c>
		p++, q++;
  801381:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801386:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	84 c0                	test   %al,%al
  801394:	74 12                	je     8013a8 <strcmp+0x39>
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	0f b6 10             	movzbl (%rax),%edx
  80139d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	38 c2                	cmp    %al,%dl
  8013a6:	74 d9                	je     801381 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	0f b6 d0             	movzbl %al,%edx
  8013b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	0f b6 c0             	movzbl %al,%eax
  8013bc:	89 d1                	mov    %edx,%ecx
  8013be:	29 c1                	sub    %eax,%ecx
  8013c0:	89 c8                	mov    %ecx,%eax
}
  8013c2:	c9                   	leaveq 
  8013c3:	c3                   	retq   

00000000008013c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c4:	55                   	push   %rbp
  8013c5:	48 89 e5             	mov    %rsp,%rbp
  8013c8:	48 83 ec 18          	sub    $0x18,%rsp
  8013cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013d8:	eb 0f                	jmp    8013e9 <strncmp+0x25>
		n--, p++, q++;
  8013da:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ee:	74 1d                	je     80140d <strncmp+0x49>
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	84 c0                	test   %al,%al
  8013f9:	74 12                	je     80140d <strncmp+0x49>
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ff:	0f b6 10             	movzbl (%rax),%edx
  801402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	38 c2                	cmp    %al,%dl
  80140b:	74 cd                	je     8013da <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80140d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801412:	75 07                	jne    80141b <strncmp+0x57>
		return 0;
  801414:	b8 00 00 00 00       	mov    $0x0,%eax
  801419:	eb 1a                	jmp    801435 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80141b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	0f b6 d0             	movzbl %al,%edx
  801425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	0f b6 c0             	movzbl %al,%eax
  80142f:	89 d1                	mov    %edx,%ecx
  801431:	29 c1                	sub    %eax,%ecx
  801433:	89 c8                	mov    %ecx,%eax
}
  801435:	c9                   	leaveq 
  801436:	c3                   	retq   

0000000000801437 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801437:	55                   	push   %rbp
  801438:	48 89 e5             	mov    %rsp,%rbp
  80143b:	48 83 ec 10          	sub    $0x10,%rsp
  80143f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801443:	89 f0                	mov    %esi,%eax
  801445:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801448:	eb 17                	jmp    801461 <strchr+0x2a>
		if (*s == c)
  80144a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801454:	75 06                	jne    80145c <strchr+0x25>
			return (char *) s;
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	eb 15                	jmp    801471 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	0f b6 00             	movzbl (%rax),%eax
  801468:	84 c0                	test   %al,%al
  80146a:	75 de                	jne    80144a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801471:	c9                   	leaveq 
  801472:	c3                   	retq   

0000000000801473 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	48 83 ec 10          	sub    $0x10,%rsp
  80147b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147f:	89 f0                	mov    %esi,%eax
  801481:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801484:	eb 11                	jmp    801497 <strfind+0x24>
		if (*s == c)
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801490:	74 12                	je     8014a4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801492:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 e4                	jne    801486 <strfind+0x13>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x32>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 18          	sub    $0x18,%rsp
  8014b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c3:	75 06                	jne    8014cb <memset+0x20>
		return v;
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	eb 69                	jmp    801534 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cf:	83 e0 03             	and    $0x3,%eax
  8014d2:	48 85 c0             	test   %rax,%rax
  8014d5:	75 48                	jne    80151f <memset+0x74>
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014db:	83 e0 03             	and    $0x3,%eax
  8014de:	48 85 c0             	test   %rax,%rax
  8014e1:	75 3c                	jne    80151f <memset+0x74>
		c &= 0xFF;
  8014e3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	c1 e2 18             	shl    $0x18,%edx
  8014f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f5:	c1 e0 10             	shl    $0x10,%eax
  8014f8:	09 c2                	or     %eax,%edx
  8014fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fd:	c1 e0 08             	shl    $0x8,%eax
  801500:	09 d0                	or     %edx,%eax
  801502:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801509:	48 89 c1             	mov    %rax,%rcx
  80150c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801510:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801514:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801517:	48 89 d7             	mov    %rdx,%rdi
  80151a:	fc                   	cld    
  80151b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151d:	eb 11                	jmp    801530 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80151f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801523:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801526:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152a:	48 89 d7             	mov    %rdx,%rdi
  80152d:	fc                   	cld    
  80152e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801534:	c9                   	leaveq 
  801535:	c3                   	retq   

0000000000801536 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	48 83 ec 28          	sub    $0x28,%rsp
  80153e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80154a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80155a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801562:	0f 83 88 00 00 00    	jae    8015f0 <memmove+0xba>
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801570:	48 01 d0             	add    %rdx,%rax
  801573:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801577:	76 77                	jbe    8015f0 <memmove+0xba>
		s += n;
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	83 e0 03             	and    $0x3,%eax
  801590:	48 85 c0             	test   %rax,%rax
  801593:	75 3b                	jne    8015d0 <memmove+0x9a>
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	48 85 c0             	test   %rax,%rax
  80159f:	75 2f                	jne    8015d0 <memmove+0x9a>
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	83 e0 03             	and    $0x3,%eax
  8015a8:	48 85 c0             	test   %rax,%rax
  8015ab:	75 23                	jne    8015d0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b1:	48 83 e8 04          	sub    $0x4,%rax
  8015b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b9:	48 83 ea 04          	sub    $0x4,%rdx
  8015bd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c5:	48 89 c7             	mov    %rax,%rdi
  8015c8:	48 89 d6             	mov    %rdx,%rsi
  8015cb:	fd                   	std    
  8015cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ce:	eb 1d                	jmp    8015ed <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 89 d7             	mov    %rdx,%rdi
  8015e7:	48 89 c1             	mov    %rax,%rcx
  8015ea:	fd                   	std    
  8015eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015ed:	fc                   	cld    
  8015ee:	eb 57                	jmp    801647 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	83 e0 03             	and    $0x3,%eax
  8015f7:	48 85 c0             	test   %rax,%rax
  8015fa:	75 36                	jne    801632 <memmove+0xfc>
  8015fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801600:	83 e0 03             	and    $0x3,%eax
  801603:	48 85 c0             	test   %rax,%rax
  801606:	75 2a                	jne    801632 <memmove+0xfc>
  801608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160c:	83 e0 03             	and    $0x3,%eax
  80160f:	48 85 c0             	test   %rax,%rax
  801612:	75 1e                	jne    801632 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	48 89 c1             	mov    %rax,%rcx
  80161b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80161f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801623:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801627:	48 89 c7             	mov    %rax,%rdi
  80162a:	48 89 d6             	mov    %rdx,%rsi
  80162d:	fc                   	cld    
  80162e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801630:	eb 15                	jmp    801647 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801636:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 89 d6             	mov    %rdx,%rsi
  801644:	fc                   	cld    
  801645:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164b:	c9                   	leaveq 
  80164c:	c3                   	retq   

000000000080164d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164d:	55                   	push   %rbp
  80164e:	48 89 e5             	mov    %rsp,%rbp
  801651:	48 83 ec 18          	sub    $0x18,%rsp
  801655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801659:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801665:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166d:	48 89 ce             	mov    %rcx,%rsi
  801670:	48 89 c7             	mov    %rax,%rdi
  801673:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
}
  80167f:	c9                   	leaveq 
  801680:	c3                   	retq   

0000000000801681 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801681:	55                   	push   %rbp
  801682:	48 89 e5             	mov    %rsp,%rbp
  801685:	48 83 ec 28          	sub    $0x28,%rsp
  801689:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801691:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801699:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a5:	eb 38                	jmp    8016df <memcmp+0x5e>
		if (*s1 != *s2)
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ab:	0f b6 10             	movzbl (%rax),%edx
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	38 c2                	cmp    %al,%dl
  8016b7:	74 1c                	je     8016d5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8016b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	0f b6 d0             	movzbl %al,%edx
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c7:	0f b6 00             	movzbl (%rax),%eax
  8016ca:	0f b6 c0             	movzbl %al,%eax
  8016cd:	89 d1                	mov    %edx,%ecx
  8016cf:	29 c1                	sub    %eax,%ecx
  8016d1:	89 c8                	mov    %ecx,%eax
  8016d3:	eb 20                	jmp    8016f5 <memcmp+0x74>
		s1++, s2++;
  8016d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016e4:	0f 95 c0             	setne  %al
  8016e7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016ec:	84 c0                	test   %al,%al
  8016ee:	75 b7                	jne    8016a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	48 83 ec 28          	sub    $0x28,%rsp
  8016ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801703:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801706:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801712:	48 01 d0             	add    %rdx,%rax
  801715:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801719:	eb 13                	jmp    80172e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171f:	0f b6 10             	movzbl (%rax),%edx
  801722:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801725:	38 c2                	cmp    %al,%dl
  801727:	74 11                	je     80173a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801729:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801732:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801736:	72 e3                	jb     80171b <memfind+0x24>
  801738:	eb 01                	jmp    80173b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80173a:	90                   	nop
	return (void *) s;
  80173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 38          	sub    $0x38,%rsp
  801749:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801751:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801754:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80175b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801762:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801763:	eb 05                	jmp    80176a <strtol+0x29>
		s++;
  801765:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	0f b6 00             	movzbl (%rax),%eax
  801771:	3c 20                	cmp    $0x20,%al
  801773:	74 f0                	je     801765 <strtol+0x24>
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3c 09                	cmp    $0x9,%al
  80177e:	74 e5                	je     801765 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	3c 2b                	cmp    $0x2b,%al
  801789:	75 07                	jne    801792 <strtol+0x51>
		s++;
  80178b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801790:	eb 17                	jmp    8017a9 <strtol+0x68>
	else if (*s == '-')
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3c 2d                	cmp    $0x2d,%al
  80179b:	75 0c                	jne    8017a9 <strtol+0x68>
		s++, neg = 1;
  80179d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ad:	74 06                	je     8017b5 <strtol+0x74>
  8017af:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b3:	75 28                	jne    8017dd <strtol+0x9c>
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	0f b6 00             	movzbl (%rax),%eax
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 1d                	jne    8017dd <strtol+0x9c>
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	48 83 c0 01          	add    $0x1,%rax
  8017c8:	0f b6 00             	movzbl (%rax),%eax
  8017cb:	3c 78                	cmp    $0x78,%al
  8017cd:	75 0e                	jne    8017dd <strtol+0x9c>
		s += 2, base = 16;
  8017cf:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017db:	eb 2c                	jmp    801809 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e1:	75 19                	jne    8017fc <strtol+0xbb>
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	0f b6 00             	movzbl (%rax),%eax
  8017ea:	3c 30                	cmp    $0x30,%al
  8017ec:	75 0e                	jne    8017fc <strtol+0xbb>
		s++, base = 8;
  8017ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017fa:	eb 0d                	jmp    801809 <strtol+0xc8>
	else if (base == 0)
  8017fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801800:	75 07                	jne    801809 <strtol+0xc8>
		base = 10;
  801802:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	3c 2f                	cmp    $0x2f,%al
  801812:	7e 1d                	jle    801831 <strtol+0xf0>
  801814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801818:	0f b6 00             	movzbl (%rax),%eax
  80181b:	3c 39                	cmp    $0x39,%al
  80181d:	7f 12                	jg     801831 <strtol+0xf0>
			dig = *s - '0';
  80181f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	0f be c0             	movsbl %al,%eax
  801829:	83 e8 30             	sub    $0x30,%eax
  80182c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182f:	eb 4e                	jmp    80187f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	0f b6 00             	movzbl (%rax),%eax
  801838:	3c 60                	cmp    $0x60,%al
  80183a:	7e 1d                	jle    801859 <strtol+0x118>
  80183c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801840:	0f b6 00             	movzbl (%rax),%eax
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 12                	jg     801859 <strtol+0x118>
			dig = *s - 'a' + 10;
  801847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184b:	0f b6 00             	movzbl (%rax),%eax
  80184e:	0f be c0             	movsbl %al,%eax
  801851:	83 e8 57             	sub    $0x57,%eax
  801854:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801857:	eb 26                	jmp    80187f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185d:	0f b6 00             	movzbl (%rax),%eax
  801860:	3c 40                	cmp    $0x40,%al
  801862:	7e 47                	jle    8018ab <strtol+0x16a>
  801864:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801868:	0f b6 00             	movzbl (%rax),%eax
  80186b:	3c 5a                	cmp    $0x5a,%al
  80186d:	7f 3c                	jg     8018ab <strtol+0x16a>
			dig = *s - 'A' + 10;
  80186f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 37             	sub    $0x37,%eax
  80187c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801882:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801885:	7d 23                	jge    8018aa <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188f:	48 98                	cltq   
  801891:	48 89 c2             	mov    %rax,%rdx
  801894:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189c:	48 98                	cltq   
  80189e:	48 01 d0             	add    %rdx,%rax
  8018a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a5:	e9 5f ff ff ff       	jmpq   801809 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018aa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018b0:	74 0b                	je     8018bd <strtol+0x17c>
		*endptr = (char *) s;
  8018b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018ba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c1:	74 09                	je     8018cc <strtol+0x18b>
  8018c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c7:	48 f7 d8             	neg    %rax
  8018ca:	eb 04                	jmp    8018d0 <strtol+0x18f>
  8018cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 30          	sub    $0x30,%rsp
  8018da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e6:	0f b6 00             	movzbl (%rax),%eax
  8018e9:	88 45 ff             	mov    %al,-0x1(%rbp)
  8018ec:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8018f1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f5:	75 06                	jne    8018fd <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	eb 68                	jmp    801965 <strstr+0x93>

	len = strlen(str);
  8018fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801901:	48 89 c7             	mov    %rax,%rdi
  801904:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	callq  *%rax
  801910:	48 98                	cltq   
  801912:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	0f b6 00             	movzbl (%rax),%eax
  80191d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801920:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801925:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801929:	75 07                	jne    801932 <strstr+0x60>
				return (char *) 0;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	eb 33                	jmp    801965 <strstr+0x93>
		} while (sc != c);
  801932:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801936:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801939:	75 db                	jne    801916 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  80193b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	48 89 ce             	mov    %rcx,%rsi
  80194a:	48 89 c7             	mov    %rax,%rdi
  80194d:	48 b8 c4 13 80 00 00 	movabs $0x8013c4,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
  801959:	85 c0                	test   %eax,%eax
  80195b:	75 b9                	jne    801916 <strstr+0x44>

	return (char *) (in - 1);
  80195d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801961:	48 83 e8 01          	sub    $0x1,%rax
}
  801965:	c9                   	leaveq 
  801966:	c3                   	retq   
	...

0000000000801968 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	53                   	push   %rbx
  80196d:	48 83 ec 58          	sub    $0x58,%rsp
  801971:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801974:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801977:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80197b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80197f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801983:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801987:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  80198d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801991:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801995:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801999:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8019a4:	4c 89 c3             	mov    %r8,%rbx
  8019a7:	cd 30                	int    $0x30
  8019a9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8019ad:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b9:	74 3e                	je     8019f9 <syscall+0x91>
  8019bb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019c0:	7e 37                	jle    8019f9 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c9:	49 89 d0             	mov    %rdx,%r8
  8019cc:	89 c1                	mov    %eax,%ecx
  8019ce:	48 ba 88 4d 80 00 00 	movabs $0x804d88,%rdx
  8019d5:	00 00 00 
  8019d8:	be 23 00 00 00       	mov    $0x23,%esi
  8019dd:	48 bf a5 4d 80 00 00 	movabs $0x804da5,%rdi
  8019e4:	00 00 00 
  8019e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ec:	49 b9 08 04 80 00 00 	movabs $0x800408,%r9
  8019f3:	00 00 00 
  8019f6:	41 ff d1             	callq  *%r9

	return ret;
  8019f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019fd:	48 83 c4 58          	add    $0x58,%rsp
  801a01:	5b                   	pop    %rbx
  801a02:	5d                   	pop    %rbp
  801a03:	c3                   	retq   

0000000000801a04 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a04:	55                   	push   %rbp
  801a05:	48 89 e5             	mov    %rsp,%rbp
  801a08:	48 83 ec 20          	sub    $0x20,%rsp
  801a0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a23:	00 
  801a24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a30:	48 89 d1             	mov    %rdx,%rcx
  801a33:	48 89 c2             	mov    %rax,%rdx
  801a36:	be 00 00 00 00       	mov    $0x0,%esi
  801a3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a40:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801a47:	00 00 00 
  801a4a:	ff d0                	callq  *%rax
}
  801a4c:	c9                   	leaveq 
  801a4d:	c3                   	retq   

0000000000801a4e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4e:	55                   	push   %rbp
  801a4f:	48 89 e5             	mov    %rsp,%rbp
  801a52:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5d:	00 
  801a5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a74:	be 00 00 00 00       	mov    $0x0,%esi
  801a79:	bf 01 00 00 00       	mov    $0x1,%edi
  801a7e:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 20          	sub    $0x20,%rsp
  801a94:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9a:	48 98                	cltq   
  801a9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa3:	00 
  801aa4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab5:	48 89 c2             	mov    %rax,%rdx
  801ab8:	be 01 00 00 00       	mov    $0x1,%esi
  801abd:	bf 03 00 00 00       	mov    $0x3,%edi
  801ac2:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ad8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adf:	00 
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af1:	ba 00 00 00 00       	mov    $0x0,%edx
  801af6:	be 00 00 00 00       	mov    $0x0,%esi
  801afb:	bf 02 00 00 00       	mov    $0x2,%edi
  801b00:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <sys_yield>:

void
sys_yield(void)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1d:	00 
  801b1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	be 00 00 00 00       	mov    $0x0,%esi
  801b39:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3e:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b61:	48 63 c8             	movslq %eax,%rcx
  801b64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6b:	48 98                	cltq   
  801b6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b74:	00 
  801b75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7b:	49 89 c8             	mov    %rcx,%r8
  801b7e:	48 89 d1             	mov    %rdx,%rcx
  801b81:	48 89 c2             	mov    %rax,%rdx
  801b84:	be 01 00 00 00       	mov    $0x1,%esi
  801b89:	bf 04 00 00 00       	mov    $0x4,%edi
  801b8e:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 30          	sub    $0x30,%rsp
  801ba4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bab:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bb2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bb6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb9:	48 63 c8             	movslq %eax,%rcx
  801bbc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc3:	48 63 f0             	movslq %eax,%rsi
  801bc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcd:	48 98                	cltq   
  801bcf:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bd3:	49 89 f9             	mov    %rdi,%r9
  801bd6:	49 89 f0             	mov    %rsi,%r8
  801bd9:	48 89 d1             	mov    %rdx,%rcx
  801bdc:	48 89 c2             	mov    %rax,%rdx
  801bdf:	be 01 00 00 00       	mov    $0x1,%esi
  801be4:	bf 05 00 00 00       	mov    $0x5,%edi
  801be9:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	callq  *%rax
}
  801bf5:	c9                   	leaveq 
  801bf6:	c3                   	retq   

0000000000801bf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bf7:	55                   	push   %rbp
  801bf8:	48 89 e5             	mov    %rsp,%rbp
  801bfb:	48 83 ec 20          	sub    $0x20,%rsp
  801bff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0d:	48 98                	cltq   
  801c0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c16:	00 
  801c17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c23:	48 89 d1             	mov    %rdx,%rcx
  801c26:	48 89 c2             	mov    %rax,%rdx
  801c29:	be 01 00 00 00       	mov    $0x1,%esi
  801c2e:	bf 06 00 00 00       	mov    $0x6,%edi
  801c33:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
}
  801c3f:	c9                   	leaveq 
  801c40:	c3                   	retq   

0000000000801c41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c41:	55                   	push   %rbp
  801c42:	48 89 e5             	mov    %rsp,%rbp
  801c45:	48 83 ec 20          	sub    $0x20,%rsp
  801c49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c52:	48 63 d0             	movslq %eax,%rdx
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	48 98                	cltq   
  801c5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c61:	00 
  801c62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6e:	48 89 d1             	mov    %rdx,%rcx
  801c71:	48 89 c2             	mov    %rax,%rdx
  801c74:	be 01 00 00 00       	mov    $0x1,%esi
  801c79:	bf 08 00 00 00       	mov    $0x8,%edi
  801c7e:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
}
  801c8a:	c9                   	leaveq 
  801c8b:	c3                   	retq   

0000000000801c8c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
  801c90:	48 83 ec 20          	sub    $0x20,%rsp
  801c94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca2:	48 98                	cltq   
  801ca4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cab:	00 
  801cac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb8:	48 89 d1             	mov    %rdx,%rcx
  801cbb:	48 89 c2             	mov    %rax,%rdx
  801cbe:	be 01 00 00 00       	mov    $0x1,%esi
  801cc3:	bf 09 00 00 00       	mov    $0x9,%edi
  801cc8:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	callq  *%rax
}
  801cd4:	c9                   	leaveq 
  801cd5:	c3                   	retq   

0000000000801cd6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cd6:	55                   	push   %rbp
  801cd7:	48 89 e5             	mov    %rsp,%rbp
  801cda:	48 83 ec 20          	sub    $0x20,%rsp
  801cde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ce5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cec:	48 98                	cltq   
  801cee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf5:	00 
  801cf6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d02:	48 89 d1             	mov    %rdx,%rcx
  801d05:	48 89 c2             	mov    %rax,%rdx
  801d08:	be 01 00 00 00       	mov    $0x1,%esi
  801d0d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d12:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 30          	sub    $0x30,%rsp
  801d28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d33:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d39:	48 63 f0             	movslq %eax,%rsi
  801d3c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d43:	48 98                	cltq   
  801d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d50:	00 
  801d51:	49 89 f1             	mov    %rsi,%r9
  801d54:	49 89 c8             	mov    %rcx,%r8
  801d57:	48 89 d1             	mov    %rdx,%rcx
  801d5a:	48 89 c2             	mov    %rax,%rdx
  801d5d:	be 00 00 00 00       	mov    $0x0,%esi
  801d62:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d67:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801d6e:	00 00 00 
  801d71:	ff d0                	callq  *%rax
}
  801d73:	c9                   	leaveq 
  801d74:	c3                   	retq   

0000000000801d75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d75:	55                   	push   %rbp
  801d76:	48 89 e5             	mov    %rsp,%rbp
  801d79:	48 83 ec 20          	sub    $0x20,%rsp
  801d7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d8c:	00 
  801d8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9e:	48 89 c2             	mov    %rax,%rdx
  801da1:	be 01 00 00 00       	mov    $0x1,%esi
  801da6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dab:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
}
  801db7:	c9                   	leaveq 
  801db8:	c3                   	retq   

0000000000801db9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801db9:	55                   	push   %rbp
  801dba:	48 89 e5             	mov    %rsp,%rbp
  801dbd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc8:	00 
  801dc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dda:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddf:	be 00 00 00 00       	mov    $0x0,%esi
  801de4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801de9:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 30          	sub    $0x30,%rsp
  801dff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e06:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e09:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e0d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e11:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e14:	48 63 c8             	movslq %eax,%rcx
  801e17:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1e:	48 63 f0             	movslq %eax,%rsi
  801e21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e28:	48 98                	cltq   
  801e2a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e2e:	49 89 f9             	mov    %rdi,%r9
  801e31:	49 89 f0             	mov    %rsi,%r8
  801e34:	48 89 d1             	mov    %rdx,%rcx
  801e37:	48 89 c2             	mov    %rax,%rdx
  801e3a:	be 00 00 00 00       	mov    $0x0,%esi
  801e3f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e44:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e50:	c9                   	leaveq 
  801e51:	c3                   	retq   

0000000000801e52 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e52:	55                   	push   %rbp
  801e53:	48 89 e5             	mov    %rsp,%rbp
  801e56:	48 83 ec 20          	sub    $0x20,%rsp
  801e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e71:	00 
  801e72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7e:	48 89 d1             	mov    %rdx,%rcx
  801e81:	48 89 c2             	mov    %rax,%rdx
  801e84:	be 00 00 00 00       	mov    $0x0,%esi
  801e89:	bf 10 00 00 00       	mov    $0x10,%edi
  801e8e:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 40          	sub    $0x40,%rsp
  801ea4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ea8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801eac:	48 8b 00             	mov    (%rax),%rax
  801eaf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801eb3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801eb7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ebb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801ebe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec2:	48 89 c2             	mov    %rax,%rdx
  801ec5:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ec9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ed0:	01 00 00 
  801ed3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801edb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ede:	83 e0 02             	and    $0x2,%eax
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	0f 84 4f 01 00 00    	je     802038 <pgfault+0x19c>
  801ee9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ef4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801efb:	01 00 00 
  801efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f02:	25 00 08 00 00       	and    $0x800,%eax
  801f07:	48 85 c0             	test   %rax,%rax
  801f0a:	0f 84 28 01 00 00    	je     802038 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801f10:	ba 07 00 00 00       	mov    $0x7,%edx
  801f15:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1f:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	0f 85 db 00 00 00    	jne    80200e <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801f3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f45:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801f49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f52:	48 89 c6             	mov    %rax,%rsi
  801f55:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f5a:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f70:	48 89 c1             	mov    %rax,%rcx
  801f73:	ba 00 00 00 00       	mov    $0x0,%edx
  801f78:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f82:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
  801f8e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801f91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f95:	79 2a                	jns    801fc1 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801f97:	48 ba b8 4d 80 00 00 	movabs $0x804db8,%rdx
  801f9e:	00 00 00 
  801fa1:	be 28 00 00 00       	mov    $0x28,%esi
  801fa6:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  801fad:	00 00 00 
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb5:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  801fbc:	00 00 00 
  801fbf:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  801fc1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcb:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
  801fd7:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801fda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801fde:	0f 89 84 00 00 00    	jns    802068 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  801fe4:	48 ba f0 4d 80 00 00 	movabs $0x804df0,%rdx
  801feb:	00 00 00 
  801fee:	be 2c 00 00 00       	mov    $0x2c,%esi
  801ff3:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  801ffa:	00 00 00 
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  802009:	00 00 00 
  80200c:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  80200e:	48 ba 20 4e 80 00 00 	movabs $0x804e20,%rdx
  802015:	00 00 00 
  802018:	be 31 00 00 00       	mov    $0x31,%esi
  80201d:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802024:	00 00 00 
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  802033:	00 00 00 
  802036:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802038:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80203b:	89 c1                	mov    %eax,%ecx
  80203d:	48 ba 4a 4e 80 00 00 	movabs $0x804e4a,%rdx
  802044:	00 00 00 
  802047:	be 35 00 00 00       	mov    $0x35,%esi
  80204c:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802053:	00 00 00 
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  802062:	00 00 00 
  802065:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  802068:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   

000000000080206b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 30          	sub    $0x30,%rsp
  802073:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802076:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  802079:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802080:	01 00 00 
  802083:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802086:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  80208e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802091:	48 c1 e0 0c          	shl    $0xc,%rax
  802095:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80209d:	25 07 0e 00 00       	and    $0xe07,%eax
  8020a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  8020a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a8:	25 00 04 00 00       	and    $0x400,%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	74 62                	je     802113 <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  8020b1:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8020b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bf:	41 89 f0             	mov    %esi,%r8d
  8020c2:	48 89 c6             	mov    %rax,%rsi
  8020c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ca:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
  8020d6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8020d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020dd:	0f 89 78 01 00 00    	jns    80225b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8020e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020e6:	89 c1                	mov    %eax,%ecx
  8020e8:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  8020ef:	00 00 00 
  8020f2:	be 4f 00 00 00       	mov    $0x4f,%esi
  8020f7:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  8020fe:	00 00 00 
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  80210d:	00 00 00 
  802110:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  802113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802116:	25 00 08 00 00       	and    $0x800,%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	75 0e                	jne    80212d <duppage+0xc2>
  80211f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802122:	83 e0 02             	and    $0x2,%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 84 d0 00 00 00    	je     8021fd <duppage+0x192>
		perm &= ~PTE_W;
  80212d:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  802131:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  802138:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80213b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80213f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802146:	41 89 f0             	mov    %esi,%r8d
  802149:	48 89 c6             	mov    %rax,%rsi
  80214c:	bf 00 00 00 00       	mov    $0x0,%edi
  802151:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802158:	00 00 00 
  80215b:	ff d0                	callq  *%rax
  80215d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802160:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802164:	79 30                	jns    802196 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  802166:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802169:	89 c1                	mov    %eax,%ecx
  80216b:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  802172:	00 00 00 
  802175:	be 57 00 00 00       	mov    $0x57,%esi
  80217a:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802181:	00 00 00 
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
  802189:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  802190:	00 00 00 
  802193:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802196:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802199:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80219d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a1:	41 89 c8             	mov    %ecx,%r8d
  8021a4:	48 89 d1             	mov    %rdx,%rcx
  8021a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ac:	48 89 c6             	mov    %rax,%rsi
  8021af:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b4:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  8021bb:	00 00 00 
  8021be:	ff d0                	callq  *%rax
  8021c0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8021c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021c7:	0f 89 8e 00 00 00    	jns    80225b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8021cd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021d0:	89 c1                	mov    %eax,%ecx
  8021d2:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  8021d9:	00 00 00 
  8021dc:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021e1:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  8021e8:	00 00 00 
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8021f7:	00 00 00 
  8021fa:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  8021fd:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802200:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802204:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220b:	41 89 f0             	mov    %esi,%r8d
  80220e:	48 89 c6             	mov    %rax,%rsi
  802211:	bf 00 00 00 00       	mov    $0x0,%edi
  802216:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802225:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802229:	79 30                	jns    80225b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80222b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80222e:	89 c1                	mov    %eax,%ecx
  802230:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  802237:	00 00 00 
  80223a:	be 61 00 00 00       	mov    $0x61,%esi
  80223f:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802246:	00 00 00 
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  802255:	00 00 00 
  802258:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802260:	c9                   	leaveq 
  802261:	c3                   	retq   

0000000000802262 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802262:	55                   	push   %rbp
  802263:	48 89 e5             	mov    %rsp,%rbp
  802266:	53                   	push   %rbx
  802267:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  80226b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  802272:	48 bf 9c 1e 80 00 00 	movabs $0x801e9c,%rdi
  802279:	00 00 00 
  80227c:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  802283:	00 00 00 
  802286:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802288:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80228f:	8b 45 9c             	mov    -0x64(%rbp),%eax
  802292:	cd 30                	int    $0x30
  802294:	89 c3                	mov    %eax,%ebx
  802296:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802299:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  80229c:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80229f:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8022a3:	79 30                	jns    8022d5 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  8022a5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8022a8:	89 c1                	mov    %eax,%ecx
  8022aa:	48 ba 8b 4e 80 00 00 	movabs $0x804e8b,%rdx
  8022b1:	00 00 00 
  8022b4:	be 80 00 00 00       	mov    $0x80,%esi
  8022b9:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  8022c0:	00 00 00 
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8022cf:	00 00 00 
  8022d2:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  8022d5:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8022d9:	75 52                	jne    80232d <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  8022db:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	callq  *%rax
  8022e7:	48 98                	cltq   
  8022e9:	48 89 c2             	mov    %rax,%rdx
  8022ec:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8022f2:	48 89 d0             	mov    %rdx,%rax
  8022f5:	48 c1 e0 02          	shl    $0x2,%rax
  8022f9:	48 01 d0             	add    %rdx,%rax
  8022fc:	48 01 c0             	add    %rax,%rax
  8022ff:	48 01 d0             	add    %rdx,%rax
  802302:	48 c1 e0 05          	shl    $0x5,%rax
  802306:	48 89 c2             	mov    %rax,%rdx
  802309:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802310:	00 00 00 
  802313:	48 01 c2             	add    %rax,%rdx
  802316:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80231d:	00 00 00 
  802320:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	e9 9d 02 00 00       	jmpq   8025ca <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  80232d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802330:	ba 07 00 00 00       	mov    $0x7,%edx
  802335:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80233a:	89 c7                	mov    %eax,%edi
  80233c:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  802343:	00 00 00 
  802346:	ff d0                	callq  *%rax
  802348:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80234b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80234f:	79 30                	jns    802381 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  802351:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802354:	89 c1                	mov    %eax,%ecx
  802356:	48 ba 8b 4e 80 00 00 	movabs $0x804e8b,%rdx
  80235d:	00 00 00 
  802360:	be 88 00 00 00       	mov    $0x88,%esi
  802365:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  80236c:	00 00 00 
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  80237b:	00 00 00 
  80237e:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  802381:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802388:	00 
	uint64_t each_pte = 0;
  802389:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802390:	00 
	uint64_t each_pdpe = 0;
  802391:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802398:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802399:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023a0:	00 
  8023a1:	e9 73 01 00 00       	jmpq   802519 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  8023a6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023ad:	01 00 00 
  8023b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b8:	83 e0 01             	and    $0x1,%eax
  8023bb:	84 c0                	test   %al,%al
  8023bd:	0f 84 41 01 00 00    	je     802504 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8023c3:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8023ca:	00 
  8023cb:	e9 24 01 00 00       	jmpq   8024f4 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  8023d0:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023d7:	01 00 00 
  8023da:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8023de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e2:	83 e0 01             	and    $0x1,%eax
  8023e5:	84 c0                	test   %al,%al
  8023e7:	0f 84 ed 00 00 00    	je     8024da <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8023ed:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8023f4:	00 
  8023f5:	e9 d0 00 00 00       	jmpq   8024ca <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  8023fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802401:	01 00 00 
  802404:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802408:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240c:	83 e0 01             	and    $0x1,%eax
  80240f:	84 c0                	test   %al,%al
  802411:	0f 84 99 00 00 00    	je     8024b0 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802417:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80241e:	00 
  80241f:	eb 7f                	jmp    8024a0 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802421:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802428:	01 00 00 
  80242b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80242f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802433:	83 e0 01             	and    $0x1,%eax
  802436:	84 c0                	test   %al,%al
  802438:	74 5c                	je     802496 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  80243a:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  802441:	00 
  802442:	74 52                	je     802496 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802444:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802448:	89 c2                	mov    %eax,%edx
  80244a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80244d:	89 d6                	mov    %edx,%esi
  80244f:	89 c7                	mov    %eax,%edi
  802451:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802458:	00 00 00 
  80245b:	ff d0                	callq  *%rax
  80245d:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  802460:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802464:	79 30                	jns    802496 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802466:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802469:	89 c1                	mov    %eax,%ecx
  80246b:	48 ba 8b 4e 80 00 00 	movabs $0x804e8b,%rdx
  802472:	00 00 00 
  802475:	be a0 00 00 00       	mov    $0xa0,%esi
  80247a:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802481:	00 00 00 
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  802490:	00 00 00 
  802493:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802496:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80249b:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  8024a0:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8024a7:	00 
  8024a8:	0f 86 73 ff ff ff    	jbe    802421 <fork+0x1bf>
  8024ae:	eb 10                	jmp    8024c0 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  8024b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8024b4:	48 83 c0 01          	add    $0x1,%rax
  8024b8:	48 c1 e0 09          	shl    $0x9,%rax
  8024bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8024c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8024c5:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8024ca:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8024d1:	00 
  8024d2:	0f 86 22 ff ff ff    	jbe    8023fa <fork+0x198>
  8024d8:	eb 10                	jmp    8024ea <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8024da:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8024de:	48 83 c0 01          	add    $0x1,%rax
  8024e2:	48 c1 e0 09          	shl    $0x9,%rax
  8024e6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8024ea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8024ef:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  8024f4:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8024fb:	00 
  8024fc:	0f 86 ce fe ff ff    	jbe    8023d0 <fork+0x16e>
  802502:	eb 10                	jmp    802514 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802508:	48 83 c0 01          	add    $0x1,%rax
  80250c:	48 c1 e0 09          	shl    $0x9,%rax
  802510:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802514:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802519:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80251e:	0f 84 82 fe ff ff    	je     8023a6 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802524:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802527:	48 be f4 43 80 00 00 	movabs $0x8043f4,%rsi
  80252e:	00 00 00 
  802531:	89 c7                	mov    %eax,%edi
  802533:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  80253a:	00 00 00 
  80253d:	ff d0                	callq  *%rax
  80253f:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802542:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802546:	79 30                	jns    802578 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802548:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80254b:	89 c1                	mov    %eax,%ecx
  80254d:	48 ba 8b 4e 80 00 00 	movabs $0x804e8b,%rdx
  802554:	00 00 00 
  802557:	be bd 00 00 00       	mov    $0xbd,%esi
  80255c:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  802563:	00 00 00 
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  802572:	00 00 00 
  802575:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802578:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80257b:	be 02 00 00 00       	mov    $0x2,%esi
  802580:	89 c7                	mov    %eax,%edi
  802582:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
  80258e:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802591:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802595:	79 30                	jns    8025c7 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802597:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80259a:	89 c1                	mov    %eax,%ecx
  80259c:	48 ba 8b 4e 80 00 00 	movabs $0x804e8b,%rdx
  8025a3:	00 00 00 
  8025a6:	be c1 00 00 00       	mov    $0xc1,%esi
  8025ab:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  8025b2:	00 00 00 
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8025c1:	00 00 00 
  8025c4:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  8025c7:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  8025ca:	48 83 c4 68          	add    $0x68,%rsp
  8025ce:	5b                   	pop    %rbx
  8025cf:	5d                   	pop    %rbp
  8025d0:	c3                   	retq   

00000000008025d1 <sfork>:

// Challenge!
int
sfork(void)
{
  8025d1:	55                   	push   %rbp
  8025d2:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025d5:	48 ba a4 4e 80 00 00 	movabs $0x804ea4,%rdx
  8025dc:	00 00 00 
  8025df:	be cc 00 00 00       	mov    $0xcc,%esi
  8025e4:	48 bf e0 4d 80 00 00 	movabs $0x804de0,%rdi
  8025eb:	00 00 00 
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  8025fa:	00 00 00 
  8025fd:	ff d1                	callq  *%rcx
	...

0000000000802600 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802600:	55                   	push   %rbp
  802601:	48 89 e5             	mov    %rsp,%rbp
  802604:	48 83 ec 08          	sub    $0x8,%rsp
  802608:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80260c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802610:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802617:	ff ff ff 
  80261a:	48 01 d0             	add    %rdx,%rax
  80261d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802621:	c9                   	leaveq 
  802622:	c3                   	retq   

0000000000802623 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802623:	55                   	push   %rbp
  802624:	48 89 e5             	mov    %rsp,%rbp
  802627:	48 83 ec 08          	sub    $0x8,%rsp
  80262b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80262f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802633:	48 89 c7             	mov    %rax,%rdi
  802636:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
  802642:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802648:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80264c:	c9                   	leaveq 
  80264d:	c3                   	retq   

000000000080264e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80264e:	55                   	push   %rbp
  80264f:	48 89 e5             	mov    %rsp,%rbp
  802652:	48 83 ec 18          	sub    $0x18,%rsp
  802656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80265a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802661:	eb 6b                	jmp    8026ce <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802666:	48 98                	cltq   
  802668:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80266e:	48 c1 e0 0c          	shl    $0xc,%rax
  802672:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267a:	48 89 c2             	mov    %rax,%rdx
  80267d:	48 c1 ea 15          	shr    $0x15,%rdx
  802681:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802688:	01 00 00 
  80268b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268f:	83 e0 01             	and    $0x1,%eax
  802692:	48 85 c0             	test   %rax,%rax
  802695:	74 21                	je     8026b8 <fd_alloc+0x6a>
  802697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269b:	48 89 c2             	mov    %rax,%rdx
  80269e:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026a9:	01 00 00 
  8026ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b0:	83 e0 01             	and    $0x1,%eax
  8026b3:	48 85 c0             	test   %rax,%rax
  8026b6:	75 12                	jne    8026ca <fd_alloc+0x7c>
			*fd_store = fd;
  8026b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	eb 1a                	jmp    8026e4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026d2:	7e 8f                	jle    802663 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026df:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026e4:	c9                   	leaveq 
  8026e5:	c3                   	retq   

00000000008026e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026e6:	55                   	push   %rbp
  8026e7:	48 89 e5             	mov    %rsp,%rbp
  8026ea:	48 83 ec 20          	sub    $0x20,%rsp
  8026ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026f9:	78 06                	js     802701 <fd_lookup+0x1b>
  8026fb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026ff:	7e 07                	jle    802708 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802701:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802706:	eb 6c                	jmp    802774 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802708:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80270b:	48 98                	cltq   
  80270d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802713:	48 c1 e0 0c          	shl    $0xc,%rax
  802717:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80271b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271f:	48 89 c2             	mov    %rax,%rdx
  802722:	48 c1 ea 15          	shr    $0x15,%rdx
  802726:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80272d:	01 00 00 
  802730:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802734:	83 e0 01             	and    $0x1,%eax
  802737:	48 85 c0             	test   %rax,%rax
  80273a:	74 21                	je     80275d <fd_lookup+0x77>
  80273c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802740:	48 89 c2             	mov    %rax,%rdx
  802743:	48 c1 ea 0c          	shr    $0xc,%rdx
  802747:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274e:	01 00 00 
  802751:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802755:	83 e0 01             	and    $0x1,%eax
  802758:	48 85 c0             	test   %rax,%rax
  80275b:	75 07                	jne    802764 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80275d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802762:	eb 10                	jmp    802774 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802764:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802768:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80276c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802774:	c9                   	leaveq 
  802775:	c3                   	retq   

0000000000802776 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802776:	55                   	push   %rbp
  802777:	48 89 e5             	mov    %rsp,%rbp
  80277a:	48 83 ec 30          	sub    $0x30,%rsp
  80277e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802782:	89 f0                	mov    %esi,%eax
  802784:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278b:	48 89 c7             	mov    %rax,%rdi
  80278e:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
  80279a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80279e:	48 89 d6             	mov    %rdx,%rsi
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b6:	78 0a                	js     8027c2 <fd_close+0x4c>
	    || fd != fd2)
  8027b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027c0:	74 12                	je     8027d4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027c2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027c6:	74 05                	je     8027cd <fd_close+0x57>
  8027c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cb:	eb 05                	jmp    8027d2 <fd_close+0x5c>
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	eb 69                	jmp    80283d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d8:	8b 00                	mov    (%rax),%eax
  8027da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027de:	48 89 d6             	mov    %rdx,%rsi
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	48 b8 3f 28 80 00 00 	movabs $0x80283f,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax
  8027ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f6:	78 2a                	js     802822 <fd_close+0xac>
		if (dev->dev_close)
  8027f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fc:	48 8b 40 20          	mov    0x20(%rax),%rax
  802800:	48 85 c0             	test   %rax,%rax
  802803:	74 16                	je     80281b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802809:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80280d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802811:	48 89 c7             	mov    %rax,%rdi
  802814:	ff d2                	callq  *%rdx
  802816:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802819:	eb 07                	jmp    802822 <fd_close+0xac>
		else
			r = 0;
  80281b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802826:	48 89 c6             	mov    %rax,%rsi
  802829:	bf 00 00 00 00       	mov    $0x0,%edi
  80282e:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  802835:	00 00 00 
  802838:	ff d0                	callq  *%rax
	return r;
  80283a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80283d:	c9                   	leaveq 
  80283e:	c3                   	retq   

000000000080283f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80283f:	55                   	push   %rbp
  802840:	48 89 e5             	mov    %rsp,%rbp
  802843:	48 83 ec 20          	sub    $0x20,%rsp
  802847:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80284a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80284e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802855:	eb 41                	jmp    802898 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802857:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80285e:	00 00 00 
  802861:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802864:	48 63 d2             	movslq %edx,%rdx
  802867:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286b:	8b 00                	mov    (%rax),%eax
  80286d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802870:	75 22                	jne    802894 <dev_lookup+0x55>
			*dev = devtab[i];
  802872:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802879:	00 00 00 
  80287c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287f:	48 63 d2             	movslq %edx,%rdx
  802882:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802886:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80288a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	eb 60                	jmp    8028f4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802894:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802898:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80289f:	00 00 00 
  8028a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028a5:	48 63 d2             	movslq %edx,%rdx
  8028a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ac:	48 85 c0             	test   %rax,%rax
  8028af:	75 a6                	jne    802857 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028b1:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8028b8:	00 00 00 
  8028bb:	48 8b 00             	mov    (%rax),%rax
  8028be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028c7:	89 c6                	mov    %eax,%esi
  8028c9:	48 bf c0 4e 80 00 00 	movabs $0x804ec0,%rdi
  8028d0:	00 00 00 
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d8:	48 b9 43 06 80 00 00 	movabs $0x800643,%rcx
  8028df:	00 00 00 
  8028e2:	ff d1                	callq  *%rcx
	*dev = 0;
  8028e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028f4:	c9                   	leaveq 
  8028f5:	c3                   	retq   

00000000008028f6 <close>:

int
close(int fdnum)
{
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	48 83 ec 20          	sub    $0x20,%rsp
  8028fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802901:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802905:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802908:	48 89 d6             	mov    %rdx,%rsi
  80290b:	89 c7                	mov    %eax,%edi
  80290d:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
  802919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802920:	79 05                	jns    802927 <close+0x31>
		return r;
  802922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802925:	eb 18                	jmp    80293f <close+0x49>
	else
		return fd_close(fd, 1);
  802927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292b:	be 01 00 00 00       	mov    $0x1,%esi
  802930:	48 89 c7             	mov    %rax,%rdi
  802933:	48 b8 76 27 80 00 00 	movabs $0x802776,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
}
  80293f:	c9                   	leaveq 
  802940:	c3                   	retq   

0000000000802941 <close_all>:

void
close_all(void)
{
  802941:	55                   	push   %rbp
  802942:	48 89 e5             	mov    %rsp,%rbp
  802945:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802950:	eb 15                	jmp    802967 <close_all+0x26>
		close(i);
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	89 c7                	mov    %eax,%edi
  802957:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802963:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802967:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80296b:	7e e5                	jle    802952 <close_all+0x11>
		close(i);
}
  80296d:	c9                   	leaveq 
  80296e:	c3                   	retq   

000000000080296f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80296f:	55                   	push   %rbp
  802970:	48 89 e5             	mov    %rsp,%rbp
  802973:	48 83 ec 40          	sub    $0x40,%rsp
  802977:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80297a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80297d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802981:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802984:	48 89 d6             	mov    %rdx,%rsi
  802987:	89 c7                	mov    %eax,%edi
  802989:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
  802995:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299c:	79 08                	jns    8029a6 <dup+0x37>
		return r;
  80299e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a1:	e9 70 01 00 00       	jmpq   802b16 <dup+0x1a7>
	close(newfdnum);
  8029a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a9:	89 c7                	mov    %eax,%edi
  8029ab:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8029b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029ba:	48 98                	cltq   
  8029bc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029c2:	48 c1 e0 0c          	shl    $0xc,%rax
  8029c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ce:	48 89 c7             	mov    %rax,%rdi
  8029d1:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
  8029dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e5:	48 89 c7             	mov    %rax,%rdi
  8029e8:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
  8029f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	48 89 c2             	mov    %rax,%rdx
  8029ff:	48 c1 ea 15          	shr    $0x15,%rdx
  802a03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a0a:	01 00 00 
  802a0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a11:	83 e0 01             	and    $0x1,%eax
  802a14:	84 c0                	test   %al,%al
  802a16:	74 71                	je     802a89 <dup+0x11a>
  802a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1c:	48 89 c2             	mov    %rax,%rdx
  802a1f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a2a:	01 00 00 
  802a2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a31:	83 e0 01             	and    $0x1,%eax
  802a34:	84 c0                	test   %al,%al
  802a36:	74 51                	je     802a89 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3c:	48 89 c2             	mov    %rax,%rdx
  802a3f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a43:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a4a:	01 00 00 
  802a4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a51:	89 c1                	mov    %eax,%ecx
  802a53:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a61:	41 89 c8             	mov    %ecx,%r8d
  802a64:	48 89 d1             	mov    %rdx,%rcx
  802a67:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6c:	48 89 c6             	mov    %rax,%rsi
  802a6f:	bf 00 00 00 00       	mov    $0x0,%edi
  802a74:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a87:	78 56                	js     802adf <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8d:	48 89 c2             	mov    %rax,%rdx
  802a90:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a94:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a9b:	01 00 00 
  802a9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aa2:	89 c1                	mov    %eax,%ecx
  802aa4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ab2:	41 89 c8             	mov    %ecx,%r8d
  802ab5:	48 89 d1             	mov    %rdx,%rcx
  802ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  802abd:	48 89 c6             	mov    %rax,%rsi
  802ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac5:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  802acc:	00 00 00 
  802acf:	ff d0                	callq  *%rax
  802ad1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad8:	78 08                	js     802ae2 <dup+0x173>
		goto err;

	return newfdnum;
  802ada:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802add:	eb 37                	jmp    802b16 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802adf:	90                   	nop
  802ae0:	eb 01                	jmp    802ae3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ae2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ae3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae7:	48 89 c6             	mov    %rax,%rsi
  802aea:	bf 00 00 00 00       	mov    $0x0,%edi
  802aef:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802afb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aff:	48 89 c6             	mov    %rax,%rsi
  802b02:	bf 00 00 00 00       	mov    $0x0,%edi
  802b07:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  802b0e:	00 00 00 
  802b11:	ff d0                	callq  *%rax
	return r;
  802b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b16:	c9                   	leaveq 
  802b17:	c3                   	retq   

0000000000802b18 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b18:	55                   	push   %rbp
  802b19:	48 89 e5             	mov    %rsp,%rbp
  802b1c:	48 83 ec 40          	sub    $0x40,%rsp
  802b20:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b27:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b2b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b2f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b32:	48 89 d6             	mov    %rdx,%rsi
  802b35:	89 c7                	mov    %eax,%edi
  802b37:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
  802b43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4a:	78 24                	js     802b70 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b50:	8b 00                	mov    (%rax),%eax
  802b52:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b56:	48 89 d6             	mov    %rdx,%rsi
  802b59:	89 c7                	mov    %eax,%edi
  802b5b:	48 b8 3f 28 80 00 00 	movabs $0x80283f,%rax
  802b62:	00 00 00 
  802b65:	ff d0                	callq  *%rax
  802b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6e:	79 05                	jns    802b75 <read+0x5d>
		return r;
  802b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b73:	eb 7a                	jmp    802bef <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b79:	8b 40 08             	mov    0x8(%rax),%eax
  802b7c:	83 e0 03             	and    $0x3,%eax
  802b7f:	83 f8 01             	cmp    $0x1,%eax
  802b82:	75 3a                	jne    802bbe <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b84:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b8b:	00 00 00 
  802b8e:	48 8b 00             	mov    (%rax),%rax
  802b91:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b97:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b9a:	89 c6                	mov    %eax,%esi
  802b9c:	48 bf df 4e 80 00 00 	movabs $0x804edf,%rdi
  802ba3:	00 00 00 
  802ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bab:	48 b9 43 06 80 00 00 	movabs $0x800643,%rcx
  802bb2:	00 00 00 
  802bb5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bbc:	eb 31                	jmp    802bef <read+0xd7>
	}
	if (!dev->dev_read)
  802bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bc6:	48 85 c0             	test   %rax,%rax
  802bc9:	75 07                	jne    802bd2 <read+0xba>
		return -E_NOT_SUPP;
  802bcb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bd0:	eb 1d                	jmp    802bef <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bde:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802be2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802be6:	48 89 ce             	mov    %rcx,%rsi
  802be9:	48 89 c7             	mov    %rax,%rdi
  802bec:	41 ff d0             	callq  *%r8
}
  802bef:	c9                   	leaveq 
  802bf0:	c3                   	retq   

0000000000802bf1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bf1:	55                   	push   %rbp
  802bf2:	48 89 e5             	mov    %rsp,%rbp
  802bf5:	48 83 ec 30          	sub    $0x30,%rsp
  802bf9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c0b:	eb 46                	jmp    802c53 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c10:	48 98                	cltq   
  802c12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c16:	48 29 c2             	sub    %rax,%rdx
  802c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1c:	48 98                	cltq   
  802c1e:	48 89 c1             	mov    %rax,%rcx
  802c21:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802c25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c28:	48 89 ce             	mov    %rcx,%rsi
  802c2b:	89 c7                	mov    %eax,%edi
  802c2d:	48 b8 18 2b 80 00 00 	movabs $0x802b18,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
  802c39:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c3c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c40:	79 05                	jns    802c47 <readn+0x56>
			return m;
  802c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c45:	eb 1d                	jmp    802c64 <readn+0x73>
		if (m == 0)
  802c47:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c4b:	74 13                	je     802c60 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c50:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c56:	48 98                	cltq   
  802c58:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c5c:	72 af                	jb     802c0d <readn+0x1c>
  802c5e:	eb 01                	jmp    802c61 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c60:	90                   	nop
	}
	return tot;
  802c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c64:	c9                   	leaveq 
  802c65:	c3                   	retq   

0000000000802c66 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c66:	55                   	push   %rbp
  802c67:	48 89 e5             	mov    %rsp,%rbp
  802c6a:	48 83 ec 40          	sub    $0x40,%rsp
  802c6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c71:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c75:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c80:	48 89 d6             	mov    %rdx,%rsi
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
  802c91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c98:	78 24                	js     802cbe <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9e:	8b 00                	mov    (%rax),%eax
  802ca0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ca4:	48 89 d6             	mov    %rdx,%rsi
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	48 b8 3f 28 80 00 00 	movabs $0x80283f,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
  802cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbc:	79 05                	jns    802cc3 <write+0x5d>
		return r;
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	eb 79                	jmp    802d3c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc7:	8b 40 08             	mov    0x8(%rax),%eax
  802cca:	83 e0 03             	and    $0x3,%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	75 3a                	jne    802d0b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cd1:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802cd8:	00 00 00 
  802cdb:	48 8b 00             	mov    (%rax),%rax
  802cde:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ce7:	89 c6                	mov    %eax,%esi
  802ce9:	48 bf fb 4e 80 00 00 	movabs $0x804efb,%rdi
  802cf0:	00 00 00 
  802cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf8:	48 b9 43 06 80 00 00 	movabs $0x800643,%rcx
  802cff:	00 00 00 
  802d02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d09:	eb 31                	jmp    802d3c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d13:	48 85 c0             	test   %rax,%rax
  802d16:	75 07                	jne    802d1f <write+0xb9>
		return -E_NOT_SUPP;
  802d18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d1d:	eb 1d                	jmp    802d3c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d23:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d2f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d33:	48 89 ce             	mov    %rcx,%rsi
  802d36:	48 89 c7             	mov    %rax,%rdi
  802d39:	41 ff d0             	callq  *%r8
}
  802d3c:	c9                   	leaveq 
  802d3d:	c3                   	retq   

0000000000802d3e <seek>:

int
seek(int fdnum, off_t offset)
{
  802d3e:	55                   	push   %rbp
  802d3f:	48 89 e5             	mov    %rsp,%rbp
  802d42:	48 83 ec 18          	sub    $0x18,%rsp
  802d46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d49:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d53:	48 89 d6             	mov    %rdx,%rsi
  802d56:	89 c7                	mov    %eax,%edi
  802d58:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	callq  *%rax
  802d64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6b:	79 05                	jns    802d72 <seek+0x34>
		return r;
  802d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d70:	eb 0f                	jmp    802d81 <seek+0x43>
	fd->fd_offset = offset;
  802d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d76:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d81:	c9                   	leaveq 
  802d82:	c3                   	retq   

0000000000802d83 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d83:	55                   	push   %rbp
  802d84:	48 89 e5             	mov    %rsp,%rbp
  802d87:	48 83 ec 30          	sub    $0x30,%rsp
  802d8b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d8e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d91:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d95:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d98:	48 89 d6             	mov    %rdx,%rsi
  802d9b:	89 c7                	mov    %eax,%edi
  802d9d:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db0:	78 24                	js     802dd6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802db2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db6:	8b 00                	mov    (%rax),%eax
  802db8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dbc:	48 89 d6             	mov    %rdx,%rsi
  802dbf:	89 c7                	mov    %eax,%edi
  802dc1:	48 b8 3f 28 80 00 00 	movabs $0x80283f,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd4:	79 05                	jns    802ddb <ftruncate+0x58>
		return r;
  802dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd9:	eb 72                	jmp    802e4d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddf:	8b 40 08             	mov    0x8(%rax),%eax
  802de2:	83 e0 03             	and    $0x3,%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	75 3a                	jne    802e23 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802de9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802df0:	00 00 00 
  802df3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802df6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dfc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dff:	89 c6                	mov    %eax,%esi
  802e01:	48 bf 18 4f 80 00 00 	movabs $0x804f18,%rdi
  802e08:	00 00 00 
  802e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e10:	48 b9 43 06 80 00 00 	movabs $0x800643,%rcx
  802e17:	00 00 00 
  802e1a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e21:	eb 2a                	jmp    802e4d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e27:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e2b:	48 85 c0             	test   %rax,%rax
  802e2e:	75 07                	jne    802e37 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e35:	eb 16                	jmp    802e4d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802e3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e43:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e46:	89 d6                	mov    %edx,%esi
  802e48:	48 89 c7             	mov    %rax,%rdi
  802e4b:	ff d1                	callq  *%rcx
}
  802e4d:	c9                   	leaveq 
  802e4e:	c3                   	retq   

0000000000802e4f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e4f:	55                   	push   %rbp
  802e50:	48 89 e5             	mov    %rsp,%rbp
  802e53:	48 83 ec 30          	sub    $0x30,%rsp
  802e57:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e5e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e62:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e65:	48 89 d6             	mov    %rdx,%rsi
  802e68:	89 c7                	mov    %eax,%edi
  802e6a:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
  802e76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7d:	78 24                	js     802ea3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e83:	8b 00                	mov    (%rax),%eax
  802e85:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e89:	48 89 d6             	mov    %rdx,%rsi
  802e8c:	89 c7                	mov    %eax,%edi
  802e8e:	48 b8 3f 28 80 00 00 	movabs $0x80283f,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
  802e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea1:	79 05                	jns    802ea8 <fstat+0x59>
		return r;
  802ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea6:	eb 5e                	jmp    802f06 <fstat+0xb7>
	if (!dev->dev_stat)
  802ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eac:	48 8b 40 28          	mov    0x28(%rax),%rax
  802eb0:	48 85 c0             	test   %rax,%rax
  802eb3:	75 07                	jne    802ebc <fstat+0x6d>
		return -E_NOT_SUPP;
  802eb5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eba:	eb 4a                	jmp    802f06 <fstat+0xb7>
	stat->st_name[0] = 0;
  802ebc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ec3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ece:	00 00 00 
	stat->st_isdir = 0;
  802ed1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802edc:	00 00 00 
	stat->st_dev = dev;
  802edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ee3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ee7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802efe:	48 89 d6             	mov    %rdx,%rsi
  802f01:	48 89 c7             	mov    %rax,%rdi
  802f04:	ff d1                	callq  *%rcx
}
  802f06:	c9                   	leaveq 
  802f07:	c3                   	retq   

0000000000802f08 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 83 ec 20          	sub    $0x20,%rsp
  802f10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1c:	be 00 00 00 00       	mov    $0x0,%esi
  802f21:	48 89 c7             	mov    %rax,%rdi
  802f24:	48 b8 f7 2f 80 00 00 	movabs $0x802ff7,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f37:	79 05                	jns    802f3e <stat+0x36>
		return fd;
  802f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3c:	eb 2f                	jmp    802f6d <stat+0x65>
	r = fstat(fd, stat);
  802f3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	48 89 d6             	mov    %rdx,%rsi
  802f48:	89 c7                	mov    %eax,%edi
  802f4a:	48 b8 4f 2e 80 00 00 	movabs $0x802e4f,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5c:	89 c7                	mov    %eax,%edi
  802f5e:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
	return r;
  802f6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f6d:	c9                   	leaveq 
  802f6e:	c3                   	retq   
	...

0000000000802f70 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f70:	55                   	push   %rbp
  802f71:	48 89 e5             	mov    %rsp,%rbp
  802f74:	48 83 ec 10          	sub    $0x10,%rsp
  802f78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f7f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f86:	00 00 00 
  802f89:	8b 00                	mov    (%rax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	75 1d                	jne    802fac <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f8f:	bf 01 00 00 00       	mov    $0x1,%edi
  802f94:	48 b8 0e 46 80 00 00 	movabs $0x80460e,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
  802fa0:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802fa7:	00 00 00 
  802faa:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fb3:	00 00 00 
  802fb6:	8b 00                	mov    (%rax),%eax
  802fb8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fbb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fc0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802fc7:	00 00 00 
  802fca:	89 c7                	mov    %eax,%edi
  802fcc:	48 b8 5f 45 80 00 00 	movabs $0x80455f,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe1:	48 89 c6             	mov    %rax,%rsi
  802fe4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe9:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 20          	sub    $0x20,%rsp
  802fff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803003:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  803006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300a:	48 89 c7             	mov    %rax,%rdi
  80300d:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  803014:	00 00 00 
  803017:	ff d0                	callq  *%rax
  803019:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80301e:	7e 0a                	jle    80302a <open+0x33>
		return -E_BAD_PATH;
  803020:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803025:	e9 a5 00 00 00       	jmpq   8030cf <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80302a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80302e:	48 89 c7             	mov    %rax,%rdi
  803031:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803044:	79 08                	jns    80304e <open+0x57>
		return r;
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803049:	e9 81 00 00 00       	jmpq   8030cf <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80304e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803055:	00 00 00 
  803058:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80305b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803065:	48 89 c6             	mov    %rax,%rsi
  803068:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80306f:	00 00 00 
  803072:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80307e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803082:	48 89 c6             	mov    %rax,%rsi
  803085:	bf 01 00 00 00       	mov    $0x1,%edi
  80308a:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803099:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80309d:	79 1d                	jns    8030bc <open+0xc5>
		fd_close(new_fd, 0);
  80309f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a3:	be 00 00 00 00       	mov    $0x0,%esi
  8030a8:	48 89 c7             	mov    %rax,%rdi
  8030ab:	48 b8 76 27 80 00 00 	movabs $0x802776,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	callq  *%rax
		return r;	
  8030b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ba:	eb 13                	jmp    8030cf <open+0xd8>
	}
	return fd2num(new_fd);
  8030bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c0:	48 89 c7             	mov    %rax,%rdi
  8030c3:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  8030ca:	00 00 00 
  8030cd:	ff d0                	callq  *%rax
}
  8030cf:	c9                   	leaveq 
  8030d0:	c3                   	retq   

00000000008030d1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030d1:	55                   	push   %rbp
  8030d2:	48 89 e5             	mov    %rsp,%rbp
  8030d5:	48 83 ec 10          	sub    $0x10,%rsp
  8030d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030eb:	00 00 00 
  8030ee:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030f0:	be 00 00 00 00       	mov    $0x0,%esi
  8030f5:	bf 06 00 00 00       	mov    $0x6,%edi
  8030fa:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 30          	sub    $0x30,%rsp
  803110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803118:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  80311c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803120:	8b 50 0c             	mov    0xc(%rax),%edx
  803123:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312a:	00 00 00 
  80312d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80312f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803136:	00 00 00 
  803139:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80313d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  803141:	be 00 00 00 00       	mov    $0x0,%esi
  803146:	bf 03 00 00 00       	mov    $0x3,%edi
  80314b:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  80315a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315e:	7e 23                	jle    803183 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  803160:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803163:	48 63 d0             	movslq %eax,%rdx
  803166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80316a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803171:	00 00 00 
  803174:	48 89 c7             	mov    %rax,%rdi
  803177:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  80317e:	00 00 00 
  803181:	ff d0                	callq  *%rax
	}
	return nbytes;
  803183:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803186:	c9                   	leaveq 
  803187:	c3                   	retq   

0000000000803188 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803188:	55                   	push   %rbp
  803189:	48 89 e5             	mov    %rsp,%rbp
  80318c:	48 83 ec 20          	sub    $0x20,%rsp
  803190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319c:	8b 50 0c             	mov    0xc(%rax),%edx
  80319f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031a6:	00 00 00 
  8031a9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031ab:	be 00 00 00 00       	mov    $0x0,%esi
  8031b0:	bf 05 00 00 00       	mov    $0x5,%edi
  8031b5:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
  8031c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c8:	79 05                	jns    8031cf <devfile_stat+0x47>
		return r;
  8031ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cd:	eb 56                	jmp    803225 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031da:	00 00 00 
  8031dd:	48 89 c7             	mov    %rax,%rdi
  8031e0:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f3:	00 00 00 
  8031f6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803200:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803206:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320d:	00 00 00 
  803210:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803220:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803225:	c9                   	leaveq 
  803226:	c3                   	retq   
	...

0000000000803228 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803228:	55                   	push   %rbp
  803229:	48 89 e5             	mov    %rsp,%rbp
  80322c:	48 83 ec 20          	sub    $0x20,%rsp
  803230:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803233:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803237:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80323a:	48 89 d6             	mov    %rdx,%rsi
  80323d:	89 c7                	mov    %eax,%edi
  80323f:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803252:	79 05                	jns    803259 <fd2sockid+0x31>
		return r;
  803254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803257:	eb 24                	jmp    80327d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325d:	8b 10                	mov    (%rax),%edx
  80325f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803266:	00 00 00 
  803269:	8b 00                	mov    (%rax),%eax
  80326b:	39 c2                	cmp    %eax,%edx
  80326d:	74 07                	je     803276 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80326f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803274:	eb 07                	jmp    80327d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803276:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80327d:	c9                   	leaveq 
  80327e:	c3                   	retq   

000000000080327f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80327f:	55                   	push   %rbp
  803280:	48 89 e5             	mov    %rsp,%rbp
  803283:	48 83 ec 20          	sub    $0x20,%rsp
  803287:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80328a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80328e:	48 89 c7             	mov    %rax,%rdi
  803291:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
  80329d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a4:	78 26                	js     8032cc <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8032af:	48 89 c6             	mov    %rax,%rsi
  8032b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b7:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ca:	79 16                	jns    8032e2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032cf:	89 c7                	mov    %eax,%edi
  8032d1:	48 b8 8c 37 80 00 00 	movabs $0x80378c,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
		return r;
  8032dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e0:	eb 3a                	jmp    80331c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032ed:	00 00 00 
  8032f0:	8b 12                	mov    (%rdx),%edx
  8032f2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803303:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803306:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330d:	48 89 c7             	mov    %rax,%rdi
  803310:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
}
  80331c:	c9                   	leaveq 
  80331d:	c3                   	retq   

000000000080331e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80331e:	55                   	push   %rbp
  80331f:	48 89 e5             	mov    %rsp,%rbp
  803322:	48 83 ec 30          	sub    $0x30,%rsp
  803326:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80332d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803334:	89 c7                	mov    %eax,%edi
  803336:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax
  803342:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803345:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803349:	79 05                	jns    803350 <accept+0x32>
		return r;
  80334b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334e:	eb 3b                	jmp    80338b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803350:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803354:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335b:	48 89 ce             	mov    %rcx,%rsi
  80335e:	89 c7                	mov    %eax,%edi
  803360:	48 b8 69 36 80 00 00 	movabs $0x803669,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803373:	79 05                	jns    80337a <accept+0x5c>
		return r;
  803375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803378:	eb 11                	jmp    80338b <accept+0x6d>
	return alloc_sockfd(r);
  80337a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
}
  80338b:	c9                   	leaveq 
  80338c:	c3                   	retq   

000000000080338d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80338d:	55                   	push   %rbp
  80338e:	48 89 e5             	mov    %rsp,%rbp
  803391:	48 83 ec 20          	sub    $0x20,%rsp
  803395:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803398:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80339f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a2:	89 c7                	mov    %eax,%edi
  8033a4:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  8033ab:	00 00 00 
  8033ae:	ff d0                	callq  *%rax
  8033b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b7:	79 05                	jns    8033be <bind+0x31>
		return r;
  8033b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033bc:	eb 1b                	jmp    8033d9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033c1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c8:	48 89 ce             	mov    %rcx,%rsi
  8033cb:	89 c7                	mov    %eax,%edi
  8033cd:	48 b8 e8 36 80 00 00 	movabs $0x8036e8,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
}
  8033d9:	c9                   	leaveq 
  8033da:	c3                   	retq   

00000000008033db <shutdown>:

int
shutdown(int s, int how)
{
  8033db:	55                   	push   %rbp
  8033dc:	48 89 e5             	mov    %rsp,%rbp
  8033df:	48 83 ec 20          	sub    $0x20,%rsp
  8033e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ec:	89 c7                	mov    %eax,%edi
  8033ee:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  8033f5:	00 00 00 
  8033f8:	ff d0                	callq  *%rax
  8033fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803401:	79 05                	jns    803408 <shutdown+0x2d>
		return r;
  803403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803406:	eb 16                	jmp    80341e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803408:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80340b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340e:	89 d6                	mov    %edx,%esi
  803410:	89 c7                	mov    %eax,%edi
  803412:	48 b8 4c 37 80 00 00 	movabs $0x80374c,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
}
  80341e:	c9                   	leaveq 
  80341f:	c3                   	retq   

0000000000803420 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803420:	55                   	push   %rbp
  803421:	48 89 e5             	mov    %rsp,%rbp
  803424:	48 83 ec 10          	sub    $0x10,%rsp
  803428:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80342c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803430:	48 89 c7             	mov    %rax,%rdi
  803433:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
  80343f:	83 f8 01             	cmp    $0x1,%eax
  803442:	75 17                	jne    80345b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803448:	8b 40 0c             	mov    0xc(%rax),%eax
  80344b:	89 c7                	mov    %eax,%edi
  80344d:	48 b8 8c 37 80 00 00 	movabs $0x80378c,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	eb 05                	jmp    803460 <devsock_close+0x40>
	else
		return 0;
  80345b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803460:	c9                   	leaveq 
  803461:	c3                   	retq   

0000000000803462 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803462:	55                   	push   %rbp
  803463:	48 89 e5             	mov    %rsp,%rbp
  803466:	48 83 ec 20          	sub    $0x20,%rsp
  80346a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80346d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803471:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803474:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803477:	89 c7                	mov    %eax,%edi
  803479:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  803480:	00 00 00 
  803483:	ff d0                	callq  *%rax
  803485:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348c:	79 05                	jns    803493 <connect+0x31>
		return r;
  80348e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803491:	eb 1b                	jmp    8034ae <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803493:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803496:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80349a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349d:	48 89 ce             	mov    %rcx,%rsi
  8034a0:	89 c7                	mov    %eax,%edi
  8034a2:	48 b8 b9 37 80 00 00 	movabs $0x8037b9,%rax
  8034a9:	00 00 00 
  8034ac:	ff d0                	callq  *%rax
}
  8034ae:	c9                   	leaveq 
  8034af:	c3                   	retq   

00000000008034b0 <listen>:

int
listen(int s, int backlog)
{
  8034b0:	55                   	push   %rbp
  8034b1:	48 89 e5             	mov    %rsp,%rbp
  8034b4:	48 83 ec 20          	sub    $0x20,%rsp
  8034b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034bb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c1:	89 c7                	mov    %eax,%edi
  8034c3:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	callq  *%rax
  8034cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d6:	79 05                	jns    8034dd <listen+0x2d>
		return r;
  8034d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034db:	eb 16                	jmp    8034f3 <listen+0x43>
	return nsipc_listen(r, backlog);
  8034dd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e3:	89 d6                	mov    %edx,%esi
  8034e5:	89 c7                	mov    %eax,%edi
  8034e7:	48 b8 1d 38 80 00 00 	movabs $0x80381d,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
}
  8034f3:	c9                   	leaveq 
  8034f4:	c3                   	retq   

00000000008034f5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034f5:	55                   	push   %rbp
  8034f6:	48 89 e5             	mov    %rsp,%rbp
  8034f9:	48 83 ec 20          	sub    $0x20,%rsp
  8034fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803501:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803505:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350d:	89 c2                	mov    %eax,%edx
  80350f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803513:	8b 40 0c             	mov    0xc(%rax),%eax
  803516:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80351a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80351f:	89 c7                	mov    %eax,%edi
  803521:	48 b8 5d 38 80 00 00 	movabs $0x80385d,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
}
  80352d:	c9                   	leaveq 
  80352e:	c3                   	retq   

000000000080352f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80352f:	55                   	push   %rbp
  803530:	48 89 e5             	mov    %rsp,%rbp
  803533:	48 83 ec 20          	sub    $0x20,%rsp
  803537:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80353b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80353f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803547:	89 c2                	mov    %eax,%edx
  803549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354d:	8b 40 0c             	mov    0xc(%rax),%eax
  803550:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803554:	b9 00 00 00 00       	mov    $0x0,%ecx
  803559:	89 c7                	mov    %eax,%edi
  80355b:	48 b8 29 39 80 00 00 	movabs $0x803929,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
}
  803567:	c9                   	leaveq 
  803568:	c3                   	retq   

0000000000803569 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803569:	55                   	push   %rbp
  80356a:	48 89 e5             	mov    %rsp,%rbp
  80356d:	48 83 ec 10          	sub    $0x10,%rsp
  803571:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803575:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357d:	48 be 43 4f 80 00 00 	movabs $0x804f43,%rsi
  803584:	00 00 00 
  803587:	48 89 c7             	mov    %rax,%rdi
  80358a:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
	return 0;
  803596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80359b:	c9                   	leaveq 
  80359c:	c3                   	retq   

000000000080359d <socket>:

int
socket(int domain, int type, int protocol)
{
  80359d:	55                   	push   %rbp
  80359e:	48 89 e5             	mov    %rsp,%rbp
  8035a1:	48 83 ec 20          	sub    $0x20,%rsp
  8035a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035ab:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035ae:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035b1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b7:	89 ce                	mov    %ecx,%esi
  8035b9:	89 c7                	mov    %eax,%edi
  8035bb:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  8035c2:	00 00 00 
  8035c5:	ff d0                	callq  *%rax
  8035c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ce:	79 05                	jns    8035d5 <socket+0x38>
		return r;
  8035d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d3:	eb 11                	jmp    8035e6 <socket+0x49>
	return alloc_sockfd(r);
  8035d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d8:	89 c7                	mov    %eax,%edi
  8035da:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
}
  8035e6:	c9                   	leaveq 
  8035e7:	c3                   	retq   

00000000008035e8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035e8:	55                   	push   %rbp
  8035e9:	48 89 e5             	mov    %rsp,%rbp
  8035ec:	48 83 ec 10          	sub    $0x10,%rsp
  8035f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035f3:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035fa:	00 00 00 
  8035fd:	8b 00                	mov    (%rax),%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	75 1d                	jne    803620 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803603:	bf 02 00 00 00       	mov    $0x2,%edi
  803608:	48 b8 0e 46 80 00 00 	movabs $0x80460e,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
  803614:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80361b:	00 00 00 
  80361e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803620:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803627:	00 00 00 
  80362a:	8b 00                	mov    (%rax),%eax
  80362c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80362f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803634:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80363b:	00 00 00 
  80363e:	89 c7                	mov    %eax,%edi
  803640:	48 b8 5f 45 80 00 00 	movabs $0x80455f,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80364c:	ba 00 00 00 00       	mov    $0x0,%edx
  803651:	be 00 00 00 00       	mov    $0x0,%esi
  803656:	bf 00 00 00 00       	mov    $0x0,%edi
  80365b:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
}
  803667:	c9                   	leaveq 
  803668:	c3                   	retq   

0000000000803669 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803669:	55                   	push   %rbp
  80366a:	48 89 e5             	mov    %rsp,%rbp
  80366d:	48 83 ec 30          	sub    $0x30,%rsp
  803671:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80367c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803683:	00 00 00 
  803686:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803689:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80368b:	bf 01 00 00 00       	mov    $0x1,%edi
  803690:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
  80369c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a3:	78 3e                	js     8036e3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8036a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ac:	00 00 00 
  8036af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b7:	8b 40 10             	mov    0x10(%rax),%eax
  8036ba:	89 c2                	mov    %eax,%edx
  8036bc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c4:	48 89 ce             	mov    %rcx,%rsi
  8036c7:	48 89 c7             	mov    %rax,%rdi
  8036ca:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036da:	8b 50 10             	mov    0x10(%rax),%edx
  8036dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036e6:	c9                   	leaveq 
  8036e7:	c3                   	retq   

00000000008036e8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036e8:	55                   	push   %rbp
  8036e9:	48 89 e5             	mov    %rsp,%rbp
  8036ec:	48 83 ec 10          	sub    $0x10,%rsp
  8036f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803701:	00 00 00 
  803704:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803707:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803709:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80370c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803710:	48 89 c6             	mov    %rax,%rsi
  803713:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80371a:	00 00 00 
  80371d:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803729:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803730:	00 00 00 
  803733:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803736:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803739:	bf 02 00 00 00       	mov    $0x2,%edi
  80373e:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 10          	sub    $0x10,%rsp
  803754:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803757:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80375a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803761:	00 00 00 
  803764:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803767:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803769:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803770:	00 00 00 
  803773:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803776:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803779:	bf 03 00 00 00       	mov    $0x3,%edi
  80377e:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
}
  80378a:	c9                   	leaveq 
  80378b:	c3                   	retq   

000000000080378c <nsipc_close>:

int
nsipc_close(int s)
{
  80378c:	55                   	push   %rbp
  80378d:	48 89 e5             	mov    %rsp,%rbp
  803790:	48 83 ec 10          	sub    $0x10,%rsp
  803794:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803797:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379e:	00 00 00 
  8037a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8037a6:	bf 04 00 00 00       	mov    $0x4,%edi
  8037ab:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
}
  8037b7:	c9                   	leaveq 
  8037b8:	c3                   	retq   

00000000008037b9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037b9:	55                   	push   %rbp
  8037ba:	48 89 e5             	mov    %rsp,%rbp
  8037bd:	48 83 ec 10          	sub    $0x10,%rsp
  8037c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037c8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d2:	00 00 00 
  8037d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037d8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037da:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e1:	48 89 c6             	mov    %rax,%rsi
  8037e4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037eb:	00 00 00 
  8037ee:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803801:	00 00 00 
  803804:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803807:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80380a:	bf 05 00 00 00       	mov    $0x5,%edi
  80380f:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
}
  80381b:	c9                   	leaveq 
  80381c:	c3                   	retq   

000000000080381d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80381d:	55                   	push   %rbp
  80381e:	48 89 e5             	mov    %rsp,%rbp
  803821:	48 83 ec 10          	sub    $0x10,%rsp
  803825:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803828:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80382b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803832:	00 00 00 
  803835:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803838:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80383a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803841:	00 00 00 
  803844:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803847:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80384a:	bf 06 00 00 00       	mov    $0x6,%edi
  80384f:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
}
  80385b:	c9                   	leaveq 
  80385c:	c3                   	retq   

000000000080385d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
  803861:	48 83 ec 30          	sub    $0x30,%rsp
  803865:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803868:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80386c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80386f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803872:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803879:	00 00 00 
  80387c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80387f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803881:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803888:	00 00 00 
  80388b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80388e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803891:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803898:	00 00 00 
  80389b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80389e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038a1:	bf 07 00 00 00       	mov    $0x7,%edi
  8038a6:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  8038ad:	00 00 00 
  8038b0:	ff d0                	callq  *%rax
  8038b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b9:	78 69                	js     803924 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038bb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038c2:	7f 08                	jg     8038cc <nsipc_recv+0x6f>
  8038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038ca:	7e 35                	jle    803901 <nsipc_recv+0xa4>
  8038cc:	48 b9 4a 4f 80 00 00 	movabs $0x804f4a,%rcx
  8038d3:	00 00 00 
  8038d6:	48 ba 5f 4f 80 00 00 	movabs $0x804f5f,%rdx
  8038dd:	00 00 00 
  8038e0:	be 61 00 00 00       	mov    $0x61,%esi
  8038e5:	48 bf 74 4f 80 00 00 	movabs $0x804f74,%rdi
  8038ec:	00 00 00 
  8038ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f4:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  8038fb:	00 00 00 
  8038fe:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803904:	48 63 d0             	movslq %eax,%rdx
  803907:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803912:	00 00 00 
  803915:	48 89 c7             	mov    %rax,%rdi
  803918:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
	}

	return r;
  803924:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803927:	c9                   	leaveq 
  803928:	c3                   	retq   

0000000000803929 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803929:	55                   	push   %rbp
  80392a:	48 89 e5             	mov    %rsp,%rbp
  80392d:	48 83 ec 20          	sub    $0x20,%rsp
  803931:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803934:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803938:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80393b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80393e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803945:	00 00 00 
  803948:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80394d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803954:	7e 35                	jle    80398b <nsipc_send+0x62>
  803956:	48 b9 80 4f 80 00 00 	movabs $0x804f80,%rcx
  80395d:	00 00 00 
  803960:	48 ba 5f 4f 80 00 00 	movabs $0x804f5f,%rdx
  803967:	00 00 00 
  80396a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80396f:	48 bf 74 4f 80 00 00 	movabs $0x804f74,%rdi
  803976:	00 00 00 
  803979:	b8 00 00 00 00       	mov    $0x0,%eax
  80397e:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  803985:	00 00 00 
  803988:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80398b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80398e:	48 63 d0             	movslq %eax,%rdx
  803991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803995:	48 89 c6             	mov    %rax,%rsi
  803998:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80399f:	00 00 00 
  8039a2:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b5:	00 00 00 
  8039b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c5:	00 00 00 
  8039c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039cb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039ce:	bf 08 00 00 00       	mov    $0x8,%edi
  8039d3:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
}
  8039df:	c9                   	leaveq 
  8039e0:	c3                   	retq   

00000000008039e1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039e1:	55                   	push   %rbp
  8039e2:	48 89 e5             	mov    %rsp,%rbp
  8039e5:	48 83 ec 10          	sub    $0x10,%rsp
  8039e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039ec:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039ef:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039f9:	00 00 00 
  8039fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a01:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a08:	00 00 00 
  803a0b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a0e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a18:	00 00 00 
  803a1b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a1e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a21:	bf 09 00 00 00       	mov    $0x9,%edi
  803a26:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
}
  803a32:	c9                   	leaveq 
  803a33:	c3                   	retq   

0000000000803a34 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a34:	55                   	push   %rbp
  803a35:	48 89 e5             	mov    %rsp,%rbp
  803a38:	53                   	push   %rbx
  803a39:	48 83 ec 38          	sub    $0x38,%rsp
  803a3d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a41:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a45:	48 89 c7             	mov    %rax,%rdi
  803a48:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  803a4f:	00 00 00 
  803a52:	ff d0                	callq  *%rax
  803a54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a57:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a5b:	0f 88 bf 01 00 00    	js     803c20 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a65:	ba 07 04 00 00       	mov    $0x407,%edx
  803a6a:	48 89 c6             	mov    %rax,%rsi
  803a6d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a72:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a81:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a85:	0f 88 95 01 00 00    	js     803c20 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a8b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a8f:	48 89 c7             	mov    %rax,%rdi
  803a92:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aa5:	0f 88 5d 01 00 00    	js     803c08 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaf:	ba 07 04 00 00       	mov    $0x407,%edx
  803ab4:	48 89 c6             	mov    %rax,%rsi
  803ab7:	bf 00 00 00 00       	mov    $0x0,%edi
  803abc:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  803ac3:	00 00 00 
  803ac6:	ff d0                	callq  *%rax
  803ac8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803acb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803acf:	0f 88 33 01 00 00    	js     803c08 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad9:	48 89 c7             	mov    %rax,%rdi
  803adc:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803ae3:	00 00 00 
  803ae6:	ff d0                	callq  *%rax
  803ae8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af0:	ba 07 04 00 00       	mov    $0x407,%edx
  803af5:	48 89 c6             	mov    %rax,%rsi
  803af8:	bf 00 00 00 00       	mov    $0x0,%edi
  803afd:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  803b04:	00 00 00 
  803b07:	ff d0                	callq  *%rax
  803b09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b10:	0f 88 d9 00 00 00    	js     803bef <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1a:	48 89 c7             	mov    %rax,%rdi
  803b1d:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	callq  *%rax
  803b29:	48 89 c2             	mov    %rax,%rdx
  803b2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b30:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b36:	48 89 d1             	mov    %rdx,%rcx
  803b39:	ba 00 00 00 00       	mov    $0x0,%edx
  803b3e:	48 89 c6             	mov    %rax,%rsi
  803b41:	bf 00 00 00 00       	mov    $0x0,%edi
  803b46:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  803b4d:	00 00 00 
  803b50:	ff d0                	callq  *%rax
  803b52:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b59:	78 79                	js     803bd4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b5f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b66:	00 00 00 
  803b69:	8b 12                	mov    (%rdx),%edx
  803b6b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b7c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b83:	00 00 00 
  803b86:	8b 12                	mov    (%rdx),%edx
  803b88:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
  803ba8:	89 c2                	mov    %eax,%edx
  803baa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bb4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbc:	48 89 c7             	mov    %rax,%rdi
  803bbf:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803bc6:	00 00 00 
  803bc9:	ff d0                	callq  *%rax
  803bcb:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd2:	eb 4f                	jmp    803c23 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803bd4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803bd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd9:	48 89 c6             	mov    %rax,%rsi
  803bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  803be1:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
  803bed:	eb 01                	jmp    803bf0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803bef:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803bf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf4:	48 89 c6             	mov    %rax,%rsi
  803bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfc:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c0c:	48 89 c6             	mov    %rax,%rsi
  803c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c14:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
err:
	return r;
  803c20:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c23:	48 83 c4 38          	add    $0x38,%rsp
  803c27:	5b                   	pop    %rbx
  803c28:	5d                   	pop    %rbp
  803c29:	c3                   	retq   

0000000000803c2a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c2a:	55                   	push   %rbp
  803c2b:	48 89 e5             	mov    %rsp,%rbp
  803c2e:	53                   	push   %rbx
  803c2f:	48 83 ec 28          	sub    $0x28,%rsp
  803c33:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c37:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c3b:	eb 01                	jmp    803c3e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c3d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c3e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803c45:	00 00 00 
  803c48:	48 8b 00             	mov    (%rax),%rax
  803c4b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c51:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c58:	48 89 c7             	mov    %rax,%rdi
  803c5b:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
  803c67:	89 c3                	mov    %eax,%ebx
  803c69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c6d:	48 89 c7             	mov    %rax,%rdi
  803c70:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	39 c3                	cmp    %eax,%ebx
  803c7e:	0f 94 c0             	sete   %al
  803c81:	0f b6 c0             	movzbl %al,%eax
  803c84:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c87:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803c8e:	00 00 00 
  803c91:	48 8b 00             	mov    (%rax),%rax
  803c94:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c9a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ca0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ca3:	75 0a                	jne    803caf <_pipeisclosed+0x85>
			return ret;
  803ca5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803ca8:	48 83 c4 28          	add    $0x28,%rsp
  803cac:	5b                   	pop    %rbx
  803cad:	5d                   	pop    %rbp
  803cae:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803caf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cb5:	74 86                	je     803c3d <_pipeisclosed+0x13>
  803cb7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cbb:	75 80                	jne    803c3d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cbd:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cc4:	00 00 00 
  803cc7:	48 8b 00             	mov    (%rax),%rax
  803cca:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803cd0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd6:	89 c6                	mov    %eax,%esi
  803cd8:	48 bf 91 4f 80 00 00 	movabs $0x804f91,%rdi
  803cdf:	00 00 00 
  803ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce7:	49 b8 43 06 80 00 00 	movabs $0x800643,%r8
  803cee:	00 00 00 
  803cf1:	41 ff d0             	callq  *%r8
	}
  803cf4:	e9 44 ff ff ff       	jmpq   803c3d <_pipeisclosed+0x13>

0000000000803cf9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803cf9:	55                   	push   %rbp
  803cfa:	48 89 e5             	mov    %rsp,%rbp
  803cfd:	48 83 ec 30          	sub    $0x30,%rsp
  803d01:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d04:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d08:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d0b:	48 89 d6             	mov    %rdx,%rsi
  803d0e:	89 c7                	mov    %eax,%edi
  803d10:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d23:	79 05                	jns    803d2a <pipeisclosed+0x31>
		return r;
  803d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d28:	eb 31                	jmp    803d5b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2e:	48 89 c7             	mov    %rax,%rdi
  803d31:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803d38:	00 00 00 
  803d3b:	ff d0                	callq  *%rax
  803d3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d49:	48 89 d6             	mov    %rdx,%rsi
  803d4c:	48 89 c7             	mov    %rax,%rdi
  803d4f:	48 b8 2a 3c 80 00 00 	movabs $0x803c2a,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
}
  803d5b:	c9                   	leaveq 
  803d5c:	c3                   	retq   

0000000000803d5d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d5d:	55                   	push   %rbp
  803d5e:	48 89 e5             	mov    %rsp,%rbp
  803d61:	48 83 ec 40          	sub    $0x40,%rsp
  803d65:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d69:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d6d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d90:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d97:	00 
  803d98:	e9 97 00 00 00       	jmpq   803e34 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d9d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803da2:	74 09                	je     803dad <devpipe_read+0x50>
				return i;
  803da4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da8:	e9 95 00 00 00       	jmpq   803e42 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803db1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803db5:	48 89 d6             	mov    %rdx,%rsi
  803db8:	48 89 c7             	mov    %rax,%rdi
  803dbb:	48 b8 2a 3c 80 00 00 	movabs $0x803c2a,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
  803dc7:	85 c0                	test   %eax,%eax
  803dc9:	74 07                	je     803dd2 <devpipe_read+0x75>
				return 0;
  803dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd0:	eb 70                	jmp    803e42 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803dd2:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
  803dde:	eb 01                	jmp    803de1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803de0:	90                   	nop
  803de1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de5:	8b 10                	mov    (%rax),%edx
  803de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803deb:	8b 40 04             	mov    0x4(%rax),%eax
  803dee:	39 c2                	cmp    %eax,%edx
  803df0:	74 ab                	je     803d9d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dfa:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e02:	8b 00                	mov    (%rax),%eax
  803e04:	89 c2                	mov    %eax,%edx
  803e06:	c1 fa 1f             	sar    $0x1f,%edx
  803e09:	c1 ea 1b             	shr    $0x1b,%edx
  803e0c:	01 d0                	add    %edx,%eax
  803e0e:	83 e0 1f             	and    $0x1f,%eax
  803e11:	29 d0                	sub    %edx,%eax
  803e13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e17:	48 98                	cltq   
  803e19:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e1e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e24:	8b 00                	mov    (%rax),%eax
  803e26:	8d 50 01             	lea    0x1(%rax),%edx
  803e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e2f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e38:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e3c:	72 a2                	jb     803de0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e42:	c9                   	leaveq 
  803e43:	c3                   	retq   

0000000000803e44 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 83 ec 40          	sub    $0x40,%rsp
  803e4c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e50:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e54:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5c:	48 89 c7             	mov    %rax,%rdi
  803e5f:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803e66:	00 00 00 
  803e69:	ff d0                	callq  *%rax
  803e6b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e77:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e7e:	00 
  803e7f:	e9 93 00 00 00       	jmpq   803f17 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e8c:	48 89 d6             	mov    %rdx,%rsi
  803e8f:	48 89 c7             	mov    %rax,%rdi
  803e92:	48 b8 2a 3c 80 00 00 	movabs $0x803c2a,%rax
  803e99:	00 00 00 
  803e9c:	ff d0                	callq  *%rax
  803e9e:	85 c0                	test   %eax,%eax
  803ea0:	74 07                	je     803ea9 <devpipe_write+0x65>
				return 0;
  803ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea7:	eb 7c                	jmp    803f25 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ea9:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	eb 01                	jmp    803eb8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803eb7:	90                   	nop
  803eb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebc:	8b 40 04             	mov    0x4(%rax),%eax
  803ebf:	48 63 d0             	movslq %eax,%rdx
  803ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec6:	8b 00                	mov    (%rax),%eax
  803ec8:	48 98                	cltq   
  803eca:	48 83 c0 20          	add    $0x20,%rax
  803ece:	48 39 c2             	cmp    %rax,%rdx
  803ed1:	73 b1                	jae    803e84 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed7:	8b 40 04             	mov    0x4(%rax),%eax
  803eda:	89 c2                	mov    %eax,%edx
  803edc:	c1 fa 1f             	sar    $0x1f,%edx
  803edf:	c1 ea 1b             	shr    $0x1b,%edx
  803ee2:	01 d0                	add    %edx,%eax
  803ee4:	83 e0 1f             	and    $0x1f,%eax
  803ee7:	29 d0                	sub    %edx,%eax
  803ee9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803eed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ef1:	48 01 ca             	add    %rcx,%rdx
  803ef4:	0f b6 0a             	movzbl (%rdx),%ecx
  803ef7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803efb:	48 98                	cltq   
  803efd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f05:	8b 40 04             	mov    0x4(%rax),%eax
  803f08:	8d 50 01             	lea    0x1(%rax),%edx
  803f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f12:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f1f:	72 96                	jb     803eb7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f25:	c9                   	leaveq 
  803f26:	c3                   	retq   

0000000000803f27 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f27:	55                   	push   %rbp
  803f28:	48 89 e5             	mov    %rsp,%rbp
  803f2b:	48 83 ec 20          	sub    $0x20,%rsp
  803f2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3b:	48 89 c7             	mov    %rax,%rdi
  803f3e:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803f45:	00 00 00 
  803f48:	ff d0                	callq  *%rax
  803f4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f52:	48 be a4 4f 80 00 00 	movabs $0x804fa4,%rsi
  803f59:	00 00 00 
  803f5c:	48 89 c7             	mov    %rax,%rdi
  803f5f:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  803f66:	00 00 00 
  803f69:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6f:	8b 50 04             	mov    0x4(%rax),%edx
  803f72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f76:	8b 00                	mov    (%rax),%eax
  803f78:	29 c2                	sub    %eax,%edx
  803f7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f7e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f88:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f8f:	00 00 00 
	stat->st_dev = &devpipe;
  803f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f96:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803f9d:	00 00 00 
  803fa0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   

0000000000803fae <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fae:	55                   	push   %rbp
  803faf:	48 89 e5             	mov    %rsp,%rbp
  803fb2:	48 83 ec 10          	sub    $0x10,%rsp
  803fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fbe:	48 89 c6             	mov    %rax,%rsi
  803fc1:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc6:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd6:	48 89 c7             	mov    %rax,%rdi
  803fd9:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  803fe0:	00 00 00 
  803fe3:	ff d0                	callq  *%rax
  803fe5:	48 89 c6             	mov    %rax,%rsi
  803fe8:	bf 00 00 00 00       	mov    $0x0,%edi
  803fed:	48 b8 f7 1b 80 00 00 	movabs $0x801bf7,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
}
  803ff9:	c9                   	leaveq 
  803ffa:	c3                   	retq   
	...

0000000000803ffc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803ffc:	55                   	push   %rbp
  803ffd:	48 89 e5             	mov    %rsp,%rbp
  804000:	48 83 ec 20          	sub    $0x20,%rsp
  804004:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804007:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80400b:	75 35                	jne    804042 <wait+0x46>
  80400d:	48 b9 ab 4f 80 00 00 	movabs $0x804fab,%rcx
  804014:	00 00 00 
  804017:	48 ba b6 4f 80 00 00 	movabs $0x804fb6,%rdx
  80401e:	00 00 00 
  804021:	be 09 00 00 00       	mov    $0x9,%esi
  804026:	48 bf cb 4f 80 00 00 	movabs $0x804fcb,%rdi
  80402d:	00 00 00 
  804030:	b8 00 00 00 00       	mov    $0x0,%eax
  804035:	49 b8 08 04 80 00 00 	movabs $0x800408,%r8
  80403c:	00 00 00 
  80403f:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804042:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804045:	48 98                	cltq   
  804047:	48 89 c2             	mov    %rax,%rdx
  80404a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804050:	48 89 d0             	mov    %rdx,%rax
  804053:	48 c1 e0 02          	shl    $0x2,%rax
  804057:	48 01 d0             	add    %rdx,%rax
  80405a:	48 01 c0             	add    %rax,%rax
  80405d:	48 01 d0             	add    %rdx,%rax
  804060:	48 c1 e0 05          	shl    $0x5,%rax
  804064:	48 89 c2             	mov    %rax,%rdx
  804067:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80406e:	00 00 00 
  804071:	48 01 d0             	add    %rdx,%rax
  804074:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804078:	eb 0c                	jmp    804086 <wait+0x8a>
		sys_yield();
  80407a:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804090:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804093:	75 0e                	jne    8040a3 <wait+0xa7>
  804095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804099:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80409f:	85 c0                	test   %eax,%eax
  8040a1:	75 d7                	jne    80407a <wait+0x7e>
		sys_yield();
}
  8040a3:	c9                   	leaveq 
  8040a4:	c3                   	retq   
  8040a5:	00 00                	add    %al,(%rax)
	...

00000000008040a8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040a8:	55                   	push   %rbp
  8040a9:	48 89 e5             	mov    %rsp,%rbp
  8040ac:	48 83 ec 20          	sub    $0x20,%rsp
  8040b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8040b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040b6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040b9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8040bd:	be 01 00 00 00       	mov    $0x1,%esi
  8040c2:	48 89 c7             	mov    %rax,%rdi
  8040c5:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  8040cc:	00 00 00 
  8040cf:	ff d0                	callq  *%rax
}
  8040d1:	c9                   	leaveq 
  8040d2:	c3                   	retq   

00000000008040d3 <getchar>:

int
getchar(void)
{
  8040d3:	55                   	push   %rbp
  8040d4:	48 89 e5             	mov    %rsp,%rbp
  8040d7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040db:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040df:	ba 01 00 00 00       	mov    $0x1,%edx
  8040e4:	48 89 c6             	mov    %rax,%rsi
  8040e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ec:	48 b8 18 2b 80 00 00 	movabs $0x802b18,%rax
  8040f3:	00 00 00 
  8040f6:	ff d0                	callq  *%rax
  8040f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8040fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ff:	79 05                	jns    804106 <getchar+0x33>
		return r;
  804101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804104:	eb 14                	jmp    80411a <getchar+0x47>
	if (r < 1)
  804106:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80410a:	7f 07                	jg     804113 <getchar+0x40>
		return -E_EOF;
  80410c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804111:	eb 07                	jmp    80411a <getchar+0x47>
	return c;
  804113:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804117:	0f b6 c0             	movzbl %al,%eax
}
  80411a:	c9                   	leaveq 
  80411b:	c3                   	retq   

000000000080411c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80411c:	55                   	push   %rbp
  80411d:	48 89 e5             	mov    %rsp,%rbp
  804120:	48 83 ec 20          	sub    $0x20,%rsp
  804124:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804127:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80412b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80412e:	48 89 d6             	mov    %rdx,%rsi
  804131:	89 c7                	mov    %eax,%edi
  804133:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
  80413f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804146:	79 05                	jns    80414d <iscons+0x31>
		return r;
  804148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80414b:	eb 1a                	jmp    804167 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80414d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804151:	8b 10                	mov    (%rax),%edx
  804153:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80415a:	00 00 00 
  80415d:	8b 00                	mov    (%rax),%eax
  80415f:	39 c2                	cmp    %eax,%edx
  804161:	0f 94 c0             	sete   %al
  804164:	0f b6 c0             	movzbl %al,%eax
}
  804167:	c9                   	leaveq 
  804168:	c3                   	retq   

0000000000804169 <opencons>:

int
opencons(void)
{
  804169:	55                   	push   %rbp
  80416a:	48 89 e5             	mov    %rsp,%rbp
  80416d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804171:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804175:	48 89 c7             	mov    %rax,%rdi
  804178:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  80417f:	00 00 00 
  804182:	ff d0                	callq  *%rax
  804184:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80418b:	79 05                	jns    804192 <opencons+0x29>
		return r;
  80418d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804190:	eb 5b                	jmp    8041ed <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804196:	ba 07 04 00 00       	mov    $0x407,%edx
  80419b:	48 89 c6             	mov    %rax,%rsi
  80419e:	bf 00 00 00 00       	mov    $0x0,%edi
  8041a3:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041b6:	79 05                	jns    8041bd <opencons+0x54>
		return r;
  8041b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041bb:	eb 30                	jmp    8041ed <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8041bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8041c8:	00 00 00 
  8041cb:	8b 12                	mov    (%rdx),%edx
  8041cd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8041cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041de:	48 89 c7             	mov    %rax,%rdi
  8041e1:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  8041e8:	00 00 00 
  8041eb:	ff d0                	callq  *%rax
}
  8041ed:	c9                   	leaveq 
  8041ee:	c3                   	retq   

00000000008041ef <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041ef:	55                   	push   %rbp
  8041f0:	48 89 e5             	mov    %rsp,%rbp
  8041f3:	48 83 ec 30          	sub    $0x30,%rsp
  8041f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804203:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804208:	75 13                	jne    80421d <devcons_read+0x2e>
		return 0;
  80420a:	b8 00 00 00 00       	mov    $0x0,%eax
  80420f:	eb 49                	jmp    80425a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804211:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  804218:	00 00 00 
  80421b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80421d:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  804224:	00 00 00 
  804227:	ff d0                	callq  *%rax
  804229:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80422c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804230:	74 df                	je     804211 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804232:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804236:	79 05                	jns    80423d <devcons_read+0x4e>
		return c;
  804238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423b:	eb 1d                	jmp    80425a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80423d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804241:	75 07                	jne    80424a <devcons_read+0x5b>
		return 0;
  804243:	b8 00 00 00 00       	mov    $0x0,%eax
  804248:	eb 10                	jmp    80425a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80424a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424d:	89 c2                	mov    %eax,%edx
  80424f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804253:	88 10                	mov    %dl,(%rax)
	return 1;
  804255:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80425a:	c9                   	leaveq 
  80425b:	c3                   	retq   

000000000080425c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80425c:	55                   	push   %rbp
  80425d:	48 89 e5             	mov    %rsp,%rbp
  804260:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804267:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80426e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804275:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80427c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804283:	eb 77                	jmp    8042fc <devcons_write+0xa0>
		m = n - tot;
  804285:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80428c:	89 c2                	mov    %eax,%edx
  80428e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804291:	89 d1                	mov    %edx,%ecx
  804293:	29 c1                	sub    %eax,%ecx
  804295:	89 c8                	mov    %ecx,%eax
  804297:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80429a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80429d:	83 f8 7f             	cmp    $0x7f,%eax
  8042a0:	76 07                	jbe    8042a9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8042a2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8042a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ac:	48 63 d0             	movslq %eax,%rdx
  8042af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b2:	48 98                	cltq   
  8042b4:	48 89 c1             	mov    %rax,%rcx
  8042b7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8042be:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042c5:	48 89 ce             	mov    %rcx,%rsi
  8042c8:	48 89 c7             	mov    %rax,%rdi
  8042cb:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8042d2:	00 00 00 
  8042d5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042da:	48 63 d0             	movslq %eax,%rdx
  8042dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042e4:	48 89 d6             	mov    %rdx,%rsi
  8042e7:	48 89 c7             	mov    %rax,%rdi
  8042ea:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  8042f1:	00 00 00 
  8042f4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042f9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8042fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ff:	48 98                	cltq   
  804301:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804308:	0f 82 77 ff ff ff    	jb     804285 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80430e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804311:	c9                   	leaveq 
  804312:	c3                   	retq   

0000000000804313 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804313:	55                   	push   %rbp
  804314:	48 89 e5             	mov    %rsp,%rbp
  804317:	48 83 ec 08          	sub    $0x8,%rsp
  80431b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80431f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804324:	c9                   	leaveq 
  804325:	c3                   	retq   

0000000000804326 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804326:	55                   	push   %rbp
  804327:	48 89 e5             	mov    %rsp,%rbp
  80432a:	48 83 ec 10          	sub    $0x10,%rsp
  80432e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804332:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433a:	48 be db 4f 80 00 00 	movabs $0x804fdb,%rsi
  804341:	00 00 00 
  804344:	48 89 c7             	mov    %rax,%rdi
  804347:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  80434e:	00 00 00 
  804351:	ff d0                	callq  *%rax
	return 0;
  804353:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804358:	c9                   	leaveq 
  804359:	c3                   	retq   
	...

000000000080435c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80435c:	55                   	push   %rbp
  80435d:	48 89 e5             	mov    %rsp,%rbp
  804360:	48 83 ec 10          	sub    $0x10,%rsp
  804364:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804368:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80436f:	00 00 00 
  804372:	48 8b 00             	mov    (%rax),%rax
  804375:	48 85 c0             	test   %rax,%rax
  804378:	75 66                	jne    8043e0 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  80437a:	ba 07 00 00 00       	mov    $0x7,%edx
  80437f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804384:	bf 00 00 00 00       	mov    $0x0,%edi
  804389:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  804390:	00 00 00 
  804393:	ff d0                	callq  *%rax
  804395:	85 c0                	test   %eax,%eax
  804397:	75 1d                	jne    8043b6 <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804399:	48 be f4 43 80 00 00 	movabs $0x8043f4,%rsi
  8043a0:	00 00 00 
  8043a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a8:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  8043af:	00 00 00 
  8043b2:	ff d0                	callq  *%rax
  8043b4:	eb 2a                	jmp    8043e0 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  8043b6:	48 ba e2 4f 80 00 00 	movabs $0x804fe2,%rdx
  8043bd:	00 00 00 
  8043c0:	be 23 00 00 00       	mov    $0x23,%esi
  8043c5:	48 bf 00 50 80 00 00 	movabs $0x805000,%rdi
  8043cc:	00 00 00 
  8043cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d4:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  8043db:	00 00 00 
  8043de:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8043e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043e7:	00 00 00 
  8043ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043ee:	48 89 10             	mov    %rdx,(%rax)
}
  8043f1:	c9                   	leaveq 
  8043f2:	c3                   	retq   
	...

00000000008043f4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8043f4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8043f7:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8043fe:	00 00 00 
call *%rax
  804401:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804403:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  804407:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  80440c:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804413:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804414:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804418:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80441b:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804422:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804423:	4c 8b 3c 24          	mov    (%rsp),%r15
  804427:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80442c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804431:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804436:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80443b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804440:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804445:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80444a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80444f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804454:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804459:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80445e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804463:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804468:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80446d:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  804471:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804475:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  804476:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  804477:	c3                   	retq   

0000000000804478 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804478:	55                   	push   %rbp
  804479:	48 89 e5             	mov    %rsp,%rbp
  80447c:	48 83 ec 30          	sub    $0x30,%rsp
  804480:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804484:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804488:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  80448c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  804493:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804498:	74 18                	je     8044b2 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  80449a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80449e:	48 89 c7             	mov    %rax,%rdi
  8044a1:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  8044a8:	00 00 00 
  8044ab:	ff d0                	callq  *%rax
  8044ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b0:	eb 19                	jmp    8044cb <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8044b2:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8044b9:	00 00 00 
  8044bc:	48 b8 75 1d 80 00 00 	movabs $0x801d75,%rax
  8044c3:	00 00 00 
  8044c6:	ff d0                	callq  *%rax
  8044c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8044cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044cf:	79 39                	jns    80450a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8044d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8044d6:	75 08                	jne    8044e0 <ipc_recv+0x68>
  8044d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044dc:	8b 00                	mov    (%rax),%eax
  8044de:	eb 05                	jmp    8044e5 <ipc_recv+0x6d>
  8044e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044e9:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8044eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044f0:	75 08                	jne    8044fa <ipc_recv+0x82>
  8044f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044f6:	8b 00                	mov    (%rax),%eax
  8044f8:	eb 05                	jmp    8044ff <ipc_recv+0x87>
  8044fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804503:	89 02                	mov    %eax,(%rdx)
		return r;
  804505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804508:	eb 53                	jmp    80455d <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80450a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80450f:	74 19                	je     80452a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804511:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804518:	00 00 00 
  80451b:	48 8b 00             	mov    (%rax),%rax
  80451e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804528:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80452a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80452f:	74 19                	je     80454a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804531:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804538:	00 00 00 
  80453b:	48 8b 00             	mov    (%rax),%rax
  80453e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804544:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804548:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80454a:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804551:	00 00 00 
  804554:	48 8b 00             	mov    (%rax),%rax
  804557:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  80455d:	c9                   	leaveq 
  80455e:	c3                   	retq   

000000000080455f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80455f:	55                   	push   %rbp
  804560:	48 89 e5             	mov    %rsp,%rbp
  804563:	48 83 ec 30          	sub    $0x30,%rsp
  804567:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80456a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80456d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804571:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  804574:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  80457b:	eb 59                	jmp    8045d6 <ipc_send+0x77>
		if(pg) {
  80457d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804582:	74 20                	je     8045a4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804584:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804587:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80458a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80458e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804591:	89 c7                	mov    %eax,%edi
  804593:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  80459a:	00 00 00 
  80459d:	ff d0                	callq  *%rax
  80459f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a2:	eb 26                	jmp    8045ca <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8045a4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8045aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ad:	89 d1                	mov    %edx,%ecx
  8045af:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8045b6:	00 00 00 
  8045b9:	89 c7                	mov    %eax,%edi
  8045bb:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8045ca:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8045d1:	00 00 00 
  8045d4:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8045d6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8045da:	74 a1                	je     80457d <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8045dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045e0:	74 2a                	je     80460c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8045e2:	48 ba 10 50 80 00 00 	movabs $0x805010,%rdx
  8045e9:	00 00 00 
  8045ec:	be 49 00 00 00       	mov    $0x49,%esi
  8045f1:	48 bf 3b 50 80 00 00 	movabs $0x80503b,%rdi
  8045f8:	00 00 00 
  8045fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804600:	48 b9 08 04 80 00 00 	movabs $0x800408,%rcx
  804607:	00 00 00 
  80460a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80460c:	c9                   	leaveq 
  80460d:	c3                   	retq   

000000000080460e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80460e:	55                   	push   %rbp
  80460f:	48 89 e5             	mov    %rsp,%rbp
  804612:	48 83 ec 18          	sub    $0x18,%rsp
  804616:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804619:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804620:	eb 6a                	jmp    80468c <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804622:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804629:	00 00 00 
  80462c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462f:	48 63 d0             	movslq %eax,%rdx
  804632:	48 89 d0             	mov    %rdx,%rax
  804635:	48 c1 e0 02          	shl    $0x2,%rax
  804639:	48 01 d0             	add    %rdx,%rax
  80463c:	48 01 c0             	add    %rax,%rax
  80463f:	48 01 d0             	add    %rdx,%rax
  804642:	48 c1 e0 05          	shl    $0x5,%rax
  804646:	48 01 c8             	add    %rcx,%rax
  804649:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80464f:	8b 00                	mov    (%rax),%eax
  804651:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804654:	75 32                	jne    804688 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804656:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80465d:	00 00 00 
  804660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804663:	48 63 d0             	movslq %eax,%rdx
  804666:	48 89 d0             	mov    %rdx,%rax
  804669:	48 c1 e0 02          	shl    $0x2,%rax
  80466d:	48 01 d0             	add    %rdx,%rax
  804670:	48 01 c0             	add    %rax,%rax
  804673:	48 01 d0             	add    %rdx,%rax
  804676:	48 c1 e0 05          	shl    $0x5,%rax
  80467a:	48 01 c8             	add    %rcx,%rax
  80467d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804683:	8b 40 08             	mov    0x8(%rax),%eax
  804686:	eb 12                	jmp    80469a <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804688:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80468c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804693:	7e 8d                	jle    804622 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80469a:	c9                   	leaveq 
  80469b:	c3                   	retq   

000000000080469c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80469c:	55                   	push   %rbp
  80469d:	48 89 e5             	mov    %rsp,%rbp
  8046a0:	48 83 ec 18          	sub    $0x18,%rsp
  8046a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046ac:	48 89 c2             	mov    %rax,%rdx
  8046af:	48 c1 ea 15          	shr    $0x15,%rdx
  8046b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046ba:	01 00 00 
  8046bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046c1:	83 e0 01             	and    $0x1,%eax
  8046c4:	48 85 c0             	test   %rax,%rax
  8046c7:	75 07                	jne    8046d0 <pageref+0x34>
		return 0;
  8046c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ce:	eb 53                	jmp    804723 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d4:	48 89 c2             	mov    %rax,%rdx
  8046d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8046db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046e2:	01 00 00 
  8046e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f1:	83 e0 01             	and    $0x1,%eax
  8046f4:	48 85 c0             	test   %rax,%rax
  8046f7:	75 07                	jne    804700 <pageref+0x64>
		return 0;
  8046f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fe:	eb 23                	jmp    804723 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804704:	48 89 c2             	mov    %rax,%rdx
  804707:	48 c1 ea 0c          	shr    $0xc,%rdx
  80470b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804712:	00 00 00 
  804715:	48 c1 e2 04          	shl    $0x4,%rdx
  804719:	48 01 d0             	add    %rdx,%rax
  80471c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804720:	0f b7 c0             	movzwl %ax,%eax
}
  804723:	c9                   	leaveq 
  804724:	c3                   	retq   
