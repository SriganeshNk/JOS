
obj/user/primespipe.debug:     file format elf64-x86-64


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
  80003c:	e8 df 03 00 00       	callq  800420 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004f:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800053:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800056:	ba 04 00 00 00       	mov    $0x4,%edx
  80005b:	48 89 ce             	mov    %rcx,%rsi
  80005e:	89 c7                	mov    %eax,%edi
  800060:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800073:	74 42                	je     8000b7 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
  80007a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007e:	89 c2                	mov    %eax,%edx
  800080:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  800084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800087:	41 89 d0             	mov    %edx,%r8d
  80008a:	89 c1                	mov    %eax,%ecx
  80008c:	48 ba 60 47 80 00 00 	movabs $0x804760,%rdx
  800093:	00 00 00 
  800096:	be 15 00 00 00       	mov    $0x15,%esi
  80009b:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  8000a2:	00 00 00 
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	49 b9 ec 04 80 00 00 	movabs $0x8004ec,%r9
  8000b1:	00 00 00 
  8000b4:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	48 bf a1 47 80 00 00 	movabs $0x8047a1,%rdi
  8000c3:	00 00 00 
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  8000d2:	00 00 00 
  8000d5:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000db:	48 89 c7             	mov    %rax,%rdi
  8000de:	48 b8 18 3b 80 00 00 	movabs $0x803b18,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	79 30                	jns    800124 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f7:	89 c1                	mov    %eax,%ecx
  8000f9:	48 ba a5 47 80 00 00 	movabs $0x8047a5,%rdx
  800100:	00 00 00 
  800103:	be 1b 00 00 00       	mov    $0x1b,%esi
  800108:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  80011e:	00 00 00 
  800121:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800124:	48 b8 46 23 80 00 00 	movabs $0x802346,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
  800130:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800133:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800137:	79 30                	jns    800169 <primeproc+0x125>
		panic("fork: %e", id);
  800139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013c:	89 c1                	mov    %eax,%ecx
  80013e:	48 ba ae 47 80 00 00 	movabs $0x8047ae,%rdx
  800145:	00 00 00 
  800148:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014d:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  800154:	00 00 00 
  800157:	b8 00 00 00 00       	mov    $0x0,%eax
  80015c:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  800163:	00 00 00 
  800166:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800169:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016d:	75 2d                	jne    80019c <primeproc+0x158>
		close(fd);
  80016f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800172:	89 c7                	mov    %eax,%edi
  800174:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
		close(pfd[1]);
  800180:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800183:	89 c7                	mov    %eax,%edi
  800185:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80018c:	00 00 00 
  80018f:	ff d0                	callq  *%rax
		fd = pfd[0];
  800191:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800194:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800197:	e9 b3 fe ff ff       	jmpq   80004f <primeproc+0xb>
	}

	close(pfd[0]);
  80019c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b3:	eb 01                	jmp    8001b6 <primeproc+0x172>
		if ((r=readn(fd, &i, 4)) != 4)
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
			if ((r=write(wfd, &i, 4)) != 4)
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
	}
  8001b5:	90                   	nop
	close(pfd[0]);
	wfd = pfd[1];

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b6:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001bd:	ba 04 00 00 00       	mov    $0x4,%edx
  8001c2:	48 89 ce             	mov    %rcx,%rsi
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	48 b8 d5 2c 80 00 00 	movabs $0x802cd5,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
  8001d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001da:	74 4e                	je     80022a <primeproc+0x1e6>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  8001eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ee:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001f1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f4:	89 14 24             	mov    %edx,(%rsp)
  8001f7:	41 89 f1             	mov    %esi,%r9d
  8001fa:	41 89 c8             	mov    %ecx,%r8d
  8001fd:	89 c1                	mov    %eax,%ecx
  8001ff:	48 ba b7 47 80 00 00 	movabs $0x8047b7,%rdx
  800206:	00 00 00 
  800209:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020e:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  800215:	00 00 00 
  800218:	b8 00 00 00 00       	mov    $0x0,%eax
  80021d:	49 ba ec 04 80 00 00 	movabs $0x8004ec,%r10
  800224:	00 00 00 
  800227:	41 ff d2             	callq  *%r10
		if (i%p)
  80022a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80022d:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  800230:	89 c2                	mov    %eax,%edx
  800232:	c1 fa 1f             	sar    $0x1f,%edx
  800235:	f7 f9                	idiv   %ecx
  800237:	89 d0                	mov    %edx,%eax
  800239:	85 c0                	test   %eax,%eax
  80023b:	0f 84 74 ff ff ff    	je     8001b5 <primeproc+0x171>
			if ((r=write(wfd, &i, 4)) != 4)
  800241:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800245:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800248:	ba 04 00 00 00       	mov    $0x4,%edx
  80024d:	48 89 ce             	mov    %rcx,%rsi
  800250:	89 c7                	mov    %eax,%edi
  800252:	48 b8 4a 2d 80 00 00 	movabs $0x802d4a,%rax
  800259:	00 00 00 
  80025c:	ff d0                	callq  *%rax
  80025e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800261:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800265:	0f 84 4a ff ff ff    	je     8001b5 <primeproc+0x171>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80026b:	b8 00 00 00 00       	mov    $0x0,%eax
  800270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800274:	89 c1                	mov    %eax,%ecx
  800276:	0f 4e 4d fc          	cmovle -0x4(%rbp),%ecx
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800280:	41 89 c9             	mov    %ecx,%r9d
  800283:	41 89 d0             	mov    %edx,%r8d
  800286:	89 c1                	mov    %eax,%ecx
  800288:	48 ba d3 47 80 00 00 	movabs $0x8047d3,%rdx
  80028f:	00 00 00 
  800292:	be 2e 00 00 00       	mov    $0x2e,%esi
  800297:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  80029e:	00 00 00 
  8002a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a6:	49 ba ec 04 80 00 00 	movabs $0x8004ec,%r10
  8002ad:	00 00 00 
  8002b0:	41 ff d2             	callq  *%r10

00000000008002b3 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8002b3:	55                   	push   %rbp
  8002b4:	48 89 e5             	mov    %rsp,%rbp
  8002b7:	48 83 ec 30          	sub    $0x30,%rsp
  8002bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8002be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c9:	00 00 00 
  8002cc:	48 ba ed 47 80 00 00 	movabs $0x8047ed,%rdx
  8002d3:	00 00 00 
  8002d6:	48 89 10             	mov    %rdx,(%rax)

	if ((i=pipe(p)) < 0)
  8002d9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002dd:	48 89 c7             	mov    %rax,%rdi
  8002e0:	48 b8 18 3b 80 00 00 	movabs $0x803b18,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	callq  *%rax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f2:	85 c0                	test   %eax,%eax
  8002f4:	79 30                	jns    800326 <umain+0x73>
		panic("pipe: %e", i);
  8002f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f9:	89 c1                	mov    %eax,%ecx
  8002fb:	48 ba a5 47 80 00 00 	movabs $0x8047a5,%rdx
  800302:	00 00 00 
  800305:	be 3a 00 00 00       	mov    $0x3a,%esi
  80030a:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  800320:	00 00 00 
  800323:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800326:	48 b8 46 23 80 00 00 	movabs $0x802346,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800339:	79 30                	jns    80036b <umain+0xb8>
		panic("fork: %e", id);
  80033b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	48 ba ae 47 80 00 00 	movabs $0x8047ae,%rdx
  800347:	00 00 00 
  80034a:	be 3e 00 00 00       	mov    $0x3e,%esi
  80034f:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  800356:	00 00 00 
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  800365:	00 00 00 
  800368:	41 ff d0             	callq  *%r8

	if (id == 0) {
  80036b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80036f:	75 22                	jne    800393 <umain+0xe0>
		close(p[1]);
  800371:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800374:	89 c7                	mov    %eax,%edi
  800376:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80037d:	00 00 00 
  800380:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800382:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800385:	89 c7                	mov    %eax,%edi
  800387:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80038e:	00 00 00 
  800391:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800393:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800396:	89 c7                	mov    %eax,%edi
  800398:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  8003a4:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003ae:	48 8d 4d f4          	lea    -0xc(%rbp),%rcx
  8003b2:	ba 04 00 00 00       	mov    $0x4,%edx
  8003b7:	48 89 ce             	mov    %rcx,%rsi
  8003ba:	89 c7                	mov    %eax,%edi
  8003bc:	48 b8 4a 2d 80 00 00 	movabs $0x802d4a,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax
  8003c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003cb:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
  8003cf:	74 42                	je     800413 <umain+0x160>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	0f 4e 55 f8          	cmovle -0x8(%rbp),%edx
  8003e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e3:	41 89 d0             	mov    %edx,%r8d
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	48 ba f8 47 80 00 00 	movabs $0x8047f8,%rdx
  8003ef:	00 00 00 
  8003f2:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003f7:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  8003fe:	00 00 00 
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
  800406:	49 b9 ec 04 80 00 00 	movabs $0x8004ec,%r9
  80040d:	00 00 00 
  800410:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800413:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800416:	83 c0 01             	add    $0x1,%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  80041c:	eb 8d                	jmp    8003ab <umain+0xf8>
	...

0000000000800420 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 83 ec 10          	sub    $0x10,%rsp
  800428:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80042f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800436:	00 00 00 
  800439:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800440:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
  80044c:	48 98                	cltq   
  80044e:	48 89 c2             	mov    %rax,%rdx
  800451:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800457:	48 89 d0             	mov    %rdx,%rax
  80045a:	48 c1 e0 02          	shl    $0x2,%rax
  80045e:	48 01 d0             	add    %rdx,%rax
  800461:	48 01 c0             	add    %rax,%rax
  800464:	48 01 d0             	add    %rdx,%rax
  800467:	48 c1 e0 05          	shl    $0x5,%rax
  80046b:	48 89 c2             	mov    %rax,%rdx
  80046e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800475:	00 00 00 
  800478:	48 01 c2             	add    %rax,%rdx
  80047b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800482:	00 00 00 
  800485:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80048c:	7e 14                	jle    8004a2 <libmain+0x82>
		binaryname = argv[0];
  80048e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800492:	48 8b 10             	mov    (%rax),%rdx
  800495:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80049c:	00 00 00 
  80049f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a9:	48 89 d6             	mov    %rdx,%rsi
  8004ac:	89 c7                	mov    %eax,%edi
  8004ae:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  8004b5:	00 00 00 
  8004b8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004ba:	48 b8 c8 04 80 00 00 	movabs $0x8004c8,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
}
  8004c6:	c9                   	leaveq 
  8004c7:	c3                   	retq   

00000000008004c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004cc:	48 b8 25 2a 80 00 00 	movabs $0x802a25,%rax
  8004d3:	00 00 00 
  8004d6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8004dd:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  8004e4:	00 00 00 
  8004e7:	ff d0                	callq  *%rax
}
  8004e9:	5d                   	pop    %rbp
  8004ea:	c3                   	retq   
	...

00000000008004ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004ec:	55                   	push   %rbp
  8004ed:	48 89 e5             	mov    %rsp,%rbp
  8004f0:	53                   	push   %rbx
  8004f1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004f8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004ff:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800505:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80050c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800513:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80051a:	84 c0                	test   %al,%al
  80051c:	74 23                	je     800541 <_panic+0x55>
  80051e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800525:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800529:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80052d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800531:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800535:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800539:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80053d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800541:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800548:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80054f:	00 00 00 
  800552:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800559:	00 00 00 
  80055c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800560:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800567:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80056e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800575:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80057c:	00 00 00 
  80057f:	48 8b 18             	mov    (%rax),%rbx
  800582:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  800589:	00 00 00 
  80058c:	ff d0                	callq  *%rax
  80058e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800594:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80059b:	41 89 c8             	mov    %ecx,%r8d
  80059e:	48 89 d1             	mov    %rdx,%rcx
  8005a1:	48 89 da             	mov    %rbx,%rdx
  8005a4:	89 c6                	mov    %eax,%esi
  8005a6:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  8005ad:	00 00 00 
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	49 b9 27 07 80 00 00 	movabs $0x800727,%r9
  8005bc:	00 00 00 
  8005bf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005c2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005c9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005d0:	48 89 d6             	mov    %rdx,%rsi
  8005d3:	48 89 c7             	mov    %rax,%rdi
  8005d6:	48 b8 7b 06 80 00 00 	movabs $0x80067b,%rax
  8005dd:	00 00 00 
  8005e0:	ff d0                	callq  *%rax
	cprintf("\n");
  8005e2:	48 bf 43 48 80 00 00 	movabs $0x804843,%rdi
  8005e9:	00 00 00 
  8005ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f1:	48 ba 27 07 80 00 00 	movabs $0x800727,%rdx
  8005f8:	00 00 00 
  8005fb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005fd:	cc                   	int3   
  8005fe:	eb fd                	jmp    8005fd <_panic+0x111>

0000000000800600 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	48 83 ec 10          	sub    $0x10,%rsp
  800608:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80060b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80060f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800618:	89 d6                	mov    %edx,%esi
  80061a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80061e:	48 63 d0             	movslq %eax,%rdx
  800621:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800626:	8d 50 01             	lea    0x1(%rax),%edx
  800629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062d:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80062f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	3d ff 00 00 00       	cmp    $0xff,%eax
  80063a:	75 2c                	jne    800668 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	48 98                	cltq   
  800644:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800648:	48 83 c2 08          	add    $0x8,%rdx
  80064c:	48 89 c6             	mov    %rax,%rsi
  80064f:	48 89 d7             	mov    %rdx,%rdi
  800652:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  800659:	00 00 00 
  80065c:	ff d0                	callq  *%rax
        b->idx = 0;
  80065e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800662:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066c:	8b 40 04             	mov    0x4(%rax),%eax
  80066f:	8d 50 01             	lea    0x1(%rax),%edx
  800672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800676:	89 50 04             	mov    %edx,0x4(%rax)
}
  800679:	c9                   	leaveq 
  80067a:	c3                   	retq   

000000000080067b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80067b:	55                   	push   %rbp
  80067c:	48 89 e5             	mov    %rsp,%rbp
  80067f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800686:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80068d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800694:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80069b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006a2:	48 8b 0a             	mov    (%rdx),%rcx
  8006a5:	48 89 08             	mov    %rcx,(%rax)
  8006a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006bf:	00 00 00 
    b.cnt = 0;
  8006c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006c9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006e1:	48 89 c6             	mov    %rax,%rsi
  8006e4:	48 bf 00 06 80 00 00 	movabs $0x800600,%rdi
  8006eb:	00 00 00 
  8006ee:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800700:	48 98                	cltq   
  800702:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800709:	48 83 c2 08          	add    $0x8,%rdx
  80070d:	48 89 c6             	mov    %rax,%rsi
  800710:	48 89 d7             	mov    %rdx,%rdi
  800713:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80071f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800725:	c9                   	leaveq 
  800726:	c3                   	retq   

0000000000800727 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800727:	55                   	push   %rbp
  800728:	48 89 e5             	mov    %rsp,%rbp
  80072b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800732:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800739:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800740:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800747:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80074e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800755:	84 c0                	test   %al,%al
  800757:	74 20                	je     800779 <cprintf+0x52>
  800759:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80075d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800761:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800765:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800769:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80076d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800771:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800775:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800779:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800780:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800787:	00 00 00 
  80078a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800791:	00 00 00 
  800794:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800798:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80079f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007bb:	48 8b 0a             	mov    (%rdx),%rcx
  8007be:	48 89 08             	mov    %rcx,(%rax)
  8007c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007df:	48 89 d6             	mov    %rdx,%rsi
  8007e2:	48 89 c7             	mov    %rax,%rdi
  8007e5:	48 b8 7b 06 80 00 00 	movabs $0x80067b,%rax
  8007ec:	00 00 00 
  8007ef:	ff d0                	callq  *%rax
  8007f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007fd:	c9                   	leaveq 
  8007fe:	c3                   	retq   
	...

0000000000800800 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800800:	55                   	push   %rbp
  800801:	48 89 e5             	mov    %rsp,%rbp
  800804:	48 83 ec 30          	sub    $0x30,%rsp
  800808:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800810:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800814:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800817:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80081b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800822:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800826:	77 52                	ja     80087a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800828:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80082b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80082f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800832:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800843:	48 89 c2             	mov    %rax,%rdx
  800846:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800849:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80084c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800854:	41 89 f9             	mov    %edi,%r9d
  800857:	48 89 c7             	mov    %rax,%rdi
  80085a:	48 b8 00 08 80 00 00 	movabs $0x800800,%rax
  800861:	00 00 00 
  800864:	ff d0                	callq  *%rax
  800866:	eb 1c                	jmp    800884 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80086c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80086f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800873:	48 89 d6             	mov    %rdx,%rsi
  800876:	89 c7                	mov    %eax,%edi
  800878:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80087e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800882:	7f e4                	jg     800868 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800884:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	ba 00 00 00 00       	mov    $0x0,%edx
  800890:	48 f7 f1             	div    %rcx
  800893:	48 89 d0             	mov    %rdx,%rax
  800896:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  80089d:	00 00 00 
  8008a0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008a4:	0f be c0             	movsbl %al,%eax
  8008a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008af:	48 89 d6             	mov    %rdx,%rsi
  8008b2:	89 c7                	mov    %eax,%edi
  8008b4:	ff d1                	callq  *%rcx
}
  8008b6:	c9                   	leaveq 
  8008b7:	c3                   	retq   

00000000008008b8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %rbp
  8008b9:	48 89 e5             	mov    %rsp,%rbp
  8008bc:	48 83 ec 20          	sub    $0x20,%rsp
  8008c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008c7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008cb:	7e 52                	jle    80091f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d1:	8b 00                	mov    (%rax),%eax
  8008d3:	83 f8 30             	cmp    $0x30,%eax
  8008d6:	73 24                	jae    8008fc <getuint+0x44>
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	8b 00                	mov    (%rax),%eax
  8008e6:	89 c0                	mov    %eax,%eax
  8008e8:	48 01 d0             	add    %rdx,%rax
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	8b 12                	mov    (%rdx),%edx
  8008f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f8:	89 0a                	mov    %ecx,(%rdx)
  8008fa:	eb 17                	jmp    800913 <getuint+0x5b>
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800904:	48 89 d0             	mov    %rdx,%rax
  800907:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800913:	48 8b 00             	mov    (%rax),%rax
  800916:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091a:	e9 a3 00 00 00       	jmpq   8009c2 <getuint+0x10a>
	else if (lflag)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800923:	74 4f                	je     800974 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 30             	cmp    $0x30,%eax
  80092e:	73 24                	jae    800954 <getuint+0x9c>
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	8b 00                	mov    (%rax),%eax
  80093e:	89 c0                	mov    %eax,%eax
  800940:	48 01 d0             	add    %rdx,%rax
  800943:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800947:	8b 12                	mov    (%rdx),%edx
  800949:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800950:	89 0a                	mov    %ecx,(%rdx)
  800952:	eb 17                	jmp    80096b <getuint+0xb3>
  800954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800958:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095c:	48 89 d0             	mov    %rdx,%rax
  80095f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800967:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096b:	48 8b 00             	mov    (%rax),%rax
  80096e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800972:	eb 4e                	jmp    8009c2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 24                	jae    8009a3 <getuint+0xeb>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	8b 12                	mov    (%rdx),%edx
  800998:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 0a                	mov    %ecx,(%rdx)
  8009a1:	eb 17                	jmp    8009ba <getuint+0x102>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ab:	48 89 d0             	mov    %rdx,%rax
  8009ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ba:	8b 00                	mov    (%rax),%eax
  8009bc:	89 c0                	mov    %eax,%eax
  8009be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c6:	c9                   	leaveq 
  8009c7:	c3                   	retq   

