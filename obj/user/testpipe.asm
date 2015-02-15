
obj/user/testpipe.debug:     file format elf64-x86-64


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
  80003c:	e8 c7 04 00 00       	callq  800508 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80004f:	89 bd 7c ff ff ff    	mov    %edi,-0x84(%rbp)
  800055:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800063:	00 00 00 
  800066:	48 ba 44 49 80 00 00 	movabs $0x804944,%rdx
  80006d:	00 00 00 
  800070:	48 89 10             	mov    %rdx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800077:	48 89 c7             	mov    %rax,%rdi
  80007a:	48 b8 00 3c 80 00 00 	movabs $0x803c00,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008d:	79 30                	jns    8000bf <umain+0x7b>
		panic("pipe: %e", i);
  80008f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800092:	89 c1                	mov    %eax,%ecx
  800094:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  80009b:	00 00 00 
  80009e:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a3:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  8000aa:	00 00 00 
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8000b9:	00 00 00 
  8000bc:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000bf:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8000c6:	00 00 00 
  8000c9:	ff d0                	callq  *%rax
  8000cb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d2:	79 30                	jns    800104 <umain+0xc0>
		panic("fork: %e", i);
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	89 c1                	mov    %eax,%ecx
  8000d9:	48 ba 69 49 80 00 00 	movabs $0x804969,%rdx
  8000e0:	00 00 00 
  8000e3:	be 11 00 00 00       	mov    $0x11,%esi
  8000e8:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  8000ef:	00 00 00 
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8000fe:	00 00 00 
  800101:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800104:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800108:	0f 85 50 01 00 00    	jne    80025e <umain+0x21a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  80010e:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800111:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800118:	00 00 00 
  80011b:	48 8b 00             	mov    (%rax),%rax
  80011e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800124:	89 c6                	mov    %eax,%esi
  800126:	48 bf 72 49 80 00 00 	movabs $0x804972,%rdi
  80012d:	00 00 00 
  800130:	b8 00 00 00 00       	mov    $0x0,%eax
  800135:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  80013c:	00 00 00 
  80013f:	ff d1                	callq  *%rcx
		close(p[1]);
  800141:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800144:	89 c7                	mov    %eax,%edi
  800146:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  80014d:	00 00 00 
  800150:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800152:	8b 55 80             	mov    -0x80(%rbp),%edx
  800155:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80015c:	00 00 00 
  80015f:	48 8b 00             	mov    (%rax),%rax
  800162:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800168:	89 c6                	mov    %eax,%esi
  80016a:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  800171:	00 00 00 
  800174:	b8 00 00 00 00       	mov    $0x0,%eax
  800179:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  800180:	00 00 00 
  800183:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800185:	8b 45 80             	mov    -0x80(%rbp),%eax
  800188:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  80018c:	ba 63 00 00 00       	mov    $0x63,%edx
  800191:	48 89 ce             	mov    %rcx,%rsi
  800194:	89 c7                	mov    %eax,%edi
  800196:	48 b8 bd 2d 80 00 00 	movabs $0x802dbd,%rax
  80019d:	00 00 00 
  8001a0:	ff d0                	callq  *%rax
  8001a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (i < 0)
  8001a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a9:	79 30                	jns    8001db <umain+0x197>
			panic("read: %e", i);
  8001ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ae:	89 c1                	mov    %eax,%ecx
  8001b0:	48 ba ac 49 80 00 00 	movabs $0x8049ac,%rdx
  8001b7:	00 00 00 
  8001ba:	be 19 00 00 00       	mov    $0x19,%esi
  8001bf:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  8001c6:	00 00 00 
  8001c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ce:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8001d5:	00 00 00 
  8001d8:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001de:	48 98                	cltq   
  8001e0:	c6 44 05 90 00       	movb   $0x0,-0x70(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001ec:	00 00 00 
  8001ef:	48 8b 10             	mov    (%rax),%rdx
  8001f2:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8001f6:	48 89 d6             	mov    %rdx,%rsi
  8001f9:	48 89 c7             	mov    %rax,%rdi
  8001fc:	48 b8 3b 15 80 00 00 	movabs $0x80153b,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	85 c0                	test   %eax,%eax
  80020a:	75 1d                	jne    800229 <umain+0x1e5>
			cprintf("\npipe read closed properly\n");
  80020c:	48 bf b5 49 80 00 00 	movabs $0x8049b5,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	48 ba 0f 08 80 00 00 	movabs $0x80080f,%rdx
  800222:	00 00 00 
  800225:	ff d2                	callq  *%rdx
  800227:	eb 24                	jmp    80024d <umain+0x209>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800229:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	89 c6                	mov    %eax,%esi
  800232:	48 bf d1 49 80 00 00 	movabs $0x8049d1,%rdi
  800239:	00 00 00 
  80023c:	b8 00 00 00 00       	mov    $0x0,%eax
  800241:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  800248:	00 00 00 
  80024b:	ff d1                	callq  *%rcx
		exit();
  80024d:	48 b8 b0 05 80 00 00 	movabs $0x8005b0,%rax
  800254:	00 00 00 
  800257:	ff d0                	callq  *%rax
  800259:	e9 1c 01 00 00       	jmpq   80037a <umain+0x336>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80025e:	8b 55 80             	mov    -0x80(%rbp),%edx
  800261:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800268:	00 00 00 
  80026b:	48 8b 00             	mov    (%rax),%rax
  80026e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800274:	89 c6                	mov    %eax,%esi
  800276:	48 bf 72 49 80 00 00 	movabs $0x804972,%rdi
  80027d:	00 00 00 
  800280:	b8 00 00 00 00       	mov    $0x0,%eax
  800285:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  80028c:	00 00 00 
  80028f:	ff d1                	callq  *%rcx
		close(p[0]);
  800291:	8b 45 80             	mov    -0x80(%rbp),%eax
  800294:	89 c7                	mov    %eax,%edi
  800296:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002a2:	8b 55 84             	mov    -0x7c(%rbp),%edx
  8002a5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ac:	00 00 00 
  8002af:	48 8b 00             	mov    (%rax),%rax
  8002b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002b8:	89 c6                	mov    %eax,%esi
  8002ba:	48 bf e4 49 80 00 00 	movabs $0x8049e4,%rdi
  8002c1:	00 00 00 
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  8002d0:	00 00 00 
  8002d3:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002dc:	00 00 00 
  8002df:	48 8b 00             	mov    (%rax),%rax
  8002e2:	48 89 c7             	mov    %rax,%rdi
  8002e5:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
  8002f1:	48 63 d0             	movslq %eax,%rdx
  8002f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002fb:	00 00 00 
  8002fe:	48 8b 08             	mov    (%rax),%rcx
  800301:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800304:	48 89 ce             	mov    %rcx,%rsi
  800307:	89 c7                	mov    %eax,%edi
  800309:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
  800315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800318:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80031f:	00 00 00 
  800322:	48 8b 00             	mov    (%rax),%rax
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  80032f:	00 00 00 
  800332:	ff d0                	callq  *%rax
  800334:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800337:	74 30                	je     800369 <umain+0x325>
			panic("write: %e", i);
  800339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033c:	89 c1                	mov    %eax,%ecx
  80033e:	48 ba 01 4a 80 00 00 	movabs $0x804a01,%rdx
  800345:	00 00 00 
  800348:	be 25 00 00 00       	mov    $0x25,%esi
  80034d:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  800354:	00 00 00 
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  800363:	00 00 00 
  800366:	41 ff d0             	callq  *%r8
		close(p[1]);
  800369:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80036c:	89 c7                	mov    %eax,%edi
  80036e:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
	}
	wait(pid);
  80037a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037d:	89 c7                	mov    %eax,%edi
  80037f:	48 b8 c8 41 80 00 00 	movabs $0x8041c8,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  80038b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800392:	00 00 00 
  800395:	48 ba 0b 4a 80 00 00 	movabs $0x804a0b,%rdx
  80039c:	00 00 00 
  80039f:	48 89 10             	mov    %rdx,(%rax)
	if ((i = pipe(p)) < 0)
  8003a2:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003a6:	48 89 c7             	mov    %rax,%rdi
  8003a9:	48 b8 00 3c 80 00 00 	movabs $0x803c00,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
  8003b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bc:	79 30                	jns    8003ee <umain+0x3aa>
		panic("pipe: %e", i);
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	89 c1                	mov    %eax,%ecx
  8003c3:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  8003ca:	00 00 00 
  8003cd:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003d2:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  8003d9:	00 00 00 
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e1:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8003e8:	00 00 00 
  8003eb:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8003ee:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
  8003fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800401:	79 30                	jns    800433 <umain+0x3ef>
		panic("fork: %e", i);
  800403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800406:	89 c1                	mov    %eax,%ecx
  800408:	48 ba 69 49 80 00 00 	movabs $0x804969,%rdx
  80040f:	00 00 00 
  800412:	be 2f 00 00 00       	mov    $0x2f,%esi
  800417:	48 bf 59 49 80 00 00 	movabs $0x804959,%rdi
  80041e:	00 00 00 
  800421:	b8 00 00 00 00       	mov    $0x0,%eax
  800426:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80042d:	00 00 00 
  800430:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800433:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800437:	75 7c                	jne    8004b5 <umain+0x471>
		close(p[0]);
  800439:	8b 45 80             	mov    -0x80(%rbp),%eax
  80043c:	89 c7                	mov    %eax,%edi
  80043e:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	eb 01                	jmp    80044d <umain+0x409>
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  80044c:	90                   	nop
		panic("fork: %e", i);

	if (pid == 0) {
		close(p[0]);
		while (1) {
			cprintf(".");
  80044d:	48 bf 18 4a 80 00 00 	movabs $0x804a18,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	48 ba 0f 08 80 00 00 	movabs $0x80080f,%rdx
  800463:	00 00 00 
  800466:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  800468:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80046b:	ba 01 00 00 00       	mov    $0x1,%edx
  800470:	48 be 1a 4a 80 00 00 	movabs $0x804a1a,%rsi
  800477:	00 00 00 
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
  800488:	83 f8 01             	cmp    $0x1,%eax
  80048b:	74 bf                	je     80044c <umain+0x408>
				break;
  80048d:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  80048e:	48 bf 1c 4a 80 00 00 	movabs $0x804a1c,%rdi
  800495:	00 00 00 
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	48 ba 0f 08 80 00 00 	movabs $0x80080f,%rdx
  8004a4:	00 00 00 
  8004a7:	ff d2                	callq  *%rdx
		exit();
  8004a9:	48 b8 b0 05 80 00 00 	movabs $0x8005b0,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
	}
	close(p[0]);
  8004b5:	8b 45 80             	mov    -0x80(%rbp),%eax
  8004b8:	89 c7                	mov    %eax,%edi
  8004ba:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
	close(p[1]);
  8004c6:	8b 45 84             	mov    -0x7c(%rbp),%eax
  8004c9:	89 c7                	mov    %eax,%edi
  8004cb:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
	wait(pid);
  8004d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 c8 41 80 00 00 	movabs $0x8041c8,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  8004e8:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  8004ef:	00 00 00 
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	48 ba 0f 08 80 00 00 	movabs $0x80080f,%rdx
  8004fe:	00 00 00 
  800501:	ff d2                	callq  *%rdx
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   
  800505:	00 00                	add    %al,(%rax)
	...

0000000000800508 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 10          	sub    $0x10,%rsp
  800510:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800513:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800517:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80051e:	00 00 00 
  800521:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800528:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
  800534:	48 98                	cltq   
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80053f:	48 89 d0             	mov    %rdx,%rax
  800542:	48 c1 e0 02          	shl    $0x2,%rax
  800546:	48 01 d0             	add    %rdx,%rax
  800549:	48 01 c0             	add    %rax,%rax
  80054c:	48 01 d0             	add    %rdx,%rax
  80054f:	48 c1 e0 05          	shl    $0x5,%rax
  800553:	48 89 c2             	mov    %rax,%rdx
  800556:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80055d:	00 00 00 
  800560:	48 01 c2             	add    %rax,%rdx
  800563:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80056a:	00 00 00 
  80056d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800574:	7e 14                	jle    80058a <libmain+0x82>
		binaryname = argv[0];
  800576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057a:	48 8b 10             	mov    (%rax),%rdx
  80057d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800584:	00 00 00 
  800587:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80058a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80058e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800591:	48 89 d6             	mov    %rdx,%rsi
  800594:	89 c7                	mov    %eax,%edi
  800596:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80059d:	00 00 00 
  8005a0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005a2:	48 b8 b0 05 80 00 00 	movabs $0x8005b0,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005b4:	48 b8 0d 2b 80 00 00 	movabs $0x802b0d,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c5:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
}
  8005d1:	5d                   	pop    %rbp
  8005d2:	c3                   	retq   
	...

00000000008005d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	53                   	push   %rbx
  8005d9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005e0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005e7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005ed:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005f4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005fb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800602:	84 c0                	test   %al,%al
  800604:	74 23                	je     800629 <_panic+0x55>
  800606:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80060d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800611:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800615:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800619:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80061d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800621:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800625:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800629:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800630:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800637:	00 00 00 
  80063a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800641:	00 00 00 
  800644:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800648:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80064f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800656:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80065d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800664:	00 00 00 
  800667:	48 8b 18             	mov    (%rax),%rbx
  80066a:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
  800676:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80067c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800683:	41 89 c8             	mov    %ecx,%r8d
  800686:	48 89 d1             	mov    %rdx,%rcx
  800689:	48 89 da             	mov    %rbx,%rdx
  80068c:	89 c6                	mov    %eax,%esi
  80068e:	48 bf 58 4a 80 00 00 	movabs $0x804a58,%rdi
  800695:	00 00 00 
  800698:	b8 00 00 00 00       	mov    $0x0,%eax
  80069d:	49 b9 0f 08 80 00 00 	movabs $0x80080f,%r9
  8006a4:	00 00 00 
  8006a7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006aa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006b1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006b8:	48 89 d6             	mov    %rdx,%rsi
  8006bb:	48 89 c7             	mov    %rax,%rdi
  8006be:	48 b8 63 07 80 00 00 	movabs $0x800763,%rax
  8006c5:	00 00 00 
  8006c8:	ff d0                	callq  *%rax
	cprintf("\n");
  8006ca:	48 bf 7b 4a 80 00 00 	movabs $0x804a7b,%rdi
  8006d1:	00 00 00 
  8006d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d9:	48 ba 0f 08 80 00 00 	movabs $0x80080f,%rdx
  8006e0:	00 00 00 
  8006e3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006e5:	cc                   	int3   
  8006e6:	eb fd                	jmp    8006e5 <_panic+0x111>

00000000008006e8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006e8:	55                   	push   %rbp
  8006e9:	48 89 e5             	mov    %rsp,%rbp
  8006ec:	48 83 ec 10          	sub    $0x10,%rsp
  8006f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800700:	89 d6                	mov    %edx,%esi
  800702:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800706:	48 63 d0             	movslq %eax,%rdx
  800709:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80070e:	8d 50 01             	lea    0x1(%rax),%edx
  800711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800715:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800722:	75 2c                	jne    800750 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800728:	8b 00                	mov    (%rax),%eax
  80072a:	48 98                	cltq   
  80072c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800730:	48 83 c2 08          	add    $0x8,%rdx
  800734:	48 89 c6             	mov    %rax,%rsi
  800737:	48 89 d7             	mov    %rdx,%rdi
  80073a:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  800741:	00 00 00 
  800744:	ff d0                	callq  *%rax
        b->idx = 0;
  800746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80074a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800754:	8b 40 04             	mov    0x4(%rax),%eax
  800757:	8d 50 01             	lea    0x1(%rax),%edx
  80075a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80075e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800761:	c9                   	leaveq 
  800762:	c3                   	retq   

0000000000800763 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800763:	55                   	push   %rbp
  800764:	48 89 e5             	mov    %rsp,%rbp
  800767:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80076e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800775:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80077c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800783:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80078a:	48 8b 0a             	mov    (%rdx),%rcx
  80078d:	48 89 08             	mov    %rcx,(%rax)
  800790:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800794:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800798:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80079c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007a7:	00 00 00 
    b.cnt = 0;
  8007aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007b1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007b4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007bb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007c2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007c9:	48 89 c6             	mov    %rax,%rsi
  8007cc:	48 bf e8 06 80 00 00 	movabs $0x8006e8,%rdi
  8007d3:	00 00 00 
  8007d6:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  8007dd:	00 00 00 
  8007e0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007e2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007e8:	48 98                	cltq   
  8007ea:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007f1:	48 83 c2 08          	add    $0x8,%rdx
  8007f5:	48 89 c6             	mov    %rax,%rsi
  8007f8:	48 89 d7             	mov    %rdx,%rdi
  8007fb:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  800802:	00 00 00 
  800805:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800807:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80080d:	c9                   	leaveq 
  80080e:	c3                   	retq   

000000000080080f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80080f:	55                   	push   %rbp
  800810:	48 89 e5             	mov    %rsp,%rbp
  800813:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80081a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800821:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800828:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80082f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800836:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80083d:	84 c0                	test   %al,%al
  80083f:	74 20                	je     800861 <cprintf+0x52>
  800841:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800845:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800849:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80084d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800851:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800855:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800859:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80085d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800861:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800868:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80086f:	00 00 00 
  800872:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800879:	00 00 00 
  80087c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800880:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800887:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80088e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800895:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80089c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008a3:	48 8b 0a             	mov    (%rdx),%rcx
  8008a6:	48 89 08             	mov    %rcx,(%rax)
  8008a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008b9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008c0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008c7:	48 89 d6             	mov    %rdx,%rsi
  8008ca:	48 89 c7             	mov    %rax,%rdi
  8008cd:	48 b8 63 07 80 00 00 	movabs $0x800763,%rax
  8008d4:	00 00 00 
  8008d7:	ff d0                	callq  *%rax
  8008d9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008df:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008e5:	c9                   	leaveq 
  8008e6:	c3                   	retq   
	...

00000000008008e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	48 83 ec 30          	sub    $0x30,%rsp
  8008f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008fc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008ff:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800903:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800907:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80090a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80090e:	77 52                	ja     800962 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800910:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800913:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800917:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80091a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	48 f7 75 d0          	divq   -0x30(%rbp)
  80092b:	48 89 c2             	mov    %rax,%rdx
  80092e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800931:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800934:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80093c:	41 89 f9             	mov    %edi,%r9d
  80093f:	48 89 c7             	mov    %rax,%rdi
  800942:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800949:	00 00 00 
  80094c:	ff d0                	callq  *%rax
  80094e:	eb 1c                	jmp    80096c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800950:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800954:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800957:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80095b:	48 89 d6             	mov    %rdx,%rsi
  80095e:	89 c7                	mov    %eax,%edi
  800960:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800962:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800966:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80096a:	7f e4                	jg     800950 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80096c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	ba 00 00 00 00       	mov    $0x0,%edx
  800978:	48 f7 f1             	div    %rcx
  80097b:	48 89 d0             	mov    %rdx,%rax
  80097e:	48 ba 70 4c 80 00 00 	movabs $0x804c70,%rdx
  800985:	00 00 00 
  800988:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80098c:	0f be c0             	movsbl %al,%eax
  80098f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800993:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800997:	48 89 d6             	mov    %rdx,%rsi
  80099a:	89 c7                	mov    %eax,%edi
  80099c:	ff d1                	callq  *%rcx
}
  80099e:	c9                   	leaveq 
  80099f:	c3                   	retq   

