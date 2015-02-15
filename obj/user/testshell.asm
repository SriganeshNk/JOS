
obj/user/testshell.debug:     file format elf64-x86-64


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
  80003c:	e8 f7 07 00 00       	callq  800838 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800053:	bf 00 00 00 00       	mov    $0x0,%edi
  800058:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax
	close(1);
  800064:	bf 01 00 00 00       	mov    $0x1,%edi
  800069:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	opencons();
  800075:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
	opencons();
  800081:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  800088:	00 00 00 
  80008b:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008d:	be 00 00 00 00       	mov    $0x0,%esi
  800092:	48 bf 80 55 80 00 00 	movabs $0x805580,%rdi
  800099:	00 00 00 
  80009c:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	callq  *%rax
  8000a8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000af:	79 30                	jns    8000e1 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b4:	89 c1                	mov    %eax,%ecx
  8000b6:	48 ba 8d 55 80 00 00 	movabs $0x80558d,%rdx
  8000bd:	00 00 00 
  8000c0:	be 13 00 00 00       	mov    $0x13,%esi
  8000c5:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  8000cc:	00 00 00 
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8000db:	00 00 00 
  8000de:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e5:	48 89 c7             	mov    %rax,%rdi
  8000e8:	48 b8 38 4b 80 00 00 	movabs $0x804b38,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
  8000f4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fb:	79 30                	jns    80012d <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800100:	89 c1                	mov    %eax,%ecx
  800102:	48 ba b4 55 80 00 00 	movabs $0x8055b4,%rdx
  800109:	00 00 00 
  80010c:	be 15 00 00 00       	mov    $0x15,%esi
  800111:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  800127:	00 00 00 
  80012a:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800130:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800133:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  800149:	00 00 00 
  80014c:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014e:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  800155:	00 00 00 
  800158:	ff d0                	callq  *%rax
  80015a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800161:	79 30                	jns    800193 <umain+0x14f>
		panic("fork: %e", r);
  800163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800166:	89 c1                	mov    %eax,%ecx
  800168:	48 ba e4 55 80 00 00 	movabs $0x8055e4,%rdx
  80016f:	00 00 00 
  800172:	be 1a 00 00 00       	mov    $0x1a,%esi
  800177:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  80017e:	00 00 00 
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80018d:	00 00 00 
  800190:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800193:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800197:	0f 85 fb 00 00 00    	jne    800298 <umain+0x254>
		dup(rfd, 0);
  80019d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001a0:	be 00 00 00 00       	mov    $0x0,%esi
  8001a5:	89 c7                	mov    %eax,%edi
  8001a7:	48 b8 6b 2e 80 00 00 	movabs $0x802e6b,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b6:	be 01 00 00 00       	mov    $0x1,%esi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 6b 2e 80 00 00 	movabs $0x802e6b,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
		close(rfd);
  8001c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cc:	89 c7                	mov    %eax,%edi
  8001ce:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax
		close(wfd);
  8001da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dd:	89 c7                	mov    %eax,%edi
  8001df:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8001e6:	00 00 00 
  8001e9:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f0:	48 ba ed 55 80 00 00 	movabs $0x8055ed,%rdx
  8001f7:	00 00 00 
  8001fa:	48 be f0 55 80 00 00 	movabs $0x8055f0,%rsi
  800201:	00 00 00 
  800204:	48 bf f3 55 80 00 00 	movabs $0x8055f3,%rdi
  80020b:	00 00 00 
  80020e:	b8 00 00 00 00       	mov    $0x0,%eax
  800213:	49 b8 97 3a 80 00 00 	movabs $0x803a97,%r8
  80021a:	00 00 00 
  80021d:	41 ff d0             	callq  *%r8
  800220:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800223:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800227:	79 30                	jns    800259 <umain+0x215>
			panic("spawn: %e", r);
  800229:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022c:	89 c1                	mov    %eax,%ecx
  80022e:	48 ba fb 55 80 00 00 	movabs $0x8055fb,%rdx
  800235:	00 00 00 
  800238:	be 21 00 00 00       	mov    $0x21,%esi
  80023d:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  800253:	00 00 00 
  800256:	41 ff d0             	callq  *%r8
		close(0);
  800259:	bf 00 00 00 00       	mov    $0x0,%edi
  80025e:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
		close(1);
  80026a:	bf 01 00 00 00       	mov    $0x1,%edi
  80026f:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  800276:	00 00 00 
  800279:	ff d0                	callq  *%rax
		wait(r);
  80027b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027e:	89 c7                	mov    %eax,%edi
  800280:	48 b8 00 51 80 00 00 	movabs $0x805100,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
		exit();
  80028c:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
	}
	close(rfd);
  800298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029b:	89 c7                	mov    %eax,%edi
  80029d:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8002a4:	00 00 00 
  8002a7:	ff d0                	callq  *%rax
	close(wfd);
  8002a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002ba:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002c0:	be 00 00 00 00       	mov    $0x0,%esi
  8002c5:	48 bf 05 56 80 00 00 	movabs $0x805605,%rdi
  8002cc:	00 00 00 
  8002cf:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	callq  *%rax
  8002db:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002de:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e2:	79 30                	jns    800314 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e7:	89 c1                	mov    %eax,%ecx
  8002e9:	48 ba 18 56 80 00 00 	movabs $0x805618,%rdx
  8002f0:	00 00 00 
  8002f3:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f8:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  8002ff:	00 00 00 
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80030e:	00 00 00 
  800311:	41 ff d0             	callq  *%r8

	nloff = 0;
  800314:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800322:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800326:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800329:	ba 01 00 00 00       	mov    $0x1,%edx
  80032e:	48 89 ce             	mov    %rcx,%rsi
  800331:	89 c7                	mov    %eax,%edi
  800333:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  80033a:	00 00 00 
  80033d:	ff d0                	callq  *%rax
  80033f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800342:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800346:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800349:	ba 01 00 00 00       	mov    $0x1,%edx
  80034e:	48 89 ce             	mov    %rcx,%rsi
  800351:	89 c7                	mov    %eax,%edi
  800353:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  80035a:	00 00 00 
  80035d:	ff d0                	callq  *%rax
  80035f:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800362:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800366:	79 30                	jns    800398 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036b:	89 c1                	mov    %eax,%ecx
  80036d:	48 ba 3b 56 80 00 00 	movabs $0x80563b,%rdx
  800374:	00 00 00 
  800377:	be 33 00 00 00       	mov    $0x33,%esi
  80037c:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  800383:	00 00 00 
  800386:	b8 00 00 00 00       	mov    $0x0,%eax
  80038b:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  800392:	00 00 00 
  800395:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800398:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039c:	79 30                	jns    8003ce <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a1:	89 c1                	mov    %eax,%ecx
  8003a3:	48 ba 55 56 80 00 00 	movabs $0x805655,%rdx
  8003aa:	00 00 00 
  8003ad:	be 35 00 00 00       	mov    $0x35,%esi
  8003b2:	48 bf a3 55 80 00 00 	movabs $0x8055a3,%rdi
  8003b9:	00 00 00 
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8003c8:	00 00 00 
  8003cb:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d2:	75 06                	jne    8003da <umain+0x396>
  8003d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d8:	74 4b                	je     800425 <umain+0x3e1>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003de:	75 12                	jne    8003f2 <umain+0x3ae>
  8003e0:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e4:	75 0c                	jne    8003f2 <umain+0x3ae>
  8003e6:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003ea:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ee:	38 c2                	cmp    %al,%dl
  8003f0:	74 19                	je     80040b <umain+0x3c7>
			wrong(rfd, kfd, nloff);
  8003f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fb:	89 ce                	mov    %ecx,%esi
  8003fd:	89 c7                	mov    %eax,%edi
  8003ff:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800406:	00 00 00 
  800409:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80040f:	3c 0a                	cmp    $0xa,%al
  800411:	75 09                	jne    80041c <umain+0x3d8>
			nloff = off+1;
  800413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800416:	83 c0 01             	add    $0x1,%eax
  800419:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800420:	e9 fd fe ff ff       	jmpq   800322 <umain+0x2de>
		if (n1 < 0)
			panic("reading testshell.out: %e", n1);
		if (n2 < 0)
			panic("reading testshell.key: %e", n2);
		if (n1 == 0 && n2 == 0)
			break;
  800425:	90                   	nop
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
	cprintf("shell ran correctly\n");
  800426:	48 bf 6f 56 80 00 00 	movabs $0x80566f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 3a 32 80 00 00 	movabs $0x80323a,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 3a 32 80 00 00 	movabs $0x80323a,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 88 56 80 00 00 	movabs $0x805688,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf aa 56 80 00 00 	movabs $0x8056aa,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf b9 56 80 00 00 	movabs $0x8056b9,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf c7 56 80 00 00 	movabs $0x8056c7,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   
	...

0000000000800584 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	48 83 ec 20          	sub    $0x20,%rsp
  80058c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800592:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800595:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800599:	be 01 00 00 00       	mov    $0x1,%esi
  80059e:	48 89 c7             	mov    %rax,%rdi
  8005a1:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  8005a8:	00 00 00 
  8005ab:	ff d0                	callq  *%rax
}
  8005ad:	c9                   	leaveq 
  8005ae:	c3                   	retq   

00000000008005af <getchar>:

int
getchar(void)
{
  8005af:	55                   	push   %rbp
  8005b0:	48 89 e5             	mov    %rsp,%rbp
  8005b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8005c0:	48 89 c6             	mov    %rax,%rsi
  8005c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c8:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  8005cf:	00 00 00 
  8005d2:	ff d0                	callq  *%rax
  8005d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005db:	79 05                	jns    8005e2 <getchar+0x33>
		return r;
  8005dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e0:	eb 14                	jmp    8005f6 <getchar+0x47>
	if (r < 1)
  8005e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e6:	7f 07                	jg     8005ef <getchar+0x40>
		return -E_EOF;
  8005e8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ed:	eb 07                	jmp    8005f6 <getchar+0x47>
	return c;
  8005ef:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f3:	0f b6 c0             	movzbl %al,%eax
}
  8005f6:	c9                   	leaveq 
  8005f7:	c3                   	retq   

00000000008005f8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f8:	55                   	push   %rbp
  8005f9:	48 89 e5             	mov    %rsp,%rbp
  8005fc:	48 83 ec 20          	sub    $0x20,%rsp
  800600:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800603:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800607:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80060a:	48 89 d6             	mov    %rdx,%rsi
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
  80061b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800622:	79 05                	jns    800629 <iscons+0x31>
		return r;
  800624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800627:	eb 1a                	jmp    800643 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062d:	8b 10                	mov    (%rax),%edx
  80062f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800636:	00 00 00 
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	39 c2                	cmp    %eax,%edx
  80063d:	0f 94 c0             	sete   %al
  800640:	0f b6 c0             	movzbl %al,%eax
}
  800643:	c9                   	leaveq 
  800644:	c3                   	retq   

0000000000800645 <opencons>:

int
opencons(void)
{
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800651:	48 89 c7             	mov    %rax,%rdi
  800654:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  80065b:	00 00 00 
  80065e:	ff d0                	callq  *%rax
  800660:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800663:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800667:	79 05                	jns    80066e <opencons+0x29>
		return r;
  800669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066c:	eb 5b                	jmp    8006c9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	ba 07 04 00 00       	mov    $0x407,%edx
  800677:	48 89 c6             	mov    %rax,%rsi
  80067a:	bf 00 00 00 00       	mov    $0x0,%edi
  80067f:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  800686:	00 00 00 
  800689:	ff d0                	callq  *%rax
  80068b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800692:	79 05                	jns    800699 <opencons+0x54>
		return r;
  800694:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800697:	eb 30                	jmp    8006c9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a4:	00 00 00 
  8006a7:	8b 12                	mov    (%rdx),%edx
  8006a9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ba:	48 89 c7             	mov    %rax,%rdi
  8006bd:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	callq  *%rax
}
  8006c9:	c9                   	leaveq 
  8006ca:	c3                   	retq   

00000000008006cb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006cb:	55                   	push   %rbp
  8006cc:	48 89 e5             	mov    %rsp,%rbp
  8006cf:	48 83 ec 30          	sub    $0x30,%rsp
  8006d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e4:	75 13                	jne    8006f9 <devcons_read+0x2e>
		return 0;
  8006e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006eb:	eb 49                	jmp    800736 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8006ed:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  8006f4:	00 00 00 
  8006f7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006f9:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  800700:	00 00 00 
  800703:	ff d0                	callq  *%rax
  800705:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800708:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070c:	74 df                	je     8006ed <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80070e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800712:	79 05                	jns    800719 <devcons_read+0x4e>
		return c;
  800714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800717:	eb 1d                	jmp    800736 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800719:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071d:	75 07                	jne    800726 <devcons_read+0x5b>
		return 0;
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	eb 10                	jmp    800736 <devcons_read+0x6b>
	*(char*)vbuf = c;
  800726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800729:	89 c2                	mov    %eax,%edx
  80072b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80072f:	88 10                	mov    %dl,(%rax)
	return 1;
  800731:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800736:	c9                   	leaveq 
  800737:	c3                   	retq   

0000000000800738 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800738:	55                   	push   %rbp
  800739:	48 89 e5             	mov    %rsp,%rbp
  80073c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800743:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800751:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80075f:	eb 77                	jmp    8007d8 <devcons_write+0xa0>
		m = n - tot;
  800761:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800768:	89 c2                	mov    %eax,%edx
  80076a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076d:	89 d1                	mov    %edx,%ecx
  80076f:	29 c1                	sub    %eax,%ecx
  800771:	89 c8                	mov    %ecx,%eax
  800773:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800776:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800779:	83 f8 7f             	cmp    $0x7f,%eax
  80077c:	76 07                	jbe    800785 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80077e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800785:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800788:	48 63 d0             	movslq %eax,%rdx
  80078b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078e:	48 98                	cltq   
  800790:	48 89 c1             	mov    %rax,%rcx
  800793:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 77 ff ff ff    	jb     800761 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be d1 56 80 00 00 	movabs $0x8056d1,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   
	...

0000000000800838 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800838:	55                   	push   %rbp
  800839:	48 89 e5             	mov    %rsp,%rbp
  80083c:	48 83 ec 10          	sub    $0x10,%rsp
  800840:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800843:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800847:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80084e:	00 00 00 
  800851:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800858:	48 b8 cc 1f 80 00 00 	movabs $0x801fcc,%rax
  80085f:	00 00 00 
  800862:	ff d0                	callq  *%rax
  800864:	48 98                	cltq   
  800866:	48 89 c2             	mov    %rax,%rdx
  800869:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 c1 e0 02          	shl    $0x2,%rax
  800876:	48 01 d0             	add    %rdx,%rax
  800879:	48 01 c0             	add    %rax,%rax
  80087c:	48 01 d0             	add    %rdx,%rax
  80087f:	48 c1 e0 05          	shl    $0x5,%rax
  800883:	48 89 c2             	mov    %rax,%rdx
  800886:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80088d:	00 00 00 
  800890:	48 01 c2             	add    %rax,%rdx
  800893:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80089a:	00 00 00 
  80089d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008a4:	7e 14                	jle    8008ba <libmain+0x82>
		binaryname = argv[0];
  8008a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008aa:	48 8b 10             	mov    (%rax),%rdx
  8008ad:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  8008b4:	00 00 00 
  8008b7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008c1:	48 89 d6             	mov    %rdx,%rsi
  8008c4:	89 c7                	mov    %eax,%edi
  8008c6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008d2:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  8008d9:	00 00 00 
  8008dc:	ff d0                	callq  *%rax
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008e4:	48 b8 3d 2e 80 00 00 	movabs $0x802e3d,%rax
  8008eb:	00 00 00 
  8008ee:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8008f5:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  8008fc:	00 00 00 
  8008ff:	ff d0                	callq  *%rax
}
  800901:	5d                   	pop    %rbp
  800902:	c3                   	retq   
	...

0000000000800904 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800904:	55                   	push   %rbp
  800905:	48 89 e5             	mov    %rsp,%rbp
  800908:	53                   	push   %rbx
  800909:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800910:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800917:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80091d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800924:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80092b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800932:	84 c0                	test   %al,%al
  800934:	74 23                	je     800959 <_panic+0x55>
  800936:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80093d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800941:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800945:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800949:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80094d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800951:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800955:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800959:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800960:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800967:	00 00 00 
  80096a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800971:	00 00 00 
  800974:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800978:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80097f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800986:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80098d:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  800994:	00 00 00 
  800997:	48 8b 18             	mov    (%rax),%rbx
  80099a:	48 b8 cc 1f 80 00 00 	movabs $0x801fcc,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8009ac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009b3:	41 89 c8             	mov    %ecx,%r8d
  8009b6:	48 89 d1             	mov    %rdx,%rcx
  8009b9:	48 89 da             	mov    %rbx,%rdx
  8009bc:	89 c6                	mov    %eax,%esi
  8009be:	48 bf e8 56 80 00 00 	movabs $0x8056e8,%rdi
  8009c5:	00 00 00 
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	49 b9 3f 0b 80 00 00 	movabs $0x800b3f,%r9
  8009d4:	00 00 00 
  8009d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009e8:	48 89 d6             	mov    %rdx,%rsi
  8009eb:	48 89 c7             	mov    %rax,%rdi
  8009ee:	48 b8 93 0a 80 00 00 	movabs $0x800a93,%rax
  8009f5:	00 00 00 
  8009f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8009fa:	48 bf 0b 57 80 00 00 	movabs $0x80570b,%rdi
  800a01:	00 00 00 
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
  800a09:	48 ba 3f 0b 80 00 00 	movabs $0x800b3f,%rdx
  800a10:	00 00 00 
  800a13:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a15:	cc                   	int3   
  800a16:	eb fd                	jmp    800a15 <_panic+0x111>

0000000000800a18 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a18:	55                   	push   %rbp
  800a19:	48 89 e5             	mov    %rsp,%rbp
  800a1c:	48 83 ec 10          	sub    $0x10,%rsp
  800a20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2b:	8b 00                	mov    (%rax),%eax
  800a2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a36:	48 63 d0             	movslq %eax,%rdx
  800a39:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800a3e:	8d 50 01             	lea    0x1(%rax),%edx
  800a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a45:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800a47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a4b:	8b 00                	mov    (%rax),%eax
  800a4d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a52:	75 2c                	jne    800a80 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a58:	8b 00                	mov    (%rax),%eax
  800a5a:	48 98                	cltq   
  800a5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a60:	48 83 c2 08          	add    $0x8,%rdx
  800a64:	48 89 c6             	mov    %rax,%rsi
  800a67:	48 89 d7             	mov    %rdx,%rdi
  800a6a:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  800a71:	00 00 00 
  800a74:	ff d0                	callq  *%rax
        b->idx = 0;
  800a76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a7a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a84:	8b 40 04             	mov    0x4(%rax),%eax
  800a87:	8d 50 01             	lea    0x1(%rax),%edx
  800a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a91:	c9                   	leaveq 
  800a92:	c3                   	retq   

0000000000800a93 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a93:	55                   	push   %rbp
  800a94:	48 89 e5             	mov    %rsp,%rbp
  800a97:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a9e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800aa5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800aac:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ab3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800aba:	48 8b 0a             	mov    (%rdx),%rcx
  800abd:	48 89 08             	mov    %rcx,(%rax)
  800ac0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ac4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ac8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800acc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ad0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ad7:	00 00 00 
    b.cnt = 0;
  800ada:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ae1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ae4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800aeb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800af2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800af9:	48 89 c6             	mov    %rax,%rsi
  800afc:	48 bf 18 0a 80 00 00 	movabs $0x800a18,%rdi
  800b03:	00 00 00 
  800b06:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  800b0d:	00 00 00 
  800b10:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800b12:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b18:	48 98                	cltq   
  800b1a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b21:	48 83 c2 08          	add    $0x8,%rdx
  800b25:	48 89 c6             	mov    %rax,%rsi
  800b28:	48 89 d7             	mov    %rdx,%rdi
  800b2b:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  800b32:	00 00 00 
  800b35:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b37:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b3d:	c9                   	leaveq 
  800b3e:	c3                   	retq   

0000000000800b3f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b3f:	55                   	push   %rbp
  800b40:	48 89 e5             	mov    %rsp,%rbp
  800b43:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b4a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b51:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b58:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b5f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b66:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b6d:	84 c0                	test   %al,%al
  800b6f:	74 20                	je     800b91 <cprintf+0x52>
  800b71:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b75:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b79:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b7d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b81:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b85:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b89:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b8d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b91:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b98:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b9f:	00 00 00 
  800ba2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ba9:	00 00 00 
  800bac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800bb7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bbe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800bc5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bcc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bd3:	48 8b 0a             	mov    (%rdx),%rcx
  800bd6:	48 89 08             	mov    %rcx,(%rax)
  800bd9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bdd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800be1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800be5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800be9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bf0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bf7:	48 89 d6             	mov    %rdx,%rsi
  800bfa:	48 89 c7             	mov    %rax,%rdi
  800bfd:	48 b8 93 0a 80 00 00 	movabs $0x800a93,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
  800c09:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800c0f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c15:	c9                   	leaveq 
  800c16:	c3                   	retq   
	...

0000000000800c18 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c18:	55                   	push   %rbp
  800c19:	48 89 e5             	mov    %rsp,%rbp
  800c1c:	48 83 ec 30          	sub    $0x30,%rsp
  800c20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800c24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c28:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c2c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c2f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c33:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c37:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c3a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c3e:	77 52                	ja     800c92 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c40:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c43:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c47:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c4a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	48 f7 75 d0          	divq   -0x30(%rbp)
  800c5b:	48 89 c2             	mov    %rax,%rdx
  800c5e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c61:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c64:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c6c:	41 89 f9             	mov    %edi,%r9d
  800c6f:	48 89 c7             	mov    %rax,%rdi
  800c72:	48 b8 18 0c 80 00 00 	movabs $0x800c18,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax
  800c7e:	eb 1c                	jmp    800c9c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c84:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c87:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800c8b:	48 89 d6             	mov    %rdx,%rsi
  800c8e:	89 c7                	mov    %eax,%edi
  800c90:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800c96:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c9a:	7f e4                	jg     800c80 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca8:	48 f7 f1             	div    %rcx
  800cab:	48 89 d0             	mov    %rdx,%rax
  800cae:	48 ba 10 59 80 00 00 	movabs $0x805910,%rdx
  800cb5:	00 00 00 
  800cb8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cc3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800cc7:	48 89 d6             	mov    %rdx,%rsi
  800cca:	89 c7                	mov    %eax,%edi
  800ccc:	ff d1                	callq  *%rcx
}
  800cce:	c9                   	leaveq 
  800ccf:	c3                   	retq   

0000000000800cd0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd0:	55                   	push   %rbp
  800cd1:	48 89 e5             	mov    %rsp,%rbp
  800cd4:	48 83 ec 20          	sub    $0x20,%rsp
  800cd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cdc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cdf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ce3:	7e 52                	jle    800d37 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce9:	8b 00                	mov    (%rax),%eax
  800ceb:	83 f8 30             	cmp    $0x30,%eax
  800cee:	73 24                	jae    800d14 <getuint+0x44>
  800cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfc:	8b 00                	mov    (%rax),%eax
  800cfe:	89 c0                	mov    %eax,%eax
  800d00:	48 01 d0             	add    %rdx,%rax
  800d03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d07:	8b 12                	mov    (%rdx),%edx
  800d09:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d0c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d10:	89 0a                	mov    %ecx,(%rdx)
  800d12:	eb 17                	jmp    800d2b <getuint+0x5b>
  800d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d18:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d1c:	48 89 d0             	mov    %rdx,%rax
  800d1f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d27:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d2b:	48 8b 00             	mov    (%rax),%rax
  800d2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d32:	e9 a3 00 00 00       	jmpq   800dda <getuint+0x10a>
	else if (lflag)
  800d37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d3b:	74 4f                	je     800d8c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d41:	8b 00                	mov    (%rax),%eax
  800d43:	83 f8 30             	cmp    $0x30,%eax
  800d46:	73 24                	jae    800d6c <getuint+0x9c>
  800d48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d54:	8b 00                	mov    (%rax),%eax
  800d56:	89 c0                	mov    %eax,%eax
  800d58:	48 01 d0             	add    %rdx,%rax
  800d5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5f:	8b 12                	mov    (%rdx),%edx
  800d61:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d68:	89 0a                	mov    %ecx,(%rdx)
  800d6a:	eb 17                	jmp    800d83 <getuint+0xb3>
  800d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d70:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d74:	48 89 d0             	mov    %rdx,%rax
  800d77:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d7f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d83:	48 8b 00             	mov    (%rax),%rax
  800d86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d8a:	eb 4e                	jmp    800dda <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	8b 00                	mov    (%rax),%eax
  800d92:	83 f8 30             	cmp    $0x30,%eax
  800d95:	73 24                	jae    800dbb <getuint+0xeb>
  800d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da3:	8b 00                	mov    (%rax),%eax
  800da5:	89 c0                	mov    %eax,%eax
  800da7:	48 01 d0             	add    %rdx,%rax
  800daa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dae:	8b 12                	mov    (%rdx),%edx
  800db0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800db3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db7:	89 0a                	mov    %ecx,(%rdx)
  800db9:	eb 17                	jmp    800dd2 <getuint+0x102>
  800dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800dc3:	48 89 d0             	mov    %rdx,%rax
  800dc6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dd2:	8b 00                	mov    (%rax),%eax
  800dd4:	89 c0                	mov    %eax,%eax
  800dd6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dde:	c9                   	leaveq 
  800ddf:	c3                   	retq   

