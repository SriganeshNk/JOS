
obj/user/sh.debug:     file format elf64-x86-64


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
  80003c:	e8 37 11 00 00       	callq  801178 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004f:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005d:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800064:	be 00 00 00 00       	mov    $0x0,%esi
  800069:	48 89 c7             	mov    %rax,%rdi
  80006c:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax

again:
	argc = 0;
  800078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007f:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800086:	48 89 c6             	mov    %rax,%rsi
  800089:	bf 00 00 00 00       	mov    $0x0,%edi
  80008e:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
  80009a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000a0:	83 f8 77             	cmp    $0x77,%eax
  8000a3:	74 2e                	je     8000d3 <runcmd+0x8f>
  8000a5:	83 f8 77             	cmp    $0x77,%eax
  8000a8:	7f 1b                	jg     8000c5 <runcmd+0x81>
  8000aa:	83 f8 3c             	cmp    $0x3c,%eax
  8000ad:	74 6e                	je     80011d <runcmd+0xd9>
  8000af:	83 f8 3e             	cmp    $0x3e,%eax
  8000b2:	0f 84 3a 01 00 00    	je     8001f2 <runcmd+0x1ae>
  8000b8:	85 c0                	test   %eax,%eax
  8000ba:	0f 84 af 03 00 00    	je     80046f <runcmd+0x42b>
  8000c0:	e9 71 03 00 00       	jmpq   800436 <runcmd+0x3f2>
  8000c5:	83 f8 7c             	cmp    $0x7c,%eax
  8000c8:	0f 84 f9 01 00 00    	je     8002c7 <runcmd+0x283>
  8000ce:	e9 63 03 00 00       	jmpq   800436 <runcmd+0x3f2>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d3:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d7:	75 27                	jne    800100 <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d9:	48 bf 08 66 80 00 00 	movabs $0x806608,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  8000ef:	00 00 00 
  8000f2:	ff d2                	callq  *%rdx
				exit();
  8000f4:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  800100:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	48 98                	cltq   
  80010c:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800113:	ff 
  800114:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
  800118:	e9 4d 03 00 00       	jmpq   80046a <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011d:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800124:	48 89 c6             	mov    %rax,%rsi
  800127:	bf 00 00 00 00       	mov    $0x0,%edi
  80012c:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800133:	00 00 00 
  800136:	ff d0                	callq  *%rax
  800138:	83 f8 77             	cmp    $0x77,%eax
  80013b:	74 27                	je     800164 <runcmd+0x120>
				cprintf("syntax error: < not followed by word\n");
  80013d:	48 bf 20 66 80 00 00 	movabs $0x806620,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800153:	00 00 00 
  800156:	ff d2                	callq  *%rdx
				exit();
  800158:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80015f:	00 00 00 
  800162:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800164:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016b:	be 00 00 00 00       	mov    $0x0,%esi
  800170:	48 89 c7             	mov    %rax,%rdi
  800173:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
  80017f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800182:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800186:	79 34                	jns    8001bc <runcmd+0x178>
				cprintf("open %s for read: %e", t, fd);
  800188:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80018f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800192:	48 89 c6             	mov    %rax,%rsi
  800195:	48 bf 46 66 80 00 00 	movabs $0x806646,%rdi
  80019c:	00 00 00 
  80019f:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a4:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  8001ab:	00 00 00 
  8001ae:	ff d1                	callq  *%rcx
				exit();
  8001b0:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c0:	0f 84 a0 02 00 00    	je     800466 <runcmd+0x422>
				dup(fd, 0);
  8001c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c9:	be 00 00 00 00       	mov    $0x0,%esi
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  8001d7:	00 00 00 
  8001da:	ff d0                	callq  *%rax
				close(fd);
  8001dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001df:	89 c7                	mov    %eax,%edi
  8001e1:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
			}
			break;
  8001ed:	e9 74 02 00 00       	jmpq   800466 <runcmd+0x422>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f2:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001f9:	48 89 c6             	mov    %rax,%rsi
  8001fc:	bf 00 00 00 00       	mov    $0x0,%edi
  800201:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  800208:	00 00 00 
  80020b:	ff d0                	callq  *%rax
  80020d:	83 f8 77             	cmp    $0x77,%eax
  800210:	74 27                	je     800239 <runcmd+0x1f5>
				cprintf("syntax error: > not followed by word\n");
  800212:	48 bf 60 66 80 00 00 	movabs $0x806660,%rdi
  800219:	00 00 00 
  80021c:	b8 00 00 00 00       	mov    $0x0,%eax
  800221:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800228:	00 00 00 
  80022b:	ff d2                	callq  *%rdx
				exit();
  80022d:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800239:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800240:	be 01 03 00 00       	mov    $0x301,%esi
  800245:	48 89 c7             	mov    %rax,%rdi
  800248:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  80024f:	00 00 00 
  800252:	ff d0                	callq  *%rax
  800254:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800257:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025b:	79 34                	jns    800291 <runcmd+0x24d>
				cprintf("open %s for write: %e", t, fd);
  80025d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800264:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800267:	48 89 c6             	mov    %rax,%rsi
  80026a:	48 bf 86 66 80 00 00 	movabs $0x806686,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  800280:	00 00 00 
  800283:	ff d1                	callq  *%rcx
				exit();
  800285:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800291:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800295:	0f 84 ce 01 00 00    	je     800469 <runcmd+0x425>
				dup(fd, 1);
  80029b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029e:	be 01 00 00 00       	mov    $0x1,%esi
  8002a3:	89 c7                	mov    %eax,%edi
  8002a5:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  8002ac:	00 00 00 
  8002af:	ff d0                	callq  *%rax
				close(fd);
  8002b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
			}
			break;
  8002c2:	e9 a2 01 00 00       	jmpq   800469 <runcmd+0x425>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002c7:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002ce:	48 89 c7             	mov    %rax,%rdi
  8002d1:	48 b8 c0 5b 80 00 00 	movabs $0x805bc0,%rax
  8002d8:	00 00 00 
  8002db:	ff d0                	callq  *%rax
  8002dd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e4:	79 2c                	jns    800312 <runcmd+0x2ce>
				cprintf("pipe: %e", r);
  8002e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e9:	89 c6                	mov    %eax,%esi
  8002eb:	48 bf 9c 66 80 00 00 	movabs $0x80669c,%rdi
  8002f2:	00 00 00 
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fa:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800301:	00 00 00 
  800304:	ff d2                	callq  *%rdx
				exit();
  800306:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
			}
			if (debug)
  800312:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800319:	00 00 00 
  80031c:	8b 00                	mov    (%rax),%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	74 29                	je     80034b <runcmd+0x307>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800322:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  800328:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80032e:	89 c6                	mov    %eax,%esi
  800330:	48 bf a5 66 80 00 00 	movabs $0x8066a5,%rdi
  800337:	00 00 00 
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  800346:	00 00 00 
  800349:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034b:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
  800357:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80035e:	79 2c                	jns    80038c <runcmd+0x348>
				cprintf("fork: %e", r);
  800360:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800363:	89 c6                	mov    %eax,%esi
  800365:	48 bf b2 66 80 00 00 	movabs $0x8066b2,%rdi
  80036c:	00 00 00 
  80036f:	b8 00 00 00 00       	mov    $0x0,%eax
  800374:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  80037b:	00 00 00 
  80037e:	ff d2                	callq  *%rdx
				exit();
  800380:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800387:	00 00 00 
  80038a:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800390:	75 50                	jne    8003e2 <runcmd+0x39e>
				if (p[0] != 0) {
  800392:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 2d                	je     8003c9 <runcmd+0x385>
					dup(p[0], 0);
  80039c:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a2:	be 00 00 00 00       	mov    $0x0,%esi
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
					close(p[0]);
  8003b5:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003bb:	89 c7                	mov    %eax,%edi
  8003bd:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003c9:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003cf:	89 c7                	mov    %eax,%edi
  8003d1:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
				goto again;
  8003dd:	e9 96 fc ff ff       	jmpq   800078 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003e8:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003ee:	83 f8 01             	cmp    $0x1,%eax
  8003f1:	74 2d                	je     800420 <runcmd+0x3dc>
					dup(p[1], 1);
  8003f3:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f9:	be 01 00 00 00       	mov    $0x1,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
					close(p[1]);
  80040c:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800420:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800426:	89 c7                	mov    %eax,%edi
  800428:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  80042f:	00 00 00 
  800432:	ff d0                	callq  *%rax
				goto runit;
  800434:	eb 3a                	jmp    800470 <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800436:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800439:	89 c1                	mov    %eax,%ecx
  80043b:	48 ba bb 66 80 00 00 	movabs $0x8066bb,%rdx
  800442:	00 00 00 
  800445:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044a:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800451:	00 00 00 
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  800460:	00 00 00 
  800463:	41 ff d0             	callq  *%r8
			}
			if (fd != 0) {
				dup(fd, 0);
				close(fd);
			}
			break;
  800466:	90                   	nop
  800467:	eb 01                	jmp    80046a <runcmd+0x426>
			}
			if (fd != 1) {
				dup(fd, 1);
				close(fd);
			}
			break;
  800469:	90                   	nop
		default:
			panic("bad return %d from gettoken", c);
			break;

		}
	}
  80046a:	e9 10 fc ff ff       	jmpq   80007f <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046f:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  800470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800474:	75 34                	jne    8004aa <runcmd+0x466>
		if (debug)
  800476:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80047d:	00 00 00 
  800480:	8b 00                	mov    (%rax),%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 84 7b 03 00 00    	je     800805 <runcmd+0x7c1>
			cprintf("EMPTY COMMAND\n");
  80048a:	48 bf e1 66 80 00 00 	movabs $0x8066e1,%rdi
  800491:	00 00 00 
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  8004a0:	00 00 00 
  8004a3:	ff d2                	callq  *%rdx
		return;
  8004a5:	e9 5b 03 00 00       	jmpq   800805 <runcmd+0x7c1>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b1:	e9 8a 00 00 00       	jmpq   800540 <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004bd:	00 00 00 
  8004c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c3:	48 63 d2             	movslq %edx,%rdx
  8004c6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004ca:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d1:	48 89 d6             	mov    %rdx,%rsi
  8004d4:	48 89 c7             	mov    %rax,%rdi
  8004d7:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004ea:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f1:	48 89 d6             	mov    %rdx,%rsi
  8004f4:	48 89 c7             	mov    %rax,%rdi
  8004f7:	48 b8 f6 21 80 00 00 	movabs $0x8021f6,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800503:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  80050a:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800511:	48 89 d6             	mov    %rdx,%rsi
  800514:	48 89 c7             	mov    %rax,%rdi
  800517:	48 b8 84 41 80 00 00 	movabs $0x804184,%rax
  80051e:	00 00 00 
  800521:	ff d0                	callq  *%rax
  800523:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800526:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80052a:	75 10                	jne    80053c <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052c:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800533:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  80053a:	eb 19                	jmp    800555 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800540:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800547:	00 00 00 
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054f:	0f 8c 61 ff ff ff    	jl     8004b6 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800555:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055c:	0f b6 00             	movzbl (%rax),%eax
  80055f:	3c 2f                	cmp    $0x2f,%al
  800561:	74 39                	je     80059c <runcmd+0x558>
		argv0buf[0] = '/';
  800563:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  80056a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800571:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800578:	48 83 c2 01          	add    $0x1,%rdx
  80057c:	48 89 c6             	mov    %rax,%rsi
  80057f:	48 89 d7             	mov    %rdx,%rdi
  800582:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  800589:	00 00 00 
  80058c:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058e:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800595:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059f:	48 98                	cltq   
  8005a1:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a8:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8005b4:	00 00 00 
  8005b7:	8b 00                	mov    (%rax),%eax
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	0f 84 95 00 00 00    	je     800656 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c1:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8005c8:	00 00 00 
  8005cb:	48 8b 00             	mov    (%rax),%rax
  8005ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d4:	89 c6                	mov    %eax,%esi
  8005d6:	48 bf f0 66 80 00 00 	movabs $0x8066f0,%rdi
  8005dd:	00 00 00 
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  8005ec:	00 00 00 
  8005ef:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f8:	eb 2f                	jmp    800629 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fd:	48 98                	cltq   
  8005ff:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800606:	ff 
  800607:	48 89 c6             	mov    %rax,%rsi
  80060a:	48 bf fe 66 80 00 00 	movabs $0x8066fe,%rdi
  800611:	00 00 00 
  800614:	b8 00 00 00 00       	mov    $0x0,%eax
  800619:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800620:	00 00 00 
  800623:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800625:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800629:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062c:	48 98                	cltq   
  80062e:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800635:	ff 
  800636:	48 85 c0             	test   %rax,%rax
  800639:	75 bf                	jne    8005fa <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063b:	48 bf 02 67 80 00 00 	movabs $0x806702,%rdi
  800642:	00 00 00 
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800651:	00 00 00 
  800654:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800656:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065d:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800664:	48 89 d6             	mov    %rdx,%rsi
  800667:	48 89 c7             	mov    %rax,%rdi
  80066a:	48 b8 ac 47 80 00 00 	movabs $0x8047ac,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
  800676:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800679:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067d:	79 28                	jns    8006a7 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800686:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800689:	48 89 c6             	mov    %rax,%rsi
  80068c:	48 bf 04 67 80 00 00 	movabs $0x806704,%rdi
  800693:	00 00 00 
  800696:	b8 00 00 00 00       	mov    $0x0,%eax
  80069b:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  8006a2:	00 00 00 
  8006a5:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a7:	48 b8 bd 3b 80 00 00 	movabs $0x803bbd,%rax
  8006ae:	00 00 00 
  8006b1:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b7:	0f 88 9c 00 00 00    	js     800759 <runcmd+0x715>
		if (debug)
  8006bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8006c4:	00 00 00 
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	74 3b                	je     800708 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d4:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8006db:	00 00 00 
  8006de:	48 8b 00             	mov    (%rax),%rax
  8006e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006ea:	89 c6                	mov    %eax,%esi
  8006ec:	48 bf 12 67 80 00 00 	movabs $0x806712,%rdi
  8006f3:	00 00 00 
  8006f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fb:	49 b8 7f 14 80 00 00 	movabs $0x80147f,%r8
  800702:	00 00 00 
  800705:	41 ff d0             	callq  *%r8
		wait(r);
  800708:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070b:	89 c7                	mov    %eax,%edi
  80070d:	48 b8 88 61 80 00 00 	movabs $0x806188,%rax
  800714:	00 00 00 
  800717:	ff d0                	callq  *%rax
		if (debug)
  800719:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800720:	00 00 00 
  800723:	8b 00                	mov    (%rax),%eax
  800725:	85 c0                	test   %eax,%eax
  800727:	74 30                	je     800759 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800729:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  800730:	00 00 00 
  800733:	48 8b 00             	mov    (%rax),%rax
  800736:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073c:	89 c6                	mov    %eax,%esi
  80073e:	48 bf 27 67 80 00 00 	movabs $0x806727,%rdi
  800745:	00 00 00 
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800754:	00 00 00 
  800757:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800759:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075d:	0f 84 94 00 00 00    	je     8007f7 <runcmd+0x7b3>
		if (debug)
  800763:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80076a:	00 00 00 
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	85 c0                	test   %eax,%eax
  800771:	74 33                	je     8007a6 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800773:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80077a:	00 00 00 
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800786:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800789:	89 c6                	mov    %eax,%esi
  80078b:	48 bf 3d 67 80 00 00 	movabs $0x80673d,%rdi
  800792:	00 00 00 
  800795:	b8 00 00 00 00       	mov    $0x0,%eax
  80079a:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  8007a1:	00 00 00 
  8007a4:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a9:	89 c7                	mov    %eax,%edi
  8007ab:	48 b8 88 61 80 00 00 	movabs $0x806188,%rax
  8007b2:	00 00 00 
  8007b5:	ff d0                	callq  *%rax
		if (debug)
  8007b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8007be:	00 00 00 
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	74 30                	je     8007f7 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c7:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8007ce:	00 00 00 
  8007d1:	48 8b 00             	mov    (%rax),%rax
  8007d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007da:	89 c6                	mov    %eax,%esi
  8007dc:	48 bf 27 67 80 00 00 	movabs $0x806727,%rdi
  8007e3:	00 00 00 
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  8007f2:	00 00 00 
  8007f5:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f7:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8007fe:	00 00 00 
  800801:	ff d0                	callq  *%rax
  800803:	eb 01                	jmp    800806 <runcmd+0x7c2>
runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
		if (debug)
			cprintf("EMPTY COMMAND\n");
		return;
  800805:	90                   	nop
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	48 83 ec 30          	sub    $0x30,%rsp
  800810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800818:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  80081c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800821:	75 36                	jne    800859 <_gettoken+0x51>
		if (debug > 1)
  800823:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80082a:	00 00 00 
  80082d:	8b 00                	mov    (%rax),%eax
  80082f:	83 f8 01             	cmp    $0x1,%eax
  800832:	7e 1b                	jle    80084f <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800834:	48 bf 5a 67 80 00 00 	movabs $0x80675a,%rdi
  80083b:	00 00 00 
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  80084a:	00 00 00 
  80084d:	ff d2                	callq  *%rdx
		return 0;
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
  800854:	e9 fe 01 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}

	if (debug > 1)
  800859:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800860:	00 00 00 
  800863:	8b 00                	mov    (%rax),%eax
  800865:	83 f8 01             	cmp    $0x1,%eax
  800868:	7e 22                	jle    80088c <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	48 89 c6             	mov    %rax,%rsi
  800871:	48 bf 69 67 80 00 00 	movabs $0x806769,%rdi
  800878:	00 00 00 
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
  800880:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800887:	00 00 00 
  80088a:	ff d2                	callq  *%rdx

	*p1 = 0;
  80088c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800890:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  8008a2:	eb 0c                	jmp    8008b0 <_gettoken+0xa8>
		*s++ = 0;
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	c6 00 00             	movb   $0x0,(%rax)
  8008ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	0f b6 00             	movzbl (%rax),%eax
  8008b7:	0f be c0             	movsbl %al,%eax
  8008ba:	89 c6                	mov    %eax,%esi
  8008bc:	48 bf 77 67 80 00 00 	movabs $0x806777,%rdi
  8008c3:	00 00 00 
  8008c6:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax
  8008d2:	48 85 c0             	test   %rax,%rax
  8008d5:	75 cd                	jne    8008a4 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	0f b6 00             	movzbl (%rax),%eax
  8008de:	84 c0                	test   %al,%al
  8008e0:	75 36                	jne    800918 <_gettoken+0x110>
		if (debug > 1)
  8008e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8008e9:	00 00 00 
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	83 f8 01             	cmp    $0x1,%eax
  8008f1:	7e 1b                	jle    80090e <_gettoken+0x106>
			cprintf("EOL\n");
  8008f3:	48 bf 7c 67 80 00 00 	movabs $0x80677c,%rdi
  8008fa:	00 00 00 
  8008fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800902:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800909:	00 00 00 
  80090c:	ff d2                	callq  *%rdx
		return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	e9 3f 01 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}
	if (strchr(SYMBOLS, *s)) {
  800918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091c:	0f b6 00             	movzbl (%rax),%eax
  80091f:	0f be c0             	movsbl %al,%eax
  800922:	89 c6                	mov    %eax,%esi
  800924:	48 bf 81 67 80 00 00 	movabs $0x806781,%rdi
  80092b:	00 00 00 
  80092e:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  800935:	00 00 00 
  800938:	ff d0                	callq  *%rax
  80093a:	48 85 c0             	test   %rax,%rax
  80093d:	74 68                	je     8009a7 <_gettoken+0x19f>
		t = *s;
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	0f b6 00             	movzbl (%rax),%eax
  800946:	0f be c0             	movsbl %al,%eax
  800949:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	c6 00 00             	movb   $0x0,(%rax)
  80095e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		*p2 = s;
  800963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800967:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096b:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  80096e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800975:	00 00 00 
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 01             	cmp    $0x1,%eax
  80097d:	7e 20                	jle    80099f <_gettoken+0x197>
			cprintf("TOK %c\n", t);
  80097f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800982:	89 c6                	mov    %eax,%esi
  800984:	48 bf 89 67 80 00 00 	movabs $0x806789,%rdi
  80098b:	00 00 00 
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  80099a:	00 00 00 
  80099d:	ff d2                	callq  *%rdx
		return t;
  80099f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a2:	e9 b0 00 00 00       	jmpq   800a57 <_gettoken+0x24f>
	}
	*p1 = s;
  8009a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b2:	eb 05                	jmp    8009b9 <_gettoken+0x1b1>
		s++;
  8009b4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	0f b6 00             	movzbl (%rax),%eax
  8009c0:	84 c0                	test   %al,%al
  8009c2:	74 27                	je     8009eb <_gettoken+0x1e3>
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f be c0             	movsbl %al,%eax
  8009ce:	89 c6                	mov    %eax,%esi
  8009d0:	48 bf 91 67 80 00 00 	movabs $0x806791,%rdi
  8009d7:	00 00 00 
  8009da:	48 b8 d3 23 80 00 00 	movabs $0x8023d3,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
  8009e6:	48 85 c0             	test   %rax,%rax
  8009e9:	74 c9                	je     8009b4 <_gettoken+0x1ac>
		s++;
	*p2 = s;
  8009eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f3:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8009fd:	00 00 00 
  800a00:	8b 00                	mov    (%rax),%eax
  800a02:	83 f8 01             	cmp    $0x1,%eax
  800a05:	7e 4b                	jle    800a52 <_gettoken+0x24a>
		t = **p2;
  800a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0b:	48 8b 00             	mov    (%rax),%rax
  800a0e:	0f b6 00             	movzbl (%rax),%eax
  800a11:	0f be c0             	movsbl %al,%eax
  800a14:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1b:	48 8b 00             	mov    (%rax),%rax
  800a1e:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a25:	48 8b 00             	mov    (%rax),%rax
  800a28:	48 89 c6             	mov    %rax,%rsi
  800a2b:	48 bf 9d 67 80 00 00 	movabs $0x80679d,%rdi
  800a32:	00 00 00 
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3a:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800a41:	00 00 00 
  800a44:	ff d2                	callq  *%rdx
		**p2 = t;
  800a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4a:	48 8b 00             	mov    (%rax),%rax
  800a4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a50:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a52:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a57:	c9                   	leaveq 
  800a58:	c3                   	retq   

0000000000800a59 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a59:	55                   	push   %rbp
  800a5a:	48 89 e5             	mov    %rsp,%rbp
  800a5d:	48 83 ec 10          	sub    $0x10,%rsp
  800a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a69:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a6e:	74 3a                	je     800aaa <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a74:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800a7b:	00 00 00 
  800a7e:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800a85:	00 00 00 
  800a88:	48 89 c7             	mov    %rax,%rdi
  800a8b:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax
  800a97:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800a9e:	00 00 00 
  800aa1:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	eb 74                	jmp    800b1e <gettoken+0xc5>
	}
	c = nc;
  800aaa:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800ab1:	00 00 00 
  800ab4:	8b 10                	mov    (%rax),%edx
  800ab6:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800abd:	00 00 00 
  800ac0:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac2:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  800ac9:	00 00 00 
  800acc:	48 8b 10             	mov    (%rax),%rdx
  800acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad3:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad6:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  800add:	00 00 00 
  800ae0:	48 8b 00             	mov    (%rax),%rax
  800ae3:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800aea:	00 00 00 
  800aed:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800af4:	00 00 00 
  800af7:	48 89 c7             	mov    %rax,%rdi
  800afa:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	callq  *%rax
  800b06:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800b0d:	00 00 00 
  800b10:	89 02                	mov    %eax,(%rdx)
	return c;
  800b12:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800b19:	00 00 00 
  800b1c:	8b 00                	mov    (%rax),%eax
}
  800b1e:	c9                   	leaveq 
  800b1f:	c3                   	retq   

0000000000800b20 <usage>:


void
usage(void)
{
  800b20:	55                   	push   %rbp
  800b21:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b24:	48 bf a8 67 80 00 00 	movabs $0x8067a8,%rdi
  800b2b:	00 00 00 
  800b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b33:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800b3a:	00 00 00 
  800b3d:	ff d2                	callq  *%rdx
	exit();
  800b3f:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800b46:	00 00 00 
  800b49:	ff d0                	callq  *%rax
}
  800b4b:	5d                   	pop    %rbp
  800b4c:	c3                   	retq   

0000000000800b4d <umain>:

void
umain(int argc, char **argv)
{
  800b4d:	55                   	push   %rbp
  800b4e:	48 89 e5             	mov    %rsp,%rbp
  800b51:	48 83 ec 50          	sub    $0x50,%rsp
  800b55:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b58:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800b5c:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6a:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b6e:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b72:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b76:	48 89 ce             	mov    %rcx,%rsi
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	48 b8 9c 35 80 00 00 	movabs $0x80359c,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b88:	eb 4d                	jmp    800bd7 <umain+0x8a>
		switch (r) {
  800b8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8d:	83 f8 69             	cmp    $0x69,%eax
  800b90:	74 27                	je     800bb9 <umain+0x6c>
  800b92:	83 f8 78             	cmp    $0x78,%eax
  800b95:	74 2b                	je     800bc2 <umain+0x75>
  800b97:	83 f8 64             	cmp    $0x64,%eax
  800b9a:	75 2f                	jne    800bcb <umain+0x7e>
		case 'd':
			debug++;
  800b9c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ba3:	00 00 00 
  800ba6:	8b 00                	mov    (%rax),%eax
  800ba8:	8d 50 01             	lea    0x1(%rax),%edx
  800bab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bb2:	00 00 00 
  800bb5:	89 10                	mov    %edx,(%rax)
			break;
  800bb7:	eb 1e                	jmp    800bd7 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bb9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc0:	eb 15                	jmp    800bd7 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bc9:	eb 0c                	jmp    800bd7 <umain+0x8a>
		default:
			usage();
  800bcb:	48 b8 20 0b 80 00 00 	movabs $0x800b20,%rax
  800bd2:	00 00 00 
  800bd5:	ff d0                	callq  *%rax
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd7:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdb:	48 89 c7             	mov    %rax,%rdi
  800bde:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	callq  *%rax
  800bea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf1:	79 97                	jns    800b8a <umain+0x3d>
			break;
		default:
			usage();
		}

	if (argc > 2)
  800bf3:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf6:	83 f8 02             	cmp    $0x2,%eax
  800bf9:	7e 0c                	jle    800c07 <umain+0xba>
		usage();
  800bfb:	48 b8 20 0b 80 00 00 	movabs $0x800b20,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c07:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0a:	83 f8 02             	cmp    $0x2,%eax
  800c0d:	0f 85 b3 00 00 00    	jne    800cc6 <umain+0x179>
		close(0);
  800c13:	bf 00 00 00 00       	mov    $0x0,%edi
  800c18:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  800c1f:	00 00 00 
  800c22:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c24:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c28:	48 83 c0 08          	add    $0x8,%rax
  800c2c:	48 8b 00             	mov    (%rax),%rax
  800c2f:	be 00 00 00 00       	mov    $0x0,%esi
  800c34:	48 89 c7             	mov    %rax,%rdi
  800c37:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  800c3e:	00 00 00 
  800c41:	ff d0                	callq  *%rax
  800c43:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4a:	79 3f                	jns    800c8b <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c50:	48 83 c0 08          	add    $0x8,%rax
  800c54:	48 8b 00             	mov    (%rax),%rax
  800c57:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5a:	41 89 d0             	mov    %edx,%r8d
  800c5d:	48 89 c1             	mov    %rax,%rcx
  800c60:	48 ba c9 67 80 00 00 	movabs $0x8067c9,%rdx
  800c67:	00 00 00 
  800c6a:	be 2b 01 00 00       	mov    $0x12b,%esi
  800c6f:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800c76:	00 00 00 
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	49 b9 44 12 80 00 00 	movabs $0x801244,%r9
  800c85:	00 00 00 
  800c88:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c8f:	74 35                	je     800cc6 <umain+0x179>
  800c91:	48 b9 d5 67 80 00 00 	movabs $0x8067d5,%rcx
  800c98:	00 00 00 
  800c9b:	48 ba dc 67 80 00 00 	movabs $0x8067dc,%rdx
  800ca2:	00 00 00 
  800ca5:	be 2c 01 00 00       	mov    $0x12c,%esi
  800caa:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800cb1:	00 00 00 
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  800cc0:	00 00 00 
  800cc3:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc6:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800cca:	75 14                	jne    800ce0 <umain+0x193>
		interactive = iscons(0);
  800ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd1:	48 b8 38 0f 80 00 00 	movabs $0x800f38,%rax
  800cd8:	00 00 00 
  800cdb:	ff d0                	callq  *%rax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce4:	74 0c                	je     800cf2 <umain+0x1a5>
  800ce6:	48 b8 f1 67 80 00 00 	movabs $0x8067f1,%rax
  800ced:	00 00 00 
  800cf0:	eb 05                	jmp    800cf7 <umain+0x1aa>
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf7:	48 89 c7             	mov    %rax,%rdi
  800cfa:	48 b8 e4 1f 80 00 00 	movabs $0x801fe4,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d0f:	75 37                	jne    800d48 <umain+0x1fb>
			if (debug)
  800d11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d18:	00 00 00 
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	74 1b                	je     800d3c <umain+0x1ef>
				cprintf("EXITING\n");
  800d21:	48 bf f4 67 80 00 00 	movabs $0x8067f4,%rdi
  800d28:	00 00 00 
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800d37:	00 00 00 
  800d3a:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3c:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800d43:	00 00 00 
  800d46:	ff d0                	callq  *%rax
		}
		if(strcmp(buf, "quit")==0)
  800d48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4c:	48 be fd 67 80 00 00 	movabs $0x8067fd,%rsi
  800d53:	00 00 00 
  800d56:	48 89 c7             	mov    %rax,%rdi
  800d59:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	callq  *%rax
  800d65:	85 c0                	test   %eax,%eax
  800d67:	75 0c                	jne    800d75 <umain+0x228>
			exit();
  800d69:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800d70:	00 00 00 
  800d73:	ff d0                	callq  *%rax
		if (debug)
  800d75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d7c:	00 00 00 
  800d7f:	8b 00                	mov    (%rax),%eax
  800d81:	85 c0                	test   %eax,%eax
  800d83:	74 22                	je     800da7 <umain+0x25a>
			cprintf("LINE: %s\n", buf);
  800d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d89:	48 89 c6             	mov    %rax,%rsi
  800d8c:	48 bf 02 68 80 00 00 	movabs $0x806802,%rdi
  800d93:	00 00 00 
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9b:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800da2:	00 00 00 
  800da5:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dab:	0f b6 00             	movzbl (%rax),%eax
  800dae:	3c 23                	cmp    $0x23,%al
  800db0:	0f 84 08 01 00 00    	je     800ebe <umain+0x371>
			continue;
		if (echocmds)
  800db6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800dba:	74 22                	je     800dde <umain+0x291>
			printf("# %s\n", buf);
  800dbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc0:	48 89 c6             	mov    %rax,%rsi
  800dc3:	48 bf 0c 68 80 00 00 	movabs $0x80680c,%rdi
  800dca:	00 00 00 
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd2:	48 ba f4 46 80 00 00 	movabs $0x8046f4,%rdx
  800dd9:	00 00 00 
  800ddc:	ff d2                	callq  *%rdx
		if (debug)
  800dde:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800de5:	00 00 00 
  800de8:	8b 00                	mov    (%rax),%eax
  800dea:	85 c0                	test   %eax,%eax
  800dec:	74 1b                	je     800e09 <umain+0x2bc>
			cprintf("BEFORE FORK\n");
  800dee:	48 bf 12 68 80 00 00 	movabs $0x806812,%rdi
  800df5:	00 00 00 
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfd:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800e04:	00 00 00 
  800e07:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800e09:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  800e10:	00 00 00 
  800e13:	ff d0                	callq  *%rax
  800e15:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e1c:	79 30                	jns    800e4e <umain+0x301>
			panic("fork: %e", r);
  800e1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e21:	89 c1                	mov    %eax,%ecx
  800e23:	48 ba b2 66 80 00 00 	movabs $0x8066b2,%rdx
  800e2a:	00 00 00 
  800e2d:	be 45 01 00 00       	mov    $0x145,%esi
  800e32:	48 bf d7 66 80 00 00 	movabs $0x8066d7,%rdi
  800e39:	00 00 00 
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e41:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  800e48:	00 00 00 
  800e4b:	41 ff d0             	callq  *%r8
		if (debug)
  800e4e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e55:	00 00 00 
  800e58:	8b 00                	mov    (%rax),%eax
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	74 20                	je     800e7e <umain+0x331>
			cprintf("FORK: %d\n", r);
  800e5e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e61:	89 c6                	mov    %eax,%esi
  800e63:	48 bf 1f 68 80 00 00 	movabs $0x80681f,%rdi
  800e6a:	00 00 00 
  800e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e72:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  800e79:	00 00 00 
  800e7c:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e82:	75 24                	jne    800ea8 <umain+0x35b>
			runcmd(buf);
  800e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e88:	48 89 c7             	mov    %rax,%rdi
  800e8b:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800e92:	00 00 00 
  800e95:	ff d0                	callq  *%rax
			exit();
  800e97:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	callq  *%rax
		} else
			wait(r);
	}
  800ea3:	e9 38 fe ff ff       	jmpq   800ce0 <umain+0x193>
			cprintf("FORK: %d\n", r);
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 88 61 80 00 00 	movabs $0x806188,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
	}
  800eb9:	e9 22 fe ff ff       	jmpq   800ce0 <umain+0x193>
		if(strcmp(buf, "quit")==0)
			exit();
		if (debug)
			cprintf("LINE: %s\n", buf);
		if (buf[0] == '#')
			continue;
  800ebe:	90                   	nop
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
	}
  800ebf:	e9 1c fe ff ff       	jmpq   800ce0 <umain+0x193>

