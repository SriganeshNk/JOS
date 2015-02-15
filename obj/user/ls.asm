
obj/user/ls.debug:     file format elf64-x86-64


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
  80003c:	e8 e3 04 00 00       	callq  800524 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004f:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800056:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005d:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800064:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006b:	48 89 d6             	mov    %rdx,%rsi
  80006e:	48 89 c7             	mov    %rax,%rdi
  800071:	48 b8 6c 2c 80 00 00 	movabs $0x802c6c,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
  80007d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800080:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800084:	79 3b                	jns    8000c1 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800086:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800089:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800090:	41 89 d0             	mov    %edx,%r8d
  800093:	48 89 c1             	mov    %rax,%rcx
  800096:	48 ba e0 45 80 00 00 	movabs $0x8045e0,%rdx
  80009d:	00 00 00 
  8000a0:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a5:	48 bf ec 45 80 00 00 	movabs $0x8045ec,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	49 b9 f0 05 80 00 00 	movabs $0x8005f0,%r9
  8000bb:	00 00 00 
  8000be:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	74 36                	je     8000fe <ls+0xba>
  8000c8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000cf:	00 00 00 
  8000d2:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	75 22                	jne    8000fe <ls+0xba>
		lsdir(path, prefix);
  8000dc:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000ea:	48 89 d6             	mov    %rdx,%rsi
  8000ed:	48 89 c7             	mov    %rax,%rdi
  8000f0:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax
  8000fc:	eb 28                	jmp    800126 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fe:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800101:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800104:	85 c0                	test   %eax,%eax
  800106:	0f 95 c0             	setne  %al
  800109:	0f b6 c0             	movzbl %al,%eax
  80010c:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800113:	89 c6                	mov    %eax,%esi
  800115:	bf 00 00 00 00       	mov    $0x0,%edi
  80011a:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
}
  800126:	c9                   	leaveq 
  800127:	c3                   	retq   

0000000000800128 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800128:	55                   	push   %rbp
  800129:	48 89 e5             	mov    %rsp,%rbp
  80012c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800133:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  80013a:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800141:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800148:	be 00 00 00 00       	mov    $0x0,%esi
  80014d:	48 89 c7             	mov    %rax,%rdi
  800150:	48 b8 5b 2d 80 00 00 	movabs $0x802d5b,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 7a                	jns    8001df <lsdir+0xb7>
		panic("open %s: %e", path, fd);
  800165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800168:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016f:	41 89 d0             	mov    %edx,%r8d
  800172:	48 89 c1             	mov    %rax,%rcx
  800175:	48 ba f6 45 80 00 00 	movabs $0x8045f6,%rdx
  80017c:	00 00 00 
  80017f:	be 1d 00 00 00       	mov    $0x1d,%esi
  800184:	48 bf ec 45 80 00 00 	movabs $0x8045ec,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 f0 05 80 00 00 	movabs $0x8005f0,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  8001a0:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a7:	84 c0                	test   %al,%al
  8001a9:	74 35                	je     8001e0 <lsdir+0xb8>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ab:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b1:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b7:	83 f8 01             	cmp    $0x1,%eax
  8001ba:	0f 94 c0             	sete   %al
  8001bd:	0f b6 f0             	movzbl %al,%esi
  8001c0:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c7:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001ce:	48 89 c7             	mov    %rax,%rdi
  8001d1:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
  8001dd:	eb 01                	jmp    8001e0 <lsdir+0xb8>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001df:	90                   	nop
  8001e0:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ea:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ef:	48 89 ce             	mov    %rcx,%rsi
  8001f2:	89 c7                	mov    %eax,%edi
  8001f4:	48 b8 55 29 80 00 00 	movabs $0x802955,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
  800200:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800203:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  80020a:	74 94                	je     8001a0 <lsdir+0x78>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800210:	7e 35                	jle    800247 <lsdir+0x11f>
		panic("short read in directory %s", path);
  800212:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800219:	48 89 c1             	mov    %rax,%rcx
  80021c:	48 ba 02 46 80 00 00 	movabs $0x804602,%rdx
  800223:	00 00 00 
  800226:	be 22 00 00 00       	mov    $0x22,%esi
  80022b:	48 bf ec 45 80 00 00 	movabs $0x8045ec,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	49 b8 f0 05 80 00 00 	movabs $0x8005f0,%r8
  800241:	00 00 00 
  800244:	41 ff d0             	callq  *%r8
	if (n < 0)
  800247:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80024b:	79 3b                	jns    800288 <lsdir+0x160>
		panic("error reading directory %s: %e", path, n);
  80024d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800250:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800257:	41 89 d0             	mov    %edx,%r8d
  80025a:	48 89 c1             	mov    %rax,%rcx
  80025d:	48 ba 20 46 80 00 00 	movabs $0x804620,%rdx
  800264:	00 00 00 
  800267:	be 24 00 00 00       	mov    $0x24,%esi
  80026c:	48 bf ec 45 80 00 00 	movabs $0x8045ec,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	49 b9 f0 05 80 00 00 	movabs $0x8005f0,%r9
  800282:	00 00 00 
  800285:	41 ff d1             	callq  *%r9
}
  800288:	c9                   	leaveq 
  800289:	c3                   	retq   

000000000080028a <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  80028a:	55                   	push   %rbp
  80028b:	48 89 e5             	mov    %rsp,%rbp
  80028e:	48 83 ec 30          	sub    $0x30,%rsp
  800292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800296:	89 f0                	mov    %esi,%eax
  800298:	89 55 e0             	mov    %edx,-0x20(%rbp)
  80029b:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029f:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a9:	00 00 00 
  8002ac:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	74 34                	je     8002ea <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b6:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002ba:	74 07                	je     8002c3 <ls1+0x39>
  8002bc:	b8 64 00 00 00       	mov    $0x64,%eax
  8002c1:	eb 05                	jmp    8002c8 <ls1+0x3e>
  8002c3:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c8:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002cb:	89 c2                	mov    %eax,%edx
  8002cd:	89 ce                	mov    %ecx,%esi
  8002cf:	48 bf 3f 46 80 00 00 	movabs $0x80463f,%rdi
  8002d6:	00 00 00 
  8002d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002de:	48 b9 dc 31 80 00 00 	movabs $0x8031dc,%rcx
  8002e5:	00 00 00 
  8002e8:	ff d1                	callq  *%rcx
	if(prefix) {
  8002ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ef:	74 73                	je     800364 <ls1+0xda>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f5:	0f b6 00             	movzbl (%rax),%eax
  8002f8:	84 c0                	test   %al,%al
  8002fa:	74 34                	je     800330 <ls1+0xa6>
  8002fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800300:	48 89 c7             	mov    %rax,%rdi
  800303:	48 b8 90 13 80 00 00 	movabs $0x801390,%rax
  80030a:	00 00 00 
  80030d:	ff d0                	callq  *%rax
  80030f:	48 98                	cltq   
  800311:	48 83 e8 01          	sub    $0x1,%rax
  800315:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800319:	0f b6 00             	movzbl (%rax),%eax
  80031c:	3c 2f                	cmp    $0x2f,%al
  80031e:	74 10                	je     800330 <ls1+0xa6>
			sep = "/";
  800320:	48 b8 48 46 80 00 00 	movabs $0x804648,%rax
  800327:	00 00 00 
  80032a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032e:	eb 0e                	jmp    80033e <ls1+0xb4>
		else
			sep = "";
  800330:	48 b8 4a 46 80 00 00 	movabs $0x80464a,%rax
  800337:	00 00 00 
  80033a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800346:	48 89 c6             	mov    %rax,%rsi
  800349:	48 bf 4b 46 80 00 00 	movabs $0x80464b,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	48 b9 dc 31 80 00 00 	movabs $0x8031dc,%rcx
  80035f:	00 00 00 
  800362:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800364:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800368:	48 89 c6             	mov    %rax,%rsi
  80036b:	48 bf 50 46 80 00 00 	movabs $0x804650,%rdi
  800372:	00 00 00 
  800375:	b8 00 00 00 00       	mov    $0x0,%eax
  80037a:	48 ba dc 31 80 00 00 	movabs $0x8031dc,%rdx
  800381:	00 00 00 
  800384:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800386:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038d:	00 00 00 
  800390:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	74 21                	je     8003bb <ls1+0x131>
  80039a:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039e:	74 1b                	je     8003bb <ls1+0x131>
		printf("/");
  8003a0:	48 bf 48 46 80 00 00 	movabs $0x804648,%rdi
  8003a7:	00 00 00 
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003af:	48 ba dc 31 80 00 00 	movabs $0x8031dc,%rdx
  8003b6:	00 00 00 
  8003b9:	ff d2                	callq  *%rdx
	printf("\n");
  8003bb:	48 bf 53 46 80 00 00 	movabs $0x804653,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba dc 31 80 00 00 	movabs $0x8031dc,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
}
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <usage>:

void
usage(void)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dc:	48 bf 55 46 80 00 00 	movabs $0x804655,%rdi
  8003e3:	00 00 00 
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	48 ba dc 31 80 00 00 	movabs $0x8031dc,%rdx
  8003f2:	00 00 00 
  8003f5:	ff d2                	callq  *%rdx
	exit();
  8003f7:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
}
  800403:	5d                   	pop    %rbp
  800404:	c3                   	retq   

0000000000800405 <umain>:

void
umain(int argc, char **argv)
{
  800405:	55                   	push   %rbp
  800406:	48 89 e5             	mov    %rsp,%rbp
  800409:	48 83 ec 40          	sub    $0x40,%rsp
  80040d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800410:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800414:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800418:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041c:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800420:	48 89 ce             	mov    %rcx,%rsi
  800423:	48 89 c7             	mov    %rax,%rdi
  800426:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  80042d:	00 00 00 
  800430:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800432:	eb 60                	jmp    800494 <umain+0x8f>
		switch (i) {
  800434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800437:	83 e8 46             	sub    $0x46,%eax
  80043a:	83 f8 26             	cmp    $0x26,%eax
  80043d:	77 49                	ja     800488 <umain+0x83>
  80043f:	48 98                	cltq   
  800441:	ba 01 00 00 00       	mov    $0x1,%edx
  800446:	89 c1                	mov    %eax,%ecx
  800448:	48 d3 e2             	shl    %cl,%rdx
  80044b:	48 b8 01 00 00 40 40 	movabs $0x4040000001,%rax
  800452:	00 00 00 
  800455:	48 21 d0             	and    %rdx,%rax
  800458:	48 85 c0             	test   %rax,%rax
  80045b:	74 2b                	je     800488 <umain+0x83>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800470:	8d 48 01             	lea    0x1(%rax),%ecx
  800473:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80047a:	00 00 00 
  80047d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800480:	48 63 d2             	movslq %edx,%rdx
  800483:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800486:	eb 0c                	jmp    800494 <umain+0x8f>
		default:
			usage();
  800488:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800494:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800498:	48 89 c7             	mov    %rax,%rdi
  80049b:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
  8004a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ae:	79 84                	jns    800434 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8004b0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004b3:	83 f8 01             	cmp    $0x1,%eax
  8004b6:	75 22                	jne    8004da <umain+0xd5>
		ls("/", "");
  8004b8:	48 be 4a 46 80 00 00 	movabs $0x80464a,%rsi
  8004bf:	00 00 00 
  8004c2:	48 bf 48 46 80 00 00 	movabs $0x804648,%rdi
  8004c9:	00 00 00 
  8004cc:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8004d3:	00 00 00 
  8004d6:	ff d0                	callq  *%rax
  8004d8:	eb 47                	jmp    800521 <umain+0x11c>
	else {
		for (i = 1; i < argc; i++)
  8004da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004e1:	eb 36                	jmp    800519 <umain+0x114>
			ls(argv[i], argv[i]);
  8004e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e6:	48 98                	cltq   
  8004e8:	48 c1 e0 03          	shl    $0x3,%rax
  8004ec:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8004f0:	48 8b 10             	mov    (%rax),%rdx
  8004f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f6:	48 98                	cltq   
  8004f8:	48 c1 e0 03          	shl    $0x3,%rax
  8004fc:	48 03 45 c0          	add    -0x40(%rbp),%rax
  800500:	48 8b 00             	mov    (%rax),%rax
  800503:	48 89 d6             	mov    %rdx,%rsi
  800506:	48 89 c7             	mov    %rax,%rdi
  800509:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800510:	00 00 00 
  800513:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800515:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800519:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80051c:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  80051f:	7c c2                	jl     8004e3 <umain+0xde>
			ls(argv[i], argv[i]);
	}
}
  800521:	c9                   	leaveq 
  800522:	c3                   	retq   
	...

0000000000800524 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800533:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80053a:	00 00 00 
  80053d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800544:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  80054b:	00 00 00 
  80054e:	ff d0                	callq  *%rax
  800550:	48 98                	cltq   
  800552:	48 89 c2             	mov    %rax,%rdx
  800555:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80055b:	48 89 d0             	mov    %rdx,%rax
  80055e:	48 c1 e0 02          	shl    $0x2,%rax
  800562:	48 01 d0             	add    %rdx,%rax
  800565:	48 01 c0             	add    %rax,%rax
  800568:	48 01 d0             	add    %rdx,%rax
  80056b:	48 c1 e0 05          	shl    $0x5,%rax
  80056f:	48 89 c2             	mov    %rax,%rdx
  800572:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800579:	00 00 00 
  80057c:	48 01 c2             	add    %rax,%rdx
  80057f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800586:	00 00 00 
  800589:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800590:	7e 14                	jle    8005a6 <libmain+0x82>
		binaryname = argv[0];
  800592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800596:	48 8b 10             	mov    (%rax),%rdx
  800599:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8005a0:	00 00 00 
  8005a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ad:	48 89 d6             	mov    %rdx,%rsi
  8005b0:	89 c7                	mov    %eax,%edi
  8005b2:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  8005b9:	00 00 00 
  8005bc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005be:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  8005c5:	00 00 00 
  8005c8:	ff d0                	callq  *%rax
}
  8005ca:	c9                   	leaveq 
  8005cb:	c3                   	retq   

00000000008005cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005cc:	55                   	push   %rbp
  8005cd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005d0:	48 b8 a5 26 80 00 00 	movabs $0x8026a5,%rax
  8005d7:	00 00 00 
  8005da:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8005e1:	48 b8 74 1c 80 00 00 	movabs $0x801c74,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	callq  *%rax
}
  8005ed:	5d                   	pop    %rbp
  8005ee:	c3                   	retq   
	...

00000000008005f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f0:	55                   	push   %rbp
  8005f1:	48 89 e5             	mov    %rsp,%rbp
  8005f4:	53                   	push   %rbx
  8005f5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005fc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800603:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800609:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800610:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800617:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80061e:	84 c0                	test   %al,%al
  800620:	74 23                	je     800645 <_panic+0x55>
  800622:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800629:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80062d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800631:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800635:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800639:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80063d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800641:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800645:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80064c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800653:	00 00 00 
  800656:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80065d:	00 00 00 
  800660:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800664:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80066b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800672:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800679:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800680:	00 00 00 
  800683:	48 8b 18             	mov    (%rax),%rbx
  800686:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  80068d:	00 00 00 
  800690:	ff d0                	callq  *%rax
  800692:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800698:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80069f:	41 89 c8             	mov    %ecx,%r8d
  8006a2:	48 89 d1             	mov    %rdx,%rcx
  8006a5:	48 89 da             	mov    %rbx,%rdx
  8006a8:	89 c6                	mov    %eax,%esi
  8006aa:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  8006b1:	00 00 00 
  8006b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b9:	49 b9 2b 08 80 00 00 	movabs $0x80082b,%r9
  8006c0:	00 00 00 
  8006c3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006cd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d4:	48 89 d6             	mov    %rdx,%rsi
  8006d7:	48 89 c7             	mov    %rax,%rdi
  8006da:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8006e1:	00 00 00 
  8006e4:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e6:	48 bf a3 46 80 00 00 	movabs $0x8046a3,%rdi
  8006ed:	00 00 00 
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8006fc:	00 00 00 
  8006ff:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800701:	cc                   	int3   
  800702:	eb fd                	jmp    800701 <_panic+0x111>

0000000000800704 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800704:	55                   	push   %rbp
  800705:	48 89 e5             	mov    %rsp,%rbp
  800708:	48 83 ec 10          	sub    $0x10,%rsp
  80070c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80070f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800717:	8b 00                	mov    (%rax),%eax
  800719:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80071c:	89 d6                	mov    %edx,%esi
  80071e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800722:	48 63 d0             	movslq %eax,%rdx
  800725:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80072a:	8d 50 01             	lea    0x1(%rax),%edx
  80072d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800731:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073e:	75 2c                	jne    80076c <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	48 98                	cltq   
  800748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074c:	48 83 c2 08          	add    $0x8,%rdx
  800750:	48 89 c6             	mov    %rax,%rsi
  800753:	48 89 d7             	mov    %rdx,%rdi
  800756:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
        b->idx = 0;
  800762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800766:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80076c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800770:	8b 40 04             	mov    0x4(%rax),%eax
  800773:	8d 50 01             	lea    0x1(%rax),%edx
  800776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80077d:	c9                   	leaveq 
  80077e:	c3                   	retq   

000000000080077f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80077f:	55                   	push   %rbp
  800780:	48 89 e5             	mov    %rsp,%rbp
  800783:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80078a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800791:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800798:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80079f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a6:	48 8b 0a             	mov    (%rdx),%rcx
  8007a9:	48 89 08             	mov    %rcx,(%rax)
  8007ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007c3:	00 00 00 
    b.cnt = 0;
  8007c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007cd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007d0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007de:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e5:	48 89 c6             	mov    %rax,%rsi
  8007e8:	48 bf 04 07 80 00 00 	movabs $0x800704,%rdi
  8007ef:	00 00 00 
  8007f2:	48 b8 dc 0b 80 00 00 	movabs $0x800bdc,%rax
  8007f9:	00 00 00 
  8007fc:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007fe:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800804:	48 98                	cltq   
  800806:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80080d:	48 83 c2 08          	add    $0x8,%rdx
  800811:	48 89 c6             	mov    %rax,%rsi
  800814:	48 89 d7             	mov    %rdx,%rdi
  800817:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800823:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800829:	c9                   	leaveq 
  80082a:	c3                   	retq   

000000000080082b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800836:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80083d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800844:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80084b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800852:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800859:	84 c0                	test   %al,%al
  80085b:	74 20                	je     80087d <cprintf+0x52>
  80085d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800861:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800865:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800869:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80086d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800871:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800875:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800879:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80087d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800884:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80088b:	00 00 00 
  80088e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800895:	00 00 00 
  800898:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80089c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008bf:	48 8b 0a             	mov    (%rdx),%rcx
  8008c2:	48 89 08             	mov    %rcx,(%rax)
  8008c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008d5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008e3:	48 89 d6             	mov    %rdx,%rsi
  8008e6:	48 89 c7             	mov    %rax,%rdi
  8008e9:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8008f0:	00 00 00 
  8008f3:	ff d0                	callq  *%rax
  8008f5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008fb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800901:	c9                   	leaveq 
  800902:	c3                   	retq   
	...

0000000000800904 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800904:	55                   	push   %rbp
  800905:	48 89 e5             	mov    %rsp,%rbp
  800908:	48 83 ec 30          	sub    $0x30,%rsp
  80090c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800910:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800914:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800918:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80091b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80091f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800923:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800926:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80092a:	77 52                	ja     80097e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80092c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80092f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800933:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800936:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80093a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093e:	ba 00 00 00 00       	mov    $0x0,%edx
  800943:	48 f7 75 d0          	divq   -0x30(%rbp)
  800947:	48 89 c2             	mov    %rax,%rdx
  80094a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80094d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800950:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800958:	41 89 f9             	mov    %edi,%r9d
  80095b:	48 89 c7             	mov    %rax,%rdi
  80095e:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  800965:	00 00 00 
  800968:	ff d0                	callq  *%rax
  80096a:	eb 1c                	jmp    800988 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80096c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800970:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800973:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800977:	48 89 d6             	mov    %rdx,%rsi
  80097a:	89 c7                	mov    %eax,%edi
  80097c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80097e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800982:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800986:	7f e4                	jg     80096c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800988:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	ba 00 00 00 00       	mov    $0x0,%edx
  800994:	48 f7 f1             	div    %rcx
  800997:	48 89 d0             	mov    %rdx,%rax
  80099a:	48 ba b0 48 80 00 00 	movabs $0x8048b0,%rdx
  8009a1:	00 00 00 
  8009a4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a8:	0f be c0             	movsbl %al,%eax
  8009ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009af:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8009b3:	48 89 d6             	mov    %rdx,%rsi
  8009b6:	89 c7                	mov    %eax,%edi
  8009b8:	ff d1                	callq  *%rcx
}
  8009ba:	c9                   	leaveq 
  8009bb:	c3                   	retq   