0000000000800de0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800de0:	55                   	push   %rbp
  800de1:	48 89 e5             	mov    %rsp,%rbp
  800de4:	48 83 ec 20          	sub    $0x20,%rsp
  800de8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800def:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800df3:	7e 52                	jle    800e47 <getint+0x67>
		x=va_arg(*ap, long long);
  800df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df9:	8b 00                	mov    (%rax),%eax
  800dfb:	83 f8 30             	cmp    $0x30,%eax
  800dfe:	73 24                	jae    800e24 <getint+0x44>
  800e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e04:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0c:	8b 00                	mov    (%rax),%eax
  800e0e:	89 c0                	mov    %eax,%eax
  800e10:	48 01 d0             	add    %rdx,%rax
  800e13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e17:	8b 12                	mov    (%rdx),%edx
  800e19:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e20:	89 0a                	mov    %ecx,(%rdx)
  800e22:	eb 17                	jmp    800e3b <getint+0x5b>
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e2c:	48 89 d0             	mov    %rdx,%rax
  800e2f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e37:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e3b:	48 8b 00             	mov    (%rax),%rax
  800e3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e42:	e9 a3 00 00 00       	jmpq   800eea <getint+0x10a>
	else if (lflag)
  800e47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e4b:	74 4f                	je     800e9c <getint+0xbc>
		x=va_arg(*ap, long);
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	8b 00                	mov    (%rax),%eax
  800e53:	83 f8 30             	cmp    $0x30,%eax
  800e56:	73 24                	jae    800e7c <getint+0x9c>
  800e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e64:	8b 00                	mov    (%rax),%eax
  800e66:	89 c0                	mov    %eax,%eax
  800e68:	48 01 d0             	add    %rdx,%rax
  800e6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6f:	8b 12                	mov    (%rdx),%edx
  800e71:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e78:	89 0a                	mov    %ecx,(%rdx)
  800e7a:	eb 17                	jmp    800e93 <getint+0xb3>
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e84:	48 89 d0             	mov    %rdx,%rax
  800e87:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e8f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e93:	48 8b 00             	mov    (%rax),%rax
  800e96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e9a:	eb 4e                	jmp    800eea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	8b 00                	mov    (%rax),%eax
  800ea2:	83 f8 30             	cmp    $0x30,%eax
  800ea5:	73 24                	jae    800ecb <getint+0xeb>
  800ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	8b 00                	mov    (%rax),%eax
  800eb5:	89 c0                	mov    %eax,%eax
  800eb7:	48 01 d0             	add    %rdx,%rax
  800eba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebe:	8b 12                	mov    (%rdx),%edx
  800ec0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ec3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec7:	89 0a                	mov    %ecx,(%rdx)
  800ec9:	eb 17                	jmp    800ee2 <getint+0x102>
  800ecb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ed3:	48 89 d0             	mov    %rdx,%rax
  800ed6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ede:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ee2:	8b 00                	mov    (%rax),%eax
  800ee4:	48 98                	cltq   
  800ee6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eee:	c9                   	leaveq 
  800eef:	c3                   	retq   

0000000000800ef0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ef0:	55                   	push   %rbp
  800ef1:	48 89 e5             	mov    %rsp,%rbp
  800ef4:	41 54                	push   %r12
  800ef6:	53                   	push   %rbx
  800ef7:	48 83 ec 60          	sub    $0x60,%rsp
  800efb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800eff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800f03:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f07:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800f0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f0f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f13:	48 8b 0a             	mov    (%rdx),%rcx
  800f16:	48 89 08             	mov    %rcx,(%rax)
  800f19:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f1d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f21:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f25:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f29:	eb 17                	jmp    800f42 <vprintfmt+0x52>
			if (ch == '\0')
  800f2b:	85 db                	test   %ebx,%ebx
  800f2d:	0f 84 ea 04 00 00    	je     80141d <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800f33:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f37:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f3b:	48 89 c6             	mov    %rax,%rsi
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f42:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f46:	0f b6 00             	movzbl (%rax),%eax
  800f49:	0f b6 d8             	movzbl %al,%ebx
  800f4c:	83 fb 25             	cmp    $0x25,%ebx
  800f4f:	0f 95 c0             	setne  %al
  800f52:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	75 d0                	jne    800f2b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f5b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f5f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800f7b:	eb 04                	jmp    800f81 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800f7d:	90                   	nop
  800f7e:	eb 01                	jmp    800f81 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800f80:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f85:	0f b6 00             	movzbl (%rax),%eax
  800f88:	0f b6 d8             	movzbl %al,%ebx
  800f8b:	89 d8                	mov    %ebx,%eax
  800f8d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f92:	83 e8 23             	sub    $0x23,%eax
  800f95:	83 f8 55             	cmp    $0x55,%eax
  800f98:	0f 87 4b 04 00 00    	ja     8013e9 <vprintfmt+0x4f9>
  800f9e:	89 c0                	mov    %eax,%eax
  800fa0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800fa7:	00 
  800fa8:	48 b8 38 59 80 00 00 	movabs $0x805938,%rax
  800faf:	00 00 00 
  800fb2:	48 01 d0             	add    %rdx,%rax
  800fb5:	48 8b 00             	mov    (%rax),%rax
  800fb8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800fbe:	eb c1                	jmp    800f81 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fc4:	eb bb                	jmp    800f81 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fe1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe5:	0f b6 00             	movzbl (%rax),%eax
  800fe8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800feb:	83 fb 2f             	cmp    $0x2f,%ebx
  800fee:	7e 63                	jle    801053 <vprintfmt+0x163>
  800ff0:	83 fb 39             	cmp    $0x39,%ebx
  800ff3:	7f 5e                	jg     801053 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ffa:	eb d1                	jmp    800fcd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ffc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fff:	83 f8 30             	cmp    $0x30,%eax
  801002:	73 17                	jae    80101b <vprintfmt+0x12b>
  801004:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801008:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100b:	89 c0                	mov    %eax,%eax
  80100d:	48 01 d0             	add    %rdx,%rax
  801010:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801013:	83 c2 08             	add    $0x8,%edx
  801016:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801019:	eb 0f                	jmp    80102a <vprintfmt+0x13a>
  80101b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80101f:	48 89 d0             	mov    %rdx,%rax
  801022:	48 83 c2 08          	add    $0x8,%rdx
  801026:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80102a:	8b 00                	mov    (%rax),%eax
  80102c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80102f:	eb 23                	jmp    801054 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801031:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801035:	0f 89 42 ff ff ff    	jns    800f7d <vprintfmt+0x8d>
				width = 0;
  80103b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801042:	e9 36 ff ff ff       	jmpq   800f7d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801047:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80104e:	e9 2e ff ff ff       	jmpq   800f81 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801053:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801054:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801058:	0f 89 22 ff ff ff    	jns    800f80 <vprintfmt+0x90>
				width = precision, precision = -1;
  80105e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801061:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801064:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80106b:	e9 10 ff ff ff       	jmpq   800f80 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801070:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801074:	e9 08 ff ff ff       	jmpq   800f81 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801079:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80107c:	83 f8 30             	cmp    $0x30,%eax
  80107f:	73 17                	jae    801098 <vprintfmt+0x1a8>
  801081:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801085:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801088:	89 c0                	mov    %eax,%eax
  80108a:	48 01 d0             	add    %rdx,%rax
  80108d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801090:	83 c2 08             	add    $0x8,%edx
  801093:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801096:	eb 0f                	jmp    8010a7 <vprintfmt+0x1b7>
  801098:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80109c:	48 89 d0             	mov    %rdx,%rax
  80109f:	48 83 c2 08          	add    $0x8,%rdx
  8010a3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010a7:	8b 00                	mov    (%rax),%eax
  8010a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ad:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8010b1:	48 89 d6             	mov    %rdx,%rsi
  8010b4:	89 c7                	mov    %eax,%edi
  8010b6:	ff d1                	callq  *%rcx
			break;
  8010b8:	e9 5a 03 00 00       	jmpq   801417 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8010bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010c0:	83 f8 30             	cmp    $0x30,%eax
  8010c3:	73 17                	jae    8010dc <vprintfmt+0x1ec>
  8010c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010cc:	89 c0                	mov    %eax,%eax
  8010ce:	48 01 d0             	add    %rdx,%rax
  8010d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010d4:	83 c2 08             	add    $0x8,%edx
  8010d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010da:	eb 0f                	jmp    8010eb <vprintfmt+0x1fb>
  8010dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010e0:	48 89 d0             	mov    %rdx,%rax
  8010e3:	48 83 c2 08          	add    $0x8,%rdx
  8010e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010eb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010ed:	85 db                	test   %ebx,%ebx
  8010ef:	79 02                	jns    8010f3 <vprintfmt+0x203>
				err = -err;
  8010f1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010f3:	83 fb 15             	cmp    $0x15,%ebx
  8010f6:	7f 16                	jg     80110e <vprintfmt+0x21e>
  8010f8:	48 b8 60 58 80 00 00 	movabs $0x805860,%rax
  8010ff:	00 00 00 
  801102:	48 63 d3             	movslq %ebx,%rdx
  801105:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801109:	4d 85 e4             	test   %r12,%r12
  80110c:	75 2e                	jne    80113c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80110e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801112:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801116:	89 d9                	mov    %ebx,%ecx
  801118:	48 ba 21 59 80 00 00 	movabs $0x805921,%rdx
  80111f:	00 00 00 
  801122:	48 89 c7             	mov    %rax,%rdi
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	49 b8 27 14 80 00 00 	movabs $0x801427,%r8
  801131:	00 00 00 
  801134:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801137:	e9 db 02 00 00       	jmpq   801417 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80113c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801140:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801144:	4c 89 e1             	mov    %r12,%rcx
  801147:	48 ba 2a 59 80 00 00 	movabs $0x80592a,%rdx
  80114e:	00 00 00 
  801151:	48 89 c7             	mov    %rax,%rdi
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	49 b8 27 14 80 00 00 	movabs $0x801427,%r8
  801160:	00 00 00 
  801163:	41 ff d0             	callq  *%r8
			break;
  801166:	e9 ac 02 00 00       	jmpq   801417 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80116b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80116e:	83 f8 30             	cmp    $0x30,%eax
  801171:	73 17                	jae    80118a <vprintfmt+0x29a>
  801173:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801177:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80117a:	89 c0                	mov    %eax,%eax
  80117c:	48 01 d0             	add    %rdx,%rax
  80117f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801182:	83 c2 08             	add    $0x8,%edx
  801185:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801188:	eb 0f                	jmp    801199 <vprintfmt+0x2a9>
  80118a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80118e:	48 89 d0             	mov    %rdx,%rax
  801191:	48 83 c2 08          	add    $0x8,%rdx
  801195:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801199:	4c 8b 20             	mov    (%rax),%r12
  80119c:	4d 85 e4             	test   %r12,%r12
  80119f:	75 0a                	jne    8011ab <vprintfmt+0x2bb>
				p = "(null)";
  8011a1:	49 bc 2d 59 80 00 00 	movabs $0x80592d,%r12
  8011a8:	00 00 00 
			if (width > 0 && padc != '-')
  8011ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011af:	7e 7a                	jle    80122b <vprintfmt+0x33b>
  8011b1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011b5:	74 74                	je     80122b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011b7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011ba:	48 98                	cltq   
  8011bc:	48 89 c6             	mov    %rax,%rsi
  8011bf:	4c 89 e7             	mov    %r12,%rdi
  8011c2:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8011c9:	00 00 00 
  8011cc:	ff d0                	callq  *%rax
  8011ce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011d1:	eb 17                	jmp    8011ea <vprintfmt+0x2fa>
					putch(padc, putdat);
  8011d3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8011d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011db:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8011df:	48 89 d6             	mov    %rdx,%rsi
  8011e2:	89 c7                	mov    %eax,%edi
  8011e4:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011e6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ee:	7f e3                	jg     8011d3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011f0:	eb 39                	jmp    80122b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8011f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011f6:	74 1e                	je     801216 <vprintfmt+0x326>
  8011f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8011fb:	7e 05                	jle    801202 <vprintfmt+0x312>
  8011fd:	83 fb 7e             	cmp    $0x7e,%ebx
  801200:	7e 14                	jle    801216 <vprintfmt+0x326>
					putch('?', putdat);
  801202:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801206:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80120a:	48 89 c6             	mov    %rax,%rsi
  80120d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801212:	ff d2                	callq  *%rdx
  801214:	eb 0f                	jmp    801225 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801216:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80121a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80121e:	48 89 c6             	mov    %rax,%rsi
  801221:	89 df                	mov    %ebx,%edi
  801223:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801225:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801229:	eb 01                	jmp    80122c <vprintfmt+0x33c>
  80122b:	90                   	nop
  80122c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801231:	0f be d8             	movsbl %al,%ebx
  801234:	85 db                	test   %ebx,%ebx
  801236:	0f 95 c0             	setne  %al
  801239:	49 83 c4 01          	add    $0x1,%r12
  80123d:	84 c0                	test   %al,%al
  80123f:	74 28                	je     801269 <vprintfmt+0x379>
  801241:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801245:	78 ab                	js     8011f2 <vprintfmt+0x302>
  801247:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80124b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80124f:	79 a1                	jns    8011f2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801251:	eb 16                	jmp    801269 <vprintfmt+0x379>
				putch(' ', putdat);
  801253:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801257:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80125b:	48 89 c6             	mov    %rax,%rsi
  80125e:	bf 20 00 00 00       	mov    $0x20,%edi
  801263:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801265:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801269:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80126d:	7f e4                	jg     801253 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80126f:	e9 a3 01 00 00       	jmpq   801417 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801274:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801278:	be 03 00 00 00       	mov    $0x3,%esi
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 b8 e0 0d 80 00 00 	movabs $0x800de0,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
  80128c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 85 c0             	test   %rax,%rax
  801297:	79 1d                	jns    8012b6 <vprintfmt+0x3c6>
				putch('-', putdat);
  801299:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80129d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8012a1:	48 89 c6             	mov    %rax,%rsi
  8012a4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012a9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8012ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012af:	48 f7 d8             	neg    %rax
  8012b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012b6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012bd:	e9 e8 00 00 00       	jmpq   8013aa <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012c6:	be 03 00 00 00       	mov    $0x3,%esi
  8012cb:	48 89 c7             	mov    %rax,%rdi
  8012ce:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  8012d5:	00 00 00 
  8012d8:	ff d0                	callq  *%rax
  8012da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012de:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012e5:	e9 c0 00 00 00       	jmpq   8013aa <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8012ea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8012ee:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8012f2:	48 89 c6             	mov    %rax,%rsi
  8012f5:	bf 58 00 00 00       	mov    $0x58,%edi
  8012fa:	ff d2                	callq  *%rdx
			putch('X', putdat);
  8012fc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801300:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801304:	48 89 c6             	mov    %rax,%rsi
  801307:	bf 58 00 00 00       	mov    $0x58,%edi
  80130c:	ff d2                	callq  *%rdx
			putch('X', putdat);
  80130e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801312:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801316:	48 89 c6             	mov    %rax,%rsi
  801319:	bf 58 00 00 00       	mov    $0x58,%edi
  80131e:	ff d2                	callq  *%rdx
			break;
  801320:	e9 f2 00 00 00       	jmpq   801417 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801325:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801329:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80132d:	48 89 c6             	mov    %rax,%rsi
  801330:	bf 30 00 00 00       	mov    $0x30,%edi
  801335:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801337:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80133b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80133f:	48 89 c6             	mov    %rax,%rsi
  801342:	bf 78 00 00 00       	mov    $0x78,%edi
  801347:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801349:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134c:	83 f8 30             	cmp    $0x30,%eax
  80134f:	73 17                	jae    801368 <vprintfmt+0x478>
  801351:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801355:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801358:	89 c0                	mov    %eax,%eax
  80135a:	48 01 d0             	add    %rdx,%rax
  80135d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801360:	83 c2 08             	add    $0x8,%edx
  801363:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801366:	eb 0f                	jmp    801377 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801368:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80136c:	48 89 d0             	mov    %rdx,%rax
  80136f:	48 83 c2 08          	add    $0x8,%rdx
  801373:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801377:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80137a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80137e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801385:	eb 23                	jmp    8013aa <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801387:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80138b:	be 03 00 00 00       	mov    $0x3,%esi
  801390:	48 89 c7             	mov    %rax,%rdi
  801393:	48 b8 d0 0c 80 00 00 	movabs $0x800cd0,%rax
  80139a:	00 00 00 
  80139d:	ff d0                	callq  *%rax
  80139f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8013a3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8013aa:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8013af:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8013b2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8013b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c1:	45 89 c1             	mov    %r8d,%r9d
  8013c4:	41 89 f8             	mov    %edi,%r8d
  8013c7:	48 89 c7             	mov    %rax,%rdi
  8013ca:	48 b8 18 0c 80 00 00 	movabs $0x800c18,%rax
  8013d1:	00 00 00 
  8013d4:	ff d0                	callq  *%rax
			break;
  8013d6:	eb 3f                	jmp    801417 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013d8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013dc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013e0:	48 89 c6             	mov    %rax,%rsi
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	ff d2                	callq  *%rdx
			break;
  8013e7:	eb 2e                	jmp    801417 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013e9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013ed:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013f1:	48 89 c6             	mov    %rax,%rsi
  8013f4:	bf 25 00 00 00       	mov    $0x25,%edi
  8013f9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013fb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801400:	eb 05                	jmp    801407 <vprintfmt+0x517>
  801402:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801407:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80140b:	48 83 e8 01          	sub    $0x1,%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3c 25                	cmp    $0x25,%al
  801414:	75 ec                	jne    801402 <vprintfmt+0x512>
				/* do nothing */;
			break;
  801416:	90                   	nop
		}
	}
  801417:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801418:	e9 25 fb ff ff       	jmpq   800f42 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  80141d:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80141e:	48 83 c4 60          	add    $0x60,%rsp
  801422:	5b                   	pop    %rbx
  801423:	41 5c                	pop    %r12
  801425:	5d                   	pop    %rbp
  801426:	c3                   	retq   

0000000000801427 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801427:	55                   	push   %rbp
  801428:	48 89 e5             	mov    %rsp,%rbp
  80142b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801432:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801439:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801440:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801447:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80144e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801455:	84 c0                	test   %al,%al
  801457:	74 20                	je     801479 <printfmt+0x52>
  801459:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80145d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801461:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801465:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801469:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80146d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801471:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801475:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801479:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801480:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801487:	00 00 00 
  80148a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801491:	00 00 00 
  801494:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801498:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80149f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014a6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ad:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014b4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014bb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014c9:	48 89 c7             	mov    %rax,%rdi
  8014cc:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  8014d3:	00 00 00 
  8014d6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014d8:	c9                   	leaveq 
  8014d9:	c3                   	retq   

00000000008014da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	48 83 ec 10          	sub    $0x10,%rsp
  8014e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ed:	8b 40 10             	mov    0x10(%rax),%eax
  8014f0:	8d 50 01             	lea    0x1(%rax),%edx
  8014f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	48 8b 10             	mov    (%rax),%rdx
  801501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801505:	48 8b 40 08          	mov    0x8(%rax),%rax
  801509:	48 39 c2             	cmp    %rax,%rdx
  80150c:	73 17                	jae    801525 <sprintputch+0x4b>
		*b->buf++ = ch;
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	48 8b 00             	mov    (%rax),%rax
  801515:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801518:	88 10                	mov    %dl,(%rax)
  80151a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 89 10             	mov    %rdx,(%rax)
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   

0000000000801527 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	48 83 ec 50          	sub    $0x50,%rsp
  80152f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801533:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801536:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80153a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80153e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801542:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801546:	48 8b 0a             	mov    (%rdx),%rcx
  801549:	48 89 08             	mov    %rcx,(%rax)
  80154c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801550:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801554:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801558:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80155c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801560:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801564:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801567:	48 98                	cltq   
  801569:	48 83 e8 01          	sub    $0x1,%rax
  80156d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801571:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801575:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80157c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801581:	74 06                	je     801589 <vsnprintf+0x62>
  801583:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801587:	7f 07                	jg     801590 <vsnprintf+0x69>
		return -E_INVAL;
  801589:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158e:	eb 2f                	jmp    8015bf <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801590:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801594:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801598:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80159c:	48 89 c6             	mov    %rax,%rsi
  80159f:	48 bf da 14 80 00 00 	movabs $0x8014da,%rdi
  8015a6:	00 00 00 
  8015a9:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015b9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015bf:	c9                   	leaveq 
  8015c0:	c3                   	retq   

00000000008015c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c1:	55                   	push   %rbp
  8015c2:	48 89 e5             	mov    %rsp,%rbp
  8015c5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015d3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015d9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015e0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015e7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015ee:	84 c0                	test   %al,%al
  8015f0:	74 20                	je     801612 <snprintf+0x51>
  8015f2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015f6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015fa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015fe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801602:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801606:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80160a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80160e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801612:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801619:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801620:	00 00 00 
  801623:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80162a:	00 00 00 
  80162d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801631:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801638:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80163f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801646:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80164d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801654:	48 8b 0a             	mov    (%rdx),%rcx
  801657:	48 89 08             	mov    %rcx,(%rax)
  80165a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80165e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801662:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801666:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80166a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801671:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801678:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80167e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801685:	48 89 c7             	mov    %rax,%rdi
  801688:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
  801694:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80169a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016a0:	c9                   	leaveq 
  8016a1:	c3                   	retq   
	...

00000000008016a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016a4:	55                   	push   %rbp
  8016a5:	48 89 e5             	mov    %rsp,%rbp
  8016a8:	48 83 ec 18          	sub    $0x18,%rsp
  8016ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016b7:	eb 09                	jmp    8016c2 <strlen+0x1e>
		n++;
  8016b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	84 c0                	test   %al,%al
  8016cb:	75 ec                	jne    8016b9 <strlen+0x15>
		n++;
	return n;
  8016cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	48 83 ec 20          	sub    $0x20,%rsp
  8016da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016e9:	eb 0e                	jmp    8016f9 <strnlen+0x27>
		n++;
  8016eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016f4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016f9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016fe:	74 0b                	je     80170b <strnlen+0x39>
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	84 c0                	test   %al,%al
  801709:	75 e0                	jne    8016eb <strnlen+0x19>
		n++;
	return n;
  80170b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80170e:	c9                   	leaveq 
  80170f:	c3                   	retq   