0000000000800ec4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800ec4:	55                   	push   %rbp
  800ec5:	48 89 e5             	mov    %rsp,%rbp
  800ec8:	48 83 ec 20          	sub    $0x20,%rsp
  800ecc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ed2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ed5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ed9:	be 01 00 00 00       	mov    $0x1,%esi
  800ede:	48 89 c7             	mov    %rax,%rdi
  800ee1:	48 b8 a0 29 80 00 00 	movabs $0x8029a0,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   

0000000000800eef <getchar>:

int
getchar(void)
{
  800eef:	55                   	push   %rbp
  800ef0:	48 89 e5             	mov    %rsp,%rbp
  800ef3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ef7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800efb:	ba 01 00 00 00       	mov    $0x1,%edx
  800f00:	48 89 c6             	mov    %rax,%rsi
  800f03:	bf 00 00 00 00       	mov    $0x0,%edi
  800f08:	48 b8 94 3d 80 00 00 	movabs $0x803d94,%rax
  800f0f:	00 00 00 
  800f12:	ff d0                	callq  *%rax
  800f14:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800f17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f1b:	79 05                	jns    800f22 <getchar+0x33>
		return r;
  800f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f20:	eb 14                	jmp    800f36 <getchar+0x47>
	if (r < 1)
  800f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f26:	7f 07                	jg     800f2f <getchar+0x40>
		return -E_EOF;
  800f28:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f2d:	eb 07                	jmp    800f36 <getchar+0x47>
	return c;
  800f2f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f33:	0f b6 c0             	movzbl %al,%eax
}
  800f36:	c9                   	leaveq 
  800f37:	c3                   	retq   

0000000000800f38 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f38:	55                   	push   %rbp
  800f39:	48 89 e5             	mov    %rsp,%rbp
  800f3c:	48 83 ec 20          	sub    $0x20,%rsp
  800f40:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f43:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f4a:	48 89 d6             	mov    %rdx,%rsi
  800f4d:	89 c7                	mov    %eax,%edi
  800f4f:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
  800f5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f62:	79 05                	jns    800f69 <iscons+0x31>
		return r;
  800f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f67:	eb 1a                	jmp    800f83 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	8b 10                	mov    (%rax),%edx
  800f6f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800f76:	00 00 00 
  800f79:	8b 00                	mov    (%rax),%eax
  800f7b:	39 c2                	cmp    %eax,%edx
  800f7d:	0f 94 c0             	sete   %al
  800f80:	0f b6 c0             	movzbl %al,%eax
}
  800f83:	c9                   	leaveq 
  800f84:	c3                   	retq   

0000000000800f85 <opencons>:

int
opencons(void)
{
  800f85:	55                   	push   %rbp
  800f86:	48 89 e5             	mov    %rsp,%rbp
  800f89:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa7:	79 05                	jns    800fae <opencons+0x29>
		return r;
  800fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fac:	eb 5b                	jmp    801009 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb2:	ba 07 04 00 00       	mov    $0x407,%edx
  800fb7:	48 89 c6             	mov    %rax,%rsi
  800fba:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbf:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  800fc6:	00 00 00 
  800fc9:	ff d0                	callq  *%rax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd2:	79 05                	jns    800fd9 <opencons+0x54>
		return r;
  800fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd7:	eb 30                	jmp    801009 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  800fe4:	00 00 00 
  800fe7:	8b 12                	mov    (%rdx),%edx
  800fe9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	48 89 c7             	mov    %rax,%rdi
  800ffd:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 30          	sub    $0x30,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80101f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801024:	75 13                	jne    801039 <devcons_read+0x2e>
		return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
  80102b:	eb 49                	jmp    801076 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80102d:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  801034:	00 00 00 
  801037:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801039:	48 b8 ea 29 80 00 00 	movabs $0x8029ea,%rax
  801040:	00 00 00 
  801043:	ff d0                	callq  *%rax
  801045:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801048:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80104c:	74 df                	je     80102d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80104e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801052:	79 05                	jns    801059 <devcons_read+0x4e>
		return c;
  801054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801057:	eb 1d                	jmp    801076 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  801059:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80105d:	75 07                	jne    801066 <devcons_read+0x5b>
		return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
  801064:	eb 10                	jmp    801076 <devcons_read+0x6b>
	*(char*)vbuf = c;
  801066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106f:	88 10                	mov    %dl,(%rax)
	return 1;
  801071:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801076:	c9                   	leaveq 
  801077:	c3                   	retq   

0000000000801078 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801083:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80108a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801091:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80109f:	eb 77                	jmp    801118 <devcons_write+0xa0>
		m = n - tot;
  8010a1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8010a8:	89 c2                	mov    %eax,%edx
  8010aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	29 c1                	sub    %eax,%ecx
  8010b1:	89 c8                	mov    %ecx,%eax
  8010b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8010b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010b9:	83 f8 7f             	cmp    $0x7f,%eax
  8010bc:	76 07                	jbe    8010c5 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8010be:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8010c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c8:	48 63 d0             	movslq %eax,%rdx
  8010cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ce:	48 98                	cltq   
  8010d0:	48 89 c1             	mov    %rax,%rcx
  8010d3:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8010da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010e1:	48 89 ce             	mov    %rcx,%rsi
  8010e4:	48 89 c7             	mov    %rax,%rdi
  8010e7:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010f6:	48 63 d0             	movslq %eax,%rdx
  8010f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 a0 29 80 00 00 	movabs $0x8029a0,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801115:	01 45 fc             	add    %eax,-0x4(%rbp)
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 98                	cltq   
  80111d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801124:	0f 82 77 ff ff ff    	jb     8010a1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 08          	sub    $0x8,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801156:	48 be 2e 68 80 00 00 	movabs $0x80682e,%rsi
  80115d:	00 00 00 
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   
	...

0000000000801178 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801178:	55                   	push   %rbp
  801179:	48 89 e5             	mov    %rsp,%rbp
  80117c:	48 83 ec 10          	sub    $0x10,%rsp
  801180:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801183:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  801187:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80118e:	00 00 00 
  801191:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  801198:	48 b8 6c 2a 80 00 00 	movabs $0x802a6c,%rax
  80119f:	00 00 00 
  8011a2:	ff d0                	callq  *%rax
  8011a4:	48 98                	cltq   
  8011a6:	48 89 c2             	mov    %rax,%rdx
  8011a9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8011af:	48 89 d0             	mov    %rdx,%rax
  8011b2:	48 c1 e0 02          	shl    $0x2,%rax
  8011b6:	48 01 d0             	add    %rdx,%rax
  8011b9:	48 01 c0             	add    %rax,%rax
  8011bc:	48 01 d0             	add    %rdx,%rax
  8011bf:	48 c1 e0 05          	shl    $0x5,%rax
  8011c3:	48 89 c2             	mov    %rax,%rdx
  8011c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8011cd:	00 00 00 
  8011d0:	48 01 c2             	add    %rax,%rdx
  8011d3:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8011da:	00 00 00 
  8011dd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011e4:	7e 14                	jle    8011fa <libmain+0x82>
		binaryname = argv[0];
  8011e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ea:	48 8b 10             	mov    (%rax),%rdx
  8011ed:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8011f4:	00 00 00 
  8011f7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801201:	48 89 d6             	mov    %rdx,%rsi
  801204:	89 c7                	mov    %eax,%edi
  801206:	48 b8 4d 0b 80 00 00 	movabs $0x800b4d,%rax
  80120d:	00 00 00 
  801210:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  801212:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  801219:	00 00 00 
  80121c:	ff d0                	callq  *%rax
}
  80121e:	c9                   	leaveq 
  80121f:	c3                   	retq   

0000000000801220 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801220:	55                   	push   %rbp
  801221:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  801224:	48 b8 bd 3b 80 00 00 	movabs $0x803bbd,%rax
  80122b:	00 00 00 
  80122e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801230:	bf 00 00 00 00       	mov    $0x0,%edi
  801235:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  80123c:	00 00 00 
  80123f:	ff d0                	callq  *%rax
}
  801241:	5d                   	pop    %rbp
  801242:	c3                   	retq   
	...

0000000000801244 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	53                   	push   %rbx
  801249:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801250:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801257:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80125d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801264:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80126b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801272:	84 c0                	test   %al,%al
  801274:	74 23                	je     801299 <_panic+0x55>
  801276:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80127d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801281:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801285:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801289:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80128d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801291:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801295:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801299:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012a0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8012a7:	00 00 00 
  8012aa:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8012b1:	00 00 00 
  8012b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012b8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8012bf:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8012c6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012cd:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012d4:	00 00 00 
  8012d7:	48 8b 18             	mov    (%rax),%rbx
  8012da:	48 b8 6c 2a 80 00 00 	movabs $0x802a6c,%rax
  8012e1:	00 00 00 
  8012e4:	ff d0                	callq  *%rax
  8012e6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012ec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012f3:	41 89 c8             	mov    %ecx,%r8d
  8012f6:	48 89 d1             	mov    %rdx,%rcx
  8012f9:	48 89 da             	mov    %rbx,%rdx
  8012fc:	89 c6                	mov    %eax,%esi
  8012fe:	48 bf 40 68 80 00 00 	movabs $0x806840,%rdi
  801305:	00 00 00 
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
  80130d:	49 b9 7f 14 80 00 00 	movabs $0x80147f,%r9
  801314:	00 00 00 
  801317:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80131a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801321:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801328:	48 89 d6             	mov    %rdx,%rsi
  80132b:	48 89 c7             	mov    %rax,%rdi
  80132e:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  801335:	00 00 00 
  801338:	ff d0                	callq  *%rax
	cprintf("\n");
  80133a:	48 bf 63 68 80 00 00 	movabs $0x806863,%rdi
  801341:	00 00 00 
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  801350:	00 00 00 
  801353:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801355:	cc                   	int3   
  801356:	eb fd                	jmp    801355 <_panic+0x111>

0000000000801358 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	48 83 ec 10          	sub    $0x10,%rsp
  801360:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801363:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	8b 00                	mov    (%rax),%eax
  80136d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801370:	89 d6                	mov    %edx,%esi
  801372:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801376:	48 63 d0             	movslq %eax,%rdx
  801379:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80137e:	8d 50 01             	lea    0x1(%rax),%edx
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  801387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138b:	8b 00                	mov    (%rax),%eax
  80138d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801392:	75 2c                	jne    8013c0 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  801394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801398:	8b 00                	mov    (%rax),%eax
  80139a:	48 98                	cltq   
  80139c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013a0:	48 83 c2 08          	add    $0x8,%rdx
  8013a4:	48 89 c6             	mov    %rax,%rsi
  8013a7:	48 89 d7             	mov    %rdx,%rdi
  8013aa:	48 b8 a0 29 80 00 00 	movabs $0x8029a0,%rax
  8013b1:	00 00 00 
  8013b4:	ff d0                	callq  *%rax
        b->idx = 0;
  8013b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8013c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c4:	8b 40 04             	mov    0x4(%rax),%eax
  8013c7:	8d 50 01             	lea    0x1(%rax),%edx
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013de:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013e5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8013ec:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013f3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013fa:	48 8b 0a             	mov    (%rdx),%rcx
  8013fd:	48 89 08             	mov    %rcx,(%rax)
  801400:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801404:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801408:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80140c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801417:	00 00 00 
    b.cnt = 0;
  80141a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801421:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801424:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80142b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801432:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801439:	48 89 c6             	mov    %rax,%rsi
  80143c:	48 bf 58 13 80 00 00 	movabs $0x801358,%rdi
  801443:	00 00 00 
  801446:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  80144d:	00 00 00 
  801450:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801452:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801458:	48 98                	cltq   
  80145a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801461:	48 83 c2 08          	add    $0x8,%rdx
  801465:	48 89 c6             	mov    %rax,%rsi
  801468:	48 89 d7             	mov    %rdx,%rdi
  80146b:	48 b8 a0 29 80 00 00 	movabs $0x8029a0,%rax
  801472:	00 00 00 
  801475:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801477:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80147d:	c9                   	leaveq 
  80147e:	c3                   	retq   

000000000080147f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80147f:	55                   	push   %rbp
  801480:	48 89 e5             	mov    %rsp,%rbp
  801483:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80148a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801491:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801498:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80149f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8014a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8014ad:	84 c0                	test   %al,%al
  8014af:	74 20                	je     8014d1 <cprintf+0x52>
  8014b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8014b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8014b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8014d8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014df:	00 00 00 
  8014e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014e9:	00 00 00 
  8014ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  801505:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80150c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801513:	48 8b 0a             	mov    (%rdx),%rcx
  801516:	48 89 08             	mov    %rcx,(%rax)
  801519:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80151d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801521:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801525:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801529:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801530:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801537:	48 89 d6             	mov    %rdx,%rsi
  80153a:	48 89 c7             	mov    %rax,%rdi
  80153d:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  801544:	00 00 00 
  801547:	ff d0                	callq  *%rax
  801549:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80154f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801555:	c9                   	leaveq 
  801556:	c3                   	retq   
	...

0000000000801558 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	48 83 ec 30          	sub    $0x30,%rsp
  801560:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801564:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801568:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80156c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80156f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801573:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801577:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80157a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80157e:	77 52                	ja     8015d2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801580:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801583:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801587:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80158a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80158e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	48 f7 75 d0          	divq   -0x30(%rbp)
  80159b:	48 89 c2             	mov    %rax,%rdx
  80159e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8015a1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015a4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8015a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ac:	41 89 f9             	mov    %edi,%r9d
  8015af:	48 89 c7             	mov    %rax,%rdi
  8015b2:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  8015b9:	00 00 00 
  8015bc:	ff d0                	callq  *%rax
  8015be:	eb 1c                	jmp    8015dc <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015c7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8015cb:	48 89 d6             	mov    %rdx,%rsi
  8015ce:	89 c7                	mov    %eax,%edi
  8015d0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015d2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8015d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8015da:	7f e4                	jg     8015c0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015dc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e8:	48 f7 f1             	div    %rcx
  8015eb:	48 89 d0             	mov    %rdx,%rax
  8015ee:	48 ba 70 6a 80 00 00 	movabs $0x806a70,%rdx
  8015f5:	00 00 00 
  8015f8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015fc:	0f be c0             	movsbl %al,%eax
  8015ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801603:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801607:	48 89 d6             	mov    %rdx,%rsi
  80160a:	89 c7                	mov    %eax,%edi
  80160c:	ff d1                	callq  *%rcx
}
  80160e:	c9                   	leaveq 
  80160f:	c3                   	retq   

0000000000801610 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801610:	55                   	push   %rbp
  801611:	48 89 e5             	mov    %rsp,%rbp
  801614:	48 83 ec 20          	sub    $0x20,%rsp
  801618:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80161c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80161f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801623:	7e 52                	jle    801677 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801629:	8b 00                	mov    (%rax),%eax
  80162b:	83 f8 30             	cmp    $0x30,%eax
  80162e:	73 24                	jae    801654 <getuint+0x44>
  801630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801634:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163c:	8b 00                	mov    (%rax),%eax
  80163e:	89 c0                	mov    %eax,%eax
  801640:	48 01 d0             	add    %rdx,%rax
  801643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801647:	8b 12                	mov    (%rdx),%edx
  801649:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80164c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801650:	89 0a                	mov    %ecx,(%rdx)
  801652:	eb 17                	jmp    80166b <getuint+0x5b>
  801654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801658:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80165c:	48 89 d0             	mov    %rdx,%rax
  80165f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801667:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80166b:	48 8b 00             	mov    (%rax),%rax
  80166e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801672:	e9 a3 00 00 00       	jmpq   80171a <getuint+0x10a>
	else if (lflag)
  801677:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80167b:	74 4f                	je     8016cc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80167d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801681:	8b 00                	mov    (%rax),%eax
  801683:	83 f8 30             	cmp    $0x30,%eax
  801686:	73 24                	jae    8016ac <getuint+0x9c>
  801688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801694:	8b 00                	mov    (%rax),%eax
  801696:	89 c0                	mov    %eax,%eax
  801698:	48 01 d0             	add    %rdx,%rax
  80169b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169f:	8b 12                	mov    (%rdx),%edx
  8016a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a8:	89 0a                	mov    %ecx,(%rdx)
  8016aa:	eb 17                	jmp    8016c3 <getuint+0xb3>
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016b4:	48 89 d0             	mov    %rdx,%rax
  8016b7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016bf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016c3:	48 8b 00             	mov    (%rax),%rax
  8016c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8016ca:	eb 4e                	jmp    80171a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8016cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d0:	8b 00                	mov    (%rax),%eax
  8016d2:	83 f8 30             	cmp    $0x30,%eax
  8016d5:	73 24                	jae    8016fb <getuint+0xeb>
  8016d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e3:	8b 00                	mov    (%rax),%eax
  8016e5:	89 c0                	mov    %eax,%eax
  8016e7:	48 01 d0             	add    %rdx,%rax
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	8b 12                	mov    (%rdx),%edx
  8016f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f7:	89 0a                	mov    %ecx,(%rdx)
  8016f9:	eb 17                	jmp    801712 <getuint+0x102>
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801703:	48 89 d0             	mov    %rdx,%rax
  801706:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80170a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801712:	8b 00                	mov    (%rax),%eax
  801714:	89 c0                	mov    %eax,%eax
  801716:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80171e:	c9                   	leaveq 
  80171f:	c3                   	retq   

0000000000801720 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	48 83 ec 20          	sub    $0x20,%rsp
  801728:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80172c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80172f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801733:	7e 52                	jle    801787 <getint+0x67>
		x=va_arg(*ap, long long);
  801735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801739:	8b 00                	mov    (%rax),%eax
  80173b:	83 f8 30             	cmp    $0x30,%eax
  80173e:	73 24                	jae    801764 <getint+0x44>
  801740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801744:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174c:	8b 00                	mov    (%rax),%eax
  80174e:	89 c0                	mov    %eax,%eax
  801750:	48 01 d0             	add    %rdx,%rax
  801753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801757:	8b 12                	mov    (%rdx),%edx
  801759:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80175c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801760:	89 0a                	mov    %ecx,(%rdx)
  801762:	eb 17                	jmp    80177b <getint+0x5b>
  801764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801768:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80176c:	48 89 d0             	mov    %rdx,%rax
  80176f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801777:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80177b:	48 8b 00             	mov    (%rax),%rax
  80177e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801782:	e9 a3 00 00 00       	jmpq   80182a <getint+0x10a>
	else if (lflag)
  801787:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80178b:	74 4f                	je     8017dc <getint+0xbc>
		x=va_arg(*ap, long);
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801791:	8b 00                	mov    (%rax),%eax
  801793:	83 f8 30             	cmp    $0x30,%eax
  801796:	73 24                	jae    8017bc <getint+0x9c>
  801798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a4:	8b 00                	mov    (%rax),%eax
  8017a6:	89 c0                	mov    %eax,%eax
  8017a8:	48 01 d0             	add    %rdx,%rax
  8017ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017af:	8b 12                	mov    (%rdx),%edx
  8017b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b8:	89 0a                	mov    %ecx,(%rdx)
  8017ba:	eb 17                	jmp    8017d3 <getint+0xb3>
  8017bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017c4:	48 89 d0             	mov    %rdx,%rax
  8017c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017d3:	48 8b 00             	mov    (%rax),%rax
  8017d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017da:	eb 4e                	jmp    80182a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e0:	8b 00                	mov    (%rax),%eax
  8017e2:	83 f8 30             	cmp    $0x30,%eax
  8017e5:	73 24                	jae    80180b <getint+0xeb>
  8017e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f3:	8b 00                	mov    (%rax),%eax
  8017f5:	89 c0                	mov    %eax,%eax
  8017f7:	48 01 d0             	add    %rdx,%rax
  8017fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fe:	8b 12                	mov    (%rdx),%edx
  801800:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801807:	89 0a                	mov    %ecx,(%rdx)
  801809:	eb 17                	jmp    801822 <getint+0x102>
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801813:	48 89 d0             	mov    %rdx,%rax
  801816:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80181a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80181e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801822:	8b 00                	mov    (%rax),%eax
  801824:	48 98                	cltq   
  801826:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80182a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80182e:	c9                   	leaveq 
  80182f:	c3                   	retq   

0000000000801830 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	41 54                	push   %r12
  801836:	53                   	push   %rbx
  801837:	48 83 ec 60          	sub    $0x60,%rsp
  80183b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80183f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801843:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801847:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80184b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80184f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801853:	48 8b 0a             	mov    (%rdx),%rcx
  801856:	48 89 08             	mov    %rcx,(%rax)
  801859:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80185d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801861:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801865:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801869:	eb 17                	jmp    801882 <vprintfmt+0x52>
			if (ch == '\0')
  80186b:	85 db                	test   %ebx,%ebx
  80186d:	0f 84 ea 04 00 00    	je     801d5d <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  801873:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801877:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80187b:	48 89 c6             	mov    %rax,%rsi
  80187e:	89 df                	mov    %ebx,%edi
  801880:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801882:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801886:	0f b6 00             	movzbl (%rax),%eax
  801889:	0f b6 d8             	movzbl %al,%ebx
  80188c:	83 fb 25             	cmp    $0x25,%ebx
  80188f:	0f 95 c0             	setne  %al
  801892:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801897:	84 c0                	test   %al,%al
  801899:	75 d0                	jne    80186b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80189b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80189f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8018a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8018ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8018b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8018bb:	eb 04                	jmp    8018c1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8018bd:	90                   	nop
  8018be:	eb 01                	jmp    8018c1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8018c0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018c5:	0f b6 00             	movzbl (%rax),%eax
  8018c8:	0f b6 d8             	movzbl %al,%ebx
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8018d2:	83 e8 23             	sub    $0x23,%eax
  8018d5:	83 f8 55             	cmp    $0x55,%eax
  8018d8:	0f 87 4b 04 00 00    	ja     801d29 <vprintfmt+0x4f9>
  8018de:	89 c0                	mov    %eax,%eax
  8018e0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018e7:	00 
  8018e8:	48 b8 98 6a 80 00 00 	movabs $0x806a98,%rax
  8018ef:	00 00 00 
  8018f2:	48 01 d0             	add    %rdx,%rax
  8018f5:	48 8b 00             	mov    (%rax),%rax
  8018f8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8018fa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018fe:	eb c1                	jmp    8018c1 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801900:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801904:	eb bb                	jmp    8018c1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801906:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80190d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801910:	89 d0                	mov    %edx,%eax
  801912:	c1 e0 02             	shl    $0x2,%eax
  801915:	01 d0                	add    %edx,%eax
  801917:	01 c0                	add    %eax,%eax
  801919:	01 d8                	add    %ebx,%eax
  80191b:	83 e8 30             	sub    $0x30,%eax
  80191e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801921:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80192b:	83 fb 2f             	cmp    $0x2f,%ebx
  80192e:	7e 63                	jle    801993 <vprintfmt+0x163>
  801930:	83 fb 39             	cmp    $0x39,%ebx
  801933:	7f 5e                	jg     801993 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801935:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80193a:	eb d1                	jmp    80190d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80193c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80193f:	83 f8 30             	cmp    $0x30,%eax
  801942:	73 17                	jae    80195b <vprintfmt+0x12b>
  801944:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801948:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80194b:	89 c0                	mov    %eax,%eax
  80194d:	48 01 d0             	add    %rdx,%rax
  801950:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801953:	83 c2 08             	add    $0x8,%edx
  801956:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801959:	eb 0f                	jmp    80196a <vprintfmt+0x13a>
  80195b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80195f:	48 89 d0             	mov    %rdx,%rax
  801962:	48 83 c2 08          	add    $0x8,%rdx
  801966:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80196a:	8b 00                	mov    (%rax),%eax
  80196c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80196f:	eb 23                	jmp    801994 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801971:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801975:	0f 89 42 ff ff ff    	jns    8018bd <vprintfmt+0x8d>
				width = 0;
  80197b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801982:	e9 36 ff ff ff       	jmpq   8018bd <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801987:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80198e:	e9 2e ff ff ff       	jmpq   8018c1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801993:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801994:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801998:	0f 89 22 ff ff ff    	jns    8018c0 <vprintfmt+0x90>
				width = precision, precision = -1;
  80199e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8019a1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8019a4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8019ab:	e9 10 ff ff ff       	jmpq   8018c0 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019b0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8019b4:	e9 08 ff ff ff       	jmpq   8018c1 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8019b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019bc:	83 f8 30             	cmp    $0x30,%eax
  8019bf:	73 17                	jae    8019d8 <vprintfmt+0x1a8>
  8019c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019c8:	89 c0                	mov    %eax,%eax
  8019ca:	48 01 d0             	add    %rdx,%rax
  8019cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019d0:	83 c2 08             	add    $0x8,%edx
  8019d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019d6:	eb 0f                	jmp    8019e7 <vprintfmt+0x1b7>
  8019d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019dc:	48 89 d0             	mov    %rdx,%rax
  8019df:	48 83 c2 08          	add    $0x8,%rdx
  8019e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019e7:	8b 00                	mov    (%rax),%eax
  8019e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8019ed:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8019f1:	48 89 d6             	mov    %rdx,%rsi
  8019f4:	89 c7                	mov    %eax,%edi
  8019f6:	ff d1                	callq  *%rcx
			break;
  8019f8:	e9 5a 03 00 00       	jmpq   801d57 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8019fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a00:	83 f8 30             	cmp    $0x30,%eax
  801a03:	73 17                	jae    801a1c <vprintfmt+0x1ec>
  801a05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a0c:	89 c0                	mov    %eax,%eax
  801a0e:	48 01 d0             	add    %rdx,%rax
  801a11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a14:	83 c2 08             	add    $0x8,%edx
  801a17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a1a:	eb 0f                	jmp    801a2b <vprintfmt+0x1fb>
  801a1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a20:	48 89 d0             	mov    %rdx,%rax
  801a23:	48 83 c2 08          	add    $0x8,%rdx
  801a27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a2b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801a2d:	85 db                	test   %ebx,%ebx
  801a2f:	79 02                	jns    801a33 <vprintfmt+0x203>
				err = -err;
  801a31:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a33:	83 fb 15             	cmp    $0x15,%ebx
  801a36:	7f 16                	jg     801a4e <vprintfmt+0x21e>
  801a38:	48 b8 c0 69 80 00 00 	movabs $0x8069c0,%rax
  801a3f:	00 00 00 
  801a42:	48 63 d3             	movslq %ebx,%rdx
  801a45:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a49:	4d 85 e4             	test   %r12,%r12
  801a4c:	75 2e                	jne    801a7c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  801a4e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a56:	89 d9                	mov    %ebx,%ecx
  801a58:	48 ba 81 6a 80 00 00 	movabs $0x806a81,%rdx
  801a5f:	00 00 00 
  801a62:	48 89 c7             	mov    %rax,%rdi
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	49 b8 67 1d 80 00 00 	movabs $0x801d67,%r8
  801a71:	00 00 00 
  801a74:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a77:	e9 db 02 00 00       	jmpq   801d57 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a7c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a84:	4c 89 e1             	mov    %r12,%rcx
  801a87:	48 ba 8a 6a 80 00 00 	movabs $0x806a8a,%rdx
  801a8e:	00 00 00 
  801a91:	48 89 c7             	mov    %rax,%rdi
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	49 b8 67 1d 80 00 00 	movabs $0x801d67,%r8
  801aa0:	00 00 00 
  801aa3:	41 ff d0             	callq  *%r8
			break;
  801aa6:	e9 ac 02 00 00       	jmpq   801d57 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801aab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801aae:	83 f8 30             	cmp    $0x30,%eax
  801ab1:	73 17                	jae    801aca <vprintfmt+0x29a>
  801ab3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801ab7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801aba:	89 c0                	mov    %eax,%eax
  801abc:	48 01 d0             	add    %rdx,%rax
  801abf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ac2:	83 c2 08             	add    $0x8,%edx
  801ac5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801ac8:	eb 0f                	jmp    801ad9 <vprintfmt+0x2a9>
  801aca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ace:	48 89 d0             	mov    %rdx,%rax
  801ad1:	48 83 c2 08          	add    $0x8,%rdx
  801ad5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ad9:	4c 8b 20             	mov    (%rax),%r12
  801adc:	4d 85 e4             	test   %r12,%r12
  801adf:	75 0a                	jne    801aeb <vprintfmt+0x2bb>
				p = "(null)";
  801ae1:	49 bc 8d 6a 80 00 00 	movabs $0x806a8d,%r12
  801ae8:	00 00 00 
			if (width > 0 && padc != '-')
  801aeb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801aef:	7e 7a                	jle    801b6b <vprintfmt+0x33b>
  801af1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801af5:	74 74                	je     801b6b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  801af7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801afa:	48 98                	cltq   
  801afc:	48 89 c6             	mov    %rax,%rsi
  801aff:	4c 89 e7             	mov    %r12,%rdi
  801b02:	48 b8 72 21 80 00 00 	movabs $0x802172,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
  801b0e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801b11:	eb 17                	jmp    801b2a <vprintfmt+0x2fa>
					putch(padc, putdat);
  801b13:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  801b17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b1b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  801b1f:	48 89 d6             	mov    %rdx,%rsi
  801b22:	89 c7                	mov    %eax,%edi
  801b24:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b26:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b2e:	7f e3                	jg     801b13 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b30:	eb 39                	jmp    801b6b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  801b32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b36:	74 1e                	je     801b56 <vprintfmt+0x326>
  801b38:	83 fb 1f             	cmp    $0x1f,%ebx
  801b3b:	7e 05                	jle    801b42 <vprintfmt+0x312>
  801b3d:	83 fb 7e             	cmp    $0x7e,%ebx
  801b40:	7e 14                	jle    801b56 <vprintfmt+0x326>
					putch('?', putdat);
  801b42:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b46:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b4a:	48 89 c6             	mov    %rax,%rsi
  801b4d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b52:	ff d2                	callq  *%rdx
  801b54:	eb 0f                	jmp    801b65 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801b56:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b5a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b5e:	48 89 c6             	mov    %rax,%rsi
  801b61:	89 df                	mov    %ebx,%edi
  801b63:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b65:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b69:	eb 01                	jmp    801b6c <vprintfmt+0x33c>
  801b6b:	90                   	nop
  801b6c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801b71:	0f be d8             	movsbl %al,%ebx
  801b74:	85 db                	test   %ebx,%ebx
  801b76:	0f 95 c0             	setne  %al
  801b79:	49 83 c4 01          	add    $0x1,%r12
  801b7d:	84 c0                	test   %al,%al
  801b7f:	74 28                	je     801ba9 <vprintfmt+0x379>
  801b81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b85:	78 ab                	js     801b32 <vprintfmt+0x302>
  801b87:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b8b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b8f:	79 a1                	jns    801b32 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b91:	eb 16                	jmp    801ba9 <vprintfmt+0x379>
				putch(' ', putdat);
  801b93:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801b97:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b9b:	48 89 c6             	mov    %rax,%rsi
  801b9e:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ba5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801ba9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801bad:	7f e4                	jg     801b93 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  801baf:	e9 a3 01 00 00       	jmpq   801d57 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801bb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bb8:	be 03 00 00 00       	mov    $0x3,%esi
  801bbd:	48 89 c7             	mov    %rax,%rdi
  801bc0:	48 b8 20 17 80 00 00 	movabs $0x801720,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd4:	48 85 c0             	test   %rax,%rax
  801bd7:	79 1d                	jns    801bf6 <vprintfmt+0x3c6>
				putch('-', putdat);
  801bd9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801bdd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801be1:	48 89 c6             	mov    %rax,%rsi
  801be4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801be9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  801beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bef:	48 f7 d8             	neg    %rax
  801bf2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bf6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bfd:	e9 e8 00 00 00       	jmpq   801cea <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801c02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c06:	be 03 00 00 00       	mov    $0x3,%esi
  801c0b:	48 89 c7             	mov    %rax,%rdi
  801c0e:	48 b8 10 16 80 00 00 	movabs $0x801610,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	callq  *%rax
  801c1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801c1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801c25:	e9 c0 00 00 00       	jmpq   801cea <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c2a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c2e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c32:	48 89 c6             	mov    %rax,%rsi
  801c35:	bf 58 00 00 00       	mov    $0x58,%edi
  801c3a:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801c3c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c40:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c44:	48 89 c6             	mov    %rax,%rsi
  801c47:	bf 58 00 00 00       	mov    $0x58,%edi
  801c4c:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801c4e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c56:	48 89 c6             	mov    %rax,%rsi
  801c59:	bf 58 00 00 00       	mov    $0x58,%edi
  801c5e:	ff d2                	callq  *%rdx
			break;
  801c60:	e9 f2 00 00 00       	jmpq   801d57 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801c65:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c69:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c6d:	48 89 c6             	mov    %rax,%rsi
  801c70:	bf 30 00 00 00       	mov    $0x30,%edi
  801c75:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801c77:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801c7b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c7f:	48 89 c6             	mov    %rax,%rsi
  801c82:	bf 78 00 00 00       	mov    $0x78,%edi
  801c87:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c8c:	83 f8 30             	cmp    $0x30,%eax
  801c8f:	73 17                	jae    801ca8 <vprintfmt+0x478>
  801c91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c98:	89 c0                	mov    %eax,%eax
  801c9a:	48 01 d0             	add    %rdx,%rax
  801c9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ca0:	83 c2 08             	add    $0x8,%edx
  801ca3:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ca6:	eb 0f                	jmp    801cb7 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801ca8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801cac:	48 89 d0             	mov    %rdx,%rax
  801caf:	48 83 c2 08          	add    $0x8,%rdx
  801cb3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801cb7:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801cbe:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801cc5:	eb 23                	jmp    801cea <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801cc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801ccb:	be 03 00 00 00       	mov    $0x3,%esi
  801cd0:	48 89 c7             	mov    %rax,%rdi
  801cd3:	48 b8 10 16 80 00 00 	movabs $0x801610,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
  801cdf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801ce3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cea:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cef:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801cf2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cf5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cf9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d01:	45 89 c1             	mov    %r8d,%r9d
  801d04:	41 89 f8             	mov    %edi,%r8d
  801d07:	48 89 c7             	mov    %rax,%rdi
  801d0a:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  801d11:	00 00 00 
  801d14:	ff d0                	callq  *%rax
			break;
  801d16:	eb 3f                	jmp    801d57 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d18:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801d1c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801d20:	48 89 c6             	mov    %rax,%rsi
  801d23:	89 df                	mov    %ebx,%edi
  801d25:	ff d2                	callq  *%rdx
			break;
  801d27:	eb 2e                	jmp    801d57 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d29:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801d2d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801d31:	48 89 c6             	mov    %rax,%rsi
  801d34:	bf 25 00 00 00       	mov    $0x25,%edi
  801d39:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d3b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d40:	eb 05                	jmp    801d47 <vprintfmt+0x517>
  801d42:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d47:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d4b:	48 83 e8 01          	sub    $0x1,%rax
  801d4f:	0f b6 00             	movzbl (%rax),%eax
  801d52:	3c 25                	cmp    $0x25,%al
  801d54:	75 ec                	jne    801d42 <vprintfmt+0x512>
				/* do nothing */;
			break;
  801d56:	90                   	nop
		}
	}
  801d57:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d58:	e9 25 fb ff ff       	jmpq   801882 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801d5d:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801d5e:	48 83 c4 60          	add    $0x60,%rsp
  801d62:	5b                   	pop    %rbx
  801d63:	41 5c                	pop    %r12
  801d65:	5d                   	pop    %rbp
  801d66:	c3                   	retq   