00000000008009c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009c8:	55                   	push   %rbp
  8009c9:	48 89 e5             	mov    %rsp,%rbp
  8009cc:	48 83 ec 20          	sub    $0x20,%rsp
  8009d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009db:	7e 52                	jle    800a2f <getint+0x67>
		x=va_arg(*ap, long long);
  8009dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e1:	8b 00                	mov    (%rax),%eax
  8009e3:	83 f8 30             	cmp    $0x30,%eax
  8009e6:	73 24                	jae    800a0c <getint+0x44>
  8009e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f4:	8b 00                	mov    (%rax),%eax
  8009f6:	89 c0                	mov    %eax,%eax
  8009f8:	48 01 d0             	add    %rdx,%rax
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	8b 12                	mov    (%rdx),%edx
  800a01:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a08:	89 0a                	mov    %ecx,(%rdx)
  800a0a:	eb 17                	jmp    800a23 <getint+0x5b>
  800a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a10:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a14:	48 89 d0             	mov    %rdx,%rax
  800a17:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a23:	48 8b 00             	mov    (%rax),%rax
  800a26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a2a:	e9 a3 00 00 00       	jmpq   800ad2 <getint+0x10a>
	else if (lflag)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a33:	74 4f                	je     800a84 <getint+0xbc>
		x=va_arg(*ap, long);
  800a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a39:	8b 00                	mov    (%rax),%eax
  800a3b:	83 f8 30             	cmp    $0x30,%eax
  800a3e:	73 24                	jae    800a64 <getint+0x9c>
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4c:	8b 00                	mov    (%rax),%eax
  800a4e:	89 c0                	mov    %eax,%eax
  800a50:	48 01 d0             	add    %rdx,%rax
  800a53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a57:	8b 12                	mov    (%rdx),%edx
  800a59:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a60:	89 0a                	mov    %ecx,(%rdx)
  800a62:	eb 17                	jmp    800a7b <getint+0xb3>
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a6c:	48 89 d0             	mov    %rdx,%rax
  800a6f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a77:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a7b:	48 8b 00             	mov    (%rax),%rax
  800a7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a82:	eb 4e                	jmp    800ad2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a88:	8b 00                	mov    (%rax),%eax
  800a8a:	83 f8 30             	cmp    $0x30,%eax
  800a8d:	73 24                	jae    800ab3 <getint+0xeb>
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9b:	8b 00                	mov    (%rax),%eax
  800a9d:	89 c0                	mov    %eax,%eax
  800a9f:	48 01 d0             	add    %rdx,%rax
  800aa2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa6:	8b 12                	mov    (%rdx),%edx
  800aa8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aaf:	89 0a                	mov    %ecx,(%rdx)
  800ab1:	eb 17                	jmp    800aca <getint+0x102>
  800ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800abb:	48 89 d0             	mov    %rdx,%rax
  800abe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ac2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aca:	8b 00                	mov    (%rax),%eax
  800acc:	48 98                	cltq   
  800ace:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ad6:	c9                   	leaveq 
  800ad7:	c3                   	retq   

0000000000800ad8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ad8:	55                   	push   %rbp
  800ad9:	48 89 e5             	mov    %rsp,%rbp
  800adc:	41 54                	push   %r12
  800ade:	53                   	push   %rbx
  800adf:	48 83 ec 60          	sub    $0x60,%rsp
  800ae3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ae7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800aeb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aef:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800af3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800afb:	48 8b 0a             	mov    (%rdx),%rcx
  800afe:	48 89 08             	mov    %rcx,(%rax)
  800b01:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b05:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b09:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b0d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b11:	eb 17                	jmp    800b2a <vprintfmt+0x52>
			if (ch == '\0')
  800b13:	85 db                	test   %ebx,%ebx
  800b15:	0f 84 ea 04 00 00    	je     801005 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800b1b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b1f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b23:	48 89 c6             	mov    %rax,%rsi
  800b26:	89 df                	mov    %ebx,%edi
  800b28:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b2e:	0f b6 00             	movzbl (%rax),%eax
  800b31:	0f b6 d8             	movzbl %al,%ebx
  800b34:	83 fb 25             	cmp    $0x25,%ebx
  800b37:	0f 95 c0             	setne  %al
  800b3a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b3f:	84 c0                	test   %al,%al
  800b41:	75 d0                	jne    800b13 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b43:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b47:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b5c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800b63:	eb 04                	jmp    800b69 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800b65:	90                   	nop
  800b66:	eb 01                	jmp    800b69 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800b68:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6d:	0f b6 00             	movzbl (%rax),%eax
  800b70:	0f b6 d8             	movzbl %al,%ebx
  800b73:	89 d8                	mov    %ebx,%eax
  800b75:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b7a:	83 e8 23             	sub    $0x23,%eax
  800b7d:	83 f8 55             	cmp    $0x55,%eax
  800b80:	0f 87 4b 04 00 00    	ja     800fd1 <vprintfmt+0x4f9>
  800b86:	89 c0                	mov    %eax,%eax
  800b88:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b8f:	00 
  800b90:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
  800b97:	00 00 00 
  800b9a:	48 01 d0             	add    %rdx,%rax
  800b9d:	48 8b 00             	mov    (%rax),%rax
  800ba0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba6:	eb c1                	jmp    800b69 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bac:	eb bb                	jmp    800b69 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bb8:	89 d0                	mov    %edx,%eax
  800bba:	c1 e0 02             	shl    $0x2,%eax
  800bbd:	01 d0                	add    %edx,%eax
  800bbf:	01 c0                	add    %eax,%eax
  800bc1:	01 d8                	add    %ebx,%eax
  800bc3:	83 e8 30             	sub    $0x30,%eax
  800bc6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bc9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcd:	0f b6 00             	movzbl (%rax),%eax
  800bd0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd3:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd6:	7e 63                	jle    800c3b <vprintfmt+0x163>
  800bd8:	83 fb 39             	cmp    $0x39,%ebx
  800bdb:	7f 5e                	jg     800c3b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bdd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be2:	eb d1                	jmp    800bb5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800be4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be7:	83 f8 30             	cmp    $0x30,%eax
  800bea:	73 17                	jae    800c03 <vprintfmt+0x12b>
  800bec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf3:	89 c0                	mov    %eax,%eax
  800bf5:	48 01 d0             	add    %rdx,%rax
  800bf8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bfb:	83 c2 08             	add    $0x8,%edx
  800bfe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c01:	eb 0f                	jmp    800c12 <vprintfmt+0x13a>
  800c03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c07:	48 89 d0             	mov    %rdx,%rax
  800c0a:	48 83 c2 08          	add    $0x8,%rdx
  800c0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c12:	8b 00                	mov    (%rax),%eax
  800c14:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c17:	eb 23                	jmp    800c3c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800c19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c1d:	0f 89 42 ff ff ff    	jns    800b65 <vprintfmt+0x8d>
				width = 0;
  800c23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c2a:	e9 36 ff ff ff       	jmpq   800b65 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800c2f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c36:	e9 2e ff ff ff       	jmpq   800b69 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c3b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c40:	0f 89 22 ff ff ff    	jns    800b68 <vprintfmt+0x90>
				width = precision, precision = -1;
  800c46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c49:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c4c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c53:	e9 10 ff ff ff       	jmpq   800b68 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c58:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c5c:	e9 08 ff ff ff       	jmpq   800b69 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c64:	83 f8 30             	cmp    $0x30,%eax
  800c67:	73 17                	jae    800c80 <vprintfmt+0x1a8>
  800c69:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c70:	89 c0                	mov    %eax,%eax
  800c72:	48 01 d0             	add    %rdx,%rax
  800c75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c78:	83 c2 08             	add    $0x8,%edx
  800c7b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c7e:	eb 0f                	jmp    800c8f <vprintfmt+0x1b7>
  800c80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c84:	48 89 d0             	mov    %rdx,%rax
  800c87:	48 83 c2 08          	add    $0x8,%rdx
  800c8b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8f:	8b 00                	mov    (%rax),%eax
  800c91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c95:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c99:	48 89 d6             	mov    %rdx,%rsi
  800c9c:	89 c7                	mov    %eax,%edi
  800c9e:	ff d1                	callq  *%rcx
			break;
  800ca0:	e9 5a 03 00 00       	jmpq   800fff <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ca5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca8:	83 f8 30             	cmp    $0x30,%eax
  800cab:	73 17                	jae    800cc4 <vprintfmt+0x1ec>
  800cad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb4:	89 c0                	mov    %eax,%eax
  800cb6:	48 01 d0             	add    %rdx,%rax
  800cb9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbc:	83 c2 08             	add    $0x8,%edx
  800cbf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc2:	eb 0f                	jmp    800cd3 <vprintfmt+0x1fb>
  800cc4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc8:	48 89 d0             	mov    %rdx,%rax
  800ccb:	48 83 c2 08          	add    $0x8,%rdx
  800ccf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cd5:	85 db                	test   %ebx,%ebx
  800cd7:	79 02                	jns    800cdb <vprintfmt+0x203>
				err = -err;
  800cd9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cdb:	83 fb 15             	cmp    $0x15,%ebx
  800cde:	7f 16                	jg     800cf6 <vprintfmt+0x21e>
  800ce0:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  800ce7:	00 00 00 
  800cea:	48 63 d3             	movslq %ebx,%rdx
  800ced:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf1:	4d 85 e4             	test   %r12,%r12
  800cf4:	75 2e                	jne    800d24 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800cf6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfe:	89 d9                	mov    %ebx,%ecx
  800d00:	48 ba 61 4a 80 00 00 	movabs $0x804a61,%rdx
  800d07:	00 00 00 
  800d0a:	48 89 c7             	mov    %rax,%rdi
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d12:	49 b8 0f 10 80 00 00 	movabs $0x80100f,%r8
  800d19:	00 00 00 
  800d1c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1f:	e9 db 02 00 00       	jmpq   800fff <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d24:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2c:	4c 89 e1             	mov    %r12,%rcx
  800d2f:	48 ba 6a 4a 80 00 00 	movabs $0x804a6a,%rdx
  800d36:	00 00 00 
  800d39:	48 89 c7             	mov    %rax,%rdi
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	49 b8 0f 10 80 00 00 	movabs $0x80100f,%r8
  800d48:	00 00 00 
  800d4b:	41 ff d0             	callq  *%r8
			break;
  800d4e:	e9 ac 02 00 00       	jmpq   800fff <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d56:	83 f8 30             	cmp    $0x30,%eax
  800d59:	73 17                	jae    800d72 <vprintfmt+0x29a>
  800d5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d62:	89 c0                	mov    %eax,%eax
  800d64:	48 01 d0             	add    %rdx,%rax
  800d67:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6a:	83 c2 08             	add    $0x8,%edx
  800d6d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d70:	eb 0f                	jmp    800d81 <vprintfmt+0x2a9>
  800d72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d76:	48 89 d0             	mov    %rdx,%rax
  800d79:	48 83 c2 08          	add    $0x8,%rdx
  800d7d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d81:	4c 8b 20             	mov    (%rax),%r12
  800d84:	4d 85 e4             	test   %r12,%r12
  800d87:	75 0a                	jne    800d93 <vprintfmt+0x2bb>
				p = "(null)";
  800d89:	49 bc 6d 4a 80 00 00 	movabs $0x804a6d,%r12
  800d90:	00 00 00 
			if (width > 0 && padc != '-')
  800d93:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d97:	7e 7a                	jle    800e13 <vprintfmt+0x33b>
  800d99:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d9d:	74 74                	je     800e13 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da2:	48 98                	cltq   
  800da4:	48 89 c6             	mov    %rax,%rsi
  800da7:	4c 89 e7             	mov    %r12,%rdi
  800daa:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  800db1:	00 00 00 
  800db4:	ff d0                	callq  *%rax
  800db6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800db9:	eb 17                	jmp    800dd2 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800dbb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800dbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc3:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800dc7:	48 89 d6             	mov    %rdx,%rsi
  800dca:	89 c7                	mov    %eax,%edi
  800dcc:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dce:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd6:	7f e3                	jg     800dbb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd8:	eb 39                	jmp    800e13 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800dda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dde:	74 1e                	je     800dfe <vprintfmt+0x326>
  800de0:	83 fb 1f             	cmp    $0x1f,%ebx
  800de3:	7e 05                	jle    800dea <vprintfmt+0x312>
  800de5:	83 fb 7e             	cmp    $0x7e,%ebx
  800de8:	7e 14                	jle    800dfe <vprintfmt+0x326>
					putch('?', putdat);
  800dea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dee:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800df2:	48 89 c6             	mov    %rax,%rsi
  800df5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dfa:	ff d2                	callq  *%rdx
  800dfc:	eb 0f                	jmp    800e0d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800dfe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e02:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e06:	48 89 c6             	mov    %rax,%rsi
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e11:	eb 01                	jmp    800e14 <vprintfmt+0x33c>
  800e13:	90                   	nop
  800e14:	41 0f b6 04 24       	movzbl (%r12),%eax
  800e19:	0f be d8             	movsbl %al,%ebx
  800e1c:	85 db                	test   %ebx,%ebx
  800e1e:	0f 95 c0             	setne  %al
  800e21:	49 83 c4 01          	add    $0x1,%r12
  800e25:	84 c0                	test   %al,%al
  800e27:	74 28                	je     800e51 <vprintfmt+0x379>
  800e29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2d:	78 ab                	js     800dda <vprintfmt+0x302>
  800e2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e37:	79 a1                	jns    800dda <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e39:	eb 16                	jmp    800e51 <vprintfmt+0x379>
				putch(' ', putdat);
  800e3b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e43:	48 89 c6             	mov    %rax,%rsi
  800e46:	bf 20 00 00 00       	mov    $0x20,%edi
  800e4b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e55:	7f e4                	jg     800e3b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800e57:	e9 a3 01 00 00       	jmpq   800fff <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e60:	be 03 00 00 00       	mov    $0x3,%esi
  800e65:	48 89 c7             	mov    %rax,%rdi
  800e68:	48 b8 c8 09 80 00 00 	movabs $0x8009c8,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	callq  *%rax
  800e74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	48 85 c0             	test   %rax,%rax
  800e7f:	79 1d                	jns    800e9e <vprintfmt+0x3c6>
				putch('-', putdat);
  800e81:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e85:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e89:	48 89 c6             	mov    %rax,%rsi
  800e8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e91:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e97:	48 f7 d8             	neg    %rax
  800e9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea5:	e9 e8 00 00 00       	jmpq   800f92 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eaa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eae:	be 03 00 00 00       	mov    $0x3,%esi
  800eb3:	48 89 c7             	mov    %rax,%rdi
  800eb6:	48 b8 b8 08 80 00 00 	movabs $0x8008b8,%rax
  800ebd:	00 00 00 
  800ec0:	ff d0                	callq  *%rax
  800ec2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ec6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecd:	e9 c0 00 00 00       	jmpq   800f92 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eda:	48 89 c6             	mov    %rax,%rsi
  800edd:	bf 58 00 00 00       	mov    $0x58,%edi
  800ee2:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800ee4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ee8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eec:	48 89 c6             	mov    %rax,%rsi
  800eef:	bf 58 00 00 00       	mov    $0x58,%edi
  800ef4:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800ef6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800efa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800efe:	48 89 c6             	mov    %rax,%rsi
  800f01:	bf 58 00 00 00       	mov    $0x58,%edi
  800f06:	ff d2                	callq  *%rdx
			break;
  800f08:	e9 f2 00 00 00       	jmpq   800fff <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800f0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f15:	48 89 c6             	mov    %rax,%rsi
  800f18:	bf 30 00 00 00       	mov    $0x30,%edi
  800f1d:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800f1f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f23:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f27:	48 89 c6             	mov    %rax,%rsi
  800f2a:	bf 78 00 00 00       	mov    $0x78,%edi
  800f2f:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f34:	83 f8 30             	cmp    $0x30,%eax
  800f37:	73 17                	jae    800f50 <vprintfmt+0x478>
  800f39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f40:	89 c0                	mov    %eax,%eax
  800f42:	48 01 d0             	add    %rdx,%rax
  800f45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f48:	83 c2 08             	add    $0x8,%edx
  800f4b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4e:	eb 0f                	jmp    800f5f <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800f50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 83 c2 08          	add    $0x8,%rdx
  800f5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f5f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f66:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f6d:	eb 23                	jmp    800f92 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f73:	be 03 00 00 00       	mov    $0x3,%esi
  800f78:	48 89 c7             	mov    %rax,%rdi
  800f7b:	48 b8 b8 08 80 00 00 	movabs $0x8008b8,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	callq  *%rax
  800f87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f8b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f92:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f97:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f9a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa9:	45 89 c1             	mov    %r8d,%r9d
  800fac:	41 89 f8             	mov    %edi,%r8d
  800faf:	48 89 c7             	mov    %rax,%rdi
  800fb2:	48 b8 00 08 80 00 00 	movabs $0x800800,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	callq  *%rax
			break;
  800fbe:	eb 3f                	jmp    800fff <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fc4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fc8:	48 89 c6             	mov    %rax,%rsi
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	ff d2                	callq  *%rdx
			break;
  800fcf:	eb 2e                	jmp    800fff <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fd5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fd9:	48 89 c6             	mov    %rax,%rsi
  800fdc:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe1:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe8:	eb 05                	jmp    800fef <vprintfmt+0x517>
  800fea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ff3:	48 83 e8 01          	sub    $0x1,%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	3c 25                	cmp    $0x25,%al
  800ffc:	75 ec                	jne    800fea <vprintfmt+0x512>
				/* do nothing */;
			break;
  800ffe:	90                   	nop
		}
	}
  800fff:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801000:	e9 25 fb ff ff       	jmpq   800b2a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801005:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801006:	48 83 c4 60          	add    $0x60,%rsp
  80100a:	5b                   	pop    %rbx
  80100b:	41 5c                	pop    %r12
  80100d:	5d                   	pop    %rbp
  80100e:	c3                   	retq   

000000000080100f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100f:	55                   	push   %rbp
  801010:	48 89 e5             	mov    %rsp,%rbp
  801013:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80101a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801021:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801028:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801036:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80103d:	84 c0                	test   %al,%al
  80103f:	74 20                	je     801061 <printfmt+0x52>
  801041:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801045:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801049:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80104d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801051:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801055:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801059:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80105d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801061:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801068:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80106f:	00 00 00 
  801072:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801079:	00 00 00 
  80107c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801080:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801087:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80108e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801095:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80109c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010aa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b1:	48 89 c7             	mov    %rax,%rdi
  8010b4:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 10          	sub    $0x10,%rsp
  8010ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d5:	8b 40 10             	mov    0x10(%rax),%eax
  8010d8:	8d 50 01             	lea    0x1(%rax),%edx
  8010db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010df:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e6:	48 8b 10             	mov    (%rax),%rdx
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f1:	48 39 c2             	cmp    %rax,%rdx
  8010f4:	73 17                	jae    80110d <sprintputch+0x4b>
		*b->buf++ = ch;
  8010f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fa:	48 8b 00             	mov    (%rax),%rax
  8010fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801100:	88 10                	mov    %dl,(%rax)
  801102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110a:	48 89 10             	mov    %rdx,(%rax)
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 50          	sub    $0x50,%rsp
  801117:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80111b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80111e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801122:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801126:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80112a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80112e:	48 8b 0a             	mov    (%rdx),%rcx
  801131:	48 89 08             	mov    %rcx,(%rax)
  801134:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801138:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801140:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801144:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801148:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80114c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80114f:	48 98                	cltq   
  801151:	48 83 e8 01          	sub    $0x1,%rax
  801155:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801159:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80115d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801164:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801169:	74 06                	je     801171 <vsnprintf+0x62>
  80116b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80116f:	7f 07                	jg     801178 <vsnprintf+0x69>
		return -E_INVAL;
  801171:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801176:	eb 2f                	jmp    8011a7 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801178:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80117c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801180:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801184:	48 89 c6             	mov    %rax,%rsi
  801187:	48 bf c2 10 80 00 00 	movabs $0x8010c2,%rdi
  80118e:	00 00 00 
  801191:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  801198:	00 00 00 
  80119b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80119d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011a1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011a4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011b4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011bb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011c1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011c8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011cf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 20                	je     8011fa <snprintf+0x51>
  8011da:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011de:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ea:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ee:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011fa:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801201:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801208:	00 00 00 
  80120b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801212:	00 00 00 
  801215:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801219:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801220:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801227:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80122e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801235:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80123c:	48 8b 0a             	mov    (%rdx),%rcx
  80123f:	48 89 08             	mov    %rcx,(%rax)
  801242:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801246:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80124a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80124e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801252:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801259:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801260:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801266:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80126d:	48 89 c7             	mov    %rax,%rdi
  801270:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  801277:	00 00 00 
  80127a:	ff d0                	callq  *%rax
  80127c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801282:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   
	...