0000000000801710 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801710:	55                   	push   %rbp
  801711:	48 89 e5             	mov    %rsp,%rbp
  801714:	48 83 ec 20          	sub    $0x20,%rsp
  801718:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80171c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801728:	90                   	nop
  801729:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80172d:	0f b6 10             	movzbl (%rax),%edx
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	88 10                	mov    %dl,(%rax)
  801736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173a:	0f b6 00             	movzbl (%rax),%eax
  80173d:	84 c0                	test   %al,%al
  80173f:	0f 95 c0             	setne  %al
  801742:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801747:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80174c:	84 c0                	test   %al,%al
  80174e:	75 d9                	jne    801729 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 20          	sub    $0x20,%rsp
  80175e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801762:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
  801779:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80177c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80177f:	48 98                	cltq   
  801781:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801785:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801789:	48 89 d6             	mov    %rdx,%rsi
  80178c:	48 89 c7             	mov    %rax,%rdi
  80178f:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  801796:	00 00 00 
  801799:	ff d0                	callq  *%rax
	return dst;
  80179b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	48 83 ec 28          	sub    $0x28,%rsp
  8017a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017bd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017c4:	00 
  8017c5:	eb 27                	jmp    8017ee <strncpy+0x4d>
		*dst++ = *src;
  8017c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017cb:	0f b6 10             	movzbl (%rax),%edx
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d2:	88 10                	mov    %dl,(%rax)
  8017d4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	84 c0                	test   %al,%al
  8017e2:	74 05                	je     8017e9 <strncpy+0x48>
			src++;
  8017e4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017f6:	72 cf                	jb     8017c7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017fc:	c9                   	leaveq 
  8017fd:	c3                   	retq   

00000000008017fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017fe:	55                   	push   %rbp
  8017ff:	48 89 e5             	mov    %rsp,%rbp
  801802:	48 83 ec 28          	sub    $0x28,%rsp
  801806:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80180a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80180e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801816:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80181a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80181f:	74 37                	je     801858 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801821:	eb 17                	jmp    80183a <strlcpy+0x3c>
			*dst++ = *src++;
  801823:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801827:	0f b6 10             	movzbl (%rax),%edx
  80182a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182e:	88 10                	mov    %dl,(%rax)
  801830:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801835:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80183a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80183f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801844:	74 0b                	je     801851 <strlcpy+0x53>
  801846:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80184a:	0f b6 00             	movzbl (%rax),%eax
  80184d:	84 c0                	test   %al,%al
  80184f:	75 d2                	jne    801823 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801855:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801858:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80185c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801860:	48 89 d1             	mov    %rdx,%rcx
  801863:	48 29 c1             	sub    %rax,%rcx
  801866:	48 89 c8             	mov    %rcx,%rax
}
  801869:	c9                   	leaveq 
  80186a:	c3                   	retq   

000000000080186b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80186b:	55                   	push   %rbp
  80186c:	48 89 e5             	mov    %rsp,%rbp
  80186f:	48 83 ec 10          	sub    $0x10,%rsp
  801873:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80187b:	eb 0a                	jmp    801887 <strcmp+0x1c>
		p++, q++;
  80187d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801882:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801887:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188b:	0f b6 00             	movzbl (%rax),%eax
  80188e:	84 c0                	test   %al,%al
  801890:	74 12                	je     8018a4 <strcmp+0x39>
  801892:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801896:	0f b6 10             	movzbl (%rax),%edx
  801899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189d:	0f b6 00             	movzbl (%rax),%eax
  8018a0:	38 c2                	cmp    %al,%dl
  8018a2:	74 d9                	je     80187d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	0f b6 d0             	movzbl %al,%edx
  8018ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b2:	0f b6 00             	movzbl (%rax),%eax
  8018b5:	0f b6 c0             	movzbl %al,%eax
  8018b8:	89 d1                	mov    %edx,%ecx
  8018ba:	29 c1                	sub    %eax,%ecx
  8018bc:	89 c8                	mov    %ecx,%eax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 18          	sub    $0x18,%rsp
  8018c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018d4:	eb 0f                	jmp    8018e5 <strncmp+0x25>
		n--, p++, q++;
  8018d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ea:	74 1d                	je     801909 <strncmp+0x49>
  8018ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	84 c0                	test   %al,%al
  8018f5:	74 12                	je     801909 <strncmp+0x49>
  8018f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fb:	0f b6 10             	movzbl (%rax),%edx
  8018fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801902:	0f b6 00             	movzbl (%rax),%eax
  801905:	38 c2                	cmp    %al,%dl
  801907:	74 cd                	je     8018d6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801909:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80190e:	75 07                	jne    801917 <strncmp+0x57>
		return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
  801915:	eb 1a                	jmp    801931 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	0f b6 d0             	movzbl %al,%edx
  801921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	0f b6 c0             	movzbl %al,%eax
  80192b:	89 d1                	mov    %edx,%ecx
  80192d:	29 c1                	sub    %eax,%ecx
  80192f:	89 c8                	mov    %ecx,%eax
}
  801931:	c9                   	leaveq 
  801932:	c3                   	retq   

0000000000801933 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801933:	55                   	push   %rbp
  801934:	48 89 e5             	mov    %rsp,%rbp
  801937:	48 83 ec 10          	sub    $0x10,%rsp
  80193b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80193f:	89 f0                	mov    %esi,%eax
  801941:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801944:	eb 17                	jmp    80195d <strchr+0x2a>
		if (*s == c)
  801946:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801950:	75 06                	jne    801958 <strchr+0x25>
			return (char *) s;
  801952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801956:	eb 15                	jmp    80196d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801958:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80195d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801961:	0f b6 00             	movzbl (%rax),%eax
  801964:	84 c0                	test   %al,%al
  801966:	75 de                	jne    801946 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196d:	c9                   	leaveq 
  80196e:	c3                   	retq   

000000000080196f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80196f:	55                   	push   %rbp
  801970:	48 89 e5             	mov    %rsp,%rbp
  801973:	48 83 ec 10          	sub    $0x10,%rsp
  801977:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80197b:	89 f0                	mov    %esi,%eax
  80197d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801980:	eb 11                	jmp    801993 <strfind+0x24>
		if (*s == c)
  801982:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801986:	0f b6 00             	movzbl (%rax),%eax
  801989:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80198c:	74 12                	je     8019a0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80198e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801993:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801997:	0f b6 00             	movzbl (%rax),%eax
  80199a:	84 c0                	test   %al,%al
  80199c:	75 e4                	jne    801982 <strfind+0x13>
  80199e:	eb 01                	jmp    8019a1 <strfind+0x32>
		if (*s == c)
			break;
  8019a0:	90                   	nop
	return (char *) s;
  8019a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019a5:	c9                   	leaveq 
  8019a6:	c3                   	retq   

00000000008019a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019a7:	55                   	push   %rbp
  8019a8:	48 89 e5             	mov    %rsp,%rbp
  8019ab:	48 83 ec 18          	sub    $0x18,%rsp
  8019af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019b3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019bf:	75 06                	jne    8019c7 <memset+0x20>
		return v;
  8019c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c5:	eb 69                	jmp    801a30 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019cb:	83 e0 03             	and    $0x3,%eax
  8019ce:	48 85 c0             	test   %rax,%rax
  8019d1:	75 48                	jne    801a1b <memset+0x74>
  8019d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d7:	83 e0 03             	and    $0x3,%eax
  8019da:	48 85 c0             	test   %rax,%rax
  8019dd:	75 3c                	jne    801a1b <memset+0x74>
		c &= 0xFF;
  8019df:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019e9:	89 c2                	mov    %eax,%edx
  8019eb:	c1 e2 18             	shl    $0x18,%edx
  8019ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019f1:	c1 e0 10             	shl    $0x10,%eax
  8019f4:	09 c2                	or     %eax,%edx
  8019f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019f9:	c1 e0 08             	shl    $0x8,%eax
  8019fc:	09 d0                	or     %edx,%eax
  8019fe:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a05:	48 89 c1             	mov    %rax,%rcx
  801a08:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a10:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a13:	48 89 d7             	mov    %rdx,%rdi
  801a16:	fc                   	cld    
  801a17:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a19:	eb 11                	jmp    801a2c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a1f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a22:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a26:	48 89 d7             	mov    %rdx,%rdi
  801a29:	fc                   	cld    
  801a2a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a30:	c9                   	leaveq 
  801a31:	c3                   	retq   

0000000000801a32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a32:	55                   	push   %rbp
  801a33:	48 89 e5             	mov    %rsp,%rbp
  801a36:	48 83 ec 28          	sub    $0x28,%rsp
  801a3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a42:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a5e:	0f 83 88 00 00 00    	jae    801aec <memmove+0xba>
  801a64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a6c:	48 01 d0             	add    %rdx,%rax
  801a6f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a73:	76 77                	jbe    801aec <memmove+0xba>
		s += n;
  801a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a79:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a89:	83 e0 03             	and    $0x3,%eax
  801a8c:	48 85 c0             	test   %rax,%rax
  801a8f:	75 3b                	jne    801acc <memmove+0x9a>
  801a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a95:	83 e0 03             	and    $0x3,%eax
  801a98:	48 85 c0             	test   %rax,%rax
  801a9b:	75 2f                	jne    801acc <memmove+0x9a>
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	83 e0 03             	and    $0x3,%eax
  801aa4:	48 85 c0             	test   %rax,%rax
  801aa7:	75 23                	jne    801acc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aad:	48 83 e8 04          	sub    $0x4,%rax
  801ab1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ab5:	48 83 ea 04          	sub    $0x4,%rdx
  801ab9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801abd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ac1:	48 89 c7             	mov    %rax,%rdi
  801ac4:	48 89 d6             	mov    %rdx,%rsi
  801ac7:	fd                   	std    
  801ac8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801aca:	eb 1d                	jmp    801ae9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801adc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae0:	48 89 d7             	mov    %rdx,%rdi
  801ae3:	48 89 c1             	mov    %rax,%rcx
  801ae6:	fd                   	std    
  801ae7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ae9:	fc                   	cld    
  801aea:	eb 57                	jmp    801b43 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801aec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af0:	83 e0 03             	and    $0x3,%eax
  801af3:	48 85 c0             	test   %rax,%rax
  801af6:	75 36                	jne    801b2e <memmove+0xfc>
  801af8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afc:	83 e0 03             	and    $0x3,%eax
  801aff:	48 85 c0             	test   %rax,%rax
  801b02:	75 2a                	jne    801b2e <memmove+0xfc>
  801b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b08:	83 e0 03             	and    $0x3,%eax
  801b0b:	48 85 c0             	test   %rax,%rax
  801b0e:	75 1e                	jne    801b2e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b14:	48 89 c1             	mov    %rax,%rcx
  801b17:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b23:	48 89 c7             	mov    %rax,%rdi
  801b26:	48 89 d6             	mov    %rdx,%rsi
  801b29:	fc                   	cld    
  801b2a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b2c:	eb 15                	jmp    801b43 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b36:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b3a:	48 89 c7             	mov    %rax,%rdi
  801b3d:	48 89 d6             	mov    %rdx,%rsi
  801b40:	fc                   	cld    
  801b41:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b47:	c9                   	leaveq 
  801b48:	c3                   	retq   

0000000000801b49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b49:	55                   	push   %rbp
  801b4a:	48 89 e5             	mov    %rsp,%rbp
  801b4d:	48 83 ec 18          	sub    $0x18,%rsp
  801b51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b59:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b61:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b69:	48 89 ce             	mov    %rcx,%rsi
  801b6c:	48 89 c7             	mov    %rax,%rdi
  801b6f:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	callq  *%rax
}
  801b7b:	c9                   	leaveq 
  801b7c:	c3                   	retq   

0000000000801b7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b7d:	55                   	push   %rbp
  801b7e:	48 89 e5             	mov    %rsp,%rbp
  801b81:	48 83 ec 28          	sub    $0x28,%rsp
  801b85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b8d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801ba1:	eb 38                	jmp    801bdb <memcmp+0x5e>
		if (*s1 != *s2)
  801ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba7:	0f b6 10             	movzbl (%rax),%edx
  801baa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bae:	0f b6 00             	movzbl (%rax),%eax
  801bb1:	38 c2                	cmp    %al,%dl
  801bb3:	74 1c                	je     801bd1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb9:	0f b6 00             	movzbl (%rax),%eax
  801bbc:	0f b6 d0             	movzbl %al,%edx
  801bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc3:	0f b6 00             	movzbl (%rax),%eax
  801bc6:	0f b6 c0             	movzbl %al,%eax
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	29 c1                	sub    %eax,%ecx
  801bcd:	89 c8                	mov    %ecx,%eax
  801bcf:	eb 20                	jmp    801bf1 <memcmp+0x74>
		s1++, s2++;
  801bd1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bd6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bdb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801be0:	0f 95 c0             	setne  %al
  801be3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801be8:	84 c0                	test   %al,%al
  801bea:	75 b7                	jne    801ba3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 28          	sub    $0x28,%rsp
  801bfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0e:	48 01 d0             	add    %rdx,%rax
  801c11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c15:	eb 13                	jmp    801c2a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1b:	0f b6 10             	movzbl (%rax),%edx
  801c1e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c21:	38 c2                	cmp    %al,%dl
  801c23:	74 11                	je     801c36 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c25:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c32:	72 e3                	jb     801c17 <memfind+0x24>
  801c34:	eb 01                	jmp    801c37 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c36:	90                   	nop
	return (void *) s;
  801c37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 38          	sub    $0x38,%rsp
  801c45:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c49:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c4d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c57:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c5e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c5f:	eb 05                	jmp    801c66 <strtol+0x29>
		s++;
  801c61:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6a:	0f b6 00             	movzbl (%rax),%eax
  801c6d:	3c 20                	cmp    $0x20,%al
  801c6f:	74 f0                	je     801c61 <strtol+0x24>
  801c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c75:	0f b6 00             	movzbl (%rax),%eax
  801c78:	3c 09                	cmp    $0x9,%al
  801c7a:	74 e5                	je     801c61 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c80:	0f b6 00             	movzbl (%rax),%eax
  801c83:	3c 2b                	cmp    $0x2b,%al
  801c85:	75 07                	jne    801c8e <strtol+0x51>
		s++;
  801c87:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c8c:	eb 17                	jmp    801ca5 <strtol+0x68>
	else if (*s == '-')
  801c8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c92:	0f b6 00             	movzbl (%rax),%eax
  801c95:	3c 2d                	cmp    $0x2d,%al
  801c97:	75 0c                	jne    801ca5 <strtol+0x68>
		s++, neg = 1;
  801c99:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ca5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ca9:	74 06                	je     801cb1 <strtol+0x74>
  801cab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801caf:	75 28                	jne    801cd9 <strtol+0x9c>
  801cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb5:	0f b6 00             	movzbl (%rax),%eax
  801cb8:	3c 30                	cmp    $0x30,%al
  801cba:	75 1d                	jne    801cd9 <strtol+0x9c>
  801cbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc0:	48 83 c0 01          	add    $0x1,%rax
  801cc4:	0f b6 00             	movzbl (%rax),%eax
  801cc7:	3c 78                	cmp    $0x78,%al
  801cc9:	75 0e                	jne    801cd9 <strtol+0x9c>
		s += 2, base = 16;
  801ccb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801cd0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cd7:	eb 2c                	jmp    801d05 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cd9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cdd:	75 19                	jne    801cf8 <strtol+0xbb>
  801cdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce3:	0f b6 00             	movzbl (%rax),%eax
  801ce6:	3c 30                	cmp    $0x30,%al
  801ce8:	75 0e                	jne    801cf8 <strtol+0xbb>
		s++, base = 8;
  801cea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cf6:	eb 0d                	jmp    801d05 <strtol+0xc8>
	else if (base == 0)
  801cf8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cfc:	75 07                	jne    801d05 <strtol+0xc8>
		base = 10;
  801cfe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d09:	0f b6 00             	movzbl (%rax),%eax
  801d0c:	3c 2f                	cmp    $0x2f,%al
  801d0e:	7e 1d                	jle    801d2d <strtol+0xf0>
  801d10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d14:	0f b6 00             	movzbl (%rax),%eax
  801d17:	3c 39                	cmp    $0x39,%al
  801d19:	7f 12                	jg     801d2d <strtol+0xf0>
			dig = *s - '0';
  801d1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1f:	0f b6 00             	movzbl (%rax),%eax
  801d22:	0f be c0             	movsbl %al,%eax
  801d25:	83 e8 30             	sub    $0x30,%eax
  801d28:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d2b:	eb 4e                	jmp    801d7b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d31:	0f b6 00             	movzbl (%rax),%eax
  801d34:	3c 60                	cmp    $0x60,%al
  801d36:	7e 1d                	jle    801d55 <strtol+0x118>
  801d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3c:	0f b6 00             	movzbl (%rax),%eax
  801d3f:	3c 7a                	cmp    $0x7a,%al
  801d41:	7f 12                	jg     801d55 <strtol+0x118>
			dig = *s - 'a' + 10;
  801d43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d47:	0f b6 00             	movzbl (%rax),%eax
  801d4a:	0f be c0             	movsbl %al,%eax
  801d4d:	83 e8 57             	sub    $0x57,%eax
  801d50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d53:	eb 26                	jmp    801d7b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d59:	0f b6 00             	movzbl (%rax),%eax
  801d5c:	3c 40                	cmp    $0x40,%al
  801d5e:	7e 47                	jle    801da7 <strtol+0x16a>
  801d60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d64:	0f b6 00             	movzbl (%rax),%eax
  801d67:	3c 5a                	cmp    $0x5a,%al
  801d69:	7f 3c                	jg     801da7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801d6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6f:	0f b6 00             	movzbl (%rax),%eax
  801d72:	0f be c0             	movsbl %al,%eax
  801d75:	83 e8 37             	sub    $0x37,%eax
  801d78:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d7e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d81:	7d 23                	jge    801da6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801d83:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d88:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d8b:	48 98                	cltq   
  801d8d:	48 89 c2             	mov    %rax,%rdx
  801d90:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801d95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d98:	48 98                	cltq   
  801d9a:	48 01 d0             	add    %rdx,%rax
  801d9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801da1:	e9 5f ff ff ff       	jmpq   801d05 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801da6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801da7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801dac:	74 0b                	je     801db9 <strtol+0x17c>
		*endptr = (char *) s;
  801dae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801db2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801db6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801db9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dbd:	74 09                	je     801dc8 <strtol+0x18b>
  801dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc3:	48 f7 d8             	neg    %rax
  801dc6:	eb 04                	jmp    801dcc <strtol+0x18f>
  801dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801dcc:	c9                   	leaveq 
  801dcd:	c3                   	retq   

0000000000801dce <strstr>:

char * strstr(const char *in, const char *str)
{
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
  801dd2:	48 83 ec 30          	sub    $0x30,%rsp
  801dd6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801dde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801de2:	0f b6 00             	movzbl (%rax),%eax
  801de5:	88 45 ff             	mov    %al,-0x1(%rbp)
  801de8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801ded:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801df1:	75 06                	jne    801df9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801df3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df7:	eb 68                	jmp    801e61 <strstr+0x93>

	len = strlen(str);
  801df9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dfd:	48 89 c7             	mov    %rax,%rdi
  801e00:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  801e07:	00 00 00 
  801e0a:	ff d0                	callq  *%rax
  801e0c:	48 98                	cltq   
  801e0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e16:	0f b6 00             	movzbl (%rax),%eax
  801e19:	88 45 ef             	mov    %al,-0x11(%rbp)
  801e1c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801e21:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e25:	75 07                	jne    801e2e <strstr+0x60>
				return (char *) 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2c:	eb 33                	jmp    801e61 <strstr+0x93>
		} while (sc != c);
  801e2e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e32:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e35:	75 db                	jne    801e12 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801e37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e3b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e43:	48 89 ce             	mov    %rcx,%rsi
  801e46:	48 89 c7             	mov    %rax,%rdi
  801e49:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 b9                	jne    801e12 <strstr+0x44>

	return (char *) (in - 1);
  801e59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5d:	48 83 e8 01          	sub    $0x1,%rax
}
  801e61:	c9                   	leaveq 
  801e62:	c3                   	retq   
	...

0000000000801e64 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e64:	55                   	push   %rbp
  801e65:	48 89 e5             	mov    %rsp,%rbp
  801e68:	53                   	push   %rbx
  801e69:	48 83 ec 58          	sub    $0x58,%rsp
  801e6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e70:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e73:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e77:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e7b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e7f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e83:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e86:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801e89:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e8d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e91:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e95:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e99:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e9d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ea0:	4c 89 c3             	mov    %r8,%rbx
  801ea3:	cd 30                	int    $0x30
  801ea5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801ea9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801ead:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801eb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801eb5:	74 3e                	je     801ef5 <syscall+0x91>
  801eb7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ebc:	7e 37                	jle    801ef5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ebe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ec2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ec5:	49 89 d0             	mov    %rdx,%r8
  801ec8:	89 c1                	mov    %eax,%ecx
  801eca:	48 ba e8 5b 80 00 00 	movabs $0x805be8,%rdx
  801ed1:	00 00 00 
  801ed4:	be 23 00 00 00       	mov    $0x23,%esi
  801ed9:	48 bf 05 5c 80 00 00 	movabs $0x805c05,%rdi
  801ee0:	00 00 00 
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee8:	49 b9 04 09 80 00 00 	movabs $0x800904,%r9
  801eef:	00 00 00 
  801ef2:	41 ff d1             	callq  *%r9

	return ret;
  801ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ef9:	48 83 c4 58          	add    $0x58,%rsp
  801efd:	5b                   	pop    %rbx
  801efe:	5d                   	pop    %rbp
  801eff:	c3                   	retq   

0000000000801f00 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f00:	55                   	push   %rbp
  801f01:	48 89 e5             	mov    %rsp,%rbp
  801f04:	48 83 ec 20          	sub    $0x20,%rsp
  801f08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1f:	00 
  801f20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2c:	48 89 d1             	mov    %rdx,%rcx
  801f2f:	48 89 c2             	mov    %rax,%rdx
  801f32:	be 00 00 00 00       	mov    $0x0,%esi
  801f37:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3c:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
}
  801f48:	c9                   	leaveq 
  801f49:	c3                   	retq   

0000000000801f4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801f4a:	55                   	push   %rbp
  801f4b:	48 89 e5             	mov    %rsp,%rbp
  801f4e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f59:	00 
  801f5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	be 00 00 00 00       	mov    $0x0,%esi
  801f75:	bf 01 00 00 00       	mov    $0x1,%edi
  801f7a:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
}
  801f86:	c9                   	leaveq 
  801f87:	c3                   	retq   

0000000000801f88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f88:	55                   	push   %rbp
  801f89:	48 89 e5             	mov    %rsp,%rbp
  801f8c:	48 83 ec 20          	sub    $0x20,%rsp
  801f90:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f96:	48 98                	cltq   
  801f98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f9f:	00 
  801fa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fb1:	48 89 c2             	mov    %rax,%rdx
  801fb4:	be 01 00 00 00       	mov    $0x1,%esi
  801fb9:	bf 03 00 00 00       	mov    $0x3,%edi
  801fbe:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
}
  801fca:	c9                   	leaveq 
  801fcb:	c3                   	retq   

0000000000801fcc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fcc:	55                   	push   %rbp
  801fcd:	48 89 e5             	mov    %rsp,%rbp
  801fd0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801fd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fdb:	00 
  801fdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff2:	be 00 00 00 00       	mov    $0x0,%esi
  801ff7:	bf 02 00 00 00       	mov    $0x2,%edi
  801ffc:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
}
  802008:	c9                   	leaveq 
  802009:	c3                   	retq   

000000000080200a <sys_yield>:

void
sys_yield(void)
{
  80200a:	55                   	push   %rbp
  80200b:	48 89 e5             	mov    %rsp,%rbp
  80200e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802012:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802019:	00 
  80201a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802020:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802026:	b9 00 00 00 00       	mov    $0x0,%ecx
  80202b:	ba 00 00 00 00       	mov    $0x0,%edx
  802030:	be 00 00 00 00       	mov    $0x0,%esi
  802035:	bf 0b 00 00 00       	mov    $0xb,%edi
  80203a:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
}
  802046:	c9                   	leaveq 
  802047:	c3                   	retq   

0000000000802048 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802048:	55                   	push   %rbp
  802049:	48 89 e5             	mov    %rsp,%rbp
  80204c:	48 83 ec 20          	sub    $0x20,%rsp
  802050:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802053:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802057:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80205a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205d:	48 63 c8             	movslq %eax,%rcx
  802060:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802067:	48 98                	cltq   
  802069:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802070:	00 
  802071:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802077:	49 89 c8             	mov    %rcx,%r8
  80207a:	48 89 d1             	mov    %rdx,%rcx
  80207d:	48 89 c2             	mov    %rax,%rdx
  802080:	be 01 00 00 00       	mov    $0x1,%esi
  802085:	bf 04 00 00 00       	mov    $0x4,%edi
  80208a:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802091:	00 00 00 
  802094:	ff d0                	callq  *%rax
}
  802096:	c9                   	leaveq 
  802097:	c3                   	retq   