0000000000801d67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d67:	55                   	push   %rbp
  801d68:	48 89 e5             	mov    %rsp,%rbp
  801d6b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d72:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d79:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d95:	84 c0                	test   %al,%al
  801d97:	74 20                	je     801db9 <printfmt+0x52>
  801d99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801da1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801da5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801da9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801dad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801db1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801db5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801db9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801dc0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801dc7:	00 00 00 
  801dca:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801dd1:	00 00 00 
  801dd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801dd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801ddf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801de6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801ded:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801df4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801dfb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801e02:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801e09:	48 89 c7             	mov    %rax,%rdi
  801e0c:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	callq  *%rax
	va_end(ap);
}
  801e18:	c9                   	leaveq 
  801e19:	c3                   	retq   

0000000000801e1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
  801e1e:	48 83 ec 10          	sub    $0x10,%rsp
  801e22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2d:	8b 40 10             	mov    0x10(%rax),%eax
  801e30:	8d 50 01             	lea    0x1(%rax),%edx
  801e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e37:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3e:	48 8b 10             	mov    (%rax),%rdx
  801e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e45:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e49:	48 39 c2             	cmp    %rax,%rdx
  801e4c:	73 17                	jae    801e65 <sprintputch+0x4b>
		*b->buf++ = ch;
  801e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e52:	48 8b 00             	mov    (%rax),%rax
  801e55:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e58:	88 10                	mov    %dl,(%rax)
  801e5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e62:	48 89 10             	mov    %rdx,(%rax)
}
  801e65:	c9                   	leaveq 
  801e66:	c3                   	retq   

0000000000801e67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	48 83 ec 50          	sub    $0x50,%rsp
  801e6f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e73:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e7a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e82:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e86:	48 8b 0a             	mov    (%rdx),%rcx
  801e89:	48 89 08             	mov    %rcx,(%rax)
  801e8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ea0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801ea4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801ea7:	48 98                	cltq   
  801ea9:	48 83 e8 01          	sub    $0x1,%rax
  801ead:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801eb1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801eb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801ebc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801ec1:	74 06                	je     801ec9 <vsnprintf+0x62>
  801ec3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801ec7:	7f 07                	jg     801ed0 <vsnprintf+0x69>
		return -E_INVAL;
  801ec9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ece:	eb 2f                	jmp    801eff <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801ed0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801ed4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801ed8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801edc:	48 89 c6             	mov    %rax,%rsi
  801edf:	48 bf 1a 1e 80 00 00 	movabs $0x801e1a,%rdi
  801ee6:	00 00 00 
  801ee9:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801ef5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ef9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801efc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801eff:	c9                   	leaveq 
  801f00:	c3                   	retq   

0000000000801f01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f01:	55                   	push   %rbp
  801f02:	48 89 e5             	mov    %rsp,%rbp
  801f05:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801f0c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801f13:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801f19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801f20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801f27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801f2e:	84 c0                	test   %al,%al
  801f30:	74 20                	je     801f52 <snprintf+0x51>
  801f32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801f36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801f3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f52:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f59:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f60:	00 00 00 
  801f63:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f6a:	00 00 00 
  801f6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f71:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f7f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f86:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f8d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f94:	48 8b 0a             	mov    (%rdx),%rcx
  801f97:	48 89 08             	mov    %rcx,(%rax)
  801f9a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f9e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fa2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fa6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801faa:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801fb1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801fb8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801fbe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801fc5:	48 89 c7             	mov    %rax,%rdi
  801fc8:	48 b8 67 1e 80 00 00 	movabs $0x801e67,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax
  801fd4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801fda:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fe0:	c9                   	leaveq 
  801fe1:	c3                   	retq   
	...

0000000000801fe4 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fe4:	55                   	push   %rbp
  801fe5:	48 89 e5             	mov    %rsp,%rbp
  801fe8:	48 83 ec 20          	sub    $0x20,%rsp
  801fec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801ff0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ff5:	74 27                	je     80201e <readline+0x3a>
		fprintf(1, "%s", prompt);
  801ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffb:	48 89 c2             	mov    %rax,%rdx
  801ffe:	48 be 48 6d 80 00 00 	movabs $0x806d48,%rsi
  802005:	00 00 00 
  802008:	bf 01 00 00 00       	mov    $0x1,%edi
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
  802012:	48 b9 3c 46 80 00 00 	movabs $0x80463c,%rcx
  802019:	00 00 00 
  80201c:	ff d1                	callq  *%rcx
#endif

	i = 0;
  80201e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  802025:	bf 00 00 00 00       	mov    $0x0,%edi
  80202a:	48 b8 38 0f 80 00 00 	movabs $0x800f38,%rax
  802031:	00 00 00 
  802034:	ff d0                	callq  *%rax
  802036:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802039:	eb 01                	jmp    80203c <readline+0x58>
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
  80203b:	90                   	nop
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
  80203c:	48 b8 ef 0e 80 00 00 	movabs $0x800eef,%rax
  802043:	00 00 00 
  802046:	ff d0                	callq  *%rax
  802048:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  80204b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80204f:	79 30                	jns    802081 <readline+0x9d>
			if (c != -E_EOF)
  802051:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802055:	74 20                	je     802077 <readline+0x93>
				cprintf("read error: %e\n", c);
  802057:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205a:	89 c6                	mov    %eax,%esi
  80205c:	48 bf 4b 6d 80 00 00 	movabs $0x806d4b,%rdi
  802063:	00 00 00 
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	48 ba 7f 14 80 00 00 	movabs $0x80147f,%rdx
  802072:	00 00 00 
  802075:	ff d2                	callq  *%rdx
			return NULL;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
  80207c:	e9 c0 00 00 00       	jmpq   802141 <readline+0x15d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802081:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802085:	74 06                	je     80208d <readline+0xa9>
  802087:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80208b:	75 26                	jne    8020b3 <readline+0xcf>
  80208d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802091:	7e 20                	jle    8020b3 <readline+0xcf>
			if (echoing)
  802093:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802097:	74 11                	je     8020aa <readline+0xc6>
				cputchar('\b');
  802099:	bf 08 00 00 00       	mov    $0x8,%edi
  80209e:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
			i--;
  8020aa:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  8020ae:	e9 89 00 00 00       	jmpq   80213c <readline+0x158>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8020b3:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8020b7:	7e 3d                	jle    8020f6 <readline+0x112>
  8020b9:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8020c0:	7f 34                	jg     8020f6 <readline+0x112>
			if (echoing)
  8020c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c6:	74 11                	je     8020d9 <readline+0xf5>
				cputchar(c);
  8020c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020cb:	89 c7                	mov    %eax,%edi
  8020cd:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	callq  *%rax
			buf[i++] = c;
  8020d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020dc:	89 c1                	mov    %eax,%ecx
  8020de:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8020e5:	00 00 00 
  8020e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020eb:	48 98                	cltq   
  8020ed:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020f0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f4:	eb 46                	jmp    80213c <readline+0x158>
		} else if (c == '\n' || c == '\r') {
  8020f6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020fa:	74 0a                	je     802106 <readline+0x122>
  8020fc:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  802100:	0f 85 35 ff ff ff    	jne    80203b <readline+0x57>
			if (echoing)
  802106:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80210a:	74 11                	je     80211d <readline+0x139>
				cputchar('\n');
  80210c:	bf 0a 00 00 00       	mov    $0xa,%edi
  802111:	48 b8 c4 0e 80 00 00 	movabs $0x800ec4,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
			buf[i] = 0;
  80211d:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  802124:	00 00 00 
  802127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212a:	48 98                	cltq   
  80212c:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  802130:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802137:	00 00 00 
  80213a:	eb 05                	jmp    802141 <readline+0x15d>
		}
	}
  80213c:	e9 fa fe ff ff       	jmpq   80203b <readline+0x57>
}
  802141:	c9                   	leaveq 
  802142:	c3                   	retq   
	...

0000000000802144 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
  802148:	48 83 ec 18          	sub    $0x18,%rsp
  80214c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802157:	eb 09                	jmp    802162 <strlen+0x1e>
		n++;
  802159:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80215d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802162:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802166:	0f b6 00             	movzbl (%rax),%eax
  802169:	84 c0                	test   %al,%al
  80216b:	75 ec                	jne    802159 <strlen+0x15>
		n++;
	return n;
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802170:	c9                   	leaveq 
  802171:	c3                   	retq   

0000000000802172 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802172:	55                   	push   %rbp
  802173:	48 89 e5             	mov    %rsp,%rbp
  802176:	48 83 ec 20          	sub    $0x20,%rsp
  80217a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80217e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802189:	eb 0e                	jmp    802199 <strnlen+0x27>
		n++;
  80218b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80218f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802194:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802199:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80219e:	74 0b                	je     8021ab <strnlen+0x39>
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a4:	0f b6 00             	movzbl (%rax),%eax
  8021a7:	84 c0                	test   %al,%al
  8021a9:	75 e0                	jne    80218b <strnlen+0x19>
		n++;
	return n;
  8021ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021ae:	c9                   	leaveq 
  8021af:	c3                   	retq   

00000000008021b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8021b0:	55                   	push   %rbp
  8021b1:	48 89 e5             	mov    %rsp,%rbp
  8021b4:	48 83 ec 20          	sub    $0x20,%rsp
  8021b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8021c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8021c8:	90                   	nop
  8021c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021cd:	0f b6 10             	movzbl (%rax),%edx
  8021d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d4:	88 10                	mov    %dl,(%rax)
  8021d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021da:	0f b6 00             	movzbl (%rax),%eax
  8021dd:	84 c0                	test   %al,%al
  8021df:	0f 95 c0             	setne  %al
  8021e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8021e7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8021ec:	84 c0                	test   %al,%al
  8021ee:	75 d9                	jne    8021c9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021f4:	c9                   	leaveq 
  8021f5:	c3                   	retq   

00000000008021f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021f6:	55                   	push   %rbp
  8021f7:	48 89 e5             	mov    %rsp,%rbp
  8021fa:	48 83 ec 20          	sub    $0x20,%rsp
  8021fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220a:	48 89 c7             	mov    %rax,%rdi
  80220d:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221f:	48 98                	cltq   
  802221:	48 03 45 e8          	add    -0x18(%rbp),%rax
  802225:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802229:	48 89 d6             	mov    %rdx,%rsi
  80222c:	48 89 c7             	mov    %rax,%rdi
  80222f:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
	return dst;
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80223f:	c9                   	leaveq 
  802240:	c3                   	retq   

0000000000802241 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	48 83 ec 28          	sub    $0x28,%rsp
  802249:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80224d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802251:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802259:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80225d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802264:	00 
  802265:	eb 27                	jmp    80228e <strncpy+0x4d>
		*dst++ = *src;
  802267:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80226b:	0f b6 10             	movzbl (%rax),%edx
  80226e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802272:	88 10                	mov    %dl,(%rax)
  802274:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802279:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227d:	0f b6 00             	movzbl (%rax),%eax
  802280:	84 c0                	test   %al,%al
  802282:	74 05                	je     802289 <strncpy+0x48>
			src++;
  802284:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802289:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80228e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802292:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802296:	72 cf                	jb     802267 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80229c:	c9                   	leaveq 
  80229d:	c3                   	retq   

000000000080229e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80229e:	55                   	push   %rbp
  80229f:	48 89 e5             	mov    %rsp,%rbp
  8022a2:	48 83 ec 28          	sub    $0x28,%rsp
  8022a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8022b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8022ba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022bf:	74 37                	je     8022f8 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8022c1:	eb 17                	jmp    8022da <strlcpy+0x3c>
			*dst++ = *src++;
  8022c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c7:	0f b6 10             	movzbl (%rax),%edx
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	88 10                	mov    %dl,(%rax)
  8022d0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8022d5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022da:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8022df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022e4:	74 0b                	je     8022f1 <strlcpy+0x53>
  8022e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ea:	0f b6 00             	movzbl (%rax),%eax
  8022ed:	84 c0                	test   %al,%al
  8022ef:	75 d2                	jne    8022c3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802300:	48 89 d1             	mov    %rdx,%rcx
  802303:	48 29 c1             	sub    %rax,%rcx
  802306:	48 89 c8             	mov    %rcx,%rax
}
  802309:	c9                   	leaveq 
  80230a:	c3                   	retq   

000000000080230b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80230b:	55                   	push   %rbp
  80230c:	48 89 e5             	mov    %rsp,%rbp
  80230f:	48 83 ec 10          	sub    $0x10,%rsp
  802313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802317:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80231b:	eb 0a                	jmp    802327 <strcmp+0x1c>
		p++, q++;
  80231d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802322:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232b:	0f b6 00             	movzbl (%rax),%eax
  80232e:	84 c0                	test   %al,%al
  802330:	74 12                	je     802344 <strcmp+0x39>
  802332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802336:	0f b6 10             	movzbl (%rax),%edx
  802339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233d:	0f b6 00             	movzbl (%rax),%eax
  802340:	38 c2                	cmp    %al,%dl
  802342:	74 d9                	je     80231d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802348:	0f b6 00             	movzbl (%rax),%eax
  80234b:	0f b6 d0             	movzbl %al,%edx
  80234e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802352:	0f b6 00             	movzbl (%rax),%eax
  802355:	0f b6 c0             	movzbl %al,%eax
  802358:	89 d1                	mov    %edx,%ecx
  80235a:	29 c1                	sub    %eax,%ecx
  80235c:	89 c8                	mov    %ecx,%eax
}
  80235e:	c9                   	leaveq 
  80235f:	c3                   	retq   

0000000000802360 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
  802364:	48 83 ec 18          	sub    $0x18,%rsp
  802368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80236c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802370:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802374:	eb 0f                	jmp    802385 <strncmp+0x25>
		n--, p++, q++;
  802376:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80237b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802380:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802385:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80238a:	74 1d                	je     8023a9 <strncmp+0x49>
  80238c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802390:	0f b6 00             	movzbl (%rax),%eax
  802393:	84 c0                	test   %al,%al
  802395:	74 12                	je     8023a9 <strncmp+0x49>
  802397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239b:	0f b6 10             	movzbl (%rax),%edx
  80239e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a2:	0f b6 00             	movzbl (%rax),%eax
  8023a5:	38 c2                	cmp    %al,%dl
  8023a7:	74 cd                	je     802376 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8023a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023ae:	75 07                	jne    8023b7 <strncmp+0x57>
		return 0;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	eb 1a                	jmp    8023d1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023bb:	0f b6 00             	movzbl (%rax),%eax
  8023be:	0f b6 d0             	movzbl %al,%edx
  8023c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c5:	0f b6 00             	movzbl (%rax),%eax
  8023c8:	0f b6 c0             	movzbl %al,%eax
  8023cb:	89 d1                	mov    %edx,%ecx
  8023cd:	29 c1                	sub    %eax,%ecx
  8023cf:	89 c8                	mov    %ecx,%eax
}
  8023d1:	c9                   	leaveq 
  8023d2:	c3                   	retq   

00000000008023d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
  8023d7:	48 83 ec 10          	sub    $0x10,%rsp
  8023db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023e4:	eb 17                	jmp    8023fd <strchr+0x2a>
		if (*s == c)
  8023e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ea:	0f b6 00             	movzbl (%rax),%eax
  8023ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023f0:	75 06                	jne    8023f8 <strchr+0x25>
			return (char *) s;
  8023f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f6:	eb 15                	jmp    80240d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802401:	0f b6 00             	movzbl (%rax),%eax
  802404:	84 c0                	test   %al,%al
  802406:	75 de                	jne    8023e6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240d:	c9                   	leaveq 
  80240e:	c3                   	retq   

000000000080240f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80240f:	55                   	push   %rbp
  802410:	48 89 e5             	mov    %rsp,%rbp
  802413:	48 83 ec 10          	sub    $0x10,%rsp
  802417:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80241b:	89 f0                	mov    %esi,%eax
  80241d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802420:	eb 11                	jmp    802433 <strfind+0x24>
		if (*s == c)
  802422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802426:	0f b6 00             	movzbl (%rax),%eax
  802429:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80242c:	74 12                	je     802440 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80242e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802437:	0f b6 00             	movzbl (%rax),%eax
  80243a:	84 c0                	test   %al,%al
  80243c:	75 e4                	jne    802422 <strfind+0x13>
  80243e:	eb 01                	jmp    802441 <strfind+0x32>
		if (*s == c)
			break;
  802440:	90                   	nop
	return (char *) s;
  802441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 18          	sub    $0x18,%rsp
  80244f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802453:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802456:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80245a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80245f:	75 06                	jne    802467 <memset+0x20>
		return v;
  802461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802465:	eb 69                	jmp    8024d0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246b:	83 e0 03             	and    $0x3,%eax
  80246e:	48 85 c0             	test   %rax,%rax
  802471:	75 48                	jne    8024bb <memset+0x74>
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	83 e0 03             	and    $0x3,%eax
  80247a:	48 85 c0             	test   %rax,%rax
  80247d:	75 3c                	jne    8024bb <memset+0x74>
		c &= 0xFF;
  80247f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802486:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802489:	89 c2                	mov    %eax,%edx
  80248b:	c1 e2 18             	shl    $0x18,%edx
  80248e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802491:	c1 e0 10             	shl    $0x10,%eax
  802494:	09 c2                	or     %eax,%edx
  802496:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802499:	c1 e0 08             	shl    $0x8,%eax
  80249c:	09 d0                	or     %edx,%eax
  80249e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8024a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a5:	48 89 c1             	mov    %rax,%rcx
  8024a8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8024ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024b3:	48 89 d7             	mov    %rdx,%rdi
  8024b6:	fc                   	cld    
  8024b7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8024b9:	eb 11                	jmp    8024cc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8024bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024c6:	48 89 d7             	mov    %rdx,%rdi
  8024c9:	fc                   	cld    
  8024ca:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8024cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024d0:	c9                   	leaveq 
  8024d1:	c3                   	retq   

00000000008024d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024d2:	55                   	push   %rbp
  8024d3:	48 89 e5             	mov    %rsp,%rbp
  8024d6:	48 83 ec 28          	sub    $0x28,%rsp
  8024da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024fe:	0f 83 88 00 00 00    	jae    80258c <memmove+0xba>
  802504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802508:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80250c:	48 01 d0             	add    %rdx,%rax
  80250f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802513:	76 77                	jbe    80258c <memmove+0xba>
		s += n;
  802515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802519:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80251d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802521:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802529:	83 e0 03             	and    $0x3,%eax
  80252c:	48 85 c0             	test   %rax,%rax
  80252f:	75 3b                	jne    80256c <memmove+0x9a>
  802531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802535:	83 e0 03             	and    $0x3,%eax
  802538:	48 85 c0             	test   %rax,%rax
  80253b:	75 2f                	jne    80256c <memmove+0x9a>
  80253d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802541:	83 e0 03             	and    $0x3,%eax
  802544:	48 85 c0             	test   %rax,%rax
  802547:	75 23                	jne    80256c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254d:	48 83 e8 04          	sub    $0x4,%rax
  802551:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802555:	48 83 ea 04          	sub    $0x4,%rdx
  802559:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80255d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802561:	48 89 c7             	mov    %rax,%rdi
  802564:	48 89 d6             	mov    %rdx,%rsi
  802567:	fd                   	std    
  802568:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80256a:	eb 1d                	jmp    802589 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802578:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80257c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802580:	48 89 d7             	mov    %rdx,%rdi
  802583:	48 89 c1             	mov    %rax,%rcx
  802586:	fd                   	std    
  802587:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802589:	fc                   	cld    
  80258a:	eb 57                	jmp    8025e3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80258c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802590:	83 e0 03             	and    $0x3,%eax
  802593:	48 85 c0             	test   %rax,%rax
  802596:	75 36                	jne    8025ce <memmove+0xfc>
  802598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259c:	83 e0 03             	and    $0x3,%eax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	75 2a                	jne    8025ce <memmove+0xfc>
  8025a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a8:	83 e0 03             	and    $0x3,%eax
  8025ab:	48 85 c0             	test   %rax,%rax
  8025ae:	75 1e                	jne    8025ce <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8025b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b4:	48 89 c1             	mov    %rax,%rcx
  8025b7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	fc                   	cld    
  8025ca:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8025cc:	eb 15                	jmp    8025e3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8025ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8025da:	48 89 c7             	mov    %rax,%rdi
  8025dd:	48 89 d6             	mov    %rdx,%rsi
  8025e0:	fc                   	cld    
  8025e1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8025e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025e7:	c9                   	leaveq 
  8025e8:	c3                   	retq   

00000000008025e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025e9:	55                   	push   %rbp
  8025ea:	48 89 e5             	mov    %rsp,%rbp
  8025ed:	48 83 ec 18          	sub    $0x18,%rsp
  8025f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802601:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802609:	48 89 ce             	mov    %rcx,%rsi
  80260c:	48 89 c7             	mov    %rax,%rdi
  80260f:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
}
  80261b:	c9                   	leaveq 
  80261c:	c3                   	retq   

000000000080261d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80261d:	55                   	push   %rbp
  80261e:	48 89 e5             	mov    %rsp,%rbp
  802621:	48 83 ec 28          	sub    $0x28,%rsp
  802625:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802629:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80262d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802635:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802639:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802641:	eb 38                	jmp    80267b <memcmp+0x5e>
		if (*s1 != *s2)
  802643:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802647:	0f b6 10             	movzbl (%rax),%edx
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	0f b6 00             	movzbl (%rax),%eax
  802651:	38 c2                	cmp    %al,%dl
  802653:	74 1c                	je     802671 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  802655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802659:	0f b6 00             	movzbl (%rax),%eax
  80265c:	0f b6 d0             	movzbl %al,%edx
  80265f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802663:	0f b6 00             	movzbl (%rax),%eax
  802666:	0f b6 c0             	movzbl %al,%eax
  802669:	89 d1                	mov    %edx,%ecx
  80266b:	29 c1                	sub    %eax,%ecx
  80266d:	89 c8                	mov    %ecx,%eax
  80266f:	eb 20                	jmp    802691 <memcmp+0x74>
		s1++, s2++;
  802671:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802676:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80267b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802680:	0f 95 c0             	setne  %al
  802683:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802688:	84 c0                	test   %al,%al
  80268a:	75 b7                	jne    802643 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802691:	c9                   	leaveq 
  802692:	c3                   	retq   

0000000000802693 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802693:	55                   	push   %rbp
  802694:	48 89 e5             	mov    %rsp,%rbp
  802697:	48 83 ec 28          	sub    $0x28,%rsp
  80269b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80269f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8026a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8026a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026ae:	48 01 d0             	add    %rdx,%rax
  8026b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8026b5:	eb 13                	jmp    8026ca <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8026b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bb:	0f b6 10             	movzbl (%rax),%edx
  8026be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8026c1:	38 c2                	cmp    %al,%dl
  8026c3:	74 11                	je     8026d6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8026c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8026ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ce:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8026d2:	72 e3                	jb     8026b7 <memfind+0x24>
  8026d4:	eb 01                	jmp    8026d7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8026d6:	90                   	nop
	return (void *) s;
  8026d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8026db:	c9                   	leaveq 
  8026dc:	c3                   	retq   