000000000080128c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 18          	sub    $0x18,%rsp
  801294:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80129f:	eb 09                	jmp    8012aa <strlen+0x1e>
		n++;
  8012a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	84 c0                	test   %al,%al
  8012b3:	75 ec                	jne    8012a1 <strlen+0x15>
		n++;
	return n;
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 20          	sub    $0x20,%rsp
  8012c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d1:	eb 0e                	jmp    8012e1 <strnlen+0x27>
		n++;
  8012d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012e6:	74 0b                	je     8012f3 <strnlen+0x39>
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	84 c0                	test   %al,%al
  8012f1:	75 e0                	jne    8012d3 <strnlen+0x19>
		n++;
	return n;
  8012f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 20          	sub    $0x20,%rsp
  801300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801310:	90                   	nop
  801311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801315:	0f b6 10             	movzbl (%rax),%edx
  801318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131c:	88 10                	mov    %dl,(%rax)
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	84 c0                	test   %al,%al
  801327:	0f 95 c0             	setne  %al
  80132a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80132f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801334:	84 c0                	test   %al,%al
  801336:	75 d9                	jne    801311 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 20          	sub    $0x20,%rsp
  801346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80134e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  80135c:	00 00 00 
  80135f:	ff d0                	callq  *%rax
  801361:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801364:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801367:	48 98                	cltq   
  801369:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80136d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801371:	48 89 d6             	mov    %rdx,%rsi
  801374:	48 89 c7             	mov    %rax,%rdi
  801377:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  80137e:	00 00 00 
  801381:	ff d0                	callq  *%rax
	return dst;
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 28          	sub    $0x28,%rsp
  801391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013a5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013ac:	00 
  8013ad:	eb 27                	jmp    8013d6 <strncpy+0x4d>
		*dst++ = *src;
  8013af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b3:	0f b6 10             	movzbl (%rax),%edx
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	88 10                	mov    %dl,(%rax)
  8013bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c5:	0f b6 00             	movzbl (%rax),%eax
  8013c8:	84 c0                	test   %al,%al
  8013ca:	74 05                	je     8013d1 <strncpy+0x48>
			src++;
  8013cc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013de:	72 cf                	jb     8013af <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013e4:	c9                   	leaveq 
  8013e5:	c3                   	retq   

00000000008013e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013e6:	55                   	push   %rbp
  8013e7:	48 89 e5             	mov    %rsp,%rbp
  8013ea:	48 83 ec 28          	sub    $0x28,%rsp
  8013ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801402:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801407:	74 37                	je     801440 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801409:	eb 17                	jmp    801422 <strlcpy+0x3c>
			*dst++ = *src++;
  80140b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140f:	0f b6 10             	movzbl (%rax),%edx
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	88 10                	mov    %dl,(%rax)
  801418:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80141d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801422:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801427:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80142c:	74 0b                	je     801439 <strlcpy+0x53>
  80142e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	84 c0                	test   %al,%al
  801437:	75 d2                	jne    80140b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801440:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	48 89 d1             	mov    %rdx,%rcx
  80144b:	48 29 c1             	sub    %rax,%rcx
  80144e:	48 89 c8             	mov    %rcx,%rax
}
  801451:	c9                   	leaveq 
  801452:	c3                   	retq   

0000000000801453 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	48 83 ec 10          	sub    $0x10,%rsp
  80145b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801463:	eb 0a                	jmp    80146f <strcmp+0x1c>
		p++, q++;
  801465:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80146a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80146f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	84 c0                	test   %al,%al
  801478:	74 12                	je     80148c <strcmp+0x39>
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	0f b6 10             	movzbl (%rax),%edx
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	38 c2                	cmp    %al,%dl
  80148a:	74 d9                	je     801465 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	0f b6 d0             	movzbl %al,%edx
  801496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	0f b6 c0             	movzbl %al,%eax
  8014a0:	89 d1                	mov    %edx,%ecx
  8014a2:	29 c1                	sub    %eax,%ecx
  8014a4:	89 c8                	mov    %ecx,%eax
}
  8014a6:	c9                   	leaveq 
  8014a7:	c3                   	retq   

00000000008014a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014a8:	55                   	push   %rbp
  8014a9:	48 89 e5             	mov    %rsp,%rbp
  8014ac:	48 83 ec 18          	sub    $0x18,%rsp
  8014b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014bc:	eb 0f                	jmp    8014cd <strncmp+0x25>
		n--, p++, q++;
  8014be:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d2:	74 1d                	je     8014f1 <strncmp+0x49>
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 12                	je     8014f1 <strncmp+0x49>
  8014df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e3:	0f b6 10             	movzbl (%rax),%edx
  8014e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	38 c2                	cmp    %al,%dl
  8014ef:	74 cd                	je     8014be <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f6:	75 07                	jne    8014ff <strncmp+0x57>
		return 0;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	eb 1a                	jmp    801519 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	0f b6 d0             	movzbl %al,%edx
  801509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	0f b6 c0             	movzbl %al,%eax
  801513:	89 d1                	mov    %edx,%ecx
  801515:	29 c1                	sub    %eax,%ecx
  801517:	89 c8                	mov    %ecx,%eax
}
  801519:	c9                   	leaveq 
  80151a:	c3                   	retq   

000000000080151b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151b:	55                   	push   %rbp
  80151c:	48 89 e5             	mov    %rsp,%rbp
  80151f:	48 83 ec 10          	sub    $0x10,%rsp
  801523:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801527:	89 f0                	mov    %esi,%eax
  801529:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80152c:	eb 17                	jmp    801545 <strchr+0x2a>
		if (*s == c)
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801538:	75 06                	jne    801540 <strchr+0x25>
			return (char *) s;
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	eb 15                	jmp    801555 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801540:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	84 c0                	test   %al,%al
  80154e:	75 de                	jne    80152e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801555:	c9                   	leaveq 
  801556:	c3                   	retq   

0000000000801557 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801557:	55                   	push   %rbp
  801558:	48 89 e5             	mov    %rsp,%rbp
  80155b:	48 83 ec 10          	sub    $0x10,%rsp
  80155f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801563:	89 f0                	mov    %esi,%eax
  801565:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801568:	eb 11                	jmp    80157b <strfind+0x24>
		if (*s == c)
  80156a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801574:	74 12                	je     801588 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801576:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	84 c0                	test   %al,%al
  801584:	75 e4                	jne    80156a <strfind+0x13>
  801586:	eb 01                	jmp    801589 <strfind+0x32>
		if (*s == c)
			break;
  801588:	90                   	nop
	return (char *) s;
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158d:	c9                   	leaveq 
  80158e:	c3                   	retq   

000000000080158f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80158f:	55                   	push   %rbp
  801590:	48 89 e5             	mov    %rsp,%rbp
  801593:	48 83 ec 18          	sub    $0x18,%rsp
  801597:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80159e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a7:	75 06                	jne    8015af <memset+0x20>
		return v;
  8015a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ad:	eb 69                	jmp    801618 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	83 e0 03             	and    $0x3,%eax
  8015b6:	48 85 c0             	test   %rax,%rax
  8015b9:	75 48                	jne    801603 <memset+0x74>
  8015bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bf:	83 e0 03             	and    $0x3,%eax
  8015c2:	48 85 c0             	test   %rax,%rax
  8015c5:	75 3c                	jne    801603 <memset+0x74>
		c &= 0xFF;
  8015c7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	c1 e2 18             	shl    $0x18,%edx
  8015d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d9:	c1 e0 10             	shl    $0x10,%eax
  8015dc:	09 c2                	or     %eax,%edx
  8015de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e1:	c1 e0 08             	shl    $0x8,%eax
  8015e4:	09 d0                	or     %edx,%eax
  8015e6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ed:	48 89 c1             	mov    %rax,%rcx
  8015f0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fb:	48 89 d7             	mov    %rdx,%rdi
  8015fe:	fc                   	cld    
  8015ff:	f3 ab                	rep stos %eax,%es:(%rdi)
  801601:	eb 11                	jmp    801614 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801603:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801607:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80160e:	48 89 d7             	mov    %rdx,%rdi
  801611:	fc                   	cld    
  801612:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801618:	c9                   	leaveq 
  801619:	c3                   	retq   

000000000080161a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80161a:	55                   	push   %rbp
  80161b:	48 89 e5             	mov    %rsp,%rbp
  80161e:	48 83 ec 28          	sub    $0x28,%rsp
  801622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801626:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80162e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80163e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801642:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801646:	0f 83 88 00 00 00    	jae    8016d4 <memmove+0xba>
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801654:	48 01 d0             	add    %rdx,%rax
  801657:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165b:	76 77                	jbe    8016d4 <memmove+0xba>
		s += n;
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80166d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801671:	83 e0 03             	and    $0x3,%eax
  801674:	48 85 c0             	test   %rax,%rax
  801677:	75 3b                	jne    8016b4 <memmove+0x9a>
  801679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167d:	83 e0 03             	and    $0x3,%eax
  801680:	48 85 c0             	test   %rax,%rax
  801683:	75 2f                	jne    8016b4 <memmove+0x9a>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	83 e0 03             	and    $0x3,%eax
  80168c:	48 85 c0             	test   %rax,%rax
  80168f:	75 23                	jne    8016b4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801695:	48 83 e8 04          	sub    $0x4,%rax
  801699:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169d:	48 83 ea 04          	sub    $0x4,%rdx
  8016a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016a5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016a9:	48 89 c7             	mov    %rax,%rdi
  8016ac:	48 89 d6             	mov    %rdx,%rsi
  8016af:	fd                   	std    
  8016b0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016b2:	eb 1d                	jmp    8016d1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	48 89 d7             	mov    %rdx,%rdi
  8016cb:	48 89 c1             	mov    %rax,%rcx
  8016ce:	fd                   	std    
  8016cf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016d1:	fc                   	cld    
  8016d2:	eb 57                	jmp    80172b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d8:	83 e0 03             	and    $0x3,%eax
  8016db:	48 85 c0             	test   %rax,%rax
  8016de:	75 36                	jne    801716 <memmove+0xfc>
  8016e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e4:	83 e0 03             	and    $0x3,%eax
  8016e7:	48 85 c0             	test   %rax,%rax
  8016ea:	75 2a                	jne    801716 <memmove+0xfc>
  8016ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f0:	83 e0 03             	and    $0x3,%eax
  8016f3:	48 85 c0             	test   %rax,%rax
  8016f6:	75 1e                	jne    801716 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	48 89 c1             	mov    %rax,%rcx
  8016ff:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801707:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170b:	48 89 c7             	mov    %rax,%rdi
  80170e:	48 89 d6             	mov    %rdx,%rsi
  801711:	fc                   	cld    
  801712:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801714:	eb 15                	jmp    80172b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801722:	48 89 c7             	mov    %rax,%rdi
  801725:	48 89 d6             	mov    %rdx,%rsi
  801728:	fc                   	cld    
  801729:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80172b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80172f:	c9                   	leaveq 
  801730:	c3                   	retq   

0000000000801731 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801731:	55                   	push   %rbp
  801732:	48 89 e5             	mov    %rsp,%rbp
  801735:	48 83 ec 18          	sub    $0x18,%rsp
  801739:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801741:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801749:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80174d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801751:	48 89 ce             	mov    %rcx,%rsi
  801754:	48 89 c7             	mov    %rax,%rdi
  801757:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  80175e:	00 00 00 
  801761:	ff d0                	callq  *%rax
}
  801763:	c9                   	leaveq 
  801764:	c3                   	retq   

0000000000801765 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801765:	55                   	push   %rbp
  801766:	48 89 e5             	mov    %rsp,%rbp
  801769:	48 83 ec 28          	sub    $0x28,%rsp
  80176d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801771:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801775:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801781:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801785:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801789:	eb 38                	jmp    8017c3 <memcmp+0x5e>
		if (*s1 != *s2)
  80178b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178f:	0f b6 10             	movzbl (%rax),%edx
  801792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	38 c2                	cmp    %al,%dl
  80179b:	74 1c                	je     8017b9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80179d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	0f b6 d0             	movzbl %al,%edx
  8017a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ab:	0f b6 00             	movzbl (%rax),%eax
  8017ae:	0f b6 c0             	movzbl %al,%eax
  8017b1:	89 d1                	mov    %edx,%ecx
  8017b3:	29 c1                	sub    %eax,%ecx
  8017b5:	89 c8                	mov    %ecx,%eax
  8017b7:	eb 20                	jmp    8017d9 <memcmp+0x74>
		s1++, s2++;
  8017b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017c8:	0f 95 c0             	setne  %al
  8017cb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017d0:	84 c0                	test   %al,%al
  8017d2:	75 b7                	jne    80178b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leaveq 
  8017da:	c3                   	retq   

00000000008017db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017db:	55                   	push   %rbp
  8017dc:	48 89 e5             	mov    %rsp,%rbp
  8017df:	48 83 ec 28          	sub    $0x28,%rsp
  8017e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f6:	48 01 d0             	add    %rdx,%rax
  8017f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017fd:	eb 13                	jmp    801812 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801803:	0f b6 10             	movzbl (%rax),%edx
  801806:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801809:	38 c2                	cmp    %al,%dl
  80180b:	74 11                	je     80181e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801816:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80181a:	72 e3                	jb     8017ff <memfind+0x24>
  80181c:	eb 01                	jmp    80181f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80181e:	90                   	nop
	return (void *) s;
  80181f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801823:	c9                   	leaveq 
  801824:	c3                   	retq   

0000000000801825 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	48 83 ec 38          	sub    $0x38,%rsp
  80182d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801831:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801835:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801838:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801846:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801847:	eb 05                	jmp    80184e <strtol+0x29>
		s++;
  801849:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801852:	0f b6 00             	movzbl (%rax),%eax
  801855:	3c 20                	cmp    $0x20,%al
  801857:	74 f0                	je     801849 <strtol+0x24>
  801859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185d:	0f b6 00             	movzbl (%rax),%eax
  801860:	3c 09                	cmp    $0x9,%al
  801862:	74 e5                	je     801849 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801864:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801868:	0f b6 00             	movzbl (%rax),%eax
  80186b:	3c 2b                	cmp    $0x2b,%al
  80186d:	75 07                	jne    801876 <strtol+0x51>
		s++;
  80186f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801874:	eb 17                	jmp    80188d <strtol+0x68>
	else if (*s == '-')
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	3c 2d                	cmp    $0x2d,%al
  80187f:	75 0c                	jne    80188d <strtol+0x68>
		s++, neg = 1;
  801881:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801886:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801891:	74 06                	je     801899 <strtol+0x74>
  801893:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801897:	75 28                	jne    8018c1 <strtol+0x9c>
  801899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189d:	0f b6 00             	movzbl (%rax),%eax
  8018a0:	3c 30                	cmp    $0x30,%al
  8018a2:	75 1d                	jne    8018c1 <strtol+0x9c>
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	48 83 c0 01          	add    $0x1,%rax
  8018ac:	0f b6 00             	movzbl (%rax),%eax
  8018af:	3c 78                	cmp    $0x78,%al
  8018b1:	75 0e                	jne    8018c1 <strtol+0x9c>
		s += 2, base = 16;
  8018b3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018bf:	eb 2c                	jmp    8018ed <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c5:	75 19                	jne    8018e0 <strtol+0xbb>
  8018c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cb:	0f b6 00             	movzbl (%rax),%eax
  8018ce:	3c 30                	cmp    $0x30,%al
  8018d0:	75 0e                	jne    8018e0 <strtol+0xbb>
		s++, base = 8;
  8018d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018de:	eb 0d                	jmp    8018ed <strtol+0xc8>
	else if (base == 0)
  8018e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e4:	75 07                	jne    8018ed <strtol+0xc8>
		base = 10;
  8018e6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f1:	0f b6 00             	movzbl (%rax),%eax
  8018f4:	3c 2f                	cmp    $0x2f,%al
  8018f6:	7e 1d                	jle    801915 <strtol+0xf0>
  8018f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fc:	0f b6 00             	movzbl (%rax),%eax
  8018ff:	3c 39                	cmp    $0x39,%al
  801901:	7f 12                	jg     801915 <strtol+0xf0>
			dig = *s - '0';
  801903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801907:	0f b6 00             	movzbl (%rax),%eax
  80190a:	0f be c0             	movsbl %al,%eax
  80190d:	83 e8 30             	sub    $0x30,%eax
  801910:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801913:	eb 4e                	jmp    801963 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801919:	0f b6 00             	movzbl (%rax),%eax
  80191c:	3c 60                	cmp    $0x60,%al
  80191e:	7e 1d                	jle    80193d <strtol+0x118>
  801920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801924:	0f b6 00             	movzbl (%rax),%eax
  801927:	3c 7a                	cmp    $0x7a,%al
  801929:	7f 12                	jg     80193d <strtol+0x118>
			dig = *s - 'a' + 10;
  80192b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192f:	0f b6 00             	movzbl (%rax),%eax
  801932:	0f be c0             	movsbl %al,%eax
  801935:	83 e8 57             	sub    $0x57,%eax
  801938:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80193b:	eb 26                	jmp    801963 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801941:	0f b6 00             	movzbl (%rax),%eax
  801944:	3c 40                	cmp    $0x40,%al
  801946:	7e 47                	jle    80198f <strtol+0x16a>
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	0f b6 00             	movzbl (%rax),%eax
  80194f:	3c 5a                	cmp    $0x5a,%al
  801951:	7f 3c                	jg     80198f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801957:	0f b6 00             	movzbl (%rax),%eax
  80195a:	0f be c0             	movsbl %al,%eax
  80195d:	83 e8 37             	sub    $0x37,%eax
  801960:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801963:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801966:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801969:	7d 23                	jge    80198e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80196b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801970:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801973:	48 98                	cltq   
  801975:	48 89 c2             	mov    %rax,%rdx
  801978:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80197d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801980:	48 98                	cltq   
  801982:	48 01 d0             	add    %rdx,%rax
  801985:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801989:	e9 5f ff ff ff       	jmpq   8018ed <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80198e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80198f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801994:	74 0b                	je     8019a1 <strtol+0x17c>
		*endptr = (char *) s;
  801996:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a5:	74 09                	je     8019b0 <strtol+0x18b>
  8019a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ab:	48 f7 d8             	neg    %rax
  8019ae:	eb 04                	jmp    8019b4 <strtol+0x18f>
  8019b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b4:	c9                   	leaveq 
  8019b5:	c3                   	retq   