0000000000802098 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
  80209c:	48 83 ec 30          	sub    $0x30,%rsp
  8020a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020aa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020ae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020b2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020b5:	48 63 c8             	movslq %eax,%rcx
  8020b8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020bf:	48 63 f0             	movslq %eax,%rsi
  8020c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c9:	48 98                	cltq   
  8020cb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020cf:	49 89 f9             	mov    %rdi,%r9
  8020d2:	49 89 f0             	mov    %rsi,%r8
  8020d5:	48 89 d1             	mov    %rdx,%rcx
  8020d8:	48 89 c2             	mov    %rax,%rdx
  8020db:	be 01 00 00 00       	mov    $0x1,%esi
  8020e0:	bf 05 00 00 00       	mov    $0x5,%edi
  8020e5:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  8020ec:	00 00 00 
  8020ef:	ff d0                	callq  *%rax
}
  8020f1:	c9                   	leaveq 
  8020f2:	c3                   	retq   

00000000008020f3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020f3:	55                   	push   %rbp
  8020f4:	48 89 e5             	mov    %rsp,%rbp
  8020f7:	48 83 ec 20          	sub    $0x20,%rsp
  8020fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802102:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802109:	48 98                	cltq   
  80210b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802112:	00 
  802113:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211f:	48 89 d1             	mov    %rdx,%rcx
  802122:	48 89 c2             	mov    %rax,%rdx
  802125:	be 01 00 00 00       	mov    $0x1,%esi
  80212a:	bf 06 00 00 00       	mov    $0x6,%edi
  80212f:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802136:	00 00 00 
  802139:	ff d0                	callq  *%rax
}
  80213b:	c9                   	leaveq 
  80213c:	c3                   	retq   

000000000080213d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80213d:	55                   	push   %rbp
  80213e:	48 89 e5             	mov    %rsp,%rbp
  802141:	48 83 ec 20          	sub    $0x20,%rsp
  802145:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802148:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80214b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80214e:	48 63 d0             	movslq %eax,%rdx
  802151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802154:	48 98                	cltq   
  802156:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80215d:	00 
  80215e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802164:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80216a:	48 89 d1             	mov    %rdx,%rcx
  80216d:	48 89 c2             	mov    %rax,%rdx
  802170:	be 01 00 00 00       	mov    $0x1,%esi
  802175:	bf 08 00 00 00       	mov    $0x8,%edi
  80217a:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
  80218c:	48 83 ec 20          	sub    $0x20,%rsp
  802190:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802193:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802197:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80219b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219e:	48 98                	cltq   
  8021a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a7:	00 
  8021a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b4:	48 89 d1             	mov    %rdx,%rcx
  8021b7:	48 89 c2             	mov    %rax,%rdx
  8021ba:	be 01 00 00 00       	mov    $0x1,%esi
  8021bf:	bf 09 00 00 00       	mov    $0x9,%edi
  8021c4:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  8021cb:	00 00 00 
  8021ce:	ff d0                	callq  *%rax
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 20          	sub    $0x20,%rsp
  8021da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e8:	48 98                	cltq   
  8021ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021f1:	00 
  8021f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021fe:	48 89 d1             	mov    %rdx,%rcx
  802201:	48 89 c2             	mov    %rax,%rdx
  802204:	be 01 00 00 00       	mov    $0x1,%esi
  802209:	bf 0a 00 00 00       	mov    $0xa,%edi
  80220e:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
}
  80221a:	c9                   	leaveq 
  80221b:	c3                   	retq   

000000000080221c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80221c:	55                   	push   %rbp
  80221d:	48 89 e5             	mov    %rsp,%rbp
  802220:	48 83 ec 30          	sub    $0x30,%rsp
  802224:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802227:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80222b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80222f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802232:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802235:	48 63 f0             	movslq %eax,%rsi
  802238:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80223c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223f:	48 98                	cltq   
  802241:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802245:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80224c:	00 
  80224d:	49 89 f1             	mov    %rsi,%r9
  802250:	49 89 c8             	mov    %rcx,%r8
  802253:	48 89 d1             	mov    %rdx,%rcx
  802256:	48 89 c2             	mov    %rax,%rdx
  802259:	be 00 00 00 00       	mov    $0x0,%esi
  80225e:	bf 0c 00 00 00       	mov    $0xc,%edi
  802263:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
}
  80226f:	c9                   	leaveq 
  802270:	c3                   	retq   

0000000000802271 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802271:	55                   	push   %rbp
  802272:	48 89 e5             	mov    %rsp,%rbp
  802275:	48 83 ec 20          	sub    $0x20,%rsp
  802279:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80227d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802281:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802288:	00 
  802289:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80228f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802295:	b9 00 00 00 00       	mov    $0x0,%ecx
  80229a:	48 89 c2             	mov    %rax,%rdx
  80229d:	be 01 00 00 00       	mov    $0x1,%esi
  8022a2:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022a7:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
}
  8022b3:	c9                   	leaveq 
  8022b4:	c3                   	retq   

00000000008022b5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8022b5:	55                   	push   %rbp
  8022b6:	48 89 e5             	mov    %rsp,%rbp
  8022b9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8022bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022c4:	00 
  8022c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8022db:	be 00 00 00 00       	mov    $0x0,%esi
  8022e0:	bf 0e 00 00 00       	mov    $0xe,%edi
  8022e5:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	callq  *%rax
}
  8022f1:	c9                   	leaveq 
  8022f2:	c3                   	retq   

00000000008022f3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8022f3:	55                   	push   %rbp
  8022f4:	48 89 e5             	mov    %rsp,%rbp
  8022f7:	48 83 ec 30          	sub    $0x30,%rsp
  8022fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802302:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802305:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802309:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80230d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802310:	48 63 c8             	movslq %eax,%rcx
  802313:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802317:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80231a:	48 63 f0             	movslq %eax,%rsi
  80231d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802324:	48 98                	cltq   
  802326:	48 89 0c 24          	mov    %rcx,(%rsp)
  80232a:	49 89 f9             	mov    %rdi,%r9
  80232d:	49 89 f0             	mov    %rsi,%r8
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	48 89 c2             	mov    %rax,%rdx
  802336:	be 00 00 00 00       	mov    $0x0,%esi
  80233b:	bf 0f 00 00 00       	mov    $0xf,%edi
  802340:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 20          	sub    $0x20,%rsp
  802356:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80235a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80235e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802366:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80236d:	00 
  80236e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802374:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237a:	48 89 d1             	mov    %rdx,%rcx
  80237d:	48 89 c2             	mov    %rax,%rdx
  802380:	be 00 00 00 00       	mov    $0x0,%esi
  802385:	bf 10 00 00 00       	mov    $0x10,%edi
  80238a:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802391:	00 00 00 
  802394:	ff d0                	callq  *%rax
}
  802396:	c9                   	leaveq 
  802397:	c3                   	retq   

0000000000802398 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802398:	55                   	push   %rbp
  802399:	48 89 e5             	mov    %rsp,%rbp
  80239c:	48 83 ec 40          	sub    $0x40,%rsp
  8023a0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8023a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8023a8:	48 8b 00             	mov    (%rax),%rax
  8023ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8023af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8023b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023b7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  8023ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023be:	48 89 c2             	mov    %rax,%rdx
  8023c1:	48 c1 ea 0c          	shr    $0xc,%rdx
  8023c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023cc:	01 00 00 
  8023cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  8023d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023da:	83 e0 02             	and    $0x2,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 84 4f 01 00 00    	je     802534 <pgfault+0x19c>
  8023e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e9:	48 89 c2             	mov    %rax,%rdx
  8023ec:	48 c1 ea 0c          	shr    $0xc,%rdx
  8023f0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023f7:	01 00 00 
  8023fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023fe:	25 00 08 00 00       	and    $0x800,%eax
  802403:	48 85 c0             	test   %rax,%rax
  802406:	0f 84 28 01 00 00    	je     802534 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  80240c:	ba 07 00 00 00       	mov    $0x7,%edx
  802411:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802416:	bf 00 00 00 00       	mov    $0x0,%edi
  80241b:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 85 db 00 00 00    	jne    80250a <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  80242f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802433:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802437:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80243b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802441:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  802445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802449:	ba 00 10 00 00       	mov    $0x1000,%edx
  80244e:	48 89 c6             	mov    %rax,%rsi
  802451:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802456:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  802462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802466:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80246c:	48 89 c1             	mov    %rax,%rcx
  80246f:	ba 00 00 00 00       	mov    $0x0,%edx
  802474:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802479:	bf 00 00 00 00       	mov    $0x0,%edi
  80247e:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
  80248a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  80248d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802491:	79 2a                	jns    8024bd <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  802493:	48 ba 18 5c 80 00 00 	movabs $0x805c18,%rdx
  80249a:	00 00 00 
  80249d:	be 28 00 00 00       	mov    $0x28,%esi
  8024a2:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  8024a9:	00 00 00 
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b1:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  8024b8:	00 00 00 
  8024bb:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  8024bd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c7:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8024ce:	00 00 00 
  8024d1:	ff d0                	callq  *%rax
  8024d3:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  8024d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8024da:	0f 89 84 00 00 00    	jns    802564 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  8024e0:	48 ba 50 5c 80 00 00 	movabs $0x805c50,%rdx
  8024e7:	00 00 00 
  8024ea:	be 2c 00 00 00       	mov    $0x2c,%esi
  8024ef:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  8024f6:	00 00 00 
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  802505:	00 00 00 
  802508:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  80250a:	48 ba 80 5c 80 00 00 	movabs $0x805c80,%rdx
  802511:	00 00 00 
  802514:	be 31 00 00 00       	mov    $0x31,%esi
  802519:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802520:	00 00 00 
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  80252f:	00 00 00 
  802532:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802534:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802537:	89 c1                	mov    %eax,%ecx
  802539:	48 ba aa 5c 80 00 00 	movabs $0x805caa,%rdx
  802540:	00 00 00 
  802543:	be 35 00 00 00       	mov    $0x35,%esi
  802548:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  80254f:	00 00 00 
  802552:	b8 00 00 00 00       	mov    $0x0,%eax
  802557:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80255e:	00 00 00 
  802561:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  802564:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  802565:	c9                   	leaveq 
  802566:	c3                   	retq   

0000000000802567 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802567:	55                   	push   %rbp
  802568:	48 89 e5             	mov    %rsp,%rbp
  80256b:	48 83 ec 30          	sub    $0x30,%rsp
  80256f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802572:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  802575:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80257c:	01 00 00 
  80257f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802582:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  80258a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80258d:	48 c1 e0 0c          	shl    $0xc,%rax
  802591:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802599:	25 07 0e 00 00       	and    $0xe07,%eax
  80259e:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  8025a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a4:	25 00 04 00 00       	and    $0x400,%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 62                	je     80260f <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  8025ad:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8025b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bb:	41 89 f0             	mov    %esi,%r8d
  8025be:	48 89 c6             	mov    %rax,%rsi
  8025c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c6:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8025d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8025d9:	0f 89 78 01 00 00    	jns    802757 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8025df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8025e2:	89 c1                	mov    %eax,%ecx
  8025e4:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  8025eb:	00 00 00 
  8025ee:	be 4f 00 00 00       	mov    $0x4f,%esi
  8025f3:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  8025fa:	00 00 00 
  8025fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802602:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  802609:	00 00 00 
  80260c:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  80260f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802612:	25 00 08 00 00       	and    $0x800,%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	75 0e                	jne    802629 <duppage+0xc2>
  80261b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261e:	83 e0 02             	and    $0x2,%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	0f 84 d0 00 00 00    	je     8026f9 <duppage+0x192>
		perm &= ~PTE_W;
  802629:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  80262d:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  802634:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802637:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80263b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80263e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802642:	41 89 f0             	mov    %esi,%r8d
  802645:	48 89 c6             	mov    %rax,%rsi
  802648:	bf 00 00 00 00       	mov    $0x0,%edi
  80264d:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  802654:	00 00 00 
  802657:	ff d0                	callq  *%rax
  802659:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80265c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802660:	79 30                	jns    802692 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  802662:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802665:	89 c1                	mov    %eax,%ecx
  802667:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  80266e:	00 00 00 
  802671:	be 57 00 00 00       	mov    $0x57,%esi
  802676:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  80267d:	00 00 00 
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80268c:	00 00 00 
  80268f:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802692:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802695:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269d:	41 89 c8             	mov    %ecx,%r8d
  8026a0:	48 89 d1             	mov    %rdx,%rcx
  8026a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a8:	48 89 c6             	mov    %rax,%rsi
  8026ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b0:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  8026b7:	00 00 00 
  8026ba:	ff d0                	callq  *%rax
  8026bc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8026bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8026c3:	0f 89 8e 00 00 00    	jns    802757 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8026c9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8026cc:	89 c1                	mov    %eax,%ecx
  8026ce:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  8026d5:	00 00 00 
  8026d8:	be 5b 00 00 00       	mov    $0x5b,%esi
  8026dd:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  8026e4:	00 00 00 
  8026e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ec:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8026f3:	00 00 00 
  8026f6:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  8026f9:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8026fc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802700:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802707:	41 89 f0             	mov    %esi,%r8d
  80270a:	48 89 c6             	mov    %rax,%rsi
  80270d:	bf 00 00 00 00       	mov    $0x0,%edi
  802712:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
  80271e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802721:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802725:	79 30                	jns    802757 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802727:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80272a:	89 c1                	mov    %eax,%ecx
  80272c:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  802733:	00 00 00 
  802736:	be 61 00 00 00       	mov    $0x61,%esi
  80273b:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802742:	00 00 00 
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
  80274a:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  802751:	00 00 00 
  802754:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275c:	c9                   	leaveq 
  80275d:	c3                   	retq   

000000000080275e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	53                   	push   %rbx
  802763:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  802767:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  80276e:	48 bf 98 23 80 00 00 	movabs $0x802398,%rdi
  802775:	00 00 00 
  802778:	48 b8 ac 51 80 00 00 	movabs $0x8051ac,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802784:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80278b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80278e:	cd 30                	int    $0x30
  802790:	89 c3                	mov    %eax,%ebx
  802792:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802795:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802798:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80279b:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80279f:	79 30                	jns    8027d1 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  8027a1:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8027a4:	89 c1                	mov    %eax,%ecx
  8027a6:	48 ba eb 5c 80 00 00 	movabs $0x805ceb,%rdx
  8027ad:	00 00 00 
  8027b0:	be 80 00 00 00       	mov    $0x80,%esi
  8027b5:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  8027bc:	00 00 00 
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8027cb:	00 00 00 
  8027ce:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  8027d1:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8027d5:	75 52                	jne    802829 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  8027d7:	48 b8 cc 1f 80 00 00 	movabs $0x801fcc,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
  8027e3:	48 98                	cltq   
  8027e5:	48 89 c2             	mov    %rax,%rdx
  8027e8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8027ee:	48 89 d0             	mov    %rdx,%rax
  8027f1:	48 c1 e0 02          	shl    $0x2,%rax
  8027f5:	48 01 d0             	add    %rdx,%rax
  8027f8:	48 01 c0             	add    %rax,%rax
  8027fb:	48 01 d0             	add    %rdx,%rax
  8027fe:	48 c1 e0 05          	shl    $0x5,%rax
  802802:	48 89 c2             	mov    %rax,%rdx
  802805:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80280c:	00 00 00 
  80280f:	48 01 c2             	add    %rax,%rdx
  802812:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802819:	00 00 00 
  80281c:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	e9 9d 02 00 00       	jmpq   802ac6 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  802829:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80282c:	ba 07 00 00 00       	mov    $0x7,%edx
  802831:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802836:	89 c7                	mov    %eax,%edi
  802838:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  80283f:	00 00 00 
  802842:	ff d0                	callq  *%rax
  802844:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802847:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80284b:	79 30                	jns    80287d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  80284d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802850:	89 c1                	mov    %eax,%ecx
  802852:	48 ba eb 5c 80 00 00 	movabs $0x805ceb,%rdx
  802859:	00 00 00 
  80285c:	be 88 00 00 00       	mov    $0x88,%esi
  802861:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802868:	00 00 00 
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  802877:	00 00 00 
  80287a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80287d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802884:	00 
	uint64_t each_pte = 0;
  802885:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80288c:	00 
	uint64_t each_pdpe = 0;
  80288d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802894:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802895:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80289c:	00 
  80289d:	e9 73 01 00 00       	jmpq   802a15 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  8028a2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8028a9:	01 00 00 
  8028ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b4:	83 e0 01             	and    $0x1,%eax
  8028b7:	84 c0                	test   %al,%al
  8028b9:	0f 84 41 01 00 00    	je     802a00 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8028bf:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8028c6:	00 
  8028c7:	e9 24 01 00 00       	jmpq   8029f0 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  8028cc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8028d3:	01 00 00 
  8028d6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8028da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028de:	83 e0 01             	and    $0x1,%eax
  8028e1:	84 c0                	test   %al,%al
  8028e3:	0f 84 ed 00 00 00    	je     8029d6 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8028e9:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8028f0:	00 
  8028f1:	e9 d0 00 00 00       	jmpq   8029c6 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  8028f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028fd:	01 00 00 
  802900:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802904:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802908:	83 e0 01             	and    $0x1,%eax
  80290b:	84 c0                	test   %al,%al
  80290d:	0f 84 99 00 00 00    	je     8029ac <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802913:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80291a:	00 
  80291b:	eb 7f                	jmp    80299c <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  80291d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802924:	01 00 00 
  802927:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80292b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292f:	83 e0 01             	and    $0x1,%eax
  802932:	84 c0                	test   %al,%al
  802934:	74 5c                	je     802992 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  802936:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  80293d:	00 
  80293e:	74 52                	je     802992 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802940:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802944:	89 c2                	mov    %eax,%edx
  802946:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802949:	89 d6                	mov    %edx,%esi
  80294b:	89 c7                	mov    %eax,%edi
  80294d:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
  802959:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  80295c:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802960:	79 30                	jns    802992 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802962:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802965:	89 c1                	mov    %eax,%ecx
  802967:	48 ba eb 5c 80 00 00 	movabs $0x805ceb,%rdx
  80296e:	00 00 00 
  802971:	be a0 00 00 00       	mov    $0xa0,%esi
  802976:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  80297d:	00 00 00 
  802980:	b8 00 00 00 00       	mov    $0x0,%eax
  802985:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80298c:	00 00 00 
  80298f:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802992:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802997:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  80299c:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8029a3:	00 
  8029a4:	0f 86 73 ff ff ff    	jbe    80291d <fork+0x1bf>
  8029aa:	eb 10                	jmp    8029bc <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  8029ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029b0:	48 83 c0 01          	add    $0x1,%rax
  8029b4:	48 c1 e0 09          	shl    $0x9,%rax
  8029b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8029bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8029c1:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8029c6:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8029cd:	00 
  8029ce:	0f 86 22 ff ff ff    	jbe    8028f6 <fork+0x198>
  8029d4:	eb 10                	jmp    8029e6 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8029d6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8029da:	48 83 c0 01          	add    $0x1,%rax
  8029de:	48 c1 e0 09          	shl    $0x9,%rax
  8029e2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8029e6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8029eb:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  8029f0:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8029f7:	00 
  8029f8:	0f 86 ce fe ff ff    	jbe    8028cc <fork+0x16e>
  8029fe:	eb 10                	jmp    802a10 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a04:	48 83 c0 01          	add    $0x1,%rax
  802a08:	48 c1 e0 09          	shl    $0x9,%rax
  802a0c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802a10:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802a15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a1a:	0f 84 82 fe ff ff    	je     8028a2 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802a20:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802a23:	48 be 44 52 80 00 00 	movabs $0x805244,%rsi
  802a2a:	00 00 00 
  802a2d:	89 c7                	mov    %eax,%edi
  802a2f:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802a36:	00 00 00 
  802a39:	ff d0                	callq  *%rax
  802a3b:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802a3e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802a42:	79 30                	jns    802a74 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802a44:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802a47:	89 c1                	mov    %eax,%ecx
  802a49:	48 ba eb 5c 80 00 00 	movabs $0x805ceb,%rdx
  802a50:	00 00 00 
  802a53:	be bd 00 00 00       	mov    $0xbd,%esi
  802a58:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802a5f:	00 00 00 
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  802a6e:	00 00 00 
  802a71:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802a74:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802a77:	be 02 00 00 00       	mov    $0x2,%esi
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
  802a8a:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802a8d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802a91:	79 30                	jns    802ac3 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802a93:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802a96:	89 c1                	mov    %eax,%ecx
  802a98:	48 ba eb 5c 80 00 00 	movabs $0x805ceb,%rdx
  802a9f:	00 00 00 
  802aa2:	be c1 00 00 00       	mov    $0xc1,%esi
  802aa7:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802aae:	00 00 00 
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab6:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  802abd:	00 00 00 
  802ac0:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  802ac3:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  802ac6:	48 83 c4 68          	add    $0x68,%rsp
  802aca:	5b                   	pop    %rbx
  802acb:	5d                   	pop    %rbp
  802acc:	c3                   	retq   

0000000000802acd <sfork>:

// Challenge!
int
sfork(void)
{
  802acd:	55                   	push   %rbp
  802ace:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802ad1:	48 ba 04 5d 80 00 00 	movabs $0x805d04,%rdx
  802ad8:	00 00 00 
  802adb:	be cc 00 00 00       	mov    $0xcc,%esi
  802ae0:	48 bf 40 5c 80 00 00 	movabs $0x805c40,%rdi
  802ae7:	00 00 00 
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
  802aef:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  802af6:	00 00 00 
  802af9:	ff d1                	callq  *%rcx
	...

0000000000802afc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802afc:	55                   	push   %rbp
  802afd:	48 89 e5             	mov    %rsp,%rbp
  802b00:	48 83 ec 08          	sub    $0x8,%rsp
  802b04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b0c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802b13:	ff ff ff 
  802b16:	48 01 d0             	add    %rdx,%rax
  802b19:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802b1d:	c9                   	leaveq 
  802b1e:	c3                   	retq   

0000000000802b1f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b1f:	55                   	push   %rbp
  802b20:	48 89 e5             	mov    %rsp,%rbp
  802b23:	48 83 ec 08          	sub    $0x8,%rsp
  802b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b2f:	48 89 c7             	mov    %rax,%rdi
  802b32:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
  802b3e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802b44:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 18          	sub    $0x18,%rsp
  802b52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b5d:	eb 6b                	jmp    802bca <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b62:	48 98                	cltq   
  802b64:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b6a:	48 c1 e0 0c          	shl    $0xc,%rax
  802b6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b76:	48 89 c2             	mov    %rax,%rdx
  802b79:	48 c1 ea 15          	shr    $0x15,%rdx
  802b7d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b84:	01 00 00 
  802b87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b8b:	83 e0 01             	and    $0x1,%eax
  802b8e:	48 85 c0             	test   %rax,%rax
  802b91:	74 21                	je     802bb4 <fd_alloc+0x6a>
  802b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b97:	48 89 c2             	mov    %rax,%rdx
  802b9a:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ba5:	01 00 00 
  802ba8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bac:	83 e0 01             	and    $0x1,%eax
  802baf:	48 85 c0             	test   %rax,%rax
  802bb2:	75 12                	jne    802bc6 <fd_alloc+0x7c>
			*fd_store = fd;
  802bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bbc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc4:	eb 1a                	jmp    802be0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802bc6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bca:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bce:	7e 8f                	jle    802b5f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802bdb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802be0:	c9                   	leaveq 
  802be1:	c3                   	retq   

0000000000802be2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802be2:	55                   	push   %rbp
  802be3:	48 89 e5             	mov    %rsp,%rbp
  802be6:	48 83 ec 20          	sub    $0x20,%rsp
  802bea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802bf1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bf5:	78 06                	js     802bfd <fd_lookup+0x1b>
  802bf7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802bfb:	7e 07                	jle    802c04 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c02:	eb 6c                	jmp    802c70 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802c04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c07:	48 98                	cltq   
  802c09:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c0f:	48 c1 e0 0c          	shl    $0xc,%rax
  802c13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1b:	48 89 c2             	mov    %rax,%rdx
  802c1e:	48 c1 ea 15          	shr    $0x15,%rdx
  802c22:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c29:	01 00 00 
  802c2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c30:	83 e0 01             	and    $0x1,%eax
  802c33:	48 85 c0             	test   %rax,%rax
  802c36:	74 21                	je     802c59 <fd_lookup+0x77>
  802c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3c:	48 89 c2             	mov    %rax,%rdx
  802c3f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c43:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c4a:	01 00 00 
  802c4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c51:	83 e0 01             	and    $0x1,%eax
  802c54:	48 85 c0             	test   %rax,%rax
  802c57:	75 07                	jne    802c60 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c5e:	eb 10                	jmp    802c70 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802c60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c64:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c68:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c70:	c9                   	leaveq 
  802c71:	c3                   	retq   

0000000000802c72 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c72:	55                   	push   %rbp
  802c73:	48 89 e5             	mov    %rsp,%rbp
  802c76:	48 83 ec 30          	sub    $0x30,%rsp
  802c7a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c7e:	89 f0                	mov    %esi,%eax
  802c80:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c87:	48 89 c7             	mov    %rax,%rdi
  802c8a:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
  802c96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c9a:	48 89 d6             	mov    %rdx,%rsi
  802c9d:	89 c7                	mov    %eax,%edi
  802c9f:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
  802cab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb2:	78 0a                	js     802cbe <fd_close+0x4c>
	    || fd != fd2)
  802cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802cbc:	74 12                	je     802cd0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802cbe:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802cc2:	74 05                	je     802cc9 <fd_close+0x57>
  802cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc7:	eb 05                	jmp    802cce <fd_close+0x5c>
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	eb 69                	jmp    802d39 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802cd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd4:	8b 00                	mov    (%rax),%eax
  802cd6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cda:	48 89 d6             	mov    %rdx,%rsi
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf2:	78 2a                	js     802d1e <fd_close+0xac>
		if (dev->dev_close)
  802cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf8:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cfc:	48 85 c0             	test   %rax,%rax
  802cff:	74 16                	je     802d17 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d05:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802d09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d0d:	48 89 c7             	mov    %rax,%rdi
  802d10:	ff d2                	callq  *%rdx
  802d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d15:	eb 07                	jmp    802d1e <fd_close+0xac>
		else
			r = 0;
  802d17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802d1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d22:	48 89 c6             	mov    %rax,%rsi
  802d25:	bf 00 00 00 00       	mov    $0x0,%edi
  802d2a:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
	return r;
  802d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d39:	c9                   	leaveq 
  802d3a:	c3                   	retq   