00000000008009a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009a0:	55                   	push   %rbp
  8009a1:	48 89 e5             	mov    %rsp,%rbp
  8009a4:	48 83 ec 20          	sub    $0x20,%rsp
  8009a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009af:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b3:	7e 52                	jle    800a07 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 24                	jae    8009e4 <getuint+0x44>
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d7:	8b 12                	mov    (%rdx),%edx
  8009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e0:	89 0a                	mov    %ecx,(%rdx)
  8009e2:	eb 17                	jmp    8009fb <getuint+0x5b>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ec:	48 89 d0             	mov    %rdx,%rax
  8009ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fb:	48 8b 00             	mov    (%rax),%rax
  8009fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a02:	e9 a3 00 00 00       	jmpq   800aaa <getuint+0x10a>
	else if (lflag)
  800a07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a0b:	74 4f                	je     800a5c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 24                	jae    800a3c <getuint+0x9c>
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	8b 00                	mov    (%rax),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	8b 12                	mov    (%rdx),%edx
  800a31:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	89 0a                	mov    %ecx,(%rdx)
  800a3a:	eb 17                	jmp    800a53 <getuint+0xb3>
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a44:	48 89 d0             	mov    %rdx,%rax
  800a47:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a53:	48 8b 00             	mov    (%rax),%rax
  800a56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5a:	eb 4e                	jmp    800aaa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	8b 00                	mov    (%rax),%eax
  800a62:	83 f8 30             	cmp    $0x30,%eax
  800a65:	73 24                	jae    800a8b <getuint+0xeb>
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	8b 00                	mov    (%rax),%eax
  800a75:	89 c0                	mov    %eax,%eax
  800a77:	48 01 d0             	add    %rdx,%rax
  800a7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7e:	8b 12                	mov    (%rdx),%edx
  800a80:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a87:	89 0a                	mov    %ecx,(%rdx)
  800a89:	eb 17                	jmp    800aa2 <getuint+0x102>
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a93:	48 89 d0             	mov    %rdx,%rax
  800a96:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa2:	8b 00                	mov    (%rax),%eax
  800aa4:	89 c0                	mov    %eax,%eax
  800aa6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aae:	c9                   	leaveq 
  800aaf:	c3                   	retq   

0000000000800ab0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ab0:	55                   	push   %rbp
  800ab1:	48 89 e5             	mov    %rsp,%rbp
  800ab4:	48 83 ec 20          	sub    $0x20,%rsp
  800ab8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800abc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800abf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ac3:	7e 52                	jle    800b17 <getint+0x67>
		x=va_arg(*ap, long long);
  800ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac9:	8b 00                	mov    (%rax),%eax
  800acb:	83 f8 30             	cmp    $0x30,%eax
  800ace:	73 24                	jae    800af4 <getint+0x44>
  800ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	8b 00                	mov    (%rax),%eax
  800ade:	89 c0                	mov    %eax,%eax
  800ae0:	48 01 d0             	add    %rdx,%rax
  800ae3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae7:	8b 12                	mov    (%rdx),%edx
  800ae9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af0:	89 0a                	mov    %ecx,(%rdx)
  800af2:	eb 17                	jmp    800b0b <getint+0x5b>
  800af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800afc:	48 89 d0             	mov    %rdx,%rax
  800aff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b0b:	48 8b 00             	mov    (%rax),%rax
  800b0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b12:	e9 a3 00 00 00       	jmpq   800bba <getint+0x10a>
	else if (lflag)
  800b17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b1b:	74 4f                	je     800b6c <getint+0xbc>
		x=va_arg(*ap, long);
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	8b 00                	mov    (%rax),%eax
  800b23:	83 f8 30             	cmp    $0x30,%eax
  800b26:	73 24                	jae    800b4c <getint+0x9c>
  800b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b34:	8b 00                	mov    (%rax),%eax
  800b36:	89 c0                	mov    %eax,%eax
  800b38:	48 01 d0             	add    %rdx,%rax
  800b3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3f:	8b 12                	mov    (%rdx),%edx
  800b41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b48:	89 0a                	mov    %ecx,(%rdx)
  800b4a:	eb 17                	jmp    800b63 <getint+0xb3>
  800b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b54:	48 89 d0             	mov    %rdx,%rax
  800b57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b63:	48 8b 00             	mov    (%rax),%rax
  800b66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b6a:	eb 4e                	jmp    800bba <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	8b 00                	mov    (%rax),%eax
  800b72:	83 f8 30             	cmp    $0x30,%eax
  800b75:	73 24                	jae    800b9b <getint+0xeb>
  800b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b83:	8b 00                	mov    (%rax),%eax
  800b85:	89 c0                	mov    %eax,%eax
  800b87:	48 01 d0             	add    %rdx,%rax
  800b8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8e:	8b 12                	mov    (%rdx),%edx
  800b90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b97:	89 0a                	mov    %ecx,(%rdx)
  800b99:	eb 17                	jmp    800bb2 <getint+0x102>
  800b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ba3:	48 89 d0             	mov    %rdx,%rax
  800ba6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bb2:	8b 00                	mov    (%rax),%eax
  800bb4:	48 98                	cltq   
  800bb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bbe:	c9                   	leaveq 
  800bbf:	c3                   	retq   

0000000000800bc0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bc0:	55                   	push   %rbp
  800bc1:	48 89 e5             	mov    %rsp,%rbp
  800bc4:	41 54                	push   %r12
  800bc6:	53                   	push   %rbx
  800bc7:	48 83 ec 60          	sub    $0x60,%rsp
  800bcb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bcf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bd3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bdb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800be3:	48 8b 0a             	mov    (%rdx),%rcx
  800be6:	48 89 08             	mov    %rcx,(%rax)
  800be9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bf1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bf5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf9:	eb 17                	jmp    800c12 <vprintfmt+0x52>
			if (ch == '\0')
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	0f 84 ea 04 00 00    	je     8010ed <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800c03:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c07:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c0b:	48 89 c6             	mov    %rax,%rsi
  800c0e:	89 df                	mov    %ebx,%edi
  800c10:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c12:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c16:	0f b6 00             	movzbl (%rax),%eax
  800c19:	0f b6 d8             	movzbl %al,%ebx
  800c1c:	83 fb 25             	cmp    $0x25,%ebx
  800c1f:	0f 95 c0             	setne  %al
  800c22:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c27:	84 c0                	test   %al,%al
  800c29:	75 d0                	jne    800bfb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c2b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c2f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c36:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c44:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800c4b:	eb 04                	jmp    800c51 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800c4d:	90                   	nop
  800c4e:	eb 01                	jmp    800c51 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800c50:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c55:	0f b6 00             	movzbl (%rax),%eax
  800c58:	0f b6 d8             	movzbl %al,%ebx
  800c5b:	89 d8                	mov    %ebx,%eax
  800c5d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c62:	83 e8 23             	sub    $0x23,%eax
  800c65:	83 f8 55             	cmp    $0x55,%eax
  800c68:	0f 87 4b 04 00 00    	ja     8010b9 <vprintfmt+0x4f9>
  800c6e:	89 c0                	mov    %eax,%eax
  800c70:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c77:	00 
  800c78:	48 b8 98 4c 80 00 00 	movabs $0x804c98,%rax
  800c7f:	00 00 00 
  800c82:	48 01 d0             	add    %rdx,%rax
  800c85:	48 8b 00             	mov    (%rax),%rax
  800c88:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c8a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c8e:	eb c1                	jmp    800c51 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c90:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c94:	eb bb                	jmp    800c51 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c96:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c9d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ca0:	89 d0                	mov    %edx,%eax
  800ca2:	c1 e0 02             	shl    $0x2,%eax
  800ca5:	01 d0                	add    %edx,%eax
  800ca7:	01 c0                	add    %eax,%eax
  800ca9:	01 d8                	add    %ebx,%eax
  800cab:	83 e8 30             	sub    $0x30,%eax
  800cae:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cb1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb5:	0f b6 00             	movzbl (%rax),%eax
  800cb8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cbb:	83 fb 2f             	cmp    $0x2f,%ebx
  800cbe:	7e 63                	jle    800d23 <vprintfmt+0x163>
  800cc0:	83 fb 39             	cmp    $0x39,%ebx
  800cc3:	7f 5e                	jg     800d23 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cca:	eb d1                	jmp    800c9d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ccc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccf:	83 f8 30             	cmp    $0x30,%eax
  800cd2:	73 17                	jae    800ceb <vprintfmt+0x12b>
  800cd4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	89 c0                	mov    %eax,%eax
  800cdd:	48 01 d0             	add    %rdx,%rax
  800ce0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce3:	83 c2 08             	add    $0x8,%edx
  800ce6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce9:	eb 0f                	jmp    800cfa <vprintfmt+0x13a>
  800ceb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cef:	48 89 d0             	mov    %rdx,%rax
  800cf2:	48 83 c2 08          	add    $0x8,%rdx
  800cf6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cfa:	8b 00                	mov    (%rax),%eax
  800cfc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cff:	eb 23                	jmp    800d24 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800d01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d05:	0f 89 42 ff ff ff    	jns    800c4d <vprintfmt+0x8d>
				width = 0;
  800d0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d12:	e9 36 ff ff ff       	jmpq   800c4d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800d17:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d1e:	e9 2e ff ff ff       	jmpq   800c51 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d23:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d28:	0f 89 22 ff ff ff    	jns    800c50 <vprintfmt+0x90>
				width = precision, precision = -1;
  800d2e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d31:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d34:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d3b:	e9 10 ff ff ff       	jmpq   800c50 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d40:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d44:	e9 08 ff ff ff       	jmpq   800c51 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4c:	83 f8 30             	cmp    $0x30,%eax
  800d4f:	73 17                	jae    800d68 <vprintfmt+0x1a8>
  800d51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d58:	89 c0                	mov    %eax,%eax
  800d5a:	48 01 d0             	add    %rdx,%rax
  800d5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d60:	83 c2 08             	add    $0x8,%edx
  800d63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d66:	eb 0f                	jmp    800d77 <vprintfmt+0x1b7>
  800d68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d6c:	48 89 d0             	mov    %rdx,%rax
  800d6f:	48 83 c2 08          	add    $0x8,%rdx
  800d73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d77:	8b 00                	mov    (%rax),%eax
  800d79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d81:	48 89 d6             	mov    %rdx,%rsi
  800d84:	89 c7                	mov    %eax,%edi
  800d86:	ff d1                	callq  *%rcx
			break;
  800d88:	e9 5a 03 00 00       	jmpq   8010e7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d90:	83 f8 30             	cmp    $0x30,%eax
  800d93:	73 17                	jae    800dac <vprintfmt+0x1ec>
  800d95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9c:	89 c0                	mov    %eax,%eax
  800d9e:	48 01 d0             	add    %rdx,%rax
  800da1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800da4:	83 c2 08             	add    $0x8,%edx
  800da7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800daa:	eb 0f                	jmp    800dbb <vprintfmt+0x1fb>
  800dac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db0:	48 89 d0             	mov    %rdx,%rax
  800db3:	48 83 c2 08          	add    $0x8,%rdx
  800db7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dbb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dbd:	85 db                	test   %ebx,%ebx
  800dbf:	79 02                	jns    800dc3 <vprintfmt+0x203>
				err = -err;
  800dc1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dc3:	83 fb 15             	cmp    $0x15,%ebx
  800dc6:	7f 16                	jg     800dde <vprintfmt+0x21e>
  800dc8:	48 b8 c0 4b 80 00 00 	movabs $0x804bc0,%rax
  800dcf:	00 00 00 
  800dd2:	48 63 d3             	movslq %ebx,%rdx
  800dd5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dd9:	4d 85 e4             	test   %r12,%r12
  800ddc:	75 2e                	jne    800e0c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800dde:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de6:	89 d9                	mov    %ebx,%ecx
  800de8:	48 ba 81 4c 80 00 00 	movabs $0x804c81,%rdx
  800def:	00 00 00 
  800df2:	48 89 c7             	mov    %rax,%rdi
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfa:	49 b8 f7 10 80 00 00 	movabs $0x8010f7,%r8
  800e01:	00 00 00 
  800e04:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e07:	e9 db 02 00 00       	jmpq   8010e7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e0c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	4c 89 e1             	mov    %r12,%rcx
  800e17:	48 ba 8a 4c 80 00 00 	movabs $0x804c8a,%rdx
  800e1e:	00 00 00 
  800e21:	48 89 c7             	mov    %rax,%rdi
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	49 b8 f7 10 80 00 00 	movabs $0x8010f7,%r8
  800e30:	00 00 00 
  800e33:	41 ff d0             	callq  *%r8
			break;
  800e36:	e9 ac 02 00 00       	jmpq   8010e7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3e:	83 f8 30             	cmp    $0x30,%eax
  800e41:	73 17                	jae    800e5a <vprintfmt+0x29a>
  800e43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4a:	89 c0                	mov    %eax,%eax
  800e4c:	48 01 d0             	add    %rdx,%rax
  800e4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e52:	83 c2 08             	add    $0x8,%edx
  800e55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e58:	eb 0f                	jmp    800e69 <vprintfmt+0x2a9>
  800e5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e5e:	48 89 d0             	mov    %rdx,%rax
  800e61:	48 83 c2 08          	add    $0x8,%rdx
  800e65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e69:	4c 8b 20             	mov    (%rax),%r12
  800e6c:	4d 85 e4             	test   %r12,%r12
  800e6f:	75 0a                	jne    800e7b <vprintfmt+0x2bb>
				p = "(null)";
  800e71:	49 bc 8d 4c 80 00 00 	movabs $0x804c8d,%r12
  800e78:	00 00 00 
			if (width > 0 && padc != '-')
  800e7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7f:	7e 7a                	jle    800efb <vprintfmt+0x33b>
  800e81:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e85:	74 74                	je     800efb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e87:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e8a:	48 98                	cltq   
  800e8c:	48 89 c6             	mov    %rax,%rsi
  800e8f:	4c 89 e7             	mov    %r12,%rdi
  800e92:	48 b8 a2 13 80 00 00 	movabs $0x8013a2,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	callq  *%rax
  800e9e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ea1:	eb 17                	jmp    800eba <vprintfmt+0x2fa>
					putch(padc, putdat);
  800ea3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ea7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eab:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800eaf:	48 89 d6             	mov    %rdx,%rsi
  800eb2:	89 c7                	mov    %eax,%edi
  800eb4:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ebe:	7f e3                	jg     800ea3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec0:	eb 39                	jmp    800efb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800ec2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ec6:	74 1e                	je     800ee6 <vprintfmt+0x326>
  800ec8:	83 fb 1f             	cmp    $0x1f,%ebx
  800ecb:	7e 05                	jle    800ed2 <vprintfmt+0x312>
  800ecd:	83 fb 7e             	cmp    $0x7e,%ebx
  800ed0:	7e 14                	jle    800ee6 <vprintfmt+0x326>
					putch('?', putdat);
  800ed2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eda:	48 89 c6             	mov    %rax,%rsi
  800edd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ee2:	ff d2                	callq  *%rdx
  800ee4:	eb 0f                	jmp    800ef5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800ee6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800eee:	48 89 c6             	mov    %rax,%rsi
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ef9:	eb 01                	jmp    800efc <vprintfmt+0x33c>
  800efb:	90                   	nop
  800efc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800f01:	0f be d8             	movsbl %al,%ebx
  800f04:	85 db                	test   %ebx,%ebx
  800f06:	0f 95 c0             	setne  %al
  800f09:	49 83 c4 01          	add    $0x1,%r12
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 28                	je     800f39 <vprintfmt+0x379>
  800f11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f15:	78 ab                	js     800ec2 <vprintfmt+0x302>
  800f17:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f1f:	79 a1                	jns    800ec2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f21:	eb 16                	jmp    800f39 <vprintfmt+0x379>
				putch(' ', putdat);
  800f23:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f27:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f2b:	48 89 c6             	mov    %rax,%rsi
  800f2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800f33:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f3d:	7f e4                	jg     800f23 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800f3f:	e9 a3 01 00 00       	jmpq   8010e7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f48:	be 03 00 00 00       	mov    $0x3,%esi
  800f4d:	48 89 c7             	mov    %rax,%rdi
  800f50:	48 b8 b0 0a 80 00 00 	movabs $0x800ab0,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
  800f5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f64:	48 85 c0             	test   %rax,%rax
  800f67:	79 1d                	jns    800f86 <vprintfmt+0x3c6>
				putch('-', putdat);
  800f69:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f6d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f71:	48 89 c6             	mov    %rax,%rsi
  800f74:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f79:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7f:	48 f7 d8             	neg    %rax
  800f82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f8d:	e9 e8 00 00 00       	jmpq   80107a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f96:	be 03 00 00 00       	mov    $0x3,%esi
  800f9b:	48 89 c7             	mov    %rax,%rdi
  800f9e:	48 b8 a0 09 80 00 00 	movabs $0x8009a0,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
  800faa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fb5:	e9 c0 00 00 00       	jmpq   80107a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fba:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fbe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fc2:	48 89 c6             	mov    %rax,%rsi
  800fc5:	bf 58 00 00 00       	mov    $0x58,%edi
  800fca:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800fcc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fd0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fd4:	48 89 c6             	mov    %rax,%rsi
  800fd7:	bf 58 00 00 00       	mov    $0x58,%edi
  800fdc:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800fde:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fe2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fe6:	48 89 c6             	mov    %rax,%rsi
  800fe9:	bf 58 00 00 00       	mov    $0x58,%edi
  800fee:	ff d2                	callq  *%rdx
			break;
  800ff0:	e9 f2 00 00 00       	jmpq   8010e7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800ff5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ff9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ffd:	48 89 c6             	mov    %rax,%rsi
  801000:	bf 30 00 00 00       	mov    $0x30,%edi
  801005:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801007:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80100b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80100f:	48 89 c6             	mov    %rax,%rsi
  801012:	bf 78 00 00 00       	mov    $0x78,%edi
  801017:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801019:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80101c:	83 f8 30             	cmp    $0x30,%eax
  80101f:	73 17                	jae    801038 <vprintfmt+0x478>
  801021:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801025:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801028:	89 c0                	mov    %eax,%eax
  80102a:	48 01 d0             	add    %rdx,%rax
  80102d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801030:	83 c2 08             	add    $0x8,%edx
  801033:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801036:	eb 0f                	jmp    801047 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801038:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80103c:	48 89 d0             	mov    %rdx,%rax
  80103f:	48 83 c2 08          	add    $0x8,%rdx
  801043:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801047:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80104e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801055:	eb 23                	jmp    80107a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801057:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80105b:	be 03 00 00 00       	mov    $0x3,%esi
  801060:	48 89 c7             	mov    %rax,%rdi
  801063:	48 b8 a0 09 80 00 00 	movabs $0x8009a0,%rax
  80106a:	00 00 00 
  80106d:	ff d0                	callq  *%rax
  80106f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801073:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80107a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80107f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801082:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801085:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801089:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80108d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801091:	45 89 c1             	mov    %r8d,%r9d
  801094:	41 89 f8             	mov    %edi,%r8d
  801097:	48 89 c7             	mov    %rax,%rdi
  80109a:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  8010a1:	00 00 00 
  8010a4:	ff d0                	callq  *%rax
			break;
  8010a6:	eb 3f                	jmp    8010e7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010a8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010ac:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010b0:	48 89 c6             	mov    %rax,%rsi
  8010b3:	89 df                	mov    %ebx,%edi
  8010b5:	ff d2                	callq  *%rdx
			break;
  8010b7:	eb 2e                	jmp    8010e7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010bd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010c1:	48 89 c6             	mov    %rax,%rsi
  8010c4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010c9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010cb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d0:	eb 05                	jmp    8010d7 <vprintfmt+0x517>
  8010d2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010db:	48 83 e8 01          	sub    $0x1,%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 ec                	jne    8010d2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e8:	e9 25 fb ff ff       	jmpq   800c12 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8010ed:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010ee:	48 83 c4 60          	add    $0x60,%rsp
  8010f2:	5b                   	pop    %rbx
  8010f3:	41 5c                	pop    %r12
  8010f5:	5d                   	pop    %rbp
  8010f6:	c3                   	retq   

00000000008010f7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f7:	55                   	push   %rbp
  8010f8:	48 89 e5             	mov    %rsp,%rbp
  8010fb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801102:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801109:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801110:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801117:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80111e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801125:	84 c0                	test   %al,%al
  801127:	74 20                	je     801149 <printfmt+0x52>
  801129:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80112d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801131:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801135:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801139:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80113d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801141:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801145:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801149:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801150:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801157:	00 00 00 
  80115a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801161:	00 00 00 
  801164:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801168:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80116f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801176:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80117d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801184:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80118b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801192:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801199:	48 89 c7             	mov    %rax,%rdi
  80119c:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  8011a3:	00 00 00 
  8011a6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011a8:	c9                   	leaveq 
  8011a9:	c3                   	retq   