00000000008009bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009bc:	55                   	push   %rbp
  8009bd:	48 89 e5             	mov    %rsp,%rbp
  8009c0:	48 83 ec 20          	sub    $0x20,%rsp
  8009c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009cb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009cf:	7e 52                	jle    800a23 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	83 f8 30             	cmp    $0x30,%eax
  8009da:	73 24                	jae    800a00 <getuint+0x44>
  8009dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	8b 00                	mov    (%rax),%eax
  8009ea:	89 c0                	mov    %eax,%eax
  8009ec:	48 01 d0             	add    %rdx,%rax
  8009ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f3:	8b 12                	mov    (%rdx),%edx
  8009f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fc:	89 0a                	mov    %ecx,(%rdx)
  8009fe:	eb 17                	jmp    800a17 <getuint+0x5b>
  800a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a04:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a08:	48 89 d0             	mov    %rdx,%rax
  800a0b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a13:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a17:	48 8b 00             	mov    (%rax),%rax
  800a1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1e:	e9 a3 00 00 00       	jmpq   800ac6 <getuint+0x10a>
	else if (lflag)
  800a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a27:	74 4f                	je     800a78 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	8b 00                	mov    (%rax),%eax
  800a2f:	83 f8 30             	cmp    $0x30,%eax
  800a32:	73 24                	jae    800a58 <getuint+0x9c>
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	8b 00                	mov    (%rax),%eax
  800a42:	89 c0                	mov    %eax,%eax
  800a44:	48 01 d0             	add    %rdx,%rax
  800a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4b:	8b 12                	mov    (%rdx),%edx
  800a4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a54:	89 0a                	mov    %ecx,(%rdx)
  800a56:	eb 17                	jmp    800a6f <getuint+0xb3>
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a60:	48 89 d0             	mov    %rdx,%rax
  800a63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6f:	48 8b 00             	mov    (%rax),%rax
  800a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a76:	eb 4e                	jmp    800ac6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	8b 00                	mov    (%rax),%eax
  800a7e:	83 f8 30             	cmp    $0x30,%eax
  800a81:	73 24                	jae    800aa7 <getuint+0xeb>
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	8b 00                	mov    (%rax),%eax
  800a91:	89 c0                	mov    %eax,%eax
  800a93:	48 01 d0             	add    %rdx,%rax
  800a96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9a:	8b 12                	mov    (%rdx),%edx
  800a9c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa3:	89 0a                	mov    %ecx,(%rdx)
  800aa5:	eb 17                	jmp    800abe <getuint+0x102>
  800aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aaf:	48 89 d0             	mov    %rdx,%rax
  800ab2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800abe:	8b 00                	mov    (%rax),%eax
  800ac0:	89 c0                	mov    %eax,%eax
  800ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aca:	c9                   	leaveq 
  800acb:	c3                   	retq   

0000000000800acc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800acc:	55                   	push   %rbp
  800acd:	48 89 e5             	mov    %rsp,%rbp
  800ad0:	48 83 ec 20          	sub    $0x20,%rsp
  800ad4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ad8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800adb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800adf:	7e 52                	jle    800b33 <getint+0x67>
		x=va_arg(*ap, long long);
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	8b 00                	mov    (%rax),%eax
  800ae7:	83 f8 30             	cmp    $0x30,%eax
  800aea:	73 24                	jae    800b10 <getint+0x44>
  800aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af8:	8b 00                	mov    (%rax),%eax
  800afa:	89 c0                	mov    %eax,%eax
  800afc:	48 01 d0             	add    %rdx,%rax
  800aff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b03:	8b 12                	mov    (%rdx),%edx
  800b05:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0c:	89 0a                	mov    %ecx,(%rdx)
  800b0e:	eb 17                	jmp    800b27 <getint+0x5b>
  800b10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b14:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b18:	48 89 d0             	mov    %rdx,%rax
  800b1b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b23:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b27:	48 8b 00             	mov    (%rax),%rax
  800b2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b2e:	e9 a3 00 00 00       	jmpq   800bd6 <getint+0x10a>
	else if (lflag)
  800b33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b37:	74 4f                	je     800b88 <getint+0xbc>
		x=va_arg(*ap, long);
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	8b 00                	mov    (%rax),%eax
  800b3f:	83 f8 30             	cmp    $0x30,%eax
  800b42:	73 24                	jae    800b68 <getint+0x9c>
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b50:	8b 00                	mov    (%rax),%eax
  800b52:	89 c0                	mov    %eax,%eax
  800b54:	48 01 d0             	add    %rdx,%rax
  800b57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5b:	8b 12                	mov    (%rdx),%edx
  800b5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b64:	89 0a                	mov    %ecx,(%rdx)
  800b66:	eb 17                	jmp    800b7f <getint+0xb3>
  800b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b70:	48 89 d0             	mov    %rdx,%rax
  800b73:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b7f:	48 8b 00             	mov    (%rax),%rax
  800b82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b86:	eb 4e                	jmp    800bd6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	8b 00                	mov    (%rax),%eax
  800b8e:	83 f8 30             	cmp    $0x30,%eax
  800b91:	73 24                	jae    800bb7 <getint+0xeb>
  800b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b97:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9f:	8b 00                	mov    (%rax),%eax
  800ba1:	89 c0                	mov    %eax,%eax
  800ba3:	48 01 d0             	add    %rdx,%rax
  800ba6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800baa:	8b 12                	mov    (%rdx),%edx
  800bac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800baf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb3:	89 0a                	mov    %ecx,(%rdx)
  800bb5:	eb 17                	jmp    800bce <getint+0x102>
  800bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bbf:	48 89 d0             	mov    %rdx,%rax
  800bc2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bce:	8b 00                	mov    (%rax),%eax
  800bd0:	48 98                	cltq   
  800bd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bda:	c9                   	leaveq 
  800bdb:	c3                   	retq   

0000000000800bdc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bdc:	55                   	push   %rbp
  800bdd:	48 89 e5             	mov    %rsp,%rbp
  800be0:	41 54                	push   %r12
  800be2:	53                   	push   %rbx
  800be3:	48 83 ec 60          	sub    $0x60,%rsp
  800be7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800beb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bef:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bf7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bff:	48 8b 0a             	mov    (%rdx),%rcx
  800c02:	48 89 08             	mov    %rcx,(%rax)
  800c05:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c09:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c0d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c11:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c15:	eb 17                	jmp    800c2e <vprintfmt+0x52>
			if (ch == '\0')
  800c17:	85 db                	test   %ebx,%ebx
  800c19:	0f 84 ea 04 00 00    	je     801109 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800c1f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c23:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c27:	48 89 c6             	mov    %rax,%rsi
  800c2a:	89 df                	mov    %ebx,%edi
  800c2c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c32:	0f b6 00             	movzbl (%rax),%eax
  800c35:	0f b6 d8             	movzbl %al,%ebx
  800c38:	83 fb 25             	cmp    $0x25,%ebx
  800c3b:	0f 95 c0             	setne  %al
  800c3e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c43:	84 c0                	test   %al,%al
  800c45:	75 d0                	jne    800c17 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c47:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c4b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c52:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c60:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800c67:	eb 04                	jmp    800c6d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800c69:	90                   	nop
  800c6a:	eb 01                	jmp    800c6d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800c6c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c6d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c71:	0f b6 00             	movzbl (%rax),%eax
  800c74:	0f b6 d8             	movzbl %al,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c7e:	83 e8 23             	sub    $0x23,%eax
  800c81:	83 f8 55             	cmp    $0x55,%eax
  800c84:	0f 87 4b 04 00 00    	ja     8010d5 <vprintfmt+0x4f9>
  800c8a:	89 c0                	mov    %eax,%eax
  800c8c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c93:	00 
  800c94:	48 b8 d8 48 80 00 00 	movabs $0x8048d8,%rax
  800c9b:	00 00 00 
  800c9e:	48 01 d0             	add    %rdx,%rax
  800ca1:	48 8b 00             	mov    (%rax),%rax
  800ca4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ca6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800caa:	eb c1                	jmp    800c6d <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cb0:	eb bb                	jmp    800c6d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cb9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cbc:	89 d0                	mov    %edx,%eax
  800cbe:	c1 e0 02             	shl    $0x2,%eax
  800cc1:	01 d0                	add    %edx,%eax
  800cc3:	01 c0                	add    %eax,%eax
  800cc5:	01 d8                	add    %ebx,%eax
  800cc7:	83 e8 30             	sub    $0x30,%eax
  800cca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ccd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cd1:	0f b6 00             	movzbl (%rax),%eax
  800cd4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd7:	83 fb 2f             	cmp    $0x2f,%ebx
  800cda:	7e 63                	jle    800d3f <vprintfmt+0x163>
  800cdc:	83 fb 39             	cmp    $0x39,%ebx
  800cdf:	7f 5e                	jg     800d3f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce6:	eb d1                	jmp    800cb9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ce8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ceb:	83 f8 30             	cmp    $0x30,%eax
  800cee:	73 17                	jae    800d07 <vprintfmt+0x12b>
  800cf0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf7:	89 c0                	mov    %eax,%eax
  800cf9:	48 01 d0             	add    %rdx,%rax
  800cfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cff:	83 c2 08             	add    $0x8,%edx
  800d02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d05:	eb 0f                	jmp    800d16 <vprintfmt+0x13a>
  800d07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0b:	48 89 d0             	mov    %rdx,%rax
  800d0e:	48 83 c2 08          	add    $0x8,%rdx
  800d12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d16:	8b 00                	mov    (%rax),%eax
  800d18:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d1b:	eb 23                	jmp    800d40 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800d1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d21:	0f 89 42 ff ff ff    	jns    800c69 <vprintfmt+0x8d>
				width = 0;
  800d27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d2e:	e9 36 ff ff ff       	jmpq   800c69 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800d33:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d3a:	e9 2e ff ff ff       	jmpq   800c6d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d3f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d44:	0f 89 22 ff ff ff    	jns    800c6c <vprintfmt+0x90>
				width = precision, precision = -1;
  800d4a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d4d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d50:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d57:	e9 10 ff ff ff       	jmpq   800c6c <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d5c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d60:	e9 08 ff ff ff       	jmpq   800c6d <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d68:	83 f8 30             	cmp    $0x30,%eax
  800d6b:	73 17                	jae    800d84 <vprintfmt+0x1a8>
  800d6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d74:	89 c0                	mov    %eax,%eax
  800d76:	48 01 d0             	add    %rdx,%rax
  800d79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7c:	83 c2 08             	add    $0x8,%edx
  800d7f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d82:	eb 0f                	jmp    800d93 <vprintfmt+0x1b7>
  800d84:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d88:	48 89 d0             	mov    %rdx,%rax
  800d8b:	48 83 c2 08          	add    $0x8,%rdx
  800d8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d93:	8b 00                	mov    (%rax),%eax
  800d95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d99:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d9d:	48 89 d6             	mov    %rdx,%rsi
  800da0:	89 c7                	mov    %eax,%edi
  800da2:	ff d1                	callq  *%rcx
			break;
  800da4:	e9 5a 03 00 00       	jmpq   801103 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800da9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dac:	83 f8 30             	cmp    $0x30,%eax
  800daf:	73 17                	jae    800dc8 <vprintfmt+0x1ec>
  800db1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db8:	89 c0                	mov    %eax,%eax
  800dba:	48 01 d0             	add    %rdx,%rax
  800dbd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc0:	83 c2 08             	add    $0x8,%edx
  800dc3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc6:	eb 0f                	jmp    800dd7 <vprintfmt+0x1fb>
  800dc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dcc:	48 89 d0             	mov    %rdx,%rax
  800dcf:	48 83 c2 08          	add    $0x8,%rdx
  800dd3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dd9:	85 db                	test   %ebx,%ebx
  800ddb:	79 02                	jns    800ddf <vprintfmt+0x203>
				err = -err;
  800ddd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ddf:	83 fb 15             	cmp    $0x15,%ebx
  800de2:	7f 16                	jg     800dfa <vprintfmt+0x21e>
  800de4:	48 b8 00 48 80 00 00 	movabs $0x804800,%rax
  800deb:	00 00 00 
  800dee:	48 63 d3             	movslq %ebx,%rdx
  800df1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df5:	4d 85 e4             	test   %r12,%r12
  800df8:	75 2e                	jne    800e28 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800dfa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e02:	89 d9                	mov    %ebx,%ecx
  800e04:	48 ba c1 48 80 00 00 	movabs $0x8048c1,%rdx
  800e0b:	00 00 00 
  800e0e:	48 89 c7             	mov    %rax,%rdi
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	49 b8 13 11 80 00 00 	movabs $0x801113,%r8
  800e1d:	00 00 00 
  800e20:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e23:	e9 db 02 00 00       	jmpq   801103 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e30:	4c 89 e1             	mov    %r12,%rcx
  800e33:	48 ba ca 48 80 00 00 	movabs $0x8048ca,%rdx
  800e3a:	00 00 00 
  800e3d:	48 89 c7             	mov    %rax,%rdi
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	49 b8 13 11 80 00 00 	movabs $0x801113,%r8
  800e4c:	00 00 00 
  800e4f:	41 ff d0             	callq  *%r8
			break;
  800e52:	e9 ac 02 00 00       	jmpq   801103 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5a:	83 f8 30             	cmp    $0x30,%eax
  800e5d:	73 17                	jae    800e76 <vprintfmt+0x29a>
  800e5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e66:	89 c0                	mov    %eax,%eax
  800e68:	48 01 d0             	add    %rdx,%rax
  800e6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6e:	83 c2 08             	add    $0x8,%edx
  800e71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e74:	eb 0f                	jmp    800e85 <vprintfmt+0x2a9>
  800e76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e7a:	48 89 d0             	mov    %rdx,%rax
  800e7d:	48 83 c2 08          	add    $0x8,%rdx
  800e81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e85:	4c 8b 20             	mov    (%rax),%r12
  800e88:	4d 85 e4             	test   %r12,%r12
  800e8b:	75 0a                	jne    800e97 <vprintfmt+0x2bb>
				p = "(null)";
  800e8d:	49 bc cd 48 80 00 00 	movabs $0x8048cd,%r12
  800e94:	00 00 00 
			if (width > 0 && padc != '-')
  800e97:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9b:	7e 7a                	jle    800f17 <vprintfmt+0x33b>
  800e9d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ea1:	74 74                	je     800f17 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea6:	48 98                	cltq   
  800ea8:	48 89 c6             	mov    %rax,%rsi
  800eab:	4c 89 e7             	mov    %r12,%rdi
  800eae:	48 b8 be 13 80 00 00 	movabs $0x8013be,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	callq  *%rax
  800eba:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800ebf:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ec3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ecb:	48 89 d6             	mov    %rdx,%rsi
  800ece:	89 c7                	mov    %eax,%edi
  800ed0:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eda:	7f e3                	jg     800ebf <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800edc:	eb 39                	jmp    800f17 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800ede:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ee2:	74 1e                	je     800f02 <vprintfmt+0x326>
  800ee4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee7:	7e 05                	jle    800eee <vprintfmt+0x312>
  800ee9:	83 fb 7e             	cmp    $0x7e,%ebx
  800eec:	7e 14                	jle    800f02 <vprintfmt+0x326>
					putch('?', putdat);
  800eee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ef2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ef6:	48 89 c6             	mov    %rax,%rsi
  800ef9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800efe:	ff d2                	callq  *%rdx
  800f00:	eb 0f                	jmp    800f11 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800f02:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f06:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f0a:	48 89 c6             	mov    %rax,%rsi
  800f0d:	89 df                	mov    %ebx,%edi
  800f0f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f11:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f15:	eb 01                	jmp    800f18 <vprintfmt+0x33c>
  800f17:	90                   	nop
  800f18:	41 0f b6 04 24       	movzbl (%r12),%eax
  800f1d:	0f be d8             	movsbl %al,%ebx
  800f20:	85 db                	test   %ebx,%ebx
  800f22:	0f 95 c0             	setne  %al
  800f25:	49 83 c4 01          	add    $0x1,%r12
  800f29:	84 c0                	test   %al,%al
  800f2b:	74 28                	je     800f55 <vprintfmt+0x379>
  800f2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f31:	78 ab                	js     800ede <vprintfmt+0x302>
  800f33:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f3b:	79 a1                	jns    800ede <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f3d:	eb 16                	jmp    800f55 <vprintfmt+0x379>
				putch(' ', putdat);
  800f3f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f43:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f47:	48 89 c6             	mov    %rax,%rsi
  800f4a:	bf 20 00 00 00       	mov    $0x20,%edi
  800f4f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f59:	7f e4                	jg     800f3f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800f5b:	e9 a3 01 00 00       	jmpq   801103 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f64:	be 03 00 00 00       	mov    $0x3,%esi
  800f69:	48 89 c7             	mov    %rax,%rdi
  800f6c:	48 b8 cc 0a 80 00 00 	movabs $0x800acc,%rax
  800f73:	00 00 00 
  800f76:	ff d0                	callq  *%rax
  800f78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 85 c0             	test   %rax,%rax
  800f83:	79 1d                	jns    800fa2 <vprintfmt+0x3c6>
				putch('-', putdat);
  800f85:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f89:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f8d:	48 89 c6             	mov    %rax,%rsi
  800f90:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f95:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9b:	48 f7 d8             	neg    %rax
  800f9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fa2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa9:	e9 e8 00 00 00       	jmpq   801096 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fb2:	be 03 00 00 00       	mov    $0x3,%esi
  800fb7:	48 89 c7             	mov    %rax,%rdi
  800fba:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  800fc1:	00 00 00 
  800fc4:	ff d0                	callq  *%rax
  800fc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fd1:	e9 c0 00 00 00       	jmpq   801096 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fd6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fda:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fde:	48 89 c6             	mov    %rax,%rsi
  800fe1:	bf 58 00 00 00       	mov    $0x58,%edi
  800fe6:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800fe8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fec:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ff0:	48 89 c6             	mov    %rax,%rsi
  800ff3:	bf 58 00 00 00       	mov    $0x58,%edi
  800ff8:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800ffa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ffe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801002:	48 89 c6             	mov    %rax,%rsi
  801005:	bf 58 00 00 00       	mov    $0x58,%edi
  80100a:	ff d2                	callq  *%rdx
			break;
  80100c:	e9 f2 00 00 00       	jmpq   801103 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801011:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801015:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801019:	48 89 c6             	mov    %rax,%rsi
  80101c:	bf 30 00 00 00       	mov    $0x30,%edi
  801021:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801023:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801027:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80102b:	48 89 c6             	mov    %rax,%rsi
  80102e:	bf 78 00 00 00       	mov    $0x78,%edi
  801033:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801035:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801038:	83 f8 30             	cmp    $0x30,%eax
  80103b:	73 17                	jae    801054 <vprintfmt+0x478>
  80103d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801041:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801044:	89 c0                	mov    %eax,%eax
  801046:	48 01 d0             	add    %rdx,%rax
  801049:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80104c:	83 c2 08             	add    $0x8,%edx
  80104f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801052:	eb 0f                	jmp    801063 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801054:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801058:	48 89 d0             	mov    %rdx,%rax
  80105b:	48 83 c2 08          	add    $0x8,%rdx
  80105f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801063:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80106a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801071:	eb 23                	jmp    801096 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801073:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801077:	be 03 00 00 00       	mov    $0x3,%esi
  80107c:	48 89 c7             	mov    %rax,%rdi
  80107f:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  801086:	00 00 00 
  801089:	ff d0                	callq  *%rax
  80108b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80108f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801096:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80109b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80109e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ad:	45 89 c1             	mov    %r8d,%r9d
  8010b0:	41 89 f8             	mov    %edi,%r8d
  8010b3:	48 89 c7             	mov    %rax,%rdi
  8010b6:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	callq  *%rax
			break;
  8010c2:	eb 3f                	jmp    801103 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010c4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010c8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010cc:	48 89 c6             	mov    %rax,%rsi
  8010cf:	89 df                	mov    %ebx,%edi
  8010d1:	ff d2                	callq  *%rdx
			break;
  8010d3:	eb 2e                	jmp    801103 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010d9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010dd:	48 89 c6             	mov    %rax,%rsi
  8010e0:	bf 25 00 00 00       	mov    $0x25,%edi
  8010e5:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010ec:	eb 05                	jmp    8010f3 <vprintfmt+0x517>
  8010ee:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010f7:	48 83 e8 01          	sub    $0x1,%rax
  8010fb:	0f b6 00             	movzbl (%rax),%eax
  8010fe:	3c 25                	cmp    $0x25,%al
  801100:	75 ec                	jne    8010ee <vprintfmt+0x512>
				/* do nothing */;
			break;
  801102:	90                   	nop
		}
	}
  801103:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801104:	e9 25 fb ff ff       	jmpq   800c2e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801109:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80110a:	48 83 c4 60          	add    $0x60,%rsp
  80110e:	5b                   	pop    %rbx
  80110f:	41 5c                	pop    %r12
  801111:	5d                   	pop    %rbp
  801112:	c3                   	retq   

