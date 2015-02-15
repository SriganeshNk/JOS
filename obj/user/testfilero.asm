
obj/user/testfilero.debug:     file format elf64-x86-64


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
  80003c:	e8 23 08 00 00       	callq  800864 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  800053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800057:	48 89 c6             	mov    %rax,%rsi
  80005a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800061:	00 00 00 
  800064:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800070:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800077:	00 00 00 
  80007a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
  800088:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a6:	00 00 00 
  8000a9:	be 01 00 00 00       	mov    $0x1,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 ab 24 80 00 00 	movabs $0x8024ab,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cb:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  8000d2:	00 00 00 
  8000d5:	ff d0                	callq  *%rax
}
  8000d7:	c9                   	leaveq 
  8000d8:	c3                   	retq   

00000000008000d9 <umain>:

void
umain(int argc, char **argv)
{
  8000d9:	55                   	push   %rbp
  8000da:	48 89 e5             	mov    %rsp,%rbp
  8000dd:	48 81 ec d0 02 00 00 	sub    $0x2d0,%rsp
  8000e4:	89 bd 3c fd ff ff    	mov    %edi,-0x2c4(%rbp)
  8000ea:	48 89 b5 30 fd ff ff 	mov    %rsi,-0x2d0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 66 43 80 00 00 	movabs $0x804366,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800112:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800117:	79 39                	jns    800152 <umain+0x79>
  800119:	48 83 7d f0 f4       	cmpq   $0xfffffffffffffff4,-0x10(%rbp)
  80011e:	74 32                	je     800152 <umain+0x79>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 71 43 80 00 00 	movabs $0x804371,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800157:	78 2a                	js     800183 <umain+0xaa>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf c1 43 80 00 00 	movabs $0x8043c1,%rdi
  80018f:	00 00 00 
  800192:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8001a4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x104>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba ca 43 80 00 00 	movabs $0x8043ca,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x128>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x128>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x152>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 15 44 80 00 00 	movabs $0x804415,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80024d:	00 00 00 
  800250:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800254:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80025b:	48 89 c6             	mov    %rax,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d2                	callq  *%rdx
  800265:	48 98                	cltq   
  800267:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80026b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cb>
		panic("file_stat: %e", r);
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba 29 44 80 00 00 	movabs $0x804429,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 c0             	mov    -0x40(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x23f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 30 09 80 00 00 	movabs $0x800930,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf 5e 44 80 00 00 	movabs $0x80445e,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80035a:	00 00 00 
  80035d:	48 8b 48 10          	mov    0x10(%rax),%rcx
  800361:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 c6             	mov    %rax,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d1                	callq  *%rcx
  800377:	48 98                	cltq   
  800379:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80037d:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2dd>
		panic("file_read: %e", r);
  800384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 71 44 80 00 00 	movabs $0x804471,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x331>
		panic("file_read returned wrong data");
  8003e0:	48 ba 7f 44 80 00 00 	movabs $0x80447f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 9d 44 80 00 00 	movabs $0x80449d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800440:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a0>
		panic("file_close: %e", r);
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba b0 44 80 00 00 	movabs $0x8044b0,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf bf 44 80 00 00 	movabs $0x8044bf,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 10             	mov    (%rax),%rdx
  80049c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004a0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004a4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8004c5:	00 00 00 
  8004c8:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8004cc:	48 8d 8d 40 fd ff ff 	lea    -0x2c0(%rbp),%rcx
  8004d3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 ce             	mov    %rcx,%rsi
  8004df:	48 89 c7             	mov    %rax,%rdi
  8004e2:	41 ff d0             	callq  *%r8
  8004e5:	48 98                	cltq   
  8004e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004eb:	48 83 7d f0 fd       	cmpq   $0xfffffffffffffffd,-0x10(%rbp)
  8004f0:	74 32                	je     800524 <umain+0x44b>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f6:	48 89 c1             	mov    %rax,%rcx
  8004f9:	48 ba d8 44 80 00 00 	movabs $0x8044d8,%rdx
  800500:	00 00 00 
  800503:	be 43 00 00 00       	mov    $0x43,%esi
  800508:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  80050f:	00 00 00 
  800512:	b8 00 00 00 00       	mov    $0x0,%eax
  800517:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  80051e:	00 00 00 
  800521:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800524:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  80052b:	00 00 00 
  80052e:	b8 00 00 00 00       	mov    $0x0,%eax
  800533:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  80053a:	00 00 00 
  80053d:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80053f:	be 00 00 00 00       	mov    $0x0,%esi
  800544:	48 bf 66 43 80 00 00 	movabs $0x804366,%rdi
  80054b:	00 00 00 
  80054e:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	48 98                	cltq   
  80055c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800560:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800565:	79 39                	jns    8005a0 <umain+0x4c7>
  800567:	48 83 7d f0 f4       	cmpq   $0xfffffffffffffff4,-0x10(%rbp)
  80056c:	74 32                	je     8005a0 <umain+0x4c7>
		panic("open /not-found: %e", r);
  80056e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800572:	48 89 c1             	mov    %rax,%rcx
  800575:	48 ba 25 45 80 00 00 	movabs $0x804525,%rdx
  80057c:	00 00 00 
  80057f:	be 48 00 00 00       	mov    $0x48,%esi
  800584:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  80058b:	00 00 00 
  80058e:	b8 00 00 00 00       	mov    $0x0,%eax
  800593:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  80059a:	00 00 00 
  80059d:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  8005a0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8005a5:	78 2a                	js     8005d1 <umain+0x4f8>
		panic("open /not-found succeeded!");
  8005a7:	48 ba 39 45 80 00 00 	movabs $0x804539,%rdx
  8005ae:	00 00 00 
  8005b1:	be 4a 00 00 00       	mov    $0x4a,%esi
  8005b6:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8005bd:	00 00 00 
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  8005cc:	00 00 00 
  8005cf:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8005d1:	be 00 00 00 00       	mov    $0x0,%esi
  8005d6:	48 bf c1 43 80 00 00 	movabs $0x8043c1,%rdi
  8005dd:	00 00 00 
  8005e0:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	callq  *%rax
  8005ec:	48 98                	cltq   
  8005ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8005f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8005f7:	79 32                	jns    80062b <umain+0x552>
		panic("open /newmotd: %e", r);
  8005f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005fd:	48 89 c1             	mov    %rax,%rcx
  800600:	48 ba 54 45 80 00 00 	movabs $0x804554,%rdx
  800607:	00 00 00 
  80060a:	be 4d 00 00 00       	mov    $0x4d,%esi
  80060f:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800616:	00 00 00 
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  800625:	00 00 00 
  800628:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80062b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800635:	48 c1 e0 0c          	shl    $0xc,%rax
  800639:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 66             	cmp    $0x66,%eax
  800646:	75 16                	jne    80065e <umain+0x585>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 40 04             	mov    0x4(%rax),%eax
  80064f:	85 c0                	test   %eax,%eax
  800651:	75 0b                	jne    80065e <umain+0x585>
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	8b 40 08             	mov    0x8(%rax),%eax
  80065a:	85 c0                	test   %eax,%eax
  80065c:	74 2a                	je     800688 <umain+0x5af>
		panic("open did not fill struct Fd correctly\n");
  80065e:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  800665:	00 00 00 
  800668:	be 50 00 00 00       	mov    $0x50,%esi
  80066d:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800674:	00 00 00 
  800677:	b8 00 00 00 00       	mov    $0x0,%eax
  80067c:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  800683:	00 00 00 
  800686:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800688:	48 bf 8f 45 80 00 00 	movabs $0x80458f,%rdi
  80068f:	00 00 00 
  800692:	b8 00 00 00 00       	mov    $0x0,%eax
  800697:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  80069e:	00 00 00 
  8006a1:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/robig", O_RDONLY)) < 0)
  8006a3:	be 00 00 00 00       	mov    $0x0,%esi
  8006a8:	48 bf 9d 45 80 00 00 	movabs $0x80459d,%rdi
  8006af:	00 00 00 
  8006b2:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  8006b9:	00 00 00 
  8006bc:	ff d0                	callq  *%rax
  8006be:	48 98                	cltq   
  8006c0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8006c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8006c9:	79 32                	jns    8006fd <umain+0x624>
		panic("open /robig: %e", f);
  8006cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006cf:	48 89 c1             	mov    %rax,%rcx
  8006d2:	48 ba a4 45 80 00 00 	movabs $0x8045a4,%rdx
  8006d9:	00 00 00 
  8006dc:	be 55 00 00 00       	mov    $0x55,%esi
  8006e1:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8006e8:	00 00 00 
  8006eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f0:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  8006f7:	00 00 00 
  8006fa:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8006fd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800704:	00 
  800705:	e9 1a 01 00 00       	jmpq   800824 <umain+0x74b>
		*(int*)buf = i;
  80070a:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  800711:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800715:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800717:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80071b:	48 8d 8d 40 fd ff ff 	lea    -0x2c0(%rbp),%rcx
  800722:	ba 00 02 00 00       	mov    $0x200,%edx
  800727:	48 89 ce             	mov    %rcx,%rsi
  80072a:	89 c7                	mov    %eax,%edi
  80072c:	48 b8 d9 2b 80 00 00 	movabs $0x802bd9,%rax
  800733:	00 00 00 
  800736:	ff d0                	callq  *%rax
  800738:	48 98                	cltq   
  80073a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80073e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  800743:	79 39                	jns    80077e <umain+0x6a5>
			panic("read /robig@%d: %e", i, r);
  800745:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800749:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80074d:	49 89 d0             	mov    %rdx,%r8
  800750:	48 89 c1             	mov    %rax,%rcx
  800753:	48 ba b4 45 80 00 00 	movabs $0x8045b4,%rdx
  80075a:	00 00 00 
  80075d:	be 59 00 00 00       	mov    $0x59,%esi
  800762:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800769:	00 00 00 
  80076c:	b8 00 00 00 00       	mov    $0x0,%eax
  800771:	49 b9 30 09 80 00 00 	movabs $0x800930,%r9
  800778:	00 00 00 
  80077b:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  80077e:	48 81 7d f0 00 02 00 	cmpq   $0x200,-0x10(%rbp)
  800785:	00 
  800786:	74 3f                	je     8007c7 <umain+0x6ee>
			panic("read /robig from %d returned %d < %d bytes",
  800788:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80078c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800790:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800796:	49 89 d0             	mov    %rdx,%r8
  800799:	48 89 c1             	mov    %rax,%rcx
  80079c:	48 ba c8 45 80 00 00 	movabs $0x8045c8,%rdx
  8007a3:	00 00 00 
  8007a6:	be 5c 00 00 00       	mov    $0x5c,%esi
  8007ab:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  8007b2:	00 00 00 
  8007b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ba:	49 ba 30 09 80 00 00 	movabs $0x800930,%r10
  8007c1:	00 00 00 
  8007c4:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  8007c7:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	48 98                	cltq   
  8007d2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8007d6:	74 3e                	je     800816 <umain+0x73d>
			panic("read /robig from %d returned bad data %d",
  8007d8:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
  8007df:	8b 10                	mov    (%rax),%edx
  8007e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007e5:	41 89 d0             	mov    %edx,%r8d
  8007e8:	48 89 c1             	mov    %rax,%rcx
  8007eb:	48 ba f8 45 80 00 00 	movabs $0x8045f8,%rdx
  8007f2:	00 00 00 
  8007f5:	be 5f 00 00 00       	mov    $0x5f,%esi
  8007fa:	48 bf 8b 43 80 00 00 	movabs $0x80438b,%rdi
  800801:	00 00 00 
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	49 b9 30 09 80 00 00 	movabs $0x800930,%r9
  800810:	00 00 00 
  800813:	41 ff d1             	callq  *%r9
	cprintf("open is good\n");

	// Try files with indirect blocks
	if ((f = open("/robig", O_RDONLY)) < 0)
		panic("open /robig: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80081a:	48 05 00 02 00 00    	add    $0x200,%rax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800824:	48 81 7d f8 ff df 01 	cmpq   $0x1dfff,-0x8(%rbp)
  80082b:	00 
  80082c:	0f 8e d8 fe ff ff    	jle    80070a <umain+0x631>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /robig from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800832:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800836:	89 c7                	mov    %eax,%edi
  800838:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  80083f:	00 00 00 
  800842:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800844:	48 bf 21 46 80 00 00 	movabs $0x804621,%rdi
  80084b:	00 00 00 
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  80085a:	00 00 00 
  80085d:	ff d2                	callq  *%rdx
}
  80085f:	c9                   	leaveq 
  800860:	c3                   	retq   
  800861:	00 00                	add    %al,(%rax)
	...

0000000000800864 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	48 83 ec 10          	sub    $0x10,%rsp
  80086c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80086f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800873:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80087a:	00 00 00 
  80087d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800884:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  80088b:	00 00 00 
  80088e:	ff d0                	callq  *%rax
  800890:	48 98                	cltq   
  800892:	48 89 c2             	mov    %rax,%rdx
  800895:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80089b:	48 89 d0             	mov    %rdx,%rax
  80089e:	48 c1 e0 02          	shl    $0x2,%rax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	48 01 c0             	add    %rax,%rax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	48 c1 e0 05          	shl    $0x5,%rax
  8008af:	48 89 c2             	mov    %rax,%rdx
  8008b2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8008b9:	00 00 00 
  8008bc:	48 01 c2             	add    %rax,%rdx
  8008bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008c6:	00 00 00 
  8008c9:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008d0:	7e 14                	jle    8008e6 <libmain+0x82>
		binaryname = argv[0];
  8008d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d6:	48 8b 10             	mov    (%rax),%rdx
  8008d9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008e0:	00 00 00 
  8008e3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ed:	48 89 d6             	mov    %rdx,%rsi
  8008f0:	89 c7                	mov    %eax,%edi
  8008f2:	48 b8 d9 00 80 00 00 	movabs $0x8000d9,%rax
  8008f9:	00 00 00 
  8008fc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008fe:	48 b8 0c 09 80 00 00 	movabs $0x80090c,%rax
  800905:	00 00 00 
  800908:	ff d0                	callq  *%rax
}
  80090a:	c9                   	leaveq 
  80090b:	c3                   	retq   

000000000080090c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80090c:	55                   	push   %rbp
  80090d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800910:	48 b8 29 29 80 00 00 	movabs $0x802929,%rax
  800917:	00 00 00 
  80091a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80091c:	bf 00 00 00 00       	mov    $0x0,%edi
  800921:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  800928:	00 00 00 
  80092b:	ff d0                	callq  *%rax
}
  80092d:	5d                   	pop    %rbp
  80092e:	c3                   	retq   
	...

0000000000800930 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800930:	55                   	push   %rbp
  800931:	48 89 e5             	mov    %rsp,%rbp
  800934:	53                   	push   %rbx
  800935:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80093c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800943:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800949:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800950:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800957:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80095e:	84 c0                	test   %al,%al
  800960:	74 23                	je     800985 <_panic+0x55>
  800962:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800969:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80096d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800971:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800975:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800979:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80097d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800981:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800985:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80098c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800993:	00 00 00 
  800996:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80099d:	00 00 00 
  8009a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009a4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8009ab:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8009b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009b9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8009c0:	00 00 00 
  8009c3:	48 8b 18             	mov    (%rax),%rbx
  8009c6:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8009cd:	00 00 00 
  8009d0:	ff d0                	callq  *%rax
  8009d2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8009d8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009df:	41 89 c8             	mov    %ecx,%r8d
  8009e2:	48 89 d1             	mov    %rdx,%rcx
  8009e5:	48 89 da             	mov    %rbx,%rdx
  8009e8:	89 c6                	mov    %eax,%esi
  8009ea:	48 bf 40 46 80 00 00 	movabs $0x804640,%rdi
  8009f1:	00 00 00 
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	49 b9 6b 0b 80 00 00 	movabs $0x800b6b,%r9
  800a00:	00 00 00 
  800a03:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a06:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800a0d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a14:	48 89 d6             	mov    %rdx,%rsi
  800a17:	48 89 c7             	mov    %rax,%rdi
  800a1a:	48 b8 bf 0a 80 00 00 	movabs $0x800abf,%rax
  800a21:	00 00 00 
  800a24:	ff d0                	callq  *%rax
	cprintf("\n");
  800a26:	48 bf 63 46 80 00 00 	movabs $0x804663,%rdi
  800a2d:	00 00 00 
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	48 ba 6b 0b 80 00 00 	movabs $0x800b6b,%rdx
  800a3c:	00 00 00 
  800a3f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a41:	cc                   	int3   
  800a42:	eb fd                	jmp    800a41 <_panic+0x111>

0000000000800a44 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a44:	55                   	push   %rbp
  800a45:	48 89 e5             	mov    %rsp,%rbp
  800a48:	48 83 ec 10          	sub    $0x10,%rsp
  800a4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a57:	8b 00                	mov    (%rax),%eax
  800a59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a5c:	89 d6                	mov    %edx,%esi
  800a5e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a62:	48 63 d0             	movslq %eax,%rdx
  800a65:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800a6a:	8d 50 01             	lea    0x1(%rax),%edx
  800a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a71:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a7e:	75 2c                	jne    800aac <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	48 98                	cltq   
  800a88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a8c:	48 83 c2 08          	add    $0x8,%rdx
  800a90:	48 89 c6             	mov    %rax,%rsi
  800a93:	48 89 d7             	mov    %rdx,%rdi
  800a96:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  800a9d:	00 00 00 
  800aa0:	ff d0                	callq  *%rax
        b->idx = 0;
  800aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800aa6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ab0:	8b 40 04             	mov    0x4(%rax),%eax
  800ab3:	8d 50 01             	lea    0x1(%rax),%edx
  800ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800aba:	89 50 04             	mov    %edx,0x4(%rax)
}
  800abd:	c9                   	leaveq 
  800abe:	c3                   	retq   

0000000000800abf <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800abf:	55                   	push   %rbp
  800ac0:	48 89 e5             	mov    %rsp,%rbp
  800ac3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800aca:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ad1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ad8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800adf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ae6:	48 8b 0a             	mov    (%rdx),%rcx
  800ae9:	48 89 08             	mov    %rcx,(%rax)
  800aec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800af0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800af4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800af8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800afc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800b03:	00 00 00 
    b.cnt = 0;
  800b06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800b0d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800b10:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800b17:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800b1e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800b25:	48 89 c6             	mov    %rax,%rsi
  800b28:	48 bf 44 0a 80 00 00 	movabs $0x800a44,%rdi
  800b2f:	00 00 00 
  800b32:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800b39:	00 00 00 
  800b3c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800b3e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b44:	48 98                	cltq   
  800b46:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b4d:	48 83 c2 08          	add    $0x8,%rdx
  800b51:	48 89 c6             	mov    %rax,%rsi
  800b54:	48 89 d7             	mov    %rdx,%rdi
  800b57:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  800b5e:	00 00 00 
  800b61:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b63:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b69:	c9                   	leaveq 
  800b6a:	c3                   	retq   

0000000000800b6b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b6b:	55                   	push   %rbp
  800b6c:	48 89 e5             	mov    %rsp,%rbp
  800b6f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b76:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b7d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b84:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b8b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b92:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b99:	84 c0                	test   %al,%al
  800b9b:	74 20                	je     800bbd <cprintf+0x52>
  800b9d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ba1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ba5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ba9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bad:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bb1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bb5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bb9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bbd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800bc4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800bcb:	00 00 00 
  800bce:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800bd5:	00 00 00 
  800bd8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bdc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800be3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800bf1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bf8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bff:	48 8b 0a             	mov    (%rdx),%rcx
  800c02:	48 89 08             	mov    %rcx,(%rax)
  800c05:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c09:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c0d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c11:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800c15:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800c1c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800c23:	48 89 d6             	mov    %rdx,%rsi
  800c26:	48 89 c7             	mov    %rax,%rdi
  800c29:	48 b8 bf 0a 80 00 00 	movabs $0x800abf,%rax
  800c30:	00 00 00 
  800c33:	ff d0                	callq  *%rax
  800c35:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800c3b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c41:	c9                   	leaveq 
  800c42:	c3                   	retq   
	...

0000000000800c44 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c44:	55                   	push   %rbp
  800c45:	48 89 e5             	mov    %rsp,%rbp
  800c48:	48 83 ec 30          	sub    $0x30,%rsp
  800c4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800c50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c54:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c58:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c5b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c5f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c63:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c66:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c6a:	77 52                	ja     800cbe <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c6c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c6f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c73:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c76:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	48 f7 75 d0          	divq   -0x30(%rbp)
  800c87:	48 89 c2             	mov    %rax,%rdx
  800c8a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c8d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c90:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c98:	41 89 f9             	mov    %edi,%r9d
  800c9b:	48 89 c7             	mov    %rax,%rdi
  800c9e:	48 b8 44 0c 80 00 00 	movabs $0x800c44,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	callq  *%rax
  800caa:	eb 1c                	jmp    800cc8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cb3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800cb7:	48 89 d6             	mov    %rdx,%rsi
  800cba:	89 c7                	mov    %eax,%edi
  800cbc:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cbe:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800cc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800cc6:	7f e4                	jg     800cac <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cc8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	48 f7 f1             	div    %rcx
  800cd7:	48 89 d0             	mov    %rdx,%rax
  800cda:	48 ba 70 48 80 00 00 	movabs $0x804870,%rdx
  800ce1:	00 00 00 
  800ce4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800ce8:	0f be c0             	movsbl %al,%eax
  800ceb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800cf3:	48 89 d6             	mov    %rdx,%rsi
  800cf6:	89 c7                	mov    %eax,%edi
  800cf8:	ff d1                	callq  *%rcx
}
  800cfa:	c9                   	leaveq 
  800cfb:	c3                   	retq   