00000000008026dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8026dd:	55                   	push   %rbp
  8026de:	48 89 e5             	mov    %rsp,%rbp
  8026e1:	48 83 ec 38          	sub    $0x38,%rsp
  8026e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026ed:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026f7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026fe:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026ff:	eb 05                	jmp    802706 <strtol+0x29>
		s++;
  802701:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80270a:	0f b6 00             	movzbl (%rax),%eax
  80270d:	3c 20                	cmp    $0x20,%al
  80270f:	74 f0                	je     802701 <strtol+0x24>
  802711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802715:	0f b6 00             	movzbl (%rax),%eax
  802718:	3c 09                	cmp    $0x9,%al
  80271a:	74 e5                	je     802701 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80271c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802720:	0f b6 00             	movzbl (%rax),%eax
  802723:	3c 2b                	cmp    $0x2b,%al
  802725:	75 07                	jne    80272e <strtol+0x51>
		s++;
  802727:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80272c:	eb 17                	jmp    802745 <strtol+0x68>
	else if (*s == '-')
  80272e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802732:	0f b6 00             	movzbl (%rax),%eax
  802735:	3c 2d                	cmp    $0x2d,%al
  802737:	75 0c                	jne    802745 <strtol+0x68>
		s++, neg = 1;
  802739:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80273e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802745:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802749:	74 06                	je     802751 <strtol+0x74>
  80274b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80274f:	75 28                	jne    802779 <strtol+0x9c>
  802751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802755:	0f b6 00             	movzbl (%rax),%eax
  802758:	3c 30                	cmp    $0x30,%al
  80275a:	75 1d                	jne    802779 <strtol+0x9c>
  80275c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802760:	48 83 c0 01          	add    $0x1,%rax
  802764:	0f b6 00             	movzbl (%rax),%eax
  802767:	3c 78                	cmp    $0x78,%al
  802769:	75 0e                	jne    802779 <strtol+0x9c>
		s += 2, base = 16;
  80276b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802770:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802777:	eb 2c                	jmp    8027a5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802779:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80277d:	75 19                	jne    802798 <strtol+0xbb>
  80277f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802783:	0f b6 00             	movzbl (%rax),%eax
  802786:	3c 30                	cmp    $0x30,%al
  802788:	75 0e                	jne    802798 <strtol+0xbb>
		s++, base = 8;
  80278a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80278f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802796:	eb 0d                	jmp    8027a5 <strtol+0xc8>
	else if (base == 0)
  802798:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80279c:	75 07                	jne    8027a5 <strtol+0xc8>
		base = 10;
  80279e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	0f b6 00             	movzbl (%rax),%eax
  8027ac:	3c 2f                	cmp    $0x2f,%al
  8027ae:	7e 1d                	jle    8027cd <strtol+0xf0>
  8027b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b4:	0f b6 00             	movzbl (%rax),%eax
  8027b7:	3c 39                	cmp    $0x39,%al
  8027b9:	7f 12                	jg     8027cd <strtol+0xf0>
			dig = *s - '0';
  8027bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bf:	0f b6 00             	movzbl (%rax),%eax
  8027c2:	0f be c0             	movsbl %al,%eax
  8027c5:	83 e8 30             	sub    $0x30,%eax
  8027c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027cb:	eb 4e                	jmp    80281b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8027cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d1:	0f b6 00             	movzbl (%rax),%eax
  8027d4:	3c 60                	cmp    $0x60,%al
  8027d6:	7e 1d                	jle    8027f5 <strtol+0x118>
  8027d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027dc:	0f b6 00             	movzbl (%rax),%eax
  8027df:	3c 7a                	cmp    $0x7a,%al
  8027e1:	7f 12                	jg     8027f5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8027e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e7:	0f b6 00             	movzbl (%rax),%eax
  8027ea:	0f be c0             	movsbl %al,%eax
  8027ed:	83 e8 57             	sub    $0x57,%eax
  8027f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027f3:	eb 26                	jmp    80281b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f9:	0f b6 00             	movzbl (%rax),%eax
  8027fc:	3c 40                	cmp    $0x40,%al
  8027fe:	7e 47                	jle    802847 <strtol+0x16a>
  802800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802804:	0f b6 00             	movzbl (%rax),%eax
  802807:	3c 5a                	cmp    $0x5a,%al
  802809:	7f 3c                	jg     802847 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80280b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280f:	0f b6 00             	movzbl (%rax),%eax
  802812:	0f be c0             	movsbl %al,%eax
  802815:	83 e8 37             	sub    $0x37,%eax
  802818:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80281b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80281e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802821:	7d 23                	jge    802846 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  802823:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802828:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80282b:	48 98                	cltq   
  80282d:	48 89 c2             	mov    %rax,%rdx
  802830:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  802835:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802838:	48 98                	cltq   
  80283a:	48 01 d0             	add    %rdx,%rax
  80283d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802841:	e9 5f ff ff ff       	jmpq   8027a5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802846:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802847:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80284c:	74 0b                	je     802859 <strtol+0x17c>
		*endptr = (char *) s;
  80284e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802852:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802856:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285d:	74 09                	je     802868 <strtol+0x18b>
  80285f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802863:	48 f7 d8             	neg    %rax
  802866:	eb 04                	jmp    80286c <strtol+0x18f>
  802868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80286c:	c9                   	leaveq 
  80286d:	c3                   	retq   

000000000080286e <strstr>:

char * strstr(const char *in, const char *str)
{
  80286e:	55                   	push   %rbp
  80286f:	48 89 e5             	mov    %rsp,%rbp
  802872:	48 83 ec 30          	sub    $0x30,%rsp
  802876:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80287a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80287e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802882:	0f b6 00             	movzbl (%rax),%eax
  802885:	88 45 ff             	mov    %al,-0x1(%rbp)
  802888:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  80288d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802891:	75 06                	jne    802899 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  802893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802897:	eb 68                	jmp    802901 <strstr+0x93>

	len = strlen(str);
  802899:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80289d:	48 89 c7             	mov    %rax,%rdi
  8028a0:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	callq  *%rax
  8028ac:	48 98                	cltq   
  8028ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8028b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b6:	0f b6 00             	movzbl (%rax),%eax
  8028b9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8028bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  8028c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8028c5:	75 07                	jne    8028ce <strstr+0x60>
				return (char *) 0;
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	eb 33                	jmp    802901 <strstr+0x93>
		} while (sc != c);
  8028ce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8028d2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8028d5:	75 db                	jne    8028b2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8028d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e3:	48 89 ce             	mov    %rcx,%rsi
  8028e6:	48 89 c7             	mov    %rax,%rdi
  8028e9:	48 b8 60 23 80 00 00 	movabs $0x802360,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	75 b9                	jne    8028b2 <strstr+0x44>

	return (char *) (in - 1);
  8028f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fd:	48 83 e8 01          	sub    $0x1,%rax
}
  802901:	c9                   	leaveq 
  802902:	c3                   	retq   
	...

0000000000802904 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802904:	55                   	push   %rbp
  802905:	48 89 e5             	mov    %rsp,%rbp
  802908:	53                   	push   %rbx
  802909:	48 83 ec 58          	sub    $0x58,%rsp
  80290d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802910:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802913:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802917:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80291b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80291f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802923:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802926:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802929:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80292d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802931:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802935:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802939:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80293d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802940:	4c 89 c3             	mov    %r8,%rbx
  802943:	cd 30                	int    $0x30
  802945:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  802949:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80294d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802951:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802955:	74 3e                	je     802995 <syscall+0x91>
  802957:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80295c:	7e 37                	jle    802995 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80295e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802962:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802965:	49 89 d0             	mov    %rdx,%r8
  802968:	89 c1                	mov    %eax,%ecx
  80296a:	48 ba 5b 6d 80 00 00 	movabs $0x806d5b,%rdx
  802971:	00 00 00 
  802974:	be 23 00 00 00       	mov    $0x23,%esi
  802979:	48 bf 78 6d 80 00 00 	movabs $0x806d78,%rdi
  802980:	00 00 00 
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
  802988:	49 b9 44 12 80 00 00 	movabs $0x801244,%r9
  80298f:	00 00 00 
  802992:	41 ff d1             	callq  *%r9

	return ret;
  802995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802999:	48 83 c4 58          	add    $0x58,%rsp
  80299d:	5b                   	pop    %rbx
  80299e:	5d                   	pop    %rbp
  80299f:	c3                   	retq   

00000000008029a0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8029a0:	55                   	push   %rbp
  8029a1:	48 89 e5             	mov    %rsp,%rbp
  8029a4:	48 83 ec 20          	sub    $0x20,%rsp
  8029a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8029b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029bf:	00 
  8029c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029cc:	48 89 d1             	mov    %rdx,%rcx
  8029cf:	48 89 c2             	mov    %rax,%rdx
  8029d2:	be 00 00 00 00       	mov    $0x0,%esi
  8029d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029dc:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  8029e3:	00 00 00 
  8029e6:	ff d0                	callq  *%rax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029f9:	00 
  8029fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a10:	be 00 00 00 00       	mov    $0x0,%esi
  802a15:	bf 01 00 00 00       	mov    $0x1,%edi
  802a1a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
}
  802a26:	c9                   	leaveq 
  802a27:	c3                   	retq   

0000000000802a28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	48 83 ec 20          	sub    $0x20,%rsp
  802a30:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a36:	48 98                	cltq   
  802a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a3f:	00 
  802a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a51:	48 89 c2             	mov    %rax,%rdx
  802a54:	be 01 00 00 00       	mov    $0x1,%esi
  802a59:	bf 03 00 00 00       	mov    $0x3,%edi
  802a5e:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802a65:	00 00 00 
  802a68:	ff d0                	callq  *%rax
}
  802a6a:	c9                   	leaveq 
  802a6b:	c3                   	retq   

0000000000802a6c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a6c:	55                   	push   %rbp
  802a6d:	48 89 e5             	mov    %rsp,%rbp
  802a70:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a7b:	00 
  802a7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a88:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a92:	be 00 00 00 00       	mov    $0x0,%esi
  802a97:	bf 02 00 00 00       	mov    $0x2,%edi
  802a9c:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
}
  802aa8:	c9                   	leaveq 
  802aa9:	c3                   	retq   

0000000000802aaa <sys_yield>:

void
sys_yield(void)
{
  802aaa:	55                   	push   %rbp
  802aab:	48 89 e5             	mov    %rsp,%rbp
  802aae:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802ab2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ab9:	00 
  802aba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ac0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  802acb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad0:	be 00 00 00 00       	mov    $0x0,%esi
  802ad5:	bf 0b 00 00 00       	mov    $0xb,%edi
  802ada:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802ae1:	00 00 00 
  802ae4:	ff d0                	callq  *%rax
}
  802ae6:	c9                   	leaveq 
  802ae7:	c3                   	retq   

0000000000802ae8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 20          	sub    $0x20,%rsp
  802af0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802af3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802af7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802afa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802afd:	48 63 c8             	movslq %eax,%rcx
  802b00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	48 98                	cltq   
  802b09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b10:	00 
  802b11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b17:	49 89 c8             	mov    %rcx,%r8
  802b1a:	48 89 d1             	mov    %rdx,%rcx
  802b1d:	48 89 c2             	mov    %rax,%rdx
  802b20:	be 01 00 00 00       	mov    $0x1,%esi
  802b25:	bf 04 00 00 00       	mov    $0x4,%edi
  802b2a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
}
  802b36:	c9                   	leaveq 
  802b37:	c3                   	retq   

0000000000802b38 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802b38:	55                   	push   %rbp
  802b39:	48 89 e5             	mov    %rsp,%rbp
  802b3c:	48 83 ec 30          	sub    $0x30,%rsp
  802b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b47:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802b4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b4e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b55:	48 63 c8             	movslq %eax,%rcx
  802b58:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b5f:	48 63 f0             	movslq %eax,%rsi
  802b62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b69:	48 98                	cltq   
  802b6b:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b6f:	49 89 f9             	mov    %rdi,%r9
  802b72:	49 89 f0             	mov    %rsi,%r8
  802b75:	48 89 d1             	mov    %rdx,%rcx
  802b78:	48 89 c2             	mov    %rax,%rdx
  802b7b:	be 01 00 00 00       	mov    $0x1,%esi
  802b80:	bf 05 00 00 00       	mov    $0x5,%edi
  802b85:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
}
  802b91:	c9                   	leaveq 
  802b92:	c3                   	retq   

0000000000802b93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b93:	55                   	push   %rbp
  802b94:	48 89 e5             	mov    %rsp,%rbp
  802b97:	48 83 ec 20          	sub    $0x20,%rsp
  802b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	48 98                	cltq   
  802bab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bb2:	00 
  802bb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bbf:	48 89 d1             	mov    %rdx,%rcx
  802bc2:	48 89 c2             	mov    %rax,%rdx
  802bc5:	be 01 00 00 00       	mov    $0x1,%esi
  802bca:	bf 06 00 00 00       	mov    $0x6,%edi
  802bcf:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 20          	sub    $0x20,%rsp
  802be5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802be8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802beb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bee:	48 63 d0             	movslq %eax,%rdx
  802bf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf4:	48 98                	cltq   
  802bf6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bfd:	00 
  802bfe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c0a:	48 89 d1             	mov    %rdx,%rcx
  802c0d:	48 89 c2             	mov    %rax,%rdx
  802c10:	be 01 00 00 00       	mov    $0x1,%esi
  802c15:	bf 08 00 00 00       	mov    $0x8,%edi
  802c1a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
}
  802c26:	c9                   	leaveq 
  802c27:	c3                   	retq   

0000000000802c28 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 20          	sub    $0x20,%rsp
  802c30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802c37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3e:	48 98                	cltq   
  802c40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c47:	00 
  802c48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c54:	48 89 d1             	mov    %rdx,%rcx
  802c57:	48 89 c2             	mov    %rax,%rdx
  802c5a:	be 01 00 00 00       	mov    $0x1,%esi
  802c5f:	bf 09 00 00 00       	mov    $0x9,%edi
  802c64:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	callq  *%rax
}
  802c70:	c9                   	leaveq 
  802c71:	c3                   	retq   

0000000000802c72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c72:	55                   	push   %rbp
  802c73:	48 89 e5             	mov    %rsp,%rbp
  802c76:	48 83 ec 20          	sub    $0x20,%rsp
  802c7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c88:	48 98                	cltq   
  802c8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c91:	00 
  802c92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c9e:	48 89 d1             	mov    %rdx,%rcx
  802ca1:	48 89 c2             	mov    %rax,%rdx
  802ca4:	be 01 00 00 00       	mov    $0x1,%esi
  802ca9:	bf 0a 00 00 00       	mov    $0xa,%edi
  802cae:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
}
  802cba:	c9                   	leaveq 
  802cbb:	c3                   	retq   

0000000000802cbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 83 ec 30          	sub    $0x30,%rsp
  802cc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ccb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ccf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802cd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd5:	48 63 f0             	movslq %eax,%rsi
  802cd8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdf:	48 98                	cltq   
  802ce1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ce5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cec:	00 
  802ced:	49 89 f1             	mov    %rsi,%r9
  802cf0:	49 89 c8             	mov    %rcx,%r8
  802cf3:	48 89 d1             	mov    %rdx,%rcx
  802cf6:	48 89 c2             	mov    %rax,%rdx
  802cf9:	be 00 00 00 00       	mov    $0x0,%esi
  802cfe:	bf 0c 00 00 00       	mov    $0xc,%edi
  802d03:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
}
  802d0f:	c9                   	leaveq 
  802d10:	c3                   	retq   

0000000000802d11 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802d11:	55                   	push   %rbp
  802d12:	48 89 e5             	mov    %rsp,%rbp
  802d15:	48 83 ec 20          	sub    $0x20,%rsp
  802d19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802d1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d28:	00 
  802d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d35:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d3a:	48 89 c2             	mov    %rax,%rdx
  802d3d:	be 01 00 00 00       	mov    $0x1,%esi
  802d42:	bf 0d 00 00 00       	mov    $0xd,%edi
  802d47:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax
}
  802d53:	c9                   	leaveq 
  802d54:	c3                   	retq   

0000000000802d55 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802d55:	55                   	push   %rbp
  802d56:	48 89 e5             	mov    %rsp,%rbp
  802d59:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802d5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d64:	00 
  802d65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d71:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d76:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7b:	be 00 00 00 00       	mov    $0x0,%esi
  802d80:	bf 0e 00 00 00       	mov    $0xe,%edi
  802d85:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
}
  802d91:	c9                   	leaveq 
  802d92:	c3                   	retq   

0000000000802d93 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802d93:	55                   	push   %rbp
  802d94:	48 89 e5             	mov    %rsp,%rbp
  802d97:	48 83 ec 30          	sub    $0x30,%rsp
  802d9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802da2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802da5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802da9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802dad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802db0:	48 63 c8             	movslq %eax,%rcx
  802db3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dba:	48 63 f0             	movslq %eax,%rsi
  802dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	48 98                	cltq   
  802dc6:	48 89 0c 24          	mov    %rcx,(%rsp)
  802dca:	49 89 f9             	mov    %rdi,%r9
  802dcd:	49 89 f0             	mov    %rsi,%r8
  802dd0:	48 89 d1             	mov    %rdx,%rcx
  802dd3:	48 89 c2             	mov    %rax,%rdx
  802dd6:	be 00 00 00 00       	mov    $0x0,%esi
  802ddb:	bf 0f 00 00 00       	mov    $0xf,%edi
  802de0:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802dec:	c9                   	leaveq 
  802ded:	c3                   	retq   

0000000000802dee <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802dee:	55                   	push   %rbp
  802def:	48 89 e5             	mov    %rsp,%rbp
  802df2:	48 83 ec 20          	sub    $0x20,%rsp
  802df6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dfa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802dfe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802e0d:	00 
  802e0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e1a:	48 89 d1             	mov    %rdx,%rcx
  802e1d:	48 89 c2             	mov    %rax,%rdx
  802e20:	be 00 00 00 00       	mov    $0x0,%esi
  802e25:	bf 10 00 00 00       	mov    $0x10,%edi
  802e2a:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
}
  802e36:	c9                   	leaveq 
  802e37:	c3                   	retq   

0000000000802e38 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802e38:	55                   	push   %rbp
  802e39:	48 89 e5             	mov    %rsp,%rbp
  802e3c:	48 83 ec 40          	sub    $0x40,%rsp
  802e40:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802e44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e48:	48 8b 00             	mov    (%rax),%rax
  802e4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802e4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e53:	48 8b 40 08          	mov    0x8(%rax),%rax
  802e57:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  802e5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5e:	48 89 c2             	mov    %rax,%rdx
  802e61:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e6c:	01 00 00 
  802e6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  802e77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e7a:	83 e0 02             	and    $0x2,%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	0f 84 4f 01 00 00    	je     802fd4 <pgfault+0x19c>
  802e85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e89:	48 89 c2             	mov    %rax,%rdx
  802e8c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e97:	01 00 00 
  802e9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e9e:	25 00 08 00 00       	and    $0x800,%eax
  802ea3:	48 85 c0             	test   %rax,%rax
  802ea6:	0f 84 28 01 00 00    	je     802fd4 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  802eac:	ba 07 00 00 00       	mov    $0x7,%edx
  802eb1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802eb6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ebb:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802ec2:	00 00 00 
  802ec5:	ff d0                	callq  *%rax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	0f 85 db 00 00 00    	jne    802faa <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  802ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802ee1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  802ee5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee9:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eee:	48 89 c6             	mov    %rax,%rsi
  802ef1:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802ef6:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  802f02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f06:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802f0c:	48 89 c1             	mov    %rax,%rcx
  802f0f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f14:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f19:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1e:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  802f2d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802f31:	79 2a                	jns    802f5d <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  802f33:	48 ba 88 6d 80 00 00 	movabs $0x806d88,%rdx
  802f3a:	00 00 00 
  802f3d:	be 28 00 00 00       	mov    $0x28,%esi
  802f42:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  802f49:	00 00 00 
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  802f58:	00 00 00 
  802f5b:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  802f5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f62:	bf 00 00 00 00       	mov    $0x0,%edi
  802f67:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
  802f73:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  802f76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802f7a:	0f 89 84 00 00 00    	jns    803004 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  802f80:	48 ba c0 6d 80 00 00 	movabs $0x806dc0,%rdx
  802f87:	00 00 00 
  802f8a:	be 2c 00 00 00       	mov    $0x2c,%esi
  802f8f:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  802f96:	00 00 00 
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  802fa5:	00 00 00 
  802fa8:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  802faa:	48 ba f0 6d 80 00 00 	movabs $0x806df0,%rdx
  802fb1:	00 00 00 
  802fb4:	be 31 00 00 00       	mov    $0x31,%esi
  802fb9:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  802fc0:	00 00 00 
  802fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc8:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  802fcf:	00 00 00 
  802fd2:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802fd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fd7:	89 c1                	mov    %eax,%ecx
  802fd9:	48 ba 1a 6e 80 00 00 	movabs $0x806e1a,%rdx
  802fe0:	00 00 00 
  802fe3:	be 35 00 00 00       	mov    $0x35,%esi
  802fe8:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  802fef:	00 00 00 
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  802ffe:	00 00 00 
  803001:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  803004:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  803005:	c9                   	leaveq 
  803006:	c3                   	retq   

0000000000803007 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  803007:	55                   	push   %rbp
  803008:	48 89 e5             	mov    %rsp,%rbp
  80300b:	48 83 ec 30          	sub    $0x30,%rsp
  80300f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803012:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  803015:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80301c:	01 00 00 
  80301f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803022:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803026:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  80302a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80302d:	48 c1 e0 0c          	shl    $0xc,%rax
  803031:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  803035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803039:	25 07 0e 00 00       	and    $0xe07,%eax
  80303e:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  803041:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803044:	25 00 04 00 00       	and    $0x400,%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 62                	je     8030af <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  80304d:	8b 75 ec             	mov    -0x14(%rbp),%esi
  803050:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803054:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305b:	41 89 f0             	mov    %esi,%r8d
  80305e:	48 89 c6             	mov    %rax,%rsi
  803061:	bf 00 00 00 00       	mov    $0x0,%edi
  803066:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  803075:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803079:	0f 89 78 01 00 00    	jns    8031f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80307f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803082:	89 c1                	mov    %eax,%ecx
  803084:	48 ba 38 6e 80 00 00 	movabs $0x806e38,%rdx
  80308b:	00 00 00 
  80308e:	be 4f 00 00 00       	mov    $0x4f,%esi
  803093:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  80309a:	00 00 00 
  80309d:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a2:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  8030a9:	00 00 00 
  8030ac:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  8030af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b2:	25 00 08 00 00       	and    $0x800,%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	75 0e                	jne    8030c9 <duppage+0xc2>
  8030bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030be:	83 e0 02             	and    $0x2,%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	0f 84 d0 00 00 00    	je     803199 <duppage+0x192>
		perm &= ~PTE_W;
  8030c9:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  8030cd:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  8030d4:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8030d7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030db:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e2:	41 89 f0             	mov    %esi,%r8d
  8030e5:	48 89 c6             	mov    %rax,%rsi
  8030e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ed:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
  8030f9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8030fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803100:	79 30                	jns    803132 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  803102:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803105:	89 c1                	mov    %eax,%ecx
  803107:	48 ba 38 6e 80 00 00 	movabs $0x806e38,%rdx
  80310e:	00 00 00 
  803111:	be 57 00 00 00       	mov    $0x57,%esi
  803116:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  80311d:	00 00 00 
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80312c:	00 00 00 
  80312f:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  803132:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  803135:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313d:	41 89 c8             	mov    %ecx,%r8d
  803140:	48 89 d1             	mov    %rdx,%rcx
  803143:	ba 00 00 00 00       	mov    $0x0,%edx
  803148:	48 89 c6             	mov    %rax,%rsi
  80314b:	bf 00 00 00 00       	mov    $0x0,%edi
  803150:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
  80315c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80315f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803163:	0f 89 8e 00 00 00    	jns    8031f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  803169:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80316c:	89 c1                	mov    %eax,%ecx
  80316e:	48 ba 38 6e 80 00 00 	movabs $0x806e38,%rdx
  803175:	00 00 00 
  803178:	be 5b 00 00 00       	mov    $0x5b,%esi
  80317d:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  803184:	00 00 00 
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
  80318c:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  803193:	00 00 00 
  803196:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  803199:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80319c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a7:	41 89 f0             	mov    %esi,%r8d
  8031aa:	48 89 c6             	mov    %rax,%rsi
  8031ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b2:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
  8031be:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8031c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031c5:	79 30                	jns    8031f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8031c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031ca:	89 c1                	mov    %eax,%ecx
  8031cc:	48 ba 38 6e 80 00 00 	movabs $0x806e38,%rdx
  8031d3:	00 00 00 
  8031d6:	be 61 00 00 00       	mov    $0x61,%esi
  8031db:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  8031e2:	00 00 00 
  8031e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ea:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  8031f1:	00 00 00 
  8031f4:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  8031f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031fc:	c9                   	leaveq 
  8031fd:	c3                   	retq   

00000000008031fe <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8031fe:	55                   	push   %rbp
  8031ff:	48 89 e5             	mov    %rsp,%rbp
  803202:	53                   	push   %rbx
  803203:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  803207:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  80320e:	48 bf 38 2e 80 00 00 	movabs $0x802e38,%rdi
  803215:	00 00 00 
  803218:	48 b8 34 62 80 00 00 	movabs $0x806234,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803224:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80322b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80322e:	cd 30                	int    $0x30
  803230:	89 c3                	mov    %eax,%ebx
  803232:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803235:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  803238:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80323b:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80323f:	79 30                	jns    803271 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  803241:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803244:	89 c1                	mov    %eax,%ecx
  803246:	48 ba 5b 6e 80 00 00 	movabs $0x806e5b,%rdx
  80324d:	00 00 00 
  803250:	be 80 00 00 00       	mov    $0x80,%esi
  803255:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  80325c:	00 00 00 
  80325f:	b8 00 00 00 00       	mov    $0x0,%eax
  803264:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80326b:	00 00 00 
  80326e:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  803271:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  803275:	75 52                	jne    8032c9 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  803277:	48 b8 6c 2a 80 00 00 	movabs $0x802a6c,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
  803283:	48 98                	cltq   
  803285:	48 89 c2             	mov    %rax,%rdx
  803288:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80328e:	48 89 d0             	mov    %rdx,%rax
  803291:	48 c1 e0 02          	shl    $0x2,%rax
  803295:	48 01 d0             	add    %rdx,%rax
  803298:	48 01 c0             	add    %rax,%rax
  80329b:	48 01 d0             	add    %rdx,%rax
  80329e:	48 c1 e0 05          	shl    $0x5,%rax
  8032a2:	48 89 c2             	mov    %rax,%rdx
  8032a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8032ac:	00 00 00 
  8032af:	48 01 c2             	add    %rax,%rdx
  8032b2:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8032b9:	00 00 00 
  8032bc:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  8032bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c4:	e9 9d 02 00 00       	jmpq   803566 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  8032c9:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8032cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8032d1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8032d6:	89 c7                	mov    %eax,%edi
  8032d8:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8032df:	00 00 00 
  8032e2:	ff d0                	callq  *%rax
  8032e4:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8032e7:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8032eb:	79 30                	jns    80331d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  8032ed:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8032f0:	89 c1                	mov    %eax,%ecx
  8032f2:	48 ba 5b 6e 80 00 00 	movabs $0x806e5b,%rdx
  8032f9:	00 00 00 
  8032fc:	be 88 00 00 00       	mov    $0x88,%esi
  803301:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  803308:	00 00 00 
  80330b:	b8 00 00 00 00       	mov    $0x0,%eax
  803310:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  803317:	00 00 00 
  80331a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80331d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803324:	00 
	uint64_t each_pte = 0;
  803325:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80332c:	00 
	uint64_t each_pdpe = 0;
  80332d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  803334:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  803335:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80333c:	00 
  80333d:	e9 73 01 00 00       	jmpq   8034b5 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  803342:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803349:	01 00 00 
  80334c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803350:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803354:	83 e0 01             	and    $0x1,%eax
  803357:	84 c0                	test   %al,%al
  803359:	0f 84 41 01 00 00    	je     8034a0 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80335f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803366:	00 
  803367:	e9 24 01 00 00       	jmpq   803490 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  80336c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803373:	01 00 00 
  803376:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80337a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80337e:	83 e0 01             	and    $0x1,%eax
  803381:	84 c0                	test   %al,%al
  803383:	0f 84 ed 00 00 00    	je     803476 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  803389:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803390:	00 
  803391:	e9 d0 00 00 00       	jmpq   803466 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  803396:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80339d:	01 00 00 
  8033a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8033a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033a8:	83 e0 01             	and    $0x1,%eax
  8033ab:	84 c0                	test   %al,%al
  8033ad:	0f 84 99 00 00 00    	je     80344c <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8033b3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8033ba:	00 
  8033bb:	eb 7f                	jmp    80343c <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  8033bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033c4:	01 00 00 
  8033c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8033cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033cf:	83 e0 01             	and    $0x1,%eax
  8033d2:	84 c0                	test   %al,%al
  8033d4:	74 5c                	je     803432 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  8033d6:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  8033dd:	00 
  8033de:	74 52                	je     803432 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  8033e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033e4:	89 c2                	mov    %eax,%edx
  8033e6:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8033e9:	89 d6                	mov    %edx,%esi
  8033eb:	89 c7                	mov    %eax,%edi
  8033ed:	48 b8 07 30 80 00 00 	movabs $0x803007,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
  8033f9:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8033fc:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  803400:	79 30                	jns    803432 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  803402:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803405:	89 c1                	mov    %eax,%ecx
  803407:	48 ba 5b 6e 80 00 00 	movabs $0x806e5b,%rdx
  80340e:	00 00 00 
  803411:	be a0 00 00 00       	mov    $0xa0,%esi
  803416:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  80341d:	00 00 00 
  803420:	b8 00 00 00 00       	mov    $0x0,%eax
  803425:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80342c:	00 00 00 
  80342f:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803432:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  803437:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  80343c:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  803443:	00 
  803444:	0f 86 73 ff ff ff    	jbe    8033bd <fork+0x1bf>
  80344a:	eb 10                	jmp    80345c <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  80344c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803450:	48 83 c0 01          	add    $0x1,%rax
  803454:	48 c1 e0 09          	shl    $0x9,%rax
  803458:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80345c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803461:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  803466:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  80346d:	00 
  80346e:	0f 86 22 ff ff ff    	jbe    803396 <fork+0x198>
  803474:	eb 10                	jmp    803486 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  803476:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80347a:	48 83 c0 01          	add    $0x1,%rax
  80347e:	48 c1 e0 09          	shl    $0x9,%rax
  803482:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803486:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80348b:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803490:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803497:	00 
  803498:	0f 86 ce fe ff ff    	jbe    80336c <fork+0x16e>
  80349e:	eb 10                	jmp    8034b0 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  8034a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a4:	48 83 c0 01          	add    $0x1,%rax
  8034a8:	48 c1 e0 09          	shl    $0x9,%rax
  8034ac:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8034b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034ba:	0f 84 82 fe ff ff    	je     803342 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8034c0:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8034c3:	48 be cc 62 80 00 00 	movabs $0x8062cc,%rsi
  8034ca:	00 00 00 
  8034cd:	89 c7                	mov    %eax,%edi
  8034cf:	48 b8 72 2c 80 00 00 	movabs $0x802c72,%rax
  8034d6:	00 00 00 
  8034d9:	ff d0                	callq  *%rax
  8034db:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8034de:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8034e2:	79 30                	jns    803514 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  8034e4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8034e7:	89 c1                	mov    %eax,%ecx
  8034e9:	48 ba 5b 6e 80 00 00 	movabs $0x806e5b,%rdx
  8034f0:	00 00 00 
  8034f3:	be bd 00 00 00       	mov    $0xbd,%esi
  8034f8:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  8034ff:	00 00 00 
  803502:	b8 00 00 00 00       	mov    $0x0,%eax
  803507:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80350e:	00 00 00 
  803511:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  803514:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803517:	be 02 00 00 00       	mov    $0x2,%esi
  80351c:	89 c7                	mov    %eax,%edi
  80351e:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  803525:	00 00 00 
  803528:	ff d0                	callq  *%rax
  80352a:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80352d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  803531:	79 30                	jns    803563 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  803533:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803536:	89 c1                	mov    %eax,%ecx
  803538:	48 ba 5b 6e 80 00 00 	movabs $0x806e5b,%rdx
  80353f:	00 00 00 
  803542:	be c1 00 00 00       	mov    $0xc1,%esi
  803547:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  80354e:	00 00 00 
  803551:	b8 00 00 00 00       	mov    $0x0,%eax
  803556:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80355d:	00 00 00 
  803560:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  803563:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  803566:	48 83 c4 68          	add    $0x68,%rsp
  80356a:	5b                   	pop    %rbx
  80356b:	5d                   	pop    %rbp
  80356c:	c3                   	retq   