00000000008011aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011aa:	55                   	push   %rbp
  8011ab:	48 89 e5             	mov    %rsp,%rbp
  8011ae:	48 83 ec 10          	sub    $0x10,%rsp
  8011b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	8b 40 10             	mov    0x10(%rax),%eax
  8011c0:	8d 50 01             	lea    0x1(%rax),%edx
  8011c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ce:	48 8b 10             	mov    (%rax),%rdx
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011d9:	48 39 c2             	cmp    %rax,%rdx
  8011dc:	73 17                	jae    8011f5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e2:	48 8b 00             	mov    (%rax),%rax
  8011e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011e8:	88 10                	mov    %dl,(%rax)
  8011ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 89 10             	mov    %rdx,(%rax)
}
  8011f5:	c9                   	leaveq 
  8011f6:	c3                   	retq   

00000000008011f7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	48 83 ec 50          	sub    $0x50,%rsp
  8011ff:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801203:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801206:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80120a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80120e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801212:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801216:	48 8b 0a             	mov    (%rdx),%rcx
  801219:	48 89 08             	mov    %rcx,(%rax)
  80121c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801220:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801224:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801228:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80122c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801230:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801234:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801237:	48 98                	cltq   
  801239:	48 83 e8 01          	sub    $0x1,%rax
  80123d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801241:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801245:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80124c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801251:	74 06                	je     801259 <vsnprintf+0x62>
  801253:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801257:	7f 07                	jg     801260 <vsnprintf+0x69>
		return -E_INVAL;
  801259:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125e:	eb 2f                	jmp    80128f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801260:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801264:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801268:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80126c:	48 89 c6             	mov    %rax,%rsi
  80126f:	48 bf aa 11 80 00 00 	movabs $0x8011aa,%rdi
  801276:	00 00 00 
  801279:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801285:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801289:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80128c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80128f:	c9                   	leaveq 
  801290:	c3                   	retq   

0000000000801291 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80129c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012a3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012a9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012b0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012b7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012be:	84 c0                	test   %al,%al
  8012c0:	74 20                	je     8012e2 <snprintf+0x51>
  8012c2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012c6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012ca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012ce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012d2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012d6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012da:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012de:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012e2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012e9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012f0:	00 00 00 
  8012f3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012fa:	00 00 00 
  8012fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801301:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801308:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80130f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801316:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80131d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801324:	48 8b 0a             	mov    (%rdx),%rcx
  801327:	48 89 08             	mov    %rcx,(%rax)
  80132a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80132e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801332:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801336:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80133a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801341:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801348:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80134e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801355:	48 89 c7             	mov    %rax,%rdi
  801358:	48 b8 f7 11 80 00 00 	movabs $0x8011f7,%rax
  80135f:	00 00 00 
  801362:	ff d0                	callq  *%rax
  801364:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80136a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801370:	c9                   	leaveq 
  801371:	c3                   	retq   
	...

0000000000801374 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	48 83 ec 18          	sub    $0x18,%rsp
  80137c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801387:	eb 09                	jmp    801392 <strlen+0x1e>
		n++;
  801389:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80138d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	84 c0                	test   %al,%al
  80139b:	75 ec                	jne    801389 <strlen+0x15>
		n++;
	return n;
  80139d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013a0:	c9                   	leaveq 
  8013a1:	c3                   	retq   

00000000008013a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 83 ec 20          	sub    $0x20,%rsp
  8013aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013b9:	eb 0e                	jmp    8013c9 <strnlen+0x27>
		n++;
  8013bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013ce:	74 0b                	je     8013db <strnlen+0x39>
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	84 c0                	test   %al,%al
  8013d9:	75 e0                	jne    8013bb <strnlen+0x19>
		n++;
	return n;
  8013db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013de:	c9                   	leaveq 
  8013df:	c3                   	retq   

00000000008013e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 83 ec 20          	sub    $0x20,%rsp
  8013e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013f8:	90                   	nop
  8013f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013fd:	0f b6 10             	movzbl (%rax),%edx
  801400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801404:	88 10                	mov    %dl,(%rax)
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	84 c0                	test   %al,%al
  80140f:	0f 95 c0             	setne  %al
  801412:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801417:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80141c:	84 c0                	test   %al,%al
  80141e:	75 d9                	jne    8013f9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801424:	c9                   	leaveq 
  801425:	c3                   	retq   

0000000000801426 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801426:	55                   	push   %rbp
  801427:	48 89 e5             	mov    %rsp,%rbp
  80142a:	48 83 ec 20          	sub    $0x20,%rsp
  80142e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801432:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143a:	48 89 c7             	mov    %rax,%rdi
  80143d:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  801444:	00 00 00 
  801447:	ff d0                	callq  *%rax
  801449:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80144c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80144f:	48 98                	cltq   
  801451:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801455:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801459:	48 89 d6             	mov    %rdx,%rsi
  80145c:	48 89 c7             	mov    %rax,%rdi
  80145f:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  801466:	00 00 00 
  801469:	ff d0                	callq  *%rax
	return dst;
  80146b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146f:	c9                   	leaveq 
  801470:	c3                   	retq   

0000000000801471 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	48 83 ec 28          	sub    $0x28,%rsp
  801479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801481:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801489:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80148d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801494:	00 
  801495:	eb 27                	jmp    8014be <strncpy+0x4d>
		*dst++ = *src;
  801497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149b:	0f b6 10             	movzbl (%rax),%edx
  80149e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a2:	88 10                	mov    %dl,(%rax)
  8014a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	84 c0                	test   %al,%al
  8014b2:	74 05                	je     8014b9 <strncpy+0x48>
			src++;
  8014b4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014c6:	72 cf                	jb     801497 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014cc:	c9                   	leaveq 
  8014cd:	c3                   	retq   

00000000008014ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014ce:	55                   	push   %rbp
  8014cf:	48 89 e5             	mov    %rsp,%rbp
  8014d2:	48 83 ec 28          	sub    $0x28,%rsp
  8014d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014ea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ef:	74 37                	je     801528 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8014f1:	eb 17                	jmp    80150a <strlcpy+0x3c>
			*dst++ = *src++;
  8014f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f7:	0f b6 10             	movzbl (%rax),%edx
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	88 10                	mov    %dl,(%rax)
  801500:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801505:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80150a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80150f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801514:	74 0b                	je     801521 <strlcpy+0x53>
  801516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	84 c0                	test   %al,%al
  80151f:	75 d2                	jne    8014f3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801525:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801528:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80152c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801530:	48 89 d1             	mov    %rdx,%rcx
  801533:	48 29 c1             	sub    %rax,%rcx
  801536:	48 89 c8             	mov    %rcx,%rax
}
  801539:	c9                   	leaveq 
  80153a:	c3                   	retq   

000000000080153b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80153b:	55                   	push   %rbp
  80153c:	48 89 e5             	mov    %rsp,%rbp
  80153f:	48 83 ec 10          	sub    $0x10,%rsp
  801543:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801547:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80154b:	eb 0a                	jmp    801557 <strcmp+0x1c>
		p++, q++;
  80154d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801552:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	0f b6 00             	movzbl (%rax),%eax
  80155e:	84 c0                	test   %al,%al
  801560:	74 12                	je     801574 <strcmp+0x39>
  801562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801566:	0f b6 10             	movzbl (%rax),%edx
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	38 c2                	cmp    %al,%dl
  801572:	74 d9                	je     80154d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	0f b6 d0             	movzbl %al,%edx
  80157e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	0f b6 c0             	movzbl %al,%eax
  801588:	89 d1                	mov    %edx,%ecx
  80158a:	29 c1                	sub    %eax,%ecx
  80158c:	89 c8                	mov    %ecx,%eax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 18          	sub    $0x18,%rsp
  801598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015a4:	eb 0f                	jmp    8015b5 <strncmp+0x25>
		n--, p++, q++;
  8015a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ba:	74 1d                	je     8015d9 <strncmp+0x49>
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	84 c0                	test   %al,%al
  8015c5:	74 12                	je     8015d9 <strncmp+0x49>
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 10             	movzbl (%rax),%edx
  8015ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	38 c2                	cmp    %al,%dl
  8015d7:	74 cd                	je     8015a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015de:	75 07                	jne    8015e7 <strncmp+0x57>
		return 0;
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e5:	eb 1a                	jmp    801601 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	0f b6 d0             	movzbl %al,%edx
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	0f b6 c0             	movzbl %al,%eax
  8015fb:	89 d1                	mov    %edx,%ecx
  8015fd:	29 c1                	sub    %eax,%ecx
  8015ff:	89 c8                	mov    %ecx,%eax
}
  801601:	c9                   	leaveq 
  801602:	c3                   	retq   

0000000000801603 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	48 83 ec 10          	sub    $0x10,%rsp
  80160b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801614:	eb 17                	jmp    80162d <strchr+0x2a>
		if (*s == c)
  801616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801620:	75 06                	jne    801628 <strchr+0x25>
			return (char *) s;
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801626:	eb 15                	jmp    80163d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801628:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801631:	0f b6 00             	movzbl (%rax),%eax
  801634:	84 c0                	test   %al,%al
  801636:	75 de                	jne    801616 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163d:	c9                   	leaveq 
  80163e:	c3                   	retq   

000000000080163f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80163f:	55                   	push   %rbp
  801640:	48 89 e5             	mov    %rsp,%rbp
  801643:	48 83 ec 10          	sub    $0x10,%rsp
  801647:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164b:	89 f0                	mov    %esi,%eax
  80164d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801650:	eb 11                	jmp    801663 <strfind+0x24>
		if (*s == c)
  801652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80165c:	74 12                	je     801670 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80165e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	84 c0                	test   %al,%al
  80166c:	75 e4                	jne    801652 <strfind+0x13>
  80166e:	eb 01                	jmp    801671 <strfind+0x32>
		if (*s == c)
			break;
  801670:	90                   	nop
	return (char *) s;
  801671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801675:	c9                   	leaveq 
  801676:	c3                   	retq   

0000000000801677 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801677:	55                   	push   %rbp
  801678:	48 89 e5             	mov    %rsp,%rbp
  80167b:	48 83 ec 18          	sub    $0x18,%rsp
  80167f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801683:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801686:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80168a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168f:	75 06                	jne    801697 <memset+0x20>
		return v;
  801691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801695:	eb 69                	jmp    801700 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169b:	83 e0 03             	and    $0x3,%eax
  80169e:	48 85 c0             	test   %rax,%rax
  8016a1:	75 48                	jne    8016eb <memset+0x74>
  8016a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a7:	83 e0 03             	and    $0x3,%eax
  8016aa:	48 85 c0             	test   %rax,%rax
  8016ad:	75 3c                	jne    8016eb <memset+0x74>
		c &= 0xFF;
  8016af:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	c1 e2 18             	shl    $0x18,%edx
  8016be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c1:	c1 e0 10             	shl    $0x10,%eax
  8016c4:	09 c2                	or     %eax,%edx
  8016c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c9:	c1 e0 08             	shl    $0x8,%eax
  8016cc:	09 d0                	or     %edx,%eax
  8016ce:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d5:	48 89 c1             	mov    %rax,%rcx
  8016d8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e3:	48 89 d7             	mov    %rdx,%rdi
  8016e6:	fc                   	cld    
  8016e7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016e9:	eb 11                	jmp    8016fc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016f6:	48 89 d7             	mov    %rdx,%rdi
  8016f9:	fc                   	cld    
  8016fa:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801700:	c9                   	leaveq 
  801701:	c3                   	retq   

0000000000801702 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801702:	55                   	push   %rbp
  801703:	48 89 e5             	mov    %rsp,%rbp
  801706:	48 83 ec 28          	sub    $0x28,%rsp
  80170a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801712:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801716:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80171a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80172e:	0f 83 88 00 00 00    	jae    8017bc <memmove+0xba>
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173c:	48 01 d0             	add    %rdx,%rax
  80173f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801743:	76 77                	jbe    8017bc <memmove+0xba>
		s += n;
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	83 e0 03             	and    $0x3,%eax
  80175c:	48 85 c0             	test   %rax,%rax
  80175f:	75 3b                	jne    80179c <memmove+0x9a>
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	83 e0 03             	and    $0x3,%eax
  801768:	48 85 c0             	test   %rax,%rax
  80176b:	75 2f                	jne    80179c <memmove+0x9a>
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	83 e0 03             	and    $0x3,%eax
  801774:	48 85 c0             	test   %rax,%rax
  801777:	75 23                	jne    80179c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801779:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177d:	48 83 e8 04          	sub    $0x4,%rax
  801781:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801785:	48 83 ea 04          	sub    $0x4,%rdx
  801789:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80178d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801791:	48 89 c7             	mov    %rax,%rdi
  801794:	48 89 d6             	mov    %rdx,%rsi
  801797:	fd                   	std    
  801798:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80179a:	eb 1d                	jmp    8017b9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80179c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	48 89 d7             	mov    %rdx,%rdi
  8017b3:	48 89 c1             	mov    %rax,%rcx
  8017b6:	fd                   	std    
  8017b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017b9:	fc                   	cld    
  8017ba:	eb 57                	jmp    801813 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c0:	83 e0 03             	and    $0x3,%eax
  8017c3:	48 85 c0             	test   %rax,%rax
  8017c6:	75 36                	jne    8017fe <memmove+0xfc>
  8017c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cc:	83 e0 03             	and    $0x3,%eax
  8017cf:	48 85 c0             	test   %rax,%rax
  8017d2:	75 2a                	jne    8017fe <memmove+0xfc>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	83 e0 03             	and    $0x3,%eax
  8017db:	48 85 c0             	test   %rax,%rax
  8017de:	75 1e                	jne    8017fe <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e4:	48 89 c1             	mov    %rax,%rcx
  8017e7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f3:	48 89 c7             	mov    %rax,%rdi
  8017f6:	48 89 d6             	mov    %rdx,%rsi
  8017f9:	fc                   	cld    
  8017fa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017fc:	eb 15                	jmp    801813 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801802:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801806:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80180a:	48 89 c7             	mov    %rax,%rdi
  80180d:	48 89 d6             	mov    %rdx,%rsi
  801810:	fc                   	cld    
  801811:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801817:	c9                   	leaveq 
  801818:	c3                   	retq   

0000000000801819 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801819:	55                   	push   %rbp
  80181a:	48 89 e5             	mov    %rsp,%rbp
  80181d:	48 83 ec 18          	sub    $0x18,%rsp
  801821:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801825:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801829:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80182d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801831:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801835:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801839:	48 89 ce             	mov    %rcx,%rsi
  80183c:	48 89 c7             	mov    %rax,%rdi
  80183f:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  801846:	00 00 00 
  801849:	ff d0                	callq  *%rax
}
  80184b:	c9                   	leaveq 
  80184c:	c3                   	retq   

000000000080184d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80184d:	55                   	push   %rbp
  80184e:	48 89 e5             	mov    %rsp,%rbp
  801851:	48 83 ec 28          	sub    $0x28,%rsp
  801855:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801859:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80185d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801865:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801869:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801871:	eb 38                	jmp    8018ab <memcmp+0x5e>
		if (*s1 != *s2)
  801873:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801877:	0f b6 10             	movzbl (%rax),%edx
  80187a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187e:	0f b6 00             	movzbl (%rax),%eax
  801881:	38 c2                	cmp    %al,%dl
  801883:	74 1c                	je     8018a1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801889:	0f b6 00             	movzbl (%rax),%eax
  80188c:	0f b6 d0             	movzbl %al,%edx
  80188f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801893:	0f b6 00             	movzbl (%rax),%eax
  801896:	0f b6 c0             	movzbl %al,%eax
  801899:	89 d1                	mov    %edx,%ecx
  80189b:	29 c1                	sub    %eax,%ecx
  80189d:	89 c8                	mov    %ecx,%eax
  80189f:	eb 20                	jmp    8018c1 <memcmp+0x74>
		s1++, s2++;
  8018a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018b0:	0f 95 c0             	setne  %al
  8018b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 b7                	jne    801873 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 28          	sub    $0x28,%rsp
  8018cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018de:	48 01 d0             	add    %rdx,%rax
  8018e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018e5:	eb 13                	jmp    8018fa <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018eb:	0f b6 10             	movzbl (%rax),%edx
  8018ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018f1:	38 c2                	cmp    %al,%dl
  8018f3:	74 11                	je     801906 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018f5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fe:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801902:	72 e3                	jb     8018e7 <memfind+0x24>
  801904:	eb 01                	jmp    801907 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801906:	90                   	nop
	return (void *) s;
  801907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 38          	sub    $0x38,%rsp
  801915:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801919:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80191d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801920:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801927:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80192e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80192f:	eb 05                	jmp    801936 <strtol+0x29>
		s++;
  801931:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	3c 20                	cmp    $0x20,%al
  80193f:	74 f0                	je     801931 <strtol+0x24>
  801941:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801945:	0f b6 00             	movzbl (%rax),%eax
  801948:	3c 09                	cmp    $0x9,%al
  80194a:	74 e5                	je     801931 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80194c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801950:	0f b6 00             	movzbl (%rax),%eax
  801953:	3c 2b                	cmp    $0x2b,%al
  801955:	75 07                	jne    80195e <strtol+0x51>
		s++;
  801957:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195c:	eb 17                	jmp    801975 <strtol+0x68>
	else if (*s == '-')
  80195e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801962:	0f b6 00             	movzbl (%rax),%eax
  801965:	3c 2d                	cmp    $0x2d,%al
  801967:	75 0c                	jne    801975 <strtol+0x68>
		s++, neg = 1;
  801969:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801975:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801979:	74 06                	je     801981 <strtol+0x74>
  80197b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80197f:	75 28                	jne    8019a9 <strtol+0x9c>
  801981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801985:	0f b6 00             	movzbl (%rax),%eax
  801988:	3c 30                	cmp    $0x30,%al
  80198a:	75 1d                	jne    8019a9 <strtol+0x9c>
  80198c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801990:	48 83 c0 01          	add    $0x1,%rax
  801994:	0f b6 00             	movzbl (%rax),%eax
  801997:	3c 78                	cmp    $0x78,%al
  801999:	75 0e                	jne    8019a9 <strtol+0x9c>
		s += 2, base = 16;
  80199b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019a0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019a7:	eb 2c                	jmp    8019d5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ad:	75 19                	jne    8019c8 <strtol+0xbb>
  8019af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b3:	0f b6 00             	movzbl (%rax),%eax
  8019b6:	3c 30                	cmp    $0x30,%al
  8019b8:	75 0e                	jne    8019c8 <strtol+0xbb>
		s++, base = 8;
  8019ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019bf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019c6:	eb 0d                	jmp    8019d5 <strtol+0xc8>
	else if (base == 0)
  8019c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019cc:	75 07                	jne    8019d5 <strtol+0xc8>
		base = 10;
  8019ce:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d9:	0f b6 00             	movzbl (%rax),%eax
  8019dc:	3c 2f                	cmp    $0x2f,%al
  8019de:	7e 1d                	jle    8019fd <strtol+0xf0>
  8019e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e4:	0f b6 00             	movzbl (%rax),%eax
  8019e7:	3c 39                	cmp    $0x39,%al
  8019e9:	7f 12                	jg     8019fd <strtol+0xf0>
			dig = *s - '0';
  8019eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ef:	0f b6 00             	movzbl (%rax),%eax
  8019f2:	0f be c0             	movsbl %al,%eax
  8019f5:	83 e8 30             	sub    $0x30,%eax
  8019f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019fb:	eb 4e                	jmp    801a4b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	0f b6 00             	movzbl (%rax),%eax
  801a04:	3c 60                	cmp    $0x60,%al
  801a06:	7e 1d                	jle    801a25 <strtol+0x118>
  801a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	3c 7a                	cmp    $0x7a,%al
  801a11:	7f 12                	jg     801a25 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	0f be c0             	movsbl %al,%eax
  801a1d:	83 e8 57             	sub    $0x57,%eax
  801a20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a23:	eb 26                	jmp    801a4b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	3c 40                	cmp    $0x40,%al
  801a2e:	7e 47                	jle    801a77 <strtol+0x16a>
  801a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a34:	0f b6 00             	movzbl (%rax),%eax
  801a37:	3c 5a                	cmp    $0x5a,%al
  801a39:	7f 3c                	jg     801a77 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	0f b6 00             	movzbl (%rax),%eax
  801a42:	0f be c0             	movsbl %al,%eax
  801a45:	83 e8 37             	sub    $0x37,%eax
  801a48:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a4e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a51:	7d 23                	jge    801a76 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a53:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a58:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a5b:	48 98                	cltq   
  801a5d:	48 89 c2             	mov    %rax,%rdx
  801a60:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801a65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a68:	48 98                	cltq   
  801a6a:	48 01 d0             	add    %rdx,%rax
  801a6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a71:	e9 5f ff ff ff       	jmpq   8019d5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a76:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a77:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a7c:	74 0b                	je     801a89 <strtol+0x17c>
		*endptr = (char *) s;
  801a7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a86:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a8d:	74 09                	je     801a98 <strtol+0x18b>
  801a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a93:	48 f7 d8             	neg    %rax
  801a96:	eb 04                	jmp    801a9c <strtol+0x18f>
  801a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <strstr>:

char * strstr(const char *in, const char *str)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 30          	sub    $0x30,%rsp
  801aa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aaa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801aae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ab2:	0f b6 00             	movzbl (%rax),%eax
  801ab5:	88 45 ff             	mov    %al,-0x1(%rbp)
  801ab8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801abd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ac1:	75 06                	jne    801ac9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac7:	eb 68                	jmp    801b31 <strstr+0x93>

	len = strlen(str);
  801ac9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801acd:	48 89 c7             	mov    %rax,%rdi
  801ad0:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	callq  *%rax
  801adc:	48 98                	cltq   
  801ade:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ae2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae6:	0f b6 00             	movzbl (%rax),%eax
  801ae9:	88 45 ef             	mov    %al,-0x11(%rbp)
  801aec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801af1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801af5:	75 07                	jne    801afe <strstr+0x60>
				return (char *) 0;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	eb 33                	jmp    801b31 <strstr+0x93>
		} while (sc != c);
  801afe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b02:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b05:	75 db                	jne    801ae2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801b07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b13:	48 89 ce             	mov    %rcx,%rsi
  801b16:	48 89 c7             	mov    %rax,%rdi
  801b19:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
  801b25:	85 c0                	test   %eax,%eax
  801b27:	75 b9                	jne    801ae2 <strstr+0x44>

	return (char *) (in - 1);
  801b29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2d:	48 83 e8 01          	sub    $0x1,%rax
}
  801b31:	c9                   	leaveq 
  801b32:	c3                   	retq   
	...

0000000000801b34 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	53                   	push   %rbx
  801b39:	48 83 ec 58          	sub    $0x58,%rsp
  801b3d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b40:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b43:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b47:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b4b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b4f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b56:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801b59:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b5d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b61:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b65:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b69:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b6d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801b70:	4c 89 c3             	mov    %r8,%rbx
  801b73:	cd 30                	int    $0x30
  801b75:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801b79:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b85:	74 3e                	je     801bc5 <syscall+0x91>
  801b87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b8c:	7e 37                	jle    801bc5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b95:	49 89 d0             	mov    %rdx,%r8
  801b98:	89 c1                	mov    %eax,%ecx
  801b9a:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  801ba1:	00 00 00 
  801ba4:	be 23 00 00 00       	mov    $0x23,%esi
  801ba9:	48 bf 65 4f 80 00 00 	movabs $0x804f65,%rdi
  801bb0:	00 00 00 
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	49 b9 d4 05 80 00 00 	movabs $0x8005d4,%r9
  801bbf:	00 00 00 
  801bc2:	41 ff d1             	callq  *%r9

	return ret;
  801bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bc9:	48 83 c4 58          	add    $0x58,%rsp
  801bcd:	5b                   	pop    %rbx
  801bce:	5d                   	pop    %rbp
  801bcf:	c3                   	retq   

0000000000801bd0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	48 83 ec 20          	sub    $0x20,%rsp
  801bd8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bef:	00 
  801bf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfc:	48 89 d1             	mov    %rdx,%rcx
  801bff:	48 89 c2             	mov    %rax,%rdx
  801c02:	be 00 00 00 00       	mov    $0x0,%esi
  801c07:	bf 00 00 00 00       	mov    $0x0,%edi
  801c0c:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
}
  801c18:	c9                   	leaveq 
  801c19:	c3                   	retq   

0000000000801c1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801c1a:	55                   	push   %rbp
  801c1b:	48 89 e5             	mov    %rsp,%rbp
  801c1e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c29:	00 
  801c2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c40:	be 00 00 00 00       	mov    $0x0,%esi
  801c45:	bf 01 00 00 00       	mov    $0x1,%edi
  801c4a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	callq  *%rax
}
  801c56:	c9                   	leaveq 
  801c57:	c3                   	retq   

0000000000801c58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c58:	55                   	push   %rbp
  801c59:	48 89 e5             	mov    %rsp,%rbp
  801c5c:	48 83 ec 20          	sub    $0x20,%rsp
  801c60:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c66:	48 98                	cltq   
  801c68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6f:	00 
  801c70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c81:	48 89 c2             	mov    %rax,%rdx
  801c84:	be 01 00 00 00       	mov    $0x1,%esi
  801c89:	bf 03 00 00 00       	mov    $0x3,%edi
  801c8e:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ca4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cab:	00 
  801cac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc2:	be 00 00 00 00       	mov    $0x0,%esi
  801cc7:	bf 02 00 00 00       	mov    $0x2,%edi
  801ccc:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_yield>:

void
sys_yield(void)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ce2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce9:	00 
  801cea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	be 00 00 00 00       	mov    $0x0,%esi
  801d05:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d0a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801d11:	00 00 00 
  801d14:	ff d0                	callq  *%rax
}
  801d16:	c9                   	leaveq 
  801d17:	c3                   	retq   

0000000000801d18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d18:	55                   	push   %rbp
  801d19:	48 89 e5             	mov    %rsp,%rbp
  801d1c:	48 83 ec 20          	sub    $0x20,%rsp
  801d20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d27:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2d:	48 63 c8             	movslq %eax,%rcx
  801d30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d37:	48 98                	cltq   
  801d39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d40:	00 
  801d41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d47:	49 89 c8             	mov    %rcx,%r8
  801d4a:	48 89 d1             	mov    %rdx,%rcx
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	be 01 00 00 00       	mov    $0x1,%esi
  801d55:	bf 04 00 00 00       	mov    $0x4,%edi
  801d5a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 30          	sub    $0x30,%rsp
  801d70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d77:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d7e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d85:	48 63 c8             	movslq %eax,%rcx
  801d88:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d8f:	48 63 f0             	movslq %eax,%rsi
  801d92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d99:	48 98                	cltq   
  801d9b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d9f:	49 89 f9             	mov    %rdi,%r9
  801da2:	49 89 f0             	mov    %rsi,%r8
  801da5:	48 89 d1             	mov    %rdx,%rcx
  801da8:	48 89 c2             	mov    %rax,%rdx
  801dab:	be 01 00 00 00       	mov    $0x1,%esi
  801db0:	bf 05 00 00 00       	mov    $0x5,%edi
  801db5:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
}
  801dc1:	c9                   	leaveq 
  801dc2:	c3                   	retq   

0000000000801dc3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dc3:	55                   	push   %rbp
  801dc4:	48 89 e5             	mov    %rsp,%rbp
  801dc7:	48 83 ec 20          	sub    $0x20,%rsp
  801dcb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd9:	48 98                	cltq   
  801ddb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de2:	00 
  801de3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801def:	48 89 d1             	mov    %rdx,%rcx
  801df2:	48 89 c2             	mov    %rax,%rdx
  801df5:	be 01 00 00 00       	mov    $0x1,%esi
  801dfa:	bf 06 00 00 00       	mov    $0x6,%edi
  801dff:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	callq  *%rax
}
  801e0b:	c9                   	leaveq 
  801e0c:	c3                   	retq   

0000000000801e0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e0d:	55                   	push   %rbp
  801e0e:	48 89 e5             	mov    %rsp,%rbp
  801e11:	48 83 ec 20          	sub    $0x20,%rsp
  801e15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e18:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1e:	48 63 d0             	movslq %eax,%rdx
  801e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e24:	48 98                	cltq   
  801e26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e2d:	00 
  801e2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e3a:	48 89 d1             	mov    %rdx,%rcx
  801e3d:	48 89 c2             	mov    %rax,%rdx
  801e40:	be 01 00 00 00       	mov    $0x1,%esi
  801e45:	bf 08 00 00 00       	mov    $0x8,%edi
  801e4a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801e51:	00 00 00 
  801e54:	ff d0                	callq  *%rax
}
  801e56:	c9                   	leaveq 
  801e57:	c3                   	retq   

0000000000801e58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e58:	55                   	push   %rbp
  801e59:	48 89 e5             	mov    %rsp,%rbp
  801e5c:	48 83 ec 20          	sub    $0x20,%rsp
  801e60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6e:	48 98                	cltq   
  801e70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e77:	00 
  801e78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e84:	48 89 d1             	mov    %rdx,%rcx
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	be 01 00 00 00       	mov    $0x1,%esi
  801e8f:	bf 09 00 00 00       	mov    $0x9,%edi
  801e94:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	callq  *%rax
}
  801ea0:	c9                   	leaveq 
  801ea1:	c3                   	retq   

0000000000801ea2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ea2:	55                   	push   %rbp
  801ea3:	48 89 e5             	mov    %rsp,%rbp
  801ea6:	48 83 ec 20          	sub    $0x20,%rsp
  801eaa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ead:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801eb1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb8:	48 98                	cltq   
  801eba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec1:	00 
  801ec2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ece:	48 89 d1             	mov    %rdx,%rcx
  801ed1:	48 89 c2             	mov    %rax,%rdx
  801ed4:	be 01 00 00 00       	mov    $0x1,%esi
  801ed9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ede:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
}
  801eea:	c9                   	leaveq 
  801eeb:	c3                   	retq   

0000000000801eec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 30          	sub    $0x30,%rsp
  801ef4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801efb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801eff:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f05:	48 63 f0             	movslq %eax,%rsi
  801f08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0f:	48 98                	cltq   
  801f11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1c:	00 
  801f1d:	49 89 f1             	mov    %rsi,%r9
  801f20:	49 89 c8             	mov    %rcx,%r8
  801f23:	48 89 d1             	mov    %rdx,%rcx
  801f26:	48 89 c2             	mov    %rax,%rdx
  801f29:	be 00 00 00 00       	mov    $0x0,%esi
  801f2e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f33:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 20          	sub    $0x20,%rsp
  801f49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f58:	00 
  801f59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6a:	48 89 c2             	mov    %rax,%rdx
  801f6d:	be 01 00 00 00       	mov    $0x1,%esi
  801f72:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f77:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f94:	00 
  801f95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fab:	be 00 00 00 00       	mov    $0x0,%esi
  801fb0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801fb5:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 30          	sub    $0x30,%rsp
  801fcb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fd2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801fd5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801fd9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801fdd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fe0:	48 63 c8             	movslq %eax,%rcx
  801fe3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fe7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fea:	48 63 f0             	movslq %eax,%rsi
  801fed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff4:	48 98                	cltq   
  801ff6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ffa:	49 89 f9             	mov    %rdi,%r9
  801ffd:	49 89 f0             	mov    %rsi,%r8
  802000:	48 89 d1             	mov    %rdx,%rcx
  802003:	48 89 c2             	mov    %rax,%rdx
  802006:	be 00 00 00 00       	mov    $0x0,%esi
  80200b:	bf 0f 00 00 00       	mov    $0xf,%edi
  802010:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  802017:	00 00 00 
  80201a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	48 83 ec 20          	sub    $0x20,%rsp
  802026:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80202a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80202e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802036:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80203d:	00 
  80203e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802044:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80204a:	48 89 d1             	mov    %rdx,%rcx
  80204d:	48 89 c2             	mov    %rax,%rdx
  802050:	be 00 00 00 00       	mov    $0x0,%esi
  802055:	bf 10 00 00 00       	mov    $0x10,%edi
  80205a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
}
  802066:	c9                   	leaveq 
  802067:	c3                   	retq   

0000000000802068 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802068:	55                   	push   %rbp
  802069:	48 89 e5             	mov    %rsp,%rbp
  80206c:	48 83 ec 40          	sub    $0x40,%rsp
  802070:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802074:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802078:	48 8b 00             	mov    (%rax),%rax
  80207b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80207f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802083:	48 8b 40 08          	mov    0x8(%rax),%rax
  802087:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  80208a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208e:	48 89 c2             	mov    %rax,%rdx
  802091:	48 c1 ea 0c          	shr    $0xc,%rdx
  802095:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209c:	01 00 00 
  80209f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  8020a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020aa:	83 e0 02             	and    $0x2,%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	0f 84 4f 01 00 00    	je     802204 <pgfault+0x19c>
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	48 89 c2             	mov    %rax,%rdx
  8020bc:	48 c1 ea 0c          	shr    $0xc,%rdx
  8020c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c7:	01 00 00 
  8020ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ce:	25 00 08 00 00       	and    $0x800,%eax
  8020d3:	48 85 c0             	test   %rax,%rax
  8020d6:	0f 84 28 01 00 00    	je     802204 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  8020dc:	ba 07 00 00 00       	mov    $0x7,%edx
  8020e1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020eb:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	0f 85 db 00 00 00    	jne    8021da <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  8020ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802103:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802107:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80210b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802111:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  802115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802119:	ba 00 10 00 00       	mov    $0x1000,%edx
  80211e:	48 89 c6             	mov    %rax,%rsi
  802121:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802126:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  80212d:	00 00 00 
  802130:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80213c:	48 89 c1             	mov    %rax,%rcx
  80213f:	ba 00 00 00 00       	mov    $0x0,%edx
  802144:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802149:	bf 00 00 00 00       	mov    $0x0,%edi
  80214e:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802155:	00 00 00 
  802158:	ff d0                	callq  *%rax
  80215a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  80215d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802161:	79 2a                	jns    80218d <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  802163:	48 ba 78 4f 80 00 00 	movabs $0x804f78,%rdx
  80216a:	00 00 00 
  80216d:	be 28 00 00 00       	mov    $0x28,%esi
  802172:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  802179:	00 00 00 
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  802188:	00 00 00 
  80218b:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  80218d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802192:	bf 00 00 00 00       	mov    $0x0,%edi
  802197:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  8021a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8021aa:	0f 89 84 00 00 00    	jns    802234 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  8021b0:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  8021b7:	00 00 00 
  8021ba:	be 2c 00 00 00       	mov    $0x2c,%esi
  8021bf:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8021c6:	00 00 00 
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  8021d5:	00 00 00 
  8021d8:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  8021da:	48 ba e0 4f 80 00 00 	movabs $0x804fe0,%rdx
  8021e1:	00 00 00 
  8021e4:	be 31 00 00 00       	mov    $0x31,%esi
  8021e9:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8021f0:	00 00 00 
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  8021ff:	00 00 00 
  802202:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802204:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802207:	89 c1                	mov    %eax,%ecx
  802209:	48 ba 0a 50 80 00 00 	movabs $0x80500a,%rdx
  802210:	00 00 00 
  802213:	be 35 00 00 00       	mov    $0x35,%esi
  802218:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80221f:	00 00 00 
  802222:	b8 00 00 00 00       	mov    $0x0,%eax
  802227:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80222e:	00 00 00 
  802231:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  802234:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  802235:	c9                   	leaveq 
  802236:	c3                   	retq   

0000000000802237 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802237:	55                   	push   %rbp
  802238:	48 89 e5             	mov    %rsp,%rbp
  80223b:	48 83 ec 30          	sub    $0x30,%rsp
  80223f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802242:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  802245:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224c:	01 00 00 
  80224f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802252:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802256:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  80225a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80225d:	48 c1 e0 0c          	shl    $0xc,%rax
  802261:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  802265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802269:	25 07 0e 00 00       	and    $0xe07,%eax
  80226e:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  802271:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802274:	25 00 04 00 00       	and    $0x400,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 62                	je     8022df <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  80227d:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802280:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802284:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228b:	41 89 f0             	mov    %esi,%r8d
  80228e:	48 89 c6             	mov    %rax,%rsi
  802291:	bf 00 00 00 00       	mov    $0x0,%edi
  802296:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
  8022a2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8022a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8022a9:	0f 89 78 01 00 00    	jns    802427 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8022af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022b2:	89 c1                	mov    %eax,%ecx
  8022b4:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  8022bb:	00 00 00 
  8022be:	be 4f 00 00 00       	mov    $0x4f,%esi
  8022c3:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8022ca:	00 00 00 
  8022cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d2:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8022d9:	00 00 00 
  8022dc:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  8022df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022e2:	25 00 08 00 00       	and    $0x800,%eax
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	75 0e                	jne    8022f9 <duppage+0xc2>
  8022eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ee:	83 e0 02             	and    $0x2,%eax
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	0f 84 d0 00 00 00    	je     8023c9 <duppage+0x192>
		perm &= ~PTE_W;
  8022f9:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  8022fd:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  802304:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802307:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80230b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80230e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802312:	41 89 f0             	mov    %esi,%r8d
  802315:	48 89 c6             	mov    %rax,%rsi
  802318:	bf 00 00 00 00       	mov    $0x0,%edi
  80231d:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802324:	00 00 00 
  802327:	ff d0                	callq  *%rax
  802329:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80232c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802330:	79 30                	jns    802362 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  802332:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802335:	89 c1                	mov    %eax,%ecx
  802337:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  80233e:	00 00 00 
  802341:	be 57 00 00 00       	mov    $0x57,%esi
  802346:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80234d:	00 00 00 
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
  802355:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80235c:	00 00 00 
  80235f:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802362:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802365:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236d:	41 89 c8             	mov    %ecx,%r8d
  802370:	48 89 d1             	mov    %rdx,%rcx
  802373:	ba 00 00 00 00       	mov    $0x0,%edx
  802378:	48 89 c6             	mov    %rax,%rsi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
  80238c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80238f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802393:	0f 89 8e 00 00 00    	jns    802427 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802399:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80239c:	89 c1                	mov    %eax,%ecx
  80239e:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  8023a5:	00 00 00 
  8023a8:	be 5b 00 00 00       	mov    $0x5b,%esi
  8023ad:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8023b4:	00 00 00 
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bc:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  8023c3:	00 00 00 
  8023c6:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  8023c9:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8023cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8023d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	41 89 f0             	mov    %esi,%r8d
  8023da:	48 89 c6             	mov    %rax,%rsi
  8023dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e2:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
  8023ee:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8023f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8023f5:	79 30                	jns    802427 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8023f7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023fa:	89 c1                	mov    %eax,%ecx
  8023fc:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  802403:	00 00 00 
  802406:	be 61 00 00 00       	mov    $0x61,%esi
  80240b:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  802412:	00 00 00 
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
  80241a:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  802421:	00 00 00 
  802424:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	53                   	push   %rbx
  802433:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  802437:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  80243e:	48 bf 68 20 80 00 00 	movabs $0x802068,%rdi
  802445:	00 00 00 
  802448:	48 b8 28 45 80 00 00 	movabs $0x804528,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802454:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80245b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80245e:	cd 30                	int    $0x30
  802460:	89 c3                	mov    %eax,%ebx
  802462:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802465:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802468:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80246b:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80246f:	79 30                	jns    8024a1 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  802471:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802474:	89 c1                	mov    %eax,%ecx
  802476:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  80247d:	00 00 00 
  802480:	be 80 00 00 00       	mov    $0x80,%esi
  802485:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80248c:	00 00 00 
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80249b:	00 00 00 
  80249e:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  8024a1:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8024a5:	75 52                	jne    8024f9 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  8024a7:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	48 98                	cltq   
  8024b5:	48 89 c2             	mov    %rax,%rdx
  8024b8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8024be:	48 89 d0             	mov    %rdx,%rax
  8024c1:	48 c1 e0 02          	shl    $0x2,%rax
  8024c5:	48 01 d0             	add    %rdx,%rax
  8024c8:	48 01 c0             	add    %rax,%rax
  8024cb:	48 01 d0             	add    %rdx,%rax
  8024ce:	48 c1 e0 05          	shl    $0x5,%rax
  8024d2:	48 89 c2             	mov    %rax,%rdx
  8024d5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024dc:	00 00 00 
  8024df:	48 01 c2             	add    %rax,%rdx
  8024e2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024e9:	00 00 00 
  8024ec:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	e9 9d 02 00 00       	jmpq   802796 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  8024f9:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8024fc:	ba 07 00 00 00       	mov    $0x7,%edx
  802501:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802506:	89 c7                	mov    %eax,%edi
  802508:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax
  802514:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802517:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80251b:	79 30                	jns    80254d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  80251d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802520:	89 c1                	mov    %eax,%ecx
  802522:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  802529:	00 00 00 
  80252c:	be 88 00 00 00       	mov    $0x88,%esi
  802531:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  802538:	00 00 00 
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  802547:	00 00 00 
  80254a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80254d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802554:	00 
	uint64_t each_pte = 0;
  802555:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80255c:	00 
	uint64_t each_pdpe = 0;
  80255d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802564:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802565:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80256c:	00 
  80256d:	e9 73 01 00 00       	jmpq   8026e5 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  802572:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802579:	01 00 00 
  80257c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802580:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802584:	83 e0 01             	and    $0x1,%eax
  802587:	84 c0                	test   %al,%al
  802589:	0f 84 41 01 00 00    	je     8026d0 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80258f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802596:	00 
  802597:	e9 24 01 00 00       	jmpq   8026c0 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  80259c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8025a3:	01 00 00 
  8025a6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8025aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ae:	83 e0 01             	and    $0x1,%eax
  8025b1:	84 c0                	test   %al,%al
  8025b3:	0f 84 ed 00 00 00    	je     8026a6 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8025b9:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8025c0:	00 
  8025c1:	e9 d0 00 00 00       	jmpq   802696 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  8025c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025cd:	01 00 00 
  8025d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d8:	83 e0 01             	and    $0x1,%eax
  8025db:	84 c0                	test   %al,%al
  8025dd:	0f 84 99 00 00 00    	je     80267c <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8025e3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8025ea:	00 
  8025eb:	eb 7f                	jmp    80266c <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  8025ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f4:	01 00 00 
  8025f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ff:	83 e0 01             	and    $0x1,%eax
  802602:	84 c0                	test   %al,%al
  802604:	74 5c                	je     802662 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  802606:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  80260d:	00 
  80260e:	74 52                	je     802662 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802610:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802614:	89 c2                	mov    %eax,%edx
  802616:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802619:	89 d6                	mov    %edx,%esi
  80261b:	89 c7                	mov    %eax,%edi
  80261d:	48 b8 37 22 80 00 00 	movabs $0x802237,%rax
  802624:	00 00 00 
  802627:	ff d0                	callq  *%rax
  802629:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  80262c:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802630:	79 30                	jns    802662 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802632:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802635:	89 c1                	mov    %eax,%ecx
  802637:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  80263e:	00 00 00 
  802641:	be a0 00 00 00       	mov    $0xa0,%esi
  802646:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80264d:	00 00 00 
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80265c:	00 00 00 
  80265f:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802662:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802667:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  80266c:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802673:	00 
  802674:	0f 86 73 ff ff ff    	jbe    8025ed <fork+0x1bf>
  80267a:	eb 10                	jmp    80268c <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  80267c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802680:	48 83 c0 01          	add    $0x1,%rax
  802684:	48 c1 e0 09          	shl    $0x9,%rax
  802688:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80268c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802691:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  802696:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  80269d:	00 
  80269e:	0f 86 22 ff ff ff    	jbe    8025c6 <fork+0x198>
  8026a4:	eb 10                	jmp    8026b6 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  8026a6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8026aa:	48 83 c0 01          	add    $0x1,%rax
  8026ae:	48 c1 e0 09          	shl    $0x9,%rax
  8026b2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8026b6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8026bb:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  8026c0:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8026c7:	00 
  8026c8:	0f 86 ce fe ff ff    	jbe    80259c <fork+0x16e>
  8026ce:	eb 10                	jmp    8026e0 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  8026d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d4:	48 83 c0 01          	add    $0x1,%rax
  8026d8:	48 c1 e0 09          	shl    $0x9,%rax
  8026dc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8026e0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8026e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026ea:	0f 84 82 fe ff ff    	je     802572 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8026f0:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8026f3:	48 be c0 45 80 00 00 	movabs $0x8045c0,%rsi
  8026fa:	00 00 00 
  8026fd:	89 c7                	mov    %eax,%edi
  8026ff:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
  80270b:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80270e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802712:	79 30                	jns    802744 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802714:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802717:	89 c1                	mov    %eax,%ecx
  802719:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  802720:	00 00 00 
  802723:	be bd 00 00 00       	mov    $0xbd,%esi
  802728:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80272f:	00 00 00 
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
  802737:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80273e:	00 00 00 
  802741:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802744:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802747:	be 02 00 00 00       	mov    $0x2,%esi
  80274c:	89 c7                	mov    %eax,%edi
  80274e:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  802755:	00 00 00 
  802758:	ff d0                	callq  *%rax
  80275a:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80275d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802761:	79 30                	jns    802793 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802763:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802766:	89 c1                	mov    %eax,%ecx
  802768:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  80276f:	00 00 00 
  802772:	be c1 00 00 00       	mov    $0xc1,%esi
  802777:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  80277e:	00 00 00 
  802781:	b8 00 00 00 00       	mov    $0x0,%eax
  802786:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  80278d:	00 00 00 
  802790:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  802793:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  802796:	48 83 c4 68          	add    $0x68,%rsp
  80279a:	5b                   	pop    %rbx
  80279b:	5d                   	pop    %rbp
  80279c:	c3                   	retq   