0000000000802d3b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d3b:	55                   	push   %rbp
  802d3c:	48 89 e5             	mov    %rsp,%rbp
  802d3f:	48 83 ec 20          	sub    $0x20,%rsp
  802d43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d51:	eb 41                	jmp    802d94 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802d53:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d5a:	00 00 00 
  802d5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d60:	48 63 d2             	movslq %edx,%rdx
  802d63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d67:	8b 00                	mov    (%rax),%eax
  802d69:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d6c:	75 22                	jne    802d90 <dev_lookup+0x55>
			*dev = devtab[i];
  802d6e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d75:	00 00 00 
  802d78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d7b:	48 63 d2             	movslq %edx,%rdx
  802d7e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d86:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d89:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8e:	eb 60                	jmp    802df0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d90:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d94:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802d9b:	00 00 00 
  802d9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802da1:	48 63 d2             	movslq %edx,%rdx
  802da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802da8:	48 85 c0             	test   %rax,%rax
  802dab:	75 a6                	jne    802d53 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802dad:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802db4:	00 00 00 
  802db7:	48 8b 00             	mov    (%rax),%rax
  802dba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dc0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dc3:	89 c6                	mov    %eax,%esi
  802dc5:	48 bf 20 5d 80 00 00 	movabs $0x805d20,%rdi
  802dcc:	00 00 00 
  802dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd4:	48 b9 3f 0b 80 00 00 	movabs $0x800b3f,%rcx
  802ddb:	00 00 00 
  802dde:	ff d1                	callq  *%rcx
	*dev = 0;
  802de0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802deb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <close>:

int
close(int fdnum)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 20          	sub    $0x20,%rsp
  802dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e04:	48 89 d6             	mov    %rdx,%rsi
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
  802e15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1c:	79 05                	jns    802e23 <close+0x31>
		return r;
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	eb 18                	jmp    802e3b <close+0x49>
	else
		return fd_close(fd, 1);
  802e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e27:	be 01 00 00 00       	mov    $0x1,%esi
  802e2c:	48 89 c7             	mov    %rax,%rdi
  802e2f:	48 b8 72 2c 80 00 00 	movabs $0x802c72,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <close_all>:

void
close_all(void)
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e4c:	eb 15                	jmp    802e63 <close_all+0x26>
		close(i);
  802e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e51:	89 c7                	mov    %eax,%edi
  802e53:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802e5f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e63:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e67:	7e e5                	jle    802e4e <close_all+0x11>
		close(i);
}
  802e69:	c9                   	leaveq 
  802e6a:	c3                   	retq   

0000000000802e6b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e6b:	55                   	push   %rbp
  802e6c:	48 89 e5             	mov    %rsp,%rbp
  802e6f:	48 83 ec 40          	sub    $0x40,%rsp
  802e73:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e76:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e79:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e7d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e80:	48 89 d6             	mov    %rdx,%rsi
  802e83:	89 c7                	mov    %eax,%edi
  802e85:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e98:	79 08                	jns    802ea2 <dup+0x37>
		return r;
  802e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9d:	e9 70 01 00 00       	jmpq   803012 <dup+0x1a7>
	close(newfdnum);
  802ea2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802eb3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eb6:	48 98                	cltq   
  802eb8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ebe:	48 c1 e0 0c          	shl    $0xc,%rax
  802ec2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eca:	48 89 c7             	mov    %rax,%rdi
  802ecd:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  802ed4:	00 00 00 
  802ed7:	ff d0                	callq  *%rax
  802ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802edd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee1:	48 89 c7             	mov    %rax,%rdi
  802ee4:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
  802ef0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef8:	48 89 c2             	mov    %rax,%rdx
  802efb:	48 c1 ea 15          	shr    $0x15,%rdx
  802eff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f06:	01 00 00 
  802f09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f0d:	83 e0 01             	and    $0x1,%eax
  802f10:	84 c0                	test   %al,%al
  802f12:	74 71                	je     802f85 <dup+0x11a>
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	48 89 c2             	mov    %rax,%rdx
  802f1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802f1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f26:	01 00 00 
  802f29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f2d:	83 e0 01             	and    $0x1,%eax
  802f30:	84 c0                	test   %al,%al
  802f32:	74 51                	je     802f85 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f38:	48 89 c2             	mov    %rax,%rdx
  802f3b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802f3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f46:	01 00 00 
  802f49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f4d:	89 c1                	mov    %eax,%ecx
  802f4f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802f55:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5d:	41 89 c8             	mov    %ecx,%r8d
  802f60:	48 89 d1             	mov    %rdx,%rcx
  802f63:	ba 00 00 00 00       	mov    $0x0,%edx
  802f68:	48 89 c6             	mov    %rax,%rsi
  802f6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f70:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  802f77:	00 00 00 
  802f7a:	ff d0                	callq  *%rax
  802f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f83:	78 56                	js     802fdb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f89:	48 89 c2             	mov    %rax,%rdx
  802f8c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802f90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f97:	01 00 00 
  802f9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f9e:	89 c1                	mov    %eax,%ecx
  802fa0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802fa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802faa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fae:	41 89 c8             	mov    %ecx,%r8d
  802fb1:	48 89 d1             	mov    %rdx,%rcx
  802fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb9:	48 89 c6             	mov    %rax,%rsi
  802fbc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc1:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd4:	78 08                	js     802fde <dup+0x173>
		goto err;

	return newfdnum;
  802fd6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fd9:	eb 37                	jmp    803012 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802fdb:	90                   	nop
  802fdc:	eb 01                	jmp    802fdf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802fde:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe3:	48 89 c6             	mov    %rax,%rsi
  802fe6:	bf 00 00 00 00       	mov    $0x0,%edi
  802feb:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ff7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffb:	48 89 c6             	mov    %rax,%rsi
  802ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  803003:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
	return r;
  80300f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803012:	c9                   	leaveq 
  803013:	c3                   	retq   

0000000000803014 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803014:	55                   	push   %rbp
  803015:	48 89 e5             	mov    %rsp,%rbp
  803018:	48 83 ec 40          	sub    $0x40,%rsp
  80301c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80301f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803023:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803027:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80302b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80302e:	48 89 d6             	mov    %rdx,%rsi
  803031:	89 c7                	mov    %eax,%edi
  803033:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
  80303f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803046:	78 24                	js     80306c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304c:	8b 00                	mov    (%rax),%eax
  80304e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803052:	48 89 d6             	mov    %rdx,%rsi
  803055:	89 c7                	mov    %eax,%edi
  803057:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
  803063:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803066:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306a:	79 05                	jns    803071 <read+0x5d>
		return r;
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306f:	eb 7a                	jmp    8030eb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803075:	8b 40 08             	mov    0x8(%rax),%eax
  803078:	83 e0 03             	and    $0x3,%eax
  80307b:	83 f8 01             	cmp    $0x1,%eax
  80307e:	75 3a                	jne    8030ba <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803080:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803087:	00 00 00 
  80308a:	48 8b 00             	mov    (%rax),%rax
  80308d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803093:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803096:	89 c6                	mov    %eax,%esi
  803098:	48 bf 3f 5d 80 00 00 	movabs $0x805d3f,%rdi
  80309f:	00 00 00 
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	48 b9 3f 0b 80 00 00 	movabs $0x800b3f,%rcx
  8030ae:	00 00 00 
  8030b1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030b8:	eb 31                	jmp    8030eb <read+0xd7>
	}
	if (!dev->dev_read)
  8030ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030be:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030c2:	48 85 c0             	test   %rax,%rax
  8030c5:	75 07                	jne    8030ce <read+0xba>
		return -E_NOT_SUPP;
  8030c7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030cc:	eb 1d                	jmp    8030eb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8030d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030de:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030e2:	48 89 ce             	mov    %rcx,%rsi
  8030e5:	48 89 c7             	mov    %rax,%rdi
  8030e8:	41 ff d0             	callq  *%r8
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 30          	sub    $0x30,%rsp
  8030f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803107:	eb 46                	jmp    80314f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310c:	48 98                	cltq   
  80310e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803112:	48 29 c2             	sub    %rax,%rdx
  803115:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803118:	48 98                	cltq   
  80311a:	48 89 c1             	mov    %rax,%rcx
  80311d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803121:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803124:	48 89 ce             	mov    %rcx,%rsi
  803127:	89 c7                	mov    %eax,%edi
  803129:	48 b8 14 30 80 00 00 	movabs $0x803014,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
  803135:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803138:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80313c:	79 05                	jns    803143 <readn+0x56>
			return m;
  80313e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803141:	eb 1d                	jmp    803160 <readn+0x73>
		if (m == 0)
  803143:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803147:	74 13                	je     80315c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803149:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80314f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803152:	48 98                	cltq   
  803154:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803158:	72 af                	jb     803109 <readn+0x1c>
  80315a:	eb 01                	jmp    80315d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80315c:	90                   	nop
	}
	return tot;
  80315d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803160:	c9                   	leaveq 
  803161:	c3                   	retq   

0000000000803162 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803162:	55                   	push   %rbp
  803163:	48 89 e5             	mov    %rsp,%rbp
  803166:	48 83 ec 40          	sub    $0x40,%rsp
  80316a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80316d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803171:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803175:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803179:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80317c:	48 89 d6             	mov    %rdx,%rsi
  80317f:	89 c7                	mov    %eax,%edi
  803181:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
  80318d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803194:	78 24                	js     8031ba <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319a:	8b 00                	mov    (%rax),%eax
  80319c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031a0:	48 89 d6             	mov    %rdx,%rsi
  8031a3:	89 c7                	mov    %eax,%edi
  8031a5:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  8031ac:	00 00 00 
  8031af:	ff d0                	callq  *%rax
  8031b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b8:	79 05                	jns    8031bf <write+0x5d>
		return r;
  8031ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031bd:	eb 79                	jmp    803238 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c3:	8b 40 08             	mov    0x8(%rax),%eax
  8031c6:	83 e0 03             	and    $0x3,%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	75 3a                	jne    803207 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8031cd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8031d4:	00 00 00 
  8031d7:	48 8b 00             	mov    (%rax),%rax
  8031da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031e3:	89 c6                	mov    %eax,%esi
  8031e5:	48 bf 5b 5d 80 00 00 	movabs $0x805d5b,%rdi
  8031ec:	00 00 00 
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f4:	48 b9 3f 0b 80 00 00 	movabs $0x800b3f,%rcx
  8031fb:	00 00 00 
  8031fe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803200:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803205:	eb 31                	jmp    803238 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80320f:	48 85 c0             	test   %rax,%rax
  803212:	75 07                	jne    80321b <write+0xb9>
		return -E_NOT_SUPP;
  803214:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803219:	eb 1d                	jmp    803238 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  803223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803227:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80322b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80322f:	48 89 ce             	mov    %rcx,%rsi
  803232:	48 89 c7             	mov    %rax,%rdi
  803235:	41 ff d0             	callq  *%r8
}
  803238:	c9                   	leaveq 
  803239:	c3                   	retq   

000000000080323a <seek>:

int
seek(int fdnum, off_t offset)
{
  80323a:	55                   	push   %rbp
  80323b:	48 89 e5             	mov    %rsp,%rbp
  80323e:	48 83 ec 18          	sub    $0x18,%rsp
  803242:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803245:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803248:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80324c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80324f:	48 89 d6             	mov    %rdx,%rsi
  803252:	89 c7                	mov    %eax,%edi
  803254:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
  803260:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803267:	79 05                	jns    80326e <seek+0x34>
		return r;
  803269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326c:	eb 0f                	jmp    80327d <seek+0x43>
	fd->fd_offset = offset;
  80326e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803272:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803275:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327d:	c9                   	leaveq 
  80327e:	c3                   	retq   

000000000080327f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80327f:	55                   	push   %rbp
  803280:	48 89 e5             	mov    %rsp,%rbp
  803283:	48 83 ec 30          	sub    $0x30,%rsp
  803287:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80328a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80328d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803291:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803294:	48 89 d6             	mov    %rdx,%rsi
  803297:	89 c7                	mov    %eax,%edi
  803299:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
  8032a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ac:	78 24                	js     8032d2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b2:	8b 00                	mov    (%rax),%eax
  8032b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032b8:	48 89 d6             	mov    %rdx,%rsi
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
  8032c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d0:	79 05                	jns    8032d7 <ftruncate+0x58>
		return r;
  8032d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d5:	eb 72                	jmp    803349 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8032d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032db:	8b 40 08             	mov    0x8(%rax),%eax
  8032de:	83 e0 03             	and    $0x3,%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	75 3a                	jne    80331f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8032e5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8032ec:	00 00 00 
  8032ef:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032f8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032fb:	89 c6                	mov    %eax,%esi
  8032fd:	48 bf 78 5d 80 00 00 	movabs $0x805d78,%rdi
  803304:	00 00 00 
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
  80330c:	48 b9 3f 0b 80 00 00 	movabs $0x800b3f,%rcx
  803313:	00 00 00 
  803316:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803318:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80331d:	eb 2a                	jmp    803349 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80331f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803323:	48 8b 40 30          	mov    0x30(%rax),%rax
  803327:	48 85 c0             	test   %rax,%rax
  80332a:	75 07                	jne    803333 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80332c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803331:	eb 16                	jmp    803349 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803337:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80333b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803342:	89 d6                	mov    %edx,%esi
  803344:	48 89 c7             	mov    %rax,%rdi
  803347:	ff d1                	callq  *%rcx
}
  803349:	c9                   	leaveq 
  80334a:	c3                   	retq   

000000000080334b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80334b:	55                   	push   %rbp
  80334c:	48 89 e5             	mov    %rsp,%rbp
  80334f:	48 83 ec 30          	sub    $0x30,%rsp
  803353:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803356:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80335a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80335e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803361:	48 89 d6             	mov    %rdx,%rsi
  803364:	89 c7                	mov    %eax,%edi
  803366:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
  803372:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803375:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803379:	78 24                	js     80339f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80337b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337f:	8b 00                	mov    (%rax),%eax
  803381:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803385:	48 89 d6             	mov    %rdx,%rsi
  803388:	89 c7                	mov    %eax,%edi
  80338a:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
  803396:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803399:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339d:	79 05                	jns    8033a4 <fstat+0x59>
		return r;
  80339f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a2:	eb 5e                	jmp    803402 <fstat+0xb7>
	if (!dev->dev_stat)
  8033a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8033ac:	48 85 c0             	test   %rax,%rax
  8033af:	75 07                	jne    8033b8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8033b1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033b6:	eb 4a                	jmp    803402 <fstat+0xb7>
	stat->st_name[0] = 0;
  8033b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8033bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8033ca:	00 00 00 
	stat->st_isdir = 0;
  8033cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8033d8:	00 00 00 
	stat->st_dev = dev;
  8033db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8033ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ee:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8033f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8033fa:	48 89 d6             	mov    %rdx,%rsi
  8033fd:	48 89 c7             	mov    %rax,%rdi
  803400:	ff d1                	callq  *%rcx
}
  803402:	c9                   	leaveq 
  803403:	c3                   	retq   

0000000000803404 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803404:	55                   	push   %rbp
  803405:	48 89 e5             	mov    %rsp,%rbp
  803408:	48 83 ec 20          	sub    $0x20,%rsp
  80340c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803410:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803418:	be 00 00 00 00       	mov    $0x0,%esi
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803433:	79 05                	jns    80343a <stat+0x36>
		return fd;
  803435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803438:	eb 2f                	jmp    803469 <stat+0x65>
	r = fstat(fd, stat);
  80343a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80343e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803441:	48 89 d6             	mov    %rdx,%rsi
  803444:	89 c7                	mov    %eax,%edi
  803446:	48 b8 4b 33 80 00 00 	movabs $0x80334b,%rax
  80344d:	00 00 00 
  803450:	ff d0                	callq  *%rax
  803452:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
	return r;
  803466:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803469:	c9                   	leaveq 
  80346a:	c3                   	retq   
	...

000000000080346c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80346c:	55                   	push   %rbp
  80346d:	48 89 e5             	mov    %rsp,%rbp
  803470:	48 83 ec 10          	sub    $0x10,%rsp
  803474:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803477:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80347b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803482:	00 00 00 
  803485:	8b 00                	mov    (%rax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	75 1d                	jne    8034a8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80348b:	bf 01 00 00 00       	mov    $0x1,%edi
  803490:	48 b8 5e 54 80 00 00 	movabs $0x80545e,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8034a3:	00 00 00 
  8034a6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8034a8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034af:	00 00 00 
  8034b2:	8b 00                	mov    (%rax),%eax
  8034b4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034b7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034bc:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8034c3:	00 00 00 
  8034c6:	89 c7                	mov    %eax,%edi
  8034c8:	48 b8 af 53 80 00 00 	movabs $0x8053af,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8034d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034dd:	48 89 c6             	mov    %rax,%rsi
  8034e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e5:	48 b8 c8 52 80 00 00 	movabs $0x8052c8,%rax
  8034ec:	00 00 00 
  8034ef:	ff d0                	callq  *%rax
}
  8034f1:	c9                   	leaveq 
  8034f2:	c3                   	retq   

00000000008034f3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8034f3:	55                   	push   %rbp
  8034f4:	48 89 e5             	mov    %rsp,%rbp
  8034f7:	48 83 ec 20          	sub    $0x20,%rsp
  8034fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034ff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  803502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803506:	48 89 c7             	mov    %rax,%rdi
  803509:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80351a:	7e 0a                	jle    803526 <open+0x33>
		return -E_BAD_PATH;
  80351c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803521:	e9 a5 00 00 00       	jmpq   8035cb <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  803526:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80352a:	48 89 c7             	mov    %rax,%rdi
  80352d:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80353c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803540:	79 08                	jns    80354a <open+0x57>
		return r;
  803542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803545:	e9 81 00 00 00       	jmpq   8035cb <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80354a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803551:	00 00 00 
  803554:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803557:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80355d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803561:	48 89 c6             	mov    %rax,%rsi
  803564:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80356b:	00 00 00 
  80356e:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  803575:	00 00 00 
  803578:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80357a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357e:	48 89 c6             	mov    %rax,%rsi
  803581:	bf 01 00 00 00       	mov    $0x1,%edi
  803586:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803595:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803599:	79 1d                	jns    8035b8 <open+0xc5>
		fd_close(new_fd, 0);
  80359b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359f:	be 00 00 00 00       	mov    $0x0,%esi
  8035a4:	48 89 c7             	mov    %rax,%rdi
  8035a7:	48 b8 72 2c 80 00 00 	movabs $0x802c72,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
		return r;	
  8035b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b6:	eb 13                	jmp    8035cb <open+0xd8>
	}
	return fd2num(new_fd);
  8035b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bc:	48 89 c7             	mov    %rax,%rdi
  8035bf:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
}
  8035cb:	c9                   	leaveq 
  8035cc:	c3                   	retq   

00000000008035cd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8035cd:	55                   	push   %rbp
  8035ce:	48 89 e5             	mov    %rsp,%rbp
  8035d1:	48 83 ec 10          	sub    $0x10,%rsp
  8035d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8035d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dd:	8b 50 0c             	mov    0xc(%rax),%edx
  8035e0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035e7:	00 00 00 
  8035ea:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8035ec:	be 00 00 00 00       	mov    $0x0,%esi
  8035f1:	bf 06 00 00 00       	mov    $0x6,%edi
  8035f6:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
}
  803602:	c9                   	leaveq 
  803603:	c3                   	retq   

0000000000803604 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803604:	55                   	push   %rbp
  803605:	48 89 e5             	mov    %rsp,%rbp
  803608:	48 83 ec 30          	sub    $0x30,%rsp
  80360c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803610:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803614:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  803618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361c:	8b 50 0c             	mov    0xc(%rax),%edx
  80361f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803626:	00 00 00 
  803629:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80362b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803632:	00 00 00 
  803635:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803639:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  80363d:	be 00 00 00 00       	mov    $0x0,%esi
  803642:	bf 03 00 00 00       	mov    $0x3,%edi
  803647:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
  803653:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  803656:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365a:	7e 23                	jle    80367f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80365c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365f:	48 63 d0             	movslq %eax,%rdx
  803662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803666:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80366d:	00 00 00 
  803670:	48 89 c7             	mov    %rax,%rdi
  803673:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80367f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803682:	c9                   	leaveq 
  803683:	c3                   	retq   

0000000000803684 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803684:	55                   	push   %rbp
  803685:	48 89 e5             	mov    %rsp,%rbp
  803688:	48 83 ec 20          	sub    $0x20,%rsp
  80368c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803690:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803698:	8b 50 0c             	mov    0xc(%rax),%edx
  80369b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036a2:	00 00 00 
  8036a5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036a7:	be 00 00 00 00       	mov    $0x0,%esi
  8036ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8036b1:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
  8036bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c4:	79 05                	jns    8036cb <devfile_stat+0x47>
		return r;
  8036c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c9:	eb 56                	jmp    803721 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cf:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8036d6:	00 00 00 
  8036d9:	48 89 c7             	mov    %rax,%rdi
  8036dc:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  8036e3:	00 00 00 
  8036e6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036ef:	00 00 00 
  8036f2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8036f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036fc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803702:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803709:	00 00 00 
  80370c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803712:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803716:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80371c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803721:	c9                   	leaveq 
  803722:	c3                   	retq   
	...