000000000080356d <sfork>:

// Challenge!
int
sfork(void)
{
  80356d:	55                   	push   %rbp
  80356e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  803571:	48 ba 74 6e 80 00 00 	movabs $0x806e74,%rdx
  803578:	00 00 00 
  80357b:	be cc 00 00 00       	mov    $0xcc,%esi
  803580:	48 bf b0 6d 80 00 00 	movabs $0x806db0,%rdi
  803587:	00 00 00 
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
  80358f:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  803596:	00 00 00 
  803599:	ff d1                	callq  *%rcx
	...

000000000080359c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80359c:	55                   	push   %rbp
  80359d:	48 89 e5             	mov    %rsp,%rbp
  8035a0:	48 83 ec 18          	sub    $0x18,%rsp
  8035a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8035b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035b8:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8035bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035c3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	8b 00                	mov    (%rax),%eax
  8035cd:	83 f8 01             	cmp    $0x1,%eax
  8035d0:	7e 13                	jle    8035e5 <argstart+0x49>
  8035d2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8035d7:	74 0c                	je     8035e5 <argstart+0x49>
  8035d9:	48 b8 8a 6e 80 00 00 	movabs $0x806e8a,%rax
  8035e0:	00 00 00 
  8035e3:	eb 05                	jmp    8035ea <argstart+0x4e>
  8035e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035ee:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8035f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f6:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8035fd:	00 
}
  8035fe:	c9                   	leaveq 
  8035ff:	c3                   	retq   

0000000000803600 <argnext>:

int
argnext(struct Argstate *args)
{
  803600:	55                   	push   %rbp
  803601:	48 89 e5             	mov    %rsp,%rbp
  803604:	48 83 ec 20          	sub    $0x20,%rsp
  803608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80360c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803610:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803617:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803620:	48 85 c0             	test   %rax,%rax
  803623:	75 0a                	jne    80362f <argnext+0x2f>
		return -1;
  803625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80362a:	e9 24 01 00 00       	jmpq   803753 <argnext+0x153>

	if (!*args->curarg) {
  80362f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803633:	48 8b 40 10          	mov    0x10(%rax),%rax
  803637:	0f b6 00             	movzbl (%rax),%eax
  80363a:	84 c0                	test   %al,%al
  80363c:	0f 85 d5 00 00 00    	jne    803717 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  803642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803646:	48 8b 00             	mov    (%rax),%rax
  803649:	8b 00                	mov    (%rax),%eax
  80364b:	83 f8 01             	cmp    $0x1,%eax
  80364e:	0f 84 ee 00 00 00    	je     803742 <argnext+0x142>
		    || args->argv[1][0] != '-'
  803654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803658:	48 8b 40 08          	mov    0x8(%rax),%rax
  80365c:	48 83 c0 08          	add    $0x8,%rax
  803660:	48 8b 00             	mov    (%rax),%rax
  803663:	0f b6 00             	movzbl (%rax),%eax
  803666:	3c 2d                	cmp    $0x2d,%al
  803668:	0f 85 d4 00 00 00    	jne    803742 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  80366e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803672:	48 8b 40 08          	mov    0x8(%rax),%rax
  803676:	48 83 c0 08          	add    $0x8,%rax
  80367a:	48 8b 00             	mov    (%rax),%rax
  80367d:	48 83 c0 01          	add    $0x1,%rax
  803681:	0f b6 00             	movzbl (%rax),%eax
  803684:	84 c0                	test   %al,%al
  803686:	0f 84 b6 00 00 00    	je     803742 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80368c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803690:	48 8b 40 08          	mov    0x8(%rax),%rax
  803694:	48 83 c0 08          	add    $0x8,%rax
  803698:	48 8b 00             	mov    (%rax),%rax
  80369b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80369f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a3:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8036a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ab:	48 8b 00             	mov    (%rax),%rax
  8036ae:	8b 00                	mov    (%rax),%eax
  8036b0:	83 e8 01             	sub    $0x1,%eax
  8036b3:	48 98                	cltq   
  8036b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036bc:	00 
  8036bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036c5:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8036c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036d1:	48 83 c0 08          	add    $0x8,%rax
  8036d5:	48 89 ce             	mov    %rcx,%rsi
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
		(*args->argc)--;
  8036e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036eb:	48 8b 00             	mov    (%rax),%rax
  8036ee:	8b 10                	mov    (%rax),%edx
  8036f0:	83 ea 01             	sub    $0x1,%edx
  8036f3:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8036f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036fd:	0f b6 00             	movzbl (%rax),%eax
  803700:	3c 2d                	cmp    $0x2d,%al
  803702:	75 13                	jne    803717 <argnext+0x117>
  803704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803708:	48 8b 40 10          	mov    0x10(%rax),%rax
  80370c:	48 83 c0 01          	add    $0x1,%rax
  803710:	0f b6 00             	movzbl (%rax),%eax
  803713:	84 c0                	test   %al,%al
  803715:	74 2a                	je     803741 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  803717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80371f:	0f b6 00             	movzbl (%rax),%eax
  803722:	0f b6 c0             	movzbl %al,%eax
  803725:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803730:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803738:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80373c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373f:	eb 12                	jmp    803753 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  803741:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  803742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803746:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80374d:	00 
	return -1;
  80374e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803753:	c9                   	leaveq 
  803754:	c3                   	retq   

0000000000803755 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803755:	55                   	push   %rbp
  803756:	48 89 e5             	mov    %rsp,%rbp
  803759:	48 83 ec 10          	sub    $0x10,%rsp
  80375d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  803761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803765:	48 8b 40 18          	mov    0x18(%rax),%rax
  803769:	48 85 c0             	test   %rax,%rax
  80376c:	74 0a                	je     803778 <argvalue+0x23>
  80376e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803772:	48 8b 40 18          	mov    0x18(%rax),%rax
  803776:	eb 13                	jmp    80378b <argvalue+0x36>
  803778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377c:	48 89 c7             	mov    %rax,%rdi
  80377f:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
}
  80378b:	c9                   	leaveq 
  80378c:	c3                   	retq   

000000000080378d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80378d:	55                   	push   %rbp
  80378e:	48 89 e5             	mov    %rsp,%rbp
  803791:	48 83 ec 10          	sub    $0x10,%rsp
  803795:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  803799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8037a1:	48 85 c0             	test   %rax,%rax
  8037a4:	75 0a                	jne    8037b0 <argnextvalue+0x23>
		return 0;
  8037a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ab:	e9 c8 00 00 00       	jmpq   803878 <argnextvalue+0xeb>
	if (*args->curarg) {
  8037b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8037b8:	0f b6 00             	movzbl (%rax),%eax
  8037bb:	84 c0                	test   %al,%al
  8037bd:	74 27                	je     8037e6 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8037bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037cb:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8037cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d3:	48 ba 8a 6e 80 00 00 	movabs $0x806e8a,%rdx
  8037da:	00 00 00 
  8037dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8037e1:	e9 8a 00 00 00       	jmpq   803870 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8037e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ea:	48 8b 00             	mov    (%rax),%rax
  8037ed:	8b 00                	mov    (%rax),%eax
  8037ef:	83 f8 01             	cmp    $0x1,%eax
  8037f2:	7e 64                	jle    803858 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  8037f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803804:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380c:	48 8b 00             	mov    (%rax),%rax
  80380f:	8b 00                	mov    (%rax),%eax
  803811:	83 e8 01             	sub    $0x1,%eax
  803814:	48 98                	cltq   
  803816:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80381d:	00 
  80381e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803822:	48 8b 40 08          	mov    0x8(%rax),%rax
  803826:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80382a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803832:	48 83 c0 08          	add    $0x8,%rax
  803836:	48 89 ce             	mov    %rcx,%rsi
  803839:	48 89 c7             	mov    %rax,%rdi
  80383c:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
		(*args->argc)--;
  803848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384c:	48 8b 00             	mov    (%rax),%rax
  80384f:	8b 10                	mov    (%rax),%edx
  803851:	83 ea 01             	sub    $0x1,%edx
  803854:	89 10                	mov    %edx,(%rax)
  803856:	eb 18                	jmp    803870 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  803858:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385c:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803863:	00 
		args->curarg = 0;
  803864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803868:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80386f:	00 
	}
	return (char*) args->argvalue;
  803870:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803874:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803878:	c9                   	leaveq 
  803879:	c3                   	retq   
	...

000000000080387c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80387c:	55                   	push   %rbp
  80387d:	48 89 e5             	mov    %rsp,%rbp
  803880:	48 83 ec 08          	sub    $0x8,%rsp
  803884:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803888:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80388c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803893:	ff ff ff 
  803896:	48 01 d0             	add    %rdx,%rax
  803899:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80389d:	c9                   	leaveq 
  80389e:	c3                   	retq   

000000000080389f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80389f:	55                   	push   %rbp
  8038a0:	48 89 e5             	mov    %rsp,%rbp
  8038a3:	48 83 ec 08          	sub    $0x8,%rsp
  8038a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8038ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038af:	48 89 c7             	mov    %rax,%rdi
  8038b2:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
  8038be:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8038c4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8038c8:	c9                   	leaveq 
  8038c9:	c3                   	retq   

00000000008038ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8038ca:	55                   	push   %rbp
  8038cb:	48 89 e5             	mov    %rsp,%rbp
  8038ce:	48 83 ec 18          	sub    $0x18,%rsp
  8038d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8038d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038dd:	eb 6b                	jmp    80394a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8038df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e2:	48 98                	cltq   
  8038e4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8038ea:	48 c1 e0 0c          	shl    $0xc,%rax
  8038ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8038f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f6:	48 89 c2             	mov    %rax,%rdx
  8038f9:	48 c1 ea 15          	shr    $0x15,%rdx
  8038fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803904:	01 00 00 
  803907:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80390b:	83 e0 01             	and    $0x1,%eax
  80390e:	48 85 c0             	test   %rax,%rax
  803911:	74 21                	je     803934 <fd_alloc+0x6a>
  803913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803917:	48 89 c2             	mov    %rax,%rdx
  80391a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80391e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803925:	01 00 00 
  803928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80392c:	83 e0 01             	and    $0x1,%eax
  80392f:	48 85 c0             	test   %rax,%rax
  803932:	75 12                	jne    803946 <fd_alloc+0x7c>
			*fd_store = fd;
  803934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80393c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80393f:	b8 00 00 00 00       	mov    $0x0,%eax
  803944:	eb 1a                	jmp    803960 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803946:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80394a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80394e:	7e 8f                	jle    8038df <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803954:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80395b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803960:	c9                   	leaveq 
  803961:	c3                   	retq   

0000000000803962 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803962:	55                   	push   %rbp
  803963:	48 89 e5             	mov    %rsp,%rbp
  803966:	48 83 ec 20          	sub    $0x20,%rsp
  80396a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80396d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803971:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803975:	78 06                	js     80397d <fd_lookup+0x1b>
  803977:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80397b:	7e 07                	jle    803984 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80397d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803982:	eb 6c                	jmp    8039f0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803984:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803987:	48 98                	cltq   
  803989:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80398f:	48 c1 e0 0c          	shl    $0xc,%rax
  803993:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399b:	48 89 c2             	mov    %rax,%rdx
  80399e:	48 c1 ea 15          	shr    $0x15,%rdx
  8039a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039a9:	01 00 00 
  8039ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039b0:	83 e0 01             	and    $0x1,%eax
  8039b3:	48 85 c0             	test   %rax,%rax
  8039b6:	74 21                	je     8039d9 <fd_lookup+0x77>
  8039b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039bc:	48 89 c2             	mov    %rax,%rdx
  8039bf:	48 c1 ea 0c          	shr    $0xc,%rdx
  8039c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039ca:	01 00 00 
  8039cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039d1:	83 e0 01             	and    $0x1,%eax
  8039d4:	48 85 c0             	test   %rax,%rax
  8039d7:	75 07                	jne    8039e0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8039d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8039de:	eb 10                	jmp    8039f0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8039e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039e8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8039eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f0:	c9                   	leaveq 
  8039f1:	c3                   	retq   

00000000008039f2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8039f2:	55                   	push   %rbp
  8039f3:	48 89 e5             	mov    %rsp,%rbp
  8039f6:	48 83 ec 30          	sub    $0x30,%rsp
  8039fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039fe:	89 f0                	mov    %esi,%eax
  803a00:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a07:	48 89 c7             	mov    %rax,%rdi
  803a0a:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  803a11:	00 00 00 
  803a14:	ff d0                	callq  *%rax
  803a16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a1a:	48 89 d6             	mov    %rdx,%rsi
  803a1d:	89 c7                	mov    %eax,%edi
  803a1f:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
  803a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a32:	78 0a                	js     803a3e <fd_close+0x4c>
	    || fd != fd2)
  803a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a38:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803a3c:	74 12                	je     803a50 <fd_close+0x5e>
		return (must_exist ? r : 0);
  803a3e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803a42:	74 05                	je     803a49 <fd_close+0x57>
  803a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a47:	eb 05                	jmp    803a4e <fd_close+0x5c>
  803a49:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4e:	eb 69                	jmp    803ab9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a54:	8b 00                	mov    (%rax),%eax
  803a56:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a5a:	48 89 d6             	mov    %rdx,%rsi
  803a5d:	89 c7                	mov    %eax,%edi
  803a5f:	48 b8 bb 3a 80 00 00 	movabs $0x803abb,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a72:	78 2a                	js     803a9e <fd_close+0xac>
		if (dev->dev_close)
  803a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a78:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a7c:	48 85 c0             	test   %rax,%rax
  803a7f:	74 16                	je     803a97 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a85:	48 8b 50 20          	mov    0x20(%rax),%rdx
  803a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a8d:	48 89 c7             	mov    %rax,%rdi
  803a90:	ff d2                	callq  *%rdx
  803a92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a95:	eb 07                	jmp    803a9e <fd_close+0xac>
		else
			r = 0;
  803a97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa2:	48 89 c6             	mov    %rax,%rsi
  803aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  803aaa:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
	return r;
  803ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ab9:	c9                   	leaveq 
  803aba:	c3                   	retq   

0000000000803abb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803abb:	55                   	push   %rbp
  803abc:	48 89 e5             	mov    %rsp,%rbp
  803abf:	48 83 ec 20          	sub    $0x20,%rsp
  803ac3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ac6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803aca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ad1:	eb 41                	jmp    803b14 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803ad3:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803ada:	00 00 00 
  803add:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae0:	48 63 d2             	movslq %edx,%rdx
  803ae3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ae7:	8b 00                	mov    (%rax),%eax
  803ae9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803aec:	75 22                	jne    803b10 <dev_lookup+0x55>
			*dev = devtab[i];
  803aee:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803af5:	00 00 00 
  803af8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803afb:	48 63 d2             	movslq %edx,%rdx
  803afe:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803b02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b06:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803b09:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0e:	eb 60                	jmp    803b70 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803b10:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b14:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803b1b:	00 00 00 
  803b1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b21:	48 63 d2             	movslq %edx,%rdx
  803b24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b28:	48 85 c0             	test   %rax,%rax
  803b2b:	75 a6                	jne    803ad3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803b2d:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803b34:	00 00 00 
  803b37:	48 8b 00             	mov    (%rax),%rax
  803b3a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b43:	89 c6                	mov    %eax,%esi
  803b45:	48 bf 90 6e 80 00 00 	movabs $0x806e90,%rdi
  803b4c:	00 00 00 
  803b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b54:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  803b5b:	00 00 00 
  803b5e:	ff d1                	callq  *%rcx
	*dev = 0;
  803b60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b64:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803b70:	c9                   	leaveq 
  803b71:	c3                   	retq   

0000000000803b72 <close>:

int
close(int fdnum)
{
  803b72:	55                   	push   %rbp
  803b73:	48 89 e5             	mov    %rsp,%rbp
  803b76:	48 83 ec 20          	sub    $0x20,%rsp
  803b7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b7d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b84:	48 89 d6             	mov    %rdx,%rsi
  803b87:	89 c7                	mov    %eax,%edi
  803b89:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803b90:	00 00 00 
  803b93:	ff d0                	callq  *%rax
  803b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9c:	79 05                	jns    803ba3 <close+0x31>
		return r;
  803b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba1:	eb 18                	jmp    803bbb <close+0x49>
	else
		return fd_close(fd, 1);
  803ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba7:	be 01 00 00 00       	mov    $0x1,%esi
  803bac:	48 89 c7             	mov    %rax,%rdi
  803baf:	48 b8 f2 39 80 00 00 	movabs $0x8039f2,%rax
  803bb6:	00 00 00 
  803bb9:	ff d0                	callq  *%rax
}
  803bbb:	c9                   	leaveq 
  803bbc:	c3                   	retq   

0000000000803bbd <close_all>:

void
close_all(void)
{
  803bbd:	55                   	push   %rbp
  803bbe:	48 89 e5             	mov    %rsp,%rbp
  803bc1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bcc:	eb 15                	jmp    803be3 <close_all+0x26>
		close(i);
  803bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd1:	89 c7                	mov    %eax,%edi
  803bd3:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803bdf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803be3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803be7:	7e e5                	jle    803bce <close_all+0x11>
		close(i);
}
  803be9:	c9                   	leaveq 
  803bea:	c3                   	retq   

0000000000803beb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803beb:	55                   	push   %rbp
  803bec:	48 89 e5             	mov    %rsp,%rbp
  803bef:	48 83 ec 40          	sub    $0x40,%rsp
  803bf3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803bf6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803bf9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803bfd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c00:	48 89 d6             	mov    %rdx,%rsi
  803c03:	89 c7                	mov    %eax,%edi
  803c05:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
  803c11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c18:	79 08                	jns    803c22 <dup+0x37>
		return r;
  803c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1d:	e9 70 01 00 00       	jmpq   803d92 <dup+0x1a7>
	close(newfdnum);
  803c22:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c25:	89 c7                	mov    %eax,%edi
  803c27:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803c33:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c36:	48 98                	cltq   
  803c38:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803c3e:	48 c1 e0 0c          	shl    $0xc,%rax
  803c42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4a:	48 89 c7             	mov    %rax,%rdi
  803c4d:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c61:	48 89 c7             	mov    %rax,%rdi
  803c64:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  803c6b:	00 00 00 
  803c6e:	ff d0                	callq  *%rax
  803c70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c78:	48 89 c2             	mov    %rax,%rdx
  803c7b:	48 c1 ea 15          	shr    $0x15,%rdx
  803c7f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c86:	01 00 00 
  803c89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c8d:	83 e0 01             	and    $0x1,%eax
  803c90:	84 c0                	test   %al,%al
  803c92:	74 71                	je     803d05 <dup+0x11a>
  803c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c98:	48 89 c2             	mov    %rax,%rdx
  803c9b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ca6:	01 00 00 
  803ca9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cad:	83 e0 01             	and    $0x1,%eax
  803cb0:	84 c0                	test   %al,%al
  803cb2:	74 51                	je     803d05 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb8:	48 89 c2             	mov    %rax,%rdx
  803cbb:	48 c1 ea 0c          	shr    $0xc,%rdx
  803cbf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cc6:	01 00 00 
  803cc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ccd:	89 c1                	mov    %eax,%ecx
  803ccf:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803cd5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cdd:	41 89 c8             	mov    %ecx,%r8d
  803ce0:	48 89 d1             	mov    %rdx,%rcx
  803ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce8:	48 89 c6             	mov    %rax,%rsi
  803ceb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf0:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  803cf7:	00 00 00 
  803cfa:	ff d0                	callq  *%rax
  803cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d03:	78 56                	js     803d5b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803d05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d09:	48 89 c2             	mov    %rax,%rdx
  803d0c:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d10:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d17:	01 00 00 
  803d1a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d1e:	89 c1                	mov    %eax,%ecx
  803d20:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803d26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d2e:	41 89 c8             	mov    %ecx,%r8d
  803d31:	48 89 d1             	mov    %rdx,%rcx
  803d34:	ba 00 00 00 00       	mov    $0x0,%edx
  803d39:	48 89 c6             	mov    %rax,%rsi
  803d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d41:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
  803d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d54:	78 08                	js     803d5e <dup+0x173>
		goto err;

	return newfdnum;
  803d56:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d59:	eb 37                	jmp    803d92 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803d5b:	90                   	nop
  803d5c:	eb 01                	jmp    803d5f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803d5e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d63:	48 89 c6             	mov    %rax,%rsi
  803d66:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6b:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  803d72:	00 00 00 
  803d75:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803d77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d7b:	48 89 c6             	mov    %rax,%rsi
  803d7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d83:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
	return r;
  803d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d92:	c9                   	leaveq 
  803d93:	c3                   	retq   

0000000000803d94 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803d94:	55                   	push   %rbp
  803d95:	48 89 e5             	mov    %rsp,%rbp
  803d98:	48 83 ec 40          	sub    $0x40,%rsp
  803d9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803da3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803da7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dae:	48 89 d6             	mov    %rdx,%rsi
  803db1:	89 c7                	mov    %eax,%edi
  803db3:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803dba:	00 00 00 
  803dbd:	ff d0                	callq  *%rax
  803dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc6:	78 24                	js     803dec <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dcc:	8b 00                	mov    (%rax),%eax
  803dce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dd2:	48 89 d6             	mov    %rdx,%rsi
  803dd5:	89 c7                	mov    %eax,%edi
  803dd7:	48 b8 bb 3a 80 00 00 	movabs $0x803abb,%rax
  803dde:	00 00 00 
  803de1:	ff d0                	callq  *%rax
  803de3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dea:	79 05                	jns    803df1 <read+0x5d>
		return r;
  803dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803def:	eb 7a                	jmp    803e6b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df5:	8b 40 08             	mov    0x8(%rax),%eax
  803df8:	83 e0 03             	and    $0x3,%eax
  803dfb:	83 f8 01             	cmp    $0x1,%eax
  803dfe:	75 3a                	jne    803e3a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803e00:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803e07:	00 00 00 
  803e0a:	48 8b 00             	mov    (%rax),%rax
  803e0d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e13:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e16:	89 c6                	mov    %eax,%esi
  803e18:	48 bf af 6e 80 00 00 	movabs $0x806eaf,%rdi
  803e1f:	00 00 00 
  803e22:	b8 00 00 00 00       	mov    $0x0,%eax
  803e27:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  803e2e:	00 00 00 
  803e31:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e38:	eb 31                	jmp    803e6b <read+0xd7>
	}
	if (!dev->dev_read)
  803e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  803e42:	48 85 c0             	test   %rax,%rax
  803e45:	75 07                	jne    803e4e <read+0xba>
		return -E_NOT_SUPP;
  803e47:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e4c:	eb 1d                	jmp    803e6b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  803e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e52:	4c 8b 40 10          	mov    0x10(%rax),%r8
  803e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e5e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803e62:	48 89 ce             	mov    %rcx,%rsi
  803e65:	48 89 c7             	mov    %rax,%rdi
  803e68:	41 ff d0             	callq  *%r8
}
  803e6b:	c9                   	leaveq 
  803e6c:	c3                   	retq   

0000000000803e6d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803e6d:	55                   	push   %rbp
  803e6e:	48 89 e5             	mov    %rsp,%rbp
  803e71:	48 83 ec 30          	sub    $0x30,%rsp
  803e75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e87:	eb 46                	jmp    803ecf <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8c:	48 98                	cltq   
  803e8e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e92:	48 29 c2             	sub    %rax,%rdx
  803e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e98:	48 98                	cltq   
  803e9a:	48 89 c1             	mov    %rax,%rcx
  803e9d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ea4:	48 89 ce             	mov    %rcx,%rsi
  803ea7:	89 c7                	mov    %eax,%edi
  803ea9:	48 b8 94 3d 80 00 00 	movabs $0x803d94,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803eb8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ebc:	79 05                	jns    803ec3 <readn+0x56>
			return m;
  803ebe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec1:	eb 1d                	jmp    803ee0 <readn+0x73>
		if (m == 0)
  803ec3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ec7:	74 13                	je     803edc <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803ec9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ecc:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ecf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed2:	48 98                	cltq   
  803ed4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803ed8:	72 af                	jb     803e89 <readn+0x1c>
  803eda:	eb 01                	jmp    803edd <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803edc:	90                   	nop
	}
	return tot;
  803edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ee0:	c9                   	leaveq 
  803ee1:	c3                   	retq   

0000000000803ee2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803ee2:	55                   	push   %rbp
  803ee3:	48 89 e5             	mov    %rsp,%rbp
  803ee6:	48 83 ec 40          	sub    $0x40,%rsp
  803eea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803eed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ef1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803ef5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ef9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803efc:	48 89 d6             	mov    %rdx,%rsi
  803eff:	89 c7                	mov    %eax,%edi
  803f01:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
  803f0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f14:	78 24                	js     803f3a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1a:	8b 00                	mov    (%rax),%eax
  803f1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f20:	48 89 d6             	mov    %rdx,%rsi
  803f23:	89 c7                	mov    %eax,%edi
  803f25:	48 b8 bb 3a 80 00 00 	movabs $0x803abb,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f38:	79 05                	jns    803f3f <write+0x5d>
		return r;
  803f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3d:	eb 79                	jmp    803fb8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f43:	8b 40 08             	mov    0x8(%rax),%eax
  803f46:	83 e0 03             	and    $0x3,%eax
  803f49:	85 c0                	test   %eax,%eax
  803f4b:	75 3a                	jne    803f87 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803f4d:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803f54:	00 00 00 
  803f57:	48 8b 00             	mov    (%rax),%rax
  803f5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f63:	89 c6                	mov    %eax,%esi
  803f65:	48 bf cb 6e 80 00 00 	movabs $0x806ecb,%rdi
  803f6c:	00 00 00 
  803f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f74:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  803f7b:	00 00 00 
  803f7e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803f80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f85:	eb 31                	jmp    803fb8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f8b:	48 8b 40 18          	mov    0x18(%rax),%rax
  803f8f:	48 85 c0             	test   %rax,%rax
  803f92:	75 07                	jne    803f9b <write+0xb9>
		return -E_NOT_SUPP;
  803f94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f99:	eb 1d                	jmp    803fb8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  803f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f9f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  803fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803fab:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803faf:	48 89 ce             	mov    %rcx,%rsi
  803fb2:	48 89 c7             	mov    %rax,%rdi
  803fb5:	41 ff d0             	callq  *%r8
}
  803fb8:	c9                   	leaveq 
  803fb9:	c3                   	retq   

0000000000803fba <seek>:

int
seek(int fdnum, off_t offset)
{
  803fba:	55                   	push   %rbp
  803fbb:	48 89 e5             	mov    %rsp,%rbp
  803fbe:	48 83 ec 18          	sub    $0x18,%rsp
  803fc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fc5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fcf:	48 89 d6             	mov    %rdx,%rsi
  803fd2:	89 c7                	mov    %eax,%edi
  803fd4:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803fdb:	00 00 00 
  803fde:	ff d0                	callq  *%rax
  803fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe7:	79 05                	jns    803fee <seek+0x34>
		return r;
  803fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fec:	eb 0f                	jmp    803ffd <seek+0x43>
	fd->fd_offset = offset;
  803fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ff5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ffd:	c9                   	leaveq 
  803ffe:	c3                   	retq   

0000000000803fff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803fff:	55                   	push   %rbp
  804000:	48 89 e5             	mov    %rsp,%rbp
  804003:	48 83 ec 30          	sub    $0x30,%rsp
  804007:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80400a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80400d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804011:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804014:	48 89 d6             	mov    %rdx,%rsi
  804017:	89 c7                	mov    %eax,%edi
  804019:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402c:	78 24                	js     804052 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80402e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804032:	8b 00                	mov    (%rax),%eax
  804034:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804038:	48 89 d6             	mov    %rdx,%rsi
  80403b:	89 c7                	mov    %eax,%edi
  80403d:	48 b8 bb 3a 80 00 00 	movabs $0x803abb,%rax
  804044:	00 00 00 
  804047:	ff d0                	callq  *%rax
  804049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804050:	79 05                	jns    804057 <ftruncate+0x58>
		return r;
  804052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804055:	eb 72                	jmp    8040c9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  804057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80405b:	8b 40 08             	mov    0x8(%rax),%eax
  80405e:	83 e0 03             	and    $0x3,%eax
  804061:	85 c0                	test   %eax,%eax
  804063:	75 3a                	jne    80409f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  804065:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80406c:	00 00 00 
  80406f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804072:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804078:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80407b:	89 c6                	mov    %eax,%esi
  80407d:	48 bf e8 6e 80 00 00 	movabs $0x806ee8,%rdi
  804084:	00 00 00 
  804087:	b8 00 00 00 00       	mov    $0x0,%eax
  80408c:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  804093:	00 00 00 
  804096:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  804098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80409d:	eb 2a                	jmp    8040c9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80409f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8040a7:	48 85 c0             	test   %rax,%rax
  8040aa:	75 07                	jne    8040b3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8040ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8040b1:	eb 16                	jmp    8040c9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8040b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8040bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040bf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8040c2:	89 d6                	mov    %edx,%esi
  8040c4:	48 89 c7             	mov    %rax,%rdi
  8040c7:	ff d1                	callq  *%rcx
}
  8040c9:	c9                   	leaveq 
  8040ca:	c3                   	retq   