0000000000801113 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80111e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801125:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80112c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801133:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80113a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801141:	84 c0                	test   %al,%al
  801143:	74 20                	je     801165 <printfmt+0x52>
  801145:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801149:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80114d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801151:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801155:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801159:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80115d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801161:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801165:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80116c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801173:	00 00 00 
  801176:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80117d:	00 00 00 
  801180:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801184:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80118b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801192:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801199:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011a0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011a7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011ae:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011b5:	48 89 c7             	mov    %rax,%rdi
  8011b8:	48 b8 dc 0b 80 00 00 	movabs $0x800bdc,%rax
  8011bf:	00 00 00 
  8011c2:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011c4:	c9                   	leaveq 
  8011c5:	c3                   	retq   

00000000008011c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011c6:	55                   	push   %rbp
  8011c7:	48 89 e5             	mov    %rsp,%rbp
  8011ca:	48 83 ec 10          	sub    $0x10,%rsp
  8011ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d9:	8b 40 10             	mov    0x10(%rax),%eax
  8011dc:	8d 50 01             	lea    0x1(%rax),%edx
  8011df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ea:	48 8b 10             	mov    (%rax),%rdx
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011f5:	48 39 c2             	cmp    %rax,%rdx
  8011f8:	73 17                	jae    801211 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fe:	48 8b 00             	mov    (%rax),%rax
  801201:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801204:	88 10                	mov    %dl,(%rax)
  801206:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	48 89 10             	mov    %rdx,(%rax)
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 50          	sub    $0x50,%rsp
  80121b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80121f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801222:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801226:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80122a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80122e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801232:	48 8b 0a             	mov    (%rdx),%rcx
  801235:	48 89 08             	mov    %rcx,(%rax)
  801238:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80123c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801240:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801244:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801248:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80124c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801250:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801253:	48 98                	cltq   
  801255:	48 83 e8 01          	sub    $0x1,%rax
  801259:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80125d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801261:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801268:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80126d:	74 06                	je     801275 <vsnprintf+0x62>
  80126f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801273:	7f 07                	jg     80127c <vsnprintf+0x69>
		return -E_INVAL;
  801275:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127a:	eb 2f                	jmp    8012ab <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80127c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801280:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801284:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801288:	48 89 c6             	mov    %rax,%rsi
  80128b:	48 bf c6 11 80 00 00 	movabs $0x8011c6,%rdi
  801292:	00 00 00 
  801295:	48 b8 dc 0b 80 00 00 	movabs $0x800bdc,%rax
  80129c:	00 00 00 
  80129f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012a5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012a8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012ab:	c9                   	leaveq 
  8012ac:	c3                   	retq   

00000000008012ad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ad:	55                   	push   %rbp
  8012ae:	48 89 e5             	mov    %rsp,%rbp
  8012b1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012b8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012bf:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012c5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012cc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012d3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012da:	84 c0                	test   %al,%al
  8012dc:	74 20                	je     8012fe <snprintf+0x51>
  8012de:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012e2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012e6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012ea:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012ee:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012f2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012f6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012fa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012fe:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801305:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80130c:	00 00 00 
  80130f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801316:	00 00 00 
  801319:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80131d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801324:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80132b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801332:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801339:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801340:	48 8b 0a             	mov    (%rdx),%rcx
  801343:	48 89 08             	mov    %rcx,(%rax)
  801346:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80134a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80134e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801352:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801356:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80135d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801364:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80136a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801371:	48 89 c7             	mov    %rax,%rdi
  801374:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  80137b:	00 00 00 
  80137e:	ff d0                	callq  *%rax
  801380:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801386:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   
	...

0000000000801390 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801390:	55                   	push   %rbp
  801391:	48 89 e5             	mov    %rsp,%rbp
  801394:	48 83 ec 18          	sub    $0x18,%rsp
  801398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80139c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013a3:	eb 09                	jmp    8013ae <strlen+0x1e>
		n++;
  8013a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	84 c0                	test   %al,%al
  8013b7:	75 ec                	jne    8013a5 <strlen+0x15>
		n++;
	return n;
  8013b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013bc:	c9                   	leaveq 
  8013bd:	c3                   	retq   

00000000008013be <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013be:	55                   	push   %rbp
  8013bf:	48 89 e5             	mov    %rsp,%rbp
  8013c2:	48 83 ec 20          	sub    $0x20,%rsp
  8013c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013d5:	eb 0e                	jmp    8013e5 <strnlen+0x27>
		n++;
  8013d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013e0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013e5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013ea:	74 0b                	je     8013f7 <strnlen+0x39>
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 e0                	jne    8013d7 <strnlen+0x19>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013fa:	c9                   	leaveq 
  8013fb:	c3                   	retq   

00000000008013fc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 83 ec 20          	sub    $0x20,%rsp
  801404:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801408:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80140c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801410:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801414:	90                   	nop
  801415:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801419:	0f b6 10             	movzbl (%rax),%edx
  80141c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801420:	88 10                	mov    %dl,(%rax)
  801422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	84 c0                	test   %al,%al
  80142b:	0f 95 c0             	setne  %al
  80142e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801433:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801438:	84 c0                	test   %al,%al
  80143a:	75 d9                	jne    801415 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801440:	c9                   	leaveq 
  801441:	c3                   	retq   

0000000000801442 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801442:	55                   	push   %rbp
  801443:	48 89 e5             	mov    %rsp,%rbp
  801446:	48 83 ec 20          	sub    $0x20,%rsp
  80144a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801456:	48 89 c7             	mov    %rax,%rdi
  801459:	48 b8 90 13 80 00 00 	movabs $0x801390,%rax
  801460:	00 00 00 
  801463:	ff d0                	callq  *%rax
  801465:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80146b:	48 98                	cltq   
  80146d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801471:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801475:	48 89 d6             	mov    %rdx,%rsi
  801478:	48 89 c7             	mov    %rax,%rdi
  80147b:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  801482:	00 00 00 
  801485:	ff d0                	callq  *%rax
	return dst;
  801487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148b:	c9                   	leaveq 
  80148c:	c3                   	retq   

000000000080148d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80148d:	55                   	push   %rbp
  80148e:	48 89 e5             	mov    %rsp,%rbp
  801491:	48 83 ec 28          	sub    $0x28,%rsp
  801495:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801499:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014a9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014b0:	00 
  8014b1:	eb 27                	jmp    8014da <strncpy+0x4d>
		*dst++ = *src;
  8014b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b7:	0f b6 10             	movzbl (%rax),%edx
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	88 10                	mov    %dl,(%rax)
  8014c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	84 c0                	test   %al,%al
  8014ce:	74 05                	je     8014d5 <strncpy+0x48>
			src++;
  8014d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014e2:	72 cf                	jb     8014b3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e8:	c9                   	leaveq 
  8014e9:	c3                   	retq   

00000000008014ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	48 83 ec 28          	sub    $0x28,%rsp
  8014f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801506:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80150b:	74 37                	je     801544 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80150d:	eb 17                	jmp    801526 <strlcpy+0x3c>
			*dst++ = *src++;
  80150f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801513:	0f b6 10             	movzbl (%rax),%edx
  801516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151a:	88 10                	mov    %dl,(%rax)
  80151c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801521:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801526:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80152b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801530:	74 0b                	je     80153d <strlcpy+0x53>
  801532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	84 c0                	test   %al,%al
  80153b:	75 d2                	jne    80150f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80153d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801541:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801544:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	48 89 d1             	mov    %rdx,%rcx
  80154f:	48 29 c1             	sub    %rax,%rcx
  801552:	48 89 c8             	mov    %rcx,%rax
}
  801555:	c9                   	leaveq 
  801556:	c3                   	retq   

0000000000801557 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801557:	55                   	push   %rbp
  801558:	48 89 e5             	mov    %rsp,%rbp
  80155b:	48 83 ec 10          	sub    $0x10,%rsp
  80155f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801563:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801567:	eb 0a                	jmp    801573 <strcmp+0x1c>
		p++, q++;
  801569:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801577:	0f b6 00             	movzbl (%rax),%eax
  80157a:	84 c0                	test   %al,%al
  80157c:	74 12                	je     801590 <strcmp+0x39>
  80157e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801582:	0f b6 10             	movzbl (%rax),%edx
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	38 c2                	cmp    %al,%dl
  80158e:	74 d9                	je     801569 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	0f b6 d0             	movzbl %al,%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	0f b6 c0             	movzbl %al,%eax
  8015a4:	89 d1                	mov    %edx,%ecx
  8015a6:	29 c1                	sub    %eax,%ecx
  8015a8:	89 c8                	mov    %ecx,%eax
}
  8015aa:	c9                   	leaveq 
  8015ab:	c3                   	retq   

00000000008015ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015ac:	55                   	push   %rbp
  8015ad:	48 89 e5             	mov    %rsp,%rbp
  8015b0:	48 83 ec 18          	sub    $0x18,%rsp
  8015b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015c0:	eb 0f                	jmp    8015d1 <strncmp+0x25>
		n--, p++, q++;
  8015c2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d6:	74 1d                	je     8015f5 <strncmp+0x49>
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	84 c0                	test   %al,%al
  8015e1:	74 12                	je     8015f5 <strncmp+0x49>
  8015e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e7:	0f b6 10             	movzbl (%rax),%edx
  8015ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	38 c2                	cmp    %al,%dl
  8015f3:	74 cd                	je     8015c2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015fa:	75 07                	jne    801603 <strncmp+0x57>
		return 0;
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801601:	eb 1a                	jmp    80161d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	0f b6 d0             	movzbl %al,%edx
  80160d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	0f b6 c0             	movzbl %al,%eax
  801617:	89 d1                	mov    %edx,%ecx
  801619:	29 c1                	sub    %eax,%ecx
  80161b:	89 c8                	mov    %ecx,%eax
}
  80161d:	c9                   	leaveq 
  80161e:	c3                   	retq   

000000000080161f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80161f:	55                   	push   %rbp
  801620:	48 89 e5             	mov    %rsp,%rbp
  801623:	48 83 ec 10          	sub    $0x10,%rsp
  801627:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80162b:	89 f0                	mov    %esi,%eax
  80162d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801630:	eb 17                	jmp    801649 <strchr+0x2a>
		if (*s == c)
  801632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80163c:	75 06                	jne    801644 <strchr+0x25>
			return (char *) s;
  80163e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801642:	eb 15                	jmp    801659 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801644:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	84 c0                	test   %al,%al
  801652:	75 de                	jne    801632 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801659:	c9                   	leaveq 
  80165a:	c3                   	retq   

000000000080165b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80165b:	55                   	push   %rbp
  80165c:	48 89 e5             	mov    %rsp,%rbp
  80165f:	48 83 ec 10          	sub    $0x10,%rsp
  801663:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801667:	89 f0                	mov    %esi,%eax
  801669:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80166c:	eb 11                	jmp    80167f <strfind+0x24>
		if (*s == c)
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801678:	74 12                	je     80168c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80167a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801683:	0f b6 00             	movzbl (%rax),%eax
  801686:	84 c0                	test   %al,%al
  801688:	75 e4                	jne    80166e <strfind+0x13>
  80168a:	eb 01                	jmp    80168d <strfind+0x32>
		if (*s == c)
			break;
  80168c:	90                   	nop
	return (char *) s;
  80168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801691:	c9                   	leaveq 
  801692:	c3                   	retq   

0000000000801693 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	48 83 ec 18          	sub    $0x18,%rsp
  80169b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016ab:	75 06                	jne    8016b3 <memset+0x20>
		return v;
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	eb 69                	jmp    80171c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b7:	83 e0 03             	and    $0x3,%eax
  8016ba:	48 85 c0             	test   %rax,%rax
  8016bd:	75 48                	jne    801707 <memset+0x74>
  8016bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c3:	83 e0 03             	and    $0x3,%eax
  8016c6:	48 85 c0             	test   %rax,%rax
  8016c9:	75 3c                	jne    801707 <memset+0x74>
		c &= 0xFF;
  8016cb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	c1 e2 18             	shl    $0x18,%edx
  8016da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016dd:	c1 e0 10             	shl    $0x10,%eax
  8016e0:	09 c2                	or     %eax,%edx
  8016e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e5:	c1 e0 08             	shl    $0x8,%eax
  8016e8:	09 d0                	or     %edx,%eax
  8016ea:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f1:	48 89 c1             	mov    %rax,%rcx
  8016f4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ff:	48 89 d7             	mov    %rdx,%rdi
  801702:	fc                   	cld    
  801703:	f3 ab                	rep stos %eax,%es:(%rdi)
  801705:	eb 11                	jmp    801718 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801707:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80170e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801712:	48 89 d7             	mov    %rdx,%rdi
  801715:	fc                   	cld    
  801716:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	48 83 ec 28          	sub    $0x28,%rsp
  801726:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80172a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80172e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801732:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801736:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80173a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801746:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80174a:	0f 83 88 00 00 00    	jae    8017d8 <memmove+0xba>
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801758:	48 01 d0             	add    %rdx,%rax
  80175b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80175f:	76 77                	jbe    8017d8 <memmove+0xba>
		s += n;
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801771:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801775:	83 e0 03             	and    $0x3,%eax
  801778:	48 85 c0             	test   %rax,%rax
  80177b:	75 3b                	jne    8017b8 <memmove+0x9a>
  80177d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801781:	83 e0 03             	and    $0x3,%eax
  801784:	48 85 c0             	test   %rax,%rax
  801787:	75 2f                	jne    8017b8 <memmove+0x9a>
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	83 e0 03             	and    $0x3,%eax
  801790:	48 85 c0             	test   %rax,%rax
  801793:	75 23                	jne    8017b8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801799:	48 83 e8 04          	sub    $0x4,%rax
  80179d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a1:	48 83 ea 04          	sub    $0x4,%rdx
  8017a5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017a9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017ad:	48 89 c7             	mov    %rax,%rdi
  8017b0:	48 89 d6             	mov    %rdx,%rsi
  8017b3:	fd                   	std    
  8017b4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017b6:	eb 1d                	jmp    8017d5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	48 89 d7             	mov    %rdx,%rdi
  8017cf:	48 89 c1             	mov    %rax,%rcx
  8017d2:	fd                   	std    
  8017d3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017d5:	fc                   	cld    
  8017d6:	eb 57                	jmp    80182f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017dc:	83 e0 03             	and    $0x3,%eax
  8017df:	48 85 c0             	test   %rax,%rax
  8017e2:	75 36                	jne    80181a <memmove+0xfc>
  8017e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e8:	83 e0 03             	and    $0x3,%eax
  8017eb:	48 85 c0             	test   %rax,%rax
  8017ee:	75 2a                	jne    80181a <memmove+0xfc>
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	83 e0 03             	and    $0x3,%eax
  8017f7:	48 85 c0             	test   %rax,%rax
  8017fa:	75 1e                	jne    80181a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 89 c1             	mov    %rax,%rcx
  801803:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80180f:	48 89 c7             	mov    %rax,%rdi
  801812:	48 89 d6             	mov    %rdx,%rsi
  801815:	fc                   	cld    
  801816:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801818:	eb 15                	jmp    80182f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80181a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801822:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801826:	48 89 c7             	mov    %rax,%rdi
  801829:	48 89 d6             	mov    %rdx,%rsi
  80182c:	fc                   	cld    
  80182d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80182f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801833:	c9                   	leaveq 
  801834:	c3                   	retq   

0000000000801835 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801835:	55                   	push   %rbp
  801836:	48 89 e5             	mov    %rsp,%rbp
  801839:	48 83 ec 18          	sub    $0x18,%rsp
  80183d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801845:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801855:	48 89 ce             	mov    %rcx,%rsi
  801858:	48 89 c7             	mov    %rax,%rdi
  80185b:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  801862:	00 00 00 
  801865:	ff d0                	callq  *%rax
}
  801867:	c9                   	leaveq 
  801868:	c3                   	retq   

0000000000801869 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801869:	55                   	push   %rbp
  80186a:	48 89 e5             	mov    %rsp,%rbp
  80186d:	48 83 ec 28          	sub    $0x28,%rsp
  801871:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801875:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80187d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801885:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801889:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80188d:	eb 38                	jmp    8018c7 <memcmp+0x5e>
		if (*s1 != *s2)
  80188f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801893:	0f b6 10             	movzbl (%rax),%edx
  801896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189a:	0f b6 00             	movzbl (%rax),%eax
  80189d:	38 c2                	cmp    %al,%dl
  80189f:	74 1c                	je     8018bd <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8018a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	0f b6 d0             	movzbl %al,%edx
  8018ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	89 d1                	mov    %edx,%ecx
  8018b7:	29 c1                	sub    %eax,%ecx
  8018b9:	89 c8                	mov    %ecx,%eax
  8018bb:	eb 20                	jmp    8018dd <memcmp+0x74>
		s1++, s2++;
  8018bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018cc:	0f 95 c0             	setne  %al
  8018cf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8018d4:	84 c0                	test   %al,%al
  8018d6:	75 b7                	jne    80188f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018dd:	c9                   	leaveq 
  8018de:	c3                   	retq   

00000000008018df <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018df:	55                   	push   %rbp
  8018e0:	48 89 e5             	mov    %rsp,%rbp
  8018e3:	48 83 ec 28          	sub    $0x28,%rsp
  8018e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018fa:	48 01 d0             	add    %rdx,%rax
  8018fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801901:	eb 13                	jmp    801916 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801907:	0f b6 10             	movzbl (%rax),%edx
  80190a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80190d:	38 c2                	cmp    %al,%dl
  80190f:	74 11                	je     801922 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801911:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80191e:	72 e3                	jb     801903 <memfind+0x24>
  801920:	eb 01                	jmp    801923 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801922:	90                   	nop
	return (void *) s;
  801923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801927:	c9                   	leaveq 
  801928:	c3                   	retq   