0000000000803724 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803724:	55                   	push   %rbp
  803725:	48 89 e5             	mov    %rsp,%rbp
  803728:	53                   	push   %rbx
  803729:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  803730:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  803737:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80373e:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  803745:	be 00 00 00 00       	mov    $0x0,%esi
  80374a:	48 89 c7             	mov    %rax,%rdi
  80374d:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
  803759:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80375c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803760:	79 08                	jns    80376a <spawn+0x46>
		return r;
  803762:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803765:	e9 23 03 00 00       	jmpq   803a8d <spawn+0x369>
	fd = r;
  80376a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80376d:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803770:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  803777:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80377b:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  803782:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803785:	ba 00 02 00 00       	mov    $0x200,%edx
  80378a:	48 89 ce             	mov    %rcx,%rsi
  80378d:	89 c7                	mov    %eax,%edi
  80378f:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
  80379b:	3d 00 02 00 00       	cmp    $0x200,%eax
  8037a0:	75 0d                	jne    8037af <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  8037a2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037a6:	8b 00                	mov    (%rax),%eax
  8037a8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8037ad:	74 43                	je     8037f2 <spawn+0xce>
		close(fd);
  8037af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037b2:	89 c7                	mov    %eax,%edi
  8037b4:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8037c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037c4:	8b 00                	mov    (%rax),%eax
  8037c6:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8037cb:	89 c6                	mov    %eax,%esi
  8037cd:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  8037d4:	00 00 00 
  8037d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dc:	48 b9 3f 0b 80 00 00 	movabs $0x800b3f,%rcx
  8037e3:	00 00 00 
  8037e6:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8037e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8037ed:	e9 9b 02 00 00       	jmpq   803a8d <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8037f2:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  8037f9:	00 00 00 
  8037fc:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  803802:	cd 30                	int    $0x30
  803804:	89 c3                	mov    %eax,%ebx
  803806:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803809:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80380c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80380f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803813:	79 08                	jns    80381d <spawn+0xf9>
		return r;
  803815:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803818:	e9 70 02 00 00       	jmpq   803a8d <spawn+0x369>
	child = r;
  80381d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803820:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803823:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803826:	25 ff 03 00 00       	and    $0x3ff,%eax
  80382b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803832:	00 00 00 
  803835:	48 63 d0             	movslq %eax,%rdx
  803838:	48 89 d0             	mov    %rdx,%rax
  80383b:	48 c1 e0 02          	shl    $0x2,%rax
  80383f:	48 01 d0             	add    %rdx,%rax
  803842:	48 01 c0             	add    %rax,%rax
  803845:	48 01 d0             	add    %rdx,%rax
  803848:	48 c1 e0 05          	shl    $0x5,%rax
  80384c:	48 01 c8             	add    %rcx,%rax
  80384f:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  803856:	48 89 c6             	mov    %rax,%rsi
  803859:	b8 18 00 00 00       	mov    $0x18,%eax
  80385e:	48 89 d7             	mov    %rdx,%rdi
  803861:	48 89 c1             	mov    %rax,%rcx
  803864:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803867:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80386b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80386f:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803876:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  80387d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803884:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  80388b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80388e:	48 89 ce             	mov    %rcx,%rsi
  803891:	89 c7                	mov    %eax,%edi
  803893:	48 b8 e5 3c 80 00 00 	movabs $0x803ce5,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8038a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8038a6:	79 08                	jns    8038b0 <spawn+0x18c>
		return r;
  8038a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8038ab:	e9 dd 01 00 00       	jmpq   803a8d <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8038b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038b4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8038b8:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  8038bf:	48 01 d0             	add    %rdx,%rax
  8038c2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8038c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8038cd:	eb 7a                	jmp    803949 <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  8038cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d3:	8b 00                	mov    (%rax),%eax
  8038d5:	83 f8 01             	cmp    $0x1,%eax
  8038d8:	75 65                	jne    80393f <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  8038da:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8038e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e5:	8b 40 04             	mov    0x4(%rax),%eax
  8038e8:	83 e0 02             	and    $0x2,%eax
  8038eb:	85 c0                	test   %eax,%eax
  8038ed:	74 04                	je     8038f3 <spawn+0x1cf>
			perm |= PTE_W;
  8038ef:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f7:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8038fb:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803902:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803906:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390a:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80390e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803912:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803916:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803919:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80391c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80391f:	89 3c 24             	mov    %edi,(%rsp)
  803922:	89 c7                	mov    %eax,%edi
  803924:	48 b8 55 3f 80 00 00 	movabs $0x803f55,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803933:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803937:	0f 88 2a 01 00 00    	js     803a67 <spawn+0x343>
  80393d:	eb 01                	jmp    803940 <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  80393f:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803940:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  803944:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  803949:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80394d:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803951:	0f b7 c0             	movzwl %ax,%eax
  803954:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803957:	0f 8f 72 ff ff ff    	jg     8038cf <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80395d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803960:	89 c7                	mov    %eax,%edi
  803962:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
	fd = -1;
  80396e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803975:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803978:	89 c7                	mov    %eax,%edi
  80397a:	48 b8 3c 41 80 00 00 	movabs $0x80413c,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
  803986:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803989:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80398d:	79 30                	jns    8039bf <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  80398f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803992:	89 c1                	mov    %eax,%ecx
  803994:	48 ba ba 5d 80 00 00 	movabs $0x805dba,%rdx
  80399b:	00 00 00 
  80399e:	be 82 00 00 00       	mov    $0x82,%esi
  8039a3:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  8039aa:	00 00 00 
  8039ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b2:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8039b9:	00 00 00 
  8039bc:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8039bf:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8039c6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8039c9:	48 89 d6             	mov    %rdx,%rsi
  8039cc:	89 c7                	mov    %eax,%edi
  8039ce:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
  8039da:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8039dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8039e1:	79 30                	jns    803a13 <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  8039e3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039e6:	89 c1                	mov    %eax,%ecx
  8039e8:	48 ba dc 5d 80 00 00 	movabs $0x805ddc,%rdx
  8039ef:	00 00 00 
  8039f2:	be 85 00 00 00       	mov    $0x85,%esi
  8039f7:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  8039fe:	00 00 00 
  803a01:	b8 00 00 00 00       	mov    $0x0,%eax
  803a06:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  803a0d:	00 00 00 
  803a10:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803a13:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a16:	be 02 00 00 00       	mov    $0x2,%esi
  803a1b:	89 c7                	mov    %eax,%edi
  803a1d:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  803a24:	00 00 00 
  803a27:	ff d0                	callq  *%rax
  803a29:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803a2c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a30:	79 30                	jns    803a62 <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  803a32:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a35:	89 c1                	mov    %eax,%ecx
  803a37:	48 ba f6 5d 80 00 00 	movabs $0x805df6,%rdx
  803a3e:	00 00 00 
  803a41:	be 88 00 00 00       	mov    $0x88,%esi
  803a46:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  803a4d:	00 00 00 
  803a50:	b8 00 00 00 00       	mov    $0x0,%eax
  803a55:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  803a5c:	00 00 00 
  803a5f:	41 ff d0             	callq  *%r8

	return child;
  803a62:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a65:	eb 26                	jmp    803a8d <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803a67:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803a68:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a6b:	89 c7                	mov    %eax,%edi
  803a6d:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
	close(fd);
  803a79:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a7c:	89 c7                	mov    %eax,%edi
  803a7e:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
	return r;
  803a8a:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  803a8d:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  803a94:	5b                   	pop    %rbx
  803a95:	5d                   	pop    %rbp
  803a96:	c3                   	retq   

0000000000803a97 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803a97:	55                   	push   %rbp
  803a98:	48 89 e5             	mov    %rsp,%rbp
  803a9b:	53                   	push   %rbx
  803a9c:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  803aa3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803aaa:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  803ab1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ab8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803abf:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ac6:	84 c0                	test   %al,%al
  803ac8:	74 23                	je     803aed <spawnl+0x56>
  803aca:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803ad1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ad5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ad9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803add:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803ae1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803ae5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803ae9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803aed:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803af4:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  803afb:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803afe:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803b05:	00 00 00 
  803b08:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803b0f:	00 00 00 
  803b12:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b16:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803b1d:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803b24:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803b2b:	eb 07                	jmp    803b34 <spawnl+0x9d>
		argc++;
  803b2d:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803b34:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803b3a:	83 f8 30             	cmp    $0x30,%eax
  803b3d:	73 23                	jae    803b62 <spawnl+0xcb>
  803b3f:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  803b46:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803b4c:	89 c0                	mov    %eax,%eax
  803b4e:	48 01 d0             	add    %rdx,%rax
  803b51:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  803b57:	83 c2 08             	add    $0x8,%edx
  803b5a:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803b60:	eb 15                	jmp    803b77 <spawnl+0xe0>
  803b62:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b69:	48 89 d0             	mov    %rdx,%rax
  803b6c:	48 83 c2 08          	add    $0x8,%rdx
  803b70:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803b77:	48 8b 00             	mov    (%rax),%rax
  803b7a:	48 85 c0             	test   %rax,%rax
  803b7d:	75 ae                	jne    803b2d <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b7f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803b85:	83 c0 02             	add    $0x2,%eax
  803b88:	48 89 e2             	mov    %rsp,%rdx
  803b8b:	48 89 d3             	mov    %rdx,%rbx
  803b8e:	48 63 d0             	movslq %eax,%rdx
  803b91:	48 83 ea 01          	sub    $0x1,%rdx
  803b95:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  803b9c:	48 98                	cltq   
  803b9e:	48 c1 e0 03          	shl    $0x3,%rax
  803ba2:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  803ba6:	b8 10 00 00 00       	mov    $0x10,%eax
  803bab:	48 83 e8 01          	sub    $0x1,%rax
  803baf:	48 01 d0             	add    %rdx,%rax
  803bb2:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  803bb9:	10 00 00 00 
  803bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc2:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  803bc9:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803bcd:	48 29 c4             	sub    %rax,%rsp
  803bd0:	48 89 e0             	mov    %rsp,%rax
  803bd3:	48 83 c0 0f          	add    $0xf,%rax
  803bd7:	48 c1 e8 04          	shr    $0x4,%rax
  803bdb:	48 c1 e0 04          	shl    $0x4,%rax
  803bdf:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  803be6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803bed:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  803bf4:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803bf7:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803bfd:	8d 50 01             	lea    0x1(%rax),%edx
  803c00:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803c07:	48 63 d2             	movslq %edx,%rdx
  803c0a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803c11:	00 

	va_start(vl, arg0);
  803c12:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803c19:	00 00 00 
  803c1c:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803c23:	00 00 00 
  803c26:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c2a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803c31:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803c38:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803c3f:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  803c46:	00 00 00 
  803c49:	eb 63                	jmp    803cae <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  803c4b:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  803c51:	8d 70 01             	lea    0x1(%rax),%esi
  803c54:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803c5a:	83 f8 30             	cmp    $0x30,%eax
  803c5d:	73 23                	jae    803c82 <spawnl+0x1eb>
  803c5f:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  803c66:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803c6c:	89 c0                	mov    %eax,%eax
  803c6e:	48 01 d0             	add    %rdx,%rax
  803c71:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  803c77:	83 c2 08             	add    $0x8,%edx
  803c7a:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803c80:	eb 15                	jmp    803c97 <spawnl+0x200>
  803c82:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c89:	48 89 d0             	mov    %rdx,%rax
  803c8c:	48 83 c2 08          	add    $0x8,%rdx
  803c90:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803c97:	48 8b 08             	mov    (%rax),%rcx
  803c9a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803ca1:	89 f2                	mov    %esi,%edx
  803ca3:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803ca7:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  803cae:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803cb4:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  803cba:	77 8f                	ja     803c4b <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803cbc:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803cc3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cca:	48 89 d6             	mov    %rdx,%rsi
  803ccd:	48 89 c7             	mov    %rax,%rdi
  803cd0:	48 b8 24 37 80 00 00 	movabs $0x803724,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
  803cdc:	48 89 dc             	mov    %rbx,%rsp
}
  803cdf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803ce3:	c9                   	leaveq 
  803ce4:	c3                   	retq   

0000000000803ce5 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803ce5:	55                   	push   %rbp
  803ce6:	48 89 e5             	mov    %rsp,%rbp
  803ce9:	48 83 ec 50          	sub    $0x50,%rsp
  803ced:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803cf0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803cf4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803cf8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cff:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803d07:	eb 2c                	jmp    803d35 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  803d09:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d0c:	48 98                	cltq   
  803d0e:	48 c1 e0 03          	shl    $0x3,%rax
  803d12:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803d16:	48 8b 00             	mov    (%rax),%rax
  803d19:	48 89 c7             	mov    %rax,%rdi
  803d1c:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
  803d28:	83 c0 01             	add    $0x1,%eax
  803d2b:	48 98                	cltq   
  803d2d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803d31:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803d35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d38:	48 98                	cltq   
  803d3a:	48 c1 e0 03          	shl    $0x3,%rax
  803d3e:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803d42:	48 8b 00             	mov    (%rax),%rax
  803d45:	48 85 c0             	test   %rax,%rax
  803d48:	75 bf                	jne    803d09 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d4e:	48 f7 d8             	neg    %rax
  803d51:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d57:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d67:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d6b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d6e:	83 c2 01             	add    $0x1,%edx
  803d71:	c1 e2 03             	shl    $0x3,%edx
  803d74:	48 63 d2             	movslq %edx,%rdx
  803d77:	48 f7 da             	neg    %rdx
  803d7a:	48 01 d0             	add    %rdx,%rax
  803d7d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d85:	48 83 e8 10          	sub    $0x10,%rax
  803d89:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803d8f:	77 0a                	ja     803d9b <init_stack+0xb6>
		return -E_NO_MEM;
  803d91:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803d96:	e9 b8 01 00 00       	jmpq   803f53 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d9b:	ba 07 00 00 00       	mov    $0x7,%edx
  803da0:	be 00 00 40 00       	mov    $0x400000,%esi
  803da5:	bf 00 00 00 00       	mov    $0x0,%edi
  803daa:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  803db1:	00 00 00 
  803db4:	ff d0                	callq  *%rax
  803db6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dbd:	79 08                	jns    803dc7 <init_stack+0xe2>
		return r;
  803dbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc2:	e9 8c 01 00 00       	jmpq   803f53 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803dc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803dce:	eb 73                	jmp    803e43 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803dd0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dd3:	48 98                	cltq   
  803dd5:	48 c1 e0 03          	shl    $0x3,%rax
  803dd9:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803ddd:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803de2:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  803de6:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803ded:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803df0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803df3:	48 98                	cltq   
  803df5:	48 c1 e0 03          	shl    $0x3,%rax
  803df9:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803dfd:	48 8b 10             	mov    (%rax),%rdx
  803e00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e04:	48 89 d6             	mov    %rdx,%rsi
  803e07:	48 89 c7             	mov    %rax,%rdi
  803e0a:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803e16:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e19:	48 98                	cltq   
  803e1b:	48 c1 e0 03          	shl    $0x3,%rax
  803e1f:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803e23:	48 8b 00             	mov    (%rax),%rax
  803e26:	48 89 c7             	mov    %rax,%rdi
  803e29:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
  803e35:	48 98                	cltq   
  803e37:	48 83 c0 01          	add    $0x1,%rax
  803e3b:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e3f:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e43:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e46:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e49:	7c 85                	jl     803dd0 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e4e:	48 98                	cltq   
  803e50:	48 c1 e0 03          	shl    $0x3,%rax
  803e54:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803e58:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803e5f:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803e66:	00 
  803e67:	74 35                	je     803e9e <init_stack+0x1b9>
  803e69:	48 b9 10 5e 80 00 00 	movabs $0x805e10,%rcx
  803e70:	00 00 00 
  803e73:	48 ba 36 5e 80 00 00 	movabs $0x805e36,%rdx
  803e7a:	00 00 00 
  803e7d:	be f1 00 00 00       	mov    $0xf1,%esi
  803e82:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  803e89:	00 00 00 
  803e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e91:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  803e98:	00 00 00 
  803e9b:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803e9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea2:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803ea6:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803eab:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803eaf:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803eb5:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803eb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebc:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803ec0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ec3:	48 98                	cltq   
  803ec5:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803ec8:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803ecd:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803ed1:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ed7:	48 89 c2             	mov    %rax,%rdx
  803eda:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ede:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803ee1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ee4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803eea:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803eef:	89 c2                	mov    %eax,%edx
  803ef1:	be 00 00 40 00       	mov    $0x400000,%esi
  803ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  803efb:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f0e:	78 26                	js     803f36 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f10:	be 00 00 40 00       	mov    $0x400000,%esi
  803f15:	bf 00 00 00 00       	mov    $0x0,%edi
  803f1a:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f2d:	78 0a                	js     803f39 <init_stack+0x254>
		goto error;

	return 0;
  803f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f34:	eb 1d                	jmp    803f53 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803f36:	90                   	nop
  803f37:	eb 01                	jmp    803f3a <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803f39:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803f3a:	be 00 00 40 00       	mov    $0x400000,%esi
  803f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f44:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
	return r;
  803f50:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f53:	c9                   	leaveq 
  803f54:	c3                   	retq   

0000000000803f55 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f55:	55                   	push   %rbp
  803f56:	48 89 e5             	mov    %rsp,%rbp
  803f59:	48 83 ec 50          	sub    $0x50,%rsp
  803f5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803f68:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803f6b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803f6f:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f77:	25 ff 0f 00 00       	and    $0xfff,%eax
  803f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f83:	74 21                	je     803fa6 <map_segment+0x51>
		va -= i;
  803f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f88:	48 98                	cltq   
  803f8a:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f91:	48 98                	cltq   
  803f93:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9a:	48 98                	cltq   
  803f9c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa3:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fad:	e9 74 01 00 00       	jmpq   804126 <map_segment+0x1d1>
		if (i >= filesz) {
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	48 98                	cltq   
  803fb7:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803fbb:	72 38                	jb     803ff5 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc0:	48 98                	cltq   
  803fc2:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803fc6:	48 89 c1             	mov    %rax,%rcx
  803fc9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fcc:	8b 55 10             	mov    0x10(%rbp),%edx
  803fcf:	48 89 ce             	mov    %rcx,%rsi
  803fd2:	89 c7                	mov    %eax,%edi
  803fd4:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  803fdb:	00 00 00 
  803fde:	ff d0                	callq  *%rax
  803fe0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803fe3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fe7:	0f 89 32 01 00 00    	jns    80411f <map_segment+0x1ca>
				return r;
  803fed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ff0:	e9 45 01 00 00       	jmpq   80413a <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ff5:	ba 07 00 00 00       	mov    $0x7,%edx
  803ffa:	be 00 00 40 00       	mov    $0x400000,%esi
  803fff:	bf 00 00 00 00       	mov    $0x0,%edi
  804004:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  80400b:	00 00 00 
  80400e:	ff d0                	callq  *%rax
  804010:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804013:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804017:	79 08                	jns    804021 <map_segment+0xcc>
				return r;
  804019:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80401c:	e9 19 01 00 00       	jmpq   80413a <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804024:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804027:	01 c2                	add    %eax,%edx
  804029:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80402c:	89 d6                	mov    %edx,%esi
  80402e:	89 c7                	mov    %eax,%edi
  804030:	48 b8 3a 32 80 00 00 	movabs $0x80323a,%rax
  804037:	00 00 00 
  80403a:	ff d0                	callq  *%rax
  80403c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80403f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804043:	79 08                	jns    80404d <map_segment+0xf8>
				return r;
  804045:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804048:	e9 ed 00 00 00       	jmpq   80413a <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80404d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804057:	48 98                	cltq   
  804059:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80405d:	48 89 d1             	mov    %rdx,%rcx
  804060:	48 29 c1             	sub    %rax,%rcx
  804063:	48 89 c8             	mov    %rcx,%rax
  804066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80406a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80406d:	48 63 d0             	movslq %eax,%rdx
  804070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804074:	48 39 c2             	cmp    %rax,%rdx
  804077:	48 0f 47 d0          	cmova  %rax,%rdx
  80407b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80407e:	be 00 00 40 00       	mov    $0x400000,%esi
  804083:	89 c7                	mov    %eax,%edi
  804085:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  80408c:	00 00 00 
  80408f:	ff d0                	callq  *%rax
  804091:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804094:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804098:	79 08                	jns    8040a2 <map_segment+0x14d>
				return r;
  80409a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80409d:	e9 98 00 00 00       	jmpq   80413a <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8040a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a5:	48 98                	cltq   
  8040a7:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8040ab:	48 89 c2             	mov    %rax,%rdx
  8040ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040b1:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8040b5:	48 89 d1             	mov    %rdx,%rcx
  8040b8:	89 c2                	mov    %eax,%edx
  8040ba:	be 00 00 40 00       	mov    $0x400000,%esi
  8040bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c4:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
  8040d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040d7:	79 30                	jns    804109 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  8040d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040dc:	89 c1                	mov    %eax,%ecx
  8040de:	48 ba 4b 5e 80 00 00 	movabs $0x805e4b,%rdx
  8040e5:	00 00 00 
  8040e8:	be 24 01 00 00       	mov    $0x124,%esi
  8040ed:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  8040f4:	00 00 00 
  8040f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fc:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  804103:	00 00 00 
  804106:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804109:	be 00 00 40 00       	mov    $0x400000,%esi
  80410e:	bf 00 00 00 00       	mov    $0x0,%edi
  804113:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  80411a:	00 00 00 
  80411d:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80411f:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804129:	48 98                	cltq   
  80412b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80412f:	0f 82 7d fe ff ff    	jb     803fb2 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804135:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80413a:	c9                   	leaveq 
  80413b:	c3                   	retq   

000000000080413c <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80413c:	55                   	push   %rbp
  80413d:	48 89 e5             	mov    %rsp,%rbp
  804140:	48 83 ec 60          	sub    $0x60,%rsp
  804144:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  804147:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  80414e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804155:	00 
    uint64_t each_pte = 0;
  804156:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80415d:	00 
    uint64_t each_pdpe = 0;
  80415e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804165:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  804166:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80416d:	00 
  80416e:	e9 a5 01 00 00       	jmpq   804318 <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  804173:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80417a:	01 00 00 
  80417d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804181:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804185:	83 e0 01             	and    $0x1,%eax
  804188:	84 c0                	test   %al,%al
  80418a:	0f 84 73 01 00 00    	je     804303 <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  804190:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804197:	00 
  804198:	e9 56 01 00 00       	jmpq   8042f3 <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  80419d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041a4:	01 00 00 
  8041a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8041ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041af:	83 e0 01             	and    $0x1,%eax
  8041b2:	84 c0                	test   %al,%al
  8041b4:	0f 84 1f 01 00 00    	je     8042d9 <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8041ba:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041c1:	00 
  8041c2:	e9 02 01 00 00       	jmpq   8042c9 <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  8041c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041ce:	01 00 00 
  8041d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041d9:	83 e0 01             	and    $0x1,%eax
  8041dc:	84 c0                	test   %al,%al
  8041de:	0f 84 cb 00 00 00    	je     8042af <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8041e4:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8041eb:	00 
  8041ec:	e9 ae 00 00 00       	jmpq   80429f <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  8041f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041f8:	01 00 00 
  8041fb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8041ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804203:	25 00 04 00 00       	and    $0x400,%eax
  804208:	48 85 c0             	test   %rax,%rax
  80420b:	0f 84 84 00 00 00    	je     804295 <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  804211:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804218:	01 00 00 
  80421b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80421f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804223:	25 07 0e 00 00       	and    $0xe07,%eax
  804228:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  80422b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80422f:	48 c1 e0 0c          	shl    $0xc,%rax
  804233:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  804237:	8b 75 c0             	mov    -0x40(%rbp),%esi
  80423a:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  80423e:	8b 55 ac             	mov    -0x54(%rbp),%edx
  804241:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804245:	41 89 f0             	mov    %esi,%r8d
  804248:	48 89 c6             	mov    %rax,%rsi
  80424b:	bf 00 00 00 00       	mov    $0x0,%edi
  804250:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  804257:	00 00 00 
  80425a:	ff d0                	callq  *%rax
  80425c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  80425f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  804263:	79 30                	jns    804295 <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  804265:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804268:	89 c1                	mov    %eax,%ecx
  80426a:	48 ba 68 5e 80 00 00 	movabs $0x805e68,%rdx
  804271:	00 00 00 
  804274:	be 48 01 00 00       	mov    $0x148,%esi
  804279:	48 bf d0 5d 80 00 00 	movabs $0x805dd0,%rdi
  804280:	00 00 00 
  804283:	b8 00 00 00 00       	mov    $0x0,%eax
  804288:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  80428f:	00 00 00 
  804292:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  804295:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80429a:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80429f:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8042a6:	00 
  8042a7:	0f 86 44 ff ff ff    	jbe    8041f1 <copy_shared_pages+0xb5>
  8042ad:	eb 10                	jmp    8042bf <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  8042af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b3:	48 83 c0 01          	add    $0x1,%rax
  8042b7:	48 c1 e0 09          	shl    $0x9,%rax
  8042bb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8042bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8042c9:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8042d0:	00 
  8042d1:	0f 86 f0 fe ff ff    	jbe    8041c7 <copy_shared_pages+0x8b>
  8042d7:	eb 10                	jmp    8042e9 <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  8042d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042dd:	48 83 c0 01          	add    $0x1,%rax
  8042e1:	48 c1 e0 09          	shl    $0x9,%rax
  8042e5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8042e9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8042ee:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042f3:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8042fa:	00 
  8042fb:	0f 86 9c fe ff ff    	jbe    80419d <copy_shared_pages+0x61>
  804301:	eb 10                	jmp    804313 <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  804303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804307:	48 83 c0 01          	add    $0x1,%rax
  80430b:	48 c1 e0 09          	shl    $0x9,%rax
  80430f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  804313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804318:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80431d:	0f 84 50 fe ff ff    	je     804173 <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  804323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804328:	c9                   	leaveq 
  804329:	c3                   	retq   
	...

000000000080432c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80432c:	55                   	push   %rbp
  80432d:	48 89 e5             	mov    %rsp,%rbp
  804330:	48 83 ec 20          	sub    $0x20,%rsp
  804334:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804337:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80433b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433e:	48 89 d6             	mov    %rdx,%rsi
  804341:	89 c7                	mov    %eax,%edi
  804343:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  80434a:	00 00 00 
  80434d:	ff d0                	callq  *%rax
  80434f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804356:	79 05                	jns    80435d <fd2sockid+0x31>
		return r;
  804358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435b:	eb 24                	jmp    804381 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80435d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804361:	8b 10                	mov    (%rax),%edx
  804363:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  80436a:	00 00 00 
  80436d:	8b 00                	mov    (%rax),%eax
  80436f:	39 c2                	cmp    %eax,%edx
  804371:	74 07                	je     80437a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  804373:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804378:	eb 07                	jmp    804381 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80437a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  804381:	c9                   	leaveq 
  804382:	c3                   	retq   

0000000000804383 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  804383:	55                   	push   %rbp
  804384:	48 89 e5             	mov    %rsp,%rbp
  804387:	48 83 ec 20          	sub    $0x20,%rsp
  80438b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80438e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804392:	48 89 c7             	mov    %rax,%rdi
  804395:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  80439c:	00 00 00 
  80439f:	ff d0                	callq  *%rax
  8043a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a8:	78 26                	js     8043d0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8043aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8043b3:	48 89 c6             	mov    %rax,%rsi
  8043b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bb:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
  8043c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ce:	79 16                	jns    8043e6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8043d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043d3:	89 c7                	mov    %eax,%edi
  8043d5:	48 b8 90 48 80 00 00 	movabs $0x804890,%rax
  8043dc:	00 00 00 
  8043df:	ff d0                	callq  *%rax
		return r;
  8043e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e4:	eb 3a                	jmp    804420 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8043e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ea:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  8043f1:	00 00 00 
  8043f4:	8b 12                	mov    (%rdx),%edx
  8043f6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8043f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804407:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80440a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80440d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804411:	48 89 c7             	mov    %rax,%rdi
  804414:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  80441b:	00 00 00 
  80441e:	ff d0                	callq  *%rax
}
  804420:	c9                   	leaveq 
  804421:	c3                   	retq   