00000000008040cb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8040cb:	55                   	push   %rbp
  8040cc:	48 89 e5             	mov    %rsp,%rbp
  8040cf:	48 83 ec 30          	sub    $0x30,%rsp
  8040d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8040d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8040da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040e1:	48 89 d6             	mov    %rdx,%rsi
  8040e4:	89 c7                	mov    %eax,%edi
  8040e6:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f9:	78 24                	js     80411f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8040fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ff:	8b 00                	mov    (%rax),%eax
  804101:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804105:	48 89 d6             	mov    %rdx,%rsi
  804108:	89 c7                	mov    %eax,%edi
  80410a:	48 b8 bb 3a 80 00 00 	movabs $0x803abb,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411d:	79 05                	jns    804124 <fstat+0x59>
		return r;
  80411f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804122:	eb 5e                	jmp    804182 <fstat+0xb7>
	if (!dev->dev_stat)
  804124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804128:	48 8b 40 28          	mov    0x28(%rax),%rax
  80412c:	48 85 c0             	test   %rax,%rax
  80412f:	75 07                	jne    804138 <fstat+0x6d>
		return -E_NOT_SUPP;
  804131:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804136:	eb 4a                	jmp    804182 <fstat+0xb7>
	stat->st_name[0] = 0;
  804138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80413f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804143:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80414a:	00 00 00 
	stat->st_isdir = 0;
  80414d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804151:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804158:	00 00 00 
	stat->st_dev = dev;
  80415b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80415f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804163:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80416a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  804172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804176:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80417a:	48 89 d6             	mov    %rdx,%rsi
  80417d:	48 89 c7             	mov    %rax,%rdi
  804180:	ff d1                	callq  *%rcx
}
  804182:	c9                   	leaveq 
  804183:	c3                   	retq   

0000000000804184 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804184:	55                   	push   %rbp
  804185:	48 89 e5             	mov    %rsp,%rbp
  804188:	48 83 ec 20          	sub    $0x20,%rsp
  80418c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804198:	be 00 00 00 00       	mov    $0x0,%esi
  80419d:	48 89 c7             	mov    %rax,%rdi
  8041a0:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  8041a7:	00 00 00 
  8041aa:	ff d0                	callq  *%rax
  8041ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041b3:	79 05                	jns    8041ba <stat+0x36>
		return fd;
  8041b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b8:	eb 2f                	jmp    8041e9 <stat+0x65>
	r = fstat(fd, stat);
  8041ba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c1:	48 89 d6             	mov    %rdx,%rsi
  8041c4:	89 c7                	mov    %eax,%edi
  8041c6:	48 b8 cb 40 80 00 00 	movabs $0x8040cb,%rax
  8041cd:	00 00 00 
  8041d0:	ff d0                	callq  *%rax
  8041d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8041d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d8:	89 c7                	mov    %eax,%edi
  8041da:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8041e1:	00 00 00 
  8041e4:	ff d0                	callq  *%rax
	return r;
  8041e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8041e9:	c9                   	leaveq 
  8041ea:	c3                   	retq   
	...

00000000008041ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8041ec:	55                   	push   %rbp
  8041ed:	48 89 e5             	mov    %rsp,%rbp
  8041f0:	48 83 ec 10          	sub    $0x10,%rsp
  8041f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8041fb:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804202:	00 00 00 
  804205:	8b 00                	mov    (%rax),%eax
  804207:	85 c0                	test   %eax,%eax
  804209:	75 1d                	jne    804228 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80420b:	bf 01 00 00 00       	mov    $0x1,%edi
  804210:	48 b8 e6 64 80 00 00 	movabs $0x8064e6,%rax
  804217:	00 00 00 
  80421a:	ff d0                	callq  *%rax
  80421c:	48 ba 20 a4 80 00 00 	movabs $0x80a420,%rdx
  804223:	00 00 00 
  804226:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  804228:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  80422f:	00 00 00 
  804232:	8b 00                	mov    (%rax),%eax
  804234:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804237:	b9 07 00 00 00       	mov    $0x7,%ecx
  80423c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  804243:	00 00 00 
  804246:	89 c7                	mov    %eax,%edi
  804248:	48 b8 37 64 80 00 00 	movabs $0x806437,%rax
  80424f:	00 00 00 
  804252:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804258:	ba 00 00 00 00       	mov    $0x0,%edx
  80425d:	48 89 c6             	mov    %rax,%rsi
  804260:	bf 00 00 00 00       	mov    $0x0,%edi
  804265:	48 b8 50 63 80 00 00 	movabs $0x806350,%rax
  80426c:	00 00 00 
  80426f:	ff d0                	callq  *%rax
}
  804271:	c9                   	leaveq 
  804272:	c3                   	retq   

0000000000804273 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  804273:	55                   	push   %rbp
  804274:	48 89 e5             	mov    %rsp,%rbp
  804277:	48 83 ec 20          	sub    $0x20,%rsp
  80427b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80427f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  804282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804286:	48 89 c7             	mov    %rax,%rdi
  804289:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
  804295:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80429a:	7e 0a                	jle    8042a6 <open+0x33>
		return -E_BAD_PATH;
  80429c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8042a1:	e9 a5 00 00 00       	jmpq   80434b <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8042a6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8042aa:	48 89 c7             	mov    %rax,%rdi
  8042ad:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8042bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c0:	79 08                	jns    8042ca <open+0x57>
		return r;
  8042c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c5:	e9 81 00 00 00       	jmpq   80434b <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8042ca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d1:	00 00 00 
  8042d4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8042d7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8042dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e1:	48 89 c6             	mov    %rax,%rsi
  8042e4:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8042eb:	00 00 00 
  8042ee:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  8042f5:	00 00 00 
  8042f8:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  8042fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042fe:	48 89 c6             	mov    %rax,%rsi
  804301:	bf 01 00 00 00       	mov    $0x1,%edi
  804306:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  80430d:	00 00 00 
  804310:	ff d0                	callq  *%rax
  804312:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  804315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804319:	79 1d                	jns    804338 <open+0xc5>
		fd_close(new_fd, 0);
  80431b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431f:	be 00 00 00 00       	mov    $0x0,%esi
  804324:	48 89 c7             	mov    %rax,%rdi
  804327:	48 b8 f2 39 80 00 00 	movabs $0x8039f2,%rax
  80432e:	00 00 00 
  804331:	ff d0                	callq  *%rax
		return r;	
  804333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804336:	eb 13                	jmp    80434b <open+0xd8>
	}
	return fd2num(new_fd);
  804338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433c:	48 89 c7             	mov    %rax,%rdi
  80433f:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
}
  80434b:	c9                   	leaveq 
  80434c:	c3                   	retq   

000000000080434d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80434d:	55                   	push   %rbp
  80434e:	48 89 e5             	mov    %rsp,%rbp
  804351:	48 83 ec 10          	sub    $0x10,%rsp
  804355:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80435d:	8b 50 0c             	mov    0xc(%rax),%edx
  804360:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804367:	00 00 00 
  80436a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80436c:	be 00 00 00 00       	mov    $0x0,%esi
  804371:	bf 06 00 00 00       	mov    $0x6,%edi
  804376:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  80437d:	00 00 00 
  804380:	ff d0                	callq  *%rax
}
  804382:	c9                   	leaveq 
  804383:	c3                   	retq   

0000000000804384 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804384:	55                   	push   %rbp
  804385:	48 89 e5             	mov    %rsp,%rbp
  804388:	48 83 ec 30          	sub    $0x30,%rsp
  80438c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804390:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804394:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  804398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80439c:	8b 50 0c             	mov    0xc(%rax),%edx
  80439f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a6:	00 00 00 
  8043a9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8043ab:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043b2:	00 00 00 
  8043b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043b9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8043bd:	be 00 00 00 00       	mov    $0x0,%esi
  8043c2:	bf 03 00 00 00       	mov    $0x3,%edi
  8043c7:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  8043ce:	00 00 00 
  8043d1:	ff d0                	callq  *%rax
  8043d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8043d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043da:	7e 23                	jle    8043ff <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8043dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043df:	48 63 d0             	movslq %eax,%rdx
  8043e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e6:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8043ed:	00 00 00 
  8043f0:	48 89 c7             	mov    %rax,%rdi
  8043f3:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  8043fa:	00 00 00 
  8043fd:	ff d0                	callq  *%rax
	}
	return nbytes;
  8043ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 20          	sub    $0x20,%rsp
  80440c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804410:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804418:	8b 50 0c             	mov    0xc(%rax),%edx
  80441b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804422:	00 00 00 
  804425:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804427:	be 00 00 00 00       	mov    $0x0,%esi
  80442c:	bf 05 00 00 00       	mov    $0x5,%edi
  804431:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
  80443d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804444:	79 05                	jns    80444b <devfile_stat+0x47>
		return r;
  804446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804449:	eb 56                	jmp    8044a1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804456:	00 00 00 
  804459:	48 89 c7             	mov    %rax,%rdi
  80445c:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  804463:	00 00 00 
  804466:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804468:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80446f:	00 00 00 
  804472:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80447c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804482:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804489:	00 00 00 
  80448c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  804492:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804496:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80449c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044a1:	c9                   	leaveq 
  8044a2:	c3                   	retq   
	...

00000000008044a4 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8044a4:	55                   	push   %rbp
  8044a5:	48 89 e5             	mov    %rsp,%rbp
  8044a8:	48 83 ec 20          	sub    $0x20,%rsp
  8044ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8044b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b4:	8b 40 0c             	mov    0xc(%rax),%eax
  8044b7:	85 c0                	test   %eax,%eax
  8044b9:	7e 67                	jle    804522 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8044bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bf:	8b 40 04             	mov    0x4(%rax),%eax
  8044c2:	48 63 d0             	movslq %eax,%rdx
  8044c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044c9:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8044cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d1:	8b 00                	mov    (%rax),%eax
  8044d3:	48 89 ce             	mov    %rcx,%rsi
  8044d6:	89 c7                	mov    %eax,%edi
  8044d8:	48 b8 e2 3e 80 00 00 	movabs $0x803ee2,%rax
  8044df:	00 00 00 
  8044e2:	ff d0                	callq  *%rax
  8044e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8044e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044eb:	7e 13                	jle    804500 <writebuf+0x5c>
			b->result += result;
  8044ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f1:	8b 40 08             	mov    0x8(%rax),%eax
  8044f4:	89 c2                	mov    %eax,%edx
  8044f6:	03 55 fc             	add    -0x4(%rbp),%edx
  8044f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044fd:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  804500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804504:	8b 40 04             	mov    0x4(%rax),%eax
  804507:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80450a:	74 16                	je     804522 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80450c:	b8 00 00 00 00       	mov    $0x0,%eax
  804511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804515:	89 c2                	mov    %eax,%edx
  804517:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  80451b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80451f:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  804522:	c9                   	leaveq 
  804523:	c3                   	retq   

0000000000804524 <putch>:

static void
putch(int ch, void *thunk)
{
  804524:	55                   	push   %rbp
  804525:	48 89 e5             	mov    %rsp,%rbp
  804528:	48 83 ec 20          	sub    $0x20,%rsp
  80452c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80452f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  804533:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804537:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80453b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80453f:	8b 40 04             	mov    0x4(%rax),%eax
  804542:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804545:	89 d6                	mov    %edx,%esi
  804547:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80454b:	48 63 d0             	movslq %eax,%rdx
  80454e:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  804553:	8d 50 01             	lea    0x1(%rax),%edx
  804556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455a:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  80455d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804561:	8b 40 04             	mov    0x4(%rax),%eax
  804564:	3d 00 01 00 00       	cmp    $0x100,%eax
  804569:	75 1e                	jne    804589 <putch+0x65>
		writebuf(b);
  80456b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456f:	48 89 c7             	mov    %rax,%rdi
  804572:	48 b8 a4 44 80 00 00 	movabs $0x8044a4,%rax
  804579:	00 00 00 
  80457c:	ff d0                	callq  *%rax
		b->idx = 0;
  80457e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804589:	c9                   	leaveq 
  80458a:	c3                   	retq   

000000000080458b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80458b:	55                   	push   %rbp
  80458c:	48 89 e5             	mov    %rsp,%rbp
  80458f:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804596:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80459c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8045a3:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8045aa:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8045b0:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8045b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8045bd:	00 00 00 
	b.result = 0;
  8045c0:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8045c7:	00 00 00 
	b.error = 1;
  8045ca:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8045d1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8045d4:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8045db:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8045e2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045e9:	48 89 c6             	mov    %rax,%rsi
  8045ec:	48 bf 24 45 80 00 00 	movabs $0x804524,%rdi
  8045f3:	00 00 00 
  8045f6:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8045fd:	00 00 00 
  804600:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804602:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  804608:	85 c0                	test   %eax,%eax
  80460a:	7e 16                	jle    804622 <vfprintf+0x97>
		writebuf(&b);
  80460c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804613:	48 89 c7             	mov    %rax,%rdi
  804616:	48 b8 a4 44 80 00 00 	movabs $0x8044a4,%rax
  80461d:	00 00 00 
  804620:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804622:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804628:	85 c0                	test   %eax,%eax
  80462a:	74 08                	je     804634 <vfprintf+0xa9>
  80462c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804632:	eb 06                	jmp    80463a <vfprintf+0xaf>
  804634:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80463a:	c9                   	leaveq 
  80463b:	c3                   	retq   

000000000080463c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80463c:	55                   	push   %rbp
  80463d:	48 89 e5             	mov    %rsp,%rbp
  804640:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804647:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80464d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804654:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80465b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804662:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804669:	84 c0                	test   %al,%al
  80466b:	74 20                	je     80468d <fprintf+0x51>
  80466d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804671:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804675:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804679:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80467d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804681:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804685:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804689:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80468d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804694:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80469b:	00 00 00 
  80469e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8046a5:	00 00 00 
  8046a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8046ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8046b3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8046ba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8046c1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8046c8:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8046cf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8046d5:	48 89 ce             	mov    %rcx,%rsi
  8046d8:	89 c7                	mov    %eax,%edi
  8046da:	48 b8 8b 45 80 00 00 	movabs $0x80458b,%rax
  8046e1:	00 00 00 
  8046e4:	ff d0                	callq  *%rax
  8046e6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8046ec:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8046f2:	c9                   	leaveq 
  8046f3:	c3                   	retq   

00000000008046f4 <printf>:

int
printf(const char *fmt, ...)
{
  8046f4:	55                   	push   %rbp
  8046f5:	48 89 e5             	mov    %rsp,%rbp
  8046f8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8046ff:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804706:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80470d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804714:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80471b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804722:	84 c0                	test   %al,%al
  804724:	74 20                	je     804746 <printf+0x52>
  804726:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80472a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80472e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804732:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804736:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80473a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80473e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804742:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804746:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80474d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804754:	00 00 00 
  804757:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80475e:	00 00 00 
  804761:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804765:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80476c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804773:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80477a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804781:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804788:	48 89 c6             	mov    %rax,%rsi
  80478b:	bf 01 00 00 00       	mov    $0x1,%edi
  804790:	48 b8 8b 45 80 00 00 	movabs $0x80458b,%rax
  804797:	00 00 00 
  80479a:	ff d0                	callq  *%rax
  80479c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8047a2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8047a8:	c9                   	leaveq 
  8047a9:	c3                   	retq   
	...

00000000008047ac <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8047ac:	55                   	push   %rbp
  8047ad:	48 89 e5             	mov    %rsp,%rbp
  8047b0:	53                   	push   %rbx
  8047b1:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  8047b8:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  8047bf:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8047c6:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  8047cd:	be 00 00 00 00       	mov    $0x0,%esi
  8047d2:	48 89 c7             	mov    %rax,%rdi
  8047d5:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  8047dc:	00 00 00 
  8047df:	ff d0                	callq  *%rax
  8047e1:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8047e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8047e8:	79 08                	jns    8047f2 <spawn+0x46>
		return r;
  8047ea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8047ed:	e9 23 03 00 00       	jmpq   804b15 <spawn+0x369>
	fd = r;
  8047f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8047f5:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8047f8:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  8047ff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804803:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  80480a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80480d:	ba 00 02 00 00       	mov    $0x200,%edx
  804812:	48 89 ce             	mov    %rcx,%rsi
  804815:	89 c7                	mov    %eax,%edi
  804817:	48 b8 6d 3e 80 00 00 	movabs $0x803e6d,%rax
  80481e:	00 00 00 
  804821:	ff d0                	callq  *%rax
  804823:	3d 00 02 00 00       	cmp    $0x200,%eax
  804828:	75 0d                	jne    804837 <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  80482a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80482e:	8b 00                	mov    (%rax),%eax
  804830:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804835:	74 43                	je     80487a <spawn+0xce>
		close(fd);
  804837:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80483a:	89 c7                	mov    %eax,%edi
  80483c:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  804843:	00 00 00 
  804846:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804848:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80484c:	8b 00                	mov    (%rax),%eax
  80484e:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804853:	89 c6                	mov    %eax,%esi
  804855:	48 bf 10 6f 80 00 00 	movabs $0x806f10,%rdi
  80485c:	00 00 00 
  80485f:	b8 00 00 00 00       	mov    $0x0,%eax
  804864:	48 b9 7f 14 80 00 00 	movabs $0x80147f,%rcx
  80486b:	00 00 00 
  80486e:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804870:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804875:	e9 9b 02 00 00       	jmpq   804b15 <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80487a:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  804881:	00 00 00 
  804884:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  80488a:	cd 30                	int    $0x30
  80488c:	89 c3                	mov    %eax,%ebx
  80488e:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804891:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804894:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804897:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80489b:	79 08                	jns    8048a5 <spawn+0xf9>
		return r;
  80489d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8048a0:	e9 70 02 00 00       	jmpq   804b15 <spawn+0x369>
	child = r;
  8048a5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8048a8:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8048ab:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8048ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8048b3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048ba:	00 00 00 
  8048bd:	48 63 d0             	movslq %eax,%rdx
  8048c0:	48 89 d0             	mov    %rdx,%rax
  8048c3:	48 c1 e0 02          	shl    $0x2,%rax
  8048c7:	48 01 d0             	add    %rdx,%rax
  8048ca:	48 01 c0             	add    %rax,%rax
  8048cd:	48 01 d0             	add    %rdx,%rax
  8048d0:	48 c1 e0 05          	shl    $0x5,%rax
  8048d4:	48 01 c8             	add    %rcx,%rax
  8048d7:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8048de:	48 89 c6             	mov    %rax,%rsi
  8048e1:	b8 18 00 00 00       	mov    $0x18,%eax
  8048e6:	48 89 d7             	mov    %rdx,%rdi
  8048e9:	48 89 c1             	mov    %rax,%rcx
  8048ec:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8048ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8048f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8048f7:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8048fe:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  804905:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80490c:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  804913:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804916:	48 89 ce             	mov    %rcx,%rsi
  804919:	89 c7                	mov    %eax,%edi
  80491b:	48 b8 6d 4d 80 00 00 	movabs $0x804d6d,%rax
  804922:	00 00 00 
  804925:	ff d0                	callq  *%rax
  804927:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80492a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80492e:	79 08                	jns    804938 <spawn+0x18c>
		return r;
  804930:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804933:	e9 dd 01 00 00       	jmpq   804b15 <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804938:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80493c:	48 8b 40 20          	mov    0x20(%rax),%rax
  804940:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  804947:	48 01 d0             	add    %rdx,%rax
  80494a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80494e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804955:	eb 7a                	jmp    8049d1 <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  804957:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80495b:	8b 00                	mov    (%rax),%eax
  80495d:	83 f8 01             	cmp    $0x1,%eax
  804960:	75 65                	jne    8049c7 <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  804962:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80496d:	8b 40 04             	mov    0x4(%rax),%eax
  804970:	83 e0 02             	and    $0x2,%eax
  804973:	85 c0                	test   %eax,%eax
  804975:	74 04                	je     80497b <spawn+0x1cf>
			perm |= PTE_W;
  804977:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80497b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80497f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804983:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804986:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80498a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80498e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804992:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804996:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80499a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80499e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8049a1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8049a4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049a7:	89 3c 24             	mov    %edi,(%rsp)
  8049aa:	89 c7                	mov    %eax,%edi
  8049ac:	48 b8 dd 4f 80 00 00 	movabs $0x804fdd,%rax
  8049b3:	00 00 00 
  8049b6:	ff d0                	callq  *%rax
  8049b8:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8049bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8049bf:	0f 88 2a 01 00 00    	js     804aef <spawn+0x343>
  8049c5:	eb 01                	jmp    8049c8 <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8049c7:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8049c8:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8049cc:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  8049d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8049d5:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8049d9:	0f b7 c0             	movzwl %ax,%eax
  8049dc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049df:	0f 8f 72 ff ff ff    	jg     804957 <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8049e5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049e8:	89 c7                	mov    %eax,%edi
  8049ea:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  8049f1:	00 00 00 
  8049f4:	ff d0                	callq  *%rax
	fd = -1;
  8049f6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8049fd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804a00:	89 c7                	mov    %eax,%edi
  804a02:	48 b8 c4 51 80 00 00 	movabs $0x8051c4,%rax
  804a09:	00 00 00 
  804a0c:	ff d0                	callq  *%rax
  804a0e:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804a11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804a15:	79 30                	jns    804a47 <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  804a17:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804a1a:	89 c1                	mov    %eax,%ecx
  804a1c:	48 ba 2a 6f 80 00 00 	movabs $0x806f2a,%rdx
  804a23:	00 00 00 
  804a26:	be 82 00 00 00       	mov    $0x82,%esi
  804a2b:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  804a32:	00 00 00 
  804a35:	b8 00 00 00 00       	mov    $0x0,%eax
  804a3a:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  804a41:	00 00 00 
  804a44:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804a47:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  804a4e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804a51:	48 89 d6             	mov    %rdx,%rsi
  804a54:	89 c7                	mov    %eax,%edi
  804a56:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  804a5d:	00 00 00 
  804a60:	ff d0                	callq  *%rax
  804a62:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804a65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804a69:	79 30                	jns    804a9b <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  804a6b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804a6e:	89 c1                	mov    %eax,%ecx
  804a70:	48 ba 4c 6f 80 00 00 	movabs $0x806f4c,%rdx
  804a77:	00 00 00 
  804a7a:	be 85 00 00 00       	mov    $0x85,%esi
  804a7f:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  804a86:	00 00 00 
  804a89:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8e:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  804a95:	00 00 00 
  804a98:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804a9b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804a9e:	be 02 00 00 00       	mov    $0x2,%esi
  804aa3:	89 c7                	mov    %eax,%edi
  804aa5:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  804aac:	00 00 00 
  804aaf:	ff d0                	callq  *%rax
  804ab1:	89 45 d8             	mov    %eax,-0x28(%rbp)
  804ab4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804ab8:	79 30                	jns    804aea <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  804aba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804abd:	89 c1                	mov    %eax,%ecx
  804abf:	48 ba 66 6f 80 00 00 	movabs $0x806f66,%rdx
  804ac6:	00 00 00 
  804ac9:	be 88 00 00 00       	mov    $0x88,%esi
  804ace:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  804ad5:	00 00 00 
  804ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  804add:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  804ae4:	00 00 00 
  804ae7:	41 ff d0             	callq  *%r8

	return child;
  804aea:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804aed:	eb 26                	jmp    804b15 <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804aef:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804af0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804af3:	89 c7                	mov    %eax,%edi
  804af5:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  804afc:	00 00 00 
  804aff:	ff d0                	callq  *%rax
	close(fd);
  804b01:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804b04:	89 c7                	mov    %eax,%edi
  804b06:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  804b0d:	00 00 00 
  804b10:	ff d0                	callq  *%rax
	return r;
  804b12:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  804b15:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  804b1c:	5b                   	pop    %rbx
  804b1d:	5d                   	pop    %rbp
  804b1e:	c3                   	retq   

0000000000804b1f <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804b1f:	55                   	push   %rbp
  804b20:	48 89 e5             	mov    %rsp,%rbp
  804b23:	53                   	push   %rbx
  804b24:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  804b2b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  804b32:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  804b39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804b40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804b47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804b4e:	84 c0                	test   %al,%al
  804b50:	74 23                	je     804b75 <spawnl+0x56>
  804b52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804b59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804b5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804b61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804b65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804b69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804b6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804b71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804b75:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804b7c:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  804b83:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804b86:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  804b8d:	00 00 00 
  804b90:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  804b97:	00 00 00 
  804b9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b9e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  804ba5:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  804bac:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804bb3:	eb 07                	jmp    804bbc <spawnl+0x9d>
		argc++;
  804bb5:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804bbc:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804bc2:	83 f8 30             	cmp    $0x30,%eax
  804bc5:	73 23                	jae    804bea <spawnl+0xcb>
  804bc7:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  804bce:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804bd4:	89 c0                	mov    %eax,%eax
  804bd6:	48 01 d0             	add    %rdx,%rax
  804bd9:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  804bdf:	83 c2 08             	add    $0x8,%edx
  804be2:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  804be8:	eb 15                	jmp    804bff <spawnl+0xe0>
  804bea:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804bf1:	48 89 d0             	mov    %rdx,%rax
  804bf4:	48 83 c2 08          	add    $0x8,%rdx
  804bf8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  804bff:	48 8b 00             	mov    (%rax),%rax
  804c02:	48 85 c0             	test   %rax,%rax
  804c05:	75 ae                	jne    804bb5 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804c07:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804c0d:	83 c0 02             	add    $0x2,%eax
  804c10:	48 89 e2             	mov    %rsp,%rdx
  804c13:	48 89 d3             	mov    %rdx,%rbx
  804c16:	48 63 d0             	movslq %eax,%rdx
  804c19:	48 83 ea 01          	sub    $0x1,%rdx
  804c1d:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  804c24:	48 98                	cltq   
  804c26:	48 c1 e0 03          	shl    $0x3,%rax
  804c2a:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  804c2e:	b8 10 00 00 00       	mov    $0x10,%eax
  804c33:	48 83 e8 01          	sub    $0x1,%rax
  804c37:	48 01 d0             	add    %rdx,%rax
  804c3a:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  804c41:	10 00 00 00 
  804c45:	ba 00 00 00 00       	mov    $0x0,%edx
  804c4a:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  804c51:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804c55:	48 29 c4             	sub    %rax,%rsp
  804c58:	48 89 e0             	mov    %rsp,%rax
  804c5b:	48 83 c0 0f          	add    $0xf,%rax
  804c5f:	48 c1 e8 04          	shr    $0x4,%rax
  804c63:	48 c1 e0 04          	shl    $0x4,%rax
  804c67:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  804c6e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804c75:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  804c7c:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804c7f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804c85:	8d 50 01             	lea    0x1(%rax),%edx
  804c88:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804c8f:	48 63 d2             	movslq %edx,%rdx
  804c92:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804c99:	00 

	va_start(vl, arg0);
  804c9a:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  804ca1:	00 00 00 
  804ca4:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  804cab:	00 00 00 
  804cae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804cb2:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  804cb9:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  804cc0:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804cc7:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  804cce:	00 00 00 
  804cd1:	eb 63                	jmp    804d36 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  804cd3:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  804cd9:	8d 70 01             	lea    0x1(%rax),%esi
  804cdc:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804ce2:	83 f8 30             	cmp    $0x30,%eax
  804ce5:	73 23                	jae    804d0a <spawnl+0x1eb>
  804ce7:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  804cee:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  804cf4:	89 c0                	mov    %eax,%eax
  804cf6:	48 01 d0             	add    %rdx,%rax
  804cf9:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  804cff:	83 c2 08             	add    $0x8,%edx
  804d02:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  804d08:	eb 15                	jmp    804d1f <spawnl+0x200>
  804d0a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804d11:	48 89 d0             	mov    %rdx,%rax
  804d14:	48 83 c2 08          	add    $0x8,%rdx
  804d18:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  804d1f:	48 8b 08             	mov    (%rax),%rcx
  804d22:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804d29:	89 f2                	mov    %esi,%edx
  804d2b:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804d2f:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  804d36:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  804d3c:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  804d42:	77 8f                	ja     804cd3 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804d44:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  804d4b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804d52:	48 89 d6             	mov    %rdx,%rsi
  804d55:	48 89 c7             	mov    %rax,%rdi
  804d58:	48 b8 ac 47 80 00 00 	movabs $0x8047ac,%rax
  804d5f:	00 00 00 
  804d62:	ff d0                	callq  *%rax
  804d64:	48 89 dc             	mov    %rbx,%rsp
}
  804d67:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804d6b:	c9                   	leaveq 
  804d6c:	c3                   	retq   

0000000000804d6d <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804d6d:	55                   	push   %rbp
  804d6e:	48 89 e5             	mov    %rsp,%rbp
  804d71:	48 83 ec 50          	sub    $0x50,%rsp
  804d75:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804d78:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804d7c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804d80:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d87:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804d88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804d8f:	eb 2c                	jmp    804dbd <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  804d91:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d94:	48 98                	cltq   
  804d96:	48 c1 e0 03          	shl    $0x3,%rax
  804d9a:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804d9e:	48 8b 00             	mov    (%rax),%rax
  804da1:	48 89 c7             	mov    %rax,%rdi
  804da4:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  804dab:	00 00 00 
  804dae:	ff d0                	callq  *%rax
  804db0:	83 c0 01             	add    $0x1,%eax
  804db3:	48 98                	cltq   
  804db5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804db9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804dbd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dc0:	48 98                	cltq   
  804dc2:	48 c1 e0 03          	shl    $0x3,%rax
  804dc6:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804dca:	48 8b 00             	mov    (%rax),%rax
  804dcd:	48 85 c0             	test   %rax,%rax
  804dd0:	75 bf                	jne    804d91 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804dd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dd6:	48 f7 d8             	neg    %rax
  804dd9:	48 05 00 10 40 00    	add    $0x401000,%rax
  804ddf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804de7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804deb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804def:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804df3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804df6:	83 c2 01             	add    $0x1,%edx
  804df9:	c1 e2 03             	shl    $0x3,%edx
  804dfc:	48 63 d2             	movslq %edx,%rdx
  804dff:	48 f7 da             	neg    %rdx
  804e02:	48 01 d0             	add    %rdx,%rax
  804e05:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804e09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e0d:	48 83 e8 10          	sub    $0x10,%rax
  804e11:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804e17:	77 0a                	ja     804e23 <init_stack+0xb6>
		return -E_NO_MEM;
  804e19:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804e1e:	e9 b8 01 00 00       	jmpq   804fdb <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804e23:	ba 07 00 00 00       	mov    $0x7,%edx
  804e28:	be 00 00 40 00       	mov    $0x400000,%esi
  804e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  804e32:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  804e39:	00 00 00 
  804e3c:	ff d0                	callq  *%rax
  804e3e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e41:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e45:	79 08                	jns    804e4f <init_stack+0xe2>
		return r;
  804e47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e4a:	e9 8c 01 00 00       	jmpq   804fdb <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804e56:	eb 73                	jmp    804ecb <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  804e58:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e5b:	48 98                	cltq   
  804e5d:	48 c1 e0 03          	shl    $0x3,%rax
  804e61:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804e65:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  804e6a:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  804e6e:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804e75:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  804e78:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e7b:	48 98                	cltq   
  804e7d:	48 c1 e0 03          	shl    $0x3,%rax
  804e81:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804e85:	48 8b 10             	mov    (%rax),%rdx
  804e88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e8c:	48 89 d6             	mov    %rdx,%rsi
  804e8f:	48 89 c7             	mov    %rax,%rdi
  804e92:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  804e99:	00 00 00 
  804e9c:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804e9e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ea1:	48 98                	cltq   
  804ea3:	48 c1 e0 03          	shl    $0x3,%rax
  804ea7:	48 03 45 c0          	add    -0x40(%rbp),%rax
  804eab:	48 8b 00             	mov    (%rax),%rax
  804eae:	48 89 c7             	mov    %rax,%rdi
  804eb1:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  804eb8:	00 00 00 
  804ebb:	ff d0                	callq  *%rax
  804ebd:	48 98                	cltq   
  804ebf:	48 83 c0 01          	add    $0x1,%rax
  804ec3:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804ec7:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804ecb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ece:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804ed1:	7c 85                	jl     804e58 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804ed3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ed6:	48 98                	cltq   
  804ed8:	48 c1 e0 03          	shl    $0x3,%rax
  804edc:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804ee0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804ee7:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804eee:	00 
  804eef:	74 35                	je     804f26 <init_stack+0x1b9>
  804ef1:	48 b9 80 6f 80 00 00 	movabs $0x806f80,%rcx
  804ef8:	00 00 00 
  804efb:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  804f02:	00 00 00 
  804f05:	be f1 00 00 00       	mov    $0xf1,%esi
  804f0a:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  804f11:	00 00 00 
  804f14:	b8 00 00 00 00       	mov    $0x0,%eax
  804f19:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  804f20:	00 00 00 
  804f23:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804f26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f2a:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804f2e:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  804f33:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804f37:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f3d:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804f40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f44:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804f48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f4b:	48 98                	cltq   
  804f4d:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804f50:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  804f55:	48 03 45 d0          	add    -0x30(%rbp),%rax
  804f59:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f5f:	48 89 c2             	mov    %rax,%rdx
  804f62:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f66:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804f69:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f6c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804f72:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f77:	89 c2                	mov    %eax,%edx
  804f79:	be 00 00 40 00       	mov    $0x400000,%esi
  804f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  804f83:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  804f8a:	00 00 00 
  804f8d:	ff d0                	callq  *%rax
  804f8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f92:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f96:	78 26                	js     804fbe <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804f98:	be 00 00 40 00       	mov    $0x400000,%esi
  804f9d:	bf 00 00 00 00       	mov    $0x0,%edi
  804fa2:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  804fa9:	00 00 00 
  804fac:	ff d0                	callq  *%rax
  804fae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fb5:	78 0a                	js     804fc1 <init_stack+0x254>
		goto error;

	return 0;
  804fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  804fbc:	eb 1d                	jmp    804fdb <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  804fbe:	90                   	nop
  804fbf:	eb 01                	jmp    804fc2 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  804fc1:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  804fc2:	be 00 00 40 00       	mov    $0x400000,%esi
  804fc7:	bf 00 00 00 00       	mov    $0x0,%edi
  804fcc:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  804fd3:	00 00 00 
  804fd6:	ff d0                	callq  *%rax
	return r;
  804fd8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804fdb:	c9                   	leaveq 
  804fdc:	c3                   	retq   

0000000000804fdd <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804fdd:	55                   	push   %rbp
  804fde:	48 89 e5             	mov    %rsp,%rbp
  804fe1:	48 83 ec 50          	sub    $0x50,%rsp
  804fe5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804fe8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804fec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804ff0:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804ff3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804ff7:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804ffb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fff:	25 ff 0f 00 00       	and    $0xfff,%eax
  805004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80500b:	74 21                	je     80502e <map_segment+0x51>
		va -= i;
  80500d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805010:	48 98                	cltq   
  805012:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  805016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805019:	48 98                	cltq   
  80501b:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80501f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805022:	48 98                	cltq   
  805024:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  805028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502b:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80502e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805035:	e9 74 01 00 00       	jmpq   8051ae <map_segment+0x1d1>
		if (i >= filesz) {
  80503a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80503d:	48 98                	cltq   
  80503f:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805043:	72 38                	jb     80507d <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  805045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805048:	48 98                	cltq   
  80504a:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80504e:	48 89 c1             	mov    %rax,%rcx
  805051:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805054:	8b 55 10             	mov    0x10(%rbp),%edx
  805057:	48 89 ce             	mov    %rcx,%rsi
  80505a:	89 c7                	mov    %eax,%edi
  80505c:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  805063:	00 00 00 
  805066:	ff d0                	callq  *%rax
  805068:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80506b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80506f:	0f 89 32 01 00 00    	jns    8051a7 <map_segment+0x1ca>
				return r;
  805075:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805078:	e9 45 01 00 00       	jmpq   8051c2 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80507d:	ba 07 00 00 00       	mov    $0x7,%edx
  805082:	be 00 00 40 00       	mov    $0x400000,%esi
  805087:	bf 00 00 00 00       	mov    $0x0,%edi
  80508c:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  805093:	00 00 00 
  805096:	ff d0                	callq  *%rax
  805098:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80509b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80509f:	79 08                	jns    8050a9 <map_segment+0xcc>
				return r;
  8050a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050a4:	e9 19 01 00 00       	jmpq   8051c2 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8050a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050ac:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8050af:	01 c2                	add    %eax,%edx
  8050b1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8050b4:	89 d6                	mov    %edx,%esi
  8050b6:	89 c7                	mov    %eax,%edi
  8050b8:	48 b8 ba 3f 80 00 00 	movabs $0x803fba,%rax
  8050bf:	00 00 00 
  8050c2:	ff d0                	callq  *%rax
  8050c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050cb:	79 08                	jns    8050d5 <map_segment+0xf8>
				return r;
  8050cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050d0:	e9 ed 00 00 00       	jmpq   8051c2 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8050d5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8050dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050df:	48 98                	cltq   
  8050e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8050e5:	48 89 d1             	mov    %rdx,%rcx
  8050e8:	48 29 c1             	sub    %rax,%rcx
  8050eb:	48 89 c8             	mov    %rcx,%rax
  8050ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8050f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050f5:	48 63 d0             	movslq %eax,%rdx
  8050f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050fc:	48 39 c2             	cmp    %rax,%rdx
  8050ff:	48 0f 47 d0          	cmova  %rax,%rdx
  805103:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805106:	be 00 00 40 00       	mov    $0x400000,%esi
  80510b:	89 c7                	mov    %eax,%edi
  80510d:	48 b8 6d 3e 80 00 00 	movabs $0x803e6d,%rax
  805114:	00 00 00 
  805117:	ff d0                	callq  *%rax
  805119:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80511c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805120:	79 08                	jns    80512a <map_segment+0x14d>
				return r;
  805122:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805125:	e9 98 00 00 00       	jmpq   8051c2 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80512a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80512d:	48 98                	cltq   
  80512f:	48 03 45 d0          	add    -0x30(%rbp),%rax
  805133:	48 89 c2             	mov    %rax,%rdx
  805136:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805139:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80513d:	48 89 d1             	mov    %rdx,%rcx
  805140:	89 c2                	mov    %eax,%edx
  805142:	be 00 00 40 00       	mov    $0x400000,%esi
  805147:	bf 00 00 00 00       	mov    $0x0,%edi
  80514c:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  805153:	00 00 00 
  805156:	ff d0                	callq  *%rax
  805158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80515b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80515f:	79 30                	jns    805191 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  805161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805164:	89 c1                	mov    %eax,%ecx
  805166:	48 ba bb 6f 80 00 00 	movabs $0x806fbb,%rdx
  80516d:	00 00 00 
  805170:	be 24 01 00 00       	mov    $0x124,%esi
  805175:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  80517c:	00 00 00 
  80517f:	b8 00 00 00 00       	mov    $0x0,%eax
  805184:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  80518b:	00 00 00 
  80518e:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805191:	be 00 00 40 00       	mov    $0x400000,%esi
  805196:	bf 00 00 00 00       	mov    $0x0,%edi
  80519b:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  8051a2:	00 00 00 
  8051a5:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8051a7:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8051ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051b1:	48 98                	cltq   
  8051b3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8051b7:	0f 82 7d fe ff ff    	jb     80503a <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8051bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051c2:	c9                   	leaveq 
  8051c3:	c3                   	retq   

00000000008051c4 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8051c4:	55                   	push   %rbp
  8051c5:	48 89 e5             	mov    %rsp,%rbp
  8051c8:	48 83 ec 60          	sub    $0x60,%rsp
  8051cc:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  8051cf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  8051d6:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8051dd:	00 
    uint64_t each_pte = 0;
  8051de:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8051e5:	00 
    uint64_t each_pdpe = 0;
  8051e6:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8051ed:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8051ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051f5:	00 
  8051f6:	e9 a5 01 00 00       	jmpq   8053a0 <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  8051fb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805202:	01 00 00 
  805205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805209:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80520d:	83 e0 01             	and    $0x1,%eax
  805210:	84 c0                	test   %al,%al
  805212:	0f 84 73 01 00 00    	je     80538b <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  805218:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80521f:	00 
  805220:	e9 56 01 00 00       	jmpq   80537b <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  805225:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80522c:	01 00 00 
  80522f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805233:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805237:	83 e0 01             	and    $0x1,%eax
  80523a:	84 c0                	test   %al,%al
  80523c:	0f 84 1f 01 00 00    	je     805361 <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  805242:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805249:	00 
  80524a:	e9 02 01 00 00       	jmpq   805351 <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  80524f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805256:	01 00 00 
  805259:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80525d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805261:	83 e0 01             	and    $0x1,%eax
  805264:	84 c0                	test   %al,%al
  805266:	0f 84 cb 00 00 00    	je     805337 <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80526c:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  805273:	00 
  805274:	e9 ae 00 00 00       	jmpq   805327 <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  805279:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805280:	01 00 00 
  805283:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805287:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80528b:	25 00 04 00 00       	and    $0x400,%eax
  805290:	48 85 c0             	test   %rax,%rax
  805293:	0f 84 84 00 00 00    	je     80531d <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  805299:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052a0:	01 00 00 
  8052a3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8052a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8052b0:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  8052b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052b7:	48 c1 e0 0c          	shl    $0xc,%rax
  8052bb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  8052bf:	8b 75 c0             	mov    -0x40(%rbp),%esi
  8052c2:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8052c6:	8b 55 ac             	mov    -0x54(%rbp),%edx
  8052c9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8052cd:	41 89 f0             	mov    %esi,%r8d
  8052d0:	48 89 c6             	mov    %rax,%rsi
  8052d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8052d8:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  8052df:	00 00 00 
  8052e2:	ff d0                	callq  *%rax
  8052e4:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  8052e7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8052eb:	79 30                	jns    80531d <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  8052ed:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8052f0:	89 c1                	mov    %eax,%ecx
  8052f2:	48 ba d8 6f 80 00 00 	movabs $0x806fd8,%rdx
  8052f9:	00 00 00 
  8052fc:	be 48 01 00 00       	mov    $0x148,%esi
  805301:	48 bf 40 6f 80 00 00 	movabs $0x806f40,%rdi
  805308:	00 00 00 
  80530b:	b8 00 00 00 00       	mov    $0x0,%eax
  805310:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  805317:	00 00 00 
  80531a:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  80531d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  805322:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  805327:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80532e:	00 
  80532f:	0f 86 44 ff ff ff    	jbe    805279 <copy_shared_pages+0xb5>
  805335:	eb 10                	jmp    805347 <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  805337:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80533b:	48 83 c0 01          	add    $0x1,%rax
  80533f:	48 c1 e0 09          	shl    $0x9,%rax
  805343:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  805347:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80534c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  805351:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  805358:	00 
  805359:	0f 86 f0 fe ff ff    	jbe    80524f <copy_shared_pages+0x8b>
  80535f:	eb 10                	jmp    805371 <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  805361:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805365:	48 83 c0 01          	add    $0x1,%rax
  805369:	48 c1 e0 09          	shl    $0x9,%rax
  80536d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  805371:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  805376:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80537b:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  805382:	00 
  805383:	0f 86 9c fe ff ff    	jbe    805225 <copy_shared_pages+0x61>
  805389:	eb 10                	jmp    80539b <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  80538b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80538f:	48 83 c0 01          	add    $0x1,%rax
  805393:	48 c1 e0 09          	shl    $0x9,%rax
  805397:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  80539b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8053a0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8053a5:	0f 84 50 fe ff ff    	je     8051fb <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  8053ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053b0:	c9                   	leaveq 
  8053b1:	c3                   	retq   
	...

00000000008053b4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8053b4:	55                   	push   %rbp
  8053b5:	48 89 e5             	mov    %rsp,%rbp
  8053b8:	48 83 ec 20          	sub    $0x20,%rsp
  8053bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8053bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8053c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053c6:	48 89 d6             	mov    %rdx,%rsi
  8053c9:	89 c7                	mov    %eax,%edi
  8053cb:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  8053d2:	00 00 00 
  8053d5:	ff d0                	callq  *%rax
  8053d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053de:	79 05                	jns    8053e5 <fd2sockid+0x31>
		return r;
  8053e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053e3:	eb 24                	jmp    805409 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8053e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053e9:	8b 10                	mov    (%rax),%edx
  8053eb:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  8053f2:	00 00 00 
  8053f5:	8b 00                	mov    (%rax),%eax
  8053f7:	39 c2                	cmp    %eax,%edx
  8053f9:	74 07                	je     805402 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8053fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805400:	eb 07                	jmp    805409 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  805402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805406:	8b 40 0c             	mov    0xc(%rax),%eax
}
  805409:	c9                   	leaveq 
  80540a:	c3                   	retq   

000000000080540b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80540b:	55                   	push   %rbp
  80540c:	48 89 e5             	mov    %rsp,%rbp
  80540f:	48 83 ec 20          	sub    $0x20,%rsp
  805413:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  805416:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80541a:	48 89 c7             	mov    %rax,%rdi
  80541d:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  805424:	00 00 00 
  805427:	ff d0                	callq  *%rax
  805429:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80542c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805430:	78 26                	js     805458 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  805432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805436:	ba 07 04 00 00       	mov    $0x407,%edx
  80543b:	48 89 c6             	mov    %rax,%rsi
  80543e:	bf 00 00 00 00       	mov    $0x0,%edi
  805443:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  80544a:	00 00 00 
  80544d:	ff d0                	callq  *%rax
  80544f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805452:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805456:	79 16                	jns    80546e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  805458:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80545b:	89 c7                	mov    %eax,%edi
  80545d:	48 b8 18 59 80 00 00 	movabs $0x805918,%rax
  805464:	00 00 00 
  805467:	ff d0                	callq  *%rax
		return r;
  805469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80546c:	eb 3a                	jmp    8054a8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80546e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805472:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  805479:	00 00 00 
  80547c:	8b 12                	mov    (%rdx),%edx
  80547e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805484:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80548b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80548f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805492:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  805495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805499:	48 89 c7             	mov    %rax,%rdi
  80549c:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  8054a3:	00 00 00 
  8054a6:	ff d0                	callq  *%rax
}
  8054a8:	c9                   	leaveq 
  8054a9:	c3                   	retq   