00000000008019b6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 83 ec 30          	sub    $0x30,%rsp
  8019be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ca:	0f b6 00             	movzbl (%rax),%eax
  8019cd:	88 45 ff             	mov    %al,-0x1(%rbp)
  8019d0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8019d5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019d9:	75 06                	jne    8019e1 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8019db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019df:	eb 68                	jmp    801a49 <strstr+0x93>

	len = strlen(str);
  8019e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e5:	48 89 c7             	mov    %rax,%rdi
  8019e8:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
  8019f4:	48 98                	cltq   
  8019f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	0f b6 00             	movzbl (%rax),%eax
  801a01:	88 45 ef             	mov    %al,-0x11(%rbp)
  801a04:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801a09:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a0d:	75 07                	jne    801a16 <strstr+0x60>
				return (char *) 0;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a14:	eb 33                	jmp    801a49 <strstr+0x93>
		} while (sc != c);
  801a16:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a1a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a1d:	75 db                	jne    8019fa <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801a1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a23:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2b:	48 89 ce             	mov    %rcx,%rsi
  801a2e:	48 89 c7             	mov    %rax,%rdi
  801a31:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	callq  *%rax
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	75 b9                	jne    8019fa <strstr+0x44>

	return (char *) (in - 1);
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 83 e8 01          	sub    $0x1,%rax
}
  801a49:	c9                   	leaveq 
  801a4a:	c3                   	retq   
	...

0000000000801a4c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a4c:	55                   	push   %rbp
  801a4d:	48 89 e5             	mov    %rsp,%rbp
  801a50:	53                   	push   %rbx
  801a51:	48 83 ec 58          	sub    $0x58,%rsp
  801a55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a58:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a5b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a5f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a63:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a67:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a6e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801a71:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a75:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a79:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a7d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a81:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a85:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801a88:	4c 89 c3             	mov    %r8,%rbx
  801a8b:	cd 30                	int    $0x30
  801a8d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801a91:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a99:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a9d:	74 3e                	je     801add <syscall+0x91>
  801a9f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aa4:	7e 37                	jle    801add <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801aa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801aaa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801aad:	49 89 d0             	mov    %rdx,%r8
  801ab0:	89 c1                	mov    %eax,%ecx
  801ab2:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  801ab9:	00 00 00 
  801abc:	be 23 00 00 00       	mov    $0x23,%esi
  801ac1:	48 bf 45 4d 80 00 00 	movabs $0x804d45,%rdi
  801ac8:	00 00 00 
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	49 b9 ec 04 80 00 00 	movabs $0x8004ec,%r9
  801ad7:	00 00 00 
  801ada:	41 ff d1             	callq  *%r9

	return ret;
  801add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ae1:	48 83 c4 58          	add    $0x58,%rsp
  801ae5:	5b                   	pop    %rbx
  801ae6:	5d                   	pop    %rbp
  801ae7:	c3                   	retq   

0000000000801ae8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ae8:	55                   	push   %rbp
  801ae9:	48 89 e5             	mov    %rsp,%rbp
  801aec:	48 83 ec 20          	sub    $0x20,%rsp
  801af0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801af4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801af8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	48 89 d1             	mov    %rdx,%rcx
  801b17:	48 89 c2             	mov    %rax,%rdx
  801b1a:	be 00 00 00 00       	mov    $0x0,%esi
  801b1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b24:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	callq  *%rax
}
  801b30:	c9                   	leaveq 
  801b31:	c3                   	retq   

0000000000801b32 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b32:	55                   	push   %rbp
  801b33:	48 89 e5             	mov    %rsp,%rbp
  801b36:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b41:	00 
  801b42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b53:	ba 00 00 00 00       	mov    $0x0,%edx
  801b58:	be 00 00 00 00       	mov    $0x0,%esi
  801b5d:	bf 01 00 00 00       	mov    $0x1,%edi
  801b62:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801b69:	00 00 00 
  801b6c:	ff d0                	callq  *%rax
}
  801b6e:	c9                   	leaveq 
  801b6f:	c3                   	retq   

0000000000801b70 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b70:	55                   	push   %rbp
  801b71:	48 89 e5             	mov    %rsp,%rbp
  801b74:	48 83 ec 20          	sub    $0x20,%rsp
  801b78:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7e:	48 98                	cltq   
  801b80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b87:	00 
  801b88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b99:	48 89 c2             	mov    %rax,%rdx
  801b9c:	be 01 00 00 00       	mov    $0x1,%esi
  801ba1:	bf 03 00 00 00       	mov    $0x3,%edi
  801ba6:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	callq  *%rax
}
  801bb2:	c9                   	leaveq 
  801bb3:	c3                   	retq   

0000000000801bb4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801bb4:	55                   	push   %rbp
  801bb5:	48 89 e5             	mov    %rsp,%rbp
  801bb8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801bbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc3:	00 
  801bc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bda:	be 00 00 00 00       	mov    $0x0,%esi
  801bdf:	bf 02 00 00 00       	mov    $0x2,%edi
  801be4:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801beb:	00 00 00 
  801bee:	ff d0                	callq  *%rax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <sys_yield>:

void
sys_yield(void)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801bfa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c01:	00 
  801c02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c13:	ba 00 00 00 00       	mov    $0x0,%edx
  801c18:	be 00 00 00 00       	mov    $0x0,%esi
  801c1d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c22:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	callq  *%rax
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	48 83 ec 20          	sub    $0x20,%rsp
  801c38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c3f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c45:	48 63 c8             	movslq %eax,%rcx
  801c48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4f:	48 98                	cltq   
  801c51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c58:	00 
  801c59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5f:	49 89 c8             	mov    %rcx,%r8
  801c62:	48 89 d1             	mov    %rdx,%rcx
  801c65:	48 89 c2             	mov    %rax,%rdx
  801c68:	be 01 00 00 00       	mov    $0x1,%esi
  801c6d:	bf 04 00 00 00       	mov    $0x4,%edi
  801c72:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	callq  *%rax
}
  801c7e:	c9                   	leaveq 
  801c7f:	c3                   	retq   

0000000000801c80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 30          	sub    $0x30,%rsp
  801c88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c8f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c92:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c96:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c9d:	48 63 c8             	movslq %eax,%rcx
  801ca0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ca4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca7:	48 63 f0             	movslq %eax,%rsi
  801caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb1:	48 98                	cltq   
  801cb3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cb7:	49 89 f9             	mov    %rdi,%r9
  801cba:	49 89 f0             	mov    %rsi,%r8
  801cbd:	48 89 d1             	mov    %rdx,%rcx
  801cc0:	48 89 c2             	mov    %rax,%rdx
  801cc3:	be 01 00 00 00       	mov    $0x1,%esi
  801cc8:	bf 05 00 00 00       	mov    $0x5,%edi
  801ccd:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
}
  801cd9:	c9                   	leaveq 
  801cda:	c3                   	retq   

0000000000801cdb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cdb:	55                   	push   %rbp
  801cdc:	48 89 e5             	mov    %rsp,%rbp
  801cdf:	48 83 ec 20          	sub    $0x20,%rsp
  801ce3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf1:	48 98                	cltq   
  801cf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfa:	00 
  801cfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d07:	48 89 d1             	mov    %rdx,%rcx
  801d0a:	48 89 c2             	mov    %rax,%rdx
  801d0d:	be 01 00 00 00       	mov    $0x1,%esi
  801d12:	bf 06 00 00 00       	mov    $0x6,%edi
  801d17:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801d1e:	00 00 00 
  801d21:	ff d0                	callq  *%rax
}
  801d23:	c9                   	leaveq 
  801d24:	c3                   	retq   

0000000000801d25 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d25:	55                   	push   %rbp
  801d26:	48 89 e5             	mov    %rsp,%rbp
  801d29:	48 83 ec 20          	sub    $0x20,%rsp
  801d2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d30:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d36:	48 63 d0             	movslq %eax,%rdx
  801d39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3c:	48 98                	cltq   
  801d3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d45:	00 
  801d46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d52:	48 89 d1             	mov    %rdx,%rcx
  801d55:	48 89 c2             	mov    %rax,%rdx
  801d58:	be 01 00 00 00       	mov    $0x1,%esi
  801d5d:	bf 08 00 00 00       	mov    $0x8,%edi
  801d62:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	callq  *%rax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 20          	sub    $0x20,%rsp
  801d78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d86:	48 98                	cltq   
  801d88:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d8f:	00 
  801d90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9c:	48 89 d1             	mov    %rdx,%rcx
  801d9f:	48 89 c2             	mov    %rax,%rdx
  801da2:	be 01 00 00 00       	mov    $0x1,%esi
  801da7:	bf 09 00 00 00       	mov    $0x9,%edi
  801dac:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801db3:	00 00 00 
  801db6:	ff d0                	callq  *%rax
}
  801db8:	c9                   	leaveq 
  801db9:	c3                   	retq   

0000000000801dba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 20          	sub    $0x20,%rsp
  801dc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801dc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	48 98                	cltq   
  801dd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd9:	00 
  801dda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de6:	48 89 d1             	mov    %rdx,%rcx
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	be 01 00 00 00       	mov    $0x1,%esi
  801df1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801df6:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
}
  801e02:	c9                   	leaveq 
  801e03:	c3                   	retq   

0000000000801e04 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e04:	55                   	push   %rbp
  801e05:	48 89 e5             	mov    %rsp,%rbp
  801e08:	48 83 ec 30          	sub    $0x30,%rsp
  801e0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e13:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e17:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1d:	48 63 f0             	movslq %eax,%rsi
  801e20:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e27:	48 98                	cltq   
  801e29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e34:	00 
  801e35:	49 89 f1             	mov    %rsi,%r9
  801e38:	49 89 c8             	mov    %rcx,%r8
  801e3b:	48 89 d1             	mov    %rdx,%rcx
  801e3e:	48 89 c2             	mov    %rax,%rdx
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
  801e46:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e4b:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	callq  *%rax
}
  801e57:	c9                   	leaveq 
  801e58:	c3                   	retq   

0000000000801e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e59:	55                   	push   %rbp
  801e5a:	48 89 e5             	mov    %rsp,%rbp
  801e5d:	48 83 ec 20          	sub    $0x20,%rsp
  801e61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e70:	00 
  801e71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e82:	48 89 c2             	mov    %rax,%rdx
  801e85:	be 01 00 00 00       	mov    $0x1,%esi
  801e8a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e8f:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax
}
  801e9b:	c9                   	leaveq 
  801e9c:	c3                   	retq   

0000000000801e9d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e9d:	55                   	push   %rbp
  801e9e:	48 89 e5             	mov    %rsp,%rbp
  801ea1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ea5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eac:	00 
  801ead:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec3:	be 00 00 00 00       	mov    $0x0,%esi
  801ec8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ecd:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
}
  801ed9:	c9                   	leaveq 
  801eda:	c3                   	retq   

0000000000801edb <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801edb:	55                   	push   %rbp
  801edc:	48 89 e5             	mov    %rsp,%rbp
  801edf:	48 83 ec 30          	sub    $0x30,%rsp
  801ee3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eea:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801eed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ef1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801ef5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ef8:	48 63 c8             	movslq %eax,%rcx
  801efb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801eff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f02:	48 63 f0             	movslq %eax,%rsi
  801f05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0c:	48 98                	cltq   
  801f0e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f12:	49 89 f9             	mov    %rdi,%r9
  801f15:	49 89 f0             	mov    %rsi,%r8
  801f18:	48 89 d1             	mov    %rdx,%rcx
  801f1b:	48 89 c2             	mov    %rax,%rdx
  801f1e:	be 00 00 00 00       	mov    $0x0,%esi
  801f23:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f28:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801f34:	c9                   	leaveq 
  801f35:	c3                   	retq   

0000000000801f36 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801f36:	55                   	push   %rbp
  801f37:	48 89 e5             	mov    %rsp,%rbp
  801f3a:	48 83 ec 20          	sub    $0x20,%rsp
  801f3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801f46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f55:	00 
  801f56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f62:	48 89 d1             	mov    %rdx,%rcx
  801f65:	48 89 c2             	mov    %rax,%rdx
  801f68:	be 00 00 00 00       	mov    $0x0,%esi
  801f6d:	bf 10 00 00 00       	mov    $0x10,%edi
  801f72:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	callq  *%rax
}
  801f7e:	c9                   	leaveq 
  801f7f:	c3                   	retq   

0000000000801f80 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f80:	55                   	push   %rbp
  801f81:	48 89 e5             	mov    %rsp,%rbp
  801f84:	48 83 ec 40          	sub    $0x40,%rsp
  801f88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f8c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f90:	48 8b 00             	mov    (%rax),%rax
  801f93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f9b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa6:	48 89 c2             	mov    %rax,%rdx
  801fa9:	48 c1 ea 0c          	shr    $0xc,%rdx
  801fad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb4:	01 00 00 
  801fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801fbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fc2:	83 e0 02             	and    $0x2,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	0f 84 4f 01 00 00    	je     80211c <pgfault+0x19c>
  801fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd1:	48 89 c2             	mov    %rax,%rdx
  801fd4:	48 c1 ea 0c          	shr    $0xc,%rdx
  801fd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fdf:	01 00 00 
  801fe2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe6:	25 00 08 00 00       	and    $0x800,%eax
  801feb:	48 85 c0             	test   %rax,%rax
  801fee:	0f 84 28 01 00 00    	je     80211c <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801ff4:	ba 07 00 00 00       	mov    $0x7,%edx
  801ff9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  802003:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
  80200f:	85 c0                	test   %eax,%eax
  802011:	0f 85 db 00 00 00    	jne    8020f2 <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  802017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80201f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802023:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802029:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  80202d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802031:	ba 00 10 00 00       	mov    $0x1000,%edx
  802036:	48 89 c6             	mov    %rax,%rsi
  802039:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80203e:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  80204a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802054:	48 89 c1             	mov    %rax,%rcx
  802057:	ba 00 00 00 00       	mov    $0x0,%edx
  80205c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802061:	bf 00 00 00 00       	mov    $0x0,%edi
  802066:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
  802072:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  802075:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802079:	79 2a                	jns    8020a5 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  80207b:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  802082:	00 00 00 
  802085:	be 28 00 00 00       	mov    $0x28,%esi
  80208a:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802091:	00 00 00 
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
  802099:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  8020a0:	00 00 00 
  8020a3:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  8020a5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8020af:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  8020b6:	00 00 00 
  8020b9:	ff d0                	callq  *%rax
  8020bb:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  8020be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8020c2:	0f 89 84 00 00 00    	jns    80214c <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  8020c8:	48 ba 90 4d 80 00 00 	movabs $0x804d90,%rdx
  8020cf:	00 00 00 
  8020d2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8020d7:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8020de:	00 00 00 
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  8020ed:	00 00 00 
  8020f0:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  8020f2:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  8020f9:	00 00 00 
  8020fc:	be 31 00 00 00       	mov    $0x31,%esi
  802101:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802108:	00 00 00 
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  802117:	00 00 00 
  80211a:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  80211c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	48 ba ea 4d 80 00 00 	movabs $0x804dea,%rdx
  802128:	00 00 00 
  80212b:	be 35 00 00 00       	mov    $0x35,%esi
  802130:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802137:	00 00 00 
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  802146:	00 00 00 
  802149:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  80214c:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  80214d:	c9                   	leaveq 
  80214e:	c3                   	retq   

000000000080214f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80214f:	55                   	push   %rbp
  802150:	48 89 e5             	mov    %rsp,%rbp
  802153:	48 83 ec 30          	sub    $0x30,%rsp
  802157:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80215a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  80215d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802164:	01 00 00 
  802167:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80216a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80216e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  802172:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802175:	48 c1 e0 0c          	shl    $0xc,%rax
  802179:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  80217d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802181:	25 07 0e 00 00       	and    $0xe07,%eax
  802186:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  802189:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80218c:	25 00 04 00 00       	and    $0x400,%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	74 62                	je     8021f7 <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  802195:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802198:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80219c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80219f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a3:	41 89 f0             	mov    %esi,%r8d
  8021a6:	48 89 c6             	mov    %rax,%rsi
  8021a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ae:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8021bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021c1:	0f 89 78 01 00 00    	jns    80233f <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8021c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021ca:	89 c1                	mov    %eax,%ecx
  8021cc:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  8021d3:	00 00 00 
  8021d6:	be 4f 00 00 00       	mov    $0x4f,%esi
  8021db:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8021e2:	00 00 00 
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  8021f1:	00 00 00 
  8021f4:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  8021f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021fa:	25 00 08 00 00       	and    $0x800,%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	75 0e                	jne    802211 <duppage+0xc2>
  802203:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802206:	83 e0 02             	and    $0x2,%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	0f 84 d0 00 00 00    	je     8022e1 <duppage+0x192>
		perm &= ~PTE_W;
  802211:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  802215:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  80221c:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80221f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802223:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222a:	41 89 f0             	mov    %esi,%r8d
  80222d:	48 89 c6             	mov    %rax,%rsi
  802230:	bf 00 00 00 00       	mov    $0x0,%edi
  802235:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax
  802241:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802244:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802248:	79 30                	jns    80227a <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  80224a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80224d:	89 c1                	mov    %eax,%ecx
  80224f:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  802256:	00 00 00 
  802259:	be 57 00 00 00       	mov    $0x57,%esi
  80225e:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802265:	00 00 00 
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
  80226d:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  802274:	00 00 00 
  802277:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  80227a:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80227d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802285:	41 89 c8             	mov    %ecx,%r8d
  802288:	48 89 d1             	mov    %rdx,%rcx
  80228b:	ba 00 00 00 00       	mov    $0x0,%edx
  802290:	48 89 c6             	mov    %rax,%rsi
  802293:	bf 00 00 00 00       	mov    $0x0,%edi
  802298:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  80229f:	00 00 00 
  8022a2:	ff d0                	callq  *%rax
  8022a4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8022a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8022ab:	0f 89 8e 00 00 00    	jns    80233f <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8022b1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022b4:	89 c1                	mov    %eax,%ecx
  8022b6:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  8022bd:	00 00 00 
  8022c0:	be 5b 00 00 00       	mov    $0x5b,%esi
  8022c5:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8022cc:	00 00 00 
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  8022db:	00 00 00 
  8022de:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  8022e1:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8022e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8022e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ef:	41 89 f0             	mov    %esi,%r8d
  8022f2:	48 89 c6             	mov    %rax,%rsi
  8022f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fa:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802309:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80230d:	79 30                	jns    80233f <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80230f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802312:	89 c1                	mov    %eax,%ecx
  802314:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  80231b:	00 00 00 
  80231e:	be 61 00 00 00       	mov    $0x61,%esi
  802323:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  80232a:	00 00 00 
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
  802332:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  802339:	00 00 00 
  80233c:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802344:	c9                   	leaveq 
  802345:	c3                   	retq   