0000000000801929 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801929:	55                   	push   %rbp
  80192a:	48 89 e5             	mov    %rsp,%rbp
  80192d:	48 83 ec 38          	sub    $0x38,%rsp
  801931:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801935:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801939:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80193c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801943:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80194a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80194b:	eb 05                	jmp    801952 <strtol+0x29>
		s++;
  80194d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	3c 20                	cmp    $0x20,%al
  80195b:	74 f0                	je     80194d <strtol+0x24>
  80195d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801961:	0f b6 00             	movzbl (%rax),%eax
  801964:	3c 09                	cmp    $0x9,%al
  801966:	74 e5                	je     80194d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196c:	0f b6 00             	movzbl (%rax),%eax
  80196f:	3c 2b                	cmp    $0x2b,%al
  801971:	75 07                	jne    80197a <strtol+0x51>
		s++;
  801973:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801978:	eb 17                	jmp    801991 <strtol+0x68>
	else if (*s == '-')
  80197a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197e:	0f b6 00             	movzbl (%rax),%eax
  801981:	3c 2d                	cmp    $0x2d,%al
  801983:	75 0c                	jne    801991 <strtol+0x68>
		s++, neg = 1;
  801985:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801991:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801995:	74 06                	je     80199d <strtol+0x74>
  801997:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80199b:	75 28                	jne    8019c5 <strtol+0x9c>
  80199d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a1:	0f b6 00             	movzbl (%rax),%eax
  8019a4:	3c 30                	cmp    $0x30,%al
  8019a6:	75 1d                	jne    8019c5 <strtol+0x9c>
  8019a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ac:	48 83 c0 01          	add    $0x1,%rax
  8019b0:	0f b6 00             	movzbl (%rax),%eax
  8019b3:	3c 78                	cmp    $0x78,%al
  8019b5:	75 0e                	jne    8019c5 <strtol+0x9c>
		s += 2, base = 16;
  8019b7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019bc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019c3:	eb 2c                	jmp    8019f1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019c9:	75 19                	jne    8019e4 <strtol+0xbb>
  8019cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cf:	0f b6 00             	movzbl (%rax),%eax
  8019d2:	3c 30                	cmp    $0x30,%al
  8019d4:	75 0e                	jne    8019e4 <strtol+0xbb>
		s++, base = 8;
  8019d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019db:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019e2:	eb 0d                	jmp    8019f1 <strtol+0xc8>
	else if (base == 0)
  8019e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019e8:	75 07                	jne    8019f1 <strtol+0xc8>
		base = 10;
  8019ea:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f5:	0f b6 00             	movzbl (%rax),%eax
  8019f8:	3c 2f                	cmp    $0x2f,%al
  8019fa:	7e 1d                	jle    801a19 <strtol+0xf0>
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	3c 39                	cmp    $0x39,%al
  801a05:	7f 12                	jg     801a19 <strtol+0xf0>
			dig = *s - '0';
  801a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0b:	0f b6 00             	movzbl (%rax),%eax
  801a0e:	0f be c0             	movsbl %al,%eax
  801a11:	83 e8 30             	sub    $0x30,%eax
  801a14:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a17:	eb 4e                	jmp    801a67 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	3c 60                	cmp    $0x60,%al
  801a22:	7e 1d                	jle    801a41 <strtol+0x118>
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	3c 7a                	cmp    $0x7a,%al
  801a2d:	7f 12                	jg     801a41 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a33:	0f b6 00             	movzbl (%rax),%eax
  801a36:	0f be c0             	movsbl %al,%eax
  801a39:	83 e8 57             	sub    $0x57,%eax
  801a3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a3f:	eb 26                	jmp    801a67 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	0f b6 00             	movzbl (%rax),%eax
  801a48:	3c 40                	cmp    $0x40,%al
  801a4a:	7e 47                	jle    801a93 <strtol+0x16a>
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	0f b6 00             	movzbl (%rax),%eax
  801a53:	3c 5a                	cmp    $0x5a,%al
  801a55:	7f 3c                	jg     801a93 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5b:	0f b6 00             	movzbl (%rax),%eax
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	83 e8 37             	sub    $0x37,%eax
  801a64:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a6a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a6d:	7d 23                	jge    801a92 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a6f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a74:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 89 c2             	mov    %rax,%rdx
  801a7c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801a81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 01 d0             	add    %rdx,%rax
  801a89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a8d:	e9 5f ff ff ff       	jmpq   8019f1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a92:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a93:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a98:	74 0b                	je     801aa5 <strtol+0x17c>
		*endptr = (char *) s;
  801a9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aa2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801aa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aa9:	74 09                	je     801ab4 <strtol+0x18b>
  801aab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aaf:	48 f7 d8             	neg    %rax
  801ab2:	eb 04                	jmp    801ab8 <strtol+0x18f>
  801ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ab8:	c9                   	leaveq 
  801ab9:	c3                   	retq   

0000000000801aba <strstr>:

char * strstr(const char *in, const char *str)
{
  801aba:	55                   	push   %rbp
  801abb:	48 89 e5             	mov    %rsp,%rbp
  801abe:	48 83 ec 30          	sub    $0x30,%rsp
  801ac2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ac6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801aca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ace:	0f b6 00             	movzbl (%rax),%eax
  801ad1:	88 45 ff             	mov    %al,-0x1(%rbp)
  801ad4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801ad9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801add:	75 06                	jne    801ae5 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801adf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae3:	eb 68                	jmp    801b4d <strstr+0x93>

	len = strlen(str);
  801ae5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae9:	48 89 c7             	mov    %rax,%rdi
  801aec:	48 b8 90 13 80 00 00 	movabs $0x801390,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
  801af8:	48 98                	cltq   
  801afa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801afe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b02:	0f b6 00             	movzbl (%rax),%eax
  801b05:	88 45 ef             	mov    %al,-0x11(%rbp)
  801b08:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801b0d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b11:	75 07                	jne    801b1a <strstr+0x60>
				return (char *) 0;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
  801b18:	eb 33                	jmp    801b4d <strstr+0x93>
		} while (sc != c);
  801b1a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b1e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b21:	75 db                	jne    801afe <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801b23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b27:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2f:	48 89 ce             	mov    %rcx,%rsi
  801b32:	48 89 c7             	mov    %rax,%rdi
  801b35:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	callq  *%rax
  801b41:	85 c0                	test   %eax,%eax
  801b43:	75 b9                	jne    801afe <strstr+0x44>

	return (char *) (in - 1);
  801b45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b49:	48 83 e8 01          	sub    $0x1,%rax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   
	...

0000000000801b50 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	53                   	push   %rbx
  801b55:	48 83 ec 58          	sub    $0x58,%rsp
  801b59:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b5c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b5f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b63:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b67:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b6b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b6f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b72:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801b75:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b79:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b7d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b81:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b85:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b89:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801b8c:	4c 89 c3             	mov    %r8,%rbx
  801b8f:	cd 30                	int    $0x30
  801b91:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801b95:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b9d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ba1:	74 3e                	je     801be1 <syscall+0x91>
  801ba3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ba8:	7e 37                	jle    801be1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bb1:	49 89 d0             	mov    %rdx,%r8
  801bb4:	89 c1                	mov    %eax,%ecx
  801bb6:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  801bbd:	00 00 00 
  801bc0:	be 23 00 00 00       	mov    $0x23,%esi
  801bc5:	48 bf a5 4b 80 00 00 	movabs $0x804ba5,%rdi
  801bcc:	00 00 00 
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	49 b9 f0 05 80 00 00 	movabs $0x8005f0,%r9
  801bdb:	00 00 00 
  801bde:	41 ff d1             	callq  *%r9

	return ret;
  801be1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801be5:	48 83 c4 58          	add    $0x58,%rsp
  801be9:	5b                   	pop    %rbx
  801bea:	5d                   	pop    %rbp
  801beb:	c3                   	retq   

0000000000801bec <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 20          	sub    $0x20,%rsp
  801bf4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0b:	00 
  801c0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c18:	48 89 d1             	mov    %rdx,%rcx
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	be 00 00 00 00       	mov    $0x0,%esi
  801c23:	bf 00 00 00 00       	mov    $0x0,%edi
  801c28:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	callq  *%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c45:	00 
  801c46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5c:	be 00 00 00 00       	mov    $0x0,%esi
  801c61:	bf 01 00 00 00       	mov    $0x1,%edi
  801c66:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801c6d:	00 00 00 
  801c70:	ff d0                	callq  *%rax
}
  801c72:	c9                   	leaveq 
  801c73:	c3                   	retq   

0000000000801c74 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c74:	55                   	push   %rbp
  801c75:	48 89 e5             	mov    %rsp,%rbp
  801c78:	48 83 ec 20          	sub    $0x20,%rsp
  801c7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c82:	48 98                	cltq   
  801c84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8b:	00 
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	48 89 c2             	mov    %rax,%rdx
  801ca0:	be 01 00 00 00       	mov    $0x1,%esi
  801ca5:	bf 03 00 00 00       	mov    $0x3,%edi
  801caa:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	callq  *%rax
}
  801cb6:	c9                   	leaveq 
  801cb7:	c3                   	retq   

0000000000801cb8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cb8:	55                   	push   %rbp
  801cb9:	48 89 e5             	mov    %rsp,%rbp
  801cbc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cc0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc7:	00 
  801cc8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cde:	be 00 00 00 00       	mov    $0x0,%esi
  801ce3:	bf 02 00 00 00       	mov    $0x2,%edi
  801ce8:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <sys_yield>:

void
sys_yield(void)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cfe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d05:	00 
  801d06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	be 00 00 00 00       	mov    $0x0,%esi
  801d21:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d26:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	callq  *%rax
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 20          	sub    $0x20,%rsp
  801d3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d43:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d49:	48 63 c8             	movslq %eax,%rcx
  801d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5c:	00 
  801d5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d63:	49 89 c8             	mov    %rcx,%r8
  801d66:	48 89 d1             	mov    %rdx,%rcx
  801d69:	48 89 c2             	mov    %rax,%rdx
  801d6c:	be 01 00 00 00       	mov    $0x1,%esi
  801d71:	bf 04 00 00 00       	mov    $0x4,%edi
  801d76:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
}
  801d82:	c9                   	leaveq 
  801d83:	c3                   	retq   

0000000000801d84 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d84:	55                   	push   %rbp
  801d85:	48 89 e5             	mov    %rsp,%rbp
  801d88:	48 83 ec 30          	sub    $0x30,%rsp
  801d8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d93:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d96:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d9a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801da1:	48 63 c8             	movslq %eax,%rcx
  801da4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dab:	48 63 f0             	movslq %eax,%rsi
  801dae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db5:	48 98                	cltq   
  801db7:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dbb:	49 89 f9             	mov    %rdi,%r9
  801dbe:	49 89 f0             	mov    %rsi,%r8
  801dc1:	48 89 d1             	mov    %rdx,%rcx
  801dc4:	48 89 c2             	mov    %rax,%rdx
  801dc7:	be 01 00 00 00       	mov    $0x1,%esi
  801dcc:	bf 05 00 00 00       	mov    $0x5,%edi
  801dd1:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 20          	sub    $0x20,%rsp
  801de7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df5:	48 98                	cltq   
  801df7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfe:	00 
  801dff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0b:	48 89 d1             	mov    %rdx,%rcx
  801e0e:	48 89 c2             	mov    %rax,%rdx
  801e11:	be 01 00 00 00       	mov    $0x1,%esi
  801e16:	bf 06 00 00 00       	mov    $0x6,%edi
  801e1b:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
}
  801e27:	c9                   	leaveq 
  801e28:	c3                   	retq   

0000000000801e29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	48 83 ec 20          	sub    $0x20,%rsp
  801e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e3a:	48 63 d0             	movslq %eax,%rdx
  801e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e40:	48 98                	cltq   
  801e42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e49:	00 
  801e4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e56:	48 89 d1             	mov    %rdx,%rcx
  801e59:	48 89 c2             	mov    %rax,%rdx
  801e5c:	be 01 00 00 00       	mov    $0x1,%esi
  801e61:	bf 08 00 00 00       	mov    $0x8,%edi
  801e66:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
}
  801e72:	c9                   	leaveq 
  801e73:	c3                   	retq   

0000000000801e74 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 20          	sub    $0x20,%rsp
  801e7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8a:	48 98                	cltq   
  801e8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e93:	00 
  801e94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea0:	48 89 d1             	mov    %rdx,%rcx
  801ea3:	48 89 c2             	mov    %rax,%rdx
  801ea6:	be 01 00 00 00       	mov    $0x1,%esi
  801eab:	bf 09 00 00 00       	mov    $0x9,%edi
  801eb0:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
}
  801ebc:	c9                   	leaveq 
  801ebd:	c3                   	retq   

0000000000801ebe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	48 83 ec 20          	sub    $0x20,%rsp
  801ec6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ecd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed4:	48 98                	cltq   
  801ed6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edd:	00 
  801ede:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eea:	48 89 d1             	mov    %rdx,%rcx
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	be 01 00 00 00       	mov    $0x1,%esi
  801ef5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801efa:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 30          	sub    $0x30,%rsp
  801f10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f17:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f1b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f21:	48 63 f0             	movslq %eax,%rsi
  801f24:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2b:	48 98                	cltq   
  801f2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f38:	00 
  801f39:	49 89 f1             	mov    %rsi,%r9
  801f3c:	49 89 c8             	mov    %rcx,%r8
  801f3f:	48 89 d1             	mov    %rdx,%rcx
  801f42:	48 89 c2             	mov    %rax,%rdx
  801f45:	be 00 00 00 00       	mov    $0x0,%esi
  801f4a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f4f:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801f56:	00 00 00 
  801f59:	ff d0                	callq  *%rax
}
  801f5b:	c9                   	leaveq 
  801f5c:	c3                   	retq   

0000000000801f5d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f5d:	55                   	push   %rbp
  801f5e:	48 89 e5             	mov    %rsp,%rbp
  801f61:	48 83 ec 20          	sub    $0x20,%rsp
  801f65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f74:	00 
  801f75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f86:	48 89 c2             	mov    %rax,%rdx
  801f89:	be 01 00 00 00       	mov    $0x1,%esi
  801f8e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f93:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	callq  *%rax
}
  801f9f:	c9                   	leaveq 
  801fa0:	c3                   	retq   

0000000000801fa1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801fa1:	55                   	push   %rbp
  801fa2:	48 89 e5             	mov    %rsp,%rbp
  801fa5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fa9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fb0:	00 
  801fb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc7:	be 00 00 00 00       	mov    $0x0,%esi
  801fcc:	bf 0e 00 00 00       	mov    $0xe,%edi
  801fd1:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
}
  801fdd:	c9                   	leaveq 
  801fde:	c3                   	retq   

0000000000801fdf <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801fdf:	55                   	push   %rbp
  801fe0:	48 89 e5             	mov    %rsp,%rbp
  801fe3:	48 83 ec 30          	sub    $0x30,%rsp
  801fe7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fee:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ff1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ff5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801ff9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ffc:	48 63 c8             	movslq %eax,%rcx
  801fff:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802003:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802006:	48 63 f0             	movslq %eax,%rsi
  802009:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802010:	48 98                	cltq   
  802012:	48 89 0c 24          	mov    %rcx,(%rsp)
  802016:	49 89 f9             	mov    %rdi,%r9
  802019:	49 89 f0             	mov    %rsi,%r8
  80201c:	48 89 d1             	mov    %rdx,%rcx
  80201f:	48 89 c2             	mov    %rax,%rdx
  802022:	be 00 00 00 00       	mov    $0x0,%esi
  802027:	bf 0f 00 00 00       	mov    $0xf,%edi
  80202c:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  802033:	00 00 00 
  802036:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 20          	sub    $0x20,%rsp
  802042:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802046:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80204a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80204e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802052:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802059:	00 
  80205a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802060:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802066:	48 89 d1             	mov    %rdx,%rcx
  802069:	48 89 c2             	mov    %rax,%rdx
  80206c:	be 00 00 00 00       	mov    $0x0,%esi
  802071:	bf 10 00 00 00       	mov    $0x10,%edi
  802076:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  80207d:	00 00 00 
  802080:	ff d0                	callq  *%rax
}
  802082:	c9                   	leaveq 
  802083:	c3                   	retq   

0000000000802084 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
  802088:	48 83 ec 18          	sub    $0x18,%rsp
  80208c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802090:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802094:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020a0:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8020a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8020af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b3:	8b 00                	mov    (%rax),%eax
  8020b5:	83 f8 01             	cmp    $0x1,%eax
  8020b8:	7e 13                	jle    8020cd <argstart+0x49>
  8020ba:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8020bf:	74 0c                	je     8020cd <argstart+0x49>
  8020c1:	48 b8 b3 4b 80 00 00 	movabs $0x804bb3,%rax
  8020c8:	00 00 00 
  8020cb:	eb 05                	jmp    8020d2 <argstart+0x4e>
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d6:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8020da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020de:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8020e5:	00 
}
  8020e6:	c9                   	leaveq 
  8020e7:	c3                   	retq   

00000000008020e8 <argnext>:

int
argnext(struct Argstate *args)
{
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	48 83 ec 20          	sub    $0x20,%rsp
  8020f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8020f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f8:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8020ff:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802104:	48 8b 40 10          	mov    0x10(%rax),%rax
  802108:	48 85 c0             	test   %rax,%rax
  80210b:	75 0a                	jne    802117 <argnext+0x2f>
		return -1;
  80210d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802112:	e9 24 01 00 00       	jmpq   80223b <argnext+0x153>

	if (!*args->curarg) {
  802117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80211f:	0f b6 00             	movzbl (%rax),%eax
  802122:	84 c0                	test   %al,%al
  802124:	0f 85 d5 00 00 00    	jne    8021ff <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	48 8b 00             	mov    (%rax),%rax
  802131:	8b 00                	mov    (%rax),%eax
  802133:	83 f8 01             	cmp    $0x1,%eax
  802136:	0f 84 ee 00 00 00    	je     80222a <argnext+0x142>
		    || args->argv[1][0] != '-'
  80213c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802140:	48 8b 40 08          	mov    0x8(%rax),%rax
  802144:	48 83 c0 08          	add    $0x8,%rax
  802148:	48 8b 00             	mov    (%rax),%rax
  80214b:	0f b6 00             	movzbl (%rax),%eax
  80214e:	3c 2d                	cmp    $0x2d,%al
  802150:	0f 85 d4 00 00 00    	jne    80222a <argnext+0x142>
		    || args->argv[1][1] == '\0')
  802156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80215e:	48 83 c0 08          	add    $0x8,%rax
  802162:	48 8b 00             	mov    (%rax),%rax
  802165:	48 83 c0 01          	add    $0x1,%rax
  802169:	0f b6 00             	movzbl (%rax),%eax
  80216c:	84 c0                	test   %al,%al
  80216e:	0f 84 b6 00 00 00    	je     80222a <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802178:	48 8b 40 08          	mov    0x8(%rax),%rax
  80217c:	48 83 c0 08          	add    $0x8,%rax
  802180:	48 8b 00             	mov    (%rax),%rax
  802183:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80218f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802193:	48 8b 00             	mov    (%rax),%rax
  802196:	8b 00                	mov    (%rax),%eax
  802198:	83 e8 01             	sub    $0x1,%eax
  80219b:	48 98                	cltq   
  80219d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021a4:	00 
  8021a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ad:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021b9:	48 83 c0 08          	add    $0x8,%rax
  8021bd:	48 89 ce             	mov    %rcx,%rsi
  8021c0:	48 89 c7             	mov    %rax,%rdi
  8021c3:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
		(*args->argc)--;
  8021cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d3:	48 8b 00             	mov    (%rax),%rax
  8021d6:	8b 10                	mov    (%rax),%edx
  8021d8:	83 ea 01             	sub    $0x1,%edx
  8021db:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8021dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e5:	0f b6 00             	movzbl (%rax),%eax
  8021e8:	3c 2d                	cmp    $0x2d,%al
  8021ea:	75 13                	jne    8021ff <argnext+0x117>
  8021ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021f4:	48 83 c0 01          	add    $0x1,%rax
  8021f8:	0f b6 00             	movzbl (%rax),%eax
  8021fb:	84 c0                	test   %al,%al
  8021fd:	74 2a                	je     802229 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8021ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802203:	48 8b 40 10          	mov    0x10(%rax),%rax
  802207:	0f b6 00             	movzbl (%rax),%eax
  80220a:	0f b6 c0             	movzbl %al,%eax
  80220d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  802210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802214:	48 8b 40 10          	mov    0x10(%rax),%rax
  802218:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80221c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802220:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  802224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802227:	eb 12                	jmp    80223b <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  802229:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  80222a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222e:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802235:	00 
	return -1;
  802236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80223b:	c9                   	leaveq 
  80223c:	c3                   	retq   

000000000080223d <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	48 83 ec 10          	sub    $0x10,%rsp
  802245:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802251:	48 85 c0             	test   %rax,%rax
  802254:	74 0a                	je     802260 <argvalue+0x23>
  802256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80225e:	eb 13                	jmp    802273 <argvalue+0x36>
  802260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802264:	48 89 c7             	mov    %rax,%rdi
  802267:	48 b8 75 22 80 00 00 	movabs $0x802275,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
}
  802273:	c9                   	leaveq 
  802274:	c3                   	retq   