00000000008054aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8054aa:	55                   	push   %rbp
  8054ab:	48 89 e5             	mov    %rsp,%rbp
  8054ae:	48 83 ec 30          	sub    $0x30,%rsp
  8054b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8054b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8054b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8054bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054c0:	89 c7                	mov    %eax,%edi
  8054c2:	48 b8 b4 53 80 00 00 	movabs $0x8053b4,%rax
  8054c9:	00 00 00 
  8054cc:	ff d0                	callq  *%rax
  8054ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054d5:	79 05                	jns    8054dc <accept+0x32>
		return r;
  8054d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054da:	eb 3b                	jmp    805517 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8054dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8054e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8054e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e7:	48 89 ce             	mov    %rcx,%rsi
  8054ea:	89 c7                	mov    %eax,%edi
  8054ec:	48 b8 f5 57 80 00 00 	movabs $0x8057f5,%rax
  8054f3:	00 00 00 
  8054f6:	ff d0                	callq  *%rax
  8054f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054ff:	79 05                	jns    805506 <accept+0x5c>
		return r;
  805501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805504:	eb 11                	jmp    805517 <accept+0x6d>
	return alloc_sockfd(r);
  805506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805509:	89 c7                	mov    %eax,%edi
  80550b:	48 b8 0b 54 80 00 00 	movabs $0x80540b,%rax
  805512:	00 00 00 
  805515:	ff d0                	callq  *%rax
}
  805517:	c9                   	leaveq 
  805518:	c3                   	retq   

0000000000805519 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805519:	55                   	push   %rbp
  80551a:	48 89 e5             	mov    %rsp,%rbp
  80551d:	48 83 ec 20          	sub    $0x20,%rsp
  805521:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805524:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805528:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80552b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80552e:	89 c7                	mov    %eax,%edi
  805530:	48 b8 b4 53 80 00 00 	movabs $0x8053b4,%rax
  805537:	00 00 00 
  80553a:	ff d0                	callq  *%rax
  80553c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80553f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805543:	79 05                	jns    80554a <bind+0x31>
		return r;
  805545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805548:	eb 1b                	jmp    805565 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80554a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80554d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805554:	48 89 ce             	mov    %rcx,%rsi
  805557:	89 c7                	mov    %eax,%edi
  805559:	48 b8 74 58 80 00 00 	movabs $0x805874,%rax
  805560:	00 00 00 
  805563:	ff d0                	callq  *%rax
}
  805565:	c9                   	leaveq 
  805566:	c3                   	retq   

0000000000805567 <shutdown>:

int
shutdown(int s, int how)
{
  805567:	55                   	push   %rbp
  805568:	48 89 e5             	mov    %rsp,%rbp
  80556b:	48 83 ec 20          	sub    $0x20,%rsp
  80556f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805572:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805575:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805578:	89 c7                	mov    %eax,%edi
  80557a:	48 b8 b4 53 80 00 00 	movabs $0x8053b4,%rax
  805581:	00 00 00 
  805584:	ff d0                	callq  *%rax
  805586:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805589:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80558d:	79 05                	jns    805594 <shutdown+0x2d>
		return r;
  80558f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805592:	eb 16                	jmp    8055aa <shutdown+0x43>
	return nsipc_shutdown(r, how);
  805594:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80559a:	89 d6                	mov    %edx,%esi
  80559c:	89 c7                	mov    %eax,%edi
  80559e:	48 b8 d8 58 80 00 00 	movabs $0x8058d8,%rax
  8055a5:	00 00 00 
  8055a8:	ff d0                	callq  *%rax
}
  8055aa:	c9                   	leaveq 
  8055ab:	c3                   	retq   

00000000008055ac <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8055ac:	55                   	push   %rbp
  8055ad:	48 89 e5             	mov    %rsp,%rbp
  8055b0:	48 83 ec 10          	sub    $0x10,%rsp
  8055b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8055b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055bc:	48 89 c7             	mov    %rax,%rdi
  8055bf:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  8055c6:	00 00 00 
  8055c9:	ff d0                	callq  *%rax
  8055cb:	83 f8 01             	cmp    $0x1,%eax
  8055ce:	75 17                	jne    8055e7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8055d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055d4:	8b 40 0c             	mov    0xc(%rax),%eax
  8055d7:	89 c7                	mov    %eax,%edi
  8055d9:	48 b8 18 59 80 00 00 	movabs $0x805918,%rax
  8055e0:	00 00 00 
  8055e3:	ff d0                	callq  *%rax
  8055e5:	eb 05                	jmp    8055ec <devsock_close+0x40>
	else
		return 0;
  8055e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055ec:	c9                   	leaveq 
  8055ed:	c3                   	retq   

00000000008055ee <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8055ee:	55                   	push   %rbp
  8055ef:	48 89 e5             	mov    %rsp,%rbp
  8055f2:	48 83 ec 20          	sub    $0x20,%rsp
  8055f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8055fd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805600:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805603:	89 c7                	mov    %eax,%edi
  805605:	48 b8 b4 53 80 00 00 	movabs $0x8053b4,%rax
  80560c:	00 00 00 
  80560f:	ff d0                	callq  *%rax
  805611:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805614:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805618:	79 05                	jns    80561f <connect+0x31>
		return r;
  80561a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80561d:	eb 1b                	jmp    80563a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80561f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805622:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805629:	48 89 ce             	mov    %rcx,%rsi
  80562c:	89 c7                	mov    %eax,%edi
  80562e:	48 b8 45 59 80 00 00 	movabs $0x805945,%rax
  805635:	00 00 00 
  805638:	ff d0                	callq  *%rax
}
  80563a:	c9                   	leaveq 
  80563b:	c3                   	retq   

000000000080563c <listen>:

int
listen(int s, int backlog)
{
  80563c:	55                   	push   %rbp
  80563d:	48 89 e5             	mov    %rsp,%rbp
  805640:	48 83 ec 20          	sub    $0x20,%rsp
  805644:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805647:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80564a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80564d:	89 c7                	mov    %eax,%edi
  80564f:	48 b8 b4 53 80 00 00 	movabs $0x8053b4,%rax
  805656:	00 00 00 
  805659:	ff d0                	callq  *%rax
  80565b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80565e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805662:	79 05                	jns    805669 <listen+0x2d>
		return r;
  805664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805667:	eb 16                	jmp    80567f <listen+0x43>
	return nsipc_listen(r, backlog);
  805669:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80566c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80566f:	89 d6                	mov    %edx,%esi
  805671:	89 c7                	mov    %eax,%edi
  805673:	48 b8 a9 59 80 00 00 	movabs $0x8059a9,%rax
  80567a:	00 00 00 
  80567d:	ff d0                	callq  *%rax
}
  80567f:	c9                   	leaveq 
  805680:	c3                   	retq   

0000000000805681 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  805681:	55                   	push   %rbp
  805682:	48 89 e5             	mov    %rsp,%rbp
  805685:	48 83 ec 20          	sub    $0x20,%rsp
  805689:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80568d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805691:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  805695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805699:	89 c2                	mov    %eax,%edx
  80569b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80569f:	8b 40 0c             	mov    0xc(%rax),%eax
  8056a2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8056a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8056ab:	89 c7                	mov    %eax,%edi
  8056ad:	48 b8 e9 59 80 00 00 	movabs $0x8059e9,%rax
  8056b4:	00 00 00 
  8056b7:	ff d0                	callq  *%rax
}
  8056b9:	c9                   	leaveq 
  8056ba:	c3                   	retq   

00000000008056bb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8056bb:	55                   	push   %rbp
  8056bc:	48 89 e5             	mov    %rsp,%rbp
  8056bf:	48 83 ec 20          	sub    $0x20,%rsp
  8056c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8056c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8056cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8056cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056d3:	89 c2                	mov    %eax,%edx
  8056d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056d9:	8b 40 0c             	mov    0xc(%rax),%eax
  8056dc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8056e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8056e5:	89 c7                	mov    %eax,%edi
  8056e7:	48 b8 b5 5a 80 00 00 	movabs $0x805ab5,%rax
  8056ee:	00 00 00 
  8056f1:	ff d0                	callq  *%rax
}
  8056f3:	c9                   	leaveq 
  8056f4:	c3                   	retq   

00000000008056f5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8056f5:	55                   	push   %rbp
  8056f6:	48 89 e5             	mov    %rsp,%rbp
  8056f9:	48 83 ec 10          	sub    $0x10,%rsp
  8056fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805701:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805709:	48 be f6 6f 80 00 00 	movabs $0x806ff6,%rsi
  805710:	00 00 00 
  805713:	48 89 c7             	mov    %rax,%rdi
  805716:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  80571d:	00 00 00 
  805720:	ff d0                	callq  *%rax
	return 0;
  805722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805727:	c9                   	leaveq 
  805728:	c3                   	retq   

0000000000805729 <socket>:

int
socket(int domain, int type, int protocol)
{
  805729:	55                   	push   %rbp
  80572a:	48 89 e5             	mov    %rsp,%rbp
  80572d:	48 83 ec 20          	sub    $0x20,%rsp
  805731:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805734:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805737:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80573a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80573d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805740:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805743:	89 ce                	mov    %ecx,%esi
  805745:	89 c7                	mov    %eax,%edi
  805747:	48 b8 6d 5b 80 00 00 	movabs $0x805b6d,%rax
  80574e:	00 00 00 
  805751:	ff d0                	callq  *%rax
  805753:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805756:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80575a:	79 05                	jns    805761 <socket+0x38>
		return r;
  80575c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80575f:	eb 11                	jmp    805772 <socket+0x49>
	return alloc_sockfd(r);
  805761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805764:	89 c7                	mov    %eax,%edi
  805766:	48 b8 0b 54 80 00 00 	movabs $0x80540b,%rax
  80576d:	00 00 00 
  805770:	ff d0                	callq  *%rax
}
  805772:	c9                   	leaveq 
  805773:	c3                   	retq   

0000000000805774 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805774:	55                   	push   %rbp
  805775:	48 89 e5             	mov    %rsp,%rbp
  805778:	48 83 ec 10          	sub    $0x10,%rsp
  80577c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80577f:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805786:	00 00 00 
  805789:	8b 00                	mov    (%rax),%eax
  80578b:	85 c0                	test   %eax,%eax
  80578d:	75 1d                	jne    8057ac <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80578f:	bf 02 00 00 00       	mov    $0x2,%edi
  805794:	48 b8 e6 64 80 00 00 	movabs $0x8064e6,%rax
  80579b:	00 00 00 
  80579e:	ff d0                	callq  *%rax
  8057a0:	48 ba 24 a4 80 00 00 	movabs $0x80a424,%rdx
  8057a7:	00 00 00 
  8057aa:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8057ac:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  8057b3:	00 00 00 
  8057b6:	8b 00                	mov    (%rax),%eax
  8057b8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8057bb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8057c0:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  8057c7:	00 00 00 
  8057ca:	89 c7                	mov    %eax,%edi
  8057cc:	48 b8 37 64 80 00 00 	movabs $0x806437,%rax
  8057d3:	00 00 00 
  8057d6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8057d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8057dd:	be 00 00 00 00       	mov    $0x0,%esi
  8057e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8057e7:	48 b8 50 63 80 00 00 	movabs $0x806350,%rax
  8057ee:	00 00 00 
  8057f1:	ff d0                	callq  *%rax
}
  8057f3:	c9                   	leaveq 
  8057f4:	c3                   	retq   

00000000008057f5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8057f5:	55                   	push   %rbp
  8057f6:	48 89 e5             	mov    %rsp,%rbp
  8057f9:	48 83 ec 30          	sub    $0x30,%rsp
  8057fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805800:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805804:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805808:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80580f:	00 00 00 
  805812:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805815:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805817:	bf 01 00 00 00       	mov    $0x1,%edi
  80581c:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  805823:	00 00 00 
  805826:	ff d0                	callq  *%rax
  805828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80582b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80582f:	78 3e                	js     80586f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805831:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805838:	00 00 00 
  80583b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80583f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805843:	8b 40 10             	mov    0x10(%rax),%eax
  805846:	89 c2                	mov    %eax,%edx
  805848:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80584c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805850:	48 89 ce             	mov    %rcx,%rsi
  805853:	48 89 c7             	mov    %rax,%rdi
  805856:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  80585d:	00 00 00 
  805860:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805866:	8b 50 10             	mov    0x10(%rax),%edx
  805869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80586d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80586f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805872:	c9                   	leaveq 
  805873:	c3                   	retq   

0000000000805874 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805874:	55                   	push   %rbp
  805875:	48 89 e5             	mov    %rsp,%rbp
  805878:	48 83 ec 10          	sub    $0x10,%rsp
  80587c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80587f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805883:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805886:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80588d:	00 00 00 
  805890:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805893:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805895:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80589c:	48 89 c6             	mov    %rax,%rsi
  80589f:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8058a6:	00 00 00 
  8058a9:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  8058b0:	00 00 00 
  8058b3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8058b5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058bc:	00 00 00 
  8058bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8058c2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8058c5:	bf 02 00 00 00       	mov    $0x2,%edi
  8058ca:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  8058d1:	00 00 00 
  8058d4:	ff d0                	callq  *%rax
}
  8058d6:	c9                   	leaveq 
  8058d7:	c3                   	retq   

00000000008058d8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8058d8:	55                   	push   %rbp
  8058d9:	48 89 e5             	mov    %rsp,%rbp
  8058dc:	48 83 ec 10          	sub    $0x10,%rsp
  8058e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8058e3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8058e6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058ed:	00 00 00 
  8058f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8058f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8058f5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8058fc:	00 00 00 
  8058ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805902:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805905:	bf 03 00 00 00       	mov    $0x3,%edi
  80590a:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  805911:	00 00 00 
  805914:	ff d0                	callq  *%rax
}
  805916:	c9                   	leaveq 
  805917:	c3                   	retq   

0000000000805918 <nsipc_close>:

int
nsipc_close(int s)
{
  805918:	55                   	push   %rbp
  805919:	48 89 e5             	mov    %rsp,%rbp
  80591c:	48 83 ec 10          	sub    $0x10,%rsp
  805920:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805923:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80592a:	00 00 00 
  80592d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805930:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805932:	bf 04 00 00 00       	mov    $0x4,%edi
  805937:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  80593e:	00 00 00 
  805941:	ff d0                	callq  *%rax
}
  805943:	c9                   	leaveq 
  805944:	c3                   	retq   

0000000000805945 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805945:	55                   	push   %rbp
  805946:	48 89 e5             	mov    %rsp,%rbp
  805949:	48 83 ec 10          	sub    $0x10,%rsp
  80594d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805950:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805954:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805957:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80595e:	00 00 00 
  805961:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805964:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805966:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80596d:	48 89 c6             	mov    %rax,%rsi
  805970:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805977:	00 00 00 
  80597a:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  805981:	00 00 00 
  805984:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805986:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80598d:	00 00 00 
  805990:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805993:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805996:	bf 05 00 00 00       	mov    $0x5,%edi
  80599b:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  8059a2:	00 00 00 
  8059a5:	ff d0                	callq  *%rax
}
  8059a7:	c9                   	leaveq 
  8059a8:	c3                   	retq   

00000000008059a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8059a9:	55                   	push   %rbp
  8059aa:	48 89 e5             	mov    %rsp,%rbp
  8059ad:	48 83 ec 10          	sub    $0x10,%rsp
  8059b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8059b4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8059b7:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8059be:	00 00 00 
  8059c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8059c4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8059c6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8059cd:	00 00 00 
  8059d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8059d3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8059d6:	bf 06 00 00 00       	mov    $0x6,%edi
  8059db:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  8059e2:	00 00 00 
  8059e5:	ff d0                	callq  *%rax
}
  8059e7:	c9                   	leaveq 
  8059e8:	c3                   	retq   