0000000000800cfc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cfc:	55                   	push   %rbp
  800cfd:	48 89 e5             	mov    %rsp,%rbp
  800d00:	48 83 ec 20          	sub    $0x20,%rsp
  800d04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d08:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800d0b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800d0f:	7e 52                	jle    800d63 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d15:	8b 00                	mov    (%rax),%eax
  800d17:	83 f8 30             	cmp    $0x30,%eax
  800d1a:	73 24                	jae    800d40 <getuint+0x44>
  800d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d20:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d28:	8b 00                	mov    (%rax),%eax
  800d2a:	89 c0                	mov    %eax,%eax
  800d2c:	48 01 d0             	add    %rdx,%rax
  800d2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d33:	8b 12                	mov    (%rdx),%edx
  800d35:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3c:	89 0a                	mov    %ecx,(%rdx)
  800d3e:	eb 17                	jmp    800d57 <getuint+0x5b>
  800d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d44:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d48:	48 89 d0             	mov    %rdx,%rax
  800d4b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d53:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d57:	48 8b 00             	mov    (%rax),%rax
  800d5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d5e:	e9 a3 00 00 00       	jmpq   800e06 <getuint+0x10a>
	else if (lflag)
  800d63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d67:	74 4f                	je     800db8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6d:	8b 00                	mov    (%rax),%eax
  800d6f:	83 f8 30             	cmp    $0x30,%eax
  800d72:	73 24                	jae    800d98 <getuint+0x9c>
  800d74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d78:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	8b 00                	mov    (%rax),%eax
  800d82:	89 c0                	mov    %eax,%eax
  800d84:	48 01 d0             	add    %rdx,%rax
  800d87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8b:	8b 12                	mov    (%rdx),%edx
  800d8d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d94:	89 0a                	mov    %ecx,(%rdx)
  800d96:	eb 17                	jmp    800daf <getuint+0xb3>
  800d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da0:	48 89 d0             	mov    %rdx,%rax
  800da3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800da7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800daf:	48 8b 00             	mov    (%rax),%rax
  800db2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800db6:	eb 4e                	jmp    800e06 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbc:	8b 00                	mov    (%rax),%eax
  800dbe:	83 f8 30             	cmp    $0x30,%eax
  800dc1:	73 24                	jae    800de7 <getuint+0xeb>
  800dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcf:	8b 00                	mov    (%rax),%eax
  800dd1:	89 c0                	mov    %eax,%eax
  800dd3:	48 01 d0             	add    %rdx,%rax
  800dd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dda:	8b 12                	mov    (%rdx),%edx
  800ddc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ddf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de3:	89 0a                	mov    %ecx,(%rdx)
  800de5:	eb 17                	jmp    800dfe <getuint+0x102>
  800de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800deb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800def:	48 89 d0             	mov    %rdx,%rax
  800df2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800df6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dfe:	8b 00                	mov    (%rax),%eax
  800e00:	89 c0                	mov    %eax,%eax
  800e02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800e06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e0a:	c9                   	leaveq 
  800e0b:	c3                   	retq   

0000000000800e0c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e0c:	55                   	push   %rbp
  800e0d:	48 89 e5             	mov    %rsp,%rbp
  800e10:	48 83 ec 20          	sub    $0x20,%rsp
  800e14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e18:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800e1b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800e1f:	7e 52                	jle    800e73 <getint+0x67>
		x=va_arg(*ap, long long);
  800e21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e25:	8b 00                	mov    (%rax),%eax
  800e27:	83 f8 30             	cmp    $0x30,%eax
  800e2a:	73 24                	jae    800e50 <getint+0x44>
  800e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e30:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e38:	8b 00                	mov    (%rax),%eax
  800e3a:	89 c0                	mov    %eax,%eax
  800e3c:	48 01 d0             	add    %rdx,%rax
  800e3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e43:	8b 12                	mov    (%rdx),%edx
  800e45:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4c:	89 0a                	mov    %ecx,(%rdx)
  800e4e:	eb 17                	jmp    800e67 <getint+0x5b>
  800e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e54:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e58:	48 89 d0             	mov    %rdx,%rax
  800e5b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e63:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e67:	48 8b 00             	mov    (%rax),%rax
  800e6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e6e:	e9 a3 00 00 00       	jmpq   800f16 <getint+0x10a>
	else if (lflag)
  800e73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e77:	74 4f                	je     800ec8 <getint+0xbc>
		x=va_arg(*ap, long);
  800e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7d:	8b 00                	mov    (%rax),%eax
  800e7f:	83 f8 30             	cmp    $0x30,%eax
  800e82:	73 24                	jae    800ea8 <getint+0x9c>
  800e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e88:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	8b 00                	mov    (%rax),%eax
  800e92:	89 c0                	mov    %eax,%eax
  800e94:	48 01 d0             	add    %rdx,%rax
  800e97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9b:	8b 12                	mov    (%rdx),%edx
  800e9d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea4:	89 0a                	mov    %ecx,(%rdx)
  800ea6:	eb 17                	jmp    800ebf <getint+0xb3>
  800ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb0:	48 89 d0             	mov    %rdx,%rax
  800eb3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ebf:	48 8b 00             	mov    (%rax),%rax
  800ec2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ec6:	eb 4e                	jmp    800f16 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ec8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecc:	8b 00                	mov    (%rax),%eax
  800ece:	83 f8 30             	cmp    $0x30,%eax
  800ed1:	73 24                	jae    800ef7 <getint+0xeb>
  800ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800edb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edf:	8b 00                	mov    (%rax),%eax
  800ee1:	89 c0                	mov    %eax,%eax
  800ee3:	48 01 d0             	add    %rdx,%rax
  800ee6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eea:	8b 12                	mov    (%rdx),%edx
  800eec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef3:	89 0a                	mov    %ecx,(%rdx)
  800ef5:	eb 17                	jmp    800f0e <getint+0x102>
  800ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eff:	48 89 d0             	mov    %rdx,%rax
  800f02:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f0e:	8b 00                	mov    (%rax),%eax
  800f10:	48 98                	cltq   
  800f12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f1a:	c9                   	leaveq 
  800f1b:	c3                   	retq   

0000000000800f1c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
  800f20:	41 54                	push   %r12
  800f22:	53                   	push   %rbx
  800f23:	48 83 ec 60          	sub    $0x60,%rsp
  800f27:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800f2b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800f2f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f33:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800f37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f3b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f3f:	48 8b 0a             	mov    (%rdx),%rcx
  800f42:	48 89 08             	mov    %rcx,(%rax)
  800f45:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f49:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f4d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f51:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f55:	eb 17                	jmp    800f6e <vprintfmt+0x52>
			if (ch == '\0')
  800f57:	85 db                	test   %ebx,%ebx
  800f59:	0f 84 ea 04 00 00    	je     801449 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800f5f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f63:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f67:	48 89 c6             	mov    %rax,%rsi
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f72:	0f b6 00             	movzbl (%rax),%eax
  800f75:	0f b6 d8             	movzbl %al,%ebx
  800f78:	83 fb 25             	cmp    $0x25,%ebx
  800f7b:	0f 95 c0             	setne  %al
  800f7e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f83:	84 c0                	test   %al,%al
  800f85:	75 d0                	jne    800f57 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f87:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f8b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f92:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800fa0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800fa7:	eb 04                	jmp    800fad <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800fa9:	90                   	nop
  800faa:	eb 01                	jmp    800fad <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800fac:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fb1:	0f b6 00             	movzbl (%rax),%eax
  800fb4:	0f b6 d8             	movzbl %al,%ebx
  800fb7:	89 d8                	mov    %ebx,%eax
  800fb9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800fbe:	83 e8 23             	sub    $0x23,%eax
  800fc1:	83 f8 55             	cmp    $0x55,%eax
  800fc4:	0f 87 4b 04 00 00    	ja     801415 <vprintfmt+0x4f9>
  800fca:	89 c0                	mov    %eax,%eax
  800fcc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800fd3:	00 
  800fd4:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
  800fdb:	00 00 00 
  800fde:	48 01 d0             	add    %rdx,%rax
  800fe1:	48 8b 00             	mov    (%rax),%rax
  800fe4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800fe6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800fea:	eb c1                	jmp    800fad <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fec:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ff0:	eb bb                	jmp    800fad <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ff9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	c1 e0 02             	shl    $0x2,%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	01 c0                	add    %eax,%eax
  801005:	01 d8                	add    %ebx,%eax
  801007:	83 e8 30             	sub    $0x30,%eax
  80100a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80100d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801011:	0f b6 00             	movzbl (%rax),%eax
  801014:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801017:	83 fb 2f             	cmp    $0x2f,%ebx
  80101a:	7e 63                	jle    80107f <vprintfmt+0x163>
  80101c:	83 fb 39             	cmp    $0x39,%ebx
  80101f:	7f 5e                	jg     80107f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801021:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801026:	eb d1                	jmp    800ff9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  801028:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80102b:	83 f8 30             	cmp    $0x30,%eax
  80102e:	73 17                	jae    801047 <vprintfmt+0x12b>
  801030:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801034:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801037:	89 c0                	mov    %eax,%eax
  801039:	48 01 d0             	add    %rdx,%rax
  80103c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80103f:	83 c2 08             	add    $0x8,%edx
  801042:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801045:	eb 0f                	jmp    801056 <vprintfmt+0x13a>
  801047:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80104b:	48 89 d0             	mov    %rdx,%rax
  80104e:	48 83 c2 08          	add    $0x8,%rdx
  801052:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801056:	8b 00                	mov    (%rax),%eax
  801058:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80105b:	eb 23                	jmp    801080 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80105d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801061:	0f 89 42 ff ff ff    	jns    800fa9 <vprintfmt+0x8d>
				width = 0;
  801067:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80106e:	e9 36 ff ff ff       	jmpq   800fa9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801073:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80107a:	e9 2e ff ff ff       	jmpq   800fad <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80107f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801080:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801084:	0f 89 22 ff ff ff    	jns    800fac <vprintfmt+0x90>
				width = precision, precision = -1;
  80108a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80108d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801090:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801097:	e9 10 ff ff ff       	jmpq   800fac <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80109c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8010a0:	e9 08 ff ff ff       	jmpq   800fad <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8010a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a8:	83 f8 30             	cmp    $0x30,%eax
  8010ab:	73 17                	jae    8010c4 <vprintfmt+0x1a8>
  8010ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010b4:	89 c0                	mov    %eax,%eax
  8010b6:	48 01 d0             	add    %rdx,%rax
  8010b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010bc:	83 c2 08             	add    $0x8,%edx
  8010bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010c2:	eb 0f                	jmp    8010d3 <vprintfmt+0x1b7>
  8010c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010c8:	48 89 d0             	mov    %rdx,%rax
  8010cb:	48 83 c2 08          	add    $0x8,%rdx
  8010cf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010d3:	8b 00                	mov    (%rax),%eax
  8010d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010d9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8010dd:	48 89 d6             	mov    %rdx,%rsi
  8010e0:	89 c7                	mov    %eax,%edi
  8010e2:	ff d1                	callq  *%rcx
			break;
  8010e4:	e9 5a 03 00 00       	jmpq   801443 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8010e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ec:	83 f8 30             	cmp    $0x30,%eax
  8010ef:	73 17                	jae    801108 <vprintfmt+0x1ec>
  8010f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010f8:	89 c0                	mov    %eax,%eax
  8010fa:	48 01 d0             	add    %rdx,%rax
  8010fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801100:	83 c2 08             	add    $0x8,%edx
  801103:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801106:	eb 0f                	jmp    801117 <vprintfmt+0x1fb>
  801108:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80110c:	48 89 d0             	mov    %rdx,%rax
  80110f:	48 83 c2 08          	add    $0x8,%rdx
  801113:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801117:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801119:	85 db                	test   %ebx,%ebx
  80111b:	79 02                	jns    80111f <vprintfmt+0x203>
				err = -err;
  80111d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80111f:	83 fb 15             	cmp    $0x15,%ebx
  801122:	7f 16                	jg     80113a <vprintfmt+0x21e>
  801124:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  80112b:	00 00 00 
  80112e:	48 63 d3             	movslq %ebx,%rdx
  801131:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801135:	4d 85 e4             	test   %r12,%r12
  801138:	75 2e                	jne    801168 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80113a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80113e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801142:	89 d9                	mov    %ebx,%ecx
  801144:	48 ba 81 48 80 00 00 	movabs $0x804881,%rdx
  80114b:	00 00 00 
  80114e:	48 89 c7             	mov    %rax,%rdi
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	49 b8 53 14 80 00 00 	movabs $0x801453,%r8
  80115d:	00 00 00 
  801160:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801163:	e9 db 02 00 00       	jmpq   801443 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801168:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80116c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801170:	4c 89 e1             	mov    %r12,%rcx
  801173:	48 ba 8a 48 80 00 00 	movabs $0x80488a,%rdx
  80117a:	00 00 00 
  80117d:	48 89 c7             	mov    %rax,%rdi
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	49 b8 53 14 80 00 00 	movabs $0x801453,%r8
  80118c:	00 00 00 
  80118f:	41 ff d0             	callq  *%r8
			break;
  801192:	e9 ac 02 00 00       	jmpq   801443 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801197:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119a:	83 f8 30             	cmp    $0x30,%eax
  80119d:	73 17                	jae    8011b6 <vprintfmt+0x29a>
  80119f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011a6:	89 c0                	mov    %eax,%eax
  8011a8:	48 01 d0             	add    %rdx,%rax
  8011ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011ae:	83 c2 08             	add    $0x8,%edx
  8011b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011b4:	eb 0f                	jmp    8011c5 <vprintfmt+0x2a9>
  8011b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011ba:	48 89 d0             	mov    %rdx,%rax
  8011bd:	48 83 c2 08          	add    $0x8,%rdx
  8011c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011c5:	4c 8b 20             	mov    (%rax),%r12
  8011c8:	4d 85 e4             	test   %r12,%r12
  8011cb:	75 0a                	jne    8011d7 <vprintfmt+0x2bb>
				p = "(null)";
  8011cd:	49 bc 8d 48 80 00 00 	movabs $0x80488d,%r12
  8011d4:	00 00 00 
			if (width > 0 && padc != '-')
  8011d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011db:	7e 7a                	jle    801257 <vprintfmt+0x33b>
  8011dd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011e1:	74 74                	je     801257 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011e3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011e6:	48 98                	cltq   
  8011e8:	48 89 c6             	mov    %rax,%rsi
  8011eb:	4c 89 e7             	mov    %r12,%rdi
  8011ee:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  8011f5:	00 00 00 
  8011f8:	ff d0                	callq  *%rax
  8011fa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011fd:	eb 17                	jmp    801216 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8011ff:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  801203:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801207:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80120b:	48 89 d6             	mov    %rdx,%rsi
  80120e:	89 c7                	mov    %eax,%edi
  801210:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801212:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801216:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80121a:	7f e3                	jg     8011ff <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80121c:	eb 39                	jmp    801257 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80121e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801222:	74 1e                	je     801242 <vprintfmt+0x326>
  801224:	83 fb 1f             	cmp    $0x1f,%ebx
  801227:	7e 05                	jle    80122e <vprintfmt+0x312>
  801229:	83 fb 7e             	cmp    $0x7e,%ebx
  80122c:	7e 14                	jle    801242 <vprintfmt+0x326>
					putch('?', putdat);
  80122e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801232:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801236:	48 89 c6             	mov    %rax,%rsi
  801239:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80123e:	ff d2                	callq  *%rdx
  801240:	eb 0f                	jmp    801251 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801242:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801246:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80124a:	48 89 c6             	mov    %rax,%rsi
  80124d:	89 df                	mov    %ebx,%edi
  80124f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801251:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801255:	eb 01                	jmp    801258 <vprintfmt+0x33c>
  801257:	90                   	nop
  801258:	41 0f b6 04 24       	movzbl (%r12),%eax
  80125d:	0f be d8             	movsbl %al,%ebx
  801260:	85 db                	test   %ebx,%ebx
  801262:	0f 95 c0             	setne  %al
  801265:	49 83 c4 01          	add    $0x1,%r12
  801269:	84 c0                	test   %al,%al
  80126b:	74 28                	je     801295 <vprintfmt+0x379>
  80126d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801271:	78 ab                	js     80121e <vprintfmt+0x302>
  801273:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801277:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80127b:	79 a1                	jns    80121e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80127d:	eb 16                	jmp    801295 <vprintfmt+0x379>
				putch(' ', putdat);
  80127f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801283:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801287:	48 89 c6             	mov    %rax,%rsi
  80128a:	bf 20 00 00 00       	mov    $0x20,%edi
  80128f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801291:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801295:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801299:	7f e4                	jg     80127f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80129b:	e9 a3 01 00 00       	jmpq   801443 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8012a0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012a4:	be 03 00 00 00       	mov    $0x3,%esi
  8012a9:	48 89 c7             	mov    %rax,%rdi
  8012ac:	48 b8 0c 0e 80 00 00 	movabs $0x800e0c,%rax
  8012b3:	00 00 00 
  8012b6:	ff d0                	callq  *%rax
  8012b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8012bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c0:	48 85 c0             	test   %rax,%rax
  8012c3:	79 1d                	jns    8012e2 <vprintfmt+0x3c6>
				putch('-', putdat);
  8012c5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8012c9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8012cd:	48 89 c6             	mov    %rax,%rsi
  8012d0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012d5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8012d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012db:	48 f7 d8             	neg    %rax
  8012de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012e2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012e9:	e9 e8 00 00 00       	jmpq   8013d6 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012f2:	be 03 00 00 00       	mov    $0x3,%esi
  8012f7:	48 89 c7             	mov    %rax,%rdi
  8012fa:	48 b8 fc 0c 80 00 00 	movabs $0x800cfc,%rax
  801301:	00 00 00 
  801304:	ff d0                	callq  *%rax
  801306:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80130a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801311:	e9 c0 00 00 00       	jmpq   8013d6 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801316:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80131a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80131e:	48 89 c6             	mov    %rax,%rsi
  801321:	bf 58 00 00 00       	mov    $0x58,%edi
  801326:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801328:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80132c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801330:	48 89 c6             	mov    %rax,%rsi
  801333:	bf 58 00 00 00       	mov    $0x58,%edi
  801338:	ff d2                	callq  *%rdx
			putch('X', putdat);
  80133a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80133e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801342:	48 89 c6             	mov    %rax,%rsi
  801345:	bf 58 00 00 00       	mov    $0x58,%edi
  80134a:	ff d2                	callq  *%rdx
			break;
  80134c:	e9 f2 00 00 00       	jmpq   801443 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801351:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801355:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801359:	48 89 c6             	mov    %rax,%rsi
  80135c:	bf 30 00 00 00       	mov    $0x30,%edi
  801361:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801363:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801367:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80136b:	48 89 c6             	mov    %rax,%rsi
  80136e:	bf 78 00 00 00       	mov    $0x78,%edi
  801373:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801375:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801378:	83 f8 30             	cmp    $0x30,%eax
  80137b:	73 17                	jae    801394 <vprintfmt+0x478>
  80137d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801381:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801384:	89 c0                	mov    %eax,%eax
  801386:	48 01 d0             	add    %rdx,%rax
  801389:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80138c:	83 c2 08             	add    $0x8,%edx
  80138f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801392:	eb 0f                	jmp    8013a3 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801394:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801398:	48 89 d0             	mov    %rdx,%rax
  80139b:	48 83 c2 08          	add    $0x8,%rdx
  80139f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013a3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8013aa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8013b1:	eb 23                	jmp    8013d6 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8013b3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013b7:	be 03 00 00 00       	mov    $0x3,%esi
  8013bc:	48 89 c7             	mov    %rax,%rdi
  8013bf:	48 b8 fc 0c 80 00 00 	movabs $0x800cfc,%rax
  8013c6:	00 00 00 
  8013c9:	ff d0                	callq  *%rax
  8013cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8013cf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8013d6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8013db:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8013de:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8013e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013e5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ed:	45 89 c1             	mov    %r8d,%r9d
  8013f0:	41 89 f8             	mov    %edi,%r8d
  8013f3:	48 89 c7             	mov    %rax,%rdi
  8013f6:	48 b8 44 0c 80 00 00 	movabs $0x800c44,%rax
  8013fd:	00 00 00 
  801400:	ff d0                	callq  *%rax
			break;
  801402:	eb 3f                	jmp    801443 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801404:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801408:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80140c:	48 89 c6             	mov    %rax,%rsi
  80140f:	89 df                	mov    %ebx,%edi
  801411:	ff d2                	callq  *%rdx
			break;
  801413:	eb 2e                	jmp    801443 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801415:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801419:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80141d:	48 89 c6             	mov    %rax,%rsi
  801420:	bf 25 00 00 00       	mov    $0x25,%edi
  801425:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801427:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80142c:	eb 05                	jmp    801433 <vprintfmt+0x517>
  80142e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801433:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801437:	48 83 e8 01          	sub    $0x1,%rax
  80143b:	0f b6 00             	movzbl (%rax),%eax
  80143e:	3c 25                	cmp    $0x25,%al
  801440:	75 ec                	jne    80142e <vprintfmt+0x512>
				/* do nothing */;
			break;
  801442:	90                   	nop
		}
	}
  801443:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801444:	e9 25 fb ff ff       	jmpq   800f6e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801449:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80144a:	48 83 c4 60          	add    $0x60,%rsp
  80144e:	5b                   	pop    %rbx
  80144f:	41 5c                	pop    %r12
  801451:	5d                   	pop    %rbp
  801452:	c3                   	retq   