0000000000802275 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  802275:	55                   	push   %rbp
  802276:	48 89 e5             	mov    %rsp,%rbp
  802279:	48 83 ec 10          	sub    $0x10,%rsp
  80227d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  802281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802285:	48 8b 40 10          	mov    0x10(%rax),%rax
  802289:	48 85 c0             	test   %rax,%rax
  80228c:	75 0a                	jne    802298 <argnextvalue+0x23>
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
  802293:	e9 c8 00 00 00       	jmpq   802360 <argnextvalue+0xeb>
	if (*args->curarg) {
  802298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022a0:	0f b6 00             	movzbl (%rax),%eax
  8022a3:	84 c0                	test   %al,%al
  8022a5:	74 27                	je     8022ce <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8022a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b3:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8022b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022bb:	48 ba b3 4b 80 00 00 	movabs $0x804bb3,%rdx
  8022c2:	00 00 00 
  8022c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8022c9:	e9 8a 00 00 00       	jmpq   802358 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8022ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d2:	48 8b 00             	mov    (%rax),%rax
  8022d5:	8b 00                	mov    (%rax),%eax
  8022d7:	83 f8 01             	cmp    $0x1,%eax
  8022da:	7e 64                	jle    802340 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  8022dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ec:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8022f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f4:	48 8b 00             	mov    (%rax),%rax
  8022f7:	8b 00                	mov    (%rax),%eax
  8022f9:	83 e8 01             	sub    $0x1,%eax
  8022fc:	48 98                	cltq   
  8022fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802305:	00 
  802306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80230e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802316:	48 8b 40 08          	mov    0x8(%rax),%rax
  80231a:	48 83 c0 08          	add    $0x8,%rax
  80231e:	48 89 ce             	mov    %rcx,%rsi
  802321:	48 89 c7             	mov    %rax,%rdi
  802324:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	callq  *%rax
		(*args->argc)--;
  802330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802334:	48 8b 00             	mov    (%rax),%rax
  802337:	8b 10                	mov    (%rax),%edx
  802339:	83 ea 01             	sub    $0x1,%edx
  80233c:	89 10                	mov    %edx,(%rax)
  80233e:	eb 18                	jmp    802358 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  802340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802344:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80234b:	00 
		args->curarg = 0;
  80234c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802350:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802357:	00 
	}
	return (char*) args->argvalue;
  802358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80235c:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   
	...

0000000000802364 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
  802368:	48 83 ec 08          	sub    $0x8,%rsp
  80236c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802370:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802374:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80237b:	ff ff ff 
  80237e:	48 01 d0             	add    %rdx,%rax
  802381:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 08          	sub    $0x8,%rsp
  80238f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802397:	48 89 c7             	mov    %rax,%rdi
  80239a:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	callq  *%rax
  8023a6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023ac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023b0:	c9                   	leaveq 
  8023b1:	c3                   	retq   

00000000008023b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023b2:	55                   	push   %rbp
  8023b3:	48 89 e5             	mov    %rsp,%rbp
  8023b6:	48 83 ec 18          	sub    $0x18,%rsp
  8023ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c5:	eb 6b                	jmp    802432 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ca:	48 98                	cltq   
  8023cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8023d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023de:	48 89 c2             	mov    %rax,%rdx
  8023e1:	48 c1 ea 15          	shr    $0x15,%rdx
  8023e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023ec:	01 00 00 
  8023ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f3:	83 e0 01             	and    $0x1,%eax
  8023f6:	48 85 c0             	test   %rax,%rax
  8023f9:	74 21                	je     80241c <fd_alloc+0x6a>
  8023fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ff:	48 89 c2             	mov    %rax,%rdx
  802402:	48 c1 ea 0c          	shr    $0xc,%rdx
  802406:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80240d:	01 00 00 
  802410:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802414:	83 e0 01             	and    $0x1,%eax
  802417:	48 85 c0             	test   %rax,%rax
  80241a:	75 12                	jne    80242e <fd_alloc+0x7c>
			*fd_store = fd;
  80241c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802420:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802424:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
  80242c:	eb 1a                	jmp    802448 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80242e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802432:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802436:	7e 8f                	jle    8023c7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802443:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 20          	sub    $0x20,%rsp
  802452:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802455:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802459:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80245d:	78 06                	js     802465 <fd_lookup+0x1b>
  80245f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802463:	7e 07                	jle    80246c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802465:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80246a:	eb 6c                	jmp    8024d8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80246c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246f:	48 98                	cltq   
  802471:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802477:	48 c1 e0 0c          	shl    $0xc,%rax
  80247b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80247f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802483:	48 89 c2             	mov    %rax,%rdx
  802486:	48 c1 ea 15          	shr    $0x15,%rdx
  80248a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802491:	01 00 00 
  802494:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802498:	83 e0 01             	and    $0x1,%eax
  80249b:	48 85 c0             	test   %rax,%rax
  80249e:	74 21                	je     8024c1 <fd_lookup+0x77>
  8024a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a4:	48 89 c2             	mov    %rax,%rdx
  8024a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8024ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b2:	01 00 00 
  8024b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b9:	83 e0 01             	and    $0x1,%eax
  8024bc:	48 85 c0             	test   %rax,%rax
  8024bf:	75 07                	jne    8024c8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c6:	eb 10                	jmp    8024d8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024d0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	c9                   	leaveq 
  8024d9:	c3                   	retq   

00000000008024da <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024da:	55                   	push   %rbp
  8024db:	48 89 e5             	mov    %rsp,%rbp
  8024de:	48 83 ec 30          	sub    $0x30,%rsp
  8024e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ef:	48 89 c7             	mov    %rax,%rdi
  8024f2:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
  8024fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802502:	48 89 d6             	mov    %rdx,%rsi
  802505:	89 c7                	mov    %eax,%edi
  802507:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  80250e:	00 00 00 
  802511:	ff d0                	callq  *%rax
  802513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251a:	78 0a                	js     802526 <fd_close+0x4c>
	    || fd != fd2)
  80251c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802520:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802524:	74 12                	je     802538 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802526:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80252a:	74 05                	je     802531 <fd_close+0x57>
  80252c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252f:	eb 05                	jmp    802536 <fd_close+0x5c>
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
  802536:	eb 69                	jmp    8025a1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253c:	8b 00                	mov    (%rax),%eax
  80253e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802542:	48 89 d6             	mov    %rdx,%rsi
  802545:	89 c7                	mov    %eax,%edi
  802547:	48 b8 a3 25 80 00 00 	movabs $0x8025a3,%rax
  80254e:	00 00 00 
  802551:	ff d0                	callq  *%rax
  802553:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802556:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255a:	78 2a                	js     802586 <fd_close+0xac>
		if (dev->dev_close)
  80255c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802560:	48 8b 40 20          	mov    0x20(%rax),%rax
  802564:	48 85 c0             	test   %rax,%rax
  802567:	74 16                	je     80257f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802575:	48 89 c7             	mov    %rax,%rdi
  802578:	ff d2                	callq  *%rdx
  80257a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257d:	eb 07                	jmp    802586 <fd_close+0xac>
		else
			r = 0;
  80257f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802586:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258a:	48 89 c6             	mov    %rax,%rsi
  80258d:	bf 00 00 00 00       	mov    $0x0,%edi
  802592:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
	return r;
  80259e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025a1:	c9                   	leaveq 
  8025a2:	c3                   	retq   

00000000008025a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025a3:	55                   	push   %rbp
  8025a4:	48 89 e5             	mov    %rsp,%rbp
  8025a7:	48 83 ec 20          	sub    $0x20,%rsp
  8025ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025b9:	eb 41                	jmp    8025fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025bb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025c2:	00 00 00 
  8025c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025c8:	48 63 d2             	movslq %edx,%rdx
  8025cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025cf:	8b 00                	mov    (%rax),%eax
  8025d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025d4:	75 22                	jne    8025f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8025d6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025dd:	00 00 00 
  8025e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025e3:	48 63 d2             	movslq %edx,%rdx
  8025e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f6:	eb 60                	jmp    802658 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025fc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802603:	00 00 00 
  802606:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802609:	48 63 d2             	movslq %edx,%rdx
  80260c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802610:	48 85 c0             	test   %rax,%rax
  802613:	75 a6                	jne    8025bb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802615:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80261c:	00 00 00 
  80261f:	48 8b 00             	mov    (%rax),%rax
  802622:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802628:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80262b:	89 c6                	mov    %eax,%esi
  80262d:	48 bf b8 4b 80 00 00 	movabs $0x804bb8,%rdi
  802634:	00 00 00 
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
  80263c:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802643:	00 00 00 
  802646:	ff d1                	callq  *%rcx
	*dev = 0;
  802648:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80264c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802658:	c9                   	leaveq 
  802659:	c3                   	retq   

000000000080265a <close>:

int
close(int fdnum)
{
  80265a:	55                   	push   %rbp
  80265b:	48 89 e5             	mov    %rsp,%rbp
  80265e:	48 83 ec 20          	sub    $0x20,%rsp
  802662:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802665:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802669:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80266c:	48 89 d6             	mov    %rdx,%rsi
  80266f:	89 c7                	mov    %eax,%edi
  802671:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802678:	00 00 00 
  80267b:	ff d0                	callq  *%rax
  80267d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802680:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802684:	79 05                	jns    80268b <close+0x31>
		return r;
  802686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802689:	eb 18                	jmp    8026a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80268b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268f:	be 01 00 00 00       	mov    $0x1,%esi
  802694:	48 89 c7             	mov    %rax,%rdi
  802697:	48 b8 da 24 80 00 00 	movabs $0x8024da,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
}
  8026a3:	c9                   	leaveq 
  8026a4:	c3                   	retq   

00000000008026a5 <close_all>:

void
close_all(void)
{
  8026a5:	55                   	push   %rbp
  8026a6:	48 89 e5             	mov    %rsp,%rbp
  8026a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026b4:	eb 15                	jmp    8026cb <close_all+0x26>
		close(i);
  8026b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b9:	89 c7                	mov    %eax,%edi
  8026bb:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026cf:	7e e5                	jle    8026b6 <close_all+0x11>
		close(i);
}
  8026d1:	c9                   	leaveq 
  8026d2:	c3                   	retq   

00000000008026d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026d3:	55                   	push   %rbp
  8026d4:	48 89 e5             	mov    %rsp,%rbp
  8026d7:	48 83 ec 40          	sub    $0x40,%rsp
  8026db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026e8:	48 89 d6             	mov    %rdx,%rsi
  8026eb:	89 c7                	mov    %eax,%edi
  8026ed:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802700:	79 08                	jns    80270a <dup+0x37>
		return r;
  802702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802705:	e9 70 01 00 00       	jmpq   80287a <dup+0x1a7>
	close(newfdnum);
  80270a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80270d:	89 c7                	mov    %eax,%edi
  80270f:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  802716:	00 00 00 
  802719:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80271b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80271e:	48 98                	cltq   
  802720:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802726:	48 c1 e0 0c          	shl    $0xc,%rax
  80272a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80272e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802732:	48 89 c7             	mov    %rax,%rdi
  802735:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	48 89 c7             	mov    %rax,%rdi
  80274c:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  802753:	00 00 00 
  802756:	ff d0                	callq  *%rax
  802758:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	48 89 c2             	mov    %rax,%rdx
  802763:	48 c1 ea 15          	shr    $0x15,%rdx
  802767:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80276e:	01 00 00 
  802771:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802775:	83 e0 01             	and    $0x1,%eax
  802778:	84 c0                	test   %al,%al
  80277a:	74 71                	je     8027ed <dup+0x11a>
  80277c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802780:	48 89 c2             	mov    %rax,%rdx
  802783:	48 c1 ea 0c          	shr    $0xc,%rdx
  802787:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80278e:	01 00 00 
  802791:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802795:	83 e0 01             	and    $0x1,%eax
  802798:	84 c0                	test   %al,%al
  80279a:	74 51                	je     8027ed <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	48 89 c2             	mov    %rax,%rdx
  8027a3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ae:	01 00 00 
  8027b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b5:	89 c1                	mov    %eax,%ecx
  8027b7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8027bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c5:	41 89 c8             	mov    %ecx,%r8d
  8027c8:	48 89 d1             	mov    %rdx,%rcx
  8027cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d0:	48 89 c6             	mov    %rax,%rsi
  8027d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d8:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
  8027e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027eb:	78 56                	js     802843 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f1:	48 89 c2             	mov    %rax,%rdx
  8027f4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ff:	01 00 00 
  802802:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802806:	89 c1                	mov    %eax,%ecx
  802808:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80280e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802812:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802816:	41 89 c8             	mov    %ecx,%r8d
  802819:	48 89 d1             	mov    %rdx,%rcx
  80281c:	ba 00 00 00 00       	mov    $0x0,%edx
  802821:	48 89 c6             	mov    %rax,%rsi
  802824:	bf 00 00 00 00       	mov    $0x0,%edi
  802829:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802838:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283c:	78 08                	js     802846 <dup+0x173>
		goto err;

	return newfdnum;
  80283e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802841:	eb 37                	jmp    80287a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802843:	90                   	nop
  802844:	eb 01                	jmp    802847 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802846:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284b:	48 89 c6             	mov    %rax,%rsi
  80284e:	bf 00 00 00 00       	mov    $0x0,%edi
  802853:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80285f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802863:	48 89 c6             	mov    %rax,%rsi
  802866:	bf 00 00 00 00       	mov    $0x0,%edi
  80286b:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
	return r;
  802877:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80287a:	c9                   	leaveq 
  80287b:	c3                   	retq   

000000000080287c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80287c:	55                   	push   %rbp
  80287d:	48 89 e5             	mov    %rsp,%rbp
  802880:	48 83 ec 40          	sub    $0x40,%rsp
  802884:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802887:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80288b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80288f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802893:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802896:	48 89 d6             	mov    %rdx,%rsi
  802899:	89 c7                	mov    %eax,%edi
  80289b:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8028a2:	00 00 00 
  8028a5:	ff d0                	callq  *%rax
  8028a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ae:	78 24                	js     8028d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b4:	8b 00                	mov    (%rax),%eax
  8028b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ba:	48 89 d6             	mov    %rdx,%rsi
  8028bd:	89 c7                	mov    %eax,%edi
  8028bf:	48 b8 a3 25 80 00 00 	movabs $0x8025a3,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	callq  *%rax
  8028cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d2:	79 05                	jns    8028d9 <read+0x5d>
		return r;
  8028d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d7:	eb 7a                	jmp    802953 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dd:	8b 40 08             	mov    0x8(%rax),%eax
  8028e0:	83 e0 03             	and    $0x3,%eax
  8028e3:	83 f8 01             	cmp    $0x1,%eax
  8028e6:	75 3a                	jne    802922 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028e8:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8028ef:	00 00 00 
  8028f2:	48 8b 00             	mov    (%rax),%rax
  8028f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028fe:	89 c6                	mov    %eax,%esi
  802900:	48 bf d7 4b 80 00 00 	movabs $0x804bd7,%rdi
  802907:	00 00 00 
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
  80290f:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802916:	00 00 00 
  802919:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80291b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802920:	eb 31                	jmp    802953 <read+0xd7>
	}
	if (!dev->dev_read)
  802922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802926:	48 8b 40 10          	mov    0x10(%rax),%rax
  80292a:	48 85 c0             	test   %rax,%rax
  80292d:	75 07                	jne    802936 <read+0xba>
		return -E_NOT_SUPP;
  80292f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802934:	eb 1d                	jmp    802953 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80293e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802942:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802946:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80294a:	48 89 ce             	mov    %rcx,%rsi
  80294d:	48 89 c7             	mov    %rax,%rdi
  802950:	41 ff d0             	callq  *%r8
}
  802953:	c9                   	leaveq 
  802954:	c3                   	retq   

0000000000802955 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802955:	55                   	push   %rbp
  802956:	48 89 e5             	mov    %rsp,%rbp
  802959:	48 83 ec 30          	sub    $0x30,%rsp
  80295d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802960:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802964:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80296f:	eb 46                	jmp    8029b7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802974:	48 98                	cltq   
  802976:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80297a:	48 29 c2             	sub    %rax,%rdx
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	48 98                	cltq   
  802982:	48 89 c1             	mov    %rax,%rcx
  802985:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802989:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80298c:	48 89 ce             	mov    %rcx,%rsi
  80298f:	89 c7                	mov    %eax,%edi
  802991:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  802998:	00 00 00 
  80299b:	ff d0                	callq  *%rax
  80299d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029a4:	79 05                	jns    8029ab <readn+0x56>
			return m;
  8029a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029a9:	eb 1d                	jmp    8029c8 <readn+0x73>
		if (m == 0)
  8029ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029af:	74 13                	je     8029c4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029b4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ba:	48 98                	cltq   
  8029bc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029c0:	72 af                	jb     802971 <readn+0x1c>
  8029c2:	eb 01                	jmp    8029c5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8029c4:	90                   	nop
	}
	return tot;
  8029c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029c8:	c9                   	leaveq 
  8029c9:	c3                   	retq   

00000000008029ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029ca:	55                   	push   %rbp
  8029cb:	48 89 e5             	mov    %rsp,%rbp
  8029ce:	48 83 ec 40          	sub    $0x40,%rsp
  8029d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e4:	48 89 d6             	mov    %rdx,%rsi
  8029e7:	89 c7                	mov    %eax,%edi
  8029e9:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax
  8029f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fc:	78 24                	js     802a22 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a02:	8b 00                	mov    (%rax),%eax
  802a04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a08:	48 89 d6             	mov    %rdx,%rsi
  802a0b:	89 c7                	mov    %eax,%edi
  802a0d:	48 b8 a3 25 80 00 00 	movabs $0x8025a3,%rax
  802a14:	00 00 00 
  802a17:	ff d0                	callq  *%rax
  802a19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a20:	79 05                	jns    802a27 <write+0x5d>
		return r;
  802a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a25:	eb 79                	jmp    802aa0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2b:	8b 40 08             	mov    0x8(%rax),%eax
  802a2e:	83 e0 03             	and    $0x3,%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	75 3a                	jne    802a6f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a35:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a3c:	00 00 00 
  802a3f:	48 8b 00             	mov    (%rax),%rax
  802a42:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a48:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a4b:	89 c6                	mov    %eax,%esi
  802a4d:	48 bf f3 4b 80 00 00 	movabs $0x804bf3,%rdi
  802a54:	00 00 00 
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5c:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802a63:	00 00 00 
  802a66:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6d:	eb 31                	jmp    802aa0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a73:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a77:	48 85 c0             	test   %rax,%rax
  802a7a:	75 07                	jne    802a83 <write+0xb9>
		return -E_NOT_SUPP;
  802a7c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a81:	eb 1d                	jmp    802aa0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a87:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a93:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a97:	48 89 ce             	mov    %rcx,%rsi
  802a9a:	48 89 c7             	mov    %rax,%rdi
  802a9d:	41 ff d0             	callq  *%r8
}
  802aa0:	c9                   	leaveq 
  802aa1:	c3                   	retq   