0000000000804422 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804422:	55                   	push   %rbp
  804423:	48 89 e5             	mov    %rsp,%rbp
  804426:	48 83 ec 30          	sub    $0x30,%rsp
  80442a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80442d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804431:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804435:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804438:	89 c7                	mov    %eax,%edi
  80443a:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  804441:	00 00 00 
  804444:	ff d0                	callq  *%rax
  804446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80444d:	79 05                	jns    804454 <accept+0x32>
		return r;
  80444f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804452:	eb 3b                	jmp    80448f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804454:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804458:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80445c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445f:	48 89 ce             	mov    %rcx,%rsi
  804462:	89 c7                	mov    %eax,%edi
  804464:	48 b8 6d 47 80 00 00 	movabs $0x80476d,%rax
  80446b:	00 00 00 
  80446e:	ff d0                	callq  *%rax
  804470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804477:	79 05                	jns    80447e <accept+0x5c>
		return r;
  804479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447c:	eb 11                	jmp    80448f <accept+0x6d>
	return alloc_sockfd(r);
  80447e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804481:	89 c7                	mov    %eax,%edi
  804483:	48 b8 83 43 80 00 00 	movabs $0x804383,%rax
  80448a:	00 00 00 
  80448d:	ff d0                	callq  *%rax
}
  80448f:	c9                   	leaveq 
  804490:	c3                   	retq   

0000000000804491 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804491:	55                   	push   %rbp
  804492:	48 89 e5             	mov    %rsp,%rbp
  804495:	48 83 ec 20          	sub    $0x20,%rsp
  804499:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80449c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044a0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8044a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044a6:	89 c7                	mov    %eax,%edi
  8044a8:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
  8044b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044bb:	79 05                	jns    8044c2 <bind+0x31>
		return r;
  8044bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c0:	eb 1b                	jmp    8044dd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8044c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8044c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8044c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044cc:	48 89 ce             	mov    %rcx,%rsi
  8044cf:	89 c7                	mov    %eax,%edi
  8044d1:	48 b8 ec 47 80 00 00 	movabs $0x8047ec,%rax
  8044d8:	00 00 00 
  8044db:	ff d0                	callq  *%rax
}
  8044dd:	c9                   	leaveq 
  8044de:	c3                   	retq   

00000000008044df <shutdown>:

int
shutdown(int s, int how)
{
  8044df:	55                   	push   %rbp
  8044e0:	48 89 e5             	mov    %rsp,%rbp
  8044e3:	48 83 ec 20          	sub    $0x20,%rsp
  8044e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8044ea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8044ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044f0:	89 c7                	mov    %eax,%edi
  8044f2:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  8044f9:	00 00 00 
  8044fc:	ff d0                	callq  *%rax
  8044fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804501:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804505:	79 05                	jns    80450c <shutdown+0x2d>
		return r;
  804507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80450a:	eb 16                	jmp    804522 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80450c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80450f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804512:	89 d6                	mov    %edx,%esi
  804514:	89 c7                	mov    %eax,%edi
  804516:	48 b8 50 48 80 00 00 	movabs $0x804850,%rax
  80451d:	00 00 00 
  804520:	ff d0                	callq  *%rax
}
  804522:	c9                   	leaveq 
  804523:	c3                   	retq   

0000000000804524 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804524:	55                   	push   %rbp
  804525:	48 89 e5             	mov    %rsp,%rbp
  804528:	48 83 ec 10          	sub    $0x10,%rsp
  80452c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804534:	48 89 c7             	mov    %rax,%rdi
  804537:	48 b8 ec 54 80 00 00 	movabs $0x8054ec,%rax
  80453e:	00 00 00 
  804541:	ff d0                	callq  *%rax
  804543:	83 f8 01             	cmp    $0x1,%eax
  804546:	75 17                	jne    80455f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454c:	8b 40 0c             	mov    0xc(%rax),%eax
  80454f:	89 c7                	mov    %eax,%edi
  804551:	48 b8 90 48 80 00 00 	movabs $0x804890,%rax
  804558:	00 00 00 
  80455b:	ff d0                	callq  *%rax
  80455d:	eb 05                	jmp    804564 <devsock_close+0x40>
	else
		return 0;
  80455f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804564:	c9                   	leaveq 
  804565:	c3                   	retq   

0000000000804566 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804566:	55                   	push   %rbp
  804567:	48 89 e5             	mov    %rsp,%rbp
  80456a:	48 83 ec 20          	sub    $0x20,%rsp
  80456e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804575:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804578:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80457b:	89 c7                	mov    %eax,%edi
  80457d:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  804584:	00 00 00 
  804587:	ff d0                	callq  *%rax
  804589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80458c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804590:	79 05                	jns    804597 <connect+0x31>
		return r;
  804592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804595:	eb 1b                	jmp    8045b2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804597:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80459a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80459e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a1:	48 89 ce             	mov    %rcx,%rsi
  8045a4:	89 c7                	mov    %eax,%edi
  8045a6:	48 b8 bd 48 80 00 00 	movabs $0x8048bd,%rax
  8045ad:	00 00 00 
  8045b0:	ff d0                	callq  *%rax
}
  8045b2:	c9                   	leaveq 
  8045b3:	c3                   	retq   

00000000008045b4 <listen>:

int
listen(int s, int backlog)
{
  8045b4:	55                   	push   %rbp
  8045b5:	48 89 e5             	mov    %rsp,%rbp
  8045b8:	48 83 ec 20          	sub    $0x20,%rsp
  8045bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045bf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8045c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045c5:	89 c7                	mov    %eax,%edi
  8045c7:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  8045ce:	00 00 00 
  8045d1:	ff d0                	callq  *%rax
  8045d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045da:	79 05                	jns    8045e1 <listen+0x2d>
		return r;
  8045dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045df:	eb 16                	jmp    8045f7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8045e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8045e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e7:	89 d6                	mov    %edx,%esi
  8045e9:	89 c7                	mov    %eax,%edi
  8045eb:	48 b8 21 49 80 00 00 	movabs $0x804921,%rax
  8045f2:	00 00 00 
  8045f5:	ff d0                	callq  *%rax
}
  8045f7:	c9                   	leaveq 
  8045f8:	c3                   	retq   

00000000008045f9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8045f9:	55                   	push   %rbp
  8045fa:	48 89 e5             	mov    %rsp,%rbp
  8045fd:	48 83 ec 20          	sub    $0x20,%rsp
  804601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804605:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804609:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80460d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804611:	89 c2                	mov    %eax,%edx
  804613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804617:	8b 40 0c             	mov    0xc(%rax),%eax
  80461a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80461e:	b9 00 00 00 00       	mov    $0x0,%ecx
  804623:	89 c7                	mov    %eax,%edi
  804625:	48 b8 61 49 80 00 00 	movabs $0x804961,%rax
  80462c:	00 00 00 
  80462f:	ff d0                	callq  *%rax
}
  804631:	c9                   	leaveq 
  804632:	c3                   	retq   

0000000000804633 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804633:	55                   	push   %rbp
  804634:	48 89 e5             	mov    %rsp,%rbp
  804637:	48 83 ec 20          	sub    $0x20,%rsp
  80463b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80463f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804643:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80464b:	89 c2                	mov    %eax,%edx
  80464d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804651:	8b 40 0c             	mov    0xc(%rax),%eax
  804654:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804658:	b9 00 00 00 00       	mov    $0x0,%ecx
  80465d:	89 c7                	mov    %eax,%edi
  80465f:	48 b8 2d 4a 80 00 00 	movabs $0x804a2d,%rax
  804666:	00 00 00 
  804669:	ff d0                	callq  *%rax
}
  80466b:	c9                   	leaveq 
  80466c:	c3                   	retq   

000000000080466d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80466d:	55                   	push   %rbp
  80466e:	48 89 e5             	mov    %rsp,%rbp
  804671:	48 83 ec 10          	sub    $0x10,%rsp
  804675:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804679:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80467d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804681:	48 be 86 5e 80 00 00 	movabs $0x805e86,%rsi
  804688:	00 00 00 
  80468b:	48 89 c7             	mov    %rax,%rdi
  80468e:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  804695:	00 00 00 
  804698:	ff d0                	callq  *%rax
	return 0;
  80469a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80469f:	c9                   	leaveq 
  8046a0:	c3                   	retq   

00000000008046a1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8046a1:	55                   	push   %rbp
  8046a2:	48 89 e5             	mov    %rsp,%rbp
  8046a5:	48 83 ec 20          	sub    $0x20,%rsp
  8046a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046ac:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8046af:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8046b2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8046b5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8046b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046bb:	89 ce                	mov    %ecx,%esi
  8046bd:	89 c7                	mov    %eax,%edi
  8046bf:	48 b8 e5 4a 80 00 00 	movabs $0x804ae5,%rax
  8046c6:	00 00 00 
  8046c9:	ff d0                	callq  *%rax
  8046cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d2:	79 05                	jns    8046d9 <socket+0x38>
		return r;
  8046d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d7:	eb 11                	jmp    8046ea <socket+0x49>
	return alloc_sockfd(r);
  8046d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046dc:	89 c7                	mov    %eax,%edi
  8046de:	48 b8 83 43 80 00 00 	movabs $0x804383,%rax
  8046e5:	00 00 00 
  8046e8:	ff d0                	callq  *%rax
}
  8046ea:	c9                   	leaveq 
  8046eb:	c3                   	retq   

00000000008046ec <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8046ec:	55                   	push   %rbp
  8046ed:	48 89 e5             	mov    %rsp,%rbp
  8046f0:	48 83 ec 10          	sub    $0x10,%rsp
  8046f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8046f7:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8046fe:	00 00 00 
  804701:	8b 00                	mov    (%rax),%eax
  804703:	85 c0                	test   %eax,%eax
  804705:	75 1d                	jne    804724 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804707:	bf 02 00 00 00       	mov    $0x2,%edi
  80470c:	48 b8 5e 54 80 00 00 	movabs $0x80545e,%rax
  804713:	00 00 00 
  804716:	ff d0                	callq  *%rax
  804718:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80471f:	00 00 00 
  804722:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804724:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80472b:	00 00 00 
  80472e:	8b 00                	mov    (%rax),%eax
  804730:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804733:	b9 07 00 00 00       	mov    $0x7,%ecx
  804738:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80473f:	00 00 00 
  804742:	89 c7                	mov    %eax,%edi
  804744:	48 b8 af 53 80 00 00 	movabs $0x8053af,%rax
  80474b:	00 00 00 
  80474e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804750:	ba 00 00 00 00       	mov    $0x0,%edx
  804755:	be 00 00 00 00       	mov    $0x0,%esi
  80475a:	bf 00 00 00 00       	mov    $0x0,%edi
  80475f:	48 b8 c8 52 80 00 00 	movabs $0x8052c8,%rax
  804766:	00 00 00 
  804769:	ff d0                	callq  *%rax
}
  80476b:	c9                   	leaveq 
  80476c:	c3                   	retq   

000000000080476d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80476d:	55                   	push   %rbp
  80476e:	48 89 e5             	mov    %rsp,%rbp
  804771:	48 83 ec 30          	sub    $0x30,%rsp
  804775:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804778:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80477c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804780:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804787:	00 00 00 
  80478a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80478d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80478f:	bf 01 00 00 00       	mov    $0x1,%edi
  804794:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  80479b:	00 00 00 
  80479e:	ff d0                	callq  *%rax
  8047a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047a7:	78 3e                	js     8047e7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8047a9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8047b0:	00 00 00 
  8047b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8047b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047bb:	8b 40 10             	mov    0x10(%rax),%eax
  8047be:	89 c2                	mov    %eax,%edx
  8047c0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8047c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047c8:	48 89 ce             	mov    %rcx,%rsi
  8047cb:	48 89 c7             	mov    %rax,%rdi
  8047ce:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  8047d5:	00 00 00 
  8047d8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8047da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047de:	8b 50 10             	mov    0x10(%rax),%edx
  8047e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8047e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047ea:	c9                   	leaveq 
  8047eb:	c3                   	retq   

00000000008047ec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8047ec:	55                   	push   %rbp
  8047ed:	48 89 e5             	mov    %rsp,%rbp
  8047f0:	48 83 ec 10          	sub    $0x10,%rsp
  8047f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8047f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8047fb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8047fe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804805:	00 00 00 
  804808:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80480b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80480d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804810:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804814:	48 89 c6             	mov    %rax,%rsi
  804817:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80481e:	00 00 00 
  804821:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80482d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804834:	00 00 00 
  804837:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80483a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80483d:	bf 02 00 00 00       	mov    $0x2,%edi
  804842:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  804849:	00 00 00 
  80484c:	ff d0                	callq  *%rax
}
  80484e:	c9                   	leaveq 
  80484f:	c3                   	retq   

0000000000804850 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804850:	55                   	push   %rbp
  804851:	48 89 e5             	mov    %rsp,%rbp
  804854:	48 83 ec 10          	sub    $0x10,%rsp
  804858:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80485b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80485e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804865:	00 00 00 
  804868:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80486b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80486d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804874:	00 00 00 
  804877:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80487a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80487d:	bf 03 00 00 00       	mov    $0x3,%edi
  804882:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  804889:	00 00 00 
  80488c:	ff d0                	callq  *%rax
}
  80488e:	c9                   	leaveq 
  80488f:	c3                   	retq   

0000000000804890 <nsipc_close>:

int
nsipc_close(int s)
{
  804890:	55                   	push   %rbp
  804891:	48 89 e5             	mov    %rsp,%rbp
  804894:	48 83 ec 10          	sub    $0x10,%rsp
  804898:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80489b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8048a2:	00 00 00 
  8048a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8048a8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8048aa:	bf 04 00 00 00       	mov    $0x4,%edi
  8048af:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  8048b6:	00 00 00 
  8048b9:	ff d0                	callq  *%rax
}
  8048bb:	c9                   	leaveq 
  8048bc:	c3                   	retq   

00000000008048bd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8048bd:	55                   	push   %rbp
  8048be:	48 89 e5             	mov    %rsp,%rbp
  8048c1:	48 83 ec 10          	sub    $0x10,%rsp
  8048c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8048cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8048cf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8048d6:	00 00 00 
  8048d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8048dc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8048de:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8048e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048e5:	48 89 c6             	mov    %rax,%rsi
  8048e8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8048ef:	00 00 00 
  8048f2:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  8048f9:	00 00 00 
  8048fc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8048fe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804905:	00 00 00 
  804908:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80490b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80490e:	bf 05 00 00 00       	mov    $0x5,%edi
  804913:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  80491a:	00 00 00 
  80491d:	ff d0                	callq  *%rax
}
  80491f:	c9                   	leaveq 
  804920:	c3                   	retq   

0000000000804921 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804921:	55                   	push   %rbp
  804922:	48 89 e5             	mov    %rsp,%rbp
  804925:	48 83 ec 10          	sub    $0x10,%rsp
  804929:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80492c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80492f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804936:	00 00 00 
  804939:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80493c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80493e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804945:	00 00 00 
  804948:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80494b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80494e:	bf 06 00 00 00       	mov    $0x6,%edi
  804953:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  80495a:	00 00 00 
  80495d:	ff d0                	callq  *%rax
}
  80495f:	c9                   	leaveq 
  804960:	c3                   	retq   

0000000000804961 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804961:	55                   	push   %rbp
  804962:	48 89 e5             	mov    %rsp,%rbp
  804965:	48 83 ec 30          	sub    $0x30,%rsp
  804969:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80496c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804970:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804973:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804976:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80497d:	00 00 00 
  804980:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804983:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804985:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80498c:	00 00 00 
  80498f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804992:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804995:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80499c:	00 00 00 
  80499f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8049a2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8049a5:	bf 07 00 00 00       	mov    $0x7,%edi
  8049aa:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  8049b1:	00 00 00 
  8049b4:	ff d0                	callq  *%rax
  8049b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049bd:	78 69                	js     804a28 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8049bf:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8049c6:	7f 08                	jg     8049d0 <nsipc_recv+0x6f>
  8049c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049cb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8049ce:	7e 35                	jle    804a05 <nsipc_recv+0xa4>
  8049d0:	48 b9 8d 5e 80 00 00 	movabs $0x805e8d,%rcx
  8049d7:	00 00 00 
  8049da:	48 ba a2 5e 80 00 00 	movabs $0x805ea2,%rdx
  8049e1:	00 00 00 
  8049e4:	be 61 00 00 00       	mov    $0x61,%esi
  8049e9:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  8049f0:	00 00 00 
  8049f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8049f8:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  8049ff:	00 00 00 
  804a02:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a08:	48 63 d0             	movslq %eax,%rdx
  804a0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a0f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804a16:	00 00 00 
  804a19:	48 89 c7             	mov    %rax,%rdi
  804a1c:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  804a23:	00 00 00 
  804a26:	ff d0                	callq  *%rax
	}

	return r;
  804a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a2b:	c9                   	leaveq 
  804a2c:	c3                   	retq   

0000000000804a2d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804a2d:	55                   	push   %rbp
  804a2e:	48 89 e5             	mov    %rsp,%rbp
  804a31:	48 83 ec 20          	sub    $0x20,%rsp
  804a35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804a3f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804a42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804a49:	00 00 00 
  804a4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a4f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804a51:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804a58:	7e 35                	jle    804a8f <nsipc_send+0x62>
  804a5a:	48 b9 c3 5e 80 00 00 	movabs $0x805ec3,%rcx
  804a61:	00 00 00 
  804a64:	48 ba a2 5e 80 00 00 	movabs $0x805ea2,%rdx
  804a6b:	00 00 00 
  804a6e:	be 6c 00 00 00       	mov    $0x6c,%esi
  804a73:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  804a7a:	00 00 00 
  804a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  804a82:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  804a89:	00 00 00 
  804a8c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a92:	48 63 d0             	movslq %eax,%rdx
  804a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a99:	48 89 c6             	mov    %rax,%rsi
  804a9c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804aa3:	00 00 00 
  804aa6:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  804aad:	00 00 00 
  804ab0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804ab2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804ab9:	00 00 00 
  804abc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804abf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804ac2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804ac9:	00 00 00 
  804acc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804acf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804ad2:	bf 08 00 00 00       	mov    $0x8,%edi
  804ad7:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  804ade:	00 00 00 
  804ae1:	ff d0                	callq  *%rax
}
  804ae3:	c9                   	leaveq 
  804ae4:	c3                   	retq   

0000000000804ae5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804ae5:	55                   	push   %rbp
  804ae6:	48 89 e5             	mov    %rsp,%rbp
  804ae9:	48 83 ec 10          	sub    $0x10,%rsp
  804aed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804af0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804af3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804af6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804afd:	00 00 00 
  804b00:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b03:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804b05:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804b0c:	00 00 00 
  804b0f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b12:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804b15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804b1c:	00 00 00 
  804b1f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804b22:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804b25:	bf 09 00 00 00       	mov    $0x9,%edi
  804b2a:	48 b8 ec 46 80 00 00 	movabs $0x8046ec,%rax
  804b31:	00 00 00 
  804b34:	ff d0                	callq  *%rax
}
  804b36:	c9                   	leaveq 
  804b37:	c3                   	retq   

0000000000804b38 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804b38:	55                   	push   %rbp
  804b39:	48 89 e5             	mov    %rsp,%rbp
  804b3c:	53                   	push   %rbx
  804b3d:	48 83 ec 38          	sub    $0x38,%rsp
  804b41:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804b45:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804b49:	48 89 c7             	mov    %rax,%rdi
  804b4c:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  804b53:	00 00 00 
  804b56:	ff d0                	callq  *%rax
  804b58:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804b5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b5f:	0f 88 bf 01 00 00    	js     804d24 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b69:	ba 07 04 00 00       	mov    $0x407,%edx
  804b6e:	48 89 c6             	mov    %rax,%rsi
  804b71:	bf 00 00 00 00       	mov    $0x0,%edi
  804b76:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  804b7d:	00 00 00 
  804b80:	ff d0                	callq  *%rax
  804b82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804b85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b89:	0f 88 95 01 00 00    	js     804d24 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804b8f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804b93:	48 89 c7             	mov    %rax,%rdi
  804b96:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  804b9d:	00 00 00 
  804ba0:	ff d0                	callq  *%rax
  804ba2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ba5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ba9:	0f 88 5d 01 00 00    	js     804d0c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804baf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bb3:	ba 07 04 00 00       	mov    $0x407,%edx
  804bb8:	48 89 c6             	mov    %rax,%rsi
  804bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  804bc0:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  804bc7:	00 00 00 
  804bca:	ff d0                	callq  *%rax
  804bcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bd3:	0f 88 33 01 00 00    	js     804d0c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804bd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bdd:	48 89 c7             	mov    %rax,%rdi
  804be0:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  804be7:	00 00 00 
  804bea:	ff d0                	callq  *%rax
  804bec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804bf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804bf4:	ba 07 04 00 00       	mov    $0x407,%edx
  804bf9:	48 89 c6             	mov    %rax,%rsi
  804bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  804c01:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  804c08:	00 00 00 
  804c0b:	ff d0                	callq  *%rax
  804c0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804c14:	0f 88 d9 00 00 00    	js     804cf3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804c1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c1e:	48 89 c7             	mov    %rax,%rdi
  804c21:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  804c28:	00 00 00 
  804c2b:	ff d0                	callq  *%rax
  804c2d:	48 89 c2             	mov    %rax,%rdx
  804c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c34:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804c3a:	48 89 d1             	mov    %rdx,%rcx
  804c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  804c42:	48 89 c6             	mov    %rax,%rsi
  804c45:	bf 00 00 00 00       	mov    $0x0,%edi
  804c4a:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  804c51:	00 00 00 
  804c54:	ff d0                	callq  *%rax
  804c56:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804c59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804c5d:	78 79                	js     804cd8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804c5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c63:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804c6a:	00 00 00 
  804c6d:	8b 12                	mov    (%rdx),%edx
  804c6f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804c7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c80:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804c87:	00 00 00 
  804c8a:	8b 12                	mov    (%rdx),%edx
  804c8c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804c8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c92:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804c99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c9d:	48 89 c7             	mov    %rax,%rdi
  804ca0:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804ca7:	00 00 00 
  804caa:	ff d0                	callq  *%rax
  804cac:	89 c2                	mov    %eax,%edx
  804cae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cb2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804cb4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cb8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804cbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804cc0:	48 89 c7             	mov    %rax,%rdi
  804cc3:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  804cca:	00 00 00 
  804ccd:	ff d0                	callq  *%rax
  804ccf:	89 03                	mov    %eax,(%rbx)
	return 0;
  804cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  804cd6:	eb 4f                	jmp    804d27 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804cd8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804cd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cdd:	48 89 c6             	mov    %rax,%rsi
  804ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  804ce5:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  804cec:	00 00 00 
  804cef:	ff d0                	callq  *%rax
  804cf1:	eb 01                	jmp    804cf4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804cf3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804cf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804cf8:	48 89 c6             	mov    %rax,%rsi
  804cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  804d00:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  804d07:	00 00 00 
  804d0a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804d0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d10:	48 89 c6             	mov    %rax,%rsi
  804d13:	bf 00 00 00 00       	mov    $0x0,%edi
  804d18:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  804d1f:	00 00 00 
  804d22:	ff d0                	callq  *%rax