0000000000802346 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802346:	55                   	push   %rbp
  802347:	48 89 e5             	mov    %rsp,%rbp
  80234a:	53                   	push   %rbx
  80234b:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  80234f:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  802356:	48 bf 80 1f 80 00 00 	movabs $0x801f80,%rdi
  80235d:	00 00 00 
  802360:	48 b8 94 43 80 00 00 	movabs $0x804394,%rax
  802367:	00 00 00 
  80236a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80236c:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  802373:	8b 45 9c             	mov    -0x64(%rbp),%eax
  802376:	cd 30                	int    $0x30
  802378:	89 c3                	mov    %eax,%ebx
  80237a:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80237d:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802380:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  802383:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802387:	79 30                	jns    8023b9 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  802389:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80238c:	89 c1                	mov    %eax,%ecx
  80238e:	48 ba 2b 4e 80 00 00 	movabs $0x804e2b,%rdx
  802395:	00 00 00 
  802398:	be 80 00 00 00       	mov    $0x80,%esi
  80239d:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8023a4:	00 00 00 
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  8023b3:	00 00 00 
  8023b6:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  8023b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8023bd:	75 52                	jne    802411 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  8023bf:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
  8023cb:	48 98                	cltq   
  8023cd:	48 89 c2             	mov    %rax,%rdx
  8023d0:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8023d6:	48 89 d0             	mov    %rdx,%rax
  8023d9:	48 c1 e0 02          	shl    $0x2,%rax
  8023dd:	48 01 d0             	add    %rdx,%rax
  8023e0:	48 01 c0             	add    %rax,%rax
  8023e3:	48 01 d0             	add    %rdx,%rax
  8023e6:	48 c1 e0 05          	shl    $0x5,%rax
  8023ea:	48 89 c2             	mov    %rax,%rdx
  8023ed:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023f4:	00 00 00 
  8023f7:	48 01 c2             	add    %rax,%rdx
  8023fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802401:	00 00 00 
  802404:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	e9 9d 02 00 00       	jmpq   8026ae <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  802411:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802414:	ba 07 00 00 00       	mov    $0x7,%edx
  802419:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80241e:	89 c7                	mov    %eax,%edi
  802420:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax
  80242c:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80242f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802433:	79 30                	jns    802465 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  802435:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802438:	89 c1                	mov    %eax,%ecx
  80243a:	48 ba 2b 4e 80 00 00 	movabs $0x804e2b,%rdx
  802441:	00 00 00 
  802444:	be 88 00 00 00       	mov    $0x88,%esi
  802449:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802450:	00 00 00 
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  80245f:	00 00 00 
  802462:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  802465:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80246c:	00 
	uint64_t each_pte = 0;
  80246d:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  802474:	00 
	uint64_t each_pdpe = 0;
  802475:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  80247c:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  80247d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802484:	00 
  802485:	e9 73 01 00 00       	jmpq   8025fd <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  80248a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802491:	01 00 00 
  802494:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802498:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249c:	83 e0 01             	and    $0x1,%eax
  80249f:	84 c0                	test   %al,%al
  8024a1:	0f 84 41 01 00 00    	je     8025e8 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8024a7:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8024ae:	00 
  8024af:	e9 24 01 00 00       	jmpq   8025d8 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  8024b4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024bb:	01 00 00 
  8024be:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8024c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c6:	83 e0 01             	and    $0x1,%eax
  8024c9:	84 c0                	test   %al,%al
  8024cb:	0f 84 ed 00 00 00    	je     8025be <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8024d1:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8024d8:	00 
  8024d9:	e9 d0 00 00 00       	jmpq   8025ae <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  8024de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e5:	01 00 00 
  8024e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f0:	83 e0 01             	and    $0x1,%eax
  8024f3:	84 c0                	test   %al,%al
  8024f5:	0f 84 99 00 00 00    	je     802594 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8024fb:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802502:	00 
  802503:	eb 7f                	jmp    802584 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802505:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80250c:	01 00 00 
  80250f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802513:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802517:	83 e0 01             	and    $0x1,%eax
  80251a:	84 c0                	test   %al,%al
  80251c:	74 5c                	je     80257a <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  80251e:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  802525:	00 
  802526:	74 52                	je     80257a <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802528:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802531:	89 d6                	mov    %edx,%esi
  802533:	89 c7                	mov    %eax,%edi
  802535:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  802544:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802548:	79 30                	jns    80257a <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  80254a:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	48 ba 2b 4e 80 00 00 	movabs $0x804e2b,%rdx
  802556:	00 00 00 
  802559:	be a0 00 00 00       	mov    $0xa0,%esi
  80255e:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802565:	00 00 00 
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
  80256d:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  802574:	00 00 00 
  802577:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80257a:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80257f:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  802584:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  80258b:	00 
  80258c:	0f 86 73 ff ff ff    	jbe    802505 <fork+0x1bf>
  802592:	eb 10                	jmp    8025a4 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  802594:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802598:	48 83 c0 01          	add    $0x1,%rax
  80259c:	48 c1 e0 09          	shl    $0x9,%rax
  8025a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8025a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8025a9:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8025ae:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8025b5:	00 
  8025b6:	0f 86 22 ff ff ff    	jbe    8024de <fork+0x198>
  8025bc:	eb 10                	jmp    8025ce <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8025be:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8025c2:	48 83 c0 01          	add    $0x1,%rax
  8025c6:	48 c1 e0 09          	shl    $0x9,%rax
  8025ca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8025ce:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8025d3:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  8025d8:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8025df:	00 
  8025e0:	0f 86 ce fe ff ff    	jbe    8024b4 <fork+0x16e>
  8025e6:	eb 10                	jmp    8025f8 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  8025e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ec:	48 83 c0 01          	add    $0x1,%rax
  8025f0:	48 c1 e0 09          	shl    $0x9,%rax
  8025f4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8025f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8025fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802602:	0f 84 82 fe ff ff    	je     80248a <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802608:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80260b:	48 be 2c 44 80 00 00 	movabs $0x80442c,%rsi
  802612:	00 00 00 
  802615:	89 c7                	mov    %eax,%edi
  802617:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  80261e:	00 00 00 
  802621:	ff d0                	callq  *%rax
  802623:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802626:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80262a:	79 30                	jns    80265c <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  80262c:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80262f:	89 c1                	mov    %eax,%ecx
  802631:	48 ba 2b 4e 80 00 00 	movabs $0x804e2b,%rdx
  802638:	00 00 00 
  80263b:	be bd 00 00 00       	mov    $0xbd,%esi
  802640:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802647:	00 00 00 
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax
  80264f:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  802656:	00 00 00 
  802659:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80265c:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80265f:	be 02 00 00 00       	mov    $0x2,%esi
  802664:	89 c7                	mov    %eax,%edi
  802666:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
  802672:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802675:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802679:	79 30                	jns    8026ab <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  80267b:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80267e:	89 c1                	mov    %eax,%ecx
  802680:	48 ba 2b 4e 80 00 00 	movabs $0x804e2b,%rdx
  802687:	00 00 00 
  80268a:	be c1 00 00 00       	mov    $0xc1,%esi
  80268f:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  802696:	00 00 00 
  802699:	b8 00 00 00 00       	mov    $0x0,%eax
  80269e:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  8026a5:	00 00 00 
  8026a8:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  8026ab:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  8026ae:	48 83 c4 68          	add    $0x68,%rsp
  8026b2:	5b                   	pop    %rbx
  8026b3:	5d                   	pop    %rbp
  8026b4:	c3                   	retq   

00000000008026b5 <sfork>:

// Challenge!
int
sfork(void)
{
  8026b5:	55                   	push   %rbp
  8026b6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8026b9:	48 ba 44 4e 80 00 00 	movabs $0x804e44,%rdx
  8026c0:	00 00 00 
  8026c3:	be cc 00 00 00       	mov    $0xcc,%esi
  8026c8:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8026cf:	00 00 00 
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  8026de:	00 00 00 
  8026e1:	ff d1                	callq  *%rcx
	...

00000000008026e4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026e4:	55                   	push   %rbp
  8026e5:	48 89 e5             	mov    %rsp,%rbp
  8026e8:	48 83 ec 08          	sub    $0x8,%rsp
  8026ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026f4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026fb:	ff ff ff 
  8026fe:	48 01 d0             	add    %rdx,%rax
  802701:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   

0000000000802707 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	48 83 ec 08          	sub    $0x8,%rsp
  80270f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802717:	48 89 c7             	mov    %rax,%rdi
  80271a:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
  802726:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80272c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 18          	sub    $0x18,%rsp
  80273a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80273e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802745:	eb 6b                	jmp    8027b2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274a:	48 98                	cltq   
  80274c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802752:	48 c1 e0 0c          	shl    $0xc,%rax
  802756:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80275a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275e:	48 89 c2             	mov    %rax,%rdx
  802761:	48 c1 ea 15          	shr    $0x15,%rdx
  802765:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80276c:	01 00 00 
  80276f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802773:	83 e0 01             	and    $0x1,%eax
  802776:	48 85 c0             	test   %rax,%rax
  802779:	74 21                	je     80279c <fd_alloc+0x6a>
  80277b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277f:	48 89 c2             	mov    %rax,%rdx
  802782:	48 c1 ea 0c          	shr    $0xc,%rdx
  802786:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80278d:	01 00 00 
  802790:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802794:	83 e0 01             	and    $0x1,%eax
  802797:	48 85 c0             	test   %rax,%rax
  80279a:	75 12                	jne    8027ae <fd_alloc+0x7c>
			*fd_store = fd;
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ac:	eb 1a                	jmp    8027c8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027b6:	7e 8f                	jle    802747 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027c3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027c8:	c9                   	leaveq 
  8027c9:	c3                   	retq   

00000000008027ca <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027ca:	55                   	push   %rbp
  8027cb:	48 89 e5             	mov    %rsp,%rbp
  8027ce:	48 83 ec 20          	sub    $0x20,%rsp
  8027d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027dd:	78 06                	js     8027e5 <fd_lookup+0x1b>
  8027df:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027e3:	7e 07                	jle    8027ec <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ea:	eb 6c                	jmp    802858 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ef:	48 98                	cltq   
  8027f1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027f7:	48 c1 e0 0c          	shl    $0xc,%rax
  8027fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802803:	48 89 c2             	mov    %rax,%rdx
  802806:	48 c1 ea 15          	shr    $0x15,%rdx
  80280a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802811:	01 00 00 
  802814:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802818:	83 e0 01             	and    $0x1,%eax
  80281b:	48 85 c0             	test   %rax,%rax
  80281e:	74 21                	je     802841 <fd_lookup+0x77>
  802820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802824:	48 89 c2             	mov    %rax,%rdx
  802827:	48 c1 ea 0c          	shr    $0xc,%rdx
  80282b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802832:	01 00 00 
  802835:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802839:	83 e0 01             	and    $0x1,%eax
  80283c:	48 85 c0             	test   %rax,%rax
  80283f:	75 07                	jne    802848 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802841:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802846:	eb 10                	jmp    802858 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802850:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802858:	c9                   	leaveq 
  802859:	c3                   	retq   

000000000080285a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80285a:	55                   	push   %rbp
  80285b:	48 89 e5             	mov    %rsp,%rbp
  80285e:	48 83 ec 30          	sub    $0x30,%rsp
  802862:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802866:	89 f0                	mov    %esi,%eax
  802868:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286f:	48 89 c7             	mov    %rax,%rdi
  802872:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802882:	48 89 d6             	mov    %rdx,%rsi
  802885:	89 c7                	mov    %eax,%edi
  802887:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax
  802893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289a:	78 0a                	js     8028a6 <fd_close+0x4c>
	    || fd != fd2)
  80289c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028a4:	74 12                	je     8028b8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8028a6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028aa:	74 05                	je     8028b1 <fd_close+0x57>
  8028ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028af:	eb 05                	jmp    8028b6 <fd_close+0x5c>
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b6:	eb 69                	jmp    802921 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bc:	8b 00                	mov    (%rax),%eax
  8028be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c2:	48 89 d6             	mov    %rdx,%rsi
  8028c5:	89 c7                	mov    %eax,%edi
  8028c7:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
  8028d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028da:	78 2a                	js     802906 <fd_close+0xac>
		if (dev->dev_close)
  8028dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028e4:	48 85 c0             	test   %rax,%rax
  8028e7:	74 16                	je     8028ff <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ed:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8028f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f5:	48 89 c7             	mov    %rax,%rdi
  8028f8:	ff d2                	callq  *%rdx
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	eb 07                	jmp    802906 <fd_close+0xac>
		else
			r = 0;
  8028ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80290a:	48 89 c6             	mov    %rax,%rsi
  80290d:	bf 00 00 00 00       	mov    $0x0,%edi
  802912:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
	return r;
  80291e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802921:	c9                   	leaveq 
  802922:	c3                   	retq   

0000000000802923 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802923:	55                   	push   %rbp
  802924:	48 89 e5             	mov    %rsp,%rbp
  802927:	48 83 ec 20          	sub    $0x20,%rsp
  80292b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80292e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802932:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802939:	eb 41                	jmp    80297c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80293b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802942:	00 00 00 
  802945:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802948:	48 63 d2             	movslq %edx,%rdx
  80294b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294f:	8b 00                	mov    (%rax),%eax
  802951:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802954:	75 22                	jne    802978 <dev_lookup+0x55>
			*dev = devtab[i];
  802956:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80295d:	00 00 00 
  802960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802963:	48 63 d2             	movslq %edx,%rdx
  802966:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80296a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	eb 60                	jmp    8029d8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802978:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80297c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802983:	00 00 00 
  802986:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802989:	48 63 d2             	movslq %edx,%rdx
  80298c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802990:	48 85 c0             	test   %rax,%rax
  802993:	75 a6                	jne    80293b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802995:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80299c:	00 00 00 
  80299f:	48 8b 00             	mov    (%rax),%rax
  8029a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029ab:	89 c6                	mov    %eax,%esi
  8029ad:	48 bf 60 4e 80 00 00 	movabs $0x804e60,%rdi
  8029b4:	00 00 00 
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  8029c3:	00 00 00 
  8029c6:	ff d1                	callq  *%rcx
	*dev = 0;
  8029c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029d8:	c9                   	leaveq 
  8029d9:	c3                   	retq   

00000000008029da <close>:

int
close(int fdnum)
{
  8029da:	55                   	push   %rbp
  8029db:	48 89 e5             	mov    %rsp,%rbp
  8029de:	48 83 ec 20          	sub    $0x20,%rsp
  8029e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ec:	48 89 d6             	mov    %rdx,%rsi
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a04:	79 05                	jns    802a0b <close+0x31>
		return r;
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a09:	eb 18                	jmp    802a23 <close+0x49>
	else
		return fd_close(fd, 1);
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	be 01 00 00 00       	mov    $0x1,%esi
  802a14:	48 89 c7             	mov    %rax,%rdi
  802a17:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
}
  802a23:	c9                   	leaveq 
  802a24:	c3                   	retq   

0000000000802a25 <close_all>:

void
close_all(void)
{
  802a25:	55                   	push   %rbp
  802a26:	48 89 e5             	mov    %rsp,%rbp
  802a29:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a34:	eb 15                	jmp    802a4b <close_all+0x26>
		close(i);
  802a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a47:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a4b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a4f:	7e e5                	jle    802a36 <close_all+0x11>
		close(i);
}
  802a51:	c9                   	leaveq 
  802a52:	c3                   	retq   

0000000000802a53 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a53:	55                   	push   %rbp
  802a54:	48 89 e5             	mov    %rsp,%rbp
  802a57:	48 83 ec 40          	sub    $0x40,%rsp
  802a5b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a5e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a61:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a65:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a68:	48 89 d6             	mov    %rdx,%rsi
  802a6b:	89 c7                	mov    %eax,%edi
  802a6d:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
  802a79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a80:	79 08                	jns    802a8a <dup+0x37>
		return r;
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a85:	e9 70 01 00 00       	jmpq   802bfa <dup+0x1a7>
	close(newfdnum);
  802a8a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a8d:	89 c7                	mov    %eax,%edi
  802a8f:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  802a96:	00 00 00 
  802a99:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a9b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a9e:	48 98                	cltq   
  802aa0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aa6:	48 c1 e0 0c          	shl    $0xc,%rax
  802aaa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ab2:	48 89 c7             	mov    %rax,%rdi
  802ab5:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ac5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac9:	48 89 c7             	mov    %rax,%rdi
  802acc:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae0:	48 89 c2             	mov    %rax,%rdx
  802ae3:	48 c1 ea 15          	shr    $0x15,%rdx
  802ae7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aee:	01 00 00 
  802af1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af5:	83 e0 01             	and    $0x1,%eax
  802af8:	84 c0                	test   %al,%al
  802afa:	74 71                	je     802b6d <dup+0x11a>
  802afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b00:	48 89 c2             	mov    %rax,%rdx
  802b03:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b0e:	01 00 00 
  802b11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b15:	83 e0 01             	and    $0x1,%eax
  802b18:	84 c0                	test   %al,%al
  802b1a:	74 51                	je     802b6d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b20:	48 89 c2             	mov    %rax,%rdx
  802b23:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b2e:	01 00 00 
  802b31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b35:	89 c1                	mov    %eax,%ecx
  802b37:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b3d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b45:	41 89 c8             	mov    %ecx,%r8d
  802b48:	48 89 d1             	mov    %rdx,%rcx
  802b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b50:	48 89 c6             	mov    %rax,%rsi
  802b53:	bf 00 00 00 00       	mov    $0x0,%edi
  802b58:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	78 56                	js     802bc3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b71:	48 89 c2             	mov    %rax,%rdx
  802b74:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b7f:	01 00 00 
  802b82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b86:	89 c1                	mov    %eax,%ecx
  802b88:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b96:	41 89 c8             	mov    %ecx,%r8d
  802b99:	48 89 d1             	mov    %rdx,%rcx
  802b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba1:	48 89 c6             	mov    %rax,%rsi
  802ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba9:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	78 08                	js     802bc6 <dup+0x173>
		goto err;

	return newfdnum;
  802bbe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bc1:	eb 37                	jmp    802bfa <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802bc3:	90                   	nop
  802bc4:	eb 01                	jmp    802bc7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802bc6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcb:	48 89 c6             	mov    %rax,%rsi
  802bce:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd3:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be3:	48 89 c6             	mov    %rax,%rsi
  802be6:	bf 00 00 00 00       	mov    $0x0,%edi
  802beb:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
	return r;
  802bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bfa:	c9                   	leaveq 
  802bfb:	c3                   	retq   

0000000000802bfc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bfc:	55                   	push   %rbp
  802bfd:	48 89 e5             	mov    %rsp,%rbp
  802c00:	48 83 ec 40          	sub    $0x40,%rsp
  802c04:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c16:	48 89 d6             	mov    %rdx,%rsi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2e:	78 24                	js     802c54 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	8b 00                	mov    (%rax),%eax
  802c36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3a:	48 89 d6             	mov    %rdx,%rsi
  802c3d:	89 c7                	mov    %eax,%edi
  802c3f:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c52:	79 05                	jns    802c59 <read+0x5d>
		return r;
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	eb 7a                	jmp    802cd3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5d:	8b 40 08             	mov    0x8(%rax),%eax
  802c60:	83 e0 03             	and    $0x3,%eax
  802c63:	83 f8 01             	cmp    $0x1,%eax
  802c66:	75 3a                	jne    802ca2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c6f:	00 00 00 
  802c72:	48 8b 00             	mov    (%rax),%rax
  802c75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c7e:	89 c6                	mov    %eax,%esi
  802c80:	48 bf 7f 4e 80 00 00 	movabs $0x804e7f,%rdi
  802c87:	00 00 00 
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  802c96:	00 00 00 
  802c99:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ca0:	eb 31                	jmp    802cd3 <read+0xd7>
	}
	if (!dev->dev_read)
  802ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802caa:	48 85 c0             	test   %rax,%rax
  802cad:	75 07                	jne    802cb6 <read+0xba>
		return -E_NOT_SUPP;
  802caf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb4:	eb 1d                	jmp    802cd3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cba:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802cbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cc6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cca:	48 89 ce             	mov    %rcx,%rsi
  802ccd:	48 89 c7             	mov    %rax,%rdi
  802cd0:	41 ff d0             	callq  *%r8
}
  802cd3:	c9                   	leaveq 
  802cd4:	c3                   	retq   

0000000000802cd5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cd5:	55                   	push   %rbp
  802cd6:	48 89 e5             	mov    %rsp,%rbp
  802cd9:	48 83 ec 30          	sub    $0x30,%rsp
  802cdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ce4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ce8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cef:	eb 46                	jmp    802d37 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf4:	48 98                	cltq   
  802cf6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cfa:	48 29 c2             	sub    %rax,%rdx
  802cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d00:	48 98                	cltq   
  802d02:	48 89 c1             	mov    %rax,%rcx
  802d05:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802d09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d0c:	48 89 ce             	mov    %rcx,%rsi
  802d0f:	89 c7                	mov    %eax,%edi
  802d11:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d20:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d24:	79 05                	jns    802d2b <readn+0x56>
			return m;
  802d26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d29:	eb 1d                	jmp    802d48 <readn+0x73>
		if (m == 0)
  802d2b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d2f:	74 13                	je     802d44 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d34:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3a:	48 98                	cltq   
  802d3c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d40:	72 af                	jb     802cf1 <readn+0x1c>
  802d42:	eb 01                	jmp    802d45 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d44:	90                   	nop
	}
	return tot;
  802d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d48:	c9                   	leaveq 
  802d49:	c3                   	retq   