0000000000802aa2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802aa2:	55                   	push   %rbp
  802aa3:	48 89 e5             	mov    %rsp,%rbp
  802aa6:	48 83 ec 18          	sub    $0x18,%rsp
  802aaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ab0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ab7:	48 89 d6             	mov    %rdx,%rsi
  802aba:	89 c7                	mov    %eax,%edi
  802abc:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acf:	79 05                	jns    802ad6 <seek+0x34>
		return r;
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	eb 0f                	jmp    802ae5 <seek+0x43>
	fd->fd_offset = offset;
  802ad6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ada:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802add:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae5:	c9                   	leaveq 
  802ae6:	c3                   	retq   

0000000000802ae7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 83 ec 30          	sub    $0x30,%rsp
  802aef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802af2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802af5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802af9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802afc:	48 89 d6             	mov    %rdx,%rsi
  802aff:	89 c7                	mov    %eax,%edi
  802b01:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b14:	78 24                	js     802b3a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1a:	8b 00                	mov    (%rax),%eax
  802b1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b20:	48 89 d6             	mov    %rdx,%rsi
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 a3 25 80 00 00 	movabs $0x8025a3,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b38:	79 05                	jns    802b3f <ftruncate+0x58>
		return r;
  802b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3d:	eb 72                	jmp    802bb1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b43:	8b 40 08             	mov    0x8(%rax),%eax
  802b46:	83 e0 03             	and    $0x3,%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	75 3a                	jne    802b87 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b4d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b54:	00 00 00 
  802b57:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b63:	89 c6                	mov    %eax,%esi
  802b65:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802b7b:	00 00 00 
  802b7e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b85:	eb 2a                	jmp    802bb1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b8f:	48 85 c0             	test   %rax,%rax
  802b92:	75 07                	jne    802b9b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b99:	eb 16                	jmp    802bb1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802baa:	89 d6                	mov    %edx,%esi
  802bac:	48 89 c7             	mov    %rax,%rdi
  802baf:	ff d1                	callq  *%rcx
}
  802bb1:	c9                   	leaveq 
  802bb2:	c3                   	retq   

0000000000802bb3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 30          	sub    $0x30,%rsp
  802bbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc9:	48 89 d6             	mov    %rdx,%rsi
  802bcc:	89 c7                	mov    %eax,%edi
  802bce:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
  802bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be1:	78 24                	js     802c07 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be7:	8b 00                	mov    (%rax),%eax
  802be9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bed:	48 89 d6             	mov    %rdx,%rsi
  802bf0:	89 c7                	mov    %eax,%edi
  802bf2:	48 b8 a3 25 80 00 00 	movabs $0x8025a3,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
  802bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c05:	79 05                	jns    802c0c <fstat+0x59>
		return r;
  802c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0a:	eb 5e                	jmp    802c6a <fstat+0xb7>
	if (!dev->dev_stat)
  802c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c10:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c14:	48 85 c0             	test   %rax,%rax
  802c17:	75 07                	jne    802c20 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c1e:	eb 4a                	jmp    802c6a <fstat+0xb7>
	stat->st_name[0] = 0;
  802c20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c24:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c32:	00 00 00 
	stat->st_isdir = 0;
  802c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c40:	00 00 00 
	stat->st_dev = dev;
  802c43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c4b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c56:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802c62:	48 89 d6             	mov    %rdx,%rsi
  802c65:	48 89 c7             	mov    %rax,%rdi
  802c68:	ff d1                	callq  *%rcx
}
  802c6a:	c9                   	leaveq 
  802c6b:	c3                   	retq   

0000000000802c6c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c6c:	55                   	push   %rbp
  802c6d:	48 89 e5             	mov    %rsp,%rbp
  802c70:	48 83 ec 20          	sub    $0x20,%rsp
  802c74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c80:	be 00 00 00 00       	mov    $0x0,%esi
  802c85:	48 89 c7             	mov    %rax,%rdi
  802c88:	48 b8 5b 2d 80 00 00 	movabs $0x802d5b,%rax
  802c8f:	00 00 00 
  802c92:	ff d0                	callq  *%rax
  802c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9b:	79 05                	jns    802ca2 <stat+0x36>
		return fd;
  802c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca0:	eb 2f                	jmp    802cd1 <stat+0x65>
	r = fstat(fd, stat);
  802ca2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca9:	48 89 d6             	mov    %rdx,%rsi
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 b3 2b 80 00 00 	movabs $0x802bb3,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
  802cba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
	return r;
  802cce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cd1:	c9                   	leaveq 
  802cd2:	c3                   	retq   
	...

0000000000802cd4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cd4:	55                   	push   %rbp
  802cd5:	48 89 e5             	mov    %rsp,%rbp
  802cd8:	48 83 ec 10          	sub    $0x10,%rsp
  802cdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ce3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cea:	00 00 00 
  802ced:	8b 00                	mov    (%rax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	75 1d                	jne    802d10 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cf3:	bf 01 00 00 00       	mov    $0x1,%edi
  802cf8:	48 b8 b2 44 80 00 00 	movabs $0x8044b2,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	callq  *%rax
  802d04:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d0b:	00 00 00 
  802d0e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d10:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d17:	00 00 00 
  802d1a:	8b 00                	mov    (%rax),%eax
  802d1c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d1f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d24:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d2b:	00 00 00 
  802d2e:	89 c7                	mov    %eax,%edi
  802d30:	48 b8 03 44 80 00 00 	movabs $0x804403,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d40:	ba 00 00 00 00       	mov    $0x0,%edx
  802d45:	48 89 c6             	mov    %rax,%rsi
  802d48:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4d:	48 b8 1c 43 80 00 00 	movabs $0x80431c,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
}
  802d59:	c9                   	leaveq 
  802d5a:	c3                   	retq   

0000000000802d5b <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
  802d5f:	48 83 ec 20          	sub    $0x20,%rsp
  802d63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d67:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6e:	48 89 c7             	mov    %rax,%rdi
  802d71:	48 b8 90 13 80 00 00 	movabs $0x801390,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
  802d7d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d82:	7e 0a                	jle    802d8e <open+0x33>
		return -E_BAD_PATH;
  802d84:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d89:	e9 a5 00 00 00       	jmpq   802e33 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802d8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d92:	48 89 c7             	mov    %rax,%rdi
  802d95:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
  802da1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da8:	79 08                	jns    802db2 <open+0x57>
		return r;
  802daa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dad:	e9 81 00 00 00       	jmpq   802e33 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802db2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802db9:	00 00 00 
  802dbc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802dbf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc9:	48 89 c6             	mov    %rax,%rsi
  802dcc:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802dd3:	00 00 00 
  802dd6:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 89 c6             	mov    %rax,%rsi
  802de9:	bf 01 00 00 00       	mov    $0x1,%edi
  802dee:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
  802dfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e01:	79 1d                	jns    802e20 <open+0xc5>
		fd_close(new_fd, 0);
  802e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e07:	be 00 00 00 00       	mov    $0x0,%esi
  802e0c:	48 89 c7             	mov    %rax,%rdi
  802e0f:	48 b8 da 24 80 00 00 	movabs $0x8024da,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
		return r;	
  802e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1e:	eb 13                	jmp    802e33 <open+0xd8>
	}
	return fd2num(new_fd);
  802e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e24:	48 89 c7             	mov    %rax,%rdi
  802e27:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
}
  802e33:	c9                   	leaveq 
  802e34:	c3                   	retq   

0000000000802e35 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e35:	55                   	push   %rbp
  802e36:	48 89 e5             	mov    %rsp,%rbp
  802e39:	48 83 ec 10          	sub    $0x10,%rsp
  802e3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e45:	8b 50 0c             	mov    0xc(%rax),%edx
  802e48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4f:	00 00 00 
  802e52:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e54:	be 00 00 00 00       	mov    $0x0,%esi
  802e59:	bf 06 00 00 00       	mov    $0x6,%edi
  802e5e:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
}
  802e6a:	c9                   	leaveq 
  802e6b:	c3                   	retq   

0000000000802e6c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e6c:	55                   	push   %rbp
  802e6d:	48 89 e5             	mov    %rsp,%rbp
  802e70:	48 83 ec 30          	sub    $0x30,%rsp
  802e74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e84:	8b 50 0c             	mov    0xc(%rax),%edx
  802e87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e8e:	00 00 00 
  802e91:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e93:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e9a:	00 00 00 
  802e9d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802ea5:	be 00 00 00 00       	mov    $0x0,%esi
  802eaa:	bf 03 00 00 00       	mov    $0x3,%edi
  802eaf:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec2:	7e 23                	jle    802ee7 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec7:	48 63 d0             	movslq %eax,%rdx
  802eca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ece:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ed5:	00 00 00 
  802ed8:	48 89 c7             	mov    %rax,%rdi
  802edb:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
	}
	return nbytes;
  802ee7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802eea:	c9                   	leaveq 
  802eeb:	c3                   	retq   

0000000000802eec <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802eec:	55                   	push   %rbp
  802eed:	48 89 e5             	mov    %rsp,%rbp
  802ef0:	48 83 ec 20          	sub    $0x20,%rsp
  802ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f00:	8b 50 0c             	mov    0xc(%rax),%edx
  802f03:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f0a:	00 00 00 
  802f0d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f0f:	be 00 00 00 00       	mov    $0x0,%esi
  802f14:	bf 05 00 00 00       	mov    $0x5,%edi
  802f19:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
  802f25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2c:	79 05                	jns    802f33 <devfile_stat+0x47>
		return r;
  802f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f31:	eb 56                	jmp    802f89 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f37:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f3e:	00 00 00 
  802f41:	48 89 c7             	mov    %rax,%rdi
  802f44:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f57:	00 00 00 
  802f5a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f64:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f71:	00 00 00 
  802f74:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f89:	c9                   	leaveq 
  802f8a:	c3                   	retq   
	...

0000000000802f8c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802f8c:	55                   	push   %rbp
  802f8d:	48 89 e5             	mov    %rsp,%rbp
  802f90:	48 83 ec 20          	sub    $0x20,%rsp
  802f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9c:	8b 40 0c             	mov    0xc(%rax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	7e 67                	jle    80300a <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa7:	8b 40 04             	mov    0x4(%rax),%eax
  802faa:	48 63 d0             	movslq %eax,%rdx
  802fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb1:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb9:	8b 00                	mov    (%rax),%eax
  802fbb:	48 89 ce             	mov    %rcx,%rsi
  802fbe:	89 c7                	mov    %eax,%edi
  802fc0:	48 b8 ca 29 80 00 00 	movabs $0x8029ca,%rax
  802fc7:	00 00 00 
  802fca:	ff d0                	callq  *%rax
  802fcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd3:	7e 13                	jle    802fe8 <writebuf+0x5c>
			b->result += result;
  802fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd9:	8b 40 08             	mov    0x8(%rax),%eax
  802fdc:	89 c2                	mov    %eax,%edx
  802fde:	03 55 fc             	add    -0x4(%rbp),%edx
  802fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe5:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fec:	8b 40 04             	mov    0x4(%rax),%eax
  802fef:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ff2:	74 16                	je     80300a <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffd:	89 c2                	mov    %eax,%edx
  802fff:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  803003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803007:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80300a:	c9                   	leaveq 
  80300b:	c3                   	retq   

000000000080300c <putch>:

static void
putch(int ch, void *thunk)
{
  80300c:	55                   	push   %rbp
  80300d:	48 89 e5             	mov    %rsp,%rbp
  803010:	48 83 ec 20          	sub    $0x20,%rsp
  803014:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80301b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803027:	8b 40 04             	mov    0x4(%rax),%eax
  80302a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302d:	89 d6                	mov    %edx,%esi
  80302f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803033:	48 63 d0             	movslq %eax,%rdx
  803036:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  80303b:	8d 50 01             	lea    0x1(%rax),%edx
  80303e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803042:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  803045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803049:	8b 40 04             	mov    0x4(%rax),%eax
  80304c:	3d 00 01 00 00       	cmp    $0x100,%eax
  803051:	75 1e                	jne    803071 <putch+0x65>
		writebuf(b);
  803053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803057:	48 89 c7             	mov    %rax,%rdi
  80305a:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
		b->idx = 0;
  803066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803071:	c9                   	leaveq 
  803072:	c3                   	retq   

0000000000803073 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803073:	55                   	push   %rbp
  803074:	48 89 e5             	mov    %rsp,%rbp
  803077:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80307e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803084:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80308b:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803092:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803098:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80309e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8030a5:	00 00 00 
	b.result = 0;
  8030a8:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8030af:	00 00 00 
	b.error = 1;
  8030b2:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8030b9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8030bc:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8030c3:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8030ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030d1:	48 89 c6             	mov    %rax,%rsi
  8030d4:	48 bf 0c 30 80 00 00 	movabs $0x80300c,%rdi
  8030db:	00 00 00 
  8030de:	48 b8 dc 0b 80 00 00 	movabs $0x800bdc,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8030ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	7e 16                	jle    80310a <vfprintf+0x97>
		writebuf(&b);
  8030f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030fb:	48 89 c7             	mov    %rax,%rdi
  8030fe:	48 b8 8c 2f 80 00 00 	movabs $0x802f8c,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80310a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 08                	je     80311c <vfprintf+0xa9>
  803114:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80311a:	eb 06                	jmp    803122 <vfprintf+0xaf>
  80311c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80312f:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803135:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80313c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803143:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80314a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803151:	84 c0                	test   %al,%al
  803153:	74 20                	je     803175 <fprintf+0x51>
  803155:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803159:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80315d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803161:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803165:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803169:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80316d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803171:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803175:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80317c:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803183:	00 00 00 
  803186:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80318d:	00 00 00 
  803190:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803194:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80319b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8031a9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031b0:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8031b7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031bd:	48 89 ce             	mov    %rcx,%rsi
  8031c0:	89 c7                	mov    %eax,%edi
  8031c2:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031d4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031da:	c9                   	leaveq 
  8031db:	c3                   	retq   

00000000008031dc <printf>:

int
printf(const char *fmt, ...)
{
  8031dc:	55                   	push   %rbp
  8031dd:	48 89 e5             	mov    %rsp,%rbp
  8031e0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8031e7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031ee:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031f5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031fc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803203:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80320a:	84 c0                	test   %al,%al
  80320c:	74 20                	je     80322e <printf+0x52>
  80320e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803212:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803216:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80321a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80321e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803222:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803226:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80322a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80322e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803235:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80323c:	00 00 00 
  80323f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803246:	00 00 00 
  803249:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80324d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803254:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80325b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803262:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803269:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803270:	48 89 c6             	mov    %rax,%rsi
  803273:	bf 01 00 00 00       	mov    $0x1,%edi
  803278:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
  803284:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80328a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803290:	c9                   	leaveq 
  803291:	c3                   	retq   
	...

0000000000803294 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
  803298:	48 83 ec 20          	sub    $0x20,%rsp
  80329c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80329f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a6:	48 89 d6             	mov    %rdx,%rsi
  8032a9:	89 c7                	mov    %eax,%edi
  8032ab:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
  8032b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032be:	79 05                	jns    8032c5 <fd2sockid+0x31>
		return r;
  8032c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c3:	eb 24                	jmp    8032e9 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8032c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c9:	8b 10                	mov    (%rax),%edx
  8032cb:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8032d2:	00 00 00 
  8032d5:	8b 00                	mov    (%rax),%eax
  8032d7:	39 c2                	cmp    %eax,%edx
  8032d9:	74 07                	je     8032e2 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8032db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032e0:	eb 07                	jmp    8032e9 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8032e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e6:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8032e9:	c9                   	leaveq 
  8032ea:	c3                   	retq   

00000000008032eb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8032eb:	55                   	push   %rbp
  8032ec:	48 89 e5             	mov    %rsp,%rbp
  8032ef:	48 83 ec 20          	sub    $0x20,%rsp
  8032f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8032f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032fa:	48 89 c7             	mov    %rax,%rdi
  8032fd:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803310:	78 26                	js     803338 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803316:	ba 07 04 00 00       	mov    $0x407,%edx
  80331b:	48 89 c6             	mov    %rax,%rsi
  80331e:	bf 00 00 00 00       	mov    $0x0,%edi
  803323:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803336:	79 16                	jns    80334e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803338:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333b:	89 c7                	mov    %eax,%edi
  80333d:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
		return r;
  803349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334c:	eb 3a                	jmp    803388 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80334e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803352:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803359:	00 00 00 
  80335c:	8b 12                	mov    (%rdx),%edx
  80335e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803360:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803364:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80336b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803372:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803379:	48 89 c7             	mov    %rax,%rdi
  80337c:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
}
  803388:	c9                   	leaveq 
  803389:	c3                   	retq   

000000000080338a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80338a:	55                   	push   %rbp
  80338b:	48 89 e5             	mov    %rsp,%rbp
  80338e:	48 83 ec 30          	sub    $0x30,%rsp
  803392:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80339d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a0:	89 c7                	mov    %eax,%edi
  8033a2:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8033a9:	00 00 00 
  8033ac:	ff d0                	callq  *%rax
  8033ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b5:	79 05                	jns    8033bc <accept+0x32>
		return r;
  8033b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ba:	eb 3b                	jmp    8033f7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8033bc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c7:	48 89 ce             	mov    %rcx,%rsi
  8033ca:	89 c7                	mov    %eax,%edi
  8033cc:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
  8033d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033df:	79 05                	jns    8033e6 <accept+0x5c>
		return r;
  8033e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e4:	eb 11                	jmp    8033f7 <accept+0x6d>
	return alloc_sockfd(r);
  8033e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e9:	89 c7                	mov    %eax,%edi
  8033eb:	48 b8 eb 32 80 00 00 	movabs $0x8032eb,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
}
  8033f7:	c9                   	leaveq 
  8033f8:	c3                   	retq   

00000000008033f9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033f9:	55                   	push   %rbp
  8033fa:	48 89 e5             	mov    %rsp,%rbp
  8033fd:	48 83 ec 20          	sub    $0x20,%rsp
  803401:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803408:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80340b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340e:	89 c7                	mov    %eax,%edi
  803410:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
  80341c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803423:	79 05                	jns    80342a <bind+0x31>
		return r;
  803425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803428:	eb 1b                	jmp    803445 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80342a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80342d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	48 89 ce             	mov    %rcx,%rsi
  803437:	89 c7                	mov    %eax,%edi
  803439:	48 b8 54 37 80 00 00 	movabs $0x803754,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
}
  803445:	c9                   	leaveq 
  803446:	c3                   	retq   

0000000000803447 <shutdown>:

int
shutdown(int s, int how)
{
  803447:	55                   	push   %rbp
  803448:	48 89 e5             	mov    %rsp,%rbp
  80344b:	48 83 ec 20          	sub    $0x20,%rsp
  80344f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803452:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803455:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346d:	79 05                	jns    803474 <shutdown+0x2d>
		return r;
  80346f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803472:	eb 16                	jmp    80348a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803474:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347a:	89 d6                	mov    %edx,%esi
  80347c:	89 c7                	mov    %eax,%edi
  80347e:	48 b8 b8 37 80 00 00 	movabs $0x8037b8,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
}
  80348a:	c9                   	leaveq 
  80348b:	c3                   	retq   

000000000080348c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80348c:	55                   	push   %rbp
  80348d:	48 89 e5             	mov    %rsp,%rbp
  803490:	48 83 ec 10          	sub    $0x10,%rsp
  803494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349c:	48 89 c7             	mov    %rax,%rdi
  80349f:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  8034a6:	00 00 00 
  8034a9:	ff d0                	callq  *%rax
  8034ab:	83 f8 01             	cmp    $0x1,%eax
  8034ae:	75 17                	jne    8034c7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8034b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b4:	8b 40 0c             	mov    0xc(%rax),%eax
  8034b7:	89 c7                	mov    %eax,%edi
  8034b9:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	eb 05                	jmp    8034cc <devsock_close+0x40>
	else
		return 0;
  8034c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034cc:	c9                   	leaveq 
  8034cd:	c3                   	retq   