0000000000801453 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80145e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801465:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80146c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801473:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80147a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801481:	84 c0                	test   %al,%al
  801483:	74 20                	je     8014a5 <printfmt+0x52>
  801485:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801489:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80148d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801491:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801495:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801499:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80149d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014a1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014a5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8014ac:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8014b3:	00 00 00 
  8014b6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8014bd:	00 00 00 
  8014c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014c4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8014cb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014d2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014d9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014e0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014e7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014ee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014f5:	48 89 c7             	mov    %rax,%rdi
  8014f8:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  8014ff:	00 00 00 
  801502:	ff d0                	callq  *%rax
	va_end(ap);
}
  801504:	c9                   	leaveq 
  801505:	c3                   	retq   

0000000000801506 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801506:	55                   	push   %rbp
  801507:	48 89 e5             	mov    %rsp,%rbp
  80150a:	48 83 ec 10          	sub    $0x10,%rsp
  80150e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801511:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801519:	8b 40 10             	mov    0x10(%rax),%eax
  80151c:	8d 50 01             	lea    0x1(%rax),%edx
  80151f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801523:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152a:	48 8b 10             	mov    (%rax),%rdx
  80152d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801531:	48 8b 40 08          	mov    0x8(%rax),%rax
  801535:	48 39 c2             	cmp    %rax,%rdx
  801538:	73 17                	jae    801551 <sprintputch+0x4b>
		*b->buf++ = ch;
  80153a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153e:	48 8b 00             	mov    (%rax),%rax
  801541:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801544:	88 10                	mov    %dl,(%rax)
  801546:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	48 89 10             	mov    %rdx,(%rax)
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 50          	sub    $0x50,%rsp
  80155b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80155f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801562:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801566:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80156a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80156e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801572:	48 8b 0a             	mov    (%rdx),%rcx
  801575:	48 89 08             	mov    %rcx,(%rax)
  801578:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80157c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801580:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801584:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801588:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80158c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801590:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801593:	48 98                	cltq   
  801595:	48 83 e8 01          	sub    $0x1,%rax
  801599:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80159d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8015a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8015a8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8015ad:	74 06                	je     8015b5 <vsnprintf+0x62>
  8015af:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8015b3:	7f 07                	jg     8015bc <vsnprintf+0x69>
		return -E_INVAL;
  8015b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ba:	eb 2f                	jmp    8015eb <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8015bc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8015c0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8015c4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015c8:	48 89 c6             	mov    %rax,%rsi
  8015cb:	48 bf 06 15 80 00 00 	movabs $0x801506,%rdi
  8015d2:	00 00 00 
  8015d5:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015e8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015eb:	c9                   	leaveq 
  8015ec:	c3                   	retq   

00000000008015ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015f8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015ff:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801605:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80160c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801613:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80161a:	84 c0                	test   %al,%al
  80161c:	74 20                	je     80163e <snprintf+0x51>
  80161e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801622:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801626:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80162a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80162e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801632:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801636:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80163a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80163e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801645:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80164c:	00 00 00 
  80164f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801656:	00 00 00 
  801659:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80165d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801664:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80166b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801672:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801679:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801680:	48 8b 0a             	mov    (%rdx),%rcx
  801683:	48 89 08             	mov    %rcx,(%rax)
  801686:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80168a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80168e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801692:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801696:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80169d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8016a4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8016aa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8016b1:	48 89 c7             	mov    %rax,%rdi
  8016b4:	48 b8 53 15 80 00 00 	movabs $0x801553,%rax
  8016bb:	00 00 00 
  8016be:	ff d0                	callq  *%rax
  8016c0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8016c6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016cc:	c9                   	leaveq 
  8016cd:	c3                   	retq   
	...

00000000008016d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016d0:	55                   	push   %rbp
  8016d1:	48 89 e5             	mov    %rsp,%rbp
  8016d4:	48 83 ec 18          	sub    $0x18,%rsp
  8016d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016e3:	eb 09                	jmp    8016ee <strlen+0x1e>
		n++;
  8016e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	84 c0                	test   %al,%al
  8016f7:	75 ec                	jne    8016e5 <strlen+0x15>
		n++;
	return n;
  8016f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016fc:	c9                   	leaveq 
  8016fd:	c3                   	retq   

00000000008016fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	48 83 ec 20          	sub    $0x20,%rsp
  801706:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801715:	eb 0e                	jmp    801725 <strnlen+0x27>
		n++;
  801717:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80171b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801720:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801725:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80172a:	74 0b                	je     801737 <strnlen+0x39>
  80172c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	84 c0                	test   %al,%al
  801735:	75 e0                	jne    801717 <strnlen+0x19>
		n++;
	return n;
  801737:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80173a:	c9                   	leaveq 
  80173b:	c3                   	retq   

000000000080173c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	48 83 ec 20          	sub    $0x20,%rsp
  801744:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801748:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80174c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801754:	90                   	nop
  801755:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801759:	0f b6 10             	movzbl (%rax),%edx
  80175c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801760:	88 10                	mov    %dl,(%rax)
  801762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801766:	0f b6 00             	movzbl (%rax),%eax
  801769:	84 c0                	test   %al,%al
  80176b:	0f 95 c0             	setne  %al
  80176e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801773:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801778:	84 c0                	test   %al,%al
  80177a:	75 d9                	jne    801755 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80177c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801780:	c9                   	leaveq 
  801781:	c3                   	retq   

0000000000801782 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801782:	55                   	push   %rbp
  801783:	48 89 e5             	mov    %rsp,%rbp
  801786:	48 83 ec 20          	sub    $0x20,%rsp
  80178a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801796:	48 89 c7             	mov    %rax,%rdi
  801799:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8017a0:	00 00 00 
  8017a3:	ff d0                	callq  *%rax
  8017a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8017a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ab:	48 98                	cltq   
  8017ad:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8017b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017b5:	48 89 d6             	mov    %rdx,%rsi
  8017b8:	48 89 c7             	mov    %rax,%rdi
  8017bb:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	callq  *%rax
	return dst;
  8017c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   

00000000008017cd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	48 83 ec 28          	sub    $0x28,%rsp
  8017d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017e9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017f0:	00 
  8017f1:	eb 27                	jmp    80181a <strncpy+0x4d>
		*dst++ = *src;
  8017f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017f7:	0f b6 10             	movzbl (%rax),%edx
  8017fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fe:	88 10                	mov    %dl,(%rax)
  801800:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801805:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	84 c0                	test   %al,%al
  80180e:	74 05                	je     801815 <strncpy+0x48>
			src++;
  801810:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801815:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80181a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801822:	72 cf                	jb     8017f3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 28          	sub    $0x28,%rsp
  801832:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801836:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80183a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80183e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801846:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80184b:	74 37                	je     801884 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80184d:	eb 17                	jmp    801866 <strlcpy+0x3c>
			*dst++ = *src++;
  80184f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801853:	0f b6 10             	movzbl (%rax),%edx
  801856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185a:	88 10                	mov    %dl,(%rax)
  80185c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801861:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801866:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80186b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801870:	74 0b                	je     80187d <strlcpy+0x53>
  801872:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801876:	0f b6 00             	movzbl (%rax),%eax
  801879:	84 c0                	test   %al,%al
  80187b:	75 d2                	jne    80184f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80187d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801881:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801888:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188c:	48 89 d1             	mov    %rdx,%rcx
  80188f:	48 29 c1             	sub    %rax,%rcx
  801892:	48 89 c8             	mov    %rcx,%rax
}
  801895:	c9                   	leaveq 
  801896:	c3                   	retq   

0000000000801897 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801897:	55                   	push   %rbp
  801898:	48 89 e5             	mov    %rsp,%rbp
  80189b:	48 83 ec 10          	sub    $0x10,%rsp
  80189f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8018a7:	eb 0a                	jmp    8018b3 <strcmp+0x1c>
		p++, q++;
  8018a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018ae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b7:	0f b6 00             	movzbl (%rax),%eax
  8018ba:	84 c0                	test   %al,%al
  8018bc:	74 12                	je     8018d0 <strcmp+0x39>
  8018be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c2:	0f b6 10             	movzbl (%rax),%edx
  8018c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	38 c2                	cmp    %al,%dl
  8018ce:	74 d9                	je     8018a9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d4:	0f b6 00             	movzbl (%rax),%eax
  8018d7:	0f b6 d0             	movzbl %al,%edx
  8018da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	0f b6 c0             	movzbl %al,%eax
  8018e4:	89 d1                	mov    %edx,%ecx
  8018e6:	29 c1                	sub    %eax,%ecx
  8018e8:	89 c8                	mov    %ecx,%eax
}
  8018ea:	c9                   	leaveq 
  8018eb:	c3                   	retq   

00000000008018ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 18          	sub    $0x18,%rsp
  8018f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801900:	eb 0f                	jmp    801911 <strncmp+0x25>
		n--, p++, q++;
  801902:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801907:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80190c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801911:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801916:	74 1d                	je     801935 <strncmp+0x49>
  801918:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	84 c0                	test   %al,%al
  801921:	74 12                	je     801935 <strncmp+0x49>
  801923:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801927:	0f b6 10             	movzbl (%rax),%edx
  80192a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	38 c2                	cmp    %al,%dl
  801933:	74 cd                	je     801902 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801935:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80193a:	75 07                	jne    801943 <strncmp+0x57>
		return 0;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
  801941:	eb 1a                	jmp    80195d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f b6 d0             	movzbl %al,%edx
  80194d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801951:	0f b6 00             	movzbl (%rax),%eax
  801954:	0f b6 c0             	movzbl %al,%eax
  801957:	89 d1                	mov    %edx,%ecx
  801959:	29 c1                	sub    %eax,%ecx
  80195b:	89 c8                	mov    %ecx,%eax
}
  80195d:	c9                   	leaveq 
  80195e:	c3                   	retq   

000000000080195f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	48 83 ec 10          	sub    $0x10,%rsp
  801967:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196b:	89 f0                	mov    %esi,%eax
  80196d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801970:	eb 17                	jmp    801989 <strchr+0x2a>
		if (*s == c)
  801972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801976:	0f b6 00             	movzbl (%rax),%eax
  801979:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80197c:	75 06                	jne    801984 <strchr+0x25>
			return (char *) s;
  80197e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801982:	eb 15                	jmp    801999 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801984:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198d:	0f b6 00             	movzbl (%rax),%eax
  801990:	84 c0                	test   %al,%al
  801992:	75 de                	jne    801972 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801999:	c9                   	leaveq 
  80199a:	c3                   	retq   

000000000080199b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80199b:	55                   	push   %rbp
  80199c:	48 89 e5             	mov    %rsp,%rbp
  80199f:	48 83 ec 10          	sub    $0x10,%rsp
  8019a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019a7:	89 f0                	mov    %esi,%eax
  8019a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8019ac:	eb 11                	jmp    8019bf <strfind+0x24>
		if (*s == c)
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019b8:	74 12                	je     8019cc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	84 c0                	test   %al,%al
  8019c8:	75 e4                	jne    8019ae <strfind+0x13>
  8019ca:	eb 01                	jmp    8019cd <strfind+0x32>
		if (*s == c)
			break;
  8019cc:	90                   	nop
	return (char *) s;
  8019cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019d1:	c9                   	leaveq 
  8019d2:	c3                   	retq   

00000000008019d3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	48 83 ec 18          	sub    $0x18,%rsp
  8019db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019df:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019eb:	75 06                	jne    8019f3 <memset+0x20>
		return v;
  8019ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f1:	eb 69                	jmp    801a5c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f7:	83 e0 03             	and    $0x3,%eax
  8019fa:	48 85 c0             	test   %rax,%rax
  8019fd:	75 48                	jne    801a47 <memset+0x74>
  8019ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a03:	83 e0 03             	and    $0x3,%eax
  801a06:	48 85 c0             	test   %rax,%rax
  801a09:	75 3c                	jne    801a47 <memset+0x74>
		c &= 0xFF;
  801a0b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801a12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a15:	89 c2                	mov    %eax,%edx
  801a17:	c1 e2 18             	shl    $0x18,%edx
  801a1a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a1d:	c1 e0 10             	shl    $0x10,%eax
  801a20:	09 c2                	or     %eax,%edx
  801a22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a25:	c1 e0 08             	shl    $0x8,%eax
  801a28:	09 d0                	or     %edx,%eax
  801a2a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a31:	48 89 c1             	mov    %rax,%rcx
  801a34:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a3c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a3f:	48 89 d7             	mov    %rdx,%rdi
  801a42:	fc                   	cld    
  801a43:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a45:	eb 11                	jmp    801a58 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a47:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a52:	48 89 d7             	mov    %rdx,%rdi
  801a55:	fc                   	cld    
  801a56:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a5c:	c9                   	leaveq 
  801a5d:	c3                   	retq   