0000000000802d4a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d4a:	55                   	push   %rbp
  802d4b:	48 89 e5             	mov    %rsp,%rbp
  802d4e:	48 83 ec 40          	sub    $0x40,%rsp
  802d52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d55:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d59:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d5d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d64:	48 89 d6             	mov    %rdx,%rsi
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7c:	78 24                	js     802da2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d82:	8b 00                	mov    (%rax),%eax
  802d84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d88:	48 89 d6             	mov    %rdx,%rsi
  802d8b:	89 c7                	mov    %eax,%edi
  802d8d:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da0:	79 05                	jns    802da7 <write+0x5d>
		return r;
  802da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da5:	eb 79                	jmp    802e20 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dab:	8b 40 08             	mov    0x8(%rax),%eax
  802dae:	83 e0 03             	and    $0x3,%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	75 3a                	jne    802def <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802db5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802dbc:	00 00 00 
  802dbf:	48 8b 00             	mov    (%rax),%rax
  802dc2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dc8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dcb:	89 c6                	mov    %eax,%esi
  802dcd:	48 bf 9b 4e 80 00 00 	movabs $0x804e9b,%rdi
  802dd4:	00 00 00 
  802dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddc:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  802de3:	00 00 00 
  802de6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802de8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ded:	eb 31                	jmp    802e20 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802df7:	48 85 c0             	test   %rax,%rax
  802dfa:	75 07                	jne    802e03 <write+0xb9>
		return -E_NOT_SUPP;
  802dfc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e01:	eb 1d                	jmp    802e20 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e07:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e13:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e17:	48 89 ce             	mov    %rcx,%rsi
  802e1a:	48 89 c7             	mov    %rax,%rdi
  802e1d:	41 ff d0             	callq  *%r8
}
  802e20:	c9                   	leaveq 
  802e21:	c3                   	retq   

0000000000802e22 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e22:	55                   	push   %rbp
  802e23:	48 89 e5             	mov    %rsp,%rbp
  802e26:	48 83 ec 18          	sub    $0x18,%rsp
  802e2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e2d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e37:	48 89 d6             	mov    %rdx,%rsi
  802e3a:	89 c7                	mov    %eax,%edi
  802e3c:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
  802e48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4f:	79 05                	jns    802e56 <seek+0x34>
		return r;
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e54:	eb 0f                	jmp    802e65 <seek+0x43>
	fd->fd_offset = offset;
  802e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e5d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e65:	c9                   	leaveq 
  802e66:	c3                   	retq   

0000000000802e67 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e67:	55                   	push   %rbp
  802e68:	48 89 e5             	mov    %rsp,%rbp
  802e6b:	48 83 ec 30          	sub    $0x30,%rsp
  802e6f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e72:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e75:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e7c:	48 89 d6             	mov    %rdx,%rsi
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
  802e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e94:	78 24                	js     802eba <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9a:	8b 00                	mov    (%rax),%eax
  802e9c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ea0:	48 89 d6             	mov    %rdx,%rsi
  802ea3:	89 c7                	mov    %eax,%edi
  802ea5:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
  802eb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb8:	79 05                	jns    802ebf <ftruncate+0x58>
		return r;
  802eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebd:	eb 72                	jmp    802f31 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	8b 40 08             	mov    0x8(%rax),%eax
  802ec6:	83 e0 03             	and    $0x3,%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	75 3a                	jne    802f07 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ecd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ed4:	00 00 00 
  802ed7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802eda:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ee0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ee3:	89 c6                	mov    %eax,%esi
  802ee5:	48 bf b8 4e 80 00 00 	movabs $0x804eb8,%rdi
  802eec:	00 00 00 
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	48 b9 27 07 80 00 00 	movabs $0x800727,%rcx
  802efb:	00 00 00 
  802efe:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f05:	eb 2a                	jmp    802f31 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f0f:	48 85 c0             	test   %rax,%rax
  802f12:	75 07                	jne    802f1b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f19:	eb 16                	jmp    802f31 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f27:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802f2a:	89 d6                	mov    %edx,%esi
  802f2c:	48 89 c7             	mov    %rax,%rdi
  802f2f:	ff d1                	callq  *%rcx
}
  802f31:	c9                   	leaveq 
  802f32:	c3                   	retq   

0000000000802f33 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f33:	55                   	push   %rbp
  802f34:	48 89 e5             	mov    %rsp,%rbp
  802f37:	48 83 ec 30          	sub    $0x30,%rsp
  802f3b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f3e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f46:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f49:	48 89 d6             	mov    %rdx,%rsi
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f61:	78 24                	js     802f87 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f67:	8b 00                	mov    (%rax),%eax
  802f69:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f6d:	48 89 d6             	mov    %rdx,%rsi
  802f70:	89 c7                	mov    %eax,%edi
  802f72:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	79 05                	jns    802f8c <fstat+0x59>
		return r;
  802f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8a:	eb 5e                	jmp    802fea <fstat+0xb7>
	if (!dev->dev_stat)
  802f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f90:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f94:	48 85 c0             	test   %rax,%rax
  802f97:	75 07                	jne    802fa0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f99:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f9e:	eb 4a                	jmp    802fea <fstat+0xb7>
	stat->st_name[0] = 0;
  802fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802fa7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fb2:	00 00 00 
	stat->st_isdir = 0;
  802fb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fc0:	00 00 00 
	stat->st_dev = dev;
  802fc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fcb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fde:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802fe2:	48 89 d6             	mov    %rdx,%rsi
  802fe5:	48 89 c7             	mov    %rax,%rdi
  802fe8:	ff d1                	callq  *%rcx
}
  802fea:	c9                   	leaveq 
  802feb:	c3                   	retq   

0000000000802fec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fec:	55                   	push   %rbp
  802fed:	48 89 e5             	mov    %rsp,%rbp
  802ff0:	48 83 ec 20          	sub    $0x20,%rsp
  802ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803000:	be 00 00 00 00       	mov    $0x0,%esi
  803005:	48 89 c7             	mov    %rax,%rdi
  803008:	48 b8 db 30 80 00 00 	movabs $0x8030db,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
  803014:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803017:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301b:	79 05                	jns    803022 <stat+0x36>
		return fd;
  80301d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803020:	eb 2f                	jmp    803051 <stat+0x65>
	r = fstat(fd, stat);
  803022:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803026:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803029:	48 89 d6             	mov    %rdx,%rsi
  80302c:	89 c7                	mov    %eax,%edi
  80302e:	48 b8 33 2f 80 00 00 	movabs $0x802f33,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
  80303a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	89 c7                	mov    %eax,%edi
  803042:	48 b8 da 29 80 00 00 	movabs $0x8029da,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
	return r;
  80304e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803051:	c9                   	leaveq 
  803052:	c3                   	retq   
	...

0000000000803054 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803054:	55                   	push   %rbp
  803055:	48 89 e5             	mov    %rsp,%rbp
  803058:	48 83 ec 10          	sub    $0x10,%rsp
  80305c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80305f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803063:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80306a:	00 00 00 
  80306d:	8b 00                	mov    (%rax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	75 1d                	jne    803090 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803073:	bf 01 00 00 00       	mov    $0x1,%edi
  803078:	48 b8 46 46 80 00 00 	movabs $0x804646,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
  803084:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80308b:	00 00 00 
  80308e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803090:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803097:	00 00 00 
  80309a:	8b 00                	mov    (%rax),%eax
  80309c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80309f:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030a4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8030ab:	00 00 00 
  8030ae:	89 c7                	mov    %eax,%edi
  8030b0:	48 b8 97 45 80 00 00 	movabs $0x804597,%rax
  8030b7:	00 00 00 
  8030ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8030c5:	48 89 c6             	mov    %rax,%rsi
  8030c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030cd:	48 b8 b0 44 80 00 00 	movabs $0x8044b0,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
}
  8030d9:	c9                   	leaveq 
  8030da:	c3                   	retq   

00000000008030db <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8030db:	55                   	push   %rbp
  8030dc:	48 89 e5             	mov    %rsp,%rbp
  8030df:	48 83 ec 20          	sub    $0x20,%rsp
  8030e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8030ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ee:	48 89 c7             	mov    %rax,%rdi
  8030f1:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803102:	7e 0a                	jle    80310e <open+0x33>
		return -E_BAD_PATH;
  803104:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803109:	e9 a5 00 00 00       	jmpq   8031b3 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80310e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803112:	48 89 c7             	mov    %rax,%rdi
  803115:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
  803121:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803128:	79 08                	jns    803132 <open+0x57>
		return r;
  80312a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312d:	e9 81 00 00 00       	jmpq   8031b3 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  803132:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803139:	00 00 00 
  80313c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80313f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803149:	48 89 c6             	mov    %rax,%rsi
  80314c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803153:	00 00 00 
  803156:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  803162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803166:	48 89 c6             	mov    %rax,%rsi
  803169:	bf 01 00 00 00       	mov    $0x1,%edi
  80316e:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	79 1d                	jns    8031a0 <open+0xc5>
		fd_close(new_fd, 0);
  803183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803187:	be 00 00 00 00       	mov    $0x0,%esi
  80318c:	48 89 c7             	mov    %rax,%rdi
  80318f:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
		return r;	
  80319b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319e:	eb 13                	jmp    8031b3 <open+0xd8>
	}
	return fd2num(new_fd);
  8031a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a4:	48 89 c7             	mov    %rax,%rdi
  8031a7:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	callq  *%rax
}
  8031b3:	c9                   	leaveq 
  8031b4:	c3                   	retq   

00000000008031b5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031b5:	55                   	push   %rbp
  8031b6:	48 89 e5             	mov    %rsp,%rbp
  8031b9:	48 83 ec 10          	sub    $0x10,%rsp
  8031bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8031c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031cf:	00 00 00 
  8031d2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031d4:	be 00 00 00 00       	mov    $0x0,%esi
  8031d9:	bf 06 00 00 00       	mov    $0x6,%edi
  8031de:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
}
  8031ea:	c9                   	leaveq 
  8031eb:	c3                   	retq   

00000000008031ec <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031ec:	55                   	push   %rbp
  8031ed:	48 89 e5             	mov    %rsp,%rbp
  8031f0:	48 83 ec 30          	sub    $0x30,%rsp
  8031f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  803200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803204:	8b 50 0c             	mov    0xc(%rax),%edx
  803207:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320e:	00 00 00 
  803211:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803213:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321a:	00 00 00 
  80321d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803221:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  803225:	be 00 00 00 00       	mov    $0x0,%esi
  80322a:	bf 03 00 00 00       	mov    $0x3,%edi
  80322f:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  80323e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803242:	7e 23                	jle    803267 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  803244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803247:	48 63 d0             	movslq %eax,%rdx
  80324a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80324e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803255:	00 00 00 
  803258:	48 89 c7             	mov    %rax,%rdi
  80325b:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
	}
	return nbytes;
  803267:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80326a:	c9                   	leaveq 
  80326b:	c3                   	retq   

000000000080326c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80326c:	55                   	push   %rbp
  80326d:	48 89 e5             	mov    %rsp,%rbp
  803270:	48 83 ec 20          	sub    $0x20,%rsp
  803274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803278:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80327c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803280:	8b 50 0c             	mov    0xc(%rax),%edx
  803283:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80328a:	00 00 00 
  80328d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80328f:	be 00 00 00 00       	mov    $0x0,%esi
  803294:	bf 05 00 00 00       	mov    $0x5,%edi
  803299:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
  8032a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ac:	79 05                	jns    8032b3 <devfile_stat+0x47>
		return r;
  8032ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b1:	eb 56                	jmp    803309 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032be:	00 00 00 
  8032c1:	48 89 c7             	mov    %rax,%rdi
  8032c4:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032d7:	00 00 00 
  8032da:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f1:	00 00 00 
  8032f4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032fe:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803309:	c9                   	leaveq 
  80330a:	c3                   	retq   
	...

000000000080330c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80330c:	55                   	push   %rbp
  80330d:	48 89 e5             	mov    %rsp,%rbp
  803310:	48 83 ec 20          	sub    $0x20,%rsp
  803314:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803317:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80331b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80331e:	48 89 d6             	mov    %rdx,%rsi
  803321:	89 c7                	mov    %eax,%edi
  803323:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803336:	79 05                	jns    80333d <fd2sockid+0x31>
		return r;
  803338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333b:	eb 24                	jmp    803361 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80333d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803341:	8b 10                	mov    (%rax),%edx
  803343:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80334a:	00 00 00 
  80334d:	8b 00                	mov    (%rax),%eax
  80334f:	39 c2                	cmp    %eax,%edx
  803351:	74 07                	je     80335a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803353:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803358:	eb 07                	jmp    803361 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80335a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803361:	c9                   	leaveq 
  803362:	c3                   	retq   

0000000000803363 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803363:	55                   	push   %rbp
  803364:	48 89 e5             	mov    %rsp,%rbp
  803367:	48 83 ec 20          	sub    $0x20,%rsp
  80336b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80336e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803372:	48 89 c7             	mov    %rax,%rdi
  803375:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
  803381:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803384:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803388:	78 26                	js     8033b0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80338a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338e:	ba 07 04 00 00       	mov    $0x407,%edx
  803393:	48 89 c6             	mov    %rax,%rsi
  803396:	bf 00 00 00 00       	mov    $0x0,%edi
  80339b:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
  8033a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ae:	79 16                	jns    8033c6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 70 38 80 00 00 	movabs $0x803870,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
		return r;
  8033c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c4:	eb 3a                	jmp    803400 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8033c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ca:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8033d1:	00 00 00 
  8033d4:	8b 12                	mov    (%rdx),%edx
  8033d6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8033d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8033e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033ea:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	48 89 c7             	mov    %rax,%rdi
  8033f4:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
}
  803400:	c9                   	leaveq 
  803401:	c3                   	retq   

0000000000803402 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803402:	55                   	push   %rbp
  803403:	48 89 e5             	mov    %rsp,%rbp
  803406:	48 83 ec 30          	sub    $0x30,%rsp
  80340a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80340d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803411:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803415:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803418:	89 c7                	mov    %eax,%edi
  80341a:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
  803426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803429:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342d:	79 05                	jns    803434 <accept+0x32>
		return r;
  80342f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803432:	eb 3b                	jmp    80346f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803434:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803438:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80343c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343f:	48 89 ce             	mov    %rcx,%rsi
  803442:	89 c7                	mov    %eax,%edi
  803444:	48 b8 4d 37 80 00 00 	movabs $0x80374d,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803457:	79 05                	jns    80345e <accept+0x5c>
		return r;
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345c:	eb 11                	jmp    80346f <accept+0x6d>
	return alloc_sockfd(r);
  80345e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803461:	89 c7                	mov    %eax,%edi
  803463:	48 b8 63 33 80 00 00 	movabs $0x803363,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
}
  80346f:	c9                   	leaveq 
  803470:	c3                   	retq   

0000000000803471 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803471:	55                   	push   %rbp
  803472:	48 89 e5             	mov    %rsp,%rbp
  803475:	48 83 ec 20          	sub    $0x20,%rsp
  803479:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80347c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803480:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803483:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803486:	89 c7                	mov    %eax,%edi
  803488:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349b:	79 05                	jns    8034a2 <bind+0x31>
		return r;
  80349d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a0:	eb 1b                	jmp    8034bd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ac:	48 89 ce             	mov    %rcx,%rsi
  8034af:	89 c7                	mov    %eax,%edi
  8034b1:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
}
  8034bd:	c9                   	leaveq 
  8034be:	c3                   	retq   

00000000008034bf <shutdown>:

int
shutdown(int s, int how)
{
  8034bf:	55                   	push   %rbp
  8034c0:	48 89 e5             	mov    %rsp,%rbp
  8034c3:	48 83 ec 20          	sub    $0x20,%rsp
  8034c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d0:	89 c7                	mov    %eax,%edi
  8034d2:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e5:	79 05                	jns    8034ec <shutdown+0x2d>
		return r;
  8034e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ea:	eb 16                	jmp    803502 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8034ec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f2:	89 d6                	mov    %edx,%esi
  8034f4:	89 c7                	mov    %eax,%edi
  8034f6:	48 b8 30 38 80 00 00 	movabs $0x803830,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	callq  *%rax
}
  803502:	c9                   	leaveq 
  803503:	c3                   	retq   

0000000000803504 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 83 ec 10          	sub    $0x10,%rsp
  80350c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803514:	48 89 c7             	mov    %rax,%rdi
  803517:	48 b8 d4 46 80 00 00 	movabs $0x8046d4,%rax
  80351e:	00 00 00 
  803521:	ff d0                	callq  *%rax
  803523:	83 f8 01             	cmp    $0x1,%eax
  803526:	75 17                	jne    80353f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352c:	8b 40 0c             	mov    0xc(%rax),%eax
  80352f:	89 c7                	mov    %eax,%edi
  803531:	48 b8 70 38 80 00 00 	movabs $0x803870,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
  80353d:	eb 05                	jmp    803544 <devsock_close+0x40>
	else
		return 0;
  80353f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803544:	c9                   	leaveq 
  803545:	c3                   	retq   

0000000000803546 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803546:	55                   	push   %rbp
  803547:	48 89 e5             	mov    %rsp,%rbp
  80354a:	48 83 ec 20          	sub    $0x20,%rsp
  80354e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803555:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803558:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80355b:	89 c7                	mov    %eax,%edi
  80355d:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80356c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803570:	79 05                	jns    803577 <connect+0x31>
		return r;
  803572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803575:	eb 1b                	jmp    803592 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803577:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80357a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803581:	48 89 ce             	mov    %rcx,%rsi
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
}
  803592:	c9                   	leaveq 
  803593:	c3                   	retq   

0000000000803594 <listen>:

int
listen(int s, int backlog)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 20          	sub    $0x20,%rsp
  80359c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a5:	89 c7                	mov    %eax,%edi
  8035a7:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ba:	79 05                	jns    8035c1 <listen+0x2d>
		return r;
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bf:	eb 16                	jmp    8035d7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8035c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c7:	89 d6                	mov    %edx,%esi
  8035c9:	89 c7                	mov    %eax,%edi
  8035cb:	48 b8 01 39 80 00 00 	movabs $0x803901,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
}
  8035d7:	c9                   	leaveq 
  8035d8:	c3                   	retq   

00000000008035d9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8035d9:	55                   	push   %rbp
  8035da:	48 89 e5             	mov    %rsp,%rbp
  8035dd:	48 83 ec 20          	sub    $0x20,%rsp
  8035e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8035ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f1:	89 c2                	mov    %eax,%edx
  8035f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f7:	8b 40 0c             	mov    0xc(%rax),%eax
  8035fa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  803603:	89 c7                	mov    %eax,%edi
  803605:	48 b8 41 39 80 00 00 	movabs $0x803941,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
}
  803611:	c9                   	leaveq 
  803612:	c3                   	retq   

0000000000803613 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803613:	55                   	push   %rbp
  803614:	48 89 e5             	mov    %rsp,%rbp
  803617:	48 83 ec 20          	sub    $0x20,%rsp
  80361b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80361f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803623:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362b:	89 c2                	mov    %eax,%edx
  80362d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803631:	8b 40 0c             	mov    0xc(%rax),%eax
  803634:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80363d:	89 c7                	mov    %eax,%edi
  80363f:	48 b8 0d 3a 80 00 00 	movabs $0x803a0d,%rax
  803646:	00 00 00 
  803649:	ff d0                	callq  *%rax
}
  80364b:	c9                   	leaveq 
  80364c:	c3                   	retq   