00000000008059e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8059e9:	55                   	push   %rbp
  8059ea:	48 89 e5             	mov    %rsp,%rbp
  8059ed:	48 83 ec 30          	sub    $0x30,%rsp
  8059f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059f8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8059fb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8059fe:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a05:	00 00 00 
  805a08:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805a0b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805a0d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a14:	00 00 00 
  805a17:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805a1a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805a1d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a24:	00 00 00 
  805a27:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805a2a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805a2d:	bf 07 00 00 00       	mov    $0x7,%edi
  805a32:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  805a39:	00 00 00 
  805a3c:	ff d0                	callq  *%rax
  805a3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a45:	78 69                	js     805ab0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805a47:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805a4e:	7f 08                	jg     805a58 <nsipc_recv+0x6f>
  805a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a53:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805a56:	7e 35                	jle    805a8d <nsipc_recv+0xa4>
  805a58:	48 b9 fd 6f 80 00 00 	movabs $0x806ffd,%rcx
  805a5f:	00 00 00 
  805a62:	48 ba 12 70 80 00 00 	movabs $0x807012,%rdx
  805a69:	00 00 00 
  805a6c:	be 61 00 00 00       	mov    $0x61,%esi
  805a71:	48 bf 27 70 80 00 00 	movabs $0x807027,%rdi
  805a78:	00 00 00 
  805a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  805a80:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  805a87:	00 00 00 
  805a8a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a90:	48 63 d0             	movslq %eax,%rdx
  805a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a97:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805a9e:	00 00 00 
  805aa1:	48 89 c7             	mov    %rax,%rdi
  805aa4:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  805aab:	00 00 00 
  805aae:	ff d0                	callq  *%rax
	}

	return r;
  805ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805ab3:	c9                   	leaveq 
  805ab4:	c3                   	retq   

0000000000805ab5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805ab5:	55                   	push   %rbp
  805ab6:	48 89 e5             	mov    %rsp,%rbp
  805ab9:	48 83 ec 20          	sub    $0x20,%rsp
  805abd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ac0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805ac4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805ac7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805aca:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ad1:	00 00 00 
  805ad4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805ad7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805ad9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805ae0:	7e 35                	jle    805b17 <nsipc_send+0x62>
  805ae2:	48 b9 33 70 80 00 00 	movabs $0x807033,%rcx
  805ae9:	00 00 00 
  805aec:	48 ba 12 70 80 00 00 	movabs $0x807012,%rdx
  805af3:	00 00 00 
  805af6:	be 6c 00 00 00       	mov    $0x6c,%esi
  805afb:	48 bf 27 70 80 00 00 	movabs $0x807027,%rdi
  805b02:	00 00 00 
  805b05:	b8 00 00 00 00       	mov    $0x0,%eax
  805b0a:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  805b11:	00 00 00 
  805b14:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805b1a:	48 63 d0             	movslq %eax,%rdx
  805b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b21:	48 89 c6             	mov    %rax,%rsi
  805b24:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805b2b:	00 00 00 
  805b2e:	48 b8 d2 24 80 00 00 	movabs $0x8024d2,%rax
  805b35:	00 00 00 
  805b38:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805b3a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b41:	00 00 00 
  805b44:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b47:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805b4a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b51:	00 00 00 
  805b54:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805b57:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805b5a:	bf 08 00 00 00       	mov    $0x8,%edi
  805b5f:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  805b66:	00 00 00 
  805b69:	ff d0                	callq  *%rax
}
  805b6b:	c9                   	leaveq 
  805b6c:	c3                   	retq   

0000000000805b6d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805b6d:	55                   	push   %rbp
  805b6e:	48 89 e5             	mov    %rsp,%rbp
  805b71:	48 83 ec 10          	sub    $0x10,%rsp
  805b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805b78:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805b7b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  805b7e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b85:	00 00 00 
  805b88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b8b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  805b8d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b94:	00 00 00 
  805b97:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b9a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  805b9d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ba4:	00 00 00 
  805ba7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805baa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  805bad:	bf 09 00 00 00       	mov    $0x9,%edi
  805bb2:	48 b8 74 57 80 00 00 	movabs $0x805774,%rax
  805bb9:	00 00 00 
  805bbc:	ff d0                	callq  *%rax
}
  805bbe:	c9                   	leaveq 
  805bbf:	c3                   	retq   

0000000000805bc0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805bc0:	55                   	push   %rbp
  805bc1:	48 89 e5             	mov    %rsp,%rbp
  805bc4:	53                   	push   %rbx
  805bc5:	48 83 ec 38          	sub    $0x38,%rsp
  805bc9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805bcd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805bd1:	48 89 c7             	mov    %rax,%rdi
  805bd4:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  805bdb:	00 00 00 
  805bde:	ff d0                	callq  *%rax
  805be0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805be7:	0f 88 bf 01 00 00    	js     805dac <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805bed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805bf1:	ba 07 04 00 00       	mov    $0x407,%edx
  805bf6:	48 89 c6             	mov    %rax,%rsi
  805bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  805bfe:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  805c05:	00 00 00 
  805c08:	ff d0                	callq  *%rax
  805c0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c11:	0f 88 95 01 00 00    	js     805dac <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805c17:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805c1b:	48 89 c7             	mov    %rax,%rdi
  805c1e:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  805c25:	00 00 00 
  805c28:	ff d0                	callq  *%rax
  805c2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c31:	0f 88 5d 01 00 00    	js     805d94 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805c37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805c3b:	ba 07 04 00 00       	mov    $0x407,%edx
  805c40:	48 89 c6             	mov    %rax,%rsi
  805c43:	bf 00 00 00 00       	mov    $0x0,%edi
  805c48:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  805c4f:	00 00 00 
  805c52:	ff d0                	callq  *%rax
  805c54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c57:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c5b:	0f 88 33 01 00 00    	js     805d94 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c65:	48 89 c7             	mov    %rax,%rdi
  805c68:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  805c6f:	00 00 00 
  805c72:	ff d0                	callq  *%rax
  805c74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805c78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c7c:	ba 07 04 00 00       	mov    $0x407,%edx
  805c81:	48 89 c6             	mov    %rax,%rsi
  805c84:	bf 00 00 00 00       	mov    $0x0,%edi
  805c89:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  805c90:	00 00 00 
  805c93:	ff d0                	callq  *%rax
  805c95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805c9c:	0f 88 d9 00 00 00    	js     805d7b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805ca2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805ca6:	48 89 c7             	mov    %rax,%rdi
  805ca9:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  805cb0:	00 00 00 
  805cb3:	ff d0                	callq  *%rax
  805cb5:	48 89 c2             	mov    %rax,%rdx
  805cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cbc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805cc2:	48 89 d1             	mov    %rdx,%rcx
  805cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  805cca:	48 89 c6             	mov    %rax,%rsi
  805ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  805cd2:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  805cd9:	00 00 00 
  805cdc:	ff d0                	callq  *%rax
  805cde:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805ce1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805ce5:	78 79                	js     805d60 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805ce7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ceb:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805cf2:	00 00 00 
  805cf5:	8b 12                	mov    (%rdx),%edx
  805cf7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805cfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805d04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d08:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805d0f:	00 00 00 
  805d12:	8b 12                	mov    (%rdx),%edx
  805d14:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805d16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d1a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d25:	48 89 c7             	mov    %rax,%rdi
  805d28:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  805d2f:	00 00 00 
  805d32:	ff d0                	callq  *%rax
  805d34:	89 c2                	mov    %eax,%edx
  805d36:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805d3a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805d3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805d40:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805d44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d48:	48 89 c7             	mov    %rax,%rdi
  805d4b:	48 b8 7c 38 80 00 00 	movabs $0x80387c,%rax
  805d52:	00 00 00 
  805d55:	ff d0                	callq  *%rax
  805d57:	89 03                	mov    %eax,(%rbx)
	return 0;
  805d59:	b8 00 00 00 00       	mov    $0x0,%eax
  805d5e:	eb 4f                	jmp    805daf <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  805d60:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  805d61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d65:	48 89 c6             	mov    %rax,%rsi
  805d68:	bf 00 00 00 00       	mov    $0x0,%edi
  805d6d:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  805d74:	00 00 00 
  805d77:	ff d0                	callq  *%rax
  805d79:	eb 01                	jmp    805d7c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  805d7b:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805d7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d80:	48 89 c6             	mov    %rax,%rsi
  805d83:	bf 00 00 00 00       	mov    $0x0,%edi
  805d88:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  805d8f:	00 00 00 
  805d92:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805d94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d98:	48 89 c6             	mov    %rax,%rsi
  805d9b:	bf 00 00 00 00       	mov    $0x0,%edi
  805da0:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  805da7:	00 00 00 
  805daa:	ff d0                	callq  *%rax
err:
	return r;
  805dac:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805daf:	48 83 c4 38          	add    $0x38,%rsp
  805db3:	5b                   	pop    %rbx
  805db4:	5d                   	pop    %rbp
  805db5:	c3                   	retq   

0000000000805db6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805db6:	55                   	push   %rbp
  805db7:	48 89 e5             	mov    %rsp,%rbp
  805dba:	53                   	push   %rbx
  805dbb:	48 83 ec 28          	sub    $0x28,%rsp
  805dbf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805dc3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805dc7:	eb 01                	jmp    805dca <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  805dc9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805dca:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  805dd1:	00 00 00 
  805dd4:	48 8b 00             	mov    (%rax),%rax
  805dd7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805ddd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805de0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805de4:	48 89 c7             	mov    %rax,%rdi
  805de7:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  805dee:	00 00 00 
  805df1:	ff d0                	callq  *%rax
  805df3:	89 c3                	mov    %eax,%ebx
  805df5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805df9:	48 89 c7             	mov    %rax,%rdi
  805dfc:	48 b8 74 65 80 00 00 	movabs $0x806574,%rax
  805e03:	00 00 00 
  805e06:	ff d0                	callq  *%rax
  805e08:	39 c3                	cmp    %eax,%ebx
  805e0a:	0f 94 c0             	sete   %al
  805e0d:	0f b6 c0             	movzbl %al,%eax
  805e10:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805e13:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  805e1a:	00 00 00 
  805e1d:	48 8b 00             	mov    (%rax),%rax
  805e20:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805e26:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805e29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e2c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805e2f:	75 0a                	jne    805e3b <_pipeisclosed+0x85>
			return ret;
  805e31:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  805e34:	48 83 c4 28          	add    $0x28,%rsp
  805e38:	5b                   	pop    %rbx
  805e39:	5d                   	pop    %rbp
  805e3a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  805e3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e3e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805e41:	74 86                	je     805dc9 <_pipeisclosed+0x13>
  805e43:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805e47:	75 80                	jne    805dc9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805e49:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  805e50:	00 00 00 
  805e53:	48 8b 00             	mov    (%rax),%rax
  805e56:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805e5c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805e5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e62:	89 c6                	mov    %eax,%esi
  805e64:	48 bf 44 70 80 00 00 	movabs $0x807044,%rdi
  805e6b:	00 00 00 
  805e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  805e73:	49 b8 7f 14 80 00 00 	movabs $0x80147f,%r8
  805e7a:	00 00 00 
  805e7d:	41 ff d0             	callq  *%r8
	}
  805e80:	e9 44 ff ff ff       	jmpq   805dc9 <_pipeisclosed+0x13>

0000000000805e85 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  805e85:	55                   	push   %rbp
  805e86:	48 89 e5             	mov    %rsp,%rbp
  805e89:	48 83 ec 30          	sub    $0x30,%rsp
  805e8d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805e90:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805e94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805e97:	48 89 d6             	mov    %rdx,%rsi
  805e9a:	89 c7                	mov    %eax,%edi
  805e9c:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  805ea3:	00 00 00 
  805ea6:	ff d0                	callq  *%rax
  805ea8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805eab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805eaf:	79 05                	jns    805eb6 <pipeisclosed+0x31>
		return r;
  805eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805eb4:	eb 31                	jmp    805ee7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805eba:	48 89 c7             	mov    %rax,%rdi
  805ebd:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  805ec4:	00 00 00 
  805ec7:	ff d0                	callq  *%rax
  805ec9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ed1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805ed5:	48 89 d6             	mov    %rdx,%rsi
  805ed8:	48 89 c7             	mov    %rax,%rdi
  805edb:	48 b8 b6 5d 80 00 00 	movabs $0x805db6,%rax
  805ee2:	00 00 00 
  805ee5:	ff d0                	callq  *%rax
}
  805ee7:	c9                   	leaveq 
  805ee8:	c3                   	retq   

0000000000805ee9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805ee9:	55                   	push   %rbp
  805eea:	48 89 e5             	mov    %rsp,%rbp
  805eed:	48 83 ec 40          	sub    $0x40,%rsp
  805ef1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805ef5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805ef9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f01:	48 89 c7             	mov    %rax,%rdi
  805f04:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  805f0b:	00 00 00 
  805f0e:	ff d0                	callq  *%rax
  805f10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805f14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f18:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805f1c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805f23:	00 
  805f24:	e9 97 00 00 00       	jmpq   805fc0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805f29:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805f2e:	74 09                	je     805f39 <devpipe_read+0x50>
				return i;
  805f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f34:	e9 95 00 00 00       	jmpq   805fce <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805f39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f41:	48 89 d6             	mov    %rdx,%rsi
  805f44:	48 89 c7             	mov    %rax,%rdi
  805f47:	48 b8 b6 5d 80 00 00 	movabs $0x805db6,%rax
  805f4e:	00 00 00 
  805f51:	ff d0                	callq  *%rax
  805f53:	85 c0                	test   %eax,%eax
  805f55:	74 07                	je     805f5e <devpipe_read+0x75>
				return 0;
  805f57:	b8 00 00 00 00       	mov    $0x0,%eax
  805f5c:	eb 70                	jmp    805fce <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805f5e:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  805f65:	00 00 00 
  805f68:	ff d0                	callq  *%rax
  805f6a:	eb 01                	jmp    805f6d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805f6c:	90                   	nop
  805f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f71:	8b 10                	mov    (%rax),%edx
  805f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f77:	8b 40 04             	mov    0x4(%rax),%eax
  805f7a:	39 c2                	cmp    %eax,%edx
  805f7c:	74 ab                	je     805f29 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805f86:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f8e:	8b 00                	mov    (%rax),%eax
  805f90:	89 c2                	mov    %eax,%edx
  805f92:	c1 fa 1f             	sar    $0x1f,%edx
  805f95:	c1 ea 1b             	shr    $0x1b,%edx
  805f98:	01 d0                	add    %edx,%eax
  805f9a:	83 e0 1f             	and    $0x1f,%eax
  805f9d:	29 d0                	sub    %edx,%eax
  805f9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805fa3:	48 98                	cltq   
  805fa5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805faa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fb0:	8b 00                	mov    (%rax),%eax
  805fb2:	8d 50 01             	lea    0x1(%rax),%edx
  805fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fb9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805fbb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805fc4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805fc8:	72 a2                	jb     805f6c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805fce:	c9                   	leaveq 
  805fcf:	c3                   	retq   

0000000000805fd0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805fd0:	55                   	push   %rbp
  805fd1:	48 89 e5             	mov    %rsp,%rbp
  805fd4:	48 83 ec 40          	sub    $0x40,%rsp
  805fd8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805fdc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805fe0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fe8:	48 89 c7             	mov    %rax,%rdi
  805feb:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  805ff2:	00 00 00 
  805ff5:	ff d0                	callq  *%rax
  805ff7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805ffb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806003:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80600a:	00 
  80600b:	e9 93 00 00 00       	jmpq   8060a3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806010:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806018:	48 89 d6             	mov    %rdx,%rsi
  80601b:	48 89 c7             	mov    %rax,%rdi
  80601e:	48 b8 b6 5d 80 00 00 	movabs $0x805db6,%rax
  806025:	00 00 00 
  806028:	ff d0                	callq  *%rax
  80602a:	85 c0                	test   %eax,%eax
  80602c:	74 07                	je     806035 <devpipe_write+0x65>
				return 0;
  80602e:	b8 00 00 00 00       	mov    $0x0,%eax
  806033:	eb 7c                	jmp    8060b1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806035:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  80603c:	00 00 00 
  80603f:	ff d0                	callq  *%rax
  806041:	eb 01                	jmp    806044 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806043:	90                   	nop
  806044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806048:	8b 40 04             	mov    0x4(%rax),%eax
  80604b:	48 63 d0             	movslq %eax,%rdx
  80604e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806052:	8b 00                	mov    (%rax),%eax
  806054:	48 98                	cltq   
  806056:	48 83 c0 20          	add    $0x20,%rax
  80605a:	48 39 c2             	cmp    %rax,%rdx
  80605d:	73 b1                	jae    806010 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80605f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806063:	8b 40 04             	mov    0x4(%rax),%eax
  806066:	89 c2                	mov    %eax,%edx
  806068:	c1 fa 1f             	sar    $0x1f,%edx
  80606b:	c1 ea 1b             	shr    $0x1b,%edx
  80606e:	01 d0                	add    %edx,%eax
  806070:	83 e0 1f             	and    $0x1f,%eax
  806073:	29 d0                	sub    %edx,%eax
  806075:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806079:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80607d:	48 01 ca             	add    %rcx,%rdx
  806080:	0f b6 0a             	movzbl (%rdx),%ecx
  806083:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806087:	48 98                	cltq   
  806089:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80608d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806091:	8b 40 04             	mov    0x4(%rax),%eax
  806094:	8d 50 01             	lea    0x1(%rax),%edx
  806097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80609b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80609e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8060a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8060ab:	72 96                	jb     806043 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8060ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8060b1:	c9                   	leaveq 
  8060b2:	c3                   	retq   

00000000008060b3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8060b3:	55                   	push   %rbp
  8060b4:	48 89 e5             	mov    %rsp,%rbp
  8060b7:	48 83 ec 20          	sub    $0x20,%rsp
  8060bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8060bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8060c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060c7:	48 89 c7             	mov    %rax,%rdi
  8060ca:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  8060d1:	00 00 00 
  8060d4:	ff d0                	callq  *%rax
  8060d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8060da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8060de:	48 be 57 70 80 00 00 	movabs $0x807057,%rsi
  8060e5:	00 00 00 
  8060e8:	48 89 c7             	mov    %rax,%rdi
  8060eb:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  8060f2:	00 00 00 
  8060f5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8060f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060fb:	8b 50 04             	mov    0x4(%rax),%edx
  8060fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806102:	8b 00                	mov    (%rax),%eax
  806104:	29 c2                	sub    %eax,%edx
  806106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80610a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806114:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80611b:	00 00 00 
	stat->st_dev = &devpipe;
  80611e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806122:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806129:	00 00 00 
  80612c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  806133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806138:	c9                   	leaveq 
  806139:	c3                   	retq   

000000000080613a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80613a:	55                   	push   %rbp
  80613b:	48 89 e5             	mov    %rsp,%rbp
  80613e:	48 83 ec 10          	sub    $0x10,%rsp
  806142:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80614a:	48 89 c6             	mov    %rax,%rsi
  80614d:	bf 00 00 00 00       	mov    $0x0,%edi
  806152:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  806159:	00 00 00 
  80615c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80615e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806162:	48 89 c7             	mov    %rax,%rdi
  806165:	48 b8 9f 38 80 00 00 	movabs $0x80389f,%rax
  80616c:	00 00 00 
  80616f:	ff d0                	callq  *%rax
  806171:	48 89 c6             	mov    %rax,%rsi
  806174:	bf 00 00 00 00       	mov    $0x0,%edi
  806179:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  806180:	00 00 00 
  806183:	ff d0                	callq  *%rax
}
  806185:	c9                   	leaveq 
  806186:	c3                   	retq   
	...

0000000000806188 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  806188:	55                   	push   %rbp
  806189:	48 89 e5             	mov    %rsp,%rbp
  80618c:	48 83 ec 20          	sub    $0x20,%rsp
  806190:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  806193:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806197:	75 35                	jne    8061ce <wait+0x46>
  806199:	48 b9 5e 70 80 00 00 	movabs $0x80705e,%rcx
  8061a0:	00 00 00 
  8061a3:	48 ba 69 70 80 00 00 	movabs $0x807069,%rdx
  8061aa:	00 00 00 
  8061ad:	be 09 00 00 00       	mov    $0x9,%esi
  8061b2:	48 bf 7e 70 80 00 00 	movabs $0x80707e,%rdi
  8061b9:	00 00 00 
  8061bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8061c1:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  8061c8:	00 00 00 
  8061cb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8061ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061d1:	48 98                	cltq   
  8061d3:	48 89 c2             	mov    %rax,%rdx
  8061d6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8061dc:	48 89 d0             	mov    %rdx,%rax
  8061df:	48 c1 e0 02          	shl    $0x2,%rax
  8061e3:	48 01 d0             	add    %rdx,%rax
  8061e6:	48 01 c0             	add    %rax,%rax
  8061e9:	48 01 d0             	add    %rdx,%rax
  8061ec:	48 c1 e0 05          	shl    $0x5,%rax
  8061f0:	48 89 c2             	mov    %rax,%rdx
  8061f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8061fa:	00 00 00 
  8061fd:	48 01 d0             	add    %rdx,%rax
  806200:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  806204:	eb 0c                	jmp    806212 <wait+0x8a>
		sys_yield();
  806206:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  80620d:	00 00 00 
  806210:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  806212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806216:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80621c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80621f:	75 0e                	jne    80622f <wait+0xa7>
  806221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806225:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80622b:	85 c0                	test   %eax,%eax
  80622d:	75 d7                	jne    806206 <wait+0x7e>
		sys_yield();
}
  80622f:	c9                   	leaveq 
  806230:	c3                   	retq   
  806231:	00 00                	add    %al,(%rax)
	...

0000000000806234 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  806234:	55                   	push   %rbp
  806235:	48 89 e5             	mov    %rsp,%rbp
  806238:	48 83 ec 10          	sub    $0x10,%rsp
  80623c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  806240:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  806247:	00 00 00 
  80624a:	48 8b 00             	mov    (%rax),%rax
  80624d:	48 85 c0             	test   %rax,%rax
  806250:	75 66                	jne    8062b8 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  806252:	ba 07 00 00 00       	mov    $0x7,%edx
  806257:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80625c:	bf 00 00 00 00       	mov    $0x0,%edi
  806261:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  806268:	00 00 00 
  80626b:	ff d0                	callq  *%rax
  80626d:	85 c0                	test   %eax,%eax
  80626f:	75 1d                	jne    80628e <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  806271:	48 be cc 62 80 00 00 	movabs $0x8062cc,%rsi
  806278:	00 00 00 
  80627b:	bf 00 00 00 00       	mov    $0x0,%edi
  806280:	48 b8 72 2c 80 00 00 	movabs $0x802c72,%rax
  806287:	00 00 00 
  80628a:	ff d0                	callq  *%rax
  80628c:	eb 2a                	jmp    8062b8 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  80628e:	48 ba 89 70 80 00 00 	movabs $0x807089,%rdx
  806295:	00 00 00 
  806298:	be 23 00 00 00       	mov    $0x23,%esi
  80629d:	48 bf a7 70 80 00 00 	movabs $0x8070a7,%rdi
  8062a4:	00 00 00 
  8062a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8062ac:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  8062b3:	00 00 00 
  8062b6:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8062b8:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  8062bf:	00 00 00 
  8062c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8062c6:	48 89 10             	mov    %rdx,(%rax)
}
  8062c9:	c9                   	leaveq 
  8062ca:	c3                   	retq   
	...

00000000008062cc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8062cc:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8062cf:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  8062d6:	00 00 00 
call *%rax
  8062d9:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  8062db:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  8062df:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  8062e4:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  8062eb:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  8062ec:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  8062f0:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  8062f3:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  8062fa:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  8062fb:	4c 8b 3c 24          	mov    (%rsp),%r15
  8062ff:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806304:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  806309:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80630e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  806313:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806318:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80631d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  806322:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806327:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80632c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  806331:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  806336:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80633b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  806340:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806345:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  806349:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  80634d:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  80634e:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  80634f:	c3                   	retq   

0000000000806350 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  806350:	55                   	push   %rbp
  806351:	48 89 e5             	mov    %rsp,%rbp
  806354:	48 83 ec 30          	sub    $0x30,%rsp
  806358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80635c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806360:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  806364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80636b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806370:	74 18                	je     80638a <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  806372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806376:	48 89 c7             	mov    %rax,%rdi
  806379:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  806380:	00 00 00 
  806383:	ff d0                	callq  *%rax
  806385:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806388:	eb 19                	jmp    8063a3 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80638a:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  806391:	00 00 00 
  806394:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  80639b:	00 00 00 
  80639e:	ff d0                	callq  *%rax
  8063a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8063a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063a7:	79 39                	jns    8063e2 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8063a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8063ae:	75 08                	jne    8063b8 <ipc_recv+0x68>
  8063b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063b4:	8b 00                	mov    (%rax),%eax
  8063b6:	eb 05                	jmp    8063bd <ipc_recv+0x6d>
  8063b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8063bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8063c1:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8063c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8063c8:	75 08                	jne    8063d2 <ipc_recv+0x82>
  8063ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8063ce:	8b 00                	mov    (%rax),%eax
  8063d0:	eb 05                	jmp    8063d7 <ipc_recv+0x87>
  8063d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8063d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8063db:	89 02                	mov    %eax,(%rdx)
		return r;
  8063dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063e0:	eb 53                	jmp    806435 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  8063e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8063e7:	74 19                	je     806402 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  8063e9:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8063f0:	00 00 00 
  8063f3:	48 8b 00             	mov    (%rax),%rax
  8063f6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8063fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806400:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  806402:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806407:	74 19                	je     806422 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  806409:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806410:	00 00 00 
  806413:	48 8b 00             	mov    (%rax),%rax
  806416:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80641c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806420:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  806422:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806429:	00 00 00 
  80642c:	48 8b 00             	mov    (%rax),%rax
  80642f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  806435:	c9                   	leaveq 
  806436:	c3                   	retq   

0000000000806437 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806437:	55                   	push   %rbp
  806438:	48 89 e5             	mov    %rsp,%rbp
  80643b:	48 83 ec 30          	sub    $0x30,%rsp
  80643f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806442:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806445:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  806449:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  80644c:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  806453:	eb 59                	jmp    8064ae <ipc_send+0x77>
		if(pg) {
  806455:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80645a:	74 20                	je     80647c <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  80645c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80645f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  806462:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  806466:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806469:	89 c7                	mov    %eax,%edi
  80646b:	48 b8 bc 2c 80 00 00 	movabs $0x802cbc,%rax
  806472:	00 00 00 
  806475:	ff d0                	callq  *%rax
  806477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80647a:	eb 26                	jmp    8064a2 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  80647c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80647f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806482:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806485:	89 d1                	mov    %edx,%ecx
  806487:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80648e:	00 00 00 
  806491:	89 c7                	mov    %eax,%edi
  806493:	48 b8 bc 2c 80 00 00 	movabs $0x802cbc,%rax
  80649a:	00 00 00 
  80649d:	ff d0                	callq  *%rax
  80649f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8064a2:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  8064a9:	00 00 00 
  8064ac:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8064ae:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8064b2:	74 a1                	je     806455 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  8064b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064b8:	74 2a                	je     8064e4 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  8064ba:	48 ba b8 70 80 00 00 	movabs $0x8070b8,%rdx
  8064c1:	00 00 00 
  8064c4:	be 49 00 00 00       	mov    $0x49,%esi
  8064c9:	48 bf e3 70 80 00 00 	movabs $0x8070e3,%rdi
  8064d0:	00 00 00 
  8064d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8064d8:	48 b9 44 12 80 00 00 	movabs $0x801244,%rcx
  8064df:	00 00 00 
  8064e2:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  8064e4:	c9                   	leaveq 
  8064e5:	c3                   	retq   

00000000008064e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8064e6:	55                   	push   %rbp
  8064e7:	48 89 e5             	mov    %rsp,%rbp
  8064ea:	48 83 ec 18          	sub    $0x18,%rsp
  8064ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8064f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8064f8:	eb 6a                	jmp    806564 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  8064fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  806501:	00 00 00 
  806504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806507:	48 63 d0             	movslq %eax,%rdx
  80650a:	48 89 d0             	mov    %rdx,%rax
  80650d:	48 c1 e0 02          	shl    $0x2,%rax
  806511:	48 01 d0             	add    %rdx,%rax
  806514:	48 01 c0             	add    %rax,%rax
  806517:	48 01 d0             	add    %rdx,%rax
  80651a:	48 c1 e0 05          	shl    $0x5,%rax
  80651e:	48 01 c8             	add    %rcx,%rax
  806521:	48 05 d0 00 00 00    	add    $0xd0,%rax
  806527:	8b 00                	mov    (%rax),%eax
  806529:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80652c:	75 32                	jne    806560 <ipc_find_env+0x7a>
			return envs[i].env_id;
  80652e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  806535:	00 00 00 
  806538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80653b:	48 63 d0             	movslq %eax,%rdx
  80653e:	48 89 d0             	mov    %rdx,%rax
  806541:	48 c1 e0 02          	shl    $0x2,%rax
  806545:	48 01 d0             	add    %rdx,%rax
  806548:	48 01 c0             	add    %rax,%rax
  80654b:	48 01 d0             	add    %rdx,%rax
  80654e:	48 c1 e0 05          	shl    $0x5,%rax
  806552:	48 01 c8             	add    %rcx,%rax
  806555:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80655b:	8b 40 08             	mov    0x8(%rax),%eax
  80655e:	eb 12                	jmp    806572 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806560:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806564:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80656b:	7e 8d                	jle    8064fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80656d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806572:	c9                   	leaveq 
  806573:	c3                   	retq   

0000000000806574 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806574:	55                   	push   %rbp
  806575:	48 89 e5             	mov    %rsp,%rbp
  806578:	48 83 ec 18          	sub    $0x18,%rsp
  80657c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806584:	48 89 c2             	mov    %rax,%rdx
  806587:	48 c1 ea 15          	shr    $0x15,%rdx
  80658b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806592:	01 00 00 
  806595:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806599:	83 e0 01             	and    $0x1,%eax
  80659c:	48 85 c0             	test   %rax,%rax
  80659f:	75 07                	jne    8065a8 <pageref+0x34>
		return 0;
  8065a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8065a6:	eb 53                	jmp    8065fb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8065a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8065ac:	48 89 c2             	mov    %rax,%rdx
  8065af:	48 c1 ea 0c          	shr    $0xc,%rdx
  8065b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8065ba:	01 00 00 
  8065bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8065c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8065c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065c9:	83 e0 01             	and    $0x1,%eax
  8065cc:	48 85 c0             	test   %rax,%rax
  8065cf:	75 07                	jne    8065d8 <pageref+0x64>
		return 0;
  8065d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8065d6:	eb 23                	jmp    8065fb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8065d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065dc:	48 89 c2             	mov    %rax,%rdx
  8065df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8065e3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8065ea:	00 00 00 
  8065ed:	48 c1 e2 04          	shl    $0x4,%rdx
  8065f1:	48 01 d0             	add    %rdx,%rax
  8065f4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8065f8:	0f b7 c0             	movzwl %ax,%eax
}
  8065fb:	c9                   	leaveq 
  8065fc:	c3                   	retq   