0000000000801a5e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a5e:	55                   	push   %rbp
  801a5f:	48 89 e5             	mov    %rsp,%rbp
  801a62:	48 83 ec 28          	sub    $0x28,%rsp
  801a66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a6e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a86:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a8a:	0f 83 88 00 00 00    	jae    801b18 <memmove+0xba>
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a98:	48 01 d0             	add    %rdx,%rax
  801a9b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a9f:	76 77                	jbe    801b18 <memmove+0xba>
		s += n;
  801aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801aa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aad:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab5:	83 e0 03             	and    $0x3,%eax
  801ab8:	48 85 c0             	test   %rax,%rax
  801abb:	75 3b                	jne    801af8 <memmove+0x9a>
  801abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac1:	83 e0 03             	and    $0x3,%eax
  801ac4:	48 85 c0             	test   %rax,%rax
  801ac7:	75 2f                	jne    801af8 <memmove+0x9a>
  801ac9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acd:	83 e0 03             	and    $0x3,%eax
  801ad0:	48 85 c0             	test   %rax,%rax
  801ad3:	75 23                	jne    801af8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad9:	48 83 e8 04          	sub    $0x4,%rax
  801add:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ae1:	48 83 ea 04          	sub    $0x4,%rdx
  801ae5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ae9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801aed:	48 89 c7             	mov    %rax,%rdi
  801af0:	48 89 d6             	mov    %rdx,%rsi
  801af3:	fd                   	std    
  801af4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801af6:	eb 1d                	jmp    801b15 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801af8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b04:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0c:	48 89 d7             	mov    %rdx,%rdi
  801b0f:	48 89 c1             	mov    %rax,%rcx
  801b12:	fd                   	std    
  801b13:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b15:	fc                   	cld    
  801b16:	eb 57                	jmp    801b6f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1c:	83 e0 03             	and    $0x3,%eax
  801b1f:	48 85 c0             	test   %rax,%rax
  801b22:	75 36                	jne    801b5a <memmove+0xfc>
  801b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b28:	83 e0 03             	and    $0x3,%eax
  801b2b:	48 85 c0             	test   %rax,%rax
  801b2e:	75 2a                	jne    801b5a <memmove+0xfc>
  801b30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b34:	83 e0 03             	and    $0x3,%eax
  801b37:	48 85 c0             	test   %rax,%rax
  801b3a:	75 1e                	jne    801b5a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b40:	48 89 c1             	mov    %rax,%rcx
  801b43:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b4f:	48 89 c7             	mov    %rax,%rdi
  801b52:	48 89 d6             	mov    %rdx,%rsi
  801b55:	fc                   	cld    
  801b56:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b58:	eb 15                	jmp    801b6f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b62:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b66:	48 89 c7             	mov    %rax,%rdi
  801b69:	48 89 d6             	mov    %rdx,%rsi
  801b6c:	fc                   	cld    
  801b6d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b73:	c9                   	leaveq 
  801b74:	c3                   	retq   

0000000000801b75 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b75:	55                   	push   %rbp
  801b76:	48 89 e5             	mov    %rsp,%rbp
  801b79:	48 83 ec 18          	sub    $0x18,%rsp
  801b7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b85:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b8d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b95:	48 89 ce             	mov    %rcx,%rsi
  801b98:	48 89 c7             	mov    %rax,%rdi
  801b9b:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 28          	sub    $0x28,%rsp
  801bb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801bbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801bc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801bcd:	eb 38                	jmp    801c07 <memcmp+0x5e>
		if (*s1 != *s2)
  801bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd3:	0f b6 10             	movzbl (%rax),%edx
  801bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bda:	0f b6 00             	movzbl (%rax),%eax
  801bdd:	38 c2                	cmp    %al,%dl
  801bdf:	74 1c                	je     801bfd <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801be1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be5:	0f b6 00             	movzbl (%rax),%eax
  801be8:	0f b6 d0             	movzbl %al,%edx
  801beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bef:	0f b6 00             	movzbl (%rax),%eax
  801bf2:	0f b6 c0             	movzbl %al,%eax
  801bf5:	89 d1                	mov    %edx,%ecx
  801bf7:	29 c1                	sub    %eax,%ecx
  801bf9:	89 c8                	mov    %ecx,%eax
  801bfb:	eb 20                	jmp    801c1d <memcmp+0x74>
		s1++, s2++;
  801bfd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c02:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c0c:	0f 95 c0             	setne  %al
  801c0f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c14:	84 c0                	test   %al,%al
  801c16:	75 b7                	jne    801bcf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 28          	sub    $0x28,%rsp
  801c27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c2b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c3a:	48 01 d0             	add    %rdx,%rax
  801c3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c41:	eb 13                	jmp    801c56 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c47:	0f b6 10             	movzbl (%rax),%edx
  801c4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c4d:	38 c2                	cmp    %al,%dl
  801c4f:	74 11                	je     801c62 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c51:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c5e:	72 e3                	jb     801c43 <memfind+0x24>
  801c60:	eb 01                	jmp    801c63 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c62:	90                   	nop
	return (void *) s;
  801c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c67:	c9                   	leaveq 
  801c68:	c3                   	retq   

0000000000801c69 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c69:	55                   	push   %rbp
  801c6a:	48 89 e5             	mov    %rsp,%rbp
  801c6d:	48 83 ec 38          	sub    $0x38,%rsp
  801c71:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c75:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c79:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c83:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c8a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c8b:	eb 05                	jmp    801c92 <strtol+0x29>
		s++;
  801c8d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c96:	0f b6 00             	movzbl (%rax),%eax
  801c99:	3c 20                	cmp    $0x20,%al
  801c9b:	74 f0                	je     801c8d <strtol+0x24>
  801c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca1:	0f b6 00             	movzbl (%rax),%eax
  801ca4:	3c 09                	cmp    $0x9,%al
  801ca6:	74 e5                	je     801c8d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cac:	0f b6 00             	movzbl (%rax),%eax
  801caf:	3c 2b                	cmp    $0x2b,%al
  801cb1:	75 07                	jne    801cba <strtol+0x51>
		s++;
  801cb3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb8:	eb 17                	jmp    801cd1 <strtol+0x68>
	else if (*s == '-')
  801cba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbe:	0f b6 00             	movzbl (%rax),%eax
  801cc1:	3c 2d                	cmp    $0x2d,%al
  801cc3:	75 0c                	jne    801cd1 <strtol+0x68>
		s++, neg = 1;
  801cc5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cd1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cd5:	74 06                	je     801cdd <strtol+0x74>
  801cd7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801cdb:	75 28                	jne    801d05 <strtol+0x9c>
  801cdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce1:	0f b6 00             	movzbl (%rax),%eax
  801ce4:	3c 30                	cmp    $0x30,%al
  801ce6:	75 1d                	jne    801d05 <strtol+0x9c>
  801ce8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cec:	48 83 c0 01          	add    $0x1,%rax
  801cf0:	0f b6 00             	movzbl (%rax),%eax
  801cf3:	3c 78                	cmp    $0x78,%al
  801cf5:	75 0e                	jne    801d05 <strtol+0x9c>
		s += 2, base = 16;
  801cf7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801cfc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801d03:	eb 2c                	jmp    801d31 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801d05:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d09:	75 19                	jne    801d24 <strtol+0xbb>
  801d0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0f:	0f b6 00             	movzbl (%rax),%eax
  801d12:	3c 30                	cmp    $0x30,%al
  801d14:	75 0e                	jne    801d24 <strtol+0xbb>
		s++, base = 8;
  801d16:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d1b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d22:	eb 0d                	jmp    801d31 <strtol+0xc8>
	else if (base == 0)
  801d24:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d28:	75 07                	jne    801d31 <strtol+0xc8>
		base = 10;
  801d2a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d35:	0f b6 00             	movzbl (%rax),%eax
  801d38:	3c 2f                	cmp    $0x2f,%al
  801d3a:	7e 1d                	jle    801d59 <strtol+0xf0>
  801d3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d40:	0f b6 00             	movzbl (%rax),%eax
  801d43:	3c 39                	cmp    $0x39,%al
  801d45:	7f 12                	jg     801d59 <strtol+0xf0>
			dig = *s - '0';
  801d47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4b:	0f b6 00             	movzbl (%rax),%eax
  801d4e:	0f be c0             	movsbl %al,%eax
  801d51:	83 e8 30             	sub    $0x30,%eax
  801d54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d57:	eb 4e                	jmp    801da7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5d:	0f b6 00             	movzbl (%rax),%eax
  801d60:	3c 60                	cmp    $0x60,%al
  801d62:	7e 1d                	jle    801d81 <strtol+0x118>
  801d64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d68:	0f b6 00             	movzbl (%rax),%eax
  801d6b:	3c 7a                	cmp    $0x7a,%al
  801d6d:	7f 12                	jg     801d81 <strtol+0x118>
			dig = *s - 'a' + 10;
  801d6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d73:	0f b6 00             	movzbl (%rax),%eax
  801d76:	0f be c0             	movsbl %al,%eax
  801d79:	83 e8 57             	sub    $0x57,%eax
  801d7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d7f:	eb 26                	jmp    801da7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d85:	0f b6 00             	movzbl (%rax),%eax
  801d88:	3c 40                	cmp    $0x40,%al
  801d8a:	7e 47                	jle    801dd3 <strtol+0x16a>
  801d8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d90:	0f b6 00             	movzbl (%rax),%eax
  801d93:	3c 5a                	cmp    $0x5a,%al
  801d95:	7f 3c                	jg     801dd3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801d97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9b:	0f b6 00             	movzbl (%rax),%eax
  801d9e:	0f be c0             	movsbl %al,%eax
  801da1:	83 e8 37             	sub    $0x37,%eax
  801da4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801da7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801daa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801dad:	7d 23                	jge    801dd2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801daf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801db4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801db7:	48 98                	cltq   
  801db9:	48 89 c2             	mov    %rax,%rdx
  801dbc:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dc4:	48 98                	cltq   
  801dc6:	48 01 d0             	add    %rdx,%rax
  801dc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801dcd:	e9 5f ff ff ff       	jmpq   801d31 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801dd2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801dd3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801dd8:	74 0b                	je     801de5 <strtol+0x17c>
		*endptr = (char *) s;
  801dda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dde:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801de2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801de5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de9:	74 09                	je     801df4 <strtol+0x18b>
  801deb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801def:	48 f7 d8             	neg    %rax
  801df2:	eb 04                	jmp    801df8 <strtol+0x18f>
  801df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <strstr>:

char * strstr(const char *in, const char *str)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 30          	sub    $0x30,%rsp
  801e02:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801e0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e0e:	0f b6 00             	movzbl (%rax),%eax
  801e11:	88 45 ff             	mov    %al,-0x1(%rbp)
  801e14:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801e19:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e1d:	75 06                	jne    801e25 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e23:	eb 68                	jmp    801e8d <strstr+0x93>

	len = strlen(str);
  801e25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e29:	48 89 c7             	mov    %rax,%rdi
  801e2c:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
  801e38:	48 98                	cltq   
  801e3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e42:	0f b6 00             	movzbl (%rax),%eax
  801e45:	88 45 ef             	mov    %al,-0x11(%rbp)
  801e48:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801e4d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e51:	75 07                	jne    801e5a <strstr+0x60>
				return (char *) 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 33                	jmp    801e8d <strstr+0x93>
		} while (sc != c);
  801e5a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e5e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e61:	75 db                	jne    801e3e <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801e63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e67:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6f:	48 89 ce             	mov    %rcx,%rsi
  801e72:	48 89 c7             	mov    %rax,%rdi
  801e75:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
  801e81:	85 c0                	test   %eax,%eax
  801e83:	75 b9                	jne    801e3e <strstr+0x44>

	return (char *) (in - 1);
  801e85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e89:	48 83 e8 01          	sub    $0x1,%rax
}
  801e8d:	c9                   	leaveq 
  801e8e:	c3                   	retq   
	...

0000000000801e90 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	53                   	push   %rbx
  801e95:	48 83 ec 58          	sub    $0x58,%rsp
  801e99:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e9c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e9f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ea3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ea7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801eab:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eaf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801eb2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801eb5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801eb9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ebd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ec1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ec5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ec9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ecc:	4c 89 c3             	mov    %r8,%rbx
  801ecf:	cd 30                	int    $0x30
  801ed1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801ed5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801edd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ee1:	74 3e                	je     801f21 <syscall+0x91>
  801ee3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ee8:	7e 37                	jle    801f21 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801eea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801eee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ef1:	49 89 d0             	mov    %rdx,%r8
  801ef4:	89 c1                	mov    %eax,%ecx
  801ef6:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  801efd:	00 00 00 
  801f00:	be 23 00 00 00       	mov    $0x23,%esi
  801f05:	48 bf 65 4b 80 00 00 	movabs $0x804b65,%rdi
  801f0c:	00 00 00 
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	49 b9 30 09 80 00 00 	movabs $0x800930,%r9
  801f1b:	00 00 00 
  801f1e:	41 ff d1             	callq  *%r9

	return ret;
  801f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f25:	48 83 c4 58          	add    $0x58,%rsp
  801f29:	5b                   	pop    %rbx
  801f2a:	5d                   	pop    %rbp
  801f2b:	c3                   	retq   

0000000000801f2c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f2c:	55                   	push   %rbp
  801f2d:	48 89 e5             	mov    %rsp,%rbp
  801f30:	48 83 ec 20          	sub    $0x20,%rsp
  801f34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f4b:	00 
  801f4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f58:	48 89 d1             	mov    %rdx,%rcx
  801f5b:	48 89 c2             	mov    %rax,%rdx
  801f5e:	be 00 00 00 00       	mov    $0x0,%esi
  801f63:	bf 00 00 00 00       	mov    $0x0,%edi
  801f68:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801f6f:	00 00 00 
  801f72:	ff d0                	callq  *%rax
}
  801f74:	c9                   	leaveq 
  801f75:	c3                   	retq   

0000000000801f76 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f76:	55                   	push   %rbp
  801f77:	48 89 e5             	mov    %rsp,%rbp
  801f7a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f85:	00 
  801f86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f92:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f97:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9c:	be 00 00 00 00       	mov    $0x0,%esi
  801fa1:	bf 01 00 00 00       	mov    $0x1,%edi
  801fa6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
}
  801fb2:	c9                   	leaveq 
  801fb3:	c3                   	retq   

0000000000801fb4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 20          	sub    $0x20,%rsp
  801fbc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc2:	48 98                	cltq   
  801fc4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fcb:	00 
  801fcc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fdd:	48 89 c2             	mov    %rax,%rdx
  801fe0:	be 01 00 00 00       	mov    $0x1,%esi
  801fe5:	bf 03 00 00 00       	mov    $0x3,%edi
  801fea:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	callq  *%rax
}
  801ff6:	c9                   	leaveq 
  801ff7:	c3                   	retq   

0000000000801ff8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ff8:	55                   	push   %rbp
  801ff9:	48 89 e5             	mov    %rsp,%rbp
  801ffc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802000:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802007:	00 
  802008:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802014:	b9 00 00 00 00       	mov    $0x0,%ecx
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	be 00 00 00 00       	mov    $0x0,%esi
  802023:	bf 02 00 00 00       	mov    $0x2,%edi
  802028:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  80202f:	00 00 00 
  802032:	ff d0                	callq  *%rax
}
  802034:	c9                   	leaveq 
  802035:	c3                   	retq   

0000000000802036 <sys_yield>:

void
sys_yield(void)
{
  802036:	55                   	push   %rbp
  802037:	48 89 e5             	mov    %rsp,%rbp
  80203a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80203e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802045:	00 
  802046:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80204c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802052:	b9 00 00 00 00       	mov    $0x0,%ecx
  802057:	ba 00 00 00 00       	mov    $0x0,%edx
  80205c:	be 00 00 00 00       	mov    $0x0,%esi
  802061:	bf 0b 00 00 00       	mov    $0xb,%edi
  802066:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
}
  802072:	c9                   	leaveq 
  802073:	c3                   	retq   

0000000000802074 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802074:	55                   	push   %rbp
  802075:	48 89 e5             	mov    %rsp,%rbp
  802078:	48 83 ec 20          	sub    $0x20,%rsp
  80207c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80207f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802083:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802086:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802089:	48 63 c8             	movslq %eax,%rcx
  80208c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802093:	48 98                	cltq   
  802095:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80209c:	00 
  80209d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a3:	49 89 c8             	mov    %rcx,%r8
  8020a6:	48 89 d1             	mov    %rdx,%rcx
  8020a9:	48 89 c2             	mov    %rax,%rdx
  8020ac:	be 01 00 00 00       	mov    $0x1,%esi
  8020b1:	bf 04 00 00 00       	mov    $0x4,%edi
  8020b6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8020bd:	00 00 00 
  8020c0:	ff d0                	callq  *%rax
}
  8020c2:	c9                   	leaveq 
  8020c3:	c3                   	retq   

00000000008020c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8020c4:	55                   	push   %rbp
  8020c5:	48 89 e5             	mov    %rsp,%rbp
  8020c8:	48 83 ec 30          	sub    $0x30,%rsp
  8020cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020d3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020da:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020e1:	48 63 c8             	movslq %eax,%rcx
  8020e4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020eb:	48 63 f0             	movslq %eax,%rsi
  8020ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f5:	48 98                	cltq   
  8020f7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020fb:	49 89 f9             	mov    %rdi,%r9
  8020fe:	49 89 f0             	mov    %rsi,%r8
  802101:	48 89 d1             	mov    %rdx,%rcx
  802104:	48 89 c2             	mov    %rax,%rdx
  802107:	be 01 00 00 00       	mov    $0x1,%esi
  80210c:	bf 05 00 00 00       	mov    $0x5,%edi
  802111:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
}
  80211d:	c9                   	leaveq 
  80211e:	c3                   	retq   

000000000080211f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80211f:	55                   	push   %rbp
  802120:	48 89 e5             	mov    %rsp,%rbp
  802123:	48 83 ec 20          	sub    $0x20,%rsp
  802127:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80212a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80212e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802135:	48 98                	cltq   
  802137:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80213e:	00 
  80213f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802145:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80214b:	48 89 d1             	mov    %rdx,%rcx
  80214e:	48 89 c2             	mov    %rax,%rdx
  802151:	be 01 00 00 00       	mov    $0x1,%esi
  802156:	bf 06 00 00 00       	mov    $0x6,%edi
  80215b:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
}
  802167:	c9                   	leaveq 
  802168:	c3                   	retq   