000000000080279d <sfork>:

// Challenge!
int
sfork(void)
{
  80279d:	55                   	push   %rbp
  80279e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8027a1:	48 ba 64 50 80 00 00 	movabs $0x805064,%rdx
  8027a8:	00 00 00 
  8027ab:	be cc 00 00 00       	mov    $0xcc,%esi
  8027b0:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8027b7:	00 00 00 
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  8027c6:	00 00 00 
  8027c9:	ff d1                	callq  *%rcx
	...

00000000008027cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 08          	sub    $0x8,%rsp
  8027d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027dc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027e3:	ff ff ff 
  8027e6:	48 01 d0             	add    %rdx,%rax
  8027e9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027ed:	c9                   	leaveq 
  8027ee:	c3                   	retq   

00000000008027ef <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027ef:	55                   	push   %rbp
  8027f0:	48 89 e5             	mov    %rsp,%rbp
  8027f3:	48 83 ec 08          	sub    $0x8,%rsp
  8027f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ff:	48 89 c7             	mov    %rax,%rdi
  802802:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802814:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 18          	sub    $0x18,%rsp
  802822:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802826:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80282d:	eb 6b                	jmp    80289a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802832:	48 98                	cltq   
  802834:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80283a:	48 c1 e0 0c          	shl    $0xc,%rax
  80283e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802846:	48 89 c2             	mov    %rax,%rdx
  802849:	48 c1 ea 15          	shr    $0x15,%rdx
  80284d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802854:	01 00 00 
  802857:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285b:	83 e0 01             	and    $0x1,%eax
  80285e:	48 85 c0             	test   %rax,%rax
  802861:	74 21                	je     802884 <fd_alloc+0x6a>
  802863:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802867:	48 89 c2             	mov    %rax,%rdx
  80286a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80286e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802875:	01 00 00 
  802878:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287c:	83 e0 01             	and    $0x1,%eax
  80287f:	48 85 c0             	test   %rax,%rax
  802882:	75 12                	jne    802896 <fd_alloc+0x7c>
			*fd_store = fd;
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80288c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	eb 1a                	jmp    8028b0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802896:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80289a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80289e:	7e 8f                	jle    80282f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028ab:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028b0:	c9                   	leaveq 
  8028b1:	c3                   	retq   

00000000008028b2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028b2:	55                   	push   %rbp
  8028b3:	48 89 e5             	mov    %rsp,%rbp
  8028b6:	48 83 ec 20          	sub    $0x20,%rsp
  8028ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028c5:	78 06                	js     8028cd <fd_lookup+0x1b>
  8028c7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028cb:	7e 07                	jle    8028d4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d2:	eb 6c                	jmp    802940 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d7:	48 98                	cltq   
  8028d9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028df:	48 c1 e0 0c          	shl    $0xc,%rax
  8028e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028eb:	48 89 c2             	mov    %rax,%rdx
  8028ee:	48 c1 ea 15          	shr    $0x15,%rdx
  8028f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028f9:	01 00 00 
  8028fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802900:	83 e0 01             	and    $0x1,%eax
  802903:	48 85 c0             	test   %rax,%rax
  802906:	74 21                	je     802929 <fd_lookup+0x77>
  802908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80290c:	48 89 c2             	mov    %rax,%rdx
  80290f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802913:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80291a:	01 00 00 
  80291d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802921:	83 e0 01             	and    $0x1,%eax
  802924:	48 85 c0             	test   %rax,%rax
  802927:	75 07                	jne    802930 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802929:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80292e:	eb 10                	jmp    802940 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802930:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802934:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802938:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802940:	c9                   	leaveq 
  802941:	c3                   	retq   

0000000000802942 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	48 83 ec 30          	sub    $0x30,%rsp
  80294a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80294e:	89 f0                	mov    %esi,%eax
  802950:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802957:	48 89 c7             	mov    %rax,%rdi
  80295a:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
  802966:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80296a:	48 89 d6             	mov    %rdx,%rsi
  80296d:	89 c7                	mov    %eax,%edi
  80296f:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
  80297b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802982:	78 0a                	js     80298e <fd_close+0x4c>
	    || fd != fd2)
  802984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802988:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80298c:	74 12                	je     8029a0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80298e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802992:	74 05                	je     802999 <fd_close+0x57>
  802994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802997:	eb 05                	jmp    80299e <fd_close+0x5c>
  802999:	b8 00 00 00 00       	mov    $0x0,%eax
  80299e:	eb 69                	jmp    802a09 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a4:	8b 00                	mov    (%rax),%eax
  8029a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029aa:	48 89 d6             	mov    %rdx,%rsi
  8029ad:	89 c7                	mov    %eax,%edi
  8029af:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	callq  *%rax
  8029bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c2:	78 2a                	js     8029ee <fd_close+0xac>
		if (dev->dev_close)
  8029c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029cc:	48 85 c0             	test   %rax,%rax
  8029cf:	74 16                	je     8029e7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8029d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8029d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029dd:	48 89 c7             	mov    %rax,%rdi
  8029e0:	ff d2                	callq  *%rdx
  8029e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e5:	eb 07                	jmp    8029ee <fd_close+0xac>
		else
			r = 0;
  8029e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f2:	48 89 c6             	mov    %rax,%rsi
  8029f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fa:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax
	return r;
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a09:	c9                   	leaveq 
  802a0a:	c3                   	retq   

0000000000802a0b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a0b:	55                   	push   %rbp
  802a0c:	48 89 e5             	mov    %rsp,%rbp
  802a0f:	48 83 ec 20          	sub    $0x20,%rsp
  802a13:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a21:	eb 41                	jmp    802a64 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a23:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a2a:	00 00 00 
  802a2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a30:	48 63 d2             	movslq %edx,%rdx
  802a33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a37:	8b 00                	mov    (%rax),%eax
  802a39:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a3c:	75 22                	jne    802a60 <dev_lookup+0x55>
			*dev = devtab[i];
  802a3e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a45:	00 00 00 
  802a48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a4b:	48 63 d2             	movslq %edx,%rdx
  802a4e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a56:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a59:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5e:	eb 60                	jmp    802ac0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a60:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a64:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a6b:	00 00 00 
  802a6e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a71:	48 63 d2             	movslq %edx,%rdx
  802a74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a78:	48 85 c0             	test   %rax,%rax
  802a7b:	75 a6                	jne    802a23 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a7d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a84:	00 00 00 
  802a87:	48 8b 00             	mov    (%rax),%rax
  802a8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a90:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a93:	89 c6                	mov    %eax,%esi
  802a95:	48 bf 80 50 80 00 00 	movabs $0x805080,%rdi
  802a9c:	00 00 00 
  802a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa4:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  802aab:	00 00 00 
  802aae:	ff d1                	callq  *%rcx
	*dev = 0;
  802ab0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802abb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ac0:	c9                   	leaveq 
  802ac1:	c3                   	retq   

0000000000802ac2 <close>:

int
close(int fdnum)
{
  802ac2:	55                   	push   %rbp
  802ac3:	48 89 e5             	mov    %rsp,%rbp
  802ac6:	48 83 ec 20          	sub    $0x20,%rsp
  802aca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802acd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ad4:	48 89 d6             	mov    %rdx,%rsi
  802ad7:	89 c7                	mov    %eax,%edi
  802ad9:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802ae0:	00 00 00 
  802ae3:	ff d0                	callq  *%rax
  802ae5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aec:	79 05                	jns    802af3 <close+0x31>
		return r;
  802aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af1:	eb 18                	jmp    802b0b <close+0x49>
	else
		return fd_close(fd, 1);
  802af3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af7:	be 01 00 00 00       	mov    $0x1,%esi
  802afc:	48 89 c7             	mov    %rax,%rdi
  802aff:	48 b8 42 29 80 00 00 	movabs $0x802942,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	callq  *%rax
}
  802b0b:	c9                   	leaveq 
  802b0c:	c3                   	retq   

0000000000802b0d <close_all>:

void
close_all(void)
{
  802b0d:	55                   	push   %rbp
  802b0e:	48 89 e5             	mov    %rsp,%rbp
  802b11:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b1c:	eb 15                	jmp    802b33 <close_all+0x26>
		close(i);
  802b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b21:	89 c7                	mov    %eax,%edi
  802b23:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b2f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b33:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b37:	7e e5                	jle    802b1e <close_all+0x11>
		close(i);
}
  802b39:	c9                   	leaveq 
  802b3a:	c3                   	retq   

0000000000802b3b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
  802b3f:	48 83 ec 40          	sub    $0x40,%rsp
  802b43:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b46:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b49:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b4d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b50:	48 89 d6             	mov    %rdx,%rsi
  802b53:	89 c7                	mov    %eax,%edi
  802b55:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
  802b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b68:	79 08                	jns    802b72 <dup+0x37>
		return r;
  802b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6d:	e9 70 01 00 00       	jmpq   802ce2 <dup+0x1a7>
	close(newfdnum);
  802b72:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b75:	89 c7                	mov    %eax,%edi
  802b77:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b83:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b86:	48 98                	cltq   
  802b88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b8e:	48 c1 e0 0c          	shl    $0xc,%rax
  802b92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b9a:	48 89 c7             	mov    %rax,%rdi
  802b9d:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
  802ba9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb1:	48 89 c7             	mov    %rax,%rdi
  802bb4:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802bbb:	00 00 00 
  802bbe:	ff d0                	callq  *%rax
  802bc0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	48 89 c2             	mov    %rax,%rdx
  802bcb:	48 c1 ea 15          	shr    $0x15,%rdx
  802bcf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bd6:	01 00 00 
  802bd9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bdd:	83 e0 01             	and    $0x1,%eax
  802be0:	84 c0                	test   %al,%al
  802be2:	74 71                	je     802c55 <dup+0x11a>
  802be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be8:	48 89 c2             	mov    %rax,%rdx
  802beb:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bf6:	01 00 00 
  802bf9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bfd:	83 e0 01             	and    $0x1,%eax
  802c00:	84 c0                	test   %al,%al
  802c02:	74 51                	je     802c55 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c08:	48 89 c2             	mov    %rax,%rdx
  802c0b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c16:	01 00 00 
  802c19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c1d:	89 c1                	mov    %eax,%ecx
  802c1f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802c25:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2d:	41 89 c8             	mov    %ecx,%r8d
  802c30:	48 89 d1             	mov    %rdx,%rcx
  802c33:	ba 00 00 00 00       	mov    $0x0,%edx
  802c38:	48 89 c6             	mov    %rax,%rsi
  802c3b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c40:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	callq  *%rax
  802c4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c53:	78 56                	js     802cab <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c59:	48 89 c2             	mov    %rax,%rdx
  802c5c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c60:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c67:	01 00 00 
  802c6a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c6e:	89 c1                	mov    %eax,%ecx
  802c70:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c7e:	41 89 c8             	mov    %ecx,%r8d
  802c81:	48 89 d1             	mov    %rdx,%rcx
  802c84:	ba 00 00 00 00       	mov    $0x0,%edx
  802c89:	48 89 c6             	mov    %rax,%rsi
  802c8c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c91:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	78 08                	js     802cae <dup+0x173>
		goto err;

	return newfdnum;
  802ca6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ca9:	eb 37                	jmp    802ce2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802cab:	90                   	nop
  802cac:	eb 01                	jmp    802caf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802cae:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb3:	48 89 c6             	mov    %rax,%rsi
  802cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  802cbb:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802cc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ccb:	48 89 c6             	mov    %rax,%rsi
  802cce:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd3:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  802cda:	00 00 00 
  802cdd:	ff d0                	callq  *%rax
	return r;
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ce2:	c9                   	leaveq 
  802ce3:	c3                   	retq   

0000000000802ce4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	48 83 ec 40          	sub    $0x40,%rsp
  802cec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cf3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cf7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cfb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cfe:	48 89 d6             	mov    %rdx,%rsi
  802d01:	89 c7                	mov    %eax,%edi
  802d03:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
  802d0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d16:	78 24                	js     802d3c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1c:	8b 00                	mov    (%rax),%eax
  802d1e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d22:	48 89 d6             	mov    %rdx,%rsi
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
  802d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3a:	79 05                	jns    802d41 <read+0x5d>
		return r;
  802d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3f:	eb 7a                	jmp    802dbb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d45:	8b 40 08             	mov    0x8(%rax),%eax
  802d48:	83 e0 03             	and    $0x3,%eax
  802d4b:	83 f8 01             	cmp    $0x1,%eax
  802d4e:	75 3a                	jne    802d8a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d50:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d57:	00 00 00 
  802d5a:	48 8b 00             	mov    (%rax),%rax
  802d5d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d63:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d66:	89 c6                	mov    %eax,%esi
  802d68:	48 bf 9f 50 80 00 00 	movabs $0x80509f,%rdi
  802d6f:	00 00 00 
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax
  802d77:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  802d7e:	00 00 00 
  802d81:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d88:	eb 31                	jmp    802dbb <read+0xd7>
	}
	if (!dev->dev_read)
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d92:	48 85 c0             	test   %rax,%rax
  802d95:	75 07                	jne    802d9e <read+0xba>
		return -E_NOT_SUPP;
  802d97:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d9c:	eb 1d                	jmp    802dbb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dae:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802db2:	48 89 ce             	mov    %rcx,%rsi
  802db5:	48 89 c7             	mov    %rax,%rdi
  802db8:	41 ff d0             	callq  *%r8
}
  802dbb:	c9                   	leaveq 
  802dbc:	c3                   	retq   

0000000000802dbd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802dbd:	55                   	push   %rbp
  802dbe:	48 89 e5             	mov    %rsp,%rbp
  802dc1:	48 83 ec 30          	sub    $0x30,%rsp
  802dc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dcc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dd7:	eb 46                	jmp    802e1f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802dd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddc:	48 98                	cltq   
  802dde:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802de2:	48 29 c2             	sub    %rax,%rdx
  802de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de8:	48 98                	cltq   
  802dea:	48 89 c1             	mov    %rax,%rcx
  802ded:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802df1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df4:	48 89 ce             	mov    %rcx,%rsi
  802df7:	89 c7                	mov    %eax,%edi
  802df9:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
  802e05:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e08:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e0c:	79 05                	jns    802e13 <readn+0x56>
			return m;
  802e0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e11:	eb 1d                	jmp    802e30 <readn+0x73>
		if (m == 0)
  802e13:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e17:	74 13                	je     802e2c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e1c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e22:	48 98                	cltq   
  802e24:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e28:	72 af                	jb     802dd9 <readn+0x1c>
  802e2a:	eb 01                	jmp    802e2d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802e2c:	90                   	nop
	}
	return tot;
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e30:	c9                   	leaveq 
  802e31:	c3                   	retq   