00000000008034ce <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034ce:	55                   	push   %rbp
  8034cf:	48 89 e5             	mov    %rsp,%rbp
  8034d2:	48 83 ec 20          	sub    $0x20,%rsp
  8034d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034dd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e3:	89 c7                	mov    %eax,%edi
  8034e5:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8034ec:	00 00 00 
  8034ef:	ff d0                	callq  *%rax
  8034f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f8:	79 05                	jns    8034ff <connect+0x31>
		return r;
  8034fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fd:	eb 1b                	jmp    80351a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8034ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803502:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803509:	48 89 ce             	mov    %rcx,%rsi
  80350c:	89 c7                	mov    %eax,%edi
  80350e:	48 b8 25 38 80 00 00 	movabs $0x803825,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
}
  80351a:	c9                   	leaveq 
  80351b:	c3                   	retq   

000000000080351c <listen>:

int
listen(int s, int backlog)
{
  80351c:	55                   	push   %rbp
  80351d:	48 89 e5             	mov    %rsp,%rbp
  803520:	48 83 ec 20          	sub    $0x20,%rsp
  803524:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803527:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80352a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352d:	89 c7                	mov    %eax,%edi
  80352f:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803542:	79 05                	jns    803549 <listen+0x2d>
		return r;
  803544:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803547:	eb 16                	jmp    80355f <listen+0x43>
	return nsipc_listen(r, backlog);
  803549:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80354c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354f:	89 d6                	mov    %edx,%esi
  803551:	89 c7                	mov    %eax,%edi
  803553:	48 b8 89 38 80 00 00 	movabs $0x803889,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
}
  80355f:	c9                   	leaveq 
  803560:	c3                   	retq   

0000000000803561 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803561:	55                   	push   %rbp
  803562:	48 89 e5             	mov    %rsp,%rbp
  803565:	48 83 ec 20          	sub    $0x20,%rsp
  803569:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80356d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803571:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	89 c2                	mov    %eax,%edx
  80357b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357f:	8b 40 0c             	mov    0xc(%rax),%eax
  803582:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803586:	b9 00 00 00 00       	mov    $0x0,%ecx
  80358b:	89 c7                	mov    %eax,%edi
  80358d:	48 b8 c9 38 80 00 00 	movabs $0x8038c9,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
}
  803599:	c9                   	leaveq 
  80359a:	c3                   	retq   

000000000080359b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80359b:	55                   	push   %rbp
  80359c:	48 89 e5             	mov    %rsp,%rbp
  80359f:	48 83 ec 20          	sub    $0x20,%rsp
  8035a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b3:	89 c2                	mov    %eax,%edx
  8035b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b9:	8b 40 0c             	mov    0xc(%rax),%eax
  8035bc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035c5:	89 c7                	mov    %eax,%edi
  8035c7:	48 b8 95 39 80 00 00 	movabs $0x803995,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
}
  8035d3:	c9                   	leaveq 
  8035d4:	c3                   	retq   

00000000008035d5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035d5:	55                   	push   %rbp
  8035d6:	48 89 e5             	mov    %rsp,%rbp
  8035d9:	48 83 ec 10          	sub    $0x10,%rsp
  8035dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8035e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e9:	48 be 3b 4c 80 00 00 	movabs $0x804c3b,%rsi
  8035f0:	00 00 00 
  8035f3:	48 89 c7             	mov    %rax,%rdi
  8035f6:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
	return 0;
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803607:	c9                   	leaveq 
  803608:	c3                   	retq   

0000000000803609 <socket>:

int
socket(int domain, int type, int protocol)
{
  803609:	55                   	push   %rbp
  80360a:	48 89 e5             	mov    %rsp,%rbp
  80360d:	48 83 ec 20          	sub    $0x20,%rsp
  803611:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803614:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803617:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80361a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80361d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803620:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803623:	89 ce                	mov    %ecx,%esi
  803625:	89 c7                	mov    %eax,%edi
  803627:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
  803633:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363a:	79 05                	jns    803641 <socket+0x38>
		return r;
  80363c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363f:	eb 11                	jmp    803652 <socket+0x49>
	return alloc_sockfd(r);
  803641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803644:	89 c7                	mov    %eax,%edi
  803646:	48 b8 eb 32 80 00 00 	movabs $0x8032eb,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
}
  803652:	c9                   	leaveq 
  803653:	c3                   	retq   

0000000000803654 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803654:	55                   	push   %rbp
  803655:	48 89 e5             	mov    %rsp,%rbp
  803658:	48 83 ec 10          	sub    $0x10,%rsp
  80365c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80365f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803666:	00 00 00 
  803669:	8b 00                	mov    (%rax),%eax
  80366b:	85 c0                	test   %eax,%eax
  80366d:	75 1d                	jne    80368c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80366f:	bf 02 00 00 00       	mov    $0x2,%edi
  803674:	48 b8 b2 44 80 00 00 	movabs $0x8044b2,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803687:	00 00 00 
  80368a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80368c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803693:	00 00 00 
  803696:	8b 00                	mov    (%rax),%eax
  803698:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80369b:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036a0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8036a7:	00 00 00 
  8036aa:	89 c7                	mov    %eax,%edi
  8036ac:	48 b8 03 44 80 00 00 	movabs $0x804403,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8036b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8036bd:	be 00 00 00 00       	mov    $0x0,%esi
  8036c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c7:	48 b8 1c 43 80 00 00 	movabs $0x80431c,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
}
  8036d3:	c9                   	leaveq 
  8036d4:	c3                   	retq   

00000000008036d5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036d5:	55                   	push   %rbp
  8036d6:	48 89 e5             	mov    %rsp,%rbp
  8036d9:	48 83 ec 30          	sub    $0x30,%rsp
  8036dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8036e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ef:	00 00 00 
  8036f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036f5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8036fc:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
  803708:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370f:	78 3e                	js     80374f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803711:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803718:	00 00 00 
  80371b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80371f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803723:	8b 40 10             	mov    0x10(%rax),%eax
  803726:	89 c2                	mov    %eax,%edx
  803728:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80372c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803730:	48 89 ce             	mov    %rcx,%rsi
  803733:	48 89 c7             	mov    %rax,%rdi
  803736:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803746:	8b 50 10             	mov    0x10(%rax),%edx
  803749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80374f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803752:	c9                   	leaveq 
  803753:	c3                   	retq   

0000000000803754 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803754:	55                   	push   %rbp
  803755:	48 89 e5             	mov    %rsp,%rbp
  803758:	48 83 ec 10          	sub    $0x10,%rsp
  80375c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80375f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803763:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803766:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376d:	00 00 00 
  803770:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803773:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803775:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80377c:	48 89 c6             	mov    %rax,%rsi
  80377f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803786:	00 00 00 
  803789:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  803790:	00 00 00 
  803793:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803795:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379c:	00 00 00 
  80379f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037a2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8037aa:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
}
  8037b6:	c9                   	leaveq 
  8037b7:	c3                   	retq   

00000000008037b8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8037b8:	55                   	push   %rbp
  8037b9:	48 89 e5             	mov    %rsp,%rbp
  8037bc:	48 83 ec 10          	sub    $0x10,%rsp
  8037c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037c3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8037c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037cd:	00 00 00 
  8037d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037d3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8037d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037dc:	00 00 00 
  8037df:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037e2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8037e5:	bf 03 00 00 00       	mov    $0x3,%edi
  8037ea:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
}
  8037f6:	c9                   	leaveq 
  8037f7:	c3                   	retq   

00000000008037f8 <nsipc_close>:

int
nsipc_close(int s)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	48 83 ec 10          	sub    $0x10,%rsp
  803800:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803803:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380a:	00 00 00 
  80380d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803810:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803812:	bf 04 00 00 00       	mov    $0x4,%edi
  803817:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
}
  803823:	c9                   	leaveq 
  803824:	c3                   	retq   

0000000000803825 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803825:	55                   	push   %rbp
  803826:	48 89 e5             	mov    %rsp,%rbp
  803829:	48 83 ec 10          	sub    $0x10,%rsp
  80382d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803834:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803837:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80383e:	00 00 00 
  803841:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803844:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803846:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384d:	48 89 c6             	mov    %rax,%rsi
  803850:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803857:	00 00 00 
  80385a:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803866:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80386d:	00 00 00 
  803870:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803873:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803876:	bf 05 00 00 00       	mov    $0x5,%edi
  80387b:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
}
  803887:	c9                   	leaveq 
  803888:	c3                   	retq   

0000000000803889 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803889:	55                   	push   %rbp
  80388a:	48 89 e5             	mov    %rsp,%rbp
  80388d:	48 83 ec 10          	sub    $0x10,%rsp
  803891:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803894:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803897:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80389e:	00 00 00 
  8038a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038a4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ad:	00 00 00 
  8038b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038b3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8038b6:	bf 06 00 00 00       	mov    $0x6,%edi
  8038bb:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  8038c2:	00 00 00 
  8038c5:	ff d0                	callq  *%rax
}
  8038c7:	c9                   	leaveq 
  8038c8:	c3                   	retq   

00000000008038c9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038c9:	55                   	push   %rbp
  8038ca:	48 89 e5             	mov    %rsp,%rbp
  8038cd:	48 83 ec 30          	sub    $0x30,%rsp
  8038d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038d8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8038db:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8038de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e5:	00 00 00 
  8038e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038eb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8038ed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f4:	00 00 00 
  8038f7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038fa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8038fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803904:	00 00 00 
  803907:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80390a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80390d:	bf 07 00 00 00       	mov    $0x7,%edi
  803912:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
  80391e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803921:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803925:	78 69                	js     803990 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803927:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80392e:	7f 08                	jg     803938 <nsipc_recv+0x6f>
  803930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803933:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803936:	7e 35                	jle    80396d <nsipc_recv+0xa4>
  803938:	48 b9 42 4c 80 00 00 	movabs $0x804c42,%rcx
  80393f:	00 00 00 
  803942:	48 ba 57 4c 80 00 00 	movabs $0x804c57,%rdx
  803949:	00 00 00 
  80394c:	be 61 00 00 00       	mov    $0x61,%esi
  803951:	48 bf 6c 4c 80 00 00 	movabs $0x804c6c,%rdi
  803958:	00 00 00 
  80395b:	b8 00 00 00 00       	mov    $0x0,%eax
  803960:	49 b8 f0 05 80 00 00 	movabs $0x8005f0,%r8
  803967:	00 00 00 
  80396a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80396d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803970:	48 63 d0             	movslq %eax,%rdx
  803973:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803977:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80397e:	00 00 00 
  803981:	48 89 c7             	mov    %rax,%rdi
  803984:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  80398b:	00 00 00 
  80398e:	ff d0                	callq  *%rax
	}

	return r;
  803990:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803993:	c9                   	leaveq 
  803994:	c3                   	retq   

0000000000803995 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803995:	55                   	push   %rbp
  803996:	48 89 e5             	mov    %rsp,%rbp
  803999:	48 83 ec 20          	sub    $0x20,%rsp
  80399d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039a4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039a7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b1:	00 00 00 
  8039b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8039b9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8039c0:	7e 35                	jle    8039f7 <nsipc_send+0x62>
  8039c2:	48 b9 78 4c 80 00 00 	movabs $0x804c78,%rcx
  8039c9:	00 00 00 
  8039cc:	48 ba 57 4c 80 00 00 	movabs $0x804c57,%rdx
  8039d3:	00 00 00 
  8039d6:	be 6c 00 00 00       	mov    $0x6c,%esi
  8039db:	48 bf 6c 4c 80 00 00 	movabs $0x804c6c,%rdi
  8039e2:	00 00 00 
  8039e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ea:	49 b8 f0 05 80 00 00 	movabs $0x8005f0,%r8
  8039f1:	00 00 00 
  8039f4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039fa:	48 63 d0             	movslq %eax,%rdx
  8039fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a01:	48 89 c6             	mov    %rax,%rsi
  803a04:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a0b:	00 00 00 
  803a0e:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  803a15:	00 00 00 
  803a18:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a1a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a21:	00 00 00 
  803a24:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a27:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a31:	00 00 00 
  803a34:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a37:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a3a:	bf 08 00 00 00       	mov    $0x8,%edi
  803a3f:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 10          	sub    $0x10,%rsp
  803a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a58:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a5b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a5e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a65:	00 00 00 
  803a68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a6b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a6d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a74:	00 00 00 
  803a77:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a7d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a84:	00 00 00 
  803a87:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a8a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a8d:	bf 09 00 00 00       	mov    $0x9,%edi
  803a92:	48 b8 54 36 80 00 00 	movabs $0x803654,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
}
  803a9e:	c9                   	leaveq 
  803a9f:	c3                   	retq   

0000000000803aa0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803aa0:	55                   	push   %rbp
  803aa1:	48 89 e5             	mov    %rsp,%rbp
  803aa4:	53                   	push   %rbx
  803aa5:	48 83 ec 38          	sub    $0x38,%rsp
  803aa9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803aad:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ab1:	48 89 c7             	mov    %rax,%rdi
  803ab4:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ac7:	0f 88 bf 01 00 00    	js     803c8c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad1:	ba 07 04 00 00       	mov    $0x407,%edx
  803ad6:	48 89 c6             	mov    %rax,%rsi
  803ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ade:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  803ae5:	00 00 00 
  803ae8:	ff d0                	callq  *%rax
  803aea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803af1:	0f 88 95 01 00 00    	js     803c8c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803af7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803afb:	48 89 c7             	mov    %rax,%rdi
  803afe:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
  803b0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b11:	0f 88 5d 01 00 00    	js     803c74 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1b:	ba 07 04 00 00       	mov    $0x407,%edx
  803b20:	48 89 c6             	mov    %rax,%rsi
  803b23:	bf 00 00 00 00       	mov    $0x0,%edi
  803b28:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b3b:	0f 88 33 01 00 00    	js     803c74 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b45:	48 89 c7             	mov    %rax,%rdi
  803b48:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803b4f:	00 00 00 
  803b52:	ff d0                	callq  *%rax
  803b54:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5c:	ba 07 04 00 00       	mov    $0x407,%edx
  803b61:	48 89 c6             	mov    %rax,%rsi
  803b64:	bf 00 00 00 00       	mov    $0x0,%edi
  803b69:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
  803b75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b7c:	0f 88 d9 00 00 00    	js     803c5b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b86:	48 89 c7             	mov    %rax,%rdi
  803b89:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803b90:	00 00 00 
  803b93:	ff d0                	callq  *%rax
  803b95:	48 89 c2             	mov    %rax,%rdx
  803b98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b9c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ba2:	48 89 d1             	mov    %rdx,%rcx
  803ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  803baa:	48 89 c6             	mov    %rax,%rsi
  803bad:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb2:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
  803bbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bc5:	78 79                	js     803c40 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803bc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bcb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bd2:	00 00 00 
  803bd5:	8b 12                	mov    (%rdx),%edx
  803bd7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803bd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bdd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803be4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bef:	00 00 00 
  803bf2:	8b 12                	mov    (%rdx),%edx
  803bf4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803bf6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bfa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c05:	48 89 c7             	mov    %rax,%rdi
  803c08:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
  803c14:	89 c2                	mov    %eax,%edx
  803c16:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c1a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c20:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c28:	48 89 c7             	mov    %rax,%rdi
  803c2b:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  803c32:	00 00 00 
  803c35:	ff d0                	callq  *%rax
  803c37:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c39:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3e:	eb 4f                	jmp    803c8f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803c40:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803c41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c45:	48 89 c6             	mov    %rax,%rsi
  803c48:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4d:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	eb 01                	jmp    803c5c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803c5b:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803c5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c60:	48 89 c6             	mov    %rax,%rsi
  803c63:	bf 00 00 00 00       	mov    $0x0,%edi
  803c68:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c78:	48 89 c6             	mov    %rax,%rsi
  803c7b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c80:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803c87:	00 00 00 
  803c8a:	ff d0                	callq  *%rax
err:
	return r;
  803c8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c8f:	48 83 c4 38          	add    $0x38,%rsp
  803c93:	5b                   	pop    %rbx
  803c94:	5d                   	pop    %rbp
  803c95:	c3                   	retq   

0000000000803c96 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	53                   	push   %rbx
  803c9b:	48 83 ec 28          	sub    $0x28,%rsp
  803c9f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ca3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ca7:	eb 01                	jmp    803caa <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803ca9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803caa:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cb1:	00 00 00 
  803cb4:	48 8b 00             	mov    (%rax),%rax
  803cb7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc4:	48 89 c7             	mov    %rax,%rdi
  803cc7:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
  803cd3:	89 c3                	mov    %eax,%ebx
  803cd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd9:	48 89 c7             	mov    %rax,%rdi
  803cdc:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
  803ce8:	39 c3                	cmp    %eax,%ebx
  803cea:	0f 94 c0             	sete   %al
  803ced:	0f b6 c0             	movzbl %al,%eax
  803cf0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803cf3:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cfa:	00 00 00 
  803cfd:	48 8b 00             	mov    (%rax),%rax
  803d00:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d06:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d0c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d0f:	75 0a                	jne    803d1b <_pipeisclosed+0x85>
			return ret;
  803d11:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803d14:	48 83 c4 28          	add    $0x28,%rsp
  803d18:	5b                   	pop    %rbx
  803d19:	5d                   	pop    %rbp
  803d1a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d21:	74 86                	je     803ca9 <_pipeisclosed+0x13>
  803d23:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d27:	75 80                	jne    803ca9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d29:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d30:	00 00 00 
  803d33:	48 8b 00             	mov    (%rax),%rax
  803d36:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d3c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d42:	89 c6                	mov    %eax,%esi
  803d44:	48 bf 89 4c 80 00 00 	movabs $0x804c89,%rdi
  803d4b:	00 00 00 
  803d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d53:	49 b8 2b 08 80 00 00 	movabs $0x80082b,%r8
  803d5a:	00 00 00 
  803d5d:	41 ff d0             	callq  *%r8
	}
  803d60:	e9 44 ff ff ff       	jmpq   803ca9 <_pipeisclosed+0x13>

0000000000803d65 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803d65:	55                   	push   %rbp
  803d66:	48 89 e5             	mov    %rsp,%rbp
  803d69:	48 83 ec 30          	sub    $0x30,%rsp
  803d6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d70:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d74:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d77:	48 89 d6             	mov    %rdx,%rsi
  803d7a:	89 c7                	mov    %eax,%edi
  803d7c:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  803d83:	00 00 00 
  803d86:	ff d0                	callq  *%rax
  803d88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d8f:	79 05                	jns    803d96 <pipeisclosed+0x31>
		return r;
  803d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d94:	eb 31                	jmp    803dc7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9a:	48 89 c7             	mov    %rax,%rdi
  803d9d:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803da4:	00 00 00 
  803da7:	ff d0                	callq  *%rax
  803da9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803db5:	48 89 d6             	mov    %rdx,%rsi
  803db8:	48 89 c7             	mov    %rax,%rdi
  803dbb:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
}
  803dc7:	c9                   	leaveq 
  803dc8:	c3                   	retq   