0000000000802169 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802169:	55                   	push   %rbp
  80216a:	48 89 e5             	mov    %rsp,%rbp
  80216d:	48 83 ec 20          	sub    $0x20,%rsp
  802171:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802174:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802177:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80217a:	48 63 d0             	movslq %eax,%rdx
  80217d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802180:	48 98                	cltq   
  802182:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802189:	00 
  80218a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802190:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802196:	48 89 d1             	mov    %rdx,%rcx
  802199:	48 89 c2             	mov    %rax,%rdx
  80219c:	be 01 00 00 00       	mov    $0x1,%esi
  8021a1:	bf 08 00 00 00       	mov    $0x8,%edi
  8021a6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
}
  8021b2:	c9                   	leaveq 
  8021b3:	c3                   	retq   

00000000008021b4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8021b4:	55                   	push   %rbp
  8021b5:	48 89 e5             	mov    %rsp,%rbp
  8021b8:	48 83 ec 20          	sub    $0x20,%rsp
  8021bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8021c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ca:	48 98                	cltq   
  8021cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d3:	00 
  8021d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e0:	48 89 d1             	mov    %rdx,%rcx
  8021e3:	48 89 c2             	mov    %rax,%rdx
  8021e6:	be 01 00 00 00       	mov    $0x1,%esi
  8021eb:	bf 09 00 00 00       	mov    $0x9,%edi
  8021f0:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 20          	sub    $0x20,%rsp
  802206:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802209:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80220d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802214:	48 98                	cltq   
  802216:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80221d:	00 
  80221e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802224:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80222a:	48 89 d1             	mov    %rdx,%rcx
  80222d:	48 89 c2             	mov    %rax,%rdx
  802230:	be 01 00 00 00       	mov    $0x1,%esi
  802235:	bf 0a 00 00 00       	mov    $0xa,%edi
  80223a:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
}
  802246:	c9                   	leaveq 
  802247:	c3                   	retq   

0000000000802248 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802248:	55                   	push   %rbp
  802249:	48 89 e5             	mov    %rsp,%rbp
  80224c:	48 83 ec 30          	sub    $0x30,%rsp
  802250:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802253:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802257:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80225b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80225e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802261:	48 63 f0             	movslq %eax,%rsi
  802264:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	48 98                	cltq   
  80226d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802271:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802278:	00 
  802279:	49 89 f1             	mov    %rsi,%r9
  80227c:	49 89 c8             	mov    %rcx,%r8
  80227f:	48 89 d1             	mov    %rdx,%rcx
  802282:	48 89 c2             	mov    %rax,%rdx
  802285:	be 00 00 00 00       	mov    $0x0,%esi
  80228a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80228f:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
}
  80229b:	c9                   	leaveq 
  80229c:	c3                   	retq   

000000000080229d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80229d:	55                   	push   %rbp
  80229e:	48 89 e5             	mov    %rsp,%rbp
  8022a1:	48 83 ec 20          	sub    $0x20,%rsp
  8022a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8022a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022b4:	00 
  8022b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022c6:	48 89 c2             	mov    %rax,%rdx
  8022c9:	be 01 00 00 00       	mov    $0x1,%esi
  8022ce:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022d3:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8022da:	00 00 00 
  8022dd:	ff d0                	callq  *%rax
}
  8022df:	c9                   	leaveq 
  8022e0:	c3                   	retq   

00000000008022e1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8022e1:	55                   	push   %rbp
  8022e2:	48 89 e5             	mov    %rsp,%rbp
  8022e5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8022e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022f0:	00 
  8022f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  802302:	ba 00 00 00 00       	mov    $0x0,%edx
  802307:	be 00 00 00 00       	mov    $0x0,%esi
  80230c:	bf 0e 00 00 00       	mov    $0xe,%edi
  802311:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
}
  80231d:	c9                   	leaveq 
  80231e:	c3                   	retq   

000000000080231f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80231f:	55                   	push   %rbp
  802320:	48 89 e5             	mov    %rsp,%rbp
  802323:	48 83 ec 30          	sub    $0x30,%rsp
  802327:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80232a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80232e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802331:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802335:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802339:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80233c:	48 63 c8             	movslq %eax,%rcx
  80233f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802343:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802346:	48 63 f0             	movslq %eax,%rsi
  802349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80234d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802350:	48 98                	cltq   
  802352:	48 89 0c 24          	mov    %rcx,(%rsp)
  802356:	49 89 f9             	mov    %rdi,%r9
  802359:	49 89 f0             	mov    %rsi,%r8
  80235c:	48 89 d1             	mov    %rdx,%rcx
  80235f:	48 89 c2             	mov    %rax,%rdx
  802362:	be 00 00 00 00       	mov    $0x0,%esi
  802367:	bf 0f 00 00 00       	mov    $0xf,%edi
  80236c:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802373:	00 00 00 
  802376:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802378:	c9                   	leaveq 
  802379:	c3                   	retq   

000000000080237a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80237a:	55                   	push   %rbp
  80237b:	48 89 e5             	mov    %rsp,%rbp
  80237e:	48 83 ec 20          	sub    $0x20,%rsp
  802382:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802386:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80238a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80238e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802392:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802399:	00 
  80239a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023a6:	48 89 d1             	mov    %rdx,%rcx
  8023a9:	48 89 c2             	mov    %rax,%rdx
  8023ac:	be 00 00 00 00       	mov    $0x0,%esi
  8023b1:	bf 10 00 00 00       	mov    $0x10,%edi
  8023b6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8023bd:	00 00 00 
  8023c0:	ff d0                	callq  *%rax
}
  8023c2:	c9                   	leaveq 
  8023c3:	c3                   	retq   

00000000008023c4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c4:	55                   	push   %rbp
  8023c5:	48 89 e5             	mov    %rsp,%rbp
  8023c8:	48 83 ec 30          	sub    $0x30,%rsp
  8023cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8023d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8023df:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023e4:	74 18                	je     8023fe <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8023e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ea:	48 89 c7             	mov    %rax,%rdi
  8023ed:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fc:	eb 19                	jmp    802417 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8023fe:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  802405:	00 00 00 
  802408:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  80240f:	00 00 00 
  802412:	ff d0                	callq  *%rax
  802414:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  802417:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241b:	79 39                	jns    802456 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  80241d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802422:	75 08                	jne    80242c <ipc_recv+0x68>
  802424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802428:	8b 00                	mov    (%rax),%eax
  80242a:	eb 05                	jmp    802431 <ipc_recv+0x6d>
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
  802431:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802435:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  802437:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80243c:	75 08                	jne    802446 <ipc_recv+0x82>
  80243e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802442:	8b 00                	mov    (%rax),%eax
  802444:	eb 05                	jmp    80244b <ipc_recv+0x87>
  802446:	b8 00 00 00 00       	mov    $0x0,%eax
  80244b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80244f:	89 02                	mov    %eax,(%rdx)
		return r;
  802451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802454:	eb 53                	jmp    8024a9 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  802456:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80245b:	74 19                	je     802476 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  80245d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802464:	00 00 00 
  802467:	48 8b 00             	mov    (%rax),%rax
  80246a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802474:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  802476:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80247b:	74 19                	je     802496 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  80247d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802484:	00 00 00 
  802487:	48 8b 00             	mov    (%rax),%rax
  80248a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802494:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  802496:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80249d:	00 00 00 
  8024a0:	48 8b 00             	mov    (%rax),%rax
  8024a3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8024a9:	c9                   	leaveq 
  8024aa:	c3                   	retq   

00000000008024ab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024ab:	55                   	push   %rbp
  8024ac:	48 89 e5             	mov    %rsp,%rbp
  8024af:	48 83 ec 30          	sub    $0x30,%rsp
  8024b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8024b9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8024bd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8024c0:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8024c7:	eb 59                	jmp    802522 <ipc_send+0x77>
		if(pg) {
  8024c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024ce:	74 20                	je     8024f0 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8024d0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024d3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8024d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ee:	eb 26                	jmp    802516 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8024f0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024f3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f9:	89 d1                	mov    %edx,%ecx
  8024fb:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  802502:	00 00 00 
  802505:	89 c7                	mov    %eax,%edi
  802507:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  80250e:	00 00 00 
  802511:	ff d0                	callq  *%rax
  802513:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  802516:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  802522:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802526:	74 a1                	je     8024c9 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  802528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252c:	74 2a                	je     802558 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  80252e:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  802535:	00 00 00 
  802538:	be 49 00 00 00       	mov    $0x49,%esi
  80253d:	48 bf a3 4b 80 00 00 	movabs $0x804ba3,%rdi
  802544:	00 00 00 
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	48 b9 30 09 80 00 00 	movabs $0x800930,%rcx
  802553:	00 00 00 
  802556:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  802558:	c9                   	leaveq 
  802559:	c3                   	retq   

000000000080255a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80255a:	55                   	push   %rbp
  80255b:	48 89 e5             	mov    %rsp,%rbp
  80255e:	48 83 ec 18          	sub    $0x18,%rsp
  802562:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80256c:	eb 6a                	jmp    8025d8 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80256e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802575:	00 00 00 
  802578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257b:	48 63 d0             	movslq %eax,%rdx
  80257e:	48 89 d0             	mov    %rdx,%rax
  802581:	48 c1 e0 02          	shl    $0x2,%rax
  802585:	48 01 d0             	add    %rdx,%rax
  802588:	48 01 c0             	add    %rax,%rax
  80258b:	48 01 d0             	add    %rdx,%rax
  80258e:	48 c1 e0 05          	shl    $0x5,%rax
  802592:	48 01 c8             	add    %rcx,%rax
  802595:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80259b:	8b 00                	mov    (%rax),%eax
  80259d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025a0:	75 32                	jne    8025d4 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8025a2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8025a9:	00 00 00 
  8025ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025af:	48 63 d0             	movslq %eax,%rdx
  8025b2:	48 89 d0             	mov    %rdx,%rax
  8025b5:	48 c1 e0 02          	shl    $0x2,%rax
  8025b9:	48 01 d0             	add    %rdx,%rax
  8025bc:	48 01 c0             	add    %rax,%rax
  8025bf:	48 01 d0             	add    %rdx,%rax
  8025c2:	48 c1 e0 05          	shl    $0x5,%rax
  8025c6:	48 01 c8             	add    %rcx,%rax
  8025c9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8025cf:	8b 40 08             	mov    0x8(%rax),%eax
  8025d2:	eb 12                	jmp    8025e6 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8025d4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025d8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8025df:	7e 8d                	jle    80256e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e6:	c9                   	leaveq 
  8025e7:	c3                   	retq   

00000000008025e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025e8:	55                   	push   %rbp
  8025e9:	48 89 e5             	mov    %rsp,%rbp
  8025ec:	48 83 ec 08          	sub    $0x8,%rsp
  8025f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025f8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025ff:	ff ff ff 
  802602:	48 01 d0             	add    %rdx,%rax
  802605:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802609:	c9                   	leaveq 
  80260a:	c3                   	retq   

000000000080260b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80260b:	55                   	push   %rbp
  80260c:	48 89 e5             	mov    %rsp,%rbp
  80260f:	48 83 ec 08          	sub    $0x8,%rsp
  802613:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261b:	48 89 c7             	mov    %rax,%rdi
  80261e:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802625:	00 00 00 
  802628:	ff d0                	callq  *%rax
  80262a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802630:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802634:	c9                   	leaveq 
  802635:	c3                   	retq   

0000000000802636 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802636:	55                   	push   %rbp
  802637:	48 89 e5             	mov    %rsp,%rbp
  80263a:	48 83 ec 18          	sub    $0x18,%rsp
  80263e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802642:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802649:	eb 6b                	jmp    8026b6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80264b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264e:	48 98                	cltq   
  802650:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802656:	48 c1 e0 0c          	shl    $0xc,%rax
  80265a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80265e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802662:	48 89 c2             	mov    %rax,%rdx
  802665:	48 c1 ea 15          	shr    $0x15,%rdx
  802669:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802670:	01 00 00 
  802673:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802677:	83 e0 01             	and    $0x1,%eax
  80267a:	48 85 c0             	test   %rax,%rax
  80267d:	74 21                	je     8026a0 <fd_alloc+0x6a>
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 89 c2             	mov    %rax,%rdx
  802686:	48 c1 ea 0c          	shr    $0xc,%rdx
  80268a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802691:	01 00 00 
  802694:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802698:	83 e0 01             	and    $0x1,%eax
  80269b:	48 85 c0             	test   %rax,%rax
  80269e:	75 12                	jne    8026b2 <fd_alloc+0x7c>
			*fd_store = fd;
  8026a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	eb 1a                	jmp    8026cc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026ba:	7e 8f                	jle    80264b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026c7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026cc:	c9                   	leaveq 
  8026cd:	c3                   	retq   

00000000008026ce <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026ce:	55                   	push   %rbp
  8026cf:	48 89 e5             	mov    %rsp,%rbp
  8026d2:	48 83 ec 20          	sub    $0x20,%rsp
  8026d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026e1:	78 06                	js     8026e9 <fd_lookup+0x1b>
  8026e3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026e7:	7e 07                	jle    8026f0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ee:	eb 6c                	jmp    80275c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026f3:	48 98                	cltq   
  8026f5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026fb:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802707:	48 89 c2             	mov    %rax,%rdx
  80270a:	48 c1 ea 15          	shr    $0x15,%rdx
  80270e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802715:	01 00 00 
  802718:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271c:	83 e0 01             	and    $0x1,%eax
  80271f:	48 85 c0             	test   %rax,%rax
  802722:	74 21                	je     802745 <fd_lookup+0x77>
  802724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802728:	48 89 c2             	mov    %rax,%rdx
  80272b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80272f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802736:	01 00 00 
  802739:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80273d:	83 e0 01             	and    $0x1,%eax
  802740:	48 85 c0             	test   %rax,%rax
  802743:	75 07                	jne    80274c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80274a:	eb 10                	jmp    80275c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80274c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802750:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802754:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275c:	c9                   	leaveq 
  80275d:	c3                   	retq   

000000000080275e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	48 83 ec 30          	sub    $0x30,%rsp
  802766:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80276a:	89 f0                	mov    %esi,%eax
  80276c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80276f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802773:	48 89 c7             	mov    %rax,%rdi
  802776:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  80277d:	00 00 00 
  802780:	ff d0                	callq  *%rax
  802782:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802786:	48 89 d6             	mov    %rdx,%rsi
  802789:	89 c7                	mov    %eax,%edi
  80278b:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279e:	78 0a                	js     8027aa <fd_close+0x4c>
	    || fd != fd2)
  8027a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027a8:	74 12                	je     8027bc <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027aa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027ae:	74 05                	je     8027b5 <fd_close+0x57>
  8027b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b3:	eb 05                	jmp    8027ba <fd_close+0x5c>
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ba:	eb 69                	jmp    802825 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c0:	8b 00                	mov    (%rax),%eax
  8027c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027c6:	48 89 d6             	mov    %rdx,%rsi
  8027c9:	89 c7                	mov    %eax,%edi
  8027cb:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
  8027d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027de:	78 2a                	js     80280a <fd_close+0xac>
		if (dev->dev_close)
  8027e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027e8:	48 85 c0             	test   %rax,%rax
  8027eb:	74 16                	je     802803 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f1:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8027f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f9:	48 89 c7             	mov    %rax,%rdi
  8027fc:	ff d2                	callq  *%rdx
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802801:	eb 07                	jmp    80280a <fd_close+0xac>
		else
			r = 0;
  802803:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80280a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280e:	48 89 c6             	mov    %rax,%rsi
  802811:	bf 00 00 00 00       	mov    $0x0,%edi
  802816:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  80281d:	00 00 00 
  802820:	ff d0                	callq  *%rax
	return r;
  802822:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802825:	c9                   	leaveq 
  802826:	c3                   	retq   

0000000000802827 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802827:	55                   	push   %rbp
  802828:	48 89 e5             	mov    %rsp,%rbp
  80282b:	48 83 ec 20          	sub    $0x20,%rsp
  80282f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802832:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80283d:	eb 41                	jmp    802880 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80283f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802846:	00 00 00 
  802849:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80284c:	48 63 d2             	movslq %edx,%rdx
  80284f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802853:	8b 00                	mov    (%rax),%eax
  802855:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802858:	75 22                	jne    80287c <dev_lookup+0x55>
			*dev = devtab[i];
  80285a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802861:	00 00 00 
  802864:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802867:	48 63 d2             	movslq %edx,%rdx
  80286a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80286e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802872:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802875:	b8 00 00 00 00       	mov    $0x0,%eax
  80287a:	eb 60                	jmp    8028dc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80287c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802880:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802887:	00 00 00 
  80288a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80288d:	48 63 d2             	movslq %edx,%rdx
  802890:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802894:	48 85 c0             	test   %rax,%rax
  802897:	75 a6                	jne    80283f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802899:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a0:	00 00 00 
  8028a3:	48 8b 00             	mov    (%rax),%rax
  8028a6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028ac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028af:	89 c6                	mov    %eax,%esi
  8028b1:	48 bf b0 4b 80 00 00 	movabs $0x804bb0,%rdi
  8028b8:	00 00 00 
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	48 b9 6b 0b 80 00 00 	movabs $0x800b6b,%rcx
  8028c7:	00 00 00 
  8028ca:	ff d1                	callq  *%rcx
	*dev = 0;
  8028cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028dc:	c9                   	leaveq 
  8028dd:	c3                   	retq   

00000000008028de <close>:

int
close(int fdnum)
{
  8028de:	55                   	push   %rbp
  8028df:	48 89 e5             	mov    %rsp,%rbp
  8028e2:	48 83 ec 20          	sub    $0x20,%rsp
  8028e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028f0:	48 89 d6             	mov    %rdx,%rsi
  8028f3:	89 c7                	mov    %eax,%edi
  8028f5:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
  802901:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802904:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802908:	79 05                	jns    80290f <close+0x31>
		return r;
  80290a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290d:	eb 18                	jmp    802927 <close+0x49>
	else
		return fd_close(fd, 1);
  80290f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802913:	be 01 00 00 00       	mov    $0x1,%esi
  802918:	48 89 c7             	mov    %rax,%rdi
  80291b:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
}
  802927:	c9                   	leaveq 
  802928:	c3                   	retq   

0000000000802929 <close_all>:

void
close_all(void)
{
  802929:	55                   	push   %rbp
  80292a:	48 89 e5             	mov    %rsp,%rbp
  80292d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802931:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802938:	eb 15                	jmp    80294f <close_all+0x26>
		close(i);
  80293a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80294b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80294f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802953:	7e e5                	jle    80293a <close_all+0x11>
		close(i);
}
  802955:	c9                   	leaveq 
  802956:	c3                   	retq   