0000000000802e32 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e32:	55                   	push   %rbp
  802e33:	48 89 e5             	mov    %rsp,%rbp
  802e36:	48 83 ec 40          	sub    $0x40,%rsp
  802e3a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e3d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e41:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e4c:	48 89 d6             	mov    %rdx,%rsi
  802e4f:	89 c7                	mov    %eax,%edi
  802e51:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e64:	78 24                	js     802e8a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6a:	8b 00                	mov    (%rax),%eax
  802e6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e70:	48 89 d6             	mov    %rdx,%rsi
  802e73:	89 c7                	mov    %eax,%edi
  802e75:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
  802e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e88:	79 05                	jns    802e8f <write+0x5d>
		return r;
  802e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8d:	eb 79                	jmp    802f08 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e93:	8b 40 08             	mov    0x8(%rax),%eax
  802e96:	83 e0 03             	and    $0x3,%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	75 3a                	jne    802ed7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e9d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ea4:	00 00 00 
  802ea7:	48 8b 00             	mov    (%rax),%rax
  802eaa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802eb0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802eb3:	89 c6                	mov    %eax,%esi
  802eb5:	48 bf bb 50 80 00 00 	movabs $0x8050bb,%rdi
  802ebc:	00 00 00 
  802ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec4:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  802ecb:	00 00 00 
  802ece:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ed0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ed5:	eb 31                	jmp    802f08 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802edf:	48 85 c0             	test   %rax,%rax
  802ee2:	75 07                	jne    802eeb <write+0xb9>
		return -E_NOT_SUPP;
  802ee4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ee9:	eb 1d                	jmp    802f08 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eef:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802efb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802eff:	48 89 ce             	mov    %rcx,%rsi
  802f02:	48 89 c7             	mov    %rax,%rdi
  802f05:	41 ff d0             	callq  *%r8
}
  802f08:	c9                   	leaveq 
  802f09:	c3                   	retq   

0000000000802f0a <seek>:

int
seek(int fdnum, off_t offset)
{
  802f0a:	55                   	push   %rbp
  802f0b:	48 89 e5             	mov    %rsp,%rbp
  802f0e:	48 83 ec 18          	sub    $0x18,%rsp
  802f12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f15:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f1f:	48 89 d6             	mov    %rdx,%rsi
  802f22:	89 c7                	mov    %eax,%edi
  802f24:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f37:	79 05                	jns    802f3e <seek+0x34>
		return r;
  802f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3c:	eb 0f                	jmp    802f4d <seek+0x43>
	fd->fd_offset = offset;
  802f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f42:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f45:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4d:	c9                   	leaveq 
  802f4e:	c3                   	retq   

0000000000802f4f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f4f:	55                   	push   %rbp
  802f50:	48 89 e5             	mov    %rsp,%rbp
  802f53:	48 83 ec 30          	sub    $0x30,%rsp
  802f57:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f5a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f5d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f64:	48 89 d6             	mov    %rdx,%rsi
  802f67:	89 c7                	mov    %eax,%edi
  802f69:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  802f70:	00 00 00 
  802f73:	ff d0                	callq  *%rax
  802f75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7c:	78 24                	js     802fa2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f82:	8b 00                	mov    (%rax),%eax
  802f84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f88:	48 89 d6             	mov    %rdx,%rsi
  802f8b:	89 c7                	mov    %eax,%edi
  802f8d:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa0:	79 05                	jns    802fa7 <ftruncate+0x58>
		return r;
  802fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa5:	eb 72                	jmp    803019 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fab:	8b 40 08             	mov    0x8(%rax),%eax
  802fae:	83 e0 03             	and    $0x3,%eax
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	75 3a                	jne    802fef <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fb5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802fbc:	00 00 00 
  802fbf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fc2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fc8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fcb:	89 c6                	mov    %eax,%esi
  802fcd:	48 bf d8 50 80 00 00 	movabs $0x8050d8,%rdi
  802fd4:	00 00 00 
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	48 b9 0f 08 80 00 00 	movabs $0x80080f,%rcx
  802fe3:	00 00 00 
  802fe6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fe8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fed:	eb 2a                	jmp    803019 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ff7:	48 85 c0             	test   %rax,%rax
  802ffa:	75 07                	jne    803003 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ffc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803001:	eb 16                	jmp    803019 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803007:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80300b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803012:	89 d6                	mov    %edx,%esi
  803014:	48 89 c7             	mov    %rax,%rdi
  803017:	ff d1                	callq  *%rcx
}
  803019:	c9                   	leaveq 
  80301a:	c3                   	retq   

000000000080301b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80301b:	55                   	push   %rbp
  80301c:	48 89 e5             	mov    %rsp,%rbp
  80301f:	48 83 ec 30          	sub    $0x30,%rsp
  803023:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803026:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80302a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80302e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803031:	48 89 d6             	mov    %rdx,%rsi
  803034:	89 c7                	mov    %eax,%edi
  803036:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803049:	78 24                	js     80306f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80304b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304f:	8b 00                	mov    (%rax),%eax
  803051:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803055:	48 89 d6             	mov    %rdx,%rsi
  803058:	89 c7                	mov    %eax,%edi
  80305a:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
  803066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803069:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306d:	79 05                	jns    803074 <fstat+0x59>
		return r;
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803072:	eb 5e                	jmp    8030d2 <fstat+0xb7>
	if (!dev->dev_stat)
  803074:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803078:	48 8b 40 28          	mov    0x28(%rax),%rax
  80307c:	48 85 c0             	test   %rax,%rax
  80307f:	75 07                	jne    803088 <fstat+0x6d>
		return -E_NOT_SUPP;
  803081:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803086:	eb 4a                	jmp    8030d2 <fstat+0xb7>
	stat->st_name[0] = 0;
  803088:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80308f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803093:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80309a:	00 00 00 
	stat->st_isdir = 0;
  80309d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030a8:	00 00 00 
	stat->st_dev = dev;
  8030ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030be:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8030c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8030ca:	48 89 d6             	mov    %rdx,%rsi
  8030cd:	48 89 c7             	mov    %rax,%rdi
  8030d0:	ff d1                	callq  *%rcx
}
  8030d2:	c9                   	leaveq 
  8030d3:	c3                   	retq   

00000000008030d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030d4:	55                   	push   %rbp
  8030d5:	48 89 e5             	mov    %rsp,%rbp
  8030d8:	48 83 ec 20          	sub    $0x20,%rsp
  8030dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e8:	be 00 00 00 00       	mov    $0x0,%esi
  8030ed:	48 89 c7             	mov    %rax,%rdi
  8030f0:	48 b8 c3 31 80 00 00 	movabs $0x8031c3,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
  8030fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803103:	79 05                	jns    80310a <stat+0x36>
		return fd;
  803105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803108:	eb 2f                	jmp    803139 <stat+0x65>
	r = fstat(fd, stat);
  80310a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80310e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803111:	48 89 d6             	mov    %rdx,%rsi
  803114:	89 c7                	mov    %eax,%edi
  803116:	48 b8 1b 30 80 00 00 	movabs $0x80301b,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803128:	89 c7                	mov    %eax,%edi
  80312a:	48 b8 c2 2a 80 00 00 	movabs $0x802ac2,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
	return r;
  803136:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   
	...

000000000080313c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80313c:	55                   	push   %rbp
  80313d:	48 89 e5             	mov    %rsp,%rbp
  803140:	48 83 ec 10          	sub    $0x10,%rsp
  803144:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803147:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80314b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803152:	00 00 00 
  803155:	8b 00                	mov    (%rax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	75 1d                	jne    803178 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80315b:	bf 01 00 00 00       	mov    $0x1,%edi
  803160:	48 b8 da 47 80 00 00 	movabs $0x8047da,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
  80316c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803173:	00 00 00 
  803176:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803178:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80317f:	00 00 00 
  803182:	8b 00                	mov    (%rax),%eax
  803184:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803187:	b9 07 00 00 00       	mov    $0x7,%ecx
  80318c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803193:	00 00 00 
  803196:	89 c7                	mov    %eax,%edi
  803198:	48 b8 2b 47 80 00 00 	movabs $0x80472b,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ad:	48 89 c6             	mov    %rax,%rsi
  8031b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b5:	48 b8 44 46 80 00 00 	movabs $0x804644,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
}
  8031c1:	c9                   	leaveq 
  8031c2:	c3                   	retq   

00000000008031c3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8031c3:	55                   	push   %rbp
  8031c4:	48 89 e5             	mov    %rsp,%rbp
  8031c7:	48 83 ec 20          	sub    $0x20,%rsp
  8031cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8031d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d6:	48 89 c7             	mov    %rax,%rdi
  8031d9:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  8031e0:	00 00 00 
  8031e3:	ff d0                	callq  *%rax
  8031e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031ea:	7e 0a                	jle    8031f6 <open+0x33>
		return -E_BAD_PATH;
  8031ec:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031f1:	e9 a5 00 00 00       	jmpq   80329b <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8031f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031fa:	48 89 c7             	mov    %rax,%rdi
  8031fd:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
  803209:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80320c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803210:	79 08                	jns    80321a <open+0x57>
		return r;
  803212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803215:	e9 81 00 00 00       	jmpq   80329b <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80321a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803221:	00 00 00 
  803224:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803227:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80322d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803231:	48 89 c6             	mov    %rax,%rsi
  803234:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80323b:	00 00 00 
  80323e:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80324a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324e:	48 89 c6             	mov    %rax,%rsi
  803251:	bf 01 00 00 00       	mov    $0x1,%edi
  803256:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803265:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803269:	79 1d                	jns    803288 <open+0xc5>
		fd_close(new_fd, 0);
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	be 00 00 00 00       	mov    $0x0,%esi
  803274:	48 89 c7             	mov    %rax,%rdi
  803277:	48 b8 42 29 80 00 00 	movabs $0x802942,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
		return r;	
  803283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803286:	eb 13                	jmp    80329b <open+0xd8>
	}
	return fd2num(new_fd);
  803288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328c:	48 89 c7             	mov    %rax,%rdi
  80328f:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 10          	sub    $0x10,%rsp
  8032a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ad:	8b 50 0c             	mov    0xc(%rax),%edx
  8032b0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032b7:	00 00 00 
  8032ba:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032bc:	be 00 00 00 00       	mov    $0x0,%esi
  8032c1:	bf 06 00 00 00       	mov    $0x6,%edi
  8032c6:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
}
  8032d2:	c9                   	leaveq 
  8032d3:	c3                   	retq   

00000000008032d4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032d4:	55                   	push   %rbp
  8032d5:	48 89 e5             	mov    %rsp,%rbp
  8032d8:	48 83 ec 30          	sub    $0x30,%rsp
  8032dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8032e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8032ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032f6:	00 00 00 
  8032f9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032fb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803302:	00 00 00 
  803305:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803309:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  80330d:	be 00 00 00 00       	mov    $0x0,%esi
  803312:	bf 03 00 00 00       	mov    $0x3,%edi
  803317:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
  803323:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  803326:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332a:	7e 23                	jle    80334f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  80332c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332f:	48 63 d0             	movslq %eax,%rdx
  803332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803336:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80333d:	00 00 00 
  803340:	48 89 c7             	mov    %rax,%rdi
  803343:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80334f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803352:	c9                   	leaveq 
  803353:	c3                   	retq   

0000000000803354 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803354:	55                   	push   %rbp
  803355:	48 89 e5             	mov    %rsp,%rbp
  803358:	48 83 ec 20          	sub    $0x20,%rsp
  80335c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803368:	8b 50 0c             	mov    0xc(%rax),%edx
  80336b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803372:	00 00 00 
  803375:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803377:	be 00 00 00 00       	mov    $0x0,%esi
  80337c:	bf 05 00 00 00       	mov    $0x5,%edi
  803381:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
  80338d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803390:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803394:	79 05                	jns    80339b <devfile_stat+0x47>
		return r;
  803396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803399:	eb 56                	jmp    8033f1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80339b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033a6:	00 00 00 
  8033a9:	48 89 c7             	mov    %rax,%rdi
  8033ac:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  8033b3:	00 00 00 
  8033b6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033b8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033bf:	00 00 00 
  8033c2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033cc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033d2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033d9:	00 00 00 
  8033dc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f1:	c9                   	leaveq 
  8033f2:	c3                   	retq   
	...

00000000008033f4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8033f4:	55                   	push   %rbp
  8033f5:	48 89 e5             	mov    %rsp,%rbp
  8033f8:	48 83 ec 20          	sub    $0x20,%rsp
  8033fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8033ff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803403:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803406:	48 89 d6             	mov    %rdx,%rsi
  803409:	89 c7                	mov    %eax,%edi
  80340b:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
  803417:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341e:	79 05                	jns    803425 <fd2sockid+0x31>
		return r;
  803420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803423:	eb 24                	jmp    803449 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803429:	8b 10                	mov    (%rax),%edx
  80342b:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803432:	00 00 00 
  803435:	8b 00                	mov    (%rax),%eax
  803437:	39 c2                	cmp    %eax,%edx
  803439:	74 07                	je     803442 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80343b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803440:	eb 07                	jmp    803449 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803446:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 20          	sub    $0x20,%rsp
  803453:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803456:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80345a:	48 89 c7             	mov    %rax,%rdi
  80345d:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
  803469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803470:	78 26                	js     803498 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803476:	ba 07 04 00 00       	mov    $0x407,%edx
  80347b:	48 89 c6             	mov    %rax,%rsi
  80347e:	bf 00 00 00 00       	mov    $0x0,%edi
  803483:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
  80348f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803496:	79 16                	jns    8034ae <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803498:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349b:	89 c7                	mov    %eax,%edi
  80349d:	48 b8 58 39 80 00 00 	movabs $0x803958,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
		return r;
  8034a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ac:	eb 3a                	jmp    8034e8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8034ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b2:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8034b9:	00 00 00 
  8034bc:	8b 12                	mov    (%rdx),%edx
  8034be:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8034c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034d2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d9:	48 89 c7             	mov    %rax,%rdi
  8034dc:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
}
  8034e8:	c9                   	leaveq 
  8034e9:	c3                   	retq   

00000000008034ea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034ea:	55                   	push   %rbp
  8034eb:	48 89 e5             	mov    %rsp,%rbp
  8034ee:	48 83 ec 30          	sub    $0x30,%rsp
  8034f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803500:	89 c7                	mov    %eax,%edi
  803502:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
  80350e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803515:	79 05                	jns    80351c <accept+0x32>
		return r;
  803517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351a:	eb 3b                	jmp    803557 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80351c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803520:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803527:	48 89 ce             	mov    %rcx,%rsi
  80352a:	89 c7                	mov    %eax,%edi
  80352c:	48 b8 35 38 80 00 00 	movabs $0x803835,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353f:	79 05                	jns    803546 <accept+0x5c>
		return r;
  803541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803544:	eb 11                	jmp    803557 <accept+0x6d>
	return alloc_sockfd(r);
  803546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803549:	89 c7                	mov    %eax,%edi
  80354b:	48 b8 4b 34 80 00 00 	movabs $0x80344b,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
}
  803557:	c9                   	leaveq 
  803558:	c3                   	retq   

0000000000803559 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	48 83 ec 20          	sub    $0x20,%rsp
  803561:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803564:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803568:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80356b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80356e:	89 c7                	mov    %eax,%edi
  803570:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
  80357c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803583:	79 05                	jns    80358a <bind+0x31>
		return r;
  803585:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803588:	eb 1b                	jmp    8035a5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80358a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80358d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803594:	48 89 ce             	mov    %rcx,%rsi
  803597:	89 c7                	mov    %eax,%edi
  803599:	48 b8 b4 38 80 00 00 	movabs $0x8038b4,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
}
  8035a5:	c9                   	leaveq 
  8035a6:	c3                   	retq   

00000000008035a7 <shutdown>:

int
shutdown(int s, int how)
{
  8035a7:	55                   	push   %rbp
  8035a8:	48 89 e5             	mov    %rsp,%rbp
  8035ab:	48 83 ec 20          	sub    $0x20,%rsp
  8035af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035b2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b8:	89 c7                	mov    %eax,%edi
  8035ba:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cd:	79 05                	jns    8035d4 <shutdown+0x2d>
		return r;
  8035cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d2:	eb 16                	jmp    8035ea <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035da:	89 d6                	mov    %edx,%esi
  8035dc:	89 c7                	mov    %eax,%edi
  8035de:	48 b8 18 39 80 00 00 	movabs $0x803918,%rax
  8035e5:	00 00 00 
  8035e8:	ff d0                	callq  *%rax
}
  8035ea:	c9                   	leaveq 
  8035eb:	c3                   	retq   

00000000008035ec <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035ec:	55                   	push   %rbp
  8035ed:	48 89 e5             	mov    %rsp,%rbp
  8035f0:	48 83 ec 10          	sub    $0x10,%rsp
  8035f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8035f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fc:	48 89 c7             	mov    %rax,%rdi
  8035ff:	48 b8 68 48 80 00 00 	movabs $0x804868,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
  80360b:	83 f8 01             	cmp    $0x1,%eax
  80360e:	75 17                	jne    803627 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803614:	8b 40 0c             	mov    0xc(%rax),%eax
  803617:	89 c7                	mov    %eax,%edi
  803619:	48 b8 58 39 80 00 00 	movabs $0x803958,%rax
  803620:	00 00 00 
  803623:	ff d0                	callq  *%rax
  803625:	eb 05                	jmp    80362c <devsock_close+0x40>
	else
		return 0;
  803627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80362c:	c9                   	leaveq 
  80362d:	c3                   	retq   

000000000080362e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80362e:	55                   	push   %rbp
  80362f:	48 89 e5             	mov    %rsp,%rbp
  803632:	48 83 ec 20          	sub    $0x20,%rsp
  803636:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803639:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80363d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803640:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803643:	89 c7                	mov    %eax,%edi
  803645:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803658:	79 05                	jns    80365f <connect+0x31>
		return r;
  80365a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365d:	eb 1b                	jmp    80367a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80365f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803662:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803669:	48 89 ce             	mov    %rcx,%rsi
  80366c:	89 c7                	mov    %eax,%edi
  80366e:	48 b8 85 39 80 00 00 	movabs $0x803985,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <listen>:

int
listen(int s, int backlog)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 20          	sub    $0x20,%rsp
  803684:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803687:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80368a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368d:	89 c7                	mov    %eax,%edi
  80368f:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803696:	00 00 00 
  803699:	ff d0                	callq  *%rax
  80369b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a2:	79 05                	jns    8036a9 <listen+0x2d>
		return r;
  8036a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a7:	eb 16                	jmp    8036bf <listen+0x43>
	return nsipc_listen(r, backlog);
  8036a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036af:	89 d6                	mov    %edx,%esi
  8036b1:	89 c7                	mov    %eax,%edi
  8036b3:	48 b8 e9 39 80 00 00 	movabs $0x8039e9,%rax
  8036ba:	00 00 00 
  8036bd:	ff d0                	callq  *%rax
}
  8036bf:	c9                   	leaveq 
  8036c0:	c3                   	retq   

00000000008036c1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8036c1:	55                   	push   %rbp
  8036c2:	48 89 e5             	mov    %rsp,%rbp
  8036c5:	48 83 ec 20          	sub    $0x20,%rsp
  8036c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d9:	89 c2                	mov    %eax,%edx
  8036db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036df:	8b 40 0c             	mov    0xc(%rax),%eax
  8036e2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036eb:	89 c7                	mov    %eax,%edi
  8036ed:	48 b8 29 3a 80 00 00 	movabs $0x803a29,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
}
  8036f9:	c9                   	leaveq 
  8036fa:	c3                   	retq   

00000000008036fb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036fb:	55                   	push   %rbp
  8036fc:	48 89 e5             	mov    %rsp,%rbp
  8036ff:	48 83 ec 20          	sub    $0x20,%rsp
  803703:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803707:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80370b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80370f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803713:	89 c2                	mov    %eax,%edx
  803715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803719:	8b 40 0c             	mov    0xc(%rax),%eax
  80371c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803720:	b9 00 00 00 00       	mov    $0x0,%ecx
  803725:	89 c7                	mov    %eax,%edi
  803727:	48 b8 f5 3a 80 00 00 	movabs $0x803af5,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
}
  803733:	c9                   	leaveq 
  803734:	c3                   	retq   

0000000000803735 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803735:	55                   	push   %rbp
  803736:	48 89 e5             	mov    %rsp,%rbp
  803739:	48 83 ec 10          	sub    $0x10,%rsp
  80373d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803741:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803749:	48 be 03 51 80 00 00 	movabs $0x805103,%rsi
  803750:	00 00 00 
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
	return 0;
  803762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <socket>:

int
socket(int domain, int type, int protocol)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 20          	sub    $0x20,%rsp
  803771:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803774:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803777:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80377a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80377d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803783:	89 ce                	mov    %ecx,%esi
  803785:	89 c7                	mov    %eax,%edi
  803787:	48 b8 ad 3b 80 00 00 	movabs $0x803bad,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379a:	79 05                	jns    8037a1 <socket+0x38>
		return r;
  80379c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379f:	eb 11                	jmp    8037b2 <socket+0x49>
	return alloc_sockfd(r);
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	89 c7                	mov    %eax,%edi
  8037a6:	48 b8 4b 34 80 00 00 	movabs $0x80344b,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
}
  8037b2:	c9                   	leaveq 
  8037b3:	c3                   	retq   

00000000008037b4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8037b4:	55                   	push   %rbp
  8037b5:	48 89 e5             	mov    %rsp,%rbp
  8037b8:	48 83 ec 10          	sub    $0x10,%rsp
  8037bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8037bf:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8037c6:	00 00 00 
  8037c9:	8b 00                	mov    (%rax),%eax
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	75 1d                	jne    8037ec <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037cf:	bf 02 00 00 00       	mov    $0x2,%edi
  8037d4:	48 b8 da 47 80 00 00 	movabs $0x8047da,%rax
  8037db:	00 00 00 
  8037de:	ff d0                	callq  *%rax
  8037e0:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8037e7:	00 00 00 
  8037ea:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037ec:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8037f3:	00 00 00 
  8037f6:	8b 00                	mov    (%rax),%eax
  8037f8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037fb:	b9 07 00 00 00       	mov    $0x7,%ecx
  803800:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803807:	00 00 00 
  80380a:	89 c7                	mov    %eax,%edi
  80380c:	48 b8 2b 47 80 00 00 	movabs $0x80472b,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803818:	ba 00 00 00 00       	mov    $0x0,%edx
  80381d:	be 00 00 00 00       	mov    $0x0,%esi
  803822:	bf 00 00 00 00       	mov    $0x0,%edi
  803827:	48 b8 44 46 80 00 00 	movabs $0x804644,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
}
  803833:	c9                   	leaveq 
  803834:	c3                   	retq   

0000000000803835 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803835:	55                   	push   %rbp
  803836:	48 89 e5             	mov    %rsp,%rbp
  803839:	48 83 ec 30          	sub    $0x30,%rsp
  80383d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803840:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803844:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803848:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80384f:	00 00 00 
  803852:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803855:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803857:	bf 01 00 00 00       	mov    $0x1,%edi
  80385c:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
  803868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386f:	78 3e                	js     8038af <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803871:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803878:	00 00 00 
  80387b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80387f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803883:	8b 40 10             	mov    0x10(%rax),%eax
  803886:	89 c2                	mov    %eax,%edx
  803888:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80388c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803890:	48 89 ce             	mov    %rcx,%rsi
  803893:	48 89 c7             	mov    %rax,%rdi
  803896:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8038a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a6:	8b 50 10             	mov    0x10(%rax),%edx
  8038a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ad:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8038af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038b2:	c9                   	leaveq 
  8038b3:	c3                   	retq   

00000000008038b4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038b4:	55                   	push   %rbp
  8038b5:	48 89 e5             	mov    %rsp,%rbp
  8038b8:	48 83 ec 10          	sub    $0x10,%rsp
  8038bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038c3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038cd:	00 00 00 
  8038d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038d3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038dc:	48 89 c6             	mov    %rax,%rsi
  8038df:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8038e6:	00 00 00 
  8038e9:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8038f5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038fc:	00 00 00 
  8038ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803902:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803905:	bf 02 00 00 00       	mov    $0x2,%edi
  80390a:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
}
  803916:	c9                   	leaveq 
  803917:	c3                   	retq   

0000000000803918 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803918:	55                   	push   %rbp
  803919:	48 89 e5             	mov    %rsp,%rbp
  80391c:	48 83 ec 10          	sub    $0x10,%rsp
  803920:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803923:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803926:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80392d:	00 00 00 
  803930:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803933:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803935:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80393c:	00 00 00 
  80393f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803942:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803945:	bf 03 00 00 00       	mov    $0x3,%edi
  80394a:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
}
  803956:	c9                   	leaveq 
  803957:	c3                   	retq   

0000000000803958 <nsipc_close>:

int
nsipc_close(int s)
{
  803958:	55                   	push   %rbp
  803959:	48 89 e5             	mov    %rsp,%rbp
  80395c:	48 83 ec 10          	sub    $0x10,%rsp
  803960:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803963:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80396a:	00 00 00 
  80396d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803970:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803972:	bf 04 00 00 00       	mov    $0x4,%edi
  803977:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
}
  803983:	c9                   	leaveq 
  803984:	c3                   	retq   

0000000000803985 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803985:	55                   	push   %rbp
  803986:	48 89 e5             	mov    %rsp,%rbp
  803989:	48 83 ec 10          	sub    $0x10,%rsp
  80398d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803990:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803994:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803997:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80399e:	00 00 00 
  8039a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039a4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8039a6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ad:	48 89 c6             	mov    %rax,%rsi
  8039b0:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039b7:	00 00 00 
  8039ba:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039cd:	00 00 00 
  8039d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039d6:	bf 05 00 00 00       	mov    $0x5,%edi
  8039db:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  8039e2:	00 00 00 
  8039e5:	ff d0                	callq  *%rax
}
  8039e7:	c9                   	leaveq 
  8039e8:	c3                   	retq   

00000000008039e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039e9:	55                   	push   %rbp
  8039ea:	48 89 e5             	mov    %rsp,%rbp
  8039ed:	48 83 ec 10          	sub    $0x10,%rsp
  8039f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8039f7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039fe:	00 00 00 
  803a01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a04:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a0d:	00 00 00 
  803a10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a13:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a16:	bf 06 00 00 00       	mov    $0x6,%edi
  803a1b:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
}
  803a27:	c9                   	leaveq 
  803a28:	c3                   	retq   

0000000000803a29 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a29:	55                   	push   %rbp
  803a2a:	48 89 e5             	mov    %rsp,%rbp
  803a2d:	48 83 ec 30          	sub    $0x30,%rsp
  803a31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a38:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a3b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a3e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a45:	00 00 00 
  803a48:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a4b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a4d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a54:	00 00 00 
  803a57:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a5a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a5d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a64:	00 00 00 
  803a67:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a6a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a6d:	bf 07 00 00 00       	mov    $0x7,%edi
  803a72:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a85:	78 69                	js     803af0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a87:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a8e:	7f 08                	jg     803a98 <nsipc_recv+0x6f>
  803a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a93:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a96:	7e 35                	jle    803acd <nsipc_recv+0xa4>
  803a98:	48 b9 0a 51 80 00 00 	movabs $0x80510a,%rcx
  803a9f:	00 00 00 
  803aa2:	48 ba 1f 51 80 00 00 	movabs $0x80511f,%rdx
  803aa9:	00 00 00 
  803aac:	be 61 00 00 00       	mov    $0x61,%esi
  803ab1:	48 bf 34 51 80 00 00 	movabs $0x805134,%rdi
  803ab8:	00 00 00 
  803abb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac0:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  803ac7:	00 00 00 
  803aca:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad0:	48 63 d0             	movslq %eax,%rdx
  803ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad7:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803ade:	00 00 00 
  803ae1:	48 89 c7             	mov    %rax,%rdi
  803ae4:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
	}

	return r;
  803af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803af3:	c9                   	leaveq 
  803af4:	c3                   	retq   

0000000000803af5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803af5:	55                   	push   %rbp
  803af6:	48 89 e5             	mov    %rsp,%rbp
  803af9:	48 83 ec 20          	sub    $0x20,%rsp
  803afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b04:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b07:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b0a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b11:	00 00 00 
  803b14:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b17:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b19:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b20:	7e 35                	jle    803b57 <nsipc_send+0x62>
  803b22:	48 b9 40 51 80 00 00 	movabs $0x805140,%rcx
  803b29:	00 00 00 
  803b2c:	48 ba 1f 51 80 00 00 	movabs $0x80511f,%rdx
  803b33:	00 00 00 
  803b36:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b3b:	48 bf 34 51 80 00 00 	movabs $0x805134,%rdi
  803b42:	00 00 00 
  803b45:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4a:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  803b51:	00 00 00 
  803b54:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b5a:	48 63 d0             	movslq %eax,%rdx
  803b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b61:	48 89 c6             	mov    %rax,%rsi
  803b64:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803b6b:	00 00 00 
  803b6e:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b7a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b81:	00 00 00 
  803b84:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b87:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b8a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b91:	00 00 00 
  803b94:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b97:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b9a:	bf 08 00 00 00       	mov    $0x8,%edi
  803b9f:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
}
  803bab:	c9                   	leaveq 
  803bac:	c3                   	retq   

0000000000803bad <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803bad:	55                   	push   %rbp
  803bae:	48 89 e5             	mov    %rsp,%rbp
  803bb1:	48 83 ec 10          	sub    $0x10,%rsp
  803bb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bb8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803bbb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803bbe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc5:	00 00 00 
  803bc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bcb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803bcd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd4:	00 00 00 
  803bd7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bda:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bdd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be4:	00 00 00 
  803be7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bea:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803bed:	bf 09 00 00 00       	mov    $0x9,%edi
  803bf2:	48 b8 b4 37 80 00 00 	movabs $0x8037b4,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
}
  803bfe:	c9                   	leaveq 
  803bff:	c3                   	retq   

0000000000803c00 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c00:	55                   	push   %rbp
  803c01:	48 89 e5             	mov    %rsp,%rbp
  803c04:	53                   	push   %rbx
  803c05:	48 83 ec 38          	sub    $0x38,%rsp
  803c09:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c0d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c11:	48 89 c7             	mov    %rax,%rdi
  803c14:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c27:	0f 88 bf 01 00 00    	js     803dec <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c31:	ba 07 04 00 00       	mov    $0x407,%edx
  803c36:	48 89 c6             	mov    %rax,%rsi
  803c39:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3e:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  803c45:	00 00 00 
  803c48:	ff d0                	callq  *%rax
  803c4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c51:	0f 88 95 01 00 00    	js     803dec <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c57:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c5b:	48 89 c7             	mov    %rax,%rdi
  803c5e:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  803c65:	00 00 00 
  803c68:	ff d0                	callq  *%rax
  803c6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c71:	0f 88 5d 01 00 00    	js     803dd4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7b:	ba 07 04 00 00       	mov    $0x407,%edx
  803c80:	48 89 c6             	mov    %rax,%rsi
  803c83:	bf 00 00 00 00       	mov    $0x0,%edi
  803c88:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c97:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c9b:	0f 88 33 01 00 00    	js     803dd4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ca1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca5:	48 89 c7             	mov    %rax,%rdi
  803ca8:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  803caf:	00 00 00 
  803cb2:	ff d0                	callq  *%rax
  803cb4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbc:	ba 07 04 00 00       	mov    $0x407,%edx
  803cc1:	48 89 c6             	mov    %rax,%rsi
  803cc4:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc9:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
  803cd5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cdc:	0f 88 d9 00 00 00    	js     803dbb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ce2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ce6:	48 89 c7             	mov    %rax,%rdi
  803ce9:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	48 89 c2             	mov    %rax,%rdx
  803cf8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cfc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d02:	48 89 d1             	mov    %rdx,%rcx
  803d05:	ba 00 00 00 00       	mov    $0x0,%edx
  803d0a:	48 89 c6             	mov    %rax,%rsi
  803d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d12:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d25:	78 79                	js     803da0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d2b:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d32:	00 00 00 
  803d35:	8b 12                	mov    (%rdx),%edx
  803d37:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d48:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803d4f:	00 00 00 
  803d52:	8b 12                	mov    (%rdx),%edx
  803d54:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d65:	48 89 c7             	mov    %rax,%rdi
  803d68:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
  803d74:	89 c2                	mov    %eax,%edx
  803d76:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d7a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d80:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d88:	48 89 c7             	mov    %rax,%rdi
  803d8b:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  803d92:	00 00 00 
  803d95:	ff d0                	callq  *%rax
  803d97:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d99:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9e:	eb 4f                	jmp    803def <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803da0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da5:	48 89 c6             	mov    %rax,%rsi
  803da8:	bf 00 00 00 00       	mov    $0x0,%edi
  803dad:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  803db4:	00 00 00 
  803db7:	ff d0                	callq  *%rax
  803db9:	eb 01                	jmp    803dbc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803dbb:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803dbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc0:	48 89 c6             	mov    %rax,%rsi
  803dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc8:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803dd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd8:	48 89 c6             	mov    %rax,%rsi
  803ddb:	bf 00 00 00 00       	mov    $0x0,%edi
  803de0:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
err:
	return r;
  803dec:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803def:	48 83 c4 38          	add    $0x38,%rsp
  803df3:	5b                   	pop    %rbx
  803df4:	5d                   	pop    %rbp
  803df5:	c3                   	retq   

0000000000803df6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803df6:	55                   	push   %rbp
  803df7:	48 89 e5             	mov    %rsp,%rbp
  803dfa:	53                   	push   %rbx
  803dfb:	48 83 ec 28          	sub    $0x28,%rsp
  803dff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e07:	eb 01                	jmp    803e0a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803e09:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e0a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e11:	00 00 00 
  803e14:	48 8b 00             	mov    (%rax),%rax
  803e17:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e24:	48 89 c7             	mov    %rax,%rdi
  803e27:	48 b8 68 48 80 00 00 	movabs $0x804868,%rax
  803e2e:	00 00 00 
  803e31:	ff d0                	callq  *%rax
  803e33:	89 c3                	mov    %eax,%ebx
  803e35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e39:	48 89 c7             	mov    %rax,%rdi
  803e3c:	48 b8 68 48 80 00 00 	movabs $0x804868,%rax
  803e43:	00 00 00 
  803e46:	ff d0                	callq  *%rax
  803e48:	39 c3                	cmp    %eax,%ebx
  803e4a:	0f 94 c0             	sete   %al
  803e4d:	0f b6 c0             	movzbl %al,%eax
  803e50:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e53:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e5a:	00 00 00 
  803e5d:	48 8b 00             	mov    (%rax),%rax
  803e60:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e66:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e6c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e6f:	75 0a                	jne    803e7b <_pipeisclosed+0x85>
			return ret;
  803e71:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803e74:	48 83 c4 28          	add    $0x28,%rsp
  803e78:	5b                   	pop    %rbx
  803e79:	5d                   	pop    %rbp
  803e7a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803e7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e7e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e81:	74 86                	je     803e09 <_pipeisclosed+0x13>
  803e83:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e87:	75 80                	jne    803e09 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e89:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e90:	00 00 00 
  803e93:	48 8b 00             	mov    (%rax),%rax
  803e96:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e9c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ea2:	89 c6                	mov    %eax,%esi
  803ea4:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  803eab:	00 00 00 
  803eae:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb3:	49 b8 0f 08 80 00 00 	movabs $0x80080f,%r8
  803eba:	00 00 00 
  803ebd:	41 ff d0             	callq  *%r8
	}
  803ec0:	e9 44 ff ff ff       	jmpq   803e09 <_pipeisclosed+0x13>

0000000000803ec5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803ec5:	55                   	push   %rbp
  803ec6:	48 89 e5             	mov    %rsp,%rbp
  803ec9:	48 83 ec 30          	sub    $0x30,%rsp
  803ecd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ed0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ed4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ed7:	48 89 d6             	mov    %rdx,%rsi
  803eda:	89 c7                	mov    %eax,%edi
  803edc:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  803ee3:	00 00 00 
  803ee6:	ff d0                	callq  *%rax
  803ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eef:	79 05                	jns    803ef6 <pipeisclosed+0x31>
		return r;
  803ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef4:	eb 31                	jmp    803f27 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803efa:	48 89 c7             	mov    %rax,%rdi
  803efd:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  803f04:	00 00 00 
  803f07:	ff d0                	callq  *%rax
  803f09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f15:	48 89 d6             	mov    %rdx,%rsi
  803f18:	48 89 c7             	mov    %rax,%rdi
  803f1b:	48 b8 f6 3d 80 00 00 	movabs $0x803df6,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
}
  803f27:	c9                   	leaveq 
  803f28:	c3                   	retq   

0000000000803f29 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f29:	55                   	push   %rbp
  803f2a:	48 89 e5             	mov    %rsp,%rbp
  803f2d:	48 83 ec 40          	sub    $0x40,%rsp
  803f31:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f35:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f39:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f41:	48 89 c7             	mov    %rax,%rdi
  803f44:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f5c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f63:	00 
  803f64:	e9 97 00 00 00       	jmpq   804000 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f69:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f6e:	74 09                	je     803f79 <devpipe_read+0x50>
				return i;
  803f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f74:	e9 95 00 00 00       	jmpq   80400e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f81:	48 89 d6             	mov    %rdx,%rsi
  803f84:	48 89 c7             	mov    %rax,%rdi
  803f87:	48 b8 f6 3d 80 00 00 	movabs $0x803df6,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
  803f93:	85 c0                	test   %eax,%eax
  803f95:	74 07                	je     803f9e <devpipe_read+0x75>
				return 0;
  803f97:	b8 00 00 00 00       	mov    $0x0,%eax
  803f9c:	eb 70                	jmp    80400e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f9e:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
  803faa:	eb 01                	jmp    803fad <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803fac:	90                   	nop
  803fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb1:	8b 10                	mov    (%rax),%edx
  803fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb7:	8b 40 04             	mov    0x4(%rax),%eax
  803fba:	39 c2                	cmp    %eax,%edx
  803fbc:	74 ab                	je     803f69 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fc6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fce:	8b 00                	mov    (%rax),%eax
  803fd0:	89 c2                	mov    %eax,%edx
  803fd2:	c1 fa 1f             	sar    $0x1f,%edx
  803fd5:	c1 ea 1b             	shr    $0x1b,%edx
  803fd8:	01 d0                	add    %edx,%eax
  803fda:	83 e0 1f             	and    $0x1f,%eax
  803fdd:	29 d0                	sub    %edx,%eax
  803fdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fe3:	48 98                	cltq   
  803fe5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803fea:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff0:	8b 00                	mov    (%rax),%eax
  803ff2:	8d 50 01             	lea    0x1(%rax),%edx
  803ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ffb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804004:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804008:	72 a2                	jb     803fac <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80400a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80400e:	c9                   	leaveq 
  80400f:	c3                   	retq   

0000000000804010 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804010:	55                   	push   %rbp
  804011:	48 89 e5             	mov    %rsp,%rbp
  804014:	48 83 ec 40          	sub    $0x40,%rsp
  804018:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80401c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804020:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804024:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804028:	48 89 c7             	mov    %rax,%rdi
  80402b:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  804032:	00 00 00 
  804035:	ff d0                	callq  *%rax
  804037:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80403b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80403f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804043:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80404a:	00 
  80404b:	e9 93 00 00 00       	jmpq   8040e3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804050:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804054:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804058:	48 89 d6             	mov    %rdx,%rsi
  80405b:	48 89 c7             	mov    %rax,%rdi
  80405e:	48 b8 f6 3d 80 00 00 	movabs $0x803df6,%rax
  804065:	00 00 00 
  804068:	ff d0                	callq  *%rax
  80406a:	85 c0                	test   %eax,%eax
  80406c:	74 07                	je     804075 <devpipe_write+0x65>
				return 0;
  80406e:	b8 00 00 00 00       	mov    $0x0,%eax
  804073:	eb 7c                	jmp    8040f1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804075:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80407c:	00 00 00 
  80407f:	ff d0                	callq  *%rax
  804081:	eb 01                	jmp    804084 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804083:	90                   	nop
  804084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804088:	8b 40 04             	mov    0x4(%rax),%eax
  80408b:	48 63 d0             	movslq %eax,%rdx
  80408e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804092:	8b 00                	mov    (%rax),%eax
  804094:	48 98                	cltq   
  804096:	48 83 c0 20          	add    $0x20,%rax
  80409a:	48 39 c2             	cmp    %rax,%rdx
  80409d:	73 b1                	jae    804050 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80409f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a3:	8b 40 04             	mov    0x4(%rax),%eax
  8040a6:	89 c2                	mov    %eax,%edx
  8040a8:	c1 fa 1f             	sar    $0x1f,%edx
  8040ab:	c1 ea 1b             	shr    $0x1b,%edx
  8040ae:	01 d0                	add    %edx,%eax
  8040b0:	83 e0 1f             	and    $0x1f,%eax
  8040b3:	29 d0                	sub    %edx,%eax
  8040b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8040b9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040bd:	48 01 ca             	add    %rcx,%rdx
  8040c0:	0f b6 0a             	movzbl (%rdx),%ecx
  8040c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040c7:	48 98                	cltq   
  8040c9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d1:	8b 40 04             	mov    0x4(%rax),%eax
  8040d4:	8d 50 01             	lea    0x1(%rax),%edx
  8040d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040db:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040eb:	72 96                	jb     804083 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040f1:	c9                   	leaveq 
  8040f2:	c3                   	retq   