000000000080364d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80364d:	55                   	push   %rbp
  80364e:	48 89 e5             	mov    %rsp,%rbp
  803651:	48 83 ec 10          	sub    $0x10,%rsp
  803655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803659:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80365d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803661:	48 be e3 4e 80 00 00 	movabs $0x804ee3,%rsi
  803668:	00 00 00 
  80366b:	48 89 c7             	mov    %rax,%rdi
  80366e:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
	return 0;
  80367a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80367f:	c9                   	leaveq 
  803680:	c3                   	retq   

0000000000803681 <socket>:

int
socket(int domain, int type, int protocol)
{
  803681:	55                   	push   %rbp
  803682:	48 89 e5             	mov    %rsp,%rbp
  803685:	48 83 ec 20          	sub    $0x20,%rsp
  803689:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80368f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803692:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803695:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803698:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80369b:	89 ce                	mov    %ecx,%esi
  80369d:	89 c7                	mov    %eax,%edi
  80369f:	48 b8 c5 3a 80 00 00 	movabs $0x803ac5,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
  8036ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b2:	79 05                	jns    8036b9 <socket+0x38>
		return r;
  8036b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b7:	eb 11                	jmp    8036ca <socket+0x49>
	return alloc_sockfd(r);
  8036b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bc:	89 c7                	mov    %eax,%edi
  8036be:	48 b8 63 33 80 00 00 	movabs $0x803363,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
}
  8036ca:	c9                   	leaveq 
  8036cb:	c3                   	retq   

00000000008036cc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036cc:	55                   	push   %rbp
  8036cd:	48 89 e5             	mov    %rsp,%rbp
  8036d0:	48 83 ec 10          	sub    $0x10,%rsp
  8036d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8036d7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8036de:	00 00 00 
  8036e1:	8b 00                	mov    (%rax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	75 1d                	jne    803704 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8036e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8036ec:	48 b8 46 46 80 00 00 	movabs $0x804646,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8036ff:	00 00 00 
  803702:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803704:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80370b:	00 00 00 
  80370e:	8b 00                	mov    (%rax),%eax
  803710:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803713:	b9 07 00 00 00       	mov    $0x7,%ecx
  803718:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80371f:	00 00 00 
  803722:	89 c7                	mov    %eax,%edi
  803724:	48 b8 97 45 80 00 00 	movabs $0x804597,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803730:	ba 00 00 00 00       	mov    $0x0,%edx
  803735:	be 00 00 00 00       	mov    $0x0,%esi
  80373a:	bf 00 00 00 00       	mov    $0x0,%edi
  80373f:	48 b8 b0 44 80 00 00 	movabs $0x8044b0,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
}
  80374b:	c9                   	leaveq 
  80374c:	c3                   	retq   

000000000080374d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80374d:	55                   	push   %rbp
  80374e:	48 89 e5             	mov    %rsp,%rbp
  803751:	48 83 ec 30          	sub    $0x30,%rsp
  803755:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80375c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803760:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803767:	00 00 00 
  80376a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80376d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80376f:	bf 01 00 00 00       	mov    $0x1,%edi
  803774:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
  803780:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803787:	78 3e                	js     8037c7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803789:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803790:	00 00 00 
  803793:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379b:	8b 40 10             	mov    0x10(%rax),%eax
  80379e:	89 c2                	mov    %eax,%edx
  8037a0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a8:	48 89 ce             	mov    %rcx,%rsi
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8037ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037be:	8b 50 10             	mov    0x10(%rax),%edx
  8037c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8037c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037ca:	c9                   	leaveq 
  8037cb:	c3                   	retq   

00000000008037cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037cc:	55                   	push   %rbp
  8037cd:	48 89 e5             	mov    %rsp,%rbp
  8037d0:	48 83 ec 10          	sub    $0x10,%rsp
  8037d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037db:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8037de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e5:	00 00 00 
  8037e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037eb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8037ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f4:	48 89 c6             	mov    %rax,%rsi
  8037f7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037fe:	00 00 00 
  803801:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  803808:	00 00 00 
  80380b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80380d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803814:	00 00 00 
  803817:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80381a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80381d:	bf 02 00 00 00       	mov    $0x2,%edi
  803822:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803829:	00 00 00 
  80382c:	ff d0                	callq  *%rax
}
  80382e:	c9                   	leaveq 
  80382f:	c3                   	retq   

0000000000803830 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803830:	55                   	push   %rbp
  803831:	48 89 e5             	mov    %rsp,%rbp
  803834:	48 83 ec 10          	sub    $0x10,%rsp
  803838:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80383b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80383e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803845:	00 00 00 
  803848:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80384b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80384d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803854:	00 00 00 
  803857:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80385a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80385d:	bf 03 00 00 00       	mov    $0x3,%edi
  803862:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803869:	00 00 00 
  80386c:	ff d0                	callq  *%rax
}
  80386e:	c9                   	leaveq 
  80386f:	c3                   	retq   

0000000000803870 <nsipc_close>:

int
nsipc_close(int s)
{
  803870:	55                   	push   %rbp
  803871:	48 89 e5             	mov    %rsp,%rbp
  803874:	48 83 ec 10          	sub    $0x10,%rsp
  803878:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80387b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803882:	00 00 00 
  803885:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803888:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80388a:	bf 04 00 00 00       	mov    $0x4,%edi
  80388f:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
}
  80389b:	c9                   	leaveq 
  80389c:	c3                   	retq   

000000000080389d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80389d:	55                   	push   %rbp
  80389e:	48 89 e5             	mov    %rsp,%rbp
  8038a1:	48 83 ec 10          	sub    $0x10,%rsp
  8038a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b6:	00 00 00 
  8038b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8038be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c5:	48 89 c6             	mov    %rax,%rsi
  8038c8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038cf:	00 00 00 
  8038d2:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  8038d9:	00 00 00 
  8038dc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8038de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e5:	00 00 00 
  8038e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038eb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8038ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8038f3:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  8038fa:	00 00 00 
  8038fd:	ff d0                	callq  *%rax
}
  8038ff:	c9                   	leaveq 
  803900:	c3                   	retq   

0000000000803901 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803901:	55                   	push   %rbp
  803902:	48 89 e5             	mov    %rsp,%rbp
  803905:	48 83 ec 10          	sub    $0x10,%rsp
  803909:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80390c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80390f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803916:	00 00 00 
  803919:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80391c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80391e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803925:	00 00 00 
  803928:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80392e:	bf 06 00 00 00       	mov    $0x6,%edi
  803933:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  80393a:	00 00 00 
  80393d:	ff d0                	callq  *%rax
}
  80393f:	c9                   	leaveq 
  803940:	c3                   	retq   

0000000000803941 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803941:	55                   	push   %rbp
  803942:	48 89 e5             	mov    %rsp,%rbp
  803945:	48 83 ec 30          	sub    $0x30,%rsp
  803949:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80394c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803950:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803953:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803956:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80395d:	00 00 00 
  803960:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803963:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803965:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80396c:	00 00 00 
  80396f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803972:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803975:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80397c:	00 00 00 
  80397f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803982:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803985:	bf 07 00 00 00       	mov    $0x7,%edi
  80398a:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803999:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399d:	78 69                	js     803a08 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80399f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039a6:	7f 08                	jg     8039b0 <nsipc_recv+0x6f>
  8039a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ab:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039ae:	7e 35                	jle    8039e5 <nsipc_recv+0xa4>
  8039b0:	48 b9 ea 4e 80 00 00 	movabs $0x804eea,%rcx
  8039b7:	00 00 00 
  8039ba:	48 ba ff 4e 80 00 00 	movabs $0x804eff,%rdx
  8039c1:	00 00 00 
  8039c4:	be 61 00 00 00       	mov    $0x61,%esi
  8039c9:	48 bf 14 4f 80 00 00 	movabs $0x804f14,%rdi
  8039d0:	00 00 00 
  8039d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d8:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  8039df:	00 00 00 
  8039e2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e8:	48 63 d0             	movslq %eax,%rdx
  8039eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ef:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8039f6:	00 00 00 
  8039f9:	48 89 c7             	mov    %rax,%rdi
  8039fc:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax
	}

	return r;
  803a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a0b:	c9                   	leaveq 
  803a0c:	c3                   	retq   

0000000000803a0d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a0d:	55                   	push   %rbp
  803a0e:	48 89 e5             	mov    %rsp,%rbp
  803a11:	48 83 ec 20          	sub    $0x20,%rsp
  803a15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a1c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a1f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a22:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a29:	00 00 00 
  803a2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a2f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a31:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a38:	7e 35                	jle    803a6f <nsipc_send+0x62>
  803a3a:	48 b9 20 4f 80 00 00 	movabs $0x804f20,%rcx
  803a41:	00 00 00 
  803a44:	48 ba ff 4e 80 00 00 	movabs $0x804eff,%rdx
  803a4b:	00 00 00 
  803a4e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a53:	48 bf 14 4f 80 00 00 	movabs $0x804f14,%rdi
  803a5a:	00 00 00 
  803a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a62:	49 b8 ec 04 80 00 00 	movabs $0x8004ec,%r8
  803a69:	00 00 00 
  803a6c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a72:	48 63 d0             	movslq %eax,%rdx
  803a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a79:	48 89 c6             	mov    %rax,%rsi
  803a7c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a83:	00 00 00 
  803a86:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a99:	00 00 00 
  803a9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a9f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803aa2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aa9:	00 00 00 
  803aac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aaf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803ab2:	bf 08 00 00 00       	mov    $0x8,%edi
  803ab7:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
}
  803ac3:	c9                   	leaveq 
  803ac4:	c3                   	retq   

0000000000803ac5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ac5:	55                   	push   %rbp
  803ac6:	48 89 e5             	mov    %rsp,%rbp
  803ac9:	48 83 ec 10          	sub    $0x10,%rsp
  803acd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ad3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ad6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803add:	00 00 00 
  803ae0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ae5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aec:	00 00 00 
  803aef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803af5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803afc:	00 00 00 
  803aff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b02:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b05:	bf 09 00 00 00       	mov    $0x9,%edi
  803b0a:	48 b8 cc 36 80 00 00 	movabs $0x8036cc,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	53                   	push   %rbx
  803b1d:	48 83 ec 38          	sub    $0x38,%rsp
  803b21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b25:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b29:	48 89 c7             	mov    %rax,%rdi
  803b2c:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
  803b38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b3f:	0f 88 bf 01 00 00    	js     803d04 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b49:	ba 07 04 00 00       	mov    $0x407,%edx
  803b4e:	48 89 c6             	mov    %rax,%rsi
  803b51:	bf 00 00 00 00       	mov    $0x0,%edi
  803b56:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
  803b62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b69:	0f 88 95 01 00 00    	js     803d04 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b73:	48 89 c7             	mov    %rax,%rdi
  803b76:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
  803b82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b89:	0f 88 5d 01 00 00    	js     803cec <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b93:	ba 07 04 00 00       	mov    $0x407,%edx
  803b98:	48 89 c6             	mov    %rax,%rsi
  803b9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba0:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803ba7:	00 00 00 
  803baa:	ff d0                	callq  *%rax
  803bac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803baf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bb3:	0f 88 33 01 00 00    	js     803cec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803bb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bbd:	48 89 c7             	mov    %rax,%rdi
  803bc0:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803bc7:	00 00 00 
  803bca:	ff d0                	callq  *%rax
  803bcc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd4:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd9:	48 89 c6             	mov    %rax,%rsi
  803bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  803be1:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
  803bed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bf4:	0f 88 d9 00 00 00    	js     803cd3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bfa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bfe:	48 89 c7             	mov    %rax,%rdi
  803c01:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803c08:	00 00 00 
  803c0b:	ff d0                	callq  *%rax
  803c0d:	48 89 c2             	mov    %rax,%rdx
  803c10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c14:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c1a:	48 89 d1             	mov    %rdx,%rcx
  803c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  803c22:	48 89 c6             	mov    %rax,%rsi
  803c25:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2a:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  803c31:	00 00 00 
  803c34:	ff d0                	callq  *%rax
  803c36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3d:	78 79                	js     803cb8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c43:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c4a:	00 00 00 
  803c4d:	8b 12                	mov    (%rdx),%edx
  803c4f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c60:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c67:	00 00 00 
  803c6a:	8b 12                	mov    (%rdx),%edx
  803c6c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c72:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c7d:	48 89 c7             	mov    %rax,%rdi
  803c80:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  803c87:	00 00 00 
  803c8a:	ff d0                	callq  *%rax
  803c8c:	89 c2                	mov    %eax,%edx
  803c8e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c92:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c98:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca0:	48 89 c7             	mov    %rax,%rdi
  803ca3:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	89 03                	mov    %eax,(%rbx)
	return 0;
  803cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb6:	eb 4f                	jmp    803d07 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803cb8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803cb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbd:	48 89 c6             	mov    %rax,%rsi
  803cc0:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc5:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
  803cd1:	eb 01                	jmp    803cd4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803cd3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803cd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd8:	48 89 c6             	mov    %rax,%rsi
  803cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce0:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  803ce7:	00 00 00 
  803cea:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803cec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf0:	48 89 c6             	mov    %rax,%rsi
  803cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf8:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
err:
	return r;
  803d04:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d07:	48 83 c4 38          	add    $0x38,%rsp
  803d0b:	5b                   	pop    %rbx
  803d0c:	5d                   	pop    %rbp
  803d0d:	c3                   	retq   

0000000000803d0e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d0e:	55                   	push   %rbp
  803d0f:	48 89 e5             	mov    %rsp,%rbp
  803d12:	53                   	push   %rbx
  803d13:	48 83 ec 28          	sub    $0x28,%rsp
  803d17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d1f:	eb 01                	jmp    803d22 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803d21:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d22:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d29:	00 00 00 
  803d2c:	48 8b 00             	mov    (%rax),%rax
  803d2f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d35:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3c:	48 89 c7             	mov    %rax,%rdi
  803d3f:	48 b8 d4 46 80 00 00 	movabs $0x8046d4,%rax
  803d46:	00 00 00 
  803d49:	ff d0                	callq  *%rax
  803d4b:	89 c3                	mov    %eax,%ebx
  803d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d51:	48 89 c7             	mov    %rax,%rdi
  803d54:	48 b8 d4 46 80 00 00 	movabs $0x8046d4,%rax
  803d5b:	00 00 00 
  803d5e:	ff d0                	callq  *%rax
  803d60:	39 c3                	cmp    %eax,%ebx
  803d62:	0f 94 c0             	sete   %al
  803d65:	0f b6 c0             	movzbl %al,%eax
  803d68:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d72:	00 00 00 
  803d75:	48 8b 00             	mov    (%rax),%rax
  803d78:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d7e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d84:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d87:	75 0a                	jne    803d93 <_pipeisclosed+0x85>
			return ret;
  803d89:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803d8c:	48 83 c4 28          	add    $0x28,%rsp
  803d90:	5b                   	pop    %rbx
  803d91:	5d                   	pop    %rbp
  803d92:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d96:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d99:	74 86                	je     803d21 <_pipeisclosed+0x13>
  803d9b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d9f:	75 80                	jne    803d21 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803da1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803da8:	00 00 00 
  803dab:	48 8b 00             	mov    (%rax),%rax
  803dae:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803db4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dba:	89 c6                	mov    %eax,%esi
  803dbc:	48 bf 31 4f 80 00 00 	movabs $0x804f31,%rdi
  803dc3:	00 00 00 
  803dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  803dcb:	49 b8 27 07 80 00 00 	movabs $0x800727,%r8
  803dd2:	00 00 00 
  803dd5:	41 ff d0             	callq  *%r8
	}
  803dd8:	e9 44 ff ff ff       	jmpq   803d21 <_pipeisclosed+0x13>

0000000000803ddd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803ddd:	55                   	push   %rbp
  803dde:	48 89 e5             	mov    %rsp,%rbp
  803de1:	48 83 ec 30          	sub    $0x30,%rsp
  803de5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803de8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803def:	48 89 d6             	mov    %rdx,%rsi
  803df2:	89 c7                	mov    %eax,%edi
  803df4:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
  803e00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e07:	79 05                	jns    803e0e <pipeisclosed+0x31>
		return r;
  803e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0c:	eb 31                	jmp    803e3f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e12:	48 89 c7             	mov    %rax,%rdi
  803e15:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803e1c:	00 00 00 
  803e1f:	ff d0                	callq  *%rax
  803e21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e2d:	48 89 d6             	mov    %rdx,%rsi
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 0e 3d 80 00 00 	movabs $0x803d0e,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
}
  803e3f:	c9                   	leaveq 
  803e40:	c3                   	retq   

0000000000803e41 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e41:	55                   	push   %rbp
  803e42:	48 89 e5             	mov    %rsp,%rbp
  803e45:	48 83 ec 40          	sub    $0x40,%rsp
  803e49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e59:	48 89 c7             	mov    %rax,%rdi
  803e5c:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803e63:	00 00 00 
  803e66:	ff d0                	callq  *%rax
  803e68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e74:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e7b:	00 
  803e7c:	e9 97 00 00 00       	jmpq   803f18 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e81:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e86:	74 09                	je     803e91 <devpipe_read+0x50>
				return i;
  803e88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8c:	e9 95 00 00 00       	jmpq   803f26 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e99:	48 89 d6             	mov    %rdx,%rsi
  803e9c:	48 89 c7             	mov    %rax,%rdi
  803e9f:	48 b8 0e 3d 80 00 00 	movabs $0x803d0e,%rax
  803ea6:	00 00 00 
  803ea9:	ff d0                	callq  *%rax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	74 07                	je     803eb6 <devpipe_read+0x75>
				return 0;
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb4:	eb 70                	jmp    803f26 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803eb6:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  803ebd:	00 00 00 
  803ec0:	ff d0                	callq  *%rax
  803ec2:	eb 01                	jmp    803ec5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ec4:	90                   	nop
  803ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec9:	8b 10                	mov    (%rax),%edx
  803ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecf:	8b 40 04             	mov    0x4(%rax),%eax
  803ed2:	39 c2                	cmp    %eax,%edx
  803ed4:	74 ab                	je     803e81 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ede:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee6:	8b 00                	mov    (%rax),%eax
  803ee8:	89 c2                	mov    %eax,%edx
  803eea:	c1 fa 1f             	sar    $0x1f,%edx
  803eed:	c1 ea 1b             	shr    $0x1b,%edx
  803ef0:	01 d0                	add    %edx,%eax
  803ef2:	83 e0 1f             	and    $0x1f,%eax
  803ef5:	29 d0                	sub    %edx,%eax
  803ef7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803efb:	48 98                	cltq   
  803efd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f02:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f08:	8b 00                	mov    (%rax),%eax
  803f0a:	8d 50 01             	lea    0x1(%rax),%edx
  803f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f11:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f13:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f20:	72 a2                	jb     803ec4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f26:	c9                   	leaveq 
  803f27:	c3                   	retq   