0000000000802957 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802957:	55                   	push   %rbp
  802958:	48 89 e5             	mov    %rsp,%rbp
  80295b:	48 83 ec 40          	sub    $0x40,%rsp
  80295f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802962:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802965:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802969:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80296c:	48 89 d6             	mov    %rdx,%rsi
  80296f:	89 c7                	mov    %eax,%edi
  802971:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
  80297d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802984:	79 08                	jns    80298e <dup+0x37>
		return r;
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	e9 70 01 00 00       	jmpq   802afe <dup+0x1a7>
	close(newfdnum);
  80298e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802991:	89 c7                	mov    %eax,%edi
  802993:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80299f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a2:	48 98                	cltq   
  8029a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8029ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029b6:	48 89 c7             	mov    %rax,%rdi
  8029b9:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cd:	48 89 c7             	mov    %rax,%rdi
  8029d0:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e4:	48 89 c2             	mov    %rax,%rdx
  8029e7:	48 c1 ea 15          	shr    $0x15,%rdx
  8029eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029f2:	01 00 00 
  8029f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f9:	83 e0 01             	and    $0x1,%eax
  8029fc:	84 c0                	test   %al,%al
  8029fe:	74 71                	je     802a71 <dup+0x11a>
  802a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a04:	48 89 c2             	mov    %rax,%rdx
  802a07:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a12:	01 00 00 
  802a15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a19:	83 e0 01             	and    $0x1,%eax
  802a1c:	84 c0                	test   %al,%al
  802a1e:	74 51                	je     802a71 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a24:	48 89 c2             	mov    %rax,%rdx
  802a27:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a32:	01 00 00 
  802a35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a39:	89 c1                	mov    %eax,%ecx
  802a3b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a41:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a49:	41 89 c8             	mov    %ecx,%r8d
  802a4c:	48 89 d1             	mov    %rdx,%rcx
  802a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a54:	48 89 c6             	mov    %rax,%rsi
  802a57:	bf 00 00 00 00       	mov    $0x0,%edi
  802a5c:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6f:	78 56                	js     802ac7 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a75:	48 89 c2             	mov    %rax,%rdx
  802a78:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a7c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a83:	01 00 00 
  802a86:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a8a:	89 c1                	mov    %eax,%ecx
  802a8c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a9a:	41 89 c8             	mov    %ecx,%r8d
  802a9d:	48 89 d1             	mov    %rdx,%rcx
  802aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa5:	48 89 c6             	mov    %rax,%rsi
  802aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  802aad:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
  802ab9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac0:	78 08                	js     802aca <dup+0x173>
		goto err;

	return newfdnum;
  802ac2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ac5:	eb 37                	jmp    802afe <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ac7:	90                   	nop
  802ac8:	eb 01                	jmp    802acb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802aca:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802acf:	48 89 c6             	mov    %rax,%rsi
  802ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad7:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ae3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae7:	48 89 c6             	mov    %rax,%rsi
  802aea:	bf 00 00 00 00       	mov    $0x0,%edi
  802aef:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
	return r;
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802afe:	c9                   	leaveq 
  802aff:	c3                   	retq   

0000000000802b00 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b00:	55                   	push   %rbp
  802b01:	48 89 e5             	mov    %rsp,%rbp
  802b04:	48 83 ec 40          	sub    $0x40,%rsp
  802b08:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b0f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b13:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b1a:	48 89 d6             	mov    %rdx,%rsi
  802b1d:	89 c7                	mov    %eax,%edi
  802b1f:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
  802b2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b32:	78 24                	js     802b58 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b38:	8b 00                	mov    (%rax),%eax
  802b3a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b3e:	48 89 d6             	mov    %rdx,%rsi
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
  802b4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b56:	79 05                	jns    802b5d <read+0x5d>
		return r;
  802b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5b:	eb 7a                	jmp    802bd7 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b61:	8b 40 08             	mov    0x8(%rax),%eax
  802b64:	83 e0 03             	and    $0x3,%eax
  802b67:	83 f8 01             	cmp    $0x1,%eax
  802b6a:	75 3a                	jne    802ba6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b6c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b73:	00 00 00 
  802b76:	48 8b 00             	mov    (%rax),%rax
  802b79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b82:	89 c6                	mov    %eax,%esi
  802b84:	48 bf cf 4b 80 00 00 	movabs $0x804bcf,%rdi
  802b8b:	00 00 00 
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b93:	48 b9 6b 0b 80 00 00 	movabs $0x800b6b,%rcx
  802b9a:	00 00 00 
  802b9d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba4:	eb 31                	jmp    802bd7 <read+0xd7>
	}
	if (!dev->dev_read)
  802ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802baa:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bae:	48 85 c0             	test   %rax,%rax
  802bb1:	75 07                	jne    802bba <read+0xba>
		return -E_NOT_SUPP;
  802bb3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb8:	eb 1d                	jmp    802bd7 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbe:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bca:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bce:	48 89 ce             	mov    %rcx,%rsi
  802bd1:	48 89 c7             	mov    %rax,%rdi
  802bd4:	41 ff d0             	callq  *%r8
}
  802bd7:	c9                   	leaveq 
  802bd8:	c3                   	retq   

0000000000802bd9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bd9:	55                   	push   %rbp
  802bda:	48 89 e5             	mov    %rsp,%rbp
  802bdd:	48 83 ec 30          	sub    $0x30,%rsp
  802be1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802be4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802be8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bf3:	eb 46                	jmp    802c3b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf8:	48 98                	cltq   
  802bfa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bfe:	48 29 c2             	sub    %rax,%rdx
  802c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c04:	48 98                	cltq   
  802c06:	48 89 c1             	mov    %rax,%rcx
  802c09:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802c0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c10:	48 89 ce             	mov    %rcx,%rsi
  802c13:	89 c7                	mov    %eax,%edi
  802c15:	48 b8 00 2b 80 00 00 	movabs $0x802b00,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c24:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c28:	79 05                	jns    802c2f <readn+0x56>
			return m;
  802c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2d:	eb 1d                	jmp    802c4c <readn+0x73>
		if (m == 0)
  802c2f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c33:	74 13                	je     802c48 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c38:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3e:	48 98                	cltq   
  802c40:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c44:	72 af                	jb     802bf5 <readn+0x1c>
  802c46:	eb 01                	jmp    802c49 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c48:	90                   	nop
	}
	return tot;
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c4c:	c9                   	leaveq 
  802c4d:	c3                   	retq   

0000000000802c4e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c4e:	55                   	push   %rbp
  802c4f:	48 89 e5             	mov    %rsp,%rbp
  802c52:	48 83 ec 40          	sub    $0x40,%rsp
  802c56:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c59:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c5d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c61:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c68:	48 89 d6             	mov    %rdx,%rsi
  802c6b:	89 c7                	mov    %eax,%edi
  802c6d:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c80:	78 24                	js     802ca6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	8b 00                	mov    (%rax),%eax
  802c88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c8c:	48 89 d6             	mov    %rdx,%rsi
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	79 05                	jns    802cab <write+0x5d>
		return r;
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca9:	eb 79                	jmp    802d24 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caf:	8b 40 08             	mov    0x8(%rax),%eax
  802cb2:	83 e0 03             	and    $0x3,%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	75 3a                	jne    802cf3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cb9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802cc0:	00 00 00 
  802cc3:	48 8b 00             	mov    (%rax),%rax
  802cc6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ccc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ccf:	89 c6                	mov    %eax,%esi
  802cd1:	48 bf eb 4b 80 00 00 	movabs $0x804beb,%rdi
  802cd8:	00 00 00 
  802cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce0:	48 b9 6b 0b 80 00 00 	movabs $0x800b6b,%rcx
  802ce7:	00 00 00 
  802cea:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cf1:	eb 31                	jmp    802d24 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cfb:	48 85 c0             	test   %rax,%rax
  802cfe:	75 07                	jne    802d07 <write+0xb9>
		return -E_NOT_SUPP;
  802d00:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d05:	eb 1d                	jmp    802d24 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d17:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d1b:	48 89 ce             	mov    %rcx,%rsi
  802d1e:	48 89 c7             	mov    %rax,%rdi
  802d21:	41 ff d0             	callq  *%r8
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 18          	sub    $0x18,%rsp
  802d2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d31:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3b:	48 89 d6             	mov    %rdx,%rsi
  802d3e:	89 c7                	mov    %eax,%edi
  802d40:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
  802d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d53:	79 05                	jns    802d5a <seek+0x34>
		return r;
  802d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d58:	eb 0f                	jmp    802d69 <seek+0x43>
	fd->fd_offset = offset;
  802d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d61:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d69:	c9                   	leaveq 
  802d6a:	c3                   	retq   

0000000000802d6b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d6b:	55                   	push   %rbp
  802d6c:	48 89 e5             	mov    %rsp,%rbp
  802d6f:	48 83 ec 30          	sub    $0x30,%rsp
  802d73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d76:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d80:	48 89 d6             	mov    %rdx,%rsi
  802d83:	89 c7                	mov    %eax,%edi
  802d85:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d98:	78 24                	js     802dbe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	8b 00                	mov    (%rax),%eax
  802da0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802da4:	48 89 d6             	mov    %rdx,%rsi
  802da7:	89 c7                	mov    %eax,%edi
  802da9:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbc:	79 05                	jns    802dc3 <ftruncate+0x58>
		return r;
  802dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc1:	eb 72                	jmp    802e35 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc7:	8b 40 08             	mov    0x8(%rax),%eax
  802dca:	83 e0 03             	and    $0x3,%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	75 3a                	jne    802e0b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802dd1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802dd8:	00 00 00 
  802ddb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dde:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802de4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802de7:	89 c6                	mov    %eax,%esi
  802de9:	48 bf 08 4c 80 00 00 	movabs $0x804c08,%rdi
  802df0:	00 00 00 
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	48 b9 6b 0b 80 00 00 	movabs $0x800b6b,%rcx
  802dff:	00 00 00 
  802e02:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e09:	eb 2a                	jmp    802e35 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e13:	48 85 c0             	test   %rax,%rax
  802e16:	75 07                	jne    802e1f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e1d:	eb 16                	jmp    802e35 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e23:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e2e:	89 d6                	mov    %edx,%esi
  802e30:	48 89 c7             	mov    %rax,%rdi
  802e33:	ff d1                	callq  *%rcx
}
  802e35:	c9                   	leaveq 
  802e36:	c3                   	retq   

0000000000802e37 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e37:	55                   	push   %rbp
  802e38:	48 89 e5             	mov    %rsp,%rbp
  802e3b:	48 83 ec 30          	sub    $0x30,%rsp
  802e3f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e42:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e46:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e4d:	48 89 d6             	mov    %rdx,%rsi
  802e50:	89 c7                	mov    %eax,%edi
  802e52:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
  802e5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e65:	78 24                	js     802e8b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6b:	8b 00                	mov    (%rax),%eax
  802e6d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e71:	48 89 d6             	mov    %rdx,%rsi
  802e74:	89 c7                	mov    %eax,%edi
  802e76:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e89:	79 05                	jns    802e90 <fstat+0x59>
		return r;
  802e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8e:	eb 5e                	jmp    802eee <fstat+0xb7>
	if (!dev->dev_stat)
  802e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e94:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e98:	48 85 c0             	test   %rax,%rax
  802e9b:	75 07                	jne    802ea4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e9d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ea2:	eb 4a                	jmp    802eee <fstat+0xb7>
	stat->st_name[0] = 0;
  802ea4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ea8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802eab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eaf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802eb6:	00 00 00 
	stat->st_isdir = 0;
  802eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ebd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ec4:	00 00 00 
	stat->st_dev = dev;
  802ec7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ecb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ecf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eda:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802ee6:	48 89 d6             	mov    %rdx,%rsi
  802ee9:	48 89 c7             	mov    %rax,%rdi
  802eec:	ff d1                	callq  *%rcx
}
  802eee:	c9                   	leaveq 
  802eef:	c3                   	retq   

0000000000802ef0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ef0:	55                   	push   %rbp
  802ef1:	48 89 e5             	mov    %rsp,%rbp
  802ef4:	48 83 ec 20          	sub    $0x20,%rsp
  802ef8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802efc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f04:	be 00 00 00 00       	mov    $0x0,%esi
  802f09:	48 89 c7             	mov    %rax,%rdi
  802f0c:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
  802f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1f:	79 05                	jns    802f26 <stat+0x36>
		return fd;
  802f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f24:	eb 2f                	jmp    802f55 <stat+0x65>
	r = fstat(fd, stat);
  802f26:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2d:	48 89 d6             	mov    %rdx,%rsi
  802f30:	89 c7                	mov    %eax,%edi
  802f32:	48 b8 37 2e 80 00 00 	movabs $0x802e37,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f44:	89 c7                	mov    %eax,%edi
  802f46:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
	return r;
  802f52:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f55:	c9                   	leaveq 
  802f56:	c3                   	retq   
	...

0000000000802f58 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f58:	55                   	push   %rbp
  802f59:	48 89 e5             	mov    %rsp,%rbp
  802f5c:	48 83 ec 10          	sub    $0x10,%rsp
  802f60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f67:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f6e:	00 00 00 
  802f71:	8b 00                	mov    (%rax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	75 1d                	jne    802f94 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f77:	bf 01 00 00 00       	mov    $0x1,%edi
  802f7c:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
  802f88:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f8f:	00 00 00 
  802f92:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f94:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f9b:	00 00 00 
  802f9e:	8b 00                	mov    (%rax),%eax
  802fa0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fa3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fa8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802faf:	00 00 00 
  802fb2:	89 c7                	mov    %eax,%edi
  802fb4:	48 b8 ab 24 80 00 00 	movabs $0x8024ab,%rax
  802fbb:	00 00 00 
  802fbe:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc9:	48 89 c6             	mov    %rax,%rsi
  802fcc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd1:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
}
  802fdd:	c9                   	leaveq 
  802fde:	c3                   	retq   

0000000000802fdf <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802fdf:	55                   	push   %rbp
  802fe0:	48 89 e5             	mov    %rsp,%rbp
  802fe3:	48 83 ec 20          	sub    $0x20,%rsp
  802fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802feb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff2:	48 89 c7             	mov    %rax,%rdi
  802ff5:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  802ffc:	00 00 00 
  802fff:	ff d0                	callq  *%rax
  803001:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803006:	7e 0a                	jle    803012 <open+0x33>
		return -E_BAD_PATH;
  803008:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80300d:	e9 a5 00 00 00       	jmpq   8030b7 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  803012:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803016:	48 89 c7             	mov    %rax,%rdi
  803019:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302c:	79 08                	jns    803036 <open+0x57>
		return r;
  80302e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803031:	e9 81 00 00 00       	jmpq   8030b7 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  803036:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80303d:	00 00 00 
  803040:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803043:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803049:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304d:	48 89 c6             	mov    %rax,%rsi
  803050:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803057:	00 00 00 
  80305a:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  803066:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306a:	48 89 c6             	mov    %rax,%rsi
  80306d:	bf 01 00 00 00       	mov    $0x1,%edi
  803072:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
  80307e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803081:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803085:	79 1d                	jns    8030a4 <open+0xc5>
		fd_close(new_fd, 0);
  803087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	48 89 c7             	mov    %rax,%rdi
  803093:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
		return r;	
  80309f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a2:	eb 13                	jmp    8030b7 <open+0xd8>
	}
	return fd2num(new_fd);
  8030a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a8:	48 89 c7             	mov    %rax,%rdi
  8030ab:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	callq  *%rax
}
  8030b7:	c9                   	leaveq 
  8030b8:	c3                   	retq   

00000000008030b9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030b9:	55                   	push   %rbp
  8030ba:	48 89 e5             	mov    %rsp,%rbp
  8030bd:	48 83 ec 10          	sub    $0x10,%rsp
  8030c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8030cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030d3:	00 00 00 
  8030d6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030d8:	be 00 00 00 00       	mov    $0x0,%esi
  8030dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8030e2:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
}
  8030ee:	c9                   	leaveq 
  8030ef:	c3                   	retq   

00000000008030f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030f0:	55                   	push   %rbp
  8030f1:	48 89 e5             	mov    %rsp,%rbp
  8030f4:	48 83 ec 30          	sub    $0x30,%rsp
  8030f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803100:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  803104:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803108:	8b 50 0c             	mov    0xc(%rax),%edx
  80310b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803112:	00 00 00 
  803115:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803117:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80311e:	00 00 00 
  803121:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803125:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  803129:	be 00 00 00 00       	mov    $0x0,%esi
  80312e:	bf 03 00 00 00       	mov    $0x3,%edi
  803133:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  803142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803146:	7e 23                	jle    80316b <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  803148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314b:	48 63 d0             	movslq %eax,%rdx
  80314e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803152:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803159:	00 00 00 
  80315c:	48 89 c7             	mov    %rax,%rdi
  80315f:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803166:	00 00 00 
  803169:	ff d0                	callq  *%rax
	}
	return nbytes;
  80316b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80316e:	c9                   	leaveq 
  80316f:	c3                   	retq   

0000000000803170 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803170:	55                   	push   %rbp
  803171:	48 89 e5             	mov    %rsp,%rbp
  803174:	48 83 ec 20          	sub    $0x20,%rsp
  803178:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80317c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803184:	8b 50 0c             	mov    0xc(%rax),%edx
  803187:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318e:	00 00 00 
  803191:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803193:	be 00 00 00 00       	mov    $0x0,%esi
  803198:	bf 05 00 00 00       	mov    $0x5,%edi
  80319d:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
  8031a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b0:	79 05                	jns    8031b7 <devfile_stat+0x47>
		return r;
  8031b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b5:	eb 56                	jmp    80320d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031bb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031c2:	00 00 00 
  8031c5:	48 89 c7             	mov    %rax,%rdi
  8031c8:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  8031cf:	00 00 00 
  8031d2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031db:	00 00 00 
  8031de:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f5:	00 00 00 
  8031f8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803202:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80320d:	c9                   	leaveq 
  80320e:	c3                   	retq   
	...

0000000000803210 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803210:	55                   	push   %rbp
  803211:	48 89 e5             	mov    %rsp,%rbp
  803214:	48 83 ec 20          	sub    $0x20,%rsp
  803218:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80321b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80321f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803222:	48 89 d6             	mov    %rdx,%rsi
  803225:	89 c7                	mov    %eax,%edi
  803227:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803236:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323a:	79 05                	jns    803241 <fd2sockid+0x31>
		return r;
  80323c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323f:	eb 24                	jmp    803265 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803245:	8b 10                	mov    (%rax),%edx
  803247:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80324e:	00 00 00 
  803251:	8b 00                	mov    (%rax),%eax
  803253:	39 c2                	cmp    %eax,%edx
  803255:	74 07                	je     80325e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803257:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80325c:	eb 07                	jmp    803265 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80325e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803262:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803265:	c9                   	leaveq 
  803266:	c3                   	retq   