err:
	return r;
  804d24:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804d27:	48 83 c4 38          	add    $0x38,%rsp
  804d2b:	5b                   	pop    %rbx
  804d2c:	5d                   	pop    %rbp
  804d2d:	c3                   	retq   

0000000000804d2e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804d2e:	55                   	push   %rbp
  804d2f:	48 89 e5             	mov    %rsp,%rbp
  804d32:	53                   	push   %rbx
  804d33:	48 83 ec 28          	sub    $0x28,%rsp
  804d37:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804d3b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804d3f:	eb 01                	jmp    804d42 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804d41:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804d42:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d49:	00 00 00 
  804d4c:	48 8b 00             	mov    (%rax),%rax
  804d4f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804d55:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d5c:	48 89 c7             	mov    %rax,%rdi
  804d5f:	48 b8 ec 54 80 00 00 	movabs $0x8054ec,%rax
  804d66:	00 00 00 
  804d69:	ff d0                	callq  *%rax
  804d6b:	89 c3                	mov    %eax,%ebx
  804d6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d71:	48 89 c7             	mov    %rax,%rdi
  804d74:	48 b8 ec 54 80 00 00 	movabs $0x8054ec,%rax
  804d7b:	00 00 00 
  804d7e:	ff d0                	callq  *%rax
  804d80:	39 c3                	cmp    %eax,%ebx
  804d82:	0f 94 c0             	sete   %al
  804d85:	0f b6 c0             	movzbl %al,%eax
  804d88:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804d8b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804d92:	00 00 00 
  804d95:	48 8b 00             	mov    (%rax),%rax
  804d98:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804d9e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804da1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804da4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804da7:	75 0a                	jne    804db3 <_pipeisclosed+0x85>
			return ret;
  804da9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  804dac:	48 83 c4 28          	add    $0x28,%rsp
  804db0:	5b                   	pop    %rbx
  804db1:	5d                   	pop    %rbp
  804db2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804db3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804db6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804db9:	74 86                	je     804d41 <_pipeisclosed+0x13>
  804dbb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804dbf:	75 80                	jne    804d41 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804dc1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804dc8:	00 00 00 
  804dcb:	48 8b 00             	mov    (%rax),%rax
  804dce:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804dd4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804dd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dda:	89 c6                	mov    %eax,%esi
  804ddc:	48 bf d4 5e 80 00 00 	movabs $0x805ed4,%rdi
  804de3:	00 00 00 
  804de6:	b8 00 00 00 00       	mov    $0x0,%eax
  804deb:	49 b8 3f 0b 80 00 00 	movabs $0x800b3f,%r8
  804df2:	00 00 00 
  804df5:	41 ff d0             	callq  *%r8
	}
  804df8:	e9 44 ff ff ff       	jmpq   804d41 <_pipeisclosed+0x13>

0000000000804dfd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804dfd:	55                   	push   %rbp
  804dfe:	48 89 e5             	mov    %rsp,%rbp
  804e01:	48 83 ec 30          	sub    $0x30,%rsp
  804e05:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804e08:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804e0c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804e0f:	48 89 d6             	mov    %rdx,%rsi
  804e12:	89 c7                	mov    %eax,%edi
  804e14:	48 b8 e2 2b 80 00 00 	movabs $0x802be2,%rax
  804e1b:	00 00 00 
  804e1e:	ff d0                	callq  *%rax
  804e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e27:	79 05                	jns    804e2e <pipeisclosed+0x31>
		return r;
  804e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e2c:	eb 31                	jmp    804e5f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e32:	48 89 c7             	mov    %rax,%rdi
  804e35:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  804e3c:	00 00 00 
  804e3f:	ff d0                	callq  *%rax
  804e41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e4d:	48 89 d6             	mov    %rdx,%rsi
  804e50:	48 89 c7             	mov    %rax,%rdi
  804e53:	48 b8 2e 4d 80 00 00 	movabs $0x804d2e,%rax
  804e5a:	00 00 00 
  804e5d:	ff d0                	callq  *%rax
}
  804e5f:	c9                   	leaveq 
  804e60:	c3                   	retq   

0000000000804e61 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804e61:	55                   	push   %rbp
  804e62:	48 89 e5             	mov    %rsp,%rbp
  804e65:	48 83 ec 40          	sub    $0x40,%rsp
  804e69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804e6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804e71:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e79:	48 89 c7             	mov    %rax,%rdi
  804e7c:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  804e83:	00 00 00 
  804e86:	ff d0                	callq  *%rax
  804e88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804e94:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804e9b:	00 
  804e9c:	e9 97 00 00 00       	jmpq   804f38 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804ea1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804ea6:	74 09                	je     804eb1 <devpipe_read+0x50>
				return i;
  804ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804eac:	e9 95 00 00 00       	jmpq   804f46 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804eb1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804eb9:	48 89 d6             	mov    %rdx,%rsi
  804ebc:	48 89 c7             	mov    %rax,%rdi
  804ebf:	48 b8 2e 4d 80 00 00 	movabs $0x804d2e,%rax
  804ec6:	00 00 00 
  804ec9:	ff d0                	callq  *%rax
  804ecb:	85 c0                	test   %eax,%eax
  804ecd:	74 07                	je     804ed6 <devpipe_read+0x75>
				return 0;
  804ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  804ed4:	eb 70                	jmp    804f46 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804ed6:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  804edd:	00 00 00 
  804ee0:	ff d0                	callq  *%rax
  804ee2:	eb 01                	jmp    804ee5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804ee4:	90                   	nop
  804ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ee9:	8b 10                	mov    (%rax),%edx
  804eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eef:	8b 40 04             	mov    0x4(%rax),%eax
  804ef2:	39 c2                	cmp    %eax,%edx
  804ef4:	74 ab                	je     804ea1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804ef6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804efa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804efe:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f06:	8b 00                	mov    (%rax),%eax
  804f08:	89 c2                	mov    %eax,%edx
  804f0a:	c1 fa 1f             	sar    $0x1f,%edx
  804f0d:	c1 ea 1b             	shr    $0x1b,%edx
  804f10:	01 d0                	add    %edx,%eax
  804f12:	83 e0 1f             	and    $0x1f,%eax
  804f15:	29 d0                	sub    %edx,%eax
  804f17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f1b:	48 98                	cltq   
  804f1d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804f22:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f28:	8b 00                	mov    (%rax),%eax
  804f2a:	8d 50 01             	lea    0x1(%rax),%edx
  804f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f31:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804f33:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f3c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804f40:	72 a2                	jb     804ee4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804f46:	c9                   	leaveq 
  804f47:	c3                   	retq   

0000000000804f48 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804f48:	55                   	push   %rbp
  804f49:	48 89 e5             	mov    %rsp,%rbp
  804f4c:	48 83 ec 40          	sub    $0x40,%rsp
  804f50:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804f54:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804f58:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f60:	48 89 c7             	mov    %rax,%rdi
  804f63:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  804f6a:	00 00 00 
  804f6d:	ff d0                	callq  *%rax
  804f6f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804f7b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804f82:	00 
  804f83:	e9 93 00 00 00       	jmpq   80501b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804f88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f90:	48 89 d6             	mov    %rdx,%rsi
  804f93:	48 89 c7             	mov    %rax,%rdi
  804f96:	48 b8 2e 4d 80 00 00 	movabs $0x804d2e,%rax
  804f9d:	00 00 00 
  804fa0:	ff d0                	callq  *%rax
  804fa2:	85 c0                	test   %eax,%eax
  804fa4:	74 07                	je     804fad <devpipe_write+0x65>
				return 0;
  804fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  804fab:	eb 7c                	jmp    805029 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804fad:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  804fb4:	00 00 00 
  804fb7:	ff d0                	callq  *%rax
  804fb9:	eb 01                	jmp    804fbc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804fbb:	90                   	nop
  804fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fc0:	8b 40 04             	mov    0x4(%rax),%eax
  804fc3:	48 63 d0             	movslq %eax,%rdx
  804fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fca:	8b 00                	mov    (%rax),%eax
  804fcc:	48 98                	cltq   
  804fce:	48 83 c0 20          	add    $0x20,%rax
  804fd2:	48 39 c2             	cmp    %rax,%rdx
  804fd5:	73 b1                	jae    804f88 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fdb:	8b 40 04             	mov    0x4(%rax),%eax
  804fde:	89 c2                	mov    %eax,%edx
  804fe0:	c1 fa 1f             	sar    $0x1f,%edx
  804fe3:	c1 ea 1b             	shr    $0x1b,%edx
  804fe6:	01 d0                	add    %edx,%eax
  804fe8:	83 e0 1f             	and    $0x1f,%eax
  804feb:	29 d0                	sub    %edx,%eax
  804fed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804ff1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804ff5:	48 01 ca             	add    %rcx,%rdx
  804ff8:	0f b6 0a             	movzbl (%rdx),%ecx
  804ffb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fff:	48 98                	cltq   
  805001:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805009:	8b 40 04             	mov    0x4(%rax),%eax
  80500c:	8d 50 01             	lea    0x1(%rax),%edx
  80500f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805013:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805016:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80501b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80501f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805023:	72 96                	jb     804fbb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805029:	c9                   	leaveq 
  80502a:	c3                   	retq   

000000000080502b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80502b:	55                   	push   %rbp
  80502c:	48 89 e5             	mov    %rsp,%rbp
  80502f:	48 83 ec 20          	sub    $0x20,%rsp
  805033:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805037:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80503b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80503f:	48 89 c7             	mov    %rax,%rdi
  805042:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  805049:	00 00 00 
  80504c:	ff d0                	callq  *%rax
  80504e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805056:	48 be e7 5e 80 00 00 	movabs $0x805ee7,%rsi
  80505d:	00 00 00 
  805060:	48 89 c7             	mov    %rax,%rdi
  805063:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80506a:	00 00 00 
  80506d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80506f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805073:	8b 50 04             	mov    0x4(%rax),%edx
  805076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80507a:	8b 00                	mov    (%rax),%eax
  80507c:	29 c2                	sub    %eax,%edx
  80507e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805082:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805088:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80508c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805093:	00 00 00 
	stat->st_dev = &devpipe;
  805096:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80509a:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  8050a1:	00 00 00 
  8050a4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8050ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050b0:	c9                   	leaveq 
  8050b1:	c3                   	retq   

00000000008050b2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8050b2:	55                   	push   %rbp
  8050b3:	48 89 e5             	mov    %rsp,%rbp
  8050b6:	48 83 ec 10          	sub    $0x10,%rsp
  8050ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8050be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050c2:	48 89 c6             	mov    %rax,%rsi
  8050c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8050ca:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8050d1:	00 00 00 
  8050d4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8050d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050da:	48 89 c7             	mov    %rax,%rdi
  8050dd:	48 b8 1f 2b 80 00 00 	movabs $0x802b1f,%rax
  8050e4:	00 00 00 
  8050e7:	ff d0                	callq  *%rax
  8050e9:	48 89 c6             	mov    %rax,%rsi
  8050ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8050f1:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8050f8:	00 00 00 
  8050fb:	ff d0                	callq  *%rax
}
  8050fd:	c9                   	leaveq 
  8050fe:	c3                   	retq   
	...

0000000000805100 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805100:	55                   	push   %rbp
  805101:	48 89 e5             	mov    %rsp,%rbp
  805104:	48 83 ec 20          	sub    $0x20,%rsp
  805108:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80510b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80510f:	75 35                	jne    805146 <wait+0x46>
  805111:	48 b9 ee 5e 80 00 00 	movabs $0x805eee,%rcx
  805118:	00 00 00 
  80511b:	48 ba f9 5e 80 00 00 	movabs $0x805ef9,%rdx
  805122:	00 00 00 
  805125:	be 09 00 00 00       	mov    $0x9,%esi
  80512a:	48 bf 0e 5f 80 00 00 	movabs $0x805f0e,%rdi
  805131:	00 00 00 
  805134:	b8 00 00 00 00       	mov    $0x0,%eax
  805139:	49 b8 04 09 80 00 00 	movabs $0x800904,%r8
  805140:	00 00 00 
  805143:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805146:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805149:	48 98                	cltq   
  80514b:	48 89 c2             	mov    %rax,%rdx
  80514e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  805154:	48 89 d0             	mov    %rdx,%rax
  805157:	48 c1 e0 02          	shl    $0x2,%rax
  80515b:	48 01 d0             	add    %rdx,%rax
  80515e:	48 01 c0             	add    %rax,%rax
  805161:	48 01 d0             	add    %rdx,%rax
  805164:	48 c1 e0 05          	shl    $0x5,%rax
  805168:	48 89 c2             	mov    %rax,%rdx
  80516b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805172:	00 00 00 
  805175:	48 01 d0             	add    %rdx,%rax
  805178:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80517c:	eb 0c                	jmp    80518a <wait+0x8a>
		sys_yield();
  80517e:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  805185:	00 00 00 
  805188:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80518a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80518e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805194:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805197:	75 0e                	jne    8051a7 <wait+0xa7>
  805199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80519d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8051a3:	85 c0                	test   %eax,%eax
  8051a5:	75 d7                	jne    80517e <wait+0x7e>
		sys_yield();
}
  8051a7:	c9                   	leaveq 
  8051a8:	c3                   	retq   
  8051a9:	00 00                	add    %al,(%rax)
	...

00000000008051ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8051ac:	55                   	push   %rbp
  8051ad:	48 89 e5             	mov    %rsp,%rbp
  8051b0:	48 83 ec 10          	sub    $0x10,%rsp
  8051b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8051b8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8051bf:	00 00 00 
  8051c2:	48 8b 00             	mov    (%rax),%rax
  8051c5:	48 85 c0             	test   %rax,%rax
  8051c8:	75 66                	jne    805230 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8051ca:	ba 07 00 00 00       	mov    $0x7,%edx
  8051cf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8051d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8051d9:	48 b8 48 20 80 00 00 	movabs $0x802048,%rax
  8051e0:	00 00 00 
  8051e3:	ff d0                	callq  *%rax
  8051e5:	85 c0                	test   %eax,%eax
  8051e7:	75 1d                	jne    805206 <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8051e9:	48 be 44 52 80 00 00 	movabs $0x805244,%rsi
  8051f0:	00 00 00 
  8051f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8051f8:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8051ff:	00 00 00 
  805202:	ff d0                	callq  *%rax
  805204:	eb 2a                	jmp    805230 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  805206:	48 ba 19 5f 80 00 00 	movabs $0x805f19,%rdx
  80520d:	00 00 00 
  805210:	be 23 00 00 00       	mov    $0x23,%esi
  805215:	48 bf 37 5f 80 00 00 	movabs $0x805f37,%rdi
  80521c:	00 00 00 
  80521f:	b8 00 00 00 00       	mov    $0x0,%eax
  805224:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  80522b:	00 00 00 
  80522e:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805230:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805237:	00 00 00 
  80523a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80523e:	48 89 10             	mov    %rdx,(%rax)
}
  805241:	c9                   	leaveq 
  805242:	c3                   	retq   
	...

0000000000805244 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805244:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805247:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  80524e:	00 00 00 
call *%rax
  805251:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  805253:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  805257:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  80525c:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  805263:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  805264:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  805268:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80526b:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  805272:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  805273:	4c 8b 3c 24          	mov    (%rsp),%r15
  805277:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80527c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805281:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805286:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80528b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805290:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805295:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80529a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80529f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8052a4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8052a9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8052ae:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8052b3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8052b8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8052bd:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8052c1:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8052c5:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8052c6:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8052c7:	c3                   	retq   

00000000008052c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8052c8:	55                   	push   %rbp
  8052c9:	48 89 e5             	mov    %rsp,%rbp
  8052cc:	48 83 ec 30          	sub    $0x30,%rsp
  8052d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8052d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8052d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8052dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8052e3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8052e8:	74 18                	je     805302 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8052ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052ee:	48 89 c7             	mov    %rax,%rdi
  8052f1:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  8052f8:	00 00 00 
  8052fb:	ff d0                	callq  *%rax
  8052fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805300:	eb 19                	jmp    80531b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  805302:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  805309:	00 00 00 
  80530c:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  805313:	00 00 00 
  805316:	ff d0                	callq  *%rax
  805318:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80531b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80531f:	79 39                	jns    80535a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  805321:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805326:	75 08                	jne    805330 <ipc_recv+0x68>
  805328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80532c:	8b 00                	mov    (%rax),%eax
  80532e:	eb 05                	jmp    805335 <ipc_recv+0x6d>
  805330:	b8 00 00 00 00       	mov    $0x0,%eax
  805335:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805339:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80533b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805340:	75 08                	jne    80534a <ipc_recv+0x82>
  805342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805346:	8b 00                	mov    (%rax),%eax
  805348:	eb 05                	jmp    80534f <ipc_recv+0x87>
  80534a:	b8 00 00 00 00       	mov    $0x0,%eax
  80534f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805353:	89 02                	mov    %eax,(%rdx)
		return r;
  805355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805358:	eb 53                	jmp    8053ad <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80535a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80535f:	74 19                	je     80537a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  805361:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805368:	00 00 00 
  80536b:	48 8b 00             	mov    (%rax),%rax
  80536e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805378:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80537a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80537f:	74 19                	je     80539a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  805381:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805388:	00 00 00 
  80538b:	48 8b 00             	mov    (%rax),%rax
  80538e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805398:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80539a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8053a1:	00 00 00 
  8053a4:	48 8b 00             	mov    (%rax),%rax
  8053a7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8053ad:	c9                   	leaveq 
  8053ae:	c3                   	retq   

00000000008053af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8053af:	55                   	push   %rbp
  8053b0:	48 89 e5             	mov    %rsp,%rbp
  8053b3:	48 83 ec 30          	sub    $0x30,%rsp
  8053b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8053ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8053bd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8053c1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8053c4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8053cb:	eb 59                	jmp    805426 <ipc_send+0x77>
		if(pg) {
  8053cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8053d2:	74 20                	je     8053f4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8053d4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8053d7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8053da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053e1:	89 c7                	mov    %eax,%edi
  8053e3:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  8053ea:	00 00 00 
  8053ed:	ff d0                	callq  *%rax
  8053ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053f2:	eb 26                	jmp    80541a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8053f4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8053f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8053fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053fd:	89 d1                	mov    %edx,%ecx
  8053ff:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  805406:	00 00 00 
  805409:	89 c7                	mov    %eax,%edi
  80540b:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  805412:	00 00 00 
  805415:	ff d0                	callq  *%rax
  805417:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80541a:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  805421:	00 00 00 
  805424:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  805426:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80542a:	74 a1                	je     8053cd <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  80542c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805430:	74 2a                	je     80545c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  805432:	48 ba 48 5f 80 00 00 	movabs $0x805f48,%rdx
  805439:	00 00 00 
  80543c:	be 49 00 00 00       	mov    $0x49,%esi
  805441:	48 bf 73 5f 80 00 00 	movabs $0x805f73,%rdi
  805448:	00 00 00 
  80544b:	b8 00 00 00 00       	mov    $0x0,%eax
  805450:	48 b9 04 09 80 00 00 	movabs $0x800904,%rcx
  805457:	00 00 00 
  80545a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80545c:	c9                   	leaveq 
  80545d:	c3                   	retq   

000000000080545e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80545e:	55                   	push   %rbp
  80545f:	48 89 e5             	mov    %rsp,%rbp
  805462:	48 83 ec 18          	sub    $0x18,%rsp
  805466:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805470:	eb 6a                	jmp    8054dc <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  805472:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805479:	00 00 00 
  80547c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80547f:	48 63 d0             	movslq %eax,%rdx
  805482:	48 89 d0             	mov    %rdx,%rax
  805485:	48 c1 e0 02          	shl    $0x2,%rax
  805489:	48 01 d0             	add    %rdx,%rax
  80548c:	48 01 c0             	add    %rax,%rax
  80548f:	48 01 d0             	add    %rdx,%rax
  805492:	48 c1 e0 05          	shl    $0x5,%rax
  805496:	48 01 c8             	add    %rcx,%rax
  805499:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80549f:	8b 00                	mov    (%rax),%eax
  8054a1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8054a4:	75 32                	jne    8054d8 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8054a6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8054ad:	00 00 00 
  8054b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b3:	48 63 d0             	movslq %eax,%rdx
  8054b6:	48 89 d0             	mov    %rdx,%rax
  8054b9:	48 c1 e0 02          	shl    $0x2,%rax
  8054bd:	48 01 d0             	add    %rdx,%rax
  8054c0:	48 01 c0             	add    %rax,%rax
  8054c3:	48 01 d0             	add    %rdx,%rax
  8054c6:	48 c1 e0 05          	shl    $0x5,%rax
  8054ca:	48 01 c8             	add    %rcx,%rax
  8054cd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8054d3:	8b 40 08             	mov    0x8(%rax),%eax
  8054d6:	eb 12                	jmp    8054ea <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8054d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8054dc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8054e3:	7e 8d                	jle    805472 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8054e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8054ea:	c9                   	leaveq 
  8054eb:	c3                   	retq   

00000000008054ec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8054ec:	55                   	push   %rbp
  8054ed:	48 89 e5             	mov    %rsp,%rbp
  8054f0:	48 83 ec 18          	sub    $0x18,%rsp
  8054f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8054f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054fc:	48 89 c2             	mov    %rax,%rdx
  8054ff:	48 c1 ea 15          	shr    $0x15,%rdx
  805503:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80550a:	01 00 00 
  80550d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805511:	83 e0 01             	and    $0x1,%eax
  805514:	48 85 c0             	test   %rax,%rax
  805517:	75 07                	jne    805520 <pageref+0x34>
		return 0;
  805519:	b8 00 00 00 00       	mov    $0x0,%eax
  80551e:	eb 53                	jmp    805573 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805524:	48 89 c2             	mov    %rax,%rdx
  805527:	48 c1 ea 0c          	shr    $0xc,%rdx
  80552b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805532:	01 00 00 
  805535:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805539:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80553d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805541:	83 e0 01             	and    $0x1,%eax
  805544:	48 85 c0             	test   %rax,%rax
  805547:	75 07                	jne    805550 <pageref+0x64>
		return 0;
  805549:	b8 00 00 00 00       	mov    $0x0,%eax
  80554e:	eb 23                	jmp    805573 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805554:	48 89 c2             	mov    %rax,%rdx
  805557:	48 c1 ea 0c          	shr    $0xc,%rdx
  80555b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805562:	00 00 00 
  805565:	48 c1 e2 04          	shl    $0x4,%rdx
  805569:	48 01 d0             	add    %rdx,%rax
  80556c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805570:	0f b7 c0             	movzwl %ax,%eax
}
  805573:	c9                   	leaveq 
  805574:	c3                   	retq   