00000000008040f3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040f3:	55                   	push   %rbp
  8040f4:	48 89 e5             	mov    %rsp,%rbp
  8040f7:	48 83 ec 20          	sub    $0x20,%rsp
  8040fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80411a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80411e:	48 be 64 51 80 00 00 	movabs $0x805164,%rsi
  804125:	00 00 00 
  804128:	48 89 c7             	mov    %rax,%rdi
  80412b:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  804132:	00 00 00 
  804135:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413b:	8b 50 04             	mov    0x4(%rax),%edx
  80413e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804142:	8b 00                	mov    (%rax),%eax
  804144:	29 c2                	sub    %eax,%edx
  804146:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80414a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804154:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80415b:	00 00 00 
	stat->st_dev = &devpipe;
  80415e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804162:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804169:	00 00 00 
  80416c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804173:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804178:	c9                   	leaveq 
  804179:	c3                   	retq   

000000000080417a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80417a:	55                   	push   %rbp
  80417b:	48 89 e5             	mov    %rsp,%rbp
  80417e:	48 83 ec 10          	sub    $0x10,%rsp
  804182:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80418a:	48 89 c6             	mov    %rax,%rsi
  80418d:	bf 00 00 00 00       	mov    $0x0,%edi
  804192:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  804199:	00 00 00 
  80419c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80419e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a2:	48 89 c7             	mov    %rax,%rdi
  8041a5:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  8041ac:	00 00 00 
  8041af:	ff d0                	callq  *%rax
  8041b1:	48 89 c6             	mov    %rax,%rsi
  8041b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b9:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8041c0:	00 00 00 
  8041c3:	ff d0                	callq  *%rax
}
  8041c5:	c9                   	leaveq 
  8041c6:	c3                   	retq   
	...

00000000008041c8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8041c8:	55                   	push   %rbp
  8041c9:	48 89 e5             	mov    %rsp,%rbp
  8041cc:	48 83 ec 20          	sub    $0x20,%rsp
  8041d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8041d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041d7:	75 35                	jne    80420e <wait+0x46>
  8041d9:	48 b9 6b 51 80 00 00 	movabs $0x80516b,%rcx
  8041e0:	00 00 00 
  8041e3:	48 ba 76 51 80 00 00 	movabs $0x805176,%rdx
  8041ea:	00 00 00 
  8041ed:	be 09 00 00 00       	mov    $0x9,%esi
  8041f2:	48 bf 8b 51 80 00 00 	movabs $0x80518b,%rdi
  8041f9:	00 00 00 
  8041fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804201:	49 b8 d4 05 80 00 00 	movabs $0x8005d4,%r8
  804208:	00 00 00 
  80420b:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80420e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804211:	48 98                	cltq   
  804213:	48 89 c2             	mov    %rax,%rdx
  804216:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80421c:	48 89 d0             	mov    %rdx,%rax
  80421f:	48 c1 e0 02          	shl    $0x2,%rax
  804223:	48 01 d0             	add    %rdx,%rax
  804226:	48 01 c0             	add    %rax,%rax
  804229:	48 01 d0             	add    %rdx,%rax
  80422c:	48 c1 e0 05          	shl    $0x5,%rax
  804230:	48 89 c2             	mov    %rax,%rdx
  804233:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80423a:	00 00 00 
  80423d:	48 01 d0             	add    %rdx,%rax
  804240:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804244:	eb 0c                	jmp    804252 <wait+0x8a>
		sys_yield();
  804246:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80424d:	00 00 00 
  804250:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804256:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80425c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80425f:	75 0e                	jne    80426f <wait+0xa7>
  804261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804265:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80426b:	85 c0                	test   %eax,%eax
  80426d:	75 d7                	jne    804246 <wait+0x7e>
		sys_yield();
}
  80426f:	c9                   	leaveq 
  804270:	c3                   	retq   
  804271:	00 00                	add    %al,(%rax)
	...

0000000000804274 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804274:	55                   	push   %rbp
  804275:	48 89 e5             	mov    %rsp,%rbp
  804278:	48 83 ec 20          	sub    $0x20,%rsp
  80427c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80427f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804282:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804285:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804289:	be 01 00 00 00       	mov    $0x1,%esi
  80428e:	48 89 c7             	mov    %rax,%rdi
  804291:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
}
  80429d:	c9                   	leaveq 
  80429e:	c3                   	retq   

000000000080429f <getchar>:

int
getchar(void)
{
  80429f:	55                   	push   %rbp
  8042a0:	48 89 e5             	mov    %rsp,%rbp
  8042a3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042a7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8042b0:	48 89 c6             	mov    %rax,%rsi
  8042b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b8:	48 b8 e4 2c 80 00 00 	movabs $0x802ce4,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
  8042c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042cb:	79 05                	jns    8042d2 <getchar+0x33>
		return r;
  8042cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d0:	eb 14                	jmp    8042e6 <getchar+0x47>
	if (r < 1)
  8042d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042d6:	7f 07                	jg     8042df <getchar+0x40>
		return -E_EOF;
  8042d8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042dd:	eb 07                	jmp    8042e6 <getchar+0x47>
	return c;
  8042df:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042e3:	0f b6 c0             	movzbl %al,%eax
}
  8042e6:	c9                   	leaveq 
  8042e7:	c3                   	retq   

00000000008042e8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042e8:	55                   	push   %rbp
  8042e9:	48 89 e5             	mov    %rsp,%rbp
  8042ec:	48 83 ec 20          	sub    $0x20,%rsp
  8042f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042fa:	48 89 d6             	mov    %rdx,%rsi
  8042fd:	89 c7                	mov    %eax,%edi
  8042ff:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  804306:	00 00 00 
  804309:	ff d0                	callq  *%rax
  80430b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804312:	79 05                	jns    804319 <iscons+0x31>
		return r;
  804314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804317:	eb 1a                	jmp    804333 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431d:	8b 10                	mov    (%rax),%edx
  80431f:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804326:	00 00 00 
  804329:	8b 00                	mov    (%rax),%eax
  80432b:	39 c2                	cmp    %eax,%edx
  80432d:	0f 94 c0             	sete   %al
  804330:	0f b6 c0             	movzbl %al,%eax
}
  804333:	c9                   	leaveq 
  804334:	c3                   	retq   

0000000000804335 <opencons>:

int
opencons(void)
{
  804335:	55                   	push   %rbp
  804336:	48 89 e5             	mov    %rsp,%rbp
  804339:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80433d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804341:	48 89 c7             	mov    %rax,%rdi
  804344:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80434b:	00 00 00 
  80434e:	ff d0                	callq  *%rax
  804350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804357:	79 05                	jns    80435e <opencons+0x29>
		return r;
  804359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435c:	eb 5b                	jmp    8043b9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80435e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804362:	ba 07 04 00 00       	mov    $0x407,%edx
  804367:	48 89 c6             	mov    %rax,%rsi
  80436a:	bf 00 00 00 00       	mov    $0x0,%edi
  80436f:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
  80437b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80437e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804382:	79 05                	jns    804389 <opencons+0x54>
		return r;
  804384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804387:	eb 30                	jmp    8043b9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438d:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804394:	00 00 00 
  804397:	8b 12                	mov    (%rdx),%edx
  804399:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80439b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043aa:	48 89 c7             	mov    %rax,%rdi
  8043ad:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
}
  8043b9:	c9                   	leaveq 
  8043ba:	c3                   	retq   

00000000008043bb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043bb:	55                   	push   %rbp
  8043bc:	48 89 e5             	mov    %rsp,%rbp
  8043bf:	48 83 ec 30          	sub    $0x30,%rsp
  8043c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043d4:	75 13                	jne    8043e9 <devcons_read+0x2e>
		return 0;
  8043d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043db:	eb 49                	jmp    804426 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8043dd:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  8043e4:	00 00 00 
  8043e7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043e9:	48 b8 1a 1c 80 00 00 	movabs $0x801c1a,%rax
  8043f0:	00 00 00 
  8043f3:	ff d0                	callq  *%rax
  8043f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043fc:	74 df                	je     8043dd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8043fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804402:	79 05                	jns    804409 <devcons_read+0x4e>
		return c;
  804404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804407:	eb 1d                	jmp    804426 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804409:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80440d:	75 07                	jne    804416 <devcons_read+0x5b>
		return 0;
  80440f:	b8 00 00 00 00       	mov    $0x0,%eax
  804414:	eb 10                	jmp    804426 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804419:	89 c2                	mov    %eax,%edx
  80441b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80441f:	88 10                	mov    %dl,(%rax)
	return 1;
  804421:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804426:	c9                   	leaveq 
  804427:	c3                   	retq   

0000000000804428 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804428:	55                   	push   %rbp
  804429:	48 89 e5             	mov    %rsp,%rbp
  80442c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804433:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80443a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804441:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80444f:	eb 77                	jmp    8044c8 <devcons_write+0xa0>
		m = n - tot;
  804451:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804458:	89 c2                	mov    %eax,%edx
  80445a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445d:	89 d1                	mov    %edx,%ecx
  80445f:	29 c1                	sub    %eax,%ecx
  804461:	89 c8                	mov    %ecx,%eax
  804463:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804466:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804469:	83 f8 7f             	cmp    $0x7f,%eax
  80446c:	76 07                	jbe    804475 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80446e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804475:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804478:	48 63 d0             	movslq %eax,%rdx
  80447b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447e:	48 98                	cltq   
  804480:	48 89 c1             	mov    %rax,%rcx
  804483:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80448a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804491:	48 89 ce             	mov    %rcx,%rsi
  804494:	48 89 c7             	mov    %rax,%rdi
  804497:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044a6:	48 63 d0             	movslq %eax,%rdx
  8044a9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044b0:	48 89 d6             	mov    %rdx,%rsi
  8044b3:	48 89 c7             	mov    %rax,%rdi
  8044b6:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  8044bd:	00 00 00 
  8044c0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044c5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044cb:	48 98                	cltq   
  8044cd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044d4:	0f 82 77 ff ff ff    	jb     804451 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044dd:	c9                   	leaveq 
  8044de:	c3                   	retq   

00000000008044df <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044df:	55                   	push   %rbp
  8044e0:	48 89 e5             	mov    %rsp,%rbp
  8044e3:	48 83 ec 08          	sub    $0x8,%rsp
  8044e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f0:	c9                   	leaveq 
  8044f1:	c3                   	retq   

00000000008044f2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044f2:	55                   	push   %rbp
  8044f3:	48 89 e5             	mov    %rsp,%rbp
  8044f6:	48 83 ec 10          	sub    $0x10,%rsp
  8044fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804506:	48 be 9b 51 80 00 00 	movabs $0x80519b,%rsi
  80450d:	00 00 00 
  804510:	48 89 c7             	mov    %rax,%rdi
  804513:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  80451a:	00 00 00 
  80451d:	ff d0                	callq  *%rax
	return 0;
  80451f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804524:	c9                   	leaveq 
  804525:	c3                   	retq   
	...

0000000000804528 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
  80452c:	48 83 ec 10          	sub    $0x10,%rsp
  804530:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804534:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80453b:	00 00 00 
  80453e:	48 8b 00             	mov    (%rax),%rax
  804541:	48 85 c0             	test   %rax,%rax
  804544:	75 66                	jne    8045ac <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  804546:	ba 07 00 00 00       	mov    $0x7,%edx
  80454b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804550:	bf 00 00 00 00       	mov    $0x0,%edi
  804555:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  80455c:	00 00 00 
  80455f:	ff d0                	callq  *%rax
  804561:	85 c0                	test   %eax,%eax
  804563:	75 1d                	jne    804582 <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804565:	48 be c0 45 80 00 00 	movabs $0x8045c0,%rsi
  80456c:	00 00 00 
  80456f:	bf 00 00 00 00       	mov    $0x0,%edi
  804574:	48 b8 a2 1e 80 00 00 	movabs $0x801ea2,%rax
  80457b:	00 00 00 
  80457e:	ff d0                	callq  *%rax
  804580:	eb 2a                	jmp    8045ac <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  804582:	48 ba a2 51 80 00 00 	movabs $0x8051a2,%rdx
  804589:	00 00 00 
  80458c:	be 23 00 00 00       	mov    $0x23,%esi
  804591:	48 bf c0 51 80 00 00 	movabs $0x8051c0,%rdi
  804598:	00 00 00 
  80459b:	b8 00 00 00 00       	mov    $0x0,%eax
  8045a0:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  8045a7:	00 00 00 
  8045aa:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8045ac:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045b3:	00 00 00 
  8045b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045ba:	48 89 10             	mov    %rdx,(%rax)
}
  8045bd:	c9                   	leaveq 
  8045be:	c3                   	retq   
	...

00000000008045c0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8045c0:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8045c3:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8045ca:	00 00 00 
call *%rax
  8045cd:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  8045cf:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  8045d3:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  8045d8:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  8045df:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  8045e0:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  8045e4:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  8045e7:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  8045ee:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  8045ef:	4c 8b 3c 24          	mov    (%rsp),%r15
  8045f3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8045f8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8045fd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804602:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804607:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80460c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804611:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804616:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80461b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804620:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804625:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80462a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80462f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804634:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804639:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  80463d:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804641:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  804642:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  804643:	c3                   	retq   

0000000000804644 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804644:	55                   	push   %rbp
  804645:	48 89 e5             	mov    %rsp,%rbp
  804648:	48 83 ec 30          	sub    $0x30,%rsp
  80464c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804650:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804654:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804658:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80465f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804664:	74 18                	je     80467e <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  804666:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80466a:	48 89 c7             	mov    %rax,%rdi
  80466d:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  804674:	00 00 00 
  804677:	ff d0                	callq  *%rax
  804679:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80467c:	eb 19                	jmp    804697 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80467e:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  804685:	00 00 00 
  804688:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  80468f:	00 00 00 
  804692:	ff d0                	callq  *%rax
  804694:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  804697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80469b:	79 39                	jns    8046d6 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  80469d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046a2:	75 08                	jne    8046ac <ipc_recv+0x68>
  8046a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a8:	8b 00                	mov    (%rax),%eax
  8046aa:	eb 05                	jmp    8046b1 <ipc_recv+0x6d>
  8046ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8046b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046b5:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8046b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046bc:	75 08                	jne    8046c6 <ipc_recv+0x82>
  8046be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046c2:	8b 00                	mov    (%rax),%eax
  8046c4:	eb 05                	jmp    8046cb <ipc_recv+0x87>
  8046c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8046cf:	89 02                	mov    %eax,(%rdx)
		return r;
  8046d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d4:	eb 53                	jmp    804729 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  8046d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046db:	74 19                	je     8046f6 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  8046dd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046e4:	00 00 00 
  8046e7:	48 8b 00             	mov    (%rax),%rax
  8046ea:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8046f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046f4:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  8046f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046fb:	74 19                	je     804716 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  8046fd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804704:	00 00 00 
  804707:	48 8b 00             	mov    (%rax),%rax
  80470a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804714:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  804716:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80471d:	00 00 00 
  804720:	48 8b 00             	mov    (%rax),%rax
  804723:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804729:	c9                   	leaveq 
  80472a:	c3                   	retq   

000000000080472b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80472b:	55                   	push   %rbp
  80472c:	48 89 e5             	mov    %rsp,%rbp
  80472f:	48 83 ec 30          	sub    $0x30,%rsp
  804733:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804736:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804739:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80473d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  804740:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  804747:	eb 59                	jmp    8047a2 <ipc_send+0x77>
		if(pg) {
  804749:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80474e:	74 20                	je     804770 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804750:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804753:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804756:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80475a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80475d:	89 c7                	mov    %eax,%edi
  80475f:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  804766:	00 00 00 
  804769:	ff d0                	callq  *%rax
  80476b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80476e:	eb 26                	jmp    804796 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  804770:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804773:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804776:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804779:	89 d1                	mov    %edx,%ecx
  80477b:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  804782:	00 00 00 
  804785:	89 c7                	mov    %eax,%edi
  804787:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  80478e:	00 00 00 
  804791:	ff d0                	callq  *%rax
  804793:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  804796:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80479d:	00 00 00 
  8047a0:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8047a2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047a6:	74 a1                	je     804749 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8047a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ac:	74 2a                	je     8047d8 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8047ae:	48 ba d0 51 80 00 00 	movabs $0x8051d0,%rdx
  8047b5:	00 00 00 
  8047b8:	be 49 00 00 00       	mov    $0x49,%esi
  8047bd:	48 bf fb 51 80 00 00 	movabs $0x8051fb,%rdi
  8047c4:	00 00 00 
  8047c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8047cc:	48 b9 d4 05 80 00 00 	movabs $0x8005d4,%rcx
  8047d3:	00 00 00 
  8047d6:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  8047d8:	c9                   	leaveq 
  8047d9:	c3                   	retq   

00000000008047da <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8047da:	55                   	push   %rbp
  8047db:	48 89 e5             	mov    %rsp,%rbp
  8047de:	48 83 ec 18          	sub    $0x18,%rsp
  8047e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8047e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8047ec:	eb 6a                	jmp    804858 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  8047ee:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8047f5:	00 00 00 
  8047f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047fb:	48 63 d0             	movslq %eax,%rdx
  8047fe:	48 89 d0             	mov    %rdx,%rax
  804801:	48 c1 e0 02          	shl    $0x2,%rax
  804805:	48 01 d0             	add    %rdx,%rax
  804808:	48 01 c0             	add    %rax,%rax
  80480b:	48 01 d0             	add    %rdx,%rax
  80480e:	48 c1 e0 05          	shl    $0x5,%rax
  804812:	48 01 c8             	add    %rcx,%rax
  804815:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80481b:	8b 00                	mov    (%rax),%eax
  80481d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804820:	75 32                	jne    804854 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804822:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804829:	00 00 00 
  80482c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482f:	48 63 d0             	movslq %eax,%rdx
  804832:	48 89 d0             	mov    %rdx,%rax
  804835:	48 c1 e0 02          	shl    $0x2,%rax
  804839:	48 01 d0             	add    %rdx,%rax
  80483c:	48 01 c0             	add    %rax,%rax
  80483f:	48 01 d0             	add    %rdx,%rax
  804842:	48 c1 e0 05          	shl    $0x5,%rax
  804846:	48 01 c8             	add    %rcx,%rax
  804849:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80484f:	8b 40 08             	mov    0x8(%rax),%eax
  804852:	eb 12                	jmp    804866 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804854:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804858:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80485f:	7e 8d                	jle    8047ee <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804866:	c9                   	leaveq 
  804867:	c3                   	retq   

0000000000804868 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804868:	55                   	push   %rbp
  804869:	48 89 e5             	mov    %rsp,%rbp
  80486c:	48 83 ec 18          	sub    $0x18,%rsp
  804870:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804878:	48 89 c2             	mov    %rax,%rdx
  80487b:	48 c1 ea 15          	shr    $0x15,%rdx
  80487f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804886:	01 00 00 
  804889:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80488d:	83 e0 01             	and    $0x1,%eax
  804890:	48 85 c0             	test   %rax,%rax
  804893:	75 07                	jne    80489c <pageref+0x34>
		return 0;
  804895:	b8 00 00 00 00       	mov    $0x0,%eax
  80489a:	eb 53                	jmp    8048ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80489c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a0:	48 89 c2             	mov    %rax,%rdx
  8048a3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048ae:	01 00 00 
  8048b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048bd:	83 e0 01             	and    $0x1,%eax
  8048c0:	48 85 c0             	test   %rax,%rax
  8048c3:	75 07                	jne    8048cc <pageref+0x64>
		return 0;
  8048c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ca:	eb 23                	jmp    8048ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d0:	48 89 c2             	mov    %rax,%rdx
  8048d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8048d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048de:	00 00 00 
  8048e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8048e5:	48 01 d0             	add    %rdx,%rax
  8048e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8048ec:	0f b7 c0             	movzwl %ax,%eax
}
  8048ef:	c9                   	leaveq 
  8048f0:	c3                   	retq   