0000000000803267 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803267:	55                   	push   %rbp
  803268:	48 89 e5             	mov    %rsp,%rbp
  80326b:	48 83 ec 20          	sub    $0x20,%rsp
  80326f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803272:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803276:	48 89 c7             	mov    %rax,%rdi
  803279:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
  803285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328c:	78 26                	js     8032b4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	ba 07 04 00 00       	mov    $0x407,%edx
  803297:	48 89 c6             	mov    %rax,%rsi
  80329a:	bf 00 00 00 00       	mov    $0x0,%edi
  80329f:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
  8032ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b2:	79 16                	jns    8032ca <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b7:	89 c7                	mov    %eax,%edi
  8032b9:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
		return r;
  8032c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c8:	eb 3a                	jmp    803304 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ce:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032d5:	00 00 00 
  8032d8:	8b 12                	mov    (%rdx),%edx
  8032da:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032eb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032ee:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f5:	48 89 c7             	mov    %rax,%rdi
  8032f8:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 30          	sub    $0x30,%rsp
  80330e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803311:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803315:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803319:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80331c:	89 c7                	mov    %eax,%edi
  80331e:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
  80332a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80332d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803331:	79 05                	jns    803338 <accept+0x32>
		return r;
  803333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803336:	eb 3b                	jmp    803373 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803338:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80333c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803343:	48 89 ce             	mov    %rcx,%rsi
  803346:	89 c7                	mov    %eax,%edi
  803348:	48 b8 51 36 80 00 00 	movabs $0x803651,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
  803354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335b:	79 05                	jns    803362 <accept+0x5c>
		return r;
  80335d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803360:	eb 11                	jmp    803373 <accept+0x6d>
	return alloc_sockfd(r);
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 67 32 80 00 00 	movabs $0x803267,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
}
  803373:	c9                   	leaveq 
  803374:	c3                   	retq   

0000000000803375 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 20          	sub    $0x20,%rsp
  80337d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803380:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803384:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803387:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338a:	89 c7                	mov    %eax,%edi
  80338c:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
  803398:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339f:	79 05                	jns    8033a6 <bind+0x31>
		return r;
  8033a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a4:	eb 1b                	jmp    8033c1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033a9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b0:	48 89 ce             	mov    %rcx,%rsi
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 d0 36 80 00 00 	movabs $0x8036d0,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
}
  8033c1:	c9                   	leaveq 
  8033c2:	c3                   	retq   

00000000008033c3 <shutdown>:

int
shutdown(int s, int how)
{
  8033c3:	55                   	push   %rbp
  8033c4:	48 89 e5             	mov    %rsp,%rbp
  8033c7:	48 83 ec 20          	sub    $0x20,%rsp
  8033cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d4:	89 c7                	mov    %eax,%edi
  8033d6:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e9:	79 05                	jns    8033f0 <shutdown+0x2d>
		return r;
  8033eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ee:	eb 16                	jmp    803406 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033f0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f6:	89 d6                	mov    %edx,%esi
  8033f8:	89 c7                	mov    %eax,%edi
  8033fa:	48 b8 34 37 80 00 00 	movabs $0x803734,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
}
  803406:	c9                   	leaveq 
  803407:	c3                   	retq   

0000000000803408 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803408:	55                   	push   %rbp
  803409:	48 89 e5             	mov    %rsp,%rbp
  80340c:	48 83 ec 10          	sub    $0x10,%rsp
  803410:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803418:	48 89 c7             	mov    %rax,%rdi
  80341b:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	83 f8 01             	cmp    $0x1,%eax
  80342a:	75 17                	jne    803443 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80342c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803430:	8b 40 0c             	mov    0xc(%rax),%eax
  803433:	89 c7                	mov    %eax,%edi
  803435:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
  803441:	eb 05                	jmp    803448 <devsock_close+0x40>
	else
		return 0;
  803443:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803448:	c9                   	leaveq 
  803449:	c3                   	retq   

000000000080344a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	48 83 ec 20          	sub    $0x20,%rsp
  803452:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803455:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803459:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80345c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80345f:	89 c7                	mov    %eax,%edi
  803461:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  803468:	00 00 00 
  80346b:	ff d0                	callq  *%rax
  80346d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803474:	79 05                	jns    80347b <connect+0x31>
		return r;
  803476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803479:	eb 1b                	jmp    803496 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80347b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80347e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803485:	48 89 ce             	mov    %rcx,%rsi
  803488:	89 c7                	mov    %eax,%edi
  80348a:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
}
  803496:	c9                   	leaveq 
  803497:	c3                   	retq   

0000000000803498 <listen>:

int
listen(int s, int backlog)
{
  803498:	55                   	push   %rbp
  803499:	48 89 e5             	mov    %rsp,%rbp
  80349c:	48 83 ec 20          	sub    $0x20,%rsp
  8034a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034a9:	89 c7                	mov    %eax,%edi
  8034ab:	48 b8 10 32 80 00 00 	movabs $0x803210,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034be:	79 05                	jns    8034c5 <listen+0x2d>
		return r;
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	eb 16                	jmp    8034db <listen+0x43>
	return nsipc_listen(r, backlog);
  8034c5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	89 d6                	mov    %edx,%esi
  8034cd:	89 c7                	mov    %eax,%edi
  8034cf:	48 b8 05 38 80 00 00 	movabs $0x803805,%rax
  8034d6:	00 00 00 
  8034d9:	ff d0                	callq  *%rax
}
  8034db:	c9                   	leaveq 
  8034dc:	c3                   	retq   

00000000008034dd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034dd:	55                   	push   %rbp
  8034de:	48 89 e5             	mov    %rsp,%rbp
  8034e1:	48 83 ec 20          	sub    $0x20,%rsp
  8034e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f5:	89 c2                	mov    %eax,%edx
  8034f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fb:	8b 40 0c             	mov    0xc(%rax),%eax
  8034fe:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803502:	b9 00 00 00 00       	mov    $0x0,%ecx
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 45 38 80 00 00 	movabs $0x803845,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
}
  803515:	c9                   	leaveq 
  803516:	c3                   	retq   

0000000000803517 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803517:	55                   	push   %rbp
  803518:	48 89 e5             	mov    %rsp,%rbp
  80351b:	48 83 ec 20          	sub    $0x20,%rsp
  80351f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803523:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803527:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80352b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352f:	89 c2                	mov    %eax,%edx
  803531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803535:	8b 40 0c             	mov    0xc(%rax),%eax
  803538:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80353c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803541:	89 c7                	mov    %eax,%edi
  803543:	48 b8 11 39 80 00 00 	movabs $0x803911,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
}
  80354f:	c9                   	leaveq 
  803550:	c3                   	retq   

0000000000803551 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803551:	55                   	push   %rbp
  803552:	48 89 e5             	mov    %rsp,%rbp
  803555:	48 83 ec 10          	sub    $0x10,%rsp
  803559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80355d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803565:	48 be 33 4c 80 00 00 	movabs $0x804c33,%rsi
  80356c:	00 00 00 
  80356f:	48 89 c7             	mov    %rax,%rdi
  803572:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
	return 0;
  80357e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <socket>:

int
socket(int domain, int type, int protocol)
{
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
  803589:	48 83 ec 20          	sub    $0x20,%rsp
  80358d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803590:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803593:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803596:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803599:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80359c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80359f:	89 ce                	mov    %ecx,%esi
  8035a1:	89 c7                	mov    %eax,%edi
  8035a3:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
  8035af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b6:	79 05                	jns    8035bd <socket+0x38>
		return r;
  8035b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bb:	eb 11                	jmp    8035ce <socket+0x49>
	return alloc_sockfd(r);
  8035bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c0:	89 c7                	mov    %eax,%edi
  8035c2:	48 b8 67 32 80 00 00 	movabs $0x803267,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
}
  8035ce:	c9                   	leaveq 
  8035cf:	c3                   	retq   

00000000008035d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035d0:	55                   	push   %rbp
  8035d1:	48 89 e5             	mov    %rsp,%rbp
  8035d4:	48 83 ec 10          	sub    $0x10,%rsp
  8035d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035db:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035e2:	00 00 00 
  8035e5:	8b 00                	mov    (%rax),%eax
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	75 1d                	jne    803608 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035eb:	bf 02 00 00 00       	mov    $0x2,%edi
  8035f0:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803603:	00 00 00 
  803606:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803608:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80360f:	00 00 00 
  803612:	8b 00                	mov    (%rax),%eax
  803614:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803617:	b9 07 00 00 00       	mov    $0x7,%ecx
  80361c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803623:	00 00 00 
  803626:	89 c7                	mov    %eax,%edi
  803628:	48 b8 ab 24 80 00 00 	movabs $0x8024ab,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803634:	ba 00 00 00 00       	mov    $0x0,%edx
  803639:	be 00 00 00 00       	mov    $0x0,%esi
  80363e:	bf 00 00 00 00       	mov    $0x0,%edi
  803643:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
}
  80364f:	c9                   	leaveq 
  803650:	c3                   	retq   

0000000000803651 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803651:	55                   	push   %rbp
  803652:	48 89 e5             	mov    %rsp,%rbp
  803655:	48 83 ec 30          	sub    $0x30,%rsp
  803659:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80365c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803660:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803664:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366b:	00 00 00 
  80366e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803671:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803673:	bf 01 00 00 00       	mov    $0x1,%edi
  803678:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803687:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368b:	78 3e                	js     8036cb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80368d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803694:	00 00 00 
  803697:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80369b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369f:	8b 40 10             	mov    0x10(%rax),%eax
  8036a2:	89 c2                	mov    %eax,%edx
  8036a4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ac:	48 89 ce             	mov    %rcx,%rsi
  8036af:	48 89 c7             	mov    %rax,%rdi
  8036b2:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  8036b9:	00 00 00 
  8036bc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c2:	8b 50 10             	mov    0x10(%rax),%edx
  8036c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036ce:	c9                   	leaveq 
  8036cf:	c3                   	retq   

00000000008036d0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036d0:	55                   	push   %rbp
  8036d1:	48 89 e5             	mov    %rsp,%rbp
  8036d4:	48 83 ec 10          	sub    $0x10,%rsp
  8036d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036df:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e9:	00 00 00 
  8036ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036ef:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036f1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f8:	48 89 c6             	mov    %rax,%rsi
  8036fb:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803702:	00 00 00 
  803705:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803711:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803718:	00 00 00 
  80371b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80371e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803721:	bf 02 00 00 00       	mov    $0x2,%edi
  803726:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  80372d:	00 00 00 
  803730:	ff d0                	callq  *%rax
}
  803732:	c9                   	leaveq 
  803733:	c3                   	retq   

0000000000803734 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803734:	55                   	push   %rbp
  803735:	48 89 e5             	mov    %rsp,%rbp
  803738:	48 83 ec 10          	sub    $0x10,%rsp
  80373c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80373f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803742:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803749:	00 00 00 
  80374c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80374f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803751:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803758:	00 00 00 
  80375b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80375e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803761:	bf 03 00 00 00       	mov    $0x3,%edi
  803766:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <nsipc_close>:

int
nsipc_close(int s)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 10          	sub    $0x10,%rsp
  80377c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80377f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803786:	00 00 00 
  803789:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80378c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80378e:	bf 04 00 00 00       	mov    $0x4,%edi
  803793:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
}
  80379f:	c9                   	leaveq 
  8037a0:	c3                   	retq   

00000000008037a1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037a1:	55                   	push   %rbp
  8037a2:	48 89 e5             	mov    %rsp,%rbp
  8037a5:	48 83 ec 10          	sub    $0x10,%rsp
  8037a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ba:	00 00 00 
  8037bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037c0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037c2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c9:	48 89 c6             	mov    %rax,%rsi
  8037cc:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037d3:	00 00 00 
  8037d6:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e9:	00 00 00 
  8037ec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037ef:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8037f7:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
}
  803803:	c9                   	leaveq 
  803804:	c3                   	retq   

0000000000803805 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803805:	55                   	push   %rbp
  803806:	48 89 e5             	mov    %rsp,%rbp
  803809:	48 83 ec 10          	sub    $0x10,%rsp
  80380d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803810:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803813:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381a:	00 00 00 
  80381d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803820:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803822:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803829:	00 00 00 
  80382c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80382f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803832:	bf 06 00 00 00       	mov    $0x6,%edi
  803837:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 30          	sub    $0x30,%rsp
  80384d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803850:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803854:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803857:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80385a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803861:	00 00 00 
  803864:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803867:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803869:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803870:	00 00 00 
  803873:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803876:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803879:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803880:	00 00 00 
  803883:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803886:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803889:	bf 07 00 00 00       	mov    $0x7,%edi
  80388e:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  803895:	00 00 00 
  803898:	ff d0                	callq  *%rax
  80389a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a1:	78 69                	js     80390c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038a3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038aa:	7f 08                	jg     8038b4 <nsipc_recv+0x6f>
  8038ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038af:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038b2:	7e 35                	jle    8038e9 <nsipc_recv+0xa4>
  8038b4:	48 b9 3a 4c 80 00 00 	movabs $0x804c3a,%rcx
  8038bb:	00 00 00 
  8038be:	48 ba 4f 4c 80 00 00 	movabs $0x804c4f,%rdx
  8038c5:	00 00 00 
  8038c8:	be 61 00 00 00       	mov    $0x61,%esi
  8038cd:	48 bf 64 4c 80 00 00 	movabs $0x804c64,%rdi
  8038d4:	00 00 00 
  8038d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038dc:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  8038e3:	00 00 00 
  8038e6:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ec:	48 63 d0             	movslq %eax,%rdx
  8038ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038fa:	00 00 00 
  8038fd:	48 89 c7             	mov    %rax,%rdi
  803900:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
	}

	return r;
  80390c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80390f:	c9                   	leaveq 
  803910:	c3                   	retq   

0000000000803911 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803911:	55                   	push   %rbp
  803912:	48 89 e5             	mov    %rsp,%rbp
  803915:	48 83 ec 20          	sub    $0x20,%rsp
  803919:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80391c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803920:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803923:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803926:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80392d:	00 00 00 
  803930:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803933:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803935:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80393c:	7e 35                	jle    803973 <nsipc_send+0x62>
  80393e:	48 b9 70 4c 80 00 00 	movabs $0x804c70,%rcx
  803945:	00 00 00 
  803948:	48 ba 4f 4c 80 00 00 	movabs $0x804c4f,%rdx
  80394f:	00 00 00 
  803952:	be 6c 00 00 00       	mov    $0x6c,%esi
  803957:	48 bf 64 4c 80 00 00 	movabs $0x804c64,%rdi
  80395e:	00 00 00 
  803961:	b8 00 00 00 00       	mov    $0x0,%eax
  803966:	49 b8 30 09 80 00 00 	movabs $0x800930,%r8
  80396d:	00 00 00 
  803970:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803973:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803976:	48 63 d0             	movslq %eax,%rdx
  803979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397d:	48 89 c6             	mov    %rax,%rsi
  803980:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803987:	00 00 00 
  80398a:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803996:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80399d:	00 00 00 
  8039a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039a3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ad:	00 00 00 
  8039b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039b3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8039bb:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	callq  *%rax
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 10          	sub    $0x10,%rsp
  8039d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039d7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e1:	00 00 00 
  8039e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039e7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039f0:	00 00 00 
  8039f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039f6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a00:	00 00 00 
  803a03:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a06:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a09:	bf 09 00 00 00       	mov    $0x9,%edi
  803a0e:	48 b8 d0 35 80 00 00 	movabs $0x8035d0,%rax
  803a15:	00 00 00 
  803a18:	ff d0                	callq  *%rax
}
  803a1a:	c9                   	leaveq 
  803a1b:	c3                   	retq   

0000000000803a1c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a1c:	55                   	push   %rbp
  803a1d:	48 89 e5             	mov    %rsp,%rbp
  803a20:	53                   	push   %rbx
  803a21:	48 83 ec 38          	sub    $0x38,%rsp
  803a25:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a29:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a2d:	48 89 c7             	mov    %rax,%rdi
  803a30:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
  803a3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a43:	0f 88 bf 01 00 00    	js     803c08 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a52:	48 89 c6             	mov    %rax,%rsi
  803a55:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5a:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
  803a66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a6d:	0f 88 95 01 00 00    	js     803c08 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a77:	48 89 c7             	mov    %rax,%rdi
  803a7a:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
  803a86:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a8d:	0f 88 5d 01 00 00    	js     803bf0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a97:	ba 07 04 00 00       	mov    $0x407,%edx
  803a9c:	48 89 c6             	mov    %rax,%rsi
  803a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa4:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  803aab:	00 00 00 
  803aae:	ff d0                	callq  *%rax
  803ab0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ab7:	0f 88 33 01 00 00    	js     803bf0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803abd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac1:	48 89 c7             	mov    %rax,%rdi
  803ac4:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
  803ad0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ad4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad8:	ba 07 04 00 00       	mov    $0x407,%edx
  803add:	48 89 c6             	mov    %rax,%rsi
  803ae0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae5:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  803aec:	00 00 00 
  803aef:	ff d0                	callq  *%rax
  803af1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803af4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803af8:	0f 88 d9 00 00 00    	js     803bd7 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803afe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b02:	48 89 c7             	mov    %rax,%rdi
  803b05:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803b0c:	00 00 00 
  803b0f:	ff d0                	callq  *%rax
  803b11:	48 89 c2             	mov    %rax,%rdx
  803b14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b18:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b1e:	48 89 d1             	mov    %rdx,%rcx
  803b21:	ba 00 00 00 00       	mov    $0x0,%edx
  803b26:	48 89 c6             	mov    %rax,%rsi
  803b29:	bf 00 00 00 00       	mov    $0x0,%edi
  803b2e:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
  803b3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b41:	78 79                	js     803bbc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b47:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4e:	00 00 00 
  803b51:	8b 12                	mov    (%rdx),%edx
  803b53:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b64:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b6b:	00 00 00 
  803b6e:	8b 12                	mov    (%rdx),%edx
  803b70:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b76:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b81:	48 89 c7             	mov    %rax,%rdi
  803b84:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  803b8b:	00 00 00 
  803b8e:	ff d0                	callq  *%rax
  803b90:	89 c2                	mov    %eax,%edx
  803b92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b96:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b9c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ba0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba4:	48 89 c7             	mov    %rax,%rdi
  803ba7:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
  803bb3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bba:	eb 4f                	jmp    803c0b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803bbc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803bbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc1:	48 89 c6             	mov    %rax,%rsi
  803bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc9:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	callq  *%rax
  803bd5:	eb 01                	jmp    803bd8 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803bd7:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803bd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bdc:	48 89 c6             	mov    %rax,%rsi
  803bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  803be4:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  803beb:	00 00 00 
  803bee:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bf4:	48 89 c6             	mov    %rax,%rsi
  803bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfc:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