0000000000803f28 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f28:	55                   	push   %rbp
  803f29:	48 89 e5             	mov    %rsp,%rbp
  803f2c:	48 83 ec 40          	sub    $0x40,%rsp
  803f30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f40:	48 89 c7             	mov    %rax,%rdi
  803f43:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  803f4a:	00 00 00 
  803f4d:	ff d0                	callq  *%rax
  803f4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f5b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f62:	00 
  803f63:	e9 93 00 00 00       	jmpq   803ffb <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f70:	48 89 d6             	mov    %rdx,%rsi
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 0e 3d 80 00 00 	movabs $0x803d0e,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
  803f82:	85 c0                	test   %eax,%eax
  803f84:	74 07                	je     803f8d <devpipe_write+0x65>
				return 0;
  803f86:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8b:	eb 7c                	jmp    804009 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f8d:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  803f94:	00 00 00 
  803f97:	ff d0                	callq  *%rax
  803f99:	eb 01                	jmp    803f9c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f9b:	90                   	nop
  803f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa0:	8b 40 04             	mov    0x4(%rax),%eax
  803fa3:	48 63 d0             	movslq %eax,%rdx
  803fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803faa:	8b 00                	mov    (%rax),%eax
  803fac:	48 98                	cltq   
  803fae:	48 83 c0 20          	add    $0x20,%rax
  803fb2:	48 39 c2             	cmp    %rax,%rdx
  803fb5:	73 b1                	jae    803f68 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbb:	8b 40 04             	mov    0x4(%rax),%eax
  803fbe:	89 c2                	mov    %eax,%edx
  803fc0:	c1 fa 1f             	sar    $0x1f,%edx
  803fc3:	c1 ea 1b             	shr    $0x1b,%edx
  803fc6:	01 d0                	add    %edx,%eax
  803fc8:	83 e0 1f             	and    $0x1f,%eax
  803fcb:	29 d0                	sub    %edx,%eax
  803fcd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fd1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803fd5:	48 01 ca             	add    %rcx,%rdx
  803fd8:	0f b6 0a             	movzbl (%rdx),%ecx
  803fdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fdf:	48 98                	cltq   
  803fe1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe9:	8b 40 04             	mov    0x4(%rax),%eax
  803fec:	8d 50 01             	lea    0x1(%rax),%edx
  803fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ff6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804003:	72 96                	jb     803f9b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804009:	c9                   	leaveq 
  80400a:	c3                   	retq   

000000000080400b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80400b:	55                   	push   %rbp
  80400c:	48 89 e5             	mov    %rsp,%rbp
  80400f:	48 83 ec 20          	sub    $0x20,%rsp
  804013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80401b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401f:	48 89 c7             	mov    %rax,%rdi
  804022:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804032:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804036:	48 be 44 4f 80 00 00 	movabs $0x804f44,%rsi
  80403d:	00 00 00 
  804040:	48 89 c7             	mov    %rax,%rdi
  804043:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  80404a:	00 00 00 
  80404d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80404f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804053:	8b 50 04             	mov    0x4(%rax),%edx
  804056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80405a:	8b 00                	mov    (%rax),%eax
  80405c:	29 c2                	sub    %eax,%edx
  80405e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804062:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80406c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804073:	00 00 00 
	stat->st_dev = &devpipe;
  804076:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804081:	00 00 00 
  804084:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80408b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804090:	c9                   	leaveq 
  804091:	c3                   	retq   

0000000000804092 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804092:	55                   	push   %rbp
  804093:	48 89 e5             	mov    %rsp,%rbp
  804096:	48 83 ec 10          	sub    $0x10,%rsp
  80409a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80409e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a2:	48 89 c6             	mov    %rax,%rsi
  8040a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8040aa:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  8040b1:	00 00 00 
  8040b4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8040b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ba:	48 89 c7             	mov    %rax,%rdi
  8040bd:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  8040c4:	00 00 00 
  8040c7:	ff d0                	callq  *%rax
  8040c9:	48 89 c6             	mov    %rax,%rsi
  8040cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040d1:	48 b8 db 1c 80 00 00 	movabs $0x801cdb,%rax
  8040d8:	00 00 00 
  8040db:	ff d0                	callq  *%rax
}
  8040dd:	c9                   	leaveq 
  8040de:	c3                   	retq   
	...

00000000008040e0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040e0:	55                   	push   %rbp
  8040e1:	48 89 e5             	mov    %rsp,%rbp
  8040e4:	48 83 ec 20          	sub    $0x20,%rsp
  8040e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8040eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ee:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040f1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8040f5:	be 01 00 00 00       	mov    $0x1,%esi
  8040fa:	48 89 c7             	mov    %rax,%rdi
  8040fd:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  804104:	00 00 00 
  804107:	ff d0                	callq  *%rax
}
  804109:	c9                   	leaveq 
  80410a:	c3                   	retq   

000000000080410b <getchar>:

int
getchar(void)
{
  80410b:	55                   	push   %rbp
  80410c:	48 89 e5             	mov    %rsp,%rbp
  80410f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804113:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804117:	ba 01 00 00 00       	mov    $0x1,%edx
  80411c:	48 89 c6             	mov    %rax,%rsi
  80411f:	bf 00 00 00 00       	mov    $0x0,%edi
  804124:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  80412b:	00 00 00 
  80412e:	ff d0                	callq  *%rax
  804130:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804137:	79 05                	jns    80413e <getchar+0x33>
		return r;
  804139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413c:	eb 14                	jmp    804152 <getchar+0x47>
	if (r < 1)
  80413e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804142:	7f 07                	jg     80414b <getchar+0x40>
		return -E_EOF;
  804144:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804149:	eb 07                	jmp    804152 <getchar+0x47>
	return c;
  80414b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80414f:	0f b6 c0             	movzbl %al,%eax
}
  804152:	c9                   	leaveq 
  804153:	c3                   	retq   

0000000000804154 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804154:	55                   	push   %rbp
  804155:	48 89 e5             	mov    %rsp,%rbp
  804158:	48 83 ec 20          	sub    $0x20,%rsp
  80415c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80415f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804166:	48 89 d6             	mov    %rdx,%rsi
  804169:	89 c7                	mov    %eax,%edi
  80416b:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  804172:	00 00 00 
  804175:	ff d0                	callq  *%rax
  804177:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80417a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80417e:	79 05                	jns    804185 <iscons+0x31>
		return r;
  804180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804183:	eb 1a                	jmp    80419f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804189:	8b 10                	mov    (%rax),%edx
  80418b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804192:	00 00 00 
  804195:	8b 00                	mov    (%rax),%eax
  804197:	39 c2                	cmp    %eax,%edx
  804199:	0f 94 c0             	sete   %al
  80419c:	0f b6 c0             	movzbl %al,%eax
}
  80419f:	c9                   	leaveq 
  8041a0:	c3                   	retq   

00000000008041a1 <opencons>:

int
opencons(void)
{
  8041a1:	55                   	push   %rbp
  8041a2:	48 89 e5             	mov    %rsp,%rbp
  8041a5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041a9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041ad:	48 89 c7             	mov    %rax,%rdi
  8041b0:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  8041b7:	00 00 00 
  8041ba:	ff d0                	callq  *%rax
  8041bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c3:	79 05                	jns    8041ca <opencons+0x29>
		return r;
  8041c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c8:	eb 5b                	jmp    804225 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8041d3:	48 89 c6             	mov    %rax,%rsi
  8041d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8041db:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8041e2:	00 00 00 
  8041e5:	ff d0                	callq  *%rax
  8041e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ee:	79 05                	jns    8041f5 <opencons+0x54>
		return r;
  8041f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f3:	eb 30                	jmp    804225 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8041f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804200:	00 00 00 
  804203:	8b 12                	mov    (%rdx),%edx
  804205:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804216:	48 89 c7             	mov    %rax,%rdi
  804219:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  804220:	00 00 00 
  804223:	ff d0                	callq  *%rax
}
  804225:	c9                   	leaveq 
  804226:	c3                   	retq   

0000000000804227 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804227:	55                   	push   %rbp
  804228:	48 89 e5             	mov    %rsp,%rbp
  80422b:	48 83 ec 30          	sub    $0x30,%rsp
  80422f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804233:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804237:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80423b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804240:	75 13                	jne    804255 <devcons_read+0x2e>
		return 0;
  804242:	b8 00 00 00 00       	mov    $0x0,%eax
  804247:	eb 49                	jmp    804292 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804249:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804255:	48 b8 32 1b 80 00 00 	movabs $0x801b32,%rax
  80425c:	00 00 00 
  80425f:	ff d0                	callq  *%rax
  804261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804268:	74 df                	je     804249 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80426a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80426e:	79 05                	jns    804275 <devcons_read+0x4e>
		return c;
  804270:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804273:	eb 1d                	jmp    804292 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804275:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804279:	75 07                	jne    804282 <devcons_read+0x5b>
		return 0;
  80427b:	b8 00 00 00 00       	mov    $0x0,%eax
  804280:	eb 10                	jmp    804292 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804282:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804285:	89 c2                	mov    %eax,%edx
  804287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428b:	88 10                	mov    %dl,(%rax)
	return 1;
  80428d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804292:	c9                   	leaveq 
  804293:	c3                   	retq   

0000000000804294 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80429f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042a6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042ad:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042bb:	eb 77                	jmp    804334 <devcons_write+0xa0>
		m = n - tot;
  8042bd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8042c4:	89 c2                	mov    %eax,%edx
  8042c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c9:	89 d1                	mov    %edx,%ecx
  8042cb:	29 c1                	sub    %eax,%ecx
  8042cd:	89 c8                	mov    %ecx,%eax
  8042cf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8042d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042d5:	83 f8 7f             	cmp    $0x7f,%eax
  8042d8:	76 07                	jbe    8042e1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8042da:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8042e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042e4:	48 63 d0             	movslq %eax,%rdx
  8042e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ea:	48 98                	cltq   
  8042ec:	48 89 c1             	mov    %rax,%rcx
  8042ef:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8042f6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042fd:	48 89 ce             	mov    %rcx,%rsi
  804300:	48 89 c7             	mov    %rax,%rdi
  804303:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  80430a:	00 00 00 
  80430d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80430f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804312:	48 63 d0             	movslq %eax,%rdx
  804315:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80431c:	48 89 d6             	mov    %rdx,%rsi
  80431f:	48 89 c7             	mov    %rax,%rdi
  804322:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  804329:	00 00 00 
  80432c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80432e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804331:	01 45 fc             	add    %eax,-0x4(%rbp)
  804334:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804337:	48 98                	cltq   
  804339:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804340:	0f 82 77 ff ff ff    	jb     8042bd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804346:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804349:	c9                   	leaveq 
  80434a:	c3                   	retq   

000000000080434b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80434b:	55                   	push   %rbp
  80434c:	48 89 e5             	mov    %rsp,%rbp
  80434f:	48 83 ec 08          	sub    $0x8,%rsp
  804353:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804357:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80435c:	c9                   	leaveq 
  80435d:	c3                   	retq   

000000000080435e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80435e:	55                   	push   %rbp
  80435f:	48 89 e5             	mov    %rsp,%rbp
  804362:	48 83 ec 10          	sub    $0x10,%rsp
  804366:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80436a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80436e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804372:	48 be 50 4f 80 00 00 	movabs $0x804f50,%rsi
  804379:	00 00 00 
  80437c:	48 89 c7             	mov    %rax,%rdi
  80437f:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  804386:	00 00 00 
  804389:	ff d0                	callq  *%rax
	return 0;
  80438b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   
	...

0000000000804394 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804394:	55                   	push   %rbp
  804395:	48 89 e5             	mov    %rsp,%rbp
  804398:	48 83 ec 10          	sub    $0x10,%rsp
  80439c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8043a0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a7:	00 00 00 
  8043aa:	48 8b 00             	mov    (%rax),%rax
  8043ad:	48 85 c0             	test   %rax,%rax
  8043b0:	75 66                	jne    804418 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8043b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043b7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8043bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043c1:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8043c8:	00 00 00 
  8043cb:	ff d0                	callq  *%rax
  8043cd:	85 c0                	test   %eax,%eax
  8043cf:	75 1d                	jne    8043ee <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8043d1:	48 be 2c 44 80 00 00 	movabs $0x80442c,%rsi
  8043d8:	00 00 00 
  8043db:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e0:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8043e7:	00 00 00 
  8043ea:	ff d0                	callq  *%rax
  8043ec:	eb 2a                	jmp    804418 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  8043ee:	48 ba 57 4f 80 00 00 	movabs $0x804f57,%rdx
  8043f5:	00 00 00 
  8043f8:	be 23 00 00 00       	mov    $0x23,%esi
  8043fd:	48 bf 75 4f 80 00 00 	movabs $0x804f75,%rdi
  804404:	00 00 00 
  804407:	b8 00 00 00 00       	mov    $0x0,%eax
  80440c:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  804413:	00 00 00 
  804416:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804418:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80441f:	00 00 00 
  804422:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804426:	48 89 10             	mov    %rdx,(%rax)
}
  804429:	c9                   	leaveq 
  80442a:	c3                   	retq   
	...

000000000080442c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80442c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80442f:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804436:	00 00 00 
call *%rax
  804439:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  80443b:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  80443f:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804444:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  80444b:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  80444c:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804450:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  804453:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  80445a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  80445b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80445f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804464:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804469:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80446e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804473:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804478:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80447d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804482:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804487:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80448c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804491:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804496:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80449b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044a0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044a5:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8044a9:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8044ad:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8044ae:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8044af:	c3                   	retq   

00000000008044b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044b0:	55                   	push   %rbp
  8044b1:	48 89 e5             	mov    %rsp,%rbp
  8044b4:	48 83 ec 30          	sub    $0x30,%rsp
  8044b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8044c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8044cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044d0:	74 18                	je     8044ea <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8044d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044d6:	48 89 c7             	mov    %rax,%rdi
  8044d9:	48 b8 59 1e 80 00 00 	movabs $0x801e59,%rax
  8044e0:	00 00 00 
  8044e3:	ff d0                	callq  *%rax
  8044e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e8:	eb 19                	jmp    804503 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8044ea:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8044f1:	00 00 00 
  8044f4:	48 b8 59 1e 80 00 00 	movabs $0x801e59,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
  804500:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  804503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804507:	79 39                	jns    804542 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804509:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80450e:	75 08                	jne    804518 <ipc_recv+0x68>
  804510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804514:	8b 00                	mov    (%rax),%eax
  804516:	eb 05                	jmp    80451d <ipc_recv+0x6d>
  804518:	b8 00 00 00 00       	mov    $0x0,%eax
  80451d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804521:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  804523:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804528:	75 08                	jne    804532 <ipc_recv+0x82>
  80452a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452e:	8b 00                	mov    (%rax),%eax
  804530:	eb 05                	jmp    804537 <ipc_recv+0x87>
  804532:	b8 00 00 00 00       	mov    $0x0,%eax
  804537:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80453b:	89 02                	mov    %eax,(%rdx)
		return r;
  80453d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804540:	eb 53                	jmp    804595 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  804542:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804547:	74 19                	je     804562 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804549:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804550:	00 00 00 
  804553:	48 8b 00             	mov    (%rax),%rax
  804556:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80455c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804560:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  804562:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804567:	74 19                	je     804582 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804569:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804570:	00 00 00 
  804573:	48 8b 00             	mov    (%rax),%rax
  804576:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80457c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804580:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  804582:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804589:	00 00 00 
  80458c:	48 8b 00             	mov    (%rax),%rax
  80458f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804595:	c9                   	leaveq 
  804596:	c3                   	retq   

0000000000804597 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804597:	55                   	push   %rbp
  804598:	48 89 e5             	mov    %rsp,%rbp
  80459b:	48 83 ec 30          	sub    $0x30,%rsp
  80459f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045a5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045a9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8045ac:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8045b3:	eb 59                	jmp    80460e <ipc_send+0x77>
		if(pg) {
  8045b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045ba:	74 20                	je     8045dc <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8045bc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045bf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045c9:	89 c7                	mov    %eax,%edi
  8045cb:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  8045d2:	00 00 00 
  8045d5:	ff d0                	callq  *%rax
  8045d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045da:	eb 26                	jmp    804602 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8045dc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8045e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e5:	89 d1                	mov    %edx,%ecx
  8045e7:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8045ee:	00 00 00 
  8045f1:	89 c7                	mov    %eax,%edi
  8045f3:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  8045fa:	00 00 00 
  8045fd:	ff d0                	callq  *%rax
  8045ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  804602:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  804609:	00 00 00 
  80460c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  80460e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804612:	74 a1                	je     8045b5 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804614:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804618:	74 2a                	je     804644 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  80461a:	48 ba 88 4f 80 00 00 	movabs $0x804f88,%rdx
  804621:	00 00 00 
  804624:	be 49 00 00 00       	mov    $0x49,%esi
  804629:	48 bf b3 4f 80 00 00 	movabs $0x804fb3,%rdi
  804630:	00 00 00 
  804633:	b8 00 00 00 00       	mov    $0x0,%eax
  804638:	48 b9 ec 04 80 00 00 	movabs $0x8004ec,%rcx
  80463f:	00 00 00 
  804642:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804644:	c9                   	leaveq 
  804645:	c3                   	retq   

0000000000804646 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804646:	55                   	push   %rbp
  804647:	48 89 e5             	mov    %rsp,%rbp
  80464a:	48 83 ec 18          	sub    $0x18,%rsp
  80464e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804651:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804658:	eb 6a                	jmp    8046c4 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80465a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804661:	00 00 00 
  804664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804667:	48 63 d0             	movslq %eax,%rdx
  80466a:	48 89 d0             	mov    %rdx,%rax
  80466d:	48 c1 e0 02          	shl    $0x2,%rax
  804671:	48 01 d0             	add    %rdx,%rax
  804674:	48 01 c0             	add    %rax,%rax
  804677:	48 01 d0             	add    %rdx,%rax
  80467a:	48 c1 e0 05          	shl    $0x5,%rax
  80467e:	48 01 c8             	add    %rcx,%rax
  804681:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804687:	8b 00                	mov    (%rax),%eax
  804689:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80468c:	75 32                	jne    8046c0 <ipc_find_env+0x7a>
			return envs[i].env_id;
  80468e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804695:	00 00 00 
  804698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80469b:	48 63 d0             	movslq %eax,%rdx
  80469e:	48 89 d0             	mov    %rdx,%rax
  8046a1:	48 c1 e0 02          	shl    $0x2,%rax
  8046a5:	48 01 d0             	add    %rdx,%rax
  8046a8:	48 01 c0             	add    %rax,%rax
  8046ab:	48 01 d0             	add    %rdx,%rax
  8046ae:	48 c1 e0 05          	shl    $0x5,%rax
  8046b2:	48 01 c8             	add    %rcx,%rax
  8046b5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046bb:	8b 40 08             	mov    0x8(%rax),%eax
  8046be:	eb 12                	jmp    8046d2 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046c4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046cb:	7e 8d                	jle    80465a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8046cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046d2:	c9                   	leaveq 
  8046d3:	c3                   	retq   

00000000008046d4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046d4:	55                   	push   %rbp
  8046d5:	48 89 e5             	mov    %rsp,%rbp
  8046d8:	48 83 ec 18          	sub    $0x18,%rsp
  8046dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046e4:	48 89 c2             	mov    %rax,%rdx
  8046e7:	48 c1 ea 15          	shr    $0x15,%rdx
  8046eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046f2:	01 00 00 
  8046f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046f9:	83 e0 01             	and    $0x1,%eax
  8046fc:	48 85 c0             	test   %rax,%rax
  8046ff:	75 07                	jne    804708 <pageref+0x34>
		return 0;
  804701:	b8 00 00 00 00       	mov    $0x0,%eax
  804706:	eb 53                	jmp    80475b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80470c:	48 89 c2             	mov    %rax,%rdx
  80470f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804713:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80471a:	01 00 00 
  80471d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804721:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804729:	83 e0 01             	and    $0x1,%eax
  80472c:	48 85 c0             	test   %rax,%rax
  80472f:	75 07                	jne    804738 <pageref+0x64>
		return 0;
  804731:	b8 00 00 00 00       	mov    $0x0,%eax
  804736:	eb 23                	jmp    80475b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80473c:	48 89 c2             	mov    %rax,%rdx
  80473f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804743:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80474a:	00 00 00 
  80474d:	48 c1 e2 04          	shl    $0x4,%rdx
  804751:	48 01 d0             	add    %rdx,%rax
  804754:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804758:	0f b7 c0             	movzwl %ax,%eax
}
  80475b:	c9                   	leaveq 
  80475c:	c3                   	retq   