0000000000803dc9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dc9:	55                   	push   %rbp
  803dca:	48 89 e5             	mov    %rsp,%rbp
  803dcd:	48 83 ec 40          	sub    $0x40,%rsp
  803dd1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dd5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dd9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ddd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de1:	48 89 c7             	mov    %rax,%rdi
  803de4:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803deb:	00 00 00 
  803dee:	ff d0                	callq  *%rax
  803df0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dfc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e03:	00 
  803e04:	e9 97 00 00 00       	jmpq   803ea0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e09:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e0e:	74 09                	je     803e19 <devpipe_read+0x50>
				return i;
  803e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e14:	e9 95 00 00 00       	jmpq   803eae <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e21:	48 89 d6             	mov    %rdx,%rsi
  803e24:	48 89 c7             	mov    %rax,%rdi
  803e27:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803e2e:	00 00 00 
  803e31:	ff d0                	callq  *%rax
  803e33:	85 c0                	test   %eax,%eax
  803e35:	74 07                	je     803e3e <devpipe_read+0x75>
				return 0;
  803e37:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3c:	eb 70                	jmp    803eae <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e3e:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	callq  *%rax
  803e4a:	eb 01                	jmp    803e4d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e4c:	90                   	nop
  803e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e51:	8b 10                	mov    (%rax),%edx
  803e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e57:	8b 40 04             	mov    0x4(%rax),%eax
  803e5a:	39 c2                	cmp    %eax,%edx
  803e5c:	74 ab                	je     803e09 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e66:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6e:	8b 00                	mov    (%rax),%eax
  803e70:	89 c2                	mov    %eax,%edx
  803e72:	c1 fa 1f             	sar    $0x1f,%edx
  803e75:	c1 ea 1b             	shr    $0x1b,%edx
  803e78:	01 d0                	add    %edx,%eax
  803e7a:	83 e0 1f             	and    $0x1f,%eax
  803e7d:	29 d0                	sub    %edx,%eax
  803e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e83:	48 98                	cltq   
  803e85:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e8a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e90:	8b 00                	mov    (%rax),%eax
  803e92:	8d 50 01             	lea    0x1(%rax),%edx
  803e95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e99:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ea8:	72 a2                	jb     803e4c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803eae:	c9                   	leaveq 
  803eaf:	c3                   	retq   

0000000000803eb0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803eb0:	55                   	push   %rbp
  803eb1:	48 89 e5             	mov    %rsp,%rbp
  803eb4:	48 83 ec 40          	sub    $0x40,%rsp
  803eb8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ebc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ec0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ec4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec8:	48 89 c7             	mov    %rax,%rdi
  803ecb:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
  803ed7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803edb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803edf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ee3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803eea:	00 
  803eeb:	e9 93 00 00 00       	jmpq   803f83 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ef0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ef4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef8:	48 89 d6             	mov    %rdx,%rsi
  803efb:	48 89 c7             	mov    %rax,%rdi
  803efe:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803f05:	00 00 00 
  803f08:	ff d0                	callq  *%rax
  803f0a:	85 c0                	test   %eax,%eax
  803f0c:	74 07                	je     803f15 <devpipe_write+0x65>
				return 0;
  803f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f13:	eb 7c                	jmp    803f91 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f15:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  803f1c:	00 00 00 
  803f1f:	ff d0                	callq  *%rax
  803f21:	eb 01                	jmp    803f24 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f23:	90                   	nop
  803f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f28:	8b 40 04             	mov    0x4(%rax),%eax
  803f2b:	48 63 d0             	movslq %eax,%rdx
  803f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f32:	8b 00                	mov    (%rax),%eax
  803f34:	48 98                	cltq   
  803f36:	48 83 c0 20          	add    $0x20,%rax
  803f3a:	48 39 c2             	cmp    %rax,%rdx
  803f3d:	73 b1                	jae    803ef0 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f43:	8b 40 04             	mov    0x4(%rax),%eax
  803f46:	89 c2                	mov    %eax,%edx
  803f48:	c1 fa 1f             	sar    $0x1f,%edx
  803f4b:	c1 ea 1b             	shr    $0x1b,%edx
  803f4e:	01 d0                	add    %edx,%eax
  803f50:	83 e0 1f             	and    $0x1f,%eax
  803f53:	29 d0                	sub    %edx,%eax
  803f55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f59:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f5d:	48 01 ca             	add    %rcx,%rdx
  803f60:	0f b6 0a             	movzbl (%rdx),%ecx
  803f63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f67:	48 98                	cltq   
  803f69:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f71:	8b 40 04             	mov    0x4(%rax),%eax
  803f74:	8d 50 01             	lea    0x1(%rax),%edx
  803f77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f7b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f7e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f87:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f8b:	72 96                	jb     803f23 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f91:	c9                   	leaveq 
  803f92:	c3                   	retq   

0000000000803f93 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f93:	55                   	push   %rbp
  803f94:	48 89 e5             	mov    %rsp,%rbp
  803f97:	48 83 ec 20          	sub    $0x20,%rsp
  803f9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa7:	48 89 c7             	mov    %rax,%rdi
  803faa:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  803fb1:	00 00 00 
  803fb4:	ff d0                	callq  *%rax
  803fb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbe:	48 be 9c 4c 80 00 00 	movabs $0x804c9c,%rsi
  803fc5:	00 00 00 
  803fc8:	48 89 c7             	mov    %rax,%rdi
  803fcb:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  803fd2:	00 00 00 
  803fd5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803fd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fdb:	8b 50 04             	mov    0x4(%rax),%edx
  803fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe2:	8b 00                	mov    (%rax),%eax
  803fe4:	29 c2                	sub    %eax,%edx
  803fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fea:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ff0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ffb:	00 00 00 
	stat->st_dev = &devpipe;
  803ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804002:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804009:	00 00 00 
  80400c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804013:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804018:	c9                   	leaveq 
  804019:	c3                   	retq   

000000000080401a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80401a:	55                   	push   %rbp
  80401b:	48 89 e5             	mov    %rsp,%rbp
  80401e:	48 83 ec 10          	sub    $0x10,%rsp
  804022:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402a:	48 89 c6             	mov    %rax,%rsi
  80402d:	bf 00 00 00 00       	mov    $0x0,%edi
  804032:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  804039:	00 00 00 
  80403c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80403e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804042:	48 89 c7             	mov    %rax,%rdi
  804045:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  80404c:	00 00 00 
  80404f:	ff d0                	callq  *%rax
  804051:	48 89 c6             	mov    %rax,%rsi
  804054:	bf 00 00 00 00       	mov    $0x0,%edi
  804059:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
}
  804065:	c9                   	leaveq 
  804066:	c3                   	retq   
	...

0000000000804068 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804068:	55                   	push   %rbp
  804069:	48 89 e5             	mov    %rsp,%rbp
  80406c:	48 83 ec 20          	sub    $0x20,%rsp
  804070:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804073:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804076:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804079:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80407d:	be 01 00 00 00       	mov    $0x1,%esi
  804082:	48 89 c7             	mov    %rax,%rdi
  804085:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  80408c:	00 00 00 
  80408f:	ff d0                	callq  *%rax
}
  804091:	c9                   	leaveq 
  804092:	c3                   	retq   

0000000000804093 <getchar>:

int
getchar(void)
{
  804093:	55                   	push   %rbp
  804094:	48 89 e5             	mov    %rsp,%rbp
  804097:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80409b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80409f:	ba 01 00 00 00       	mov    $0x1,%edx
  8040a4:	48 89 c6             	mov    %rax,%rsi
  8040a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ac:	48 b8 7c 28 80 00 00 	movabs $0x80287c,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8040bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040bf:	79 05                	jns    8040c6 <getchar+0x33>
		return r;
  8040c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c4:	eb 14                	jmp    8040da <getchar+0x47>
	if (r < 1)
  8040c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ca:	7f 07                	jg     8040d3 <getchar+0x40>
		return -E_EOF;
  8040cc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8040d1:	eb 07                	jmp    8040da <getchar+0x47>
	return c;
  8040d3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8040d7:	0f b6 c0             	movzbl %al,%eax
}
  8040da:	c9                   	leaveq 
  8040db:	c3                   	retq   

00000000008040dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040dc:	55                   	push   %rbp
  8040dd:	48 89 e5             	mov    %rsp,%rbp
  8040e0:	48 83 ec 20          	sub    $0x20,%rsp
  8040e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ee:	48 89 d6             	mov    %rdx,%rsi
  8040f1:	89 c7                	mov    %eax,%edi
  8040f3:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
  8040ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804106:	79 05                	jns    80410d <iscons+0x31>
		return r;
  804108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410b:	eb 1a                	jmp    804127 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80410d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804111:	8b 10                	mov    (%rax),%edx
  804113:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80411a:	00 00 00 
  80411d:	8b 00                	mov    (%rax),%eax
  80411f:	39 c2                	cmp    %eax,%edx
  804121:	0f 94 c0             	sete   %al
  804124:	0f b6 c0             	movzbl %al,%eax
}
  804127:	c9                   	leaveq 
  804128:	c3                   	retq   

0000000000804129 <opencons>:

int
opencons(void)
{
  804129:	55                   	push   %rbp
  80412a:	48 89 e5             	mov    %rsp,%rbp
  80412d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804131:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804135:	48 89 c7             	mov    %rax,%rdi
  804138:	48 b8 b2 23 80 00 00 	movabs $0x8023b2,%rax
  80413f:	00 00 00 
  804142:	ff d0                	callq  *%rax
  804144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414b:	79 05                	jns    804152 <opencons+0x29>
		return r;
  80414d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804150:	eb 5b                	jmp    8041ad <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804156:	ba 07 04 00 00       	mov    $0x407,%edx
  80415b:	48 89 c6             	mov    %rax,%rsi
  80415e:	bf 00 00 00 00       	mov    $0x0,%edi
  804163:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  80416a:	00 00 00 
  80416d:	ff d0                	callq  *%rax
  80416f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804176:	79 05                	jns    80417d <opencons+0x54>
		return r;
  804178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417b:	eb 30                	jmp    8041ad <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80417d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804181:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804188:	00 00 00 
  80418b:	8b 12                	mov    (%rdx),%edx
  80418d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80418f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804193:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80419a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419e:	48 89 c7             	mov    %rax,%rdi
  8041a1:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  8041a8:	00 00 00 
  8041ab:	ff d0                	callq  *%rax
}
  8041ad:	c9                   	leaveq 
  8041ae:	c3                   	retq   

00000000008041af <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041af:	55                   	push   %rbp
  8041b0:	48 89 e5             	mov    %rsp,%rbp
  8041b3:	48 83 ec 30          	sub    $0x30,%rsp
  8041b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8041c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041c8:	75 13                	jne    8041dd <devcons_read+0x2e>
		return 0;
  8041ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cf:	eb 49                	jmp    80421a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8041d1:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8041dd:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  8041e4:	00 00 00 
  8041e7:	ff d0                	callq  *%rax
  8041e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f0:	74 df                	je     8041d1 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8041f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f6:	79 05                	jns    8041fd <devcons_read+0x4e>
		return c;
  8041f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041fb:	eb 1d                	jmp    80421a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8041fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804201:	75 07                	jne    80420a <devcons_read+0x5b>
		return 0;
  804203:	b8 00 00 00 00       	mov    $0x0,%eax
  804208:	eb 10                	jmp    80421a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80420a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420d:	89 c2                	mov    %eax,%edx
  80420f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804213:	88 10                	mov    %dl,(%rax)
	return 1;
  804215:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80421a:	c9                   	leaveq 
  80421b:	c3                   	retq   

000000000080421c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80421c:	55                   	push   %rbp
  80421d:	48 89 e5             	mov    %rsp,%rbp
  804220:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804227:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80422e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804235:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80423c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804243:	eb 77                	jmp    8042bc <devcons_write+0xa0>
		m = n - tot;
  804245:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80424c:	89 c2                	mov    %eax,%edx
  80424e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804251:	89 d1                	mov    %edx,%ecx
  804253:	29 c1                	sub    %eax,%ecx
  804255:	89 c8                	mov    %ecx,%eax
  804257:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80425a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80425d:	83 f8 7f             	cmp    $0x7f,%eax
  804260:	76 07                	jbe    804269 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804262:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804269:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80426c:	48 63 d0             	movslq %eax,%rdx
  80426f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804272:	48 98                	cltq   
  804274:	48 89 c1             	mov    %rax,%rcx
  804277:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80427e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804285:	48 89 ce             	mov    %rcx,%rsi
  804288:	48 89 c7             	mov    %rax,%rdi
  80428b:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  804292:	00 00 00 
  804295:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804297:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80429a:	48 63 d0             	movslq %eax,%rdx
  80429d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042a4:	48 89 d6             	mov    %rdx,%rsi
  8042a7:	48 89 c7             	mov    %rax,%rdi
  8042aa:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8042b1:	00 00 00 
  8042b4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042b9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8042bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042bf:	48 98                	cltq   
  8042c1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8042c8:	0f 82 77 ff ff ff    	jb     804245 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8042ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042d1:	c9                   	leaveq 
  8042d2:	c3                   	retq   

00000000008042d3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8042d3:	55                   	push   %rbp
  8042d4:	48 89 e5             	mov    %rsp,%rbp
  8042d7:	48 83 ec 08          	sub    $0x8,%rsp
  8042db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8042df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042e4:	c9                   	leaveq 
  8042e5:	c3                   	retq   

00000000008042e6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8042e6:	55                   	push   %rbp
  8042e7:	48 89 e5             	mov    %rsp,%rbp
  8042ea:	48 83 ec 10          	sub    $0x10,%rsp
  8042ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8042f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042fa:	48 be a8 4c 80 00 00 	movabs $0x804ca8,%rsi
  804301:	00 00 00 
  804304:	48 89 c7             	mov    %rax,%rdi
  804307:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  80430e:	00 00 00 
  804311:	ff d0                	callq  *%rax
	return 0;
  804313:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804318:	c9                   	leaveq 
  804319:	c3                   	retq   
	...

000000000080431c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80431c:	55                   	push   %rbp
  80431d:	48 89 e5             	mov    %rsp,%rbp
  804320:	48 83 ec 30          	sub    $0x30,%rsp
  804324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80432c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  804337:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80433c:	74 18                	je     804356 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  80433e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804342:	48 89 c7             	mov    %rax,%rdi
  804345:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  80434c:	00 00 00 
  80434f:	ff d0                	callq  *%rax
  804351:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804354:	eb 19                	jmp    80436f <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  804356:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  80435d:	00 00 00 
  804360:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  804367:	00 00 00 
  80436a:	ff d0                	callq  *%rax
  80436c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80436f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804373:	79 39                	jns    8043ae <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804375:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80437a:	75 08                	jne    804384 <ipc_recv+0x68>
  80437c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804380:	8b 00                	mov    (%rax),%eax
  804382:	eb 05                	jmp    804389 <ipc_recv+0x6d>
  804384:	b8 00 00 00 00       	mov    $0x0,%eax
  804389:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80438d:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80438f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804394:	75 08                	jne    80439e <ipc_recv+0x82>
  804396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80439a:	8b 00                	mov    (%rax),%eax
  80439c:	eb 05                	jmp    8043a3 <ipc_recv+0x87>
  80439e:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043a7:	89 02                	mov    %eax,(%rdx)
		return r;
  8043a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ac:	eb 53                	jmp    804401 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  8043ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043b3:	74 19                	je     8043ce <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  8043b5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8043bc:	00 00 00 
  8043bf:	48 8b 00             	mov    (%rax),%rax
  8043c2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8043c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043cc:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  8043ce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043d3:	74 19                	je     8043ee <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  8043d5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8043dc:	00 00 00 
  8043df:	48 8b 00             	mov    (%rax),%rax
  8043e2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8043e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ec:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  8043ee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8043f5:	00 00 00 
  8043f8:	48 8b 00             	mov    (%rax),%rax
  8043fb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804401:	c9                   	leaveq 
  804402:	c3                   	retq   

0000000000804403 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804403:	55                   	push   %rbp
  804404:	48 89 e5             	mov    %rsp,%rbp
  804407:	48 83 ec 30          	sub    $0x30,%rsp
  80440b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80440e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804411:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804415:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  804418:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  80441f:	eb 59                	jmp    80447a <ipc_send+0x77>
		if(pg) {
  804421:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804426:	74 20                	je     804448 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804428:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80442b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80442e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804432:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804435:	89 c7                	mov    %eax,%edi
  804437:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  80443e:	00 00 00 
  804441:	ff d0                	callq  *%rax
  804443:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804446:	eb 26                	jmp    80446e <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  804448:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80444b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80444e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804451:	89 d1                	mov    %edx,%ecx
  804453:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80445a:	00 00 00 
  80445d:	89 c7                	mov    %eax,%edi
  80445f:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  804466:	00 00 00 
  804469:	ff d0                	callq  *%rax
  80446b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80446e:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  804475:	00 00 00 
  804478:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  80447a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80447e:	74 a1                	je     804421 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804484:	74 2a                	je     8044b0 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804486:	48 ba b0 4c 80 00 00 	movabs $0x804cb0,%rdx
  80448d:	00 00 00 
  804490:	be 49 00 00 00       	mov    $0x49,%esi
  804495:	48 bf db 4c 80 00 00 	movabs $0x804cdb,%rdi
  80449c:	00 00 00 
  80449f:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a4:	48 b9 f0 05 80 00 00 	movabs $0x8005f0,%rcx
  8044ab:	00 00 00 
  8044ae:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  8044b0:	c9                   	leaveq 
  8044b1:	c3                   	retq   

00000000008044b2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8044b2:	55                   	push   %rbp
  8044b3:	48 89 e5             	mov    %rsp,%rbp
  8044b6:	48 83 ec 18          	sub    $0x18,%rsp
  8044ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8044bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044c4:	eb 6a                	jmp    804530 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  8044c6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8044cd:	00 00 00 
  8044d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d3:	48 63 d0             	movslq %eax,%rdx
  8044d6:	48 89 d0             	mov    %rdx,%rax
  8044d9:	48 c1 e0 02          	shl    $0x2,%rax
  8044dd:	48 01 d0             	add    %rdx,%rax
  8044e0:	48 01 c0             	add    %rax,%rax
  8044e3:	48 01 d0             	add    %rdx,%rax
  8044e6:	48 c1 e0 05          	shl    $0x5,%rax
  8044ea:	48 01 c8             	add    %rcx,%rax
  8044ed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044f3:	8b 00                	mov    (%rax),%eax
  8044f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044f8:	75 32                	jne    80452c <ipc_find_env+0x7a>
			return envs[i].env_id;
  8044fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804501:	00 00 00 
  804504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804507:	48 63 d0             	movslq %eax,%rdx
  80450a:	48 89 d0             	mov    %rdx,%rax
  80450d:	48 c1 e0 02          	shl    $0x2,%rax
  804511:	48 01 d0             	add    %rdx,%rax
  804514:	48 01 c0             	add    %rax,%rax
  804517:	48 01 d0             	add    %rdx,%rax
  80451a:	48 c1 e0 05          	shl    $0x5,%rax
  80451e:	48 01 c8             	add    %rcx,%rax
  804521:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804527:	8b 40 08             	mov    0x8(%rax),%eax
  80452a:	eb 12                	jmp    80453e <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80452c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804530:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804537:	7e 8d                	jle    8044c6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80453e:	c9                   	leaveq 
  80453f:	c3                   	retq   

0000000000804540 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804540:	55                   	push   %rbp
  804541:	48 89 e5             	mov    %rsp,%rbp
  804544:	48 83 ec 18          	sub    $0x18,%rsp
  804548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80454c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804550:	48 89 c2             	mov    %rax,%rdx
  804553:	48 c1 ea 15          	shr    $0x15,%rdx
  804557:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80455e:	01 00 00 
  804561:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804565:	83 e0 01             	and    $0x1,%eax
  804568:	48 85 c0             	test   %rax,%rax
  80456b:	75 07                	jne    804574 <pageref+0x34>
		return 0;
  80456d:	b8 00 00 00 00       	mov    $0x0,%eax
  804572:	eb 53                	jmp    8045c7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804578:	48 89 c2             	mov    %rax,%rdx
  80457b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80457f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804586:	01 00 00 
  804589:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80458d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804595:	83 e0 01             	and    $0x1,%eax
  804598:	48 85 c0             	test   %rax,%rax
  80459b:	75 07                	jne    8045a4 <pageref+0x64>
		return 0;
  80459d:	b8 00 00 00 00       	mov    $0x0,%eax
  8045a2:	eb 23                	jmp    8045c7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8045a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045a8:	48 89 c2             	mov    %rax,%rdx
  8045ab:	48 c1 ea 0c          	shr    $0xc,%rdx
  8045af:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8045b6:	00 00 00 
  8045b9:	48 c1 e2 04          	shl    $0x4,%rdx
  8045bd:	48 01 d0             	add    %rdx,%rax
  8045c0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045c4:	0f b7 c0             	movzwl %ax,%eax
}
  8045c7:	c9                   	leaveq 
  8045c8:	c3                   	retq   