err:
	return r;
  803c08:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c0b:	48 83 c4 38          	add    $0x38,%rsp
  803c0f:	5b                   	pop    %rbx
  803c10:	5d                   	pop    %rbp
  803c11:	c3                   	retq   

0000000000803c12 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c12:	55                   	push   %rbp
  803c13:	48 89 e5             	mov    %rsp,%rbp
  803c16:	53                   	push   %rbx
  803c17:	48 83 ec 28          	sub    $0x28,%rsp
  803c1b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c1f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c23:	eb 01                	jmp    803c26 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c25:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c2d:	00 00 00 
  803c30:	48 8b 00             	mov    (%rax),%rax
  803c33:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c39:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c40:	48 89 c7             	mov    %rax,%rdi
  803c43:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
  803c4f:	89 c3                	mov    %eax,%ebx
  803c51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c55:	48 89 c7             	mov    %rax,%rdi
  803c58:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
  803c64:	39 c3                	cmp    %eax,%ebx
  803c66:	0f 94 c0             	sete   %al
  803c69:	0f b6 c0             	movzbl %al,%eax
  803c6c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c6f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c76:	00 00 00 
  803c79:	48 8b 00             	mov    (%rax),%rax
  803c7c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c82:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c88:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c8b:	75 0a                	jne    803c97 <_pipeisclosed+0x85>
			return ret;
  803c8d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803c90:	48 83 c4 28          	add    $0x28,%rsp
  803c94:	5b                   	pop    %rbx
  803c95:	5d                   	pop    %rbp
  803c96:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803c97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c9a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c9d:	74 86                	je     803c25 <_pipeisclosed+0x13>
  803c9f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ca3:	75 80                	jne    803c25 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ca5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cac:	00 00 00 
  803caf:	48 8b 00             	mov    (%rax),%rax
  803cb2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803cb8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cbe:	89 c6                	mov    %eax,%esi
  803cc0:	48 bf 81 4c 80 00 00 	movabs $0x804c81,%rdi
  803cc7:	00 00 00 
  803cca:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccf:	49 b8 6b 0b 80 00 00 	movabs $0x800b6b,%r8
  803cd6:	00 00 00 
  803cd9:	41 ff d0             	callq  *%r8
	}
  803cdc:	e9 44 ff ff ff       	jmpq   803c25 <_pipeisclosed+0x13>

0000000000803ce1 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 30          	sub    $0x30,%rsp
  803ce9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cf0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cf3:	48 89 d6             	mov    %rdx,%rsi
  803cf6:	89 c7                	mov    %eax,%edi
  803cf8:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
  803d04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0b:	79 05                	jns    803d12 <pipeisclosed+0x31>
		return r;
  803d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d10:	eb 31                	jmp    803d43 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d31:	48 89 d6             	mov    %rdx,%rsi
  803d34:	48 89 c7             	mov    %rax,%rdi
  803d37:	48 b8 12 3c 80 00 00 	movabs $0x803c12,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
}
  803d43:	c9                   	leaveq 
  803d44:	c3                   	retq   

0000000000803d45 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d45:	55                   	push   %rbp
  803d46:	48 89 e5             	mov    %rsp,%rbp
  803d49:	48 83 ec 40          	sub    $0x40,%rsp
  803d4d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d55:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5d:	48 89 c7             	mov    %rax,%rdi
  803d60:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803d67:	00 00 00 
  803d6a:	ff d0                	callq  *%rax
  803d6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d78:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d7f:	00 
  803d80:	e9 97 00 00 00       	jmpq   803e1c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d85:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d8a:	74 09                	je     803d95 <devpipe_read+0x50>
				return i;
  803d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d90:	e9 95 00 00 00       	jmpq   803e2a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d9d:	48 89 d6             	mov    %rdx,%rsi
  803da0:	48 89 c7             	mov    %rax,%rdi
  803da3:	48 b8 12 3c 80 00 00 	movabs $0x803c12,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
  803daf:	85 c0                	test   %eax,%eax
  803db1:	74 07                	je     803dba <devpipe_read+0x75>
				return 0;
  803db3:	b8 00 00 00 00       	mov    $0x0,%eax
  803db8:	eb 70                	jmp    803e2a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803dba:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  803dc1:	00 00 00 
  803dc4:	ff d0                	callq  *%rax
  803dc6:	eb 01                	jmp    803dc9 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dc8:	90                   	nop
  803dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcd:	8b 10                	mov    (%rax),%edx
  803dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd3:	8b 40 04             	mov    0x4(%rax),%eax
  803dd6:	39 c2                	cmp    %eax,%edx
  803dd8:	74 ab                	je     803d85 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dde:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803de2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803de6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dea:	8b 00                	mov    (%rax),%eax
  803dec:	89 c2                	mov    %eax,%edx
  803dee:	c1 fa 1f             	sar    $0x1f,%edx
  803df1:	c1 ea 1b             	shr    $0x1b,%edx
  803df4:	01 d0                	add    %edx,%eax
  803df6:	83 e0 1f             	and    $0x1f,%eax
  803df9:	29 d0                	sub    %edx,%eax
  803dfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dff:	48 98                	cltq   
  803e01:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e06:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0c:	8b 00                	mov    (%rax),%eax
  803e0e:	8d 50 01             	lea    0x1(%rax),%edx
  803e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e15:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e20:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e24:	72 a2                	jb     803dc8 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e2a:	c9                   	leaveq 
  803e2b:	c3                   	retq   

0000000000803e2c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e2c:	55                   	push   %rbp
  803e2d:	48 89 e5             	mov    %rsp,%rbp
  803e30:	48 83 ec 40          	sub    $0x40,%rsp
  803e34:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e3c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e44:	48 89 c7             	mov    %rax,%rdi
  803e47:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803e4e:	00 00 00 
  803e51:	ff d0                	callq  *%rax
  803e53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e5f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e66:	00 
  803e67:	e9 93 00 00 00       	jmpq   803eff <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e74:	48 89 d6             	mov    %rdx,%rsi
  803e77:	48 89 c7             	mov    %rax,%rdi
  803e7a:	48 b8 12 3c 80 00 00 	movabs $0x803c12,%rax
  803e81:	00 00 00 
  803e84:	ff d0                	callq  *%rax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 07                	je     803e91 <devpipe_write+0x65>
				return 0;
  803e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e8f:	eb 7c                	jmp    803f0d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e91:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  803e98:	00 00 00 
  803e9b:	ff d0                	callq  *%rax
  803e9d:	eb 01                	jmp    803ea0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e9f:	90                   	nop
  803ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea4:	8b 40 04             	mov    0x4(%rax),%eax
  803ea7:	48 63 d0             	movslq %eax,%rdx
  803eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eae:	8b 00                	mov    (%rax),%eax
  803eb0:	48 98                	cltq   
  803eb2:	48 83 c0 20          	add    $0x20,%rax
  803eb6:	48 39 c2             	cmp    %rax,%rdx
  803eb9:	73 b1                	jae    803e6c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebf:	8b 40 04             	mov    0x4(%rax),%eax
  803ec2:	89 c2                	mov    %eax,%edx
  803ec4:	c1 fa 1f             	sar    $0x1f,%edx
  803ec7:	c1 ea 1b             	shr    $0x1b,%edx
  803eca:	01 d0                	add    %edx,%eax
  803ecc:	83 e0 1f             	and    $0x1f,%eax
  803ecf:	29 d0                	sub    %edx,%eax
  803ed1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ed5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ed9:	48 01 ca             	add    %rcx,%rdx
  803edc:	0f b6 0a             	movzbl (%rdx),%ecx
  803edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ee3:	48 98                	cltq   
  803ee5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eed:	8b 40 04             	mov    0x4(%rax),%eax
  803ef0:	8d 50 01             	lea    0x1(%rax),%edx
  803ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803efa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803eff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f03:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f07:	72 96                	jb     803e9f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f0d:	c9                   	leaveq 
  803f0e:	c3                   	retq   

0000000000803f0f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f0f:	55                   	push   %rbp
  803f10:	48 89 e5             	mov    %rsp,%rbp
  803f13:	48 83 ec 20          	sub    $0x20,%rsp
  803f17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f23:	48 89 c7             	mov    %rax,%rdi
  803f26:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803f2d:	00 00 00 
  803f30:	ff d0                	callq  *%rax
  803f32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f3a:	48 be 94 4c 80 00 00 	movabs $0x804c94,%rsi
  803f41:	00 00 00 
  803f44:	48 89 c7             	mov    %rax,%rdi
  803f47:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  803f4e:	00 00 00 
  803f51:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f57:	8b 50 04             	mov    0x4(%rax),%edx
  803f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5e:	8b 00                	mov    (%rax),%eax
  803f60:	29 c2                	sub    %eax,%edx
  803f62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f66:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f77:	00 00 00 
	stat->st_dev = &devpipe;
  803f7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f7e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803f85:	00 00 00 
  803f88:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f94:	c9                   	leaveq 
  803f95:	c3                   	retq   

0000000000803f96 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f96:	55                   	push   %rbp
  803f97:	48 89 e5             	mov    %rsp,%rbp
  803f9a:	48 83 ec 10          	sub    $0x10,%rsp
  803f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa6:	48 89 c6             	mov    %rax,%rsi
  803fa9:	bf 00 00 00 00       	mov    $0x0,%edi
  803fae:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  803fb5:	00 00 00 
  803fb8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fbe:	48 89 c7             	mov    %rax,%rdi
  803fc1:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
  803fcd:	48 89 c6             	mov    %rax,%rsi
  803fd0:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd5:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  803fdc:	00 00 00 
  803fdf:	ff d0                	callq  *%rax
}
  803fe1:	c9                   	leaveq 
  803fe2:	c3                   	retq   
	...

0000000000803fe4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fe4:	55                   	push   %rbp
  803fe5:	48 89 e5             	mov    %rsp,%rbp
  803fe8:	48 83 ec 20          	sub    $0x20,%rsp
  803fec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ff5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ff9:	be 01 00 00 00       	mov    $0x1,%esi
  803ffe:	48 89 c7             	mov    %rax,%rdi
  804001:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  804008:	00 00 00 
  80400b:	ff d0                	callq  *%rax
}
  80400d:	c9                   	leaveq 
  80400e:	c3                   	retq   

000000000080400f <getchar>:

int
getchar(void)
{
  80400f:	55                   	push   %rbp
  804010:	48 89 e5             	mov    %rsp,%rbp
  804013:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804017:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80401b:	ba 01 00 00 00       	mov    $0x1,%edx
  804020:	48 89 c6             	mov    %rax,%rsi
  804023:	bf 00 00 00 00       	mov    $0x0,%edi
  804028:	48 b8 00 2b 80 00 00 	movabs $0x802b00,%rax
  80402f:	00 00 00 
  804032:	ff d0                	callq  *%rax
  804034:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403b:	79 05                	jns    804042 <getchar+0x33>
		return r;
  80403d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804040:	eb 14                	jmp    804056 <getchar+0x47>
	if (r < 1)
  804042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804046:	7f 07                	jg     80404f <getchar+0x40>
		return -E_EOF;
  804048:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80404d:	eb 07                	jmp    804056 <getchar+0x47>
	return c;
  80404f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804053:	0f b6 c0             	movzbl %al,%eax
}
  804056:	c9                   	leaveq 
  804057:	c3                   	retq   

0000000000804058 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804058:	55                   	push   %rbp
  804059:	48 89 e5             	mov    %rsp,%rbp
  80405c:	48 83 ec 20          	sub    $0x20,%rsp
  804060:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804063:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804067:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80406a:	48 89 d6             	mov    %rdx,%rsi
  80406d:	89 c7                	mov    %eax,%edi
  80406f:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
  80407b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80407e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804082:	79 05                	jns    804089 <iscons+0x31>
		return r;
  804084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804087:	eb 1a                	jmp    8040a3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408d:	8b 10                	mov    (%rax),%edx
  80408f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804096:	00 00 00 
  804099:	8b 00                	mov    (%rax),%eax
  80409b:	39 c2                	cmp    %eax,%edx
  80409d:	0f 94 c0             	sete   %al
  8040a0:	0f b6 c0             	movzbl %al,%eax
}
  8040a3:	c9                   	leaveq 
  8040a4:	c3                   	retq   

00000000008040a5 <opencons>:

int
opencons(void)
{
  8040a5:	55                   	push   %rbp
  8040a6:	48 89 e5             	mov    %rsp,%rbp
  8040a9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040ad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040b1:	48 89 c7             	mov    %rax,%rdi
  8040b4:	48 b8 36 26 80 00 00 	movabs $0x802636,%rax
  8040bb:	00 00 00 
  8040be:	ff d0                	callq  *%rax
  8040c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c7:	79 05                	jns    8040ce <opencons+0x29>
		return r;
  8040c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040cc:	eb 5b                	jmp    804129 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8040d7:	48 89 c6             	mov    %rax,%rsi
  8040da:	bf 00 00 00 00       	mov    $0x0,%edi
  8040df:	48 b8 74 20 80 00 00 	movabs $0x802074,%rax
  8040e6:	00 00 00 
  8040e9:	ff d0                	callq  *%rax
  8040eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f2:	79 05                	jns    8040f9 <opencons+0x54>
		return r;
  8040f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f7:	eb 30                	jmp    804129 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fd:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804104:	00 00 00 
  804107:	8b 12                	mov    (%rdx),%edx
  804109:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80410b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411a:	48 89 c7             	mov    %rax,%rdi
  80411d:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  804124:	00 00 00 
  804127:	ff d0                	callq  *%rax
}
  804129:	c9                   	leaveq 
  80412a:	c3                   	retq   

000000000080412b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80412b:	55                   	push   %rbp
  80412c:	48 89 e5             	mov    %rsp,%rbp
  80412f:	48 83 ec 30          	sub    $0x30,%rsp
  804133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80413b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80413f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804144:	75 13                	jne    804159 <devcons_read+0x2e>
		return 0;
  804146:	b8 00 00 00 00       	mov    $0x0,%eax
  80414b:	eb 49                	jmp    804196 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80414d:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  804154:	00 00 00 
  804157:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804159:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  804160:	00 00 00 
  804163:	ff d0                	callq  *%rax
  804165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416c:	74 df                	je     80414d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80416e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804172:	79 05                	jns    804179 <devcons_read+0x4e>
		return c;
  804174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804177:	eb 1d                	jmp    804196 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804179:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80417d:	75 07                	jne    804186 <devcons_read+0x5b>
		return 0;
  80417f:	b8 00 00 00 00       	mov    $0x0,%eax
  804184:	eb 10                	jmp    804196 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804189:	89 c2                	mov    %eax,%edx
  80418b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80418f:	88 10                	mov    %dl,(%rax)
	return 1;
  804191:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804196:	c9                   	leaveq 
  804197:	c3                   	retq   

0000000000804198 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804198:	55                   	push   %rbp
  804199:	48 89 e5             	mov    %rsp,%rbp
  80419c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041a3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041aa:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041b1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041bf:	eb 77                	jmp    804238 <devcons_write+0xa0>
		m = n - tot;
  8041c1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041c8:	89 c2                	mov    %eax,%edx
  8041ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cd:	89 d1                	mov    %edx,%ecx
  8041cf:	29 c1                	sub    %eax,%ecx
  8041d1:	89 c8                	mov    %ecx,%eax
  8041d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041d9:	83 f8 7f             	cmp    $0x7f,%eax
  8041dc:	76 07                	jbe    8041e5 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8041de:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041e8:	48 63 d0             	movslq %eax,%rdx
  8041eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ee:	48 98                	cltq   
  8041f0:	48 89 c1             	mov    %rax,%rcx
  8041f3:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8041fa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804201:	48 89 ce             	mov    %rcx,%rsi
  804204:	48 89 c7             	mov    %rax,%rdi
  804207:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  80420e:	00 00 00 
  804211:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804216:	48 63 d0             	movslq %eax,%rdx
  804219:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804220:	48 89 d6             	mov    %rdx,%rsi
  804223:	48 89 c7             	mov    %rax,%rdi
  804226:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  80422d:	00 00 00 
  804230:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804232:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804235:	01 45 fc             	add    %eax,-0x4(%rbp)
  804238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423b:	48 98                	cltq   
  80423d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804244:	0f 82 77 ff ff ff    	jb     8041c1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80424a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80424d:	c9                   	leaveq 
  80424e:	c3                   	retq   

000000000080424f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80424f:	55                   	push   %rbp
  804250:	48 89 e5             	mov    %rsp,%rbp
  804253:	48 83 ec 08          	sub    $0x8,%rsp
  804257:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80425b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804260:	c9                   	leaveq 
  804261:	c3                   	retq   

0000000000804262 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804262:	55                   	push   %rbp
  804263:	48 89 e5             	mov    %rsp,%rbp
  804266:	48 83 ec 10          	sub    $0x10,%rsp
  80426a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80426e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804276:	48 be a0 4c 80 00 00 	movabs $0x804ca0,%rsi
  80427d:	00 00 00 
  804280:	48 89 c7             	mov    %rax,%rdi
  804283:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  80428a:	00 00 00 
  80428d:	ff d0                	callq  *%rax
	return 0;
  80428f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804294:	c9                   	leaveq 
  804295:	c3                   	retq   
	...

0000000000804298 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804298:	55                   	push   %rbp
  804299:	48 89 e5             	mov    %rsp,%rbp
  80429c:	48 83 ec 18          	sub    $0x18,%rsp
  8042a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a8:	48 89 c2             	mov    %rax,%rdx
  8042ab:	48 c1 ea 15          	shr    $0x15,%rdx
  8042af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042b6:	01 00 00 
  8042b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042bd:	83 e0 01             	and    $0x1,%eax
  8042c0:	48 85 c0             	test   %rax,%rax
  8042c3:	75 07                	jne    8042cc <pageref+0x34>
		return 0;
  8042c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ca:	eb 53                	jmp    80431f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8042cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d0:	48 89 c2             	mov    %rax,%rdx
  8042d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8042d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042de:	01 00 00 
  8042e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ed:	83 e0 01             	and    $0x1,%eax
  8042f0:	48 85 c0             	test   %rax,%rax
  8042f3:	75 07                	jne    8042fc <pageref+0x64>
		return 0;
  8042f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8042fa:	eb 23                	jmp    80431f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804300:	48 89 c2             	mov    %rax,%rdx
  804303:	48 c1 ea 0c          	shr    $0xc,%rdx
  804307:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80430e:	00 00 00 
  804311:	48 c1 e2 04          	shl    $0x4,%rdx
  804315:	48 01 d0             	add    %rdx,%rax
  804318:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80431c:	0f b7 c0             	movzwl %ax,%eax
}
  80431f:	c9                   	leaveq 
  804320:	c3                   	retq   
