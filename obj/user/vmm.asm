
obj/user/vmm.debug:     file format elf64-x86-64


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
  80003c:	e8 97 05 00 00       	callq  8005d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <map_in_guest>:
//
// Return 0 on success, <0 on failure.
//
static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz, 
	      int fd, size_t filesz, off_t fileoffset ) {
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 50          	sub    $0x50,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800053:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800057:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80005a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80005e:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	/* Your code here */
	if (PGOFF(gpa)) {
  800062:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800066:	25 ff 0f 00 00       	and    $0xfff,%eax
  80006b:	48 85 c0             	test   %rax,%rax
  80006e:	74 08                	je     800078 <map_in_guest+0x34>
		ROUNDDOWN(gpa, PGSIZE);
  800070:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800074:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	}
	int i, r = 0;
  800078:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    for (i = 0; i < filesz; i += PGSIZE) {
  80007f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800086:	e9 3e 01 00 00       	jmpq   8001c9 <map_in_guest+0x185>
	    r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W);
  80008b:	ba 07 00 00 00       	mov    $0x7,%edx
  800090:	be 00 00 40 00       	mov    $0x400000,%esi
  800095:	bf 00 00 00 00       	mov    $0x0,%edi
  80009a:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8000a1:	00 00 00 
  8000a4:	ff d0                	callq  *%rax
  8000a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0)
  8000a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ad:	79 08                	jns    8000b7 <map_in_guest+0x73>
			return r;
  8000af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b2:	e9 f7 01 00 00       	jmpq   8002ae <map_in_guest+0x26a>
	    r = seek(fd, fileoffset + i);
  8000b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ba:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8000bd:	01 c2                	add    %eax,%edx
  8000bf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000c2:	89 d6                	mov    %edx,%esi
  8000c4:	89 c7                	mov    %eax,%edi
  8000c6:	48 b8 76 28 80 00 00 	movabs $0x802876,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
  8000d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0)
  8000d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d9:	79 08                	jns    8000e3 <map_in_guest+0x9f>
			return r;
  8000db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000de:	e9 cb 01 00 00       	jmpq   8002ae <map_in_guest+0x26a>
	    r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i));
  8000e3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%rbp)
  8000ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ed:	48 98                	cltq   
  8000ef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8000f3:	48 89 d1             	mov    %rdx,%rcx
  8000f6:	48 29 c1             	sub    %rax,%rcx
  8000f9:	48 89 c8             	mov    %rcx,%rax
  8000fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800100:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800103:	48 63 d0             	movslq %eax,%rdx
  800106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80010a:	48 39 c2             	cmp    %rax,%rdx
  80010d:	48 0f 47 d0          	cmova  %rax,%rdx
  800111:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800114:	be 00 00 40 00       	mov    $0x400000,%esi
  800119:	89 c7                	mov    %eax,%edi
  80011b:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
  800127:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r<0) 
  80012a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80012e:	79 08                	jns    800138 <map_in_guest+0xf4>
			return r;
  800130:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800133:	e9 76 01 00 00       	jmpq   8002ae <map_in_guest+0x26a>
	    r = sys_ept_map(thisenv->env_id, (void*)UTEMP, guest, (void*) (gpa + i), __EPTE_FULL);
  800138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013b:	48 98                	cltq   
  80013d:	48 03 45 d0          	add    -0x30(%rbp),%rax
  800141:	48 89 c1             	mov    %rax,%rcx
  800144:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014b:	00 00 00 
  80014e:	48 8b 00             	mov    (%rax),%rax
  800151:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800157:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80015a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800160:	be 00 00 40 00       	mov    $0x400000,%esi
  800165:	89 c7                	mov    %eax,%edi
  800167:	48 b8 93 20 80 00 00 	movabs $0x802093,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0)
  800176:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80017a:	79 30                	jns    8001ac <map_in_guest+0x168>
			panic("Something wrong with map_in_guest after calling sys_ept_map: %e", r);
  80017c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017f:	89 c1                	mov    %eax,%ecx
  800181:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800188:	00 00 00 
  80018b:	be 25 00 00 00       	mov    $0x25,%esi
  800190:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  800197:	00 00 00 
  80019a:	b8 00 00 00 00       	mov    $0x0,%eax
  80019f:	49 b8 a4 06 80 00 00 	movabs $0x8006a4,%r8
  8001a6:	00 00 00 
  8001a9:	41 ff d0             	callq  *%r8
	    sys_page_unmap(0, UTEMP);	   
  8001ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b6:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  8001bd:	00 00 00 
  8001c0:	ff d0                	callq  *%rax
	/* Your code here */
	if (PGOFF(gpa)) {
		ROUNDDOWN(gpa, PGSIZE);
	}
	int i, r = 0;
    for (i = 0; i < filesz; i += PGSIZE) {
  8001c2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8001c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001cc:	48 98                	cltq   
  8001ce:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8001d2:	0f 82 b3 fe ff ff    	jb     80008b <map_in_guest+0x47>
	    r = sys_ept_map(thisenv->env_id, (void*)UTEMP, guest, (void*) (gpa + i), __EPTE_FULL);
		if (r < 0)
			panic("Something wrong with map_in_guest after calling sys_ept_map: %e", r);
	    sys_page_unmap(0, UTEMP);	   
	}
	for (; i < memsz; i+= PGSIZE) {
  8001d8:	e9 bd 00 00 00       	jmpq   80029a <map_in_guest+0x256>
		r = sys_page_alloc(0, (void*) UTEMP, __EPTE_FULL);
  8001dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8001e2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
  8001f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0)
  8001fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001ff:	79 08                	jns    800209 <map_in_guest+0x1c5>
			return r;
  800201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800204:	e9 a5 00 00 00       	jmpq   8002ae <map_in_guest+0x26a>
	    r = sys_ept_map(thisenv->env_id, UTEMP, guest, (void *)(gpa + i), __EPTE_FULL);
  800209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020c:	48 98                	cltq   
  80020e:	48 03 45 d0          	add    -0x30(%rbp),%rax
  800212:	48 89 c1             	mov    %rax,%rcx
  800215:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80021c:	00 00 00 
  80021f:	48 8b 00             	mov    (%rax),%rax
  800222:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800228:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80022b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800231:	be 00 00 40 00       	mov    $0x400000,%esi
  800236:	89 c7                	mov    %eax,%edi
  800238:	48 b8 93 20 80 00 00 	movabs $0x802093,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
  800244:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r < 0)
  800247:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80024b:	79 30                	jns    80027d <map_in_guest+0x239>
			panic("Something wrong with sys_ept_map: %e", r);
  80024d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800250:	89 c1                	mov    %eax,%ecx
  800252:	48 ba b0 41 80 00 00 	movabs $0x8041b0,%rdx
  800259:	00 00 00 
  80025c:	be 2e 00 00 00       	mov    $0x2e,%esi
  800261:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  800268:	00 00 00 
  80026b:	b8 00 00 00 00       	mov    $0x0,%eax
  800270:	49 b8 a4 06 80 00 00 	movabs $0x8006a4,%r8
  800277:	00 00 00 
  80027a:	41 ff d0             	callq  *%r8
	    sys_page_unmap(0, UTEMP);
  80027d:	be 00 00 40 00       	mov    $0x400000,%esi
  800282:	bf 00 00 00 00       	mov    $0x0,%edi
  800287:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
	    r = sys_ept_map(thisenv->env_id, (void*)UTEMP, guest, (void*) (gpa + i), __EPTE_FULL);
		if (r < 0)
			panic("Something wrong with map_in_guest after calling sys_ept_map: %e", r);
	    sys_page_unmap(0, UTEMP);	   
	}
	for (; i < memsz; i+= PGSIZE) {
  800293:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80029a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80029d:	48 98                	cltq   
  80029f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8002a3:	0f 82 34 ff ff ff    	jb     8001dd <map_in_guest+0x199>
	    r = sys_ept_map(thisenv->env_id, UTEMP, guest, (void *)(gpa + i), __EPTE_FULL);
		if (r < 0)
			panic("Something wrong with sys_ept_map: %e", r);
	    sys_page_unmap(0, UTEMP);
	}
	return 0;
  8002a9:	b8 00 00 00 00       	mov    $0x0,%eax
} 
  8002ae:	c9                   	leaveq 
  8002af:	c3                   	retq   

00000000008002b0 <copy_guest_kern_gpa>:
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
  8002b0:	55                   	push   %rbp
  8002b1:	48 89 e5             	mov    %rsp,%rbp
  8002b4:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  8002bb:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  8002c1:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	/* Your code here */
	int fd = open(fname, O_RDONLY);
  8002c8:	48 8b 85 d0 fd ff ff 	mov    -0x230(%rbp),%rax
  8002cf:	be 00 00 00 00       	mov    $0x0,%esi
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 45 f0             	mov    %eax,-0x10(%rbp)
	if(fd < 0)
  8002e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002ea:	79 0a                	jns    8002f6 <copy_guest_kern_gpa+0x46>
		return -E_NOT_FOUND;
  8002ec:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8002f1:	e9 4b 01 00 00       	jmpq   800441 <copy_guest_kern_gpa+0x191>
	char data[512]; //512 bytes block size
	if (readn(fd, data, sizeof(data)) != sizeof(data)) {
  8002f6:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  8002fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800300:	ba 00 02 00 00       	mov    $0x200,%edx
  800305:	48 89 ce             	mov    %rcx,%rsi
  800308:	89 c7                	mov    %eax,%edi
  80030a:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
  800316:	3d 00 02 00 00       	cmp    $0x200,%eax
  80031b:	74 1b                	je     800338 <copy_guest_kern_gpa+0x88>
		close(fd);
  80031d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800320:	89 c7                	mov    %eax,%edi
  800322:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  800329:	00 00 00 
  80032c:	ff d0                	callq  *%rax
		return -E_NOT_FOUND;
  80032e:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800333:	e9 09 01 00 00       	jmpq   800441 <copy_guest_kern_gpa+0x191>
	}
	struct Elf *elfhdr = (struct Elf*)data;
  800338:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  80033f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (elfhdr->e_magic != ELF_MAGIC) {
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	8b 00                	mov    (%rax),%eax
  800349:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80034e:	74 1b                	je     80036b <copy_guest_kern_gpa+0xbb>
		close(fd);
  800350:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800353:	89 c7                	mov    %eax,%edi
  800355:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  80035c:	00 00 00 
  80035f:	ff d0                	callq  *%rax
		return -E_NOT_EXEC;
  800361:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800366:	e9 d6 00 00 00       	jmpq   800441 <copy_guest_kern_gpa+0x191>
	}
	// Program Header part from env.c...
	struct Proghdr* ph = (struct Proghdr*) (data + elfhdr->e_phoff);
  80036b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80036f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800373:	48 8d 95 e0 fd ff ff 	lea    -0x220(%rbp),%rdx
  80037a:	48 01 d0             	add    %rdx,%rax
  80037d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Proghdr* eph = ph + elfhdr->e_phnum;
  800381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800385:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  800389:	0f b7 c0             	movzwl %ax,%eax
  80038c:	48 c1 e0 03          	shl    $0x3,%rax
  800390:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800397:	00 
  800398:	48 89 d1             	mov    %rdx,%rcx
  80039b:	48 29 c1             	sub    %rax,%rcx
  80039e:	48 89 c8             	mov    %rcx,%rax
  8003a1:	48 03 45 f8          	add    -0x8(%rbp),%rax
  8003a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int r = 0;
  8003a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	for (; ph < eph; ph++) {
  8003b0:	eb 71                	jmp    800423 <copy_guest_kern_gpa+0x173>
    	if (ph->p_type == ELF_PROG_LOAD) {
  8003b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003b6:	8b 00                	mov    (%rax),%eax
  8003b8:	83 f8 01             	cmp    $0x1,%eax
  8003bb:	75 61                	jne    80041e <copy_guest_kern_gpa+0x16e>
			// Call map_in_guest if needed.
			r = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset);
  8003bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8003c5:	41 89 c0             	mov    %eax,%r8d
  8003c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cc:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8003d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003d4:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8003d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003dc:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8003e0:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8003e3:	8b 85 dc fd ff ff    	mov    -0x224(%rbp),%eax
  8003e9:	45 89 c1             	mov    %r8d,%r9d
  8003ec:	49 89 f8             	mov    %rdi,%r8
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
  8003fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
			if (r < 0) {
  800400:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800404:	79 18                	jns    80041e <copy_guest_kern_gpa+0x16e>
				close(fd);
  800406:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800409:	89 c7                	mov    %eax,%edi
  80040b:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  800412:	00 00 00 
  800415:	ff d0                	callq  *%rax
				return -E_NO_SYS;
  800417:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  80041c:	eb 23                	jmp    800441 <copy_guest_kern_gpa+0x191>
	}
	// Program Header part from env.c...
	struct Proghdr* ph = (struct Proghdr*) (data + elfhdr->e_phoff);
	struct Proghdr* eph = ph + elfhdr->e_phnum;
	int r = 0;
	for (; ph < eph; ph++) {
  80041e:	48 83 45 f8 38       	addq   $0x38,-0x8(%rbp)
  800423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800427:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042b:	72 85                	jb     8003b2 <copy_guest_kern_gpa+0x102>
				close(fd);
				return -E_NO_SYS;
			}
		}
	}
	close(fd);
  80042d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800430:	89 c7                	mov    %eax,%edi
  800432:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  800439:	00 00 00 
  80043c:	ff d0                	callq  *%rax
	return r;
  80043e:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  800441:	c9                   	leaveq 
  800442:	c3                   	retq   

0000000000800443 <umain>:

void
umain(int argc, char **argv) {
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 20          	sub    $0x20,%rsp
  80044b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80044e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int ret;
	envid_t guest;

	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
  800452:	be 00 70 00 00       	mov    $0x7000,%esi
  800457:	bf 00 00 00 01       	mov    $0x1000000,%edi
  80045c:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  800463:	00 00 00 
  800466:	ff d0                	callq  *%rax
  800468:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80046b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80046f:	79 2c                	jns    80049d <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  800471:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800474:	89 c6                	mov    %eax,%esi
  800476:	48 bf d8 41 80 00 00 	movabs $0x8041d8,%rdi
  80047d:	00 00 00 
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	48 ba df 08 80 00 00 	movabs $0x8008df,%rdx
  80048c:	00 00 00 
  80048f:	ff d2                	callq  *%rdx
		exit();
  800491:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800498:	00 00 00 
  80049b:	ff d0                	callq  *%rax
	}
	guest = ret;
  80049d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a0:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8004a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a6:	48 be fb 41 80 00 00 	movabs $0x8041fb,%rsi
  8004ad:	00 00 00 
  8004b0:	89 c7                	mov    %eax,%edi
  8004b2:	48 b8 b0 02 80 00 00 	movabs $0x8002b0,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax
  8004be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004c5:	79 2c                	jns    8004f3 <umain+0xb0>
		cprintf("Error copying page into the guest - %d\n.", ret);
  8004c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ca:	89 c6                	mov    %eax,%esi
  8004cc:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  8004d3:	00 00 00 
  8004d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004db:	48 ba df 08 80 00 00 	movabs $0x8008df,%rdx
  8004e2:	00 00 00 
  8004e5:	ff d2                	callq  *%rdx
		exit();
  8004e7:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  8004ee:	00 00 00 
  8004f1:	ff d0                	callq  *%rax
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  8004f3:	be 00 00 00 00       	mov    $0x0,%esi
  8004f8:	48 bf 31 42 80 00 00 	movabs $0x804231,%rdi
  8004ff:	00 00 00 
  800502:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  800509:	00 00 00 
  80050c:	ff d0                	callq  *%rax
  80050e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800511:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800515:	79 36                	jns    80054d <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  800517:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80051a:	89 c2                	mov    %eax,%edx
  80051c:	48 be 31 42 80 00 00 	movabs $0x804231,%rsi
  800523:	00 00 00 
  800526:	48 bf 3b 42 80 00 00 	movabs $0x80423b,%rdi
  80052d:	00 00 00 
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	48 b9 df 08 80 00 00 	movabs $0x8008df,%rcx
  80053c:	00 00 00 
  80053f:	ff d1                	callq  *%rcx
		exit();
  800541:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800548:	00 00 00 
  80054b:	ff d0                	callq  *%rax
	}

	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
  80054d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800550:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800553:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800559:	41 b8 00 02 00 00    	mov    $0x200,%r8d
  80055f:	89 d1                	mov    %edx,%ecx
  800561:	ba 00 02 00 00       	mov    $0x200,%edx
  800566:	be 00 70 00 00       	mov    $0x7000,%esi
  80056b:	89 c7                	mov    %eax,%edi
  80056d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax
  800579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800580:	79 2c                	jns    8005ae <umain+0x16b>
		cprintf("Error mapping bootloader into the guest - %d\n.", ret);
  800582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800585:	89 c6                	mov    %eax,%esi
  800587:	48 bf 58 42 80 00 00 	movabs $0x804258,%rdi
  80058e:	00 00 00 
  800591:	b8 00 00 00 00       	mov    $0x0,%eax
  800596:	48 ba df 08 80 00 00 	movabs $0x8008df,%rdx
  80059d:	00 00 00 
  8005a0:	ff d2                	callq  *%rdx
		exit();
  8005a2:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
	}

	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  8005ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005b1:	be 02 00 00 00       	mov    $0x2,%esi
  8005b6:	89 c7                	mov    %eax,%edi
  8005b8:	48 b8 dd 1e 80 00 00 	movabs $0x801edd,%rax
  8005bf:	00 00 00 
  8005c2:	ff d0                	callq  *%rax
	wait(guest);
  8005c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005c7:	89 c7                	mov    %eax,%edi
  8005c9:	48 b8 34 3b 80 00 00 	movabs $0x803b34,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
}
  8005d5:	c9                   	leaveq 
  8005d6:	c3                   	retq   
	...

00000000008005d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005d8:	55                   	push   %rbp
  8005d9:	48 89 e5             	mov    %rsp,%rbp
  8005dc:	48 83 ec 10          	sub    $0x10,%rsp
  8005e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8005e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005ee:	00 00 00 
  8005f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8005f8:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8005ff:	00 00 00 
  800602:	ff d0                	callq  *%rax
  800604:	48 98                	cltq   
  800606:	48 89 c2             	mov    %rax,%rdx
  800609:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80060f:	48 89 d0             	mov    %rdx,%rax
  800612:	48 c1 e0 02          	shl    $0x2,%rax
  800616:	48 01 d0             	add    %rdx,%rax
  800619:	48 01 c0             	add    %rax,%rax
  80061c:	48 01 d0             	add    %rdx,%rax
  80061f:	48 c1 e0 05          	shl    $0x5,%rax
  800623:	48 89 c2             	mov    %rax,%rdx
  800626:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80062d:	00 00 00 
  800630:	48 01 c2             	add    %rax,%rdx
  800633:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80063a:	00 00 00 
  80063d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800640:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800644:	7e 14                	jle    80065a <libmain+0x82>
		binaryname = argv[0];
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	48 8b 10             	mov    (%rax),%rdx
  80064d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800654:	00 00 00 
  800657:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80065a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800661:	48 89 d6             	mov    %rdx,%rsi
  800664:	89 c7                	mov    %eax,%edi
  800666:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  80066d:	00 00 00 
  800670:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800672:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
}
  80067e:	c9                   	leaveq 
  80067f:	c3                   	retq   

0000000000800680 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800684:	48 b8 79 24 80 00 00 	movabs $0x802479,%rax
  80068b:	00 00 00 
  80068e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800690:	bf 00 00 00 00       	mov    $0x0,%edi
  800695:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  80069c:	00 00 00 
  80069f:	ff d0                	callq  *%rax
}
  8006a1:	5d                   	pop    %rbp
  8006a2:	c3                   	retq   
	...

00000000008006a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006a4:	55                   	push   %rbp
  8006a5:	48 89 e5             	mov    %rsp,%rbp
  8006a8:	53                   	push   %rbx
  8006a9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8006b0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8006b7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8006bd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8006c4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8006cb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8006d2:	84 c0                	test   %al,%al
  8006d4:	74 23                	je     8006f9 <_panic+0x55>
  8006d6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8006dd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8006e1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8006e5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8006e9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8006ed:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8006f1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8006f5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8006f9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800700:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800707:	00 00 00 
  80070a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800711:	00 00 00 
  800714:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800718:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80071f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800726:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80072d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800734:	00 00 00 
  800737:	48 8b 18             	mov    (%rax),%rbx
  80073a:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  800741:	00 00 00 
  800744:	ff d0                	callq  *%rax
  800746:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80074c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800753:	41 89 c8             	mov    %ecx,%r8d
  800756:	48 89 d1             	mov    %rdx,%rcx
  800759:	48 89 da             	mov    %rbx,%rdx
  80075c:	89 c6                	mov    %eax,%esi
  80075e:	48 bf 98 42 80 00 00 	movabs $0x804298,%rdi
  800765:	00 00 00 
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
  80076d:	49 b9 df 08 80 00 00 	movabs $0x8008df,%r9
  800774:	00 00 00 
  800777:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80077a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800781:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800788:	48 89 d6             	mov    %rdx,%rsi
  80078b:	48 89 c7             	mov    %rax,%rdi
  80078e:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  800795:	00 00 00 
  800798:	ff d0                	callq  *%rax
	cprintf("\n");
  80079a:	48 bf bb 42 80 00 00 	movabs $0x8042bb,%rdi
  8007a1:	00 00 00 
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a9:	48 ba df 08 80 00 00 	movabs $0x8008df,%rdx
  8007b0:	00 00 00 
  8007b3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007b5:	cc                   	int3   
  8007b6:	eb fd                	jmp    8007b5 <_panic+0x111>

00000000008007b8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8007b8:	55                   	push   %rbp
  8007b9:	48 89 e5             	mov    %rsp,%rbp
  8007bc:	48 83 ec 10          	sub    $0x10,%rsp
  8007c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8007c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8007c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007cb:	8b 00                	mov    (%rax),%eax
  8007cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d0:	89 d6                	mov    %edx,%esi
  8007d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007d6:	48 63 d0             	movslq %eax,%rdx
  8007d9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8007de:	8d 50 01             	lea    0x1(%rax),%edx
  8007e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007e5:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8007e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007eb:	8b 00                	mov    (%rax),%eax
  8007ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007f2:	75 2c                	jne    800820 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8007f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007f8:	8b 00                	mov    (%rax),%eax
  8007fa:	48 98                	cltq   
  8007fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800800:	48 83 c2 08          	add    $0x8,%rdx
  800804:	48 89 c6             	mov    %rax,%rsi
  800807:	48 89 d7             	mov    %rdx,%rdi
  80080a:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  800811:	00 00 00 
  800814:	ff d0                	callq  *%rax
        b->idx = 0;
  800816:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80081a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800824:	8b 40 04             	mov    0x4(%rax),%eax
  800827:	8d 50 01             	lea    0x1(%rax),%edx
  80082a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80082e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800831:	c9                   	leaveq 
  800832:	c3                   	retq   

0000000000800833 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800833:	55                   	push   %rbp
  800834:	48 89 e5             	mov    %rsp,%rbp
  800837:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80083e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800845:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80084c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800853:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80085a:	48 8b 0a             	mov    (%rdx),%rcx
  80085d:	48 89 08             	mov    %rcx,(%rax)
  800860:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800864:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800868:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80086c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800870:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800877:	00 00 00 
    b.cnt = 0;
  80087a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800881:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800884:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80088b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800892:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800899:	48 89 c6             	mov    %rax,%rsi
  80089c:	48 bf b8 07 80 00 00 	movabs $0x8007b8,%rdi
  8008a3:	00 00 00 
  8008a6:	48 b8 90 0c 80 00 00 	movabs $0x800c90,%rax
  8008ad:	00 00 00 
  8008b0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8008b2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8008b8:	48 98                	cltq   
  8008ba:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8008c1:	48 83 c2 08          	add    $0x8,%rdx
  8008c5:	48 89 c6             	mov    %rax,%rsi
  8008c8:	48 89 d7             	mov    %rdx,%rdi
  8008cb:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8008d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8008dd:	c9                   	leaveq 
  8008de:	c3                   	retq   

00000000008008df <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8008ea:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8008f1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8008f8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8008ff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800906:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80090d:	84 c0                	test   %al,%al
  80090f:	74 20                	je     800931 <cprintf+0x52>
  800911:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800915:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800919:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80091d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800921:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800925:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800929:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80092d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800931:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800938:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80093f:	00 00 00 
  800942:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800949:	00 00 00 
  80094c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800950:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800957:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80095e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800965:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80096c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800973:	48 8b 0a             	mov    (%rdx),%rcx
  800976:	48 89 08             	mov    %rcx,(%rax)
  800979:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80097d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800981:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800985:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800989:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800990:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800997:	48 89 d6             	mov    %rdx,%rsi
  80099a:	48 89 c7             	mov    %rax,%rdi
  80099d:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  8009a4:	00 00 00 
  8009a7:	ff d0                	callq  *%rax
  8009a9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8009af:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8009b5:	c9                   	leaveq 
  8009b6:	c3                   	retq   
	...

00000000008009b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009b8:	55                   	push   %rbp
  8009b9:	48 89 e5             	mov    %rsp,%rbp
  8009bc:	48 83 ec 30          	sub    $0x30,%rsp
  8009c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8009c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8009c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8009cc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8009cf:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8009d3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8009da:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8009de:	77 52                	ja     800a32 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009e0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8009e3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8009e7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8009ea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8009fb:	48 89 c2             	mov    %rax,%rdx
  8009fe:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a01:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a04:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800a08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a0c:	41 89 f9             	mov    %edi,%r9d
  800a0f:	48 89 c7             	mov    %rax,%rdi
  800a12:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  800a19:	00 00 00 
  800a1c:	ff d0                	callq  *%rax
  800a1e:	eb 1c                	jmp    800a3c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a24:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a27:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800a2b:	48 89 d6             	mov    %rdx,%rsi
  800a2e:	89 c7                	mov    %eax,%edi
  800a30:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a32:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800a3a:	7f e4                	jg     800a20 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a3c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	ba 00 00 00 00       	mov    $0x0,%edx
  800a48:	48 f7 f1             	div    %rcx
  800a4b:	48 89 d0             	mov    %rdx,%rax
  800a4e:	48 ba b0 44 80 00 00 	movabs $0x8044b0,%rdx
  800a55:	00 00 00 
  800a58:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800a5c:	0f be c0             	movsbl %al,%eax
  800a5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a63:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800a67:	48 89 d6             	mov    %rdx,%rsi
  800a6a:	89 c7                	mov    %eax,%edi
  800a6c:	ff d1                	callq  *%rcx
}
  800a6e:	c9                   	leaveq 
  800a6f:	c3                   	retq   

0000000000800a70 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a70:	55                   	push   %rbp
  800a71:	48 89 e5             	mov    %rsp,%rbp
  800a74:	48 83 ec 20          	sub    $0x20,%rsp
  800a78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a7c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a7f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a83:	7e 52                	jle    800ad7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	8b 00                	mov    (%rax),%eax
  800a8b:	83 f8 30             	cmp    $0x30,%eax
  800a8e:	73 24                	jae    800ab4 <getuint+0x44>
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 01 d0             	add    %rdx,%rax
  800aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa7:	8b 12                	mov    (%rdx),%edx
  800aa9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab0:	89 0a                	mov    %ecx,(%rdx)
  800ab2:	eb 17                	jmp    800acb <getuint+0x5b>
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800abc:	48 89 d0             	mov    %rdx,%rax
  800abf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ac3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800acb:	48 8b 00             	mov    (%rax),%rax
  800ace:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ad2:	e9 a3 00 00 00       	jmpq   800b7a <getuint+0x10a>
	else if (lflag)
  800ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800adb:	74 4f                	je     800b2c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae1:	8b 00                	mov    (%rax),%eax
  800ae3:	83 f8 30             	cmp    $0x30,%eax
  800ae6:	73 24                	jae    800b0c <getuint+0x9c>
  800ae8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af4:	8b 00                	mov    (%rax),%eax
  800af6:	89 c0                	mov    %eax,%eax
  800af8:	48 01 d0             	add    %rdx,%rax
  800afb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aff:	8b 12                	mov    (%rdx),%edx
  800b01:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b08:	89 0a                	mov    %ecx,(%rdx)
  800b0a:	eb 17                	jmp    800b23 <getuint+0xb3>
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b14:	48 89 d0             	mov    %rdx,%rax
  800b17:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b23:	48 8b 00             	mov    (%rax),%rax
  800b26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b2a:	eb 4e                	jmp    800b7a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b30:	8b 00                	mov    (%rax),%eax
  800b32:	83 f8 30             	cmp    $0x30,%eax
  800b35:	73 24                	jae    800b5b <getuint+0xeb>
  800b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b43:	8b 00                	mov    (%rax),%eax
  800b45:	89 c0                	mov    %eax,%eax
  800b47:	48 01 d0             	add    %rdx,%rax
  800b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4e:	8b 12                	mov    (%rdx),%edx
  800b50:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b57:	89 0a                	mov    %ecx,(%rdx)
  800b59:	eb 17                	jmp    800b72 <getuint+0x102>
  800b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b63:	48 89 d0             	mov    %rdx,%rax
  800b66:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b72:	8b 00                	mov    (%rax),%eax
  800b74:	89 c0                	mov    %eax,%eax
  800b76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b7e:	c9                   	leaveq 
  800b7f:	c3                   	retq   

0000000000800b80 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b80:	55                   	push   %rbp
  800b81:	48 89 e5             	mov    %rsp,%rbp
  800b84:	48 83 ec 20          	sub    $0x20,%rsp
  800b88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b8c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b8f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b93:	7e 52                	jle    800be7 <getint+0x67>
		x=va_arg(*ap, long long);
  800b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b99:	8b 00                	mov    (%rax),%eax
  800b9b:	83 f8 30             	cmp    $0x30,%eax
  800b9e:	73 24                	jae    800bc4 <getint+0x44>
  800ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bac:	8b 00                	mov    (%rax),%eax
  800bae:	89 c0                	mov    %eax,%eax
  800bb0:	48 01 d0             	add    %rdx,%rax
  800bb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb7:	8b 12                	mov    (%rdx),%edx
  800bb9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc0:	89 0a                	mov    %ecx,(%rdx)
  800bc2:	eb 17                	jmp    800bdb <getint+0x5b>
  800bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bcc:	48 89 d0             	mov    %rdx,%rax
  800bcf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bdb:	48 8b 00             	mov    (%rax),%rax
  800bde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800be2:	e9 a3 00 00 00       	jmpq   800c8a <getint+0x10a>
	else if (lflag)
  800be7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800beb:	74 4f                	je     800c3c <getint+0xbc>
		x=va_arg(*ap, long);
  800bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf1:	8b 00                	mov    (%rax),%eax
  800bf3:	83 f8 30             	cmp    $0x30,%eax
  800bf6:	73 24                	jae    800c1c <getint+0x9c>
  800bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c04:	8b 00                	mov    (%rax),%eax
  800c06:	89 c0                	mov    %eax,%eax
  800c08:	48 01 d0             	add    %rdx,%rax
  800c0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0f:	8b 12                	mov    (%rdx),%edx
  800c11:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c18:	89 0a                	mov    %ecx,(%rdx)
  800c1a:	eb 17                	jmp    800c33 <getint+0xb3>
  800c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c20:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c24:	48 89 d0             	mov    %rdx,%rax
  800c27:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c33:	48 8b 00             	mov    (%rax),%rax
  800c36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c3a:	eb 4e                	jmp    800c8a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c40:	8b 00                	mov    (%rax),%eax
  800c42:	83 f8 30             	cmp    $0x30,%eax
  800c45:	73 24                	jae    800c6b <getint+0xeb>
  800c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c53:	8b 00                	mov    (%rax),%eax
  800c55:	89 c0                	mov    %eax,%eax
  800c57:	48 01 d0             	add    %rdx,%rax
  800c5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c5e:	8b 12                	mov    (%rdx),%edx
  800c60:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c67:	89 0a                	mov    %ecx,(%rdx)
  800c69:	eb 17                	jmp    800c82 <getint+0x102>
  800c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c73:	48 89 d0             	mov    %rdx,%rax
  800c76:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c82:	8b 00                	mov    (%rax),%eax
  800c84:	48 98                	cltq   
  800c86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c8e:	c9                   	leaveq 
  800c8f:	c3                   	retq   

0000000000800c90 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c90:	55                   	push   %rbp
  800c91:	48 89 e5             	mov    %rsp,%rbp
  800c94:	41 54                	push   %r12
  800c96:	53                   	push   %rbx
  800c97:	48 83 ec 60          	sub    $0x60,%rsp
  800c9b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c9f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ca3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ca7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800cab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800caf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800cb3:	48 8b 0a             	mov    (%rdx),%rcx
  800cb6:	48 89 08             	mov    %rcx,(%rax)
  800cb9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cbd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cc1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cc5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc9:	eb 17                	jmp    800ce2 <vprintfmt+0x52>
			if (ch == '\0')
  800ccb:	85 db                	test   %ebx,%ebx
  800ccd:	0f 84 ea 04 00 00    	je     8011bd <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800cd3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cd7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cdb:	48 89 c6             	mov    %rax,%rsi
  800cde:	89 df                	mov    %ebx,%edi
  800ce0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ce2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ce6:	0f b6 00             	movzbl (%rax),%eax
  800ce9:	0f b6 d8             	movzbl %al,%ebx
  800cec:	83 fb 25             	cmp    $0x25,%ebx
  800cef:	0f 95 c0             	setne  %al
  800cf2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800cf7:	84 c0                	test   %al,%al
  800cf9:	75 d0                	jne    800ccb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cfb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800cff:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d06:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800d0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800d14:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800d1b:	eb 04                	jmp    800d21 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800d1d:	90                   	nop
  800d1e:	eb 01                	jmp    800d21 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800d20:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d21:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d25:	0f b6 00             	movzbl (%rax),%eax
  800d28:	0f b6 d8             	movzbl %al,%ebx
  800d2b:	89 d8                	mov    %ebx,%eax
  800d2d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800d32:	83 e8 23             	sub    $0x23,%eax
  800d35:	83 f8 55             	cmp    $0x55,%eax
  800d38:	0f 87 4b 04 00 00    	ja     801189 <vprintfmt+0x4f9>
  800d3e:	89 c0                	mov    %eax,%eax
  800d40:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800d47:	00 
  800d48:	48 b8 d8 44 80 00 00 	movabs $0x8044d8,%rax
  800d4f:	00 00 00 
  800d52:	48 01 d0             	add    %rdx,%rax
  800d55:	48 8b 00             	mov    (%rax),%rax
  800d58:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800d5a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d5e:	eb c1                	jmp    800d21 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d60:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d64:	eb bb                	jmp    800d21 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d66:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d6d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	c1 e0 02             	shl    $0x2,%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	01 c0                	add    %eax,%eax
  800d79:	01 d8                	add    %ebx,%eax
  800d7b:	83 e8 30             	sub    $0x30,%eax
  800d7e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d85:	0f b6 00             	movzbl (%rax),%eax
  800d88:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d8b:	83 fb 2f             	cmp    $0x2f,%ebx
  800d8e:	7e 63                	jle    800df3 <vprintfmt+0x163>
  800d90:	83 fb 39             	cmp    $0x39,%ebx
  800d93:	7f 5e                	jg     800df3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d95:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d9a:	eb d1                	jmp    800d6d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800d9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9f:	83 f8 30             	cmp    $0x30,%eax
  800da2:	73 17                	jae    800dbb <vprintfmt+0x12b>
  800da4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800da8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dab:	89 c0                	mov    %eax,%eax
  800dad:	48 01 d0             	add    %rdx,%rax
  800db0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db3:	83 c2 08             	add    $0x8,%edx
  800db6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x13a>
  800dbb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dbf:	48 89 d0             	mov    %rdx,%rax
  800dc2:	48 83 c2 08          	add    $0x8,%rdx
  800dc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dca:	8b 00                	mov    (%rax),%eax
  800dcc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800dcf:	eb 23                	jmp    800df4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800dd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd5:	0f 89 42 ff ff ff    	jns    800d1d <vprintfmt+0x8d>
				width = 0;
  800ddb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800de2:	e9 36 ff ff ff       	jmpq   800d1d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800de7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800dee:	e9 2e ff ff ff       	jmpq   800d21 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800df3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800df4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df8:	0f 89 22 ff ff ff    	jns    800d20 <vprintfmt+0x90>
				width = precision, precision = -1;
  800dfe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e01:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e04:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e0b:	e9 10 ff ff ff       	jmpq   800d20 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e10:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800e14:	e9 08 ff ff ff       	jmpq   800d21 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800e19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1c:	83 f8 30             	cmp    $0x30,%eax
  800e1f:	73 17                	jae    800e38 <vprintfmt+0x1a8>
  800e21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e28:	89 c0                	mov    %eax,%eax
  800e2a:	48 01 d0             	add    %rdx,%rax
  800e2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e30:	83 c2 08             	add    $0x8,%edx
  800e33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e36:	eb 0f                	jmp    800e47 <vprintfmt+0x1b7>
  800e38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3c:	48 89 d0             	mov    %rdx,%rax
  800e3f:	48 83 c2 08          	add    $0x8,%rdx
  800e43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e47:	8b 00                	mov    (%rax),%eax
  800e49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e4d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800e51:	48 89 d6             	mov    %rdx,%rsi
  800e54:	89 c7                	mov    %eax,%edi
  800e56:	ff d1                	callq  *%rcx
			break;
  800e58:	e9 5a 03 00 00       	jmpq   8011b7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800e5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e60:	83 f8 30             	cmp    $0x30,%eax
  800e63:	73 17                	jae    800e7c <vprintfmt+0x1ec>
  800e65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e6c:	89 c0                	mov    %eax,%eax
  800e6e:	48 01 d0             	add    %rdx,%rax
  800e71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e74:	83 c2 08             	add    $0x8,%edx
  800e77:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e7a:	eb 0f                	jmp    800e8b <vprintfmt+0x1fb>
  800e7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e80:	48 89 d0             	mov    %rdx,%rax
  800e83:	48 83 c2 08          	add    $0x8,%rdx
  800e87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e8b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e8d:	85 db                	test   %ebx,%ebx
  800e8f:	79 02                	jns    800e93 <vprintfmt+0x203>
				err = -err;
  800e91:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e93:	83 fb 15             	cmp    $0x15,%ebx
  800e96:	7f 16                	jg     800eae <vprintfmt+0x21e>
  800e98:	48 b8 00 44 80 00 00 	movabs $0x804400,%rax
  800e9f:	00 00 00 
  800ea2:	48 63 d3             	movslq %ebx,%rdx
  800ea5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ea9:	4d 85 e4             	test   %r12,%r12
  800eac:	75 2e                	jne    800edc <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800eae:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb6:	89 d9                	mov    %ebx,%ecx
  800eb8:	48 ba c1 44 80 00 00 	movabs $0x8044c1,%rdx
  800ebf:	00 00 00 
  800ec2:	48 89 c7             	mov    %rax,%rdi
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eca:	49 b8 c7 11 80 00 00 	movabs $0x8011c7,%r8
  800ed1:	00 00 00 
  800ed4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed7:	e9 db 02 00 00       	jmpq   8011b7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800edc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ee0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee4:	4c 89 e1             	mov    %r12,%rcx
  800ee7:	48 ba ca 44 80 00 00 	movabs $0x8044ca,%rdx
  800eee:	00 00 00 
  800ef1:	48 89 c7             	mov    %rax,%rdi
  800ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef9:	49 b8 c7 11 80 00 00 	movabs $0x8011c7,%r8
  800f00:	00 00 00 
  800f03:	41 ff d0             	callq  *%r8
			break;
  800f06:	e9 ac 02 00 00       	jmpq   8011b7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0e:	83 f8 30             	cmp    $0x30,%eax
  800f11:	73 17                	jae    800f2a <vprintfmt+0x29a>
  800f13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1a:	89 c0                	mov    %eax,%eax
  800f1c:	48 01 d0             	add    %rdx,%rax
  800f1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f22:	83 c2 08             	add    $0x8,%edx
  800f25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f28:	eb 0f                	jmp    800f39 <vprintfmt+0x2a9>
  800f2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f2e:	48 89 d0             	mov    %rdx,%rax
  800f31:	48 83 c2 08          	add    $0x8,%rdx
  800f35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f39:	4c 8b 20             	mov    (%rax),%r12
  800f3c:	4d 85 e4             	test   %r12,%r12
  800f3f:	75 0a                	jne    800f4b <vprintfmt+0x2bb>
				p = "(null)";
  800f41:	49 bc cd 44 80 00 00 	movabs $0x8044cd,%r12
  800f48:	00 00 00 
			if (width > 0 && padc != '-')
  800f4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f4f:	7e 7a                	jle    800fcb <vprintfmt+0x33b>
  800f51:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800f55:	74 74                	je     800fcb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f57:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f5a:	48 98                	cltq   
  800f5c:	48 89 c6             	mov    %rax,%rsi
  800f5f:	4c 89 e7             	mov    %r12,%rdi
  800f62:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  800f69:	00 00 00 
  800f6c:	ff d0                	callq  *%rax
  800f6e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f71:	eb 17                	jmp    800f8a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800f73:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800f77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f7b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800f7f:	48 89 d6             	mov    %rdx,%rsi
  800f82:	89 c7                	mov    %eax,%edi
  800f84:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f86:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f8e:	7f e3                	jg     800f73 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f90:	eb 39                	jmp    800fcb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800f92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f96:	74 1e                	je     800fb6 <vprintfmt+0x326>
  800f98:	83 fb 1f             	cmp    $0x1f,%ebx
  800f9b:	7e 05                	jle    800fa2 <vprintfmt+0x312>
  800f9d:	83 fb 7e             	cmp    $0x7e,%ebx
  800fa0:	7e 14                	jle    800fb6 <vprintfmt+0x326>
					putch('?', putdat);
  800fa2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fa6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800faa:	48 89 c6             	mov    %rax,%rsi
  800fad:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800fb2:	ff d2                	callq  *%rdx
  800fb4:	eb 0f                	jmp    800fc5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800fb6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800fba:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800fbe:	48 89 c6             	mov    %rax,%rsi
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fc5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fc9:	eb 01                	jmp    800fcc <vprintfmt+0x33c>
  800fcb:	90                   	nop
  800fcc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800fd1:	0f be d8             	movsbl %al,%ebx
  800fd4:	85 db                	test   %ebx,%ebx
  800fd6:	0f 95 c0             	setne  %al
  800fd9:	49 83 c4 01          	add    $0x1,%r12
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 28                	je     801009 <vprintfmt+0x379>
  800fe1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800fe5:	78 ab                	js     800f92 <vprintfmt+0x302>
  800fe7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800feb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800fef:	79 a1                	jns    800f92 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ff1:	eb 16                	jmp    801009 <vprintfmt+0x379>
				putch(' ', putdat);
  800ff3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ff7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ffb:	48 89 c6             	mov    %rax,%rsi
  800ffe:	bf 20 00 00 00       	mov    $0x20,%edi
  801003:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801005:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801009:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80100d:	7f e4                	jg     800ff3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80100f:	e9 a3 01 00 00       	jmpq   8011b7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801014:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801018:	be 03 00 00 00       	mov    $0x3,%esi
  80101d:	48 89 c7             	mov    %rax,%rdi
  801020:	48 b8 80 0b 80 00 00 	movabs $0x800b80,%rax
  801027:	00 00 00 
  80102a:	ff d0                	callq  *%rax
  80102c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801034:	48 85 c0             	test   %rax,%rax
  801037:	79 1d                	jns    801056 <vprintfmt+0x3c6>
				putch('-', putdat);
  801039:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80103d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801041:	48 89 c6             	mov    %rax,%rsi
  801044:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801049:	ff d2                	callq  *%rdx
				num = -(long long) num;
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104f:	48 f7 d8             	neg    %rax
  801052:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801056:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80105d:	e9 e8 00 00 00       	jmpq   80114a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801062:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801066:	be 03 00 00 00       	mov    $0x3,%esi
  80106b:	48 89 c7             	mov    %rax,%rdi
  80106e:	48 b8 70 0a 80 00 00 	movabs $0x800a70,%rax
  801075:	00 00 00 
  801078:	ff d0                	callq  *%rax
  80107a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80107e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801085:	e9 c0 00 00 00       	jmpq   80114a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80108a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80108e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801092:	48 89 c6             	mov    %rax,%rsi
  801095:	bf 58 00 00 00       	mov    $0x58,%edi
  80109a:	ff d2                	callq  *%rdx
			putch('X', putdat);
  80109c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010a0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010a4:	48 89 c6             	mov    %rax,%rsi
  8010a7:	bf 58 00 00 00       	mov    $0x58,%edi
  8010ac:	ff d2                	callq  *%rdx
			putch('X', putdat);
  8010ae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010b2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010b6:	48 89 c6             	mov    %rax,%rsi
  8010b9:	bf 58 00 00 00       	mov    $0x58,%edi
  8010be:	ff d2                	callq  *%rdx
			break;
  8010c0:	e9 f2 00 00 00       	jmpq   8011b7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  8010c5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010c9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010cd:	48 89 c6             	mov    %rax,%rsi
  8010d0:	bf 30 00 00 00       	mov    $0x30,%edi
  8010d5:	ff d2                	callq  *%rdx
			putch('x', putdat);
  8010d7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010db:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010df:	48 89 c6             	mov    %rax,%rsi
  8010e2:	bf 78 00 00 00       	mov    $0x78,%edi
  8010e7:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8010e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ec:	83 f8 30             	cmp    $0x30,%eax
  8010ef:	73 17                	jae    801108 <vprintfmt+0x478>
  8010f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010f8:	89 c0                	mov    %eax,%eax
  8010fa:	48 01 d0             	add    %rdx,%rax
  8010fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801100:	83 c2 08             	add    $0x8,%edx
  801103:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801106:	eb 0f                	jmp    801117 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  801108:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80110c:	48 89 d0             	mov    %rdx,%rax
  80110f:	48 83 c2 08          	add    $0x8,%rdx
  801113:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801117:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80111a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80111e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801125:	eb 23                	jmp    80114a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801127:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80112b:	be 03 00 00 00       	mov    $0x3,%esi
  801130:	48 89 c7             	mov    %rax,%rdi
  801133:	48 b8 70 0a 80 00 00 	movabs $0x800a70,%rax
  80113a:	00 00 00 
  80113d:	ff d0                	callq  *%rax
  80113f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801143:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80114a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80114f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801152:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801159:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80115d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801161:	45 89 c1             	mov    %r8d,%r9d
  801164:	41 89 f8             	mov    %edi,%r8d
  801167:	48 89 c7             	mov    %rax,%rdi
  80116a:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax
			break;
  801176:	eb 3f                	jmp    8011b7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801178:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80117c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801180:	48 89 c6             	mov    %rax,%rsi
  801183:	89 df                	mov    %ebx,%edi
  801185:	ff d2                	callq  *%rdx
			break;
  801187:	eb 2e                	jmp    8011b7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801189:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80118d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801191:	48 89 c6             	mov    %rax,%rsi
  801194:	bf 25 00 00 00       	mov    $0x25,%edi
  801199:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80119b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011a0:	eb 05                	jmp    8011a7 <vprintfmt+0x517>
  8011a2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011ab:	48 83 e8 01          	sub    $0x1,%rax
  8011af:	0f b6 00             	movzbl (%rax),%eax
  8011b2:	3c 25                	cmp    $0x25,%al
  8011b4:	75 ec                	jne    8011a2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  8011b6:	90                   	nop
		}
	}
  8011b7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011b8:	e9 25 fb ff ff       	jmpq   800ce2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8011bd:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8011be:	48 83 c4 60          	add    $0x60,%rsp
  8011c2:	5b                   	pop    %rbx
  8011c3:	41 5c                	pop    %r12
  8011c5:	5d                   	pop    %rbp
  8011c6:	c3                   	retq   

00000000008011c7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8011d2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8011d9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8011e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f5:	84 c0                	test   %al,%al
  8011f7:	74 20                	je     801219 <printfmt+0x52>
  8011f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801201:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801205:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801209:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80120d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801211:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801215:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801219:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801220:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801227:	00 00 00 
  80122a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801231:	00 00 00 
  801234:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801238:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80123f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801246:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80124d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801254:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80125b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801262:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801269:	48 89 c7             	mov    %rax,%rdi
  80126c:	48 b8 90 0c 80 00 00 	movabs $0x800c90,%rax
  801273:	00 00 00 
  801276:	ff d0                	callq  *%rax
	va_end(ap);
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 83 ec 10          	sub    $0x10,%rsp
  801282:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801285:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	8b 40 10             	mov    0x10(%rax),%eax
  801290:	8d 50 01             	lea    0x1(%rax),%edx
  801293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801297:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80129a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129e:	48 8b 10             	mov    (%rax),%rdx
  8012a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012a9:	48 39 c2             	cmp    %rax,%rdx
  8012ac:	73 17                	jae    8012c5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	48 8b 00             	mov    (%rax),%rax
  8012b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012b8:	88 10                	mov    %dl,(%rax)
  8012ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c2:	48 89 10             	mov    %rdx,(%rax)
}
  8012c5:	c9                   	leaveq 
  8012c6:	c3                   	retq   

00000000008012c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
  8012cb:	48 83 ec 50          	sub    $0x50,%rsp
  8012cf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8012d3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8012d6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8012da:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8012de:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8012e2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8012e6:	48 8b 0a             	mov    (%rdx),%rcx
  8012e9:	48 89 08             	mov    %rcx,(%rax)
  8012ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801300:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801304:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801307:	48 98                	cltq   
  801309:	48 83 e8 01          	sub    $0x1,%rax
  80130d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801311:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801315:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80131c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801321:	74 06                	je     801329 <vsnprintf+0x62>
  801323:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801327:	7f 07                	jg     801330 <vsnprintf+0x69>
		return -E_INVAL;
  801329:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132e:	eb 2f                	jmp    80135f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801330:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801334:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801338:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80133c:	48 89 c6             	mov    %rax,%rsi
  80133f:	48 bf 7a 12 80 00 00 	movabs $0x80127a,%rdi
  801346:	00 00 00 
  801349:	48 b8 90 0c 80 00 00 	movabs $0x800c90,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801355:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801359:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80135c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80136c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801373:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801379:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801380:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801387:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80138e:	84 c0                	test   %al,%al
  801390:	74 20                	je     8013b2 <snprintf+0x51>
  801392:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801396:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80139a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80139e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8013a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8013ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8013b2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8013b9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8013c0:	00 00 00 
  8013c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8013ca:	00 00 00 
  8013cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8013d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8013d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8013df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8013e6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8013ed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8013f4:	48 8b 0a             	mov    (%rdx),%rcx
  8013f7:	48 89 08             	mov    %rcx,(%rax)
  8013fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801402:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801406:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80140a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801411:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801418:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80141e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801425:	48 89 c7             	mov    %rax,%rdi
  801428:	48 b8 c7 12 80 00 00 	movabs $0x8012c7,%rax
  80142f:	00 00 00 
  801432:	ff d0                	callq  *%rax
  801434:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80143a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801440:	c9                   	leaveq 
  801441:	c3                   	retq   
	...

0000000000801444 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801444:	55                   	push   %rbp
  801445:	48 89 e5             	mov    %rsp,%rbp
  801448:	48 83 ec 18          	sub    $0x18,%rsp
  80144c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801457:	eb 09                	jmp    801462 <strlen+0x1e>
		n++;
  801459:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80145d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	84 c0                	test   %al,%al
  80146b:	75 ec                	jne    801459 <strlen+0x15>
		n++;
	return n;
  80146d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 20          	sub    $0x20,%rsp
  80147a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801482:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801489:	eb 0e                	jmp    801499 <strnlen+0x27>
		n++;
  80148b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80148f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801494:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801499:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80149e:	74 0b                	je     8014ab <strnlen+0x39>
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	0f b6 00             	movzbl (%rax),%eax
  8014a7:	84 c0                	test   %al,%al
  8014a9:	75 e0                	jne    80148b <strnlen+0x19>
		n++;
	return n;
  8014ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 83 ec 20          	sub    $0x20,%rsp
  8014b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014c8:	90                   	nop
  8014c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014cd:	0f b6 10             	movzbl (%rax),%edx
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	88 10                	mov    %dl,(%rax)
  8014d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014da:	0f b6 00             	movzbl (%rax),%eax
  8014dd:	84 c0                	test   %al,%al
  8014df:	0f 95 c0             	setne  %al
  8014e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014e7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8014ec:	84 c0                	test   %al,%al
  8014ee:	75 d9                	jne    8014c9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f4:	c9                   	leaveq 
  8014f5:	c3                   	retq   

00000000008014f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014f6:	55                   	push   %rbp
  8014f7:	48 89 e5             	mov    %rsp,%rbp
  8014fa:	48 83 ec 20          	sub    $0x20,%rsp
  8014fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801502:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	48 89 c7             	mov    %rax,%rdi
  80150d:	48 b8 44 14 80 00 00 	movabs $0x801444,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
  801519:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80151c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80151f:	48 98                	cltq   
  801521:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801525:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801529:	48 89 d6             	mov    %rdx,%rsi
  80152c:	48 89 c7             	mov    %rax,%rdi
  80152f:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  801536:	00 00 00 
  801539:	ff d0                	callq  *%rax
	return dst;
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80153f:	c9                   	leaveq 
  801540:	c3                   	retq   

0000000000801541 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	48 83 ec 28          	sub    $0x28,%rsp
  801549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801559:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80155d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801564:	00 
  801565:	eb 27                	jmp    80158e <strncpy+0x4d>
		*dst++ = *src;
  801567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156b:	0f b6 10             	movzbl (%rax),%edx
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801572:	88 10                	mov    %dl,(%rax)
  801574:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	84 c0                	test   %al,%al
  801582:	74 05                	je     801589 <strncpy+0x48>
			src++;
  801584:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801596:	72 cf                	jb     801567 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80159c:	c9                   	leaveq 
  80159d:	c3                   	retq   

000000000080159e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80159e:	55                   	push   %rbp
  80159f:	48 89 e5             	mov    %rsp,%rbp
  8015a2:	48 83 ec 28          	sub    $0x28,%rsp
  8015a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8015b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8015ba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015bf:	74 37                	je     8015f8 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8015c1:	eb 17                	jmp    8015da <strlcpy+0x3c>
			*dst++ = *src++;
  8015c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c7:	0f b6 10             	movzbl (%rax),%edx
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ce:	88 10                	mov    %dl,(%rax)
  8015d0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015d5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015da:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015e4:	74 0b                	je     8015f1 <strlcpy+0x53>
  8015e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	84 c0                	test   %al,%al
  8015ef:	75 d2                	jne    8015c3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	48 89 d1             	mov    %rdx,%rcx
  801603:	48 29 c1             	sub    %rax,%rcx
  801606:	48 89 c8             	mov    %rcx,%rax
}
  801609:	c9                   	leaveq 
  80160a:	c3                   	retq   

000000000080160b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80160b:	55                   	push   %rbp
  80160c:	48 89 e5             	mov    %rsp,%rbp
  80160f:	48 83 ec 10          	sub    $0x10,%rsp
  801613:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801617:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80161b:	eb 0a                	jmp    801627 <strcmp+0x1c>
		p++, q++;
  80161d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801622:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162b:	0f b6 00             	movzbl (%rax),%eax
  80162e:	84 c0                	test   %al,%al
  801630:	74 12                	je     801644 <strcmp+0x39>
  801632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801636:	0f b6 10             	movzbl (%rax),%edx
  801639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	38 c2                	cmp    %al,%dl
  801642:	74 d9                	je     80161d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	0f b6 d0             	movzbl %al,%edx
  80164e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	0f b6 c0             	movzbl %al,%eax
  801658:	89 d1                	mov    %edx,%ecx
  80165a:	29 c1                	sub    %eax,%ecx
  80165c:	89 c8                	mov    %ecx,%eax
}
  80165e:	c9                   	leaveq 
  80165f:	c3                   	retq   

0000000000801660 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	48 83 ec 18          	sub    $0x18,%rsp
  801668:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80166c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801670:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801674:	eb 0f                	jmp    801685 <strncmp+0x25>
		n--, p++, q++;
  801676:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80167b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801680:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801685:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168a:	74 1d                	je     8016a9 <strncmp+0x49>
  80168c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	84 c0                	test   %al,%al
  801695:	74 12                	je     8016a9 <strncmp+0x49>
  801697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169b:	0f b6 10             	movzbl (%rax),%edx
  80169e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	38 c2                	cmp    %al,%dl
  8016a7:	74 cd                	je     801676 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8016a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016ae:	75 07                	jne    8016b7 <strncmp+0x57>
		return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 1a                	jmp    8016d1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f b6 d0             	movzbl %al,%edx
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	0f b6 c0             	movzbl %al,%eax
  8016cb:	89 d1                	mov    %edx,%ecx
  8016cd:	29 c1                	sub    %eax,%ecx
  8016cf:	89 c8                	mov    %ecx,%eax
}
  8016d1:	c9                   	leaveq 
  8016d2:	c3                   	retq   

00000000008016d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016d3:	55                   	push   %rbp
  8016d4:	48 89 e5             	mov    %rsp,%rbp
  8016d7:	48 83 ec 10          	sub    $0x10,%rsp
  8016db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016df:	89 f0                	mov    %esi,%eax
  8016e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016e4:	eb 17                	jmp    8016fd <strchr+0x2a>
		if (*s == c)
  8016e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016f0:	75 06                	jne    8016f8 <strchr+0x25>
			return (char *) s;
  8016f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f6:	eb 15                	jmp    80170d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	84 c0                	test   %al,%al
  801706:	75 de                	jne    8016e6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 10          	sub    $0x10,%rsp
  801717:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80171b:	89 f0                	mov    %esi,%eax
  80171d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801720:	eb 11                	jmp    801733 <strfind+0x24>
		if (*s == c)
  801722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80172c:	74 12                	je     801740 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80172e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	84 c0                	test   %al,%al
  80173c:	75 e4                	jne    801722 <strfind+0x13>
  80173e:	eb 01                	jmp    801741 <strfind+0x32>
		if (*s == c)
			break;
  801740:	90                   	nop
	return (char *) s;
  801741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801745:	c9                   	leaveq 
  801746:	c3                   	retq   

0000000000801747 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801747:	55                   	push   %rbp
  801748:	48 89 e5             	mov    %rsp,%rbp
  80174b:	48 83 ec 18          	sub    $0x18,%rsp
  80174f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801753:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801756:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80175a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80175f:	75 06                	jne    801767 <memset+0x20>
		return v;
  801761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801765:	eb 69                	jmp    8017d0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176b:	83 e0 03             	and    $0x3,%eax
  80176e:	48 85 c0             	test   %rax,%rax
  801771:	75 48                	jne    8017bb <memset+0x74>
  801773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801777:	83 e0 03             	and    $0x3,%eax
  80177a:	48 85 c0             	test   %rax,%rax
  80177d:	75 3c                	jne    8017bb <memset+0x74>
		c &= 0xFF;
  80177f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801786:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801789:	89 c2                	mov    %eax,%edx
  80178b:	c1 e2 18             	shl    $0x18,%edx
  80178e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801791:	c1 e0 10             	shl    $0x10,%eax
  801794:	09 c2                	or     %eax,%edx
  801796:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801799:	c1 e0 08             	shl    $0x8,%eax
  80179c:	09 d0                	or     %edx,%eax
  80179e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 89 c1             	mov    %rax,%rcx
  8017a8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017b3:	48 89 d7             	mov    %rdx,%rdi
  8017b6:	fc                   	cld    
  8017b7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8017b9:	eb 11                	jmp    8017cc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017c6:	48 89 d7             	mov    %rdx,%rdi
  8017c9:	fc                   	cld    
  8017ca:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8017cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017d0:	c9                   	leaveq 
  8017d1:	c3                   	retq   

00000000008017d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017d2:	55                   	push   %rbp
  8017d3:	48 89 e5             	mov    %rsp,%rbp
  8017d6:	48 83 ec 28          	sub    $0x28,%rsp
  8017da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017fe:	0f 83 88 00 00 00    	jae    80188c <memmove+0xba>
  801804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801808:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80180c:	48 01 d0             	add    %rdx,%rax
  80180f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801813:	76 77                	jbe    80188c <memmove+0xba>
		s += n;
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801829:	83 e0 03             	and    $0x3,%eax
  80182c:	48 85 c0             	test   %rax,%rax
  80182f:	75 3b                	jne    80186c <memmove+0x9a>
  801831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801835:	83 e0 03             	and    $0x3,%eax
  801838:	48 85 c0             	test   %rax,%rax
  80183b:	75 2f                	jne    80186c <memmove+0x9a>
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	83 e0 03             	and    $0x3,%eax
  801844:	48 85 c0             	test   %rax,%rax
  801847:	75 23                	jne    80186c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184d:	48 83 e8 04          	sub    $0x4,%rax
  801851:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801855:	48 83 ea 04          	sub    $0x4,%rdx
  801859:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80185d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801861:	48 89 c7             	mov    %rax,%rdi
  801864:	48 89 d6             	mov    %rdx,%rsi
  801867:	fd                   	std    
  801868:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80186a:	eb 1d                	jmp    801889 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80186c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801870:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801878:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	48 89 d7             	mov    %rdx,%rdi
  801883:	48 89 c1             	mov    %rax,%rcx
  801886:	fd                   	std    
  801887:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801889:	fc                   	cld    
  80188a:	eb 57                	jmp    8018e3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80188c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801890:	83 e0 03             	and    $0x3,%eax
  801893:	48 85 c0             	test   %rax,%rax
  801896:	75 36                	jne    8018ce <memmove+0xfc>
  801898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189c:	83 e0 03             	and    $0x3,%eax
  80189f:	48 85 c0             	test   %rax,%rax
  8018a2:	75 2a                	jne    8018ce <memmove+0xfc>
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	83 e0 03             	and    $0x3,%eax
  8018ab:	48 85 c0             	test   %rax,%rax
  8018ae:	75 1e                	jne    8018ce <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b4:	48 89 c1             	mov    %rax,%rcx
  8018b7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8018bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c3:	48 89 c7             	mov    %rax,%rdi
  8018c6:	48 89 d6             	mov    %rdx,%rsi
  8018c9:	fc                   	cld    
  8018ca:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018cc:	eb 15                	jmp    8018e3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018da:	48 89 c7             	mov    %rax,%rdi
  8018dd:	48 89 d6             	mov    %rdx,%rsi
  8018e0:	fc                   	cld    
  8018e1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e7:	c9                   	leaveq 
  8018e8:	c3                   	retq   

00000000008018e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	48 83 ec 18          	sub    $0x18,%rsp
  8018f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801901:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801909:	48 89 ce             	mov    %rcx,%rsi
  80190c:	48 89 c7             	mov    %rax,%rdi
  80190f:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  801916:	00 00 00 
  801919:	ff d0                	callq  *%rax
}
  80191b:	c9                   	leaveq 
  80191c:	c3                   	retq   

000000000080191d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
  801921:	48 83 ec 28          	sub    $0x28,%rsp
  801925:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801929:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80192d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801935:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80193d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801941:	eb 38                	jmp    80197b <memcmp+0x5e>
		if (*s1 != *s2)
  801943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801947:	0f b6 10             	movzbl (%rax),%edx
  80194a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	38 c2                	cmp    %al,%dl
  801953:	74 1c                	je     801971 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	0f b6 d0             	movzbl %al,%edx
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	0f b6 c0             	movzbl %al,%eax
  801969:	89 d1                	mov    %edx,%ecx
  80196b:	29 c1                	sub    %eax,%ecx
  80196d:	89 c8                	mov    %ecx,%eax
  80196f:	eb 20                	jmp    801991 <memcmp+0x74>
		s1++, s2++;
  801971:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801976:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80197b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801980:	0f 95 c0             	setne  %al
  801983:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801988:	84 c0                	test   %al,%al
  80198a:	75 b7                	jne    801943 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 28          	sub    $0x28,%rsp
  80199b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80199f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8019a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8019a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019ae:	48 01 d0             	add    %rdx,%rax
  8019b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8019b5:	eb 13                	jmp    8019ca <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019bb:	0f b6 10             	movzbl (%rax),%edx
  8019be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019c1:	38 c2                	cmp    %al,%dl
  8019c3:	74 11                	je     8019d6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ce:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019d2:	72 e3                	jb     8019b7 <memfind+0x24>
  8019d4:	eb 01                	jmp    8019d7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019d6:	90                   	nop
	return (void *) s;
  8019d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019db:	c9                   	leaveq 
  8019dc:	c3                   	retq   

00000000008019dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
  8019e1:	48 83 ec 38          	sub    $0x38,%rsp
  8019e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019ed:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019f7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019fe:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ff:	eb 05                	jmp    801a06 <strtol+0x29>
		s++;
  801a01:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3c 20                	cmp    $0x20,%al
  801a0f:	74 f0                	je     801a01 <strtol+0x24>
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	0f b6 00             	movzbl (%rax),%eax
  801a18:	3c 09                	cmp    $0x9,%al
  801a1a:	74 e5                	je     801a01 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a20:	0f b6 00             	movzbl (%rax),%eax
  801a23:	3c 2b                	cmp    $0x2b,%al
  801a25:	75 07                	jne    801a2e <strtol+0x51>
		s++;
  801a27:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a2c:	eb 17                	jmp    801a45 <strtol+0x68>
	else if (*s == '-')
  801a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a32:	0f b6 00             	movzbl (%rax),%eax
  801a35:	3c 2d                	cmp    $0x2d,%al
  801a37:	75 0c                	jne    801a45 <strtol+0x68>
		s++, neg = 1;
  801a39:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a3e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a45:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a49:	74 06                	je     801a51 <strtol+0x74>
  801a4b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a4f:	75 28                	jne    801a79 <strtol+0x9c>
  801a51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a55:	0f b6 00             	movzbl (%rax),%eax
  801a58:	3c 30                	cmp    $0x30,%al
  801a5a:	75 1d                	jne    801a79 <strtol+0x9c>
  801a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a60:	48 83 c0 01          	add    $0x1,%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	3c 78                	cmp    $0x78,%al
  801a69:	75 0e                	jne    801a79 <strtol+0x9c>
		s += 2, base = 16;
  801a6b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a70:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a77:	eb 2c                	jmp    801aa5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a79:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a7d:	75 19                	jne    801a98 <strtol+0xbb>
  801a7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a83:	0f b6 00             	movzbl (%rax),%eax
  801a86:	3c 30                	cmp    $0x30,%al
  801a88:	75 0e                	jne    801a98 <strtol+0xbb>
		s++, base = 8;
  801a8a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a8f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a96:	eb 0d                	jmp    801aa5 <strtol+0xc8>
	else if (base == 0)
  801a98:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a9c:	75 07                	jne    801aa5 <strtol+0xc8>
		base = 10;
  801a9e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	0f b6 00             	movzbl (%rax),%eax
  801aac:	3c 2f                	cmp    $0x2f,%al
  801aae:	7e 1d                	jle    801acd <strtol+0xf0>
  801ab0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab4:	0f b6 00             	movzbl (%rax),%eax
  801ab7:	3c 39                	cmp    $0x39,%al
  801ab9:	7f 12                	jg     801acd <strtol+0xf0>
			dig = *s - '0';
  801abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abf:	0f b6 00             	movzbl (%rax),%eax
  801ac2:	0f be c0             	movsbl %al,%eax
  801ac5:	83 e8 30             	sub    $0x30,%eax
  801ac8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801acb:	eb 4e                	jmp    801b1b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad1:	0f b6 00             	movzbl (%rax),%eax
  801ad4:	3c 60                	cmp    $0x60,%al
  801ad6:	7e 1d                	jle    801af5 <strtol+0x118>
  801ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adc:	0f b6 00             	movzbl (%rax),%eax
  801adf:	3c 7a                	cmp    $0x7a,%al
  801ae1:	7f 12                	jg     801af5 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ae3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae7:	0f b6 00             	movzbl (%rax),%eax
  801aea:	0f be c0             	movsbl %al,%eax
  801aed:	83 e8 57             	sub    $0x57,%eax
  801af0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801af3:	eb 26                	jmp    801b1b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	0f b6 00             	movzbl (%rax),%eax
  801afc:	3c 40                	cmp    $0x40,%al
  801afe:	7e 47                	jle    801b47 <strtol+0x16a>
  801b00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b04:	0f b6 00             	movzbl (%rax),%eax
  801b07:	3c 5a                	cmp    $0x5a,%al
  801b09:	7f 3c                	jg     801b47 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0f:	0f b6 00             	movzbl (%rax),%eax
  801b12:	0f be c0             	movsbl %al,%eax
  801b15:	83 e8 37             	sub    $0x37,%eax
  801b18:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b1e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b21:	7d 23                	jge    801b46 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801b23:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b28:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b2b:	48 98                	cltq   
  801b2d:	48 89 c2             	mov    %rax,%rdx
  801b30:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801b35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b38:	48 98                	cltq   
  801b3a:	48 01 d0             	add    %rdx,%rax
  801b3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b41:	e9 5f ff ff ff       	jmpq   801aa5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b46:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b47:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b4c:	74 0b                	je     801b59 <strtol+0x17c>
		*endptr = (char *) s;
  801b4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b52:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b56:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b5d:	74 09                	je     801b68 <strtol+0x18b>
  801b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b63:	48 f7 d8             	neg    %rax
  801b66:	eb 04                	jmp    801b6c <strtol+0x18f>
  801b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b6c:	c9                   	leaveq 
  801b6d:	c3                   	retq   

0000000000801b6e <strstr>:

char * strstr(const char *in, const char *str)
{
  801b6e:	55                   	push   %rbp
  801b6f:	48 89 e5             	mov    %rsp,%rbp
  801b72:	48 83 ec 30          	sub    $0x30,%rsp
  801b76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b7a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	88 45 ff             	mov    %al,-0x1(%rbp)
  801b88:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801b8d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b91:	75 06                	jne    801b99 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801b93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b97:	eb 68                	jmp    801c01 <strstr+0x93>

	len = strlen(str);
  801b99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b9d:	48 89 c7             	mov    %rax,%rdi
  801ba0:	48 b8 44 14 80 00 00 	movabs $0x801444,%rax
  801ba7:	00 00 00 
  801baa:	ff d0                	callq  *%rax
  801bac:	48 98                	cltq   
  801bae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801bb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb6:	0f b6 00             	movzbl (%rax),%eax
  801bb9:	88 45 ef             	mov    %al,-0x11(%rbp)
  801bbc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801bc1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801bc5:	75 07                	jne    801bce <strstr+0x60>
				return (char *) 0;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcc:	eb 33                	jmp    801c01 <strstr+0x93>
		} while (sc != c);
  801bce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801bd2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bd5:	75 db                	jne    801bb2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801bd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be3:	48 89 ce             	mov    %rcx,%rsi
  801be6:	48 89 c7             	mov    %rax,%rdi
  801be9:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	callq  *%rax
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	75 b9                	jne    801bb2 <strstr+0x44>

	return (char *) (in - 1);
  801bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfd:	48 83 e8 01          	sub    $0x1,%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   
	...

0000000000801c04 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	53                   	push   %rbx
  801c09:	48 83 ec 58          	sub    $0x58,%rsp
  801c0d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c10:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c13:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c17:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c1b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c1f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c26:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801c29:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c2d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c31:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c35:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c39:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c3d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801c40:	4c 89 c3             	mov    %r8,%rbx
  801c43:	cd 30                	int    $0x30
  801c45:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801c49:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801c4d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c55:	74 3e                	je     801c95 <syscall+0x91>
  801c57:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c5c:	7e 37                	jle    801c95 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c62:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c65:	49 89 d0             	mov    %rdx,%r8
  801c68:	89 c1                	mov    %eax,%ecx
  801c6a:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  801c71:	00 00 00 
  801c74:	be 23 00 00 00       	mov    $0x23,%esi
  801c79:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  801c80:	00 00 00 
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
  801c88:	49 b9 a4 06 80 00 00 	movabs $0x8006a4,%r9
  801c8f:	00 00 00 
  801c92:	41 ff d1             	callq  *%r9

	return ret;
  801c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c99:	48 83 c4 58          	add    $0x58,%rsp
  801c9d:	5b                   	pop    %rbx
  801c9e:	5d                   	pop    %rbp
  801c9f:	c3                   	retq   

0000000000801ca0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 20          	sub    $0x20,%rsp
  801ca8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbf:	00 
  801cc0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccc:	48 89 d1             	mov    %rdx,%rcx
  801ccf:	48 89 c2             	mov    %rax,%rdx
  801cd2:	be 00 00 00 00       	mov    $0x0,%esi
  801cd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cdc:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801ce3:	00 00 00 
  801ce6:	ff d0                	callq  *%rax
}
  801ce8:	c9                   	leaveq 
  801ce9:	c3                   	retq   

0000000000801cea <sys_cgetc>:

int
sys_cgetc(void)
{
  801cea:	55                   	push   %rbp
  801ceb:	48 89 e5             	mov    %rsp,%rbp
  801cee:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cf2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf9:	00 
  801cfa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d10:	be 00 00 00 00       	mov    $0x0,%esi
  801d15:	bf 01 00 00 00       	mov    $0x1,%edi
  801d1a:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	callq  *%rax
}
  801d26:	c9                   	leaveq 
  801d27:	c3                   	retq   

0000000000801d28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d28:	55                   	push   %rbp
  801d29:	48 89 e5             	mov    %rsp,%rbp
  801d2c:	48 83 ec 20          	sub    $0x20,%rsp
  801d30:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d36:	48 98                	cltq   
  801d38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3f:	00 
  801d40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	be 01 00 00 00       	mov    $0x1,%esi
  801d59:	bf 03 00 00 00       	mov    $0x3,%edi
  801d5e:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7b:	00 
  801d7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	be 00 00 00 00       	mov    $0x0,%esi
  801d97:	bf 02 00 00 00       	mov    $0x2,%edi
  801d9c:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
}
  801da8:	c9                   	leaveq 
  801da9:	c3                   	retq   

0000000000801daa <sys_yield>:

void
sys_yield(void)
{
  801daa:	55                   	push   %rbp
  801dab:	48 89 e5             	mov    %rsp,%rbp
  801dae:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801db2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db9:	00 
  801dba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd0:	be 00 00 00 00       	mov    $0x0,%esi
  801dd5:	bf 0b 00 00 00       	mov    $0xb,%edi
  801dda:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	callq  *%rax
}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 20          	sub    $0x20,%rsp
  801df0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801df7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801dfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dfd:	48 63 c8             	movslq %eax,%rcx
  801e00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e07:	48 98                	cltq   
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	49 89 c8             	mov    %rcx,%r8
  801e1a:	48 89 d1             	mov    %rdx,%rcx
  801e1d:	48 89 c2             	mov    %rax,%rdx
  801e20:	be 01 00 00 00       	mov    $0x1,%esi
  801e25:	bf 04 00 00 00       	mov    $0x4,%edi
  801e2a:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801e31:	00 00 00 
  801e34:	ff d0                	callq  *%rax
}
  801e36:	c9                   	leaveq 
  801e37:	c3                   	retq   

0000000000801e38 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e38:	55                   	push   %rbp
  801e39:	48 89 e5             	mov    %rsp,%rbp
  801e3c:	48 83 ec 30          	sub    $0x30,%rsp
  801e40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e47:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e4e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e55:	48 63 c8             	movslq %eax,%rcx
  801e58:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e5f:	48 63 f0             	movslq %eax,%rsi
  801e62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e69:	48 98                	cltq   
  801e6b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e6f:	49 89 f9             	mov    %rdi,%r9
  801e72:	49 89 f0             	mov    %rsi,%r8
  801e75:	48 89 d1             	mov    %rdx,%rcx
  801e78:	48 89 c2             	mov    %rax,%rdx
  801e7b:	be 01 00 00 00       	mov    $0x1,%esi
  801e80:	bf 05 00 00 00       	mov    $0x5,%edi
  801e85:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801e8c:	00 00 00 
  801e8f:	ff d0                	callq  *%rax
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 20          	sub    $0x20,%rsp
  801e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ea2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea9:	48 98                	cltq   
  801eab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eb2:	00 
  801eb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebf:	48 89 d1             	mov    %rdx,%rcx
  801ec2:	48 89 c2             	mov    %rax,%rdx
  801ec5:	be 01 00 00 00       	mov    $0x1,%esi
  801eca:	bf 06 00 00 00       	mov    $0x6,%edi
  801ecf:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax
}
  801edb:	c9                   	leaveq 
  801edc:	c3                   	retq   

0000000000801edd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801edd:	55                   	push   %rbp
  801ede:	48 89 e5             	mov    %rsp,%rbp
  801ee1:	48 83 ec 20          	sub    $0x20,%rsp
  801ee5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801eeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eee:	48 63 d0             	movslq %eax,%rdx
  801ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef4:	48 98                	cltq   
  801ef6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801efd:	00 
  801efe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f0a:	48 89 d1             	mov    %rdx,%rcx
  801f0d:	48 89 c2             	mov    %rax,%rdx
  801f10:	be 01 00 00 00       	mov    $0x1,%esi
  801f15:	bf 08 00 00 00       	mov    $0x8,%edi
  801f1a:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
}
  801f26:	c9                   	leaveq 
  801f27:	c3                   	retq   

0000000000801f28 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 83 ec 20          	sub    $0x20,%rsp
  801f30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3e:	48 98                	cltq   
  801f40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f47:	00 
  801f48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f54:	48 89 d1             	mov    %rdx,%rcx
  801f57:	48 89 c2             	mov    %rax,%rdx
  801f5a:	be 01 00 00 00       	mov    $0x1,%esi
  801f5f:	bf 09 00 00 00       	mov    $0x9,%edi
  801f64:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	callq  *%rax
}
  801f70:	c9                   	leaveq 
  801f71:	c3                   	retq   

0000000000801f72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f72:	55                   	push   %rbp
  801f73:	48 89 e5             	mov    %rsp,%rbp
  801f76:	48 83 ec 20          	sub    $0x20,%rsp
  801f7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f88:	48 98                	cltq   
  801f8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f91:	00 
  801f92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9e:	48 89 d1             	mov    %rdx,%rcx
  801fa1:	48 89 c2             	mov    %rax,%rdx
  801fa4:	be 01 00 00 00       	mov    $0x1,%esi
  801fa9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801fae:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801fb5:	00 00 00 
  801fb8:	ff d0                	callq  *%rax
}
  801fba:	c9                   	leaveq 
  801fbb:	c3                   	retq   

0000000000801fbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801fbc:	55                   	push   %rbp
  801fbd:	48 89 e5             	mov    %rsp,%rbp
  801fc0:	48 83 ec 30          	sub    $0x30,%rsp
  801fc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fcb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801fcf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801fd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fd5:	48 63 f0             	movslq %eax,%rsi
  801fd8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fdf:	48 98                	cltq   
  801fe1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fec:	00 
  801fed:	49 89 f1             	mov    %rsi,%r9
  801ff0:	49 89 c8             	mov    %rcx,%r8
  801ff3:	48 89 d1             	mov    %rdx,%rcx
  801ff6:	48 89 c2             	mov    %rax,%rdx
  801ff9:	be 00 00 00 00       	mov    $0x0,%esi
  801ffe:	bf 0c 00 00 00       	mov    $0xc,%edi
  802003:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
}
  80200f:	c9                   	leaveq 
  802010:	c3                   	retq   

0000000000802011 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802011:	55                   	push   %rbp
  802012:	48 89 e5             	mov    %rsp,%rbp
  802015:	48 83 ec 20          	sub    $0x20,%rsp
  802019:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80201d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802021:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802028:	00 
  802029:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802035:	b9 00 00 00 00       	mov    $0x0,%ecx
  80203a:	48 89 c2             	mov    %rax,%rdx
  80203d:	be 01 00 00 00       	mov    $0x1,%esi
  802042:	bf 0d 00 00 00       	mov    $0xd,%edi
  802047:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
}
  802053:	c9                   	leaveq 
  802054:	c3                   	retq   

0000000000802055 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802055:	55                   	push   %rbp
  802056:	48 89 e5             	mov    %rsp,%rbp
  802059:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80205d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802064:	00 
  802065:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80206b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802071:	b9 00 00 00 00       	mov    $0x0,%ecx
  802076:	ba 00 00 00 00       	mov    $0x0,%edx
  80207b:	be 00 00 00 00       	mov    $0x0,%esi
  802080:	bf 0e 00 00 00       	mov    $0xe,%edi
  802085:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80208c:	00 00 00 
  80208f:	ff d0                	callq  *%rax
}
  802091:	c9                   	leaveq 
  802092:	c3                   	retq   

0000000000802093 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802093:	55                   	push   %rbp
  802094:	48 89 e5             	mov    %rsp,%rbp
  802097:	48 83 ec 30          	sub    $0x30,%rsp
  80209b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80209e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020a2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020a5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020a9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020b0:	48 63 c8             	movslq %eax,%rcx
  8020b3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ba:	48 63 f0             	movslq %eax,%rsi
  8020bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c4:	48 98                	cltq   
  8020c6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020ca:	49 89 f9             	mov    %rdi,%r9
  8020cd:	49 89 f0             	mov    %rsi,%r8
  8020d0:	48 89 d1             	mov    %rdx,%rcx
  8020d3:	48 89 c2             	mov    %rax,%rdx
  8020d6:	be 00 00 00 00       	mov    $0x0,%esi
  8020db:	bf 0f 00 00 00       	mov    $0xf,%edi
  8020e0:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8020ec:	c9                   	leaveq 
  8020ed:	c3                   	retq   

00000000008020ee <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8020ee:	55                   	push   %rbp
  8020ef:	48 89 e5             	mov    %rsp,%rbp
  8020f2:	48 83 ec 20          	sub    $0x20,%rsp
  8020f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8020fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802106:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80210d:	00 
  80210e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802114:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211a:	48 89 d1             	mov    %rdx,%rcx
  80211d:	48 89 c2             	mov    %rax,%rdx
  802120:	be 00 00 00 00       	mov    $0x0,%esi
  802125:	bf 10 00 00 00       	mov    $0x10,%edi
  80212a:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  802131:	00 00 00 
  802134:	ff d0                	callq  *%rax
}
  802136:	c9                   	leaveq 
  802137:	c3                   	retq   

0000000000802138 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802138:	55                   	push   %rbp
  802139:	48 89 e5             	mov    %rsp,%rbp
  80213c:	48 83 ec 08          	sub    $0x8,%rsp
  802140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802144:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802148:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80214f:	ff ff ff 
  802152:	48 01 d0             	add    %rdx,%rax
  802155:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802159:	c9                   	leaveq 
  80215a:	c3                   	retq   

000000000080215b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80215b:	55                   	push   %rbp
  80215c:	48 89 e5             	mov    %rsp,%rbp
  80215f:	48 83 ec 08          	sub    $0x8,%rsp
  802163:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216b:	48 89 c7             	mov    %rax,%rdi
  80216e:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802180:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802184:	c9                   	leaveq 
  802185:	c3                   	retq   

0000000000802186 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802186:	55                   	push   %rbp
  802187:	48 89 e5             	mov    %rsp,%rbp
  80218a:	48 83 ec 18          	sub    $0x18,%rsp
  80218e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802199:	eb 6b                	jmp    802206 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80219b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219e:	48 98                	cltq   
  8021a0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021a6:	48 c1 e0 0c          	shl    $0xc,%rax
  8021aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b2:	48 89 c2             	mov    %rax,%rdx
  8021b5:	48 c1 ea 15          	shr    $0x15,%rdx
  8021b9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021c0:	01 00 00 
  8021c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c7:	83 e0 01             	and    $0x1,%eax
  8021ca:	48 85 c0             	test   %rax,%rax
  8021cd:	74 21                	je     8021f0 <fd_alloc+0x6a>
  8021cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d3:	48 89 c2             	mov    %rax,%rdx
  8021d6:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e1:	01 00 00 
  8021e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e8:	83 e0 01             	and    $0x1,%eax
  8021eb:	48 85 c0             	test   %rax,%rax
  8021ee:	75 12                	jne    802202 <fd_alloc+0x7c>
			*fd_store = fd;
  8021f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	eb 1a                	jmp    80221c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802202:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802206:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80220a:	7e 8f                	jle    80219b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802217:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80221c:	c9                   	leaveq 
  80221d:	c3                   	retq   

000000000080221e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80221e:	55                   	push   %rbp
  80221f:	48 89 e5             	mov    %rsp,%rbp
  802222:	48 83 ec 20          	sub    $0x20,%rsp
  802226:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802229:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80222d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802231:	78 06                	js     802239 <fd_lookup+0x1b>
  802233:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802237:	7e 07                	jle    802240 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223e:	eb 6c                	jmp    8022ac <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802240:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802243:	48 98                	cltq   
  802245:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80224b:	48 c1 e0 0c          	shl    $0xc,%rax
  80224f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802257:	48 89 c2             	mov    %rax,%rdx
  80225a:	48 c1 ea 15          	shr    $0x15,%rdx
  80225e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802265:	01 00 00 
  802268:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226c:	83 e0 01             	and    $0x1,%eax
  80226f:	48 85 c0             	test   %rax,%rax
  802272:	74 21                	je     802295 <fd_lookup+0x77>
  802274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802278:	48 89 c2             	mov    %rax,%rdx
  80227b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80227f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802286:	01 00 00 
  802289:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228d:	83 e0 01             	and    $0x1,%eax
  802290:	48 85 c0             	test   %rax,%rax
  802293:	75 07                	jne    80229c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80229a:	eb 10                	jmp    8022ac <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80229c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022a4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ac:	c9                   	leaveq 
  8022ad:	c3                   	retq   

00000000008022ae <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022ae:	55                   	push   %rbp
  8022af:	48 89 e5             	mov    %rsp,%rbp
  8022b2:	48 83 ec 30          	sub    $0x30,%rsp
  8022b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022ba:	89 f0                	mov    %esi,%eax
  8022bc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c3:	48 89 c7             	mov    %rax,%rdi
  8022c6:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
  8022d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d6:	48 89 d6             	mov    %rdx,%rsi
  8022d9:	89 c7                	mov    %eax,%edi
  8022db:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	callq  *%rax
  8022e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ee:	78 0a                	js     8022fa <fd_close+0x4c>
	    || fd != fd2)
  8022f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022f8:	74 12                	je     80230c <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022fa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022fe:	74 05                	je     802305 <fd_close+0x57>
  802300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802303:	eb 05                	jmp    80230a <fd_close+0x5c>
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	eb 69                	jmp    802375 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80230c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802310:	8b 00                	mov    (%rax),%eax
  802312:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802316:	48 89 d6             	mov    %rdx,%rsi
  802319:	89 c7                	mov    %eax,%edi
  80231b:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232e:	78 2a                	js     80235a <fd_close+0xac>
		if (dev->dev_close)
  802330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802334:	48 8b 40 20          	mov    0x20(%rax),%rax
  802338:	48 85 c0             	test   %rax,%rax
  80233b:	74 16                	je     802353 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80233d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802341:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802345:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802349:	48 89 c7             	mov    %rax,%rdi
  80234c:	ff d2                	callq  *%rdx
  80234e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802351:	eb 07                	jmp    80235a <fd_close+0xac>
		else
			r = 0;
  802353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80235a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235e:	48 89 c6             	mov    %rax,%rsi
  802361:	bf 00 00 00 00       	mov    $0x0,%edi
  802366:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  80236d:	00 00 00 
  802370:	ff d0                	callq  *%rax
	return r;
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802375:	c9                   	leaveq 
  802376:	c3                   	retq   

0000000000802377 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802377:	55                   	push   %rbp
  802378:	48 89 e5             	mov    %rsp,%rbp
  80237b:	48 83 ec 20          	sub    $0x20,%rsp
  80237f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802382:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80238d:	eb 41                	jmp    8023d0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80238f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802396:	00 00 00 
  802399:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80239c:	48 63 d2             	movslq %edx,%rdx
  80239f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a3:	8b 00                	mov    (%rax),%eax
  8023a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023a8:	75 22                	jne    8023cc <dev_lookup+0x55>
			*dev = devtab[i];
  8023aa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023b1:	00 00 00 
  8023b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023b7:	48 63 d2             	movslq %edx,%rdx
  8023ba:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	eb 60                	jmp    80242c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023d7:	00 00 00 
  8023da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023dd:	48 63 d2             	movslq %edx,%rdx
  8023e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e4:	48 85 c0             	test   %rax,%rax
  8023e7:	75 a6                	jne    80238f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023f0:	00 00 00 
  8023f3:	48 8b 00             	mov    (%rax),%rax
  8023f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	48 bf b8 47 80 00 00 	movabs $0x8047b8,%rdi
  802408:	00 00 00 
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
  802410:	48 b9 df 08 80 00 00 	movabs $0x8008df,%rcx
  802417:	00 00 00 
  80241a:	ff d1                	callq  *%rcx
	*dev = 0;
  80241c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802420:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <close>:

int
close(int fdnum)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 20          	sub    $0x20,%rsp
  802436:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802439:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802440:	48 89 d6             	mov    %rdx,%rsi
  802443:	89 c7                	mov    %eax,%edi
  802445:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  80244c:	00 00 00 
  80244f:	ff d0                	callq  *%rax
  802451:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802458:	79 05                	jns    80245f <close+0x31>
		return r;
  80245a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245d:	eb 18                	jmp    802477 <close+0x49>
	else
		return fd_close(fd, 1);
  80245f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802463:	be 01 00 00 00       	mov    $0x1,%esi
  802468:	48 89 c7             	mov    %rax,%rdi
  80246b:	48 b8 ae 22 80 00 00 	movabs $0x8022ae,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
}
  802477:	c9                   	leaveq 
  802478:	c3                   	retq   

0000000000802479 <close_all>:

void
close_all(void)
{
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802488:	eb 15                	jmp    80249f <close_all+0x26>
		close(i);
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248d:	89 c7                	mov    %eax,%edi
  80248f:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802496:	00 00 00 
  802499:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80249b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80249f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024a3:	7e e5                	jle    80248a <close_all+0x11>
		close(i);
}
  8024a5:	c9                   	leaveq 
  8024a6:	c3                   	retq   

00000000008024a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024a7:	55                   	push   %rbp
  8024a8:	48 89 e5             	mov    %rsp,%rbp
  8024ab:	48 83 ec 40          	sub    $0x40,%rsp
  8024af:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024b2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024b5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024bc:	48 89 d6             	mov    %rdx,%rsi
  8024bf:	89 c7                	mov    %eax,%edi
  8024c1:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax
  8024cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d4:	79 08                	jns    8024de <dup+0x37>
		return r;
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d9:	e9 70 01 00 00       	jmpq   80264e <dup+0x1a7>
	close(newfdnum);
  8024de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8024ea:	00 00 00 
  8024ed:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024f2:	48 98                	cltq   
  8024f4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024fa:	48 c1 e0 0c          	shl    $0xc,%rax
  8024fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802506:	48 89 c7             	mov    %rax,%rdi
  802509:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802510:	00 00 00 
  802513:	ff d0                	callq  *%rax
  802515:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251d:	48 89 c7             	mov    %rax,%rdi
  802520:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802534:	48 89 c2             	mov    %rax,%rdx
  802537:	48 c1 ea 15          	shr    $0x15,%rdx
  80253b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802542:	01 00 00 
  802545:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802549:	83 e0 01             	and    $0x1,%eax
  80254c:	84 c0                	test   %al,%al
  80254e:	74 71                	je     8025c1 <dup+0x11a>
  802550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802554:	48 89 c2             	mov    %rax,%rdx
  802557:	48 c1 ea 0c          	shr    $0xc,%rdx
  80255b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802562:	01 00 00 
  802565:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802569:	83 e0 01             	and    $0x1,%eax
  80256c:	84 c0                	test   %al,%al
  80256e:	74 51                	je     8025c1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802574:	48 89 c2             	mov    %rax,%rdx
  802577:	48 c1 ea 0c          	shr    $0xc,%rdx
  80257b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802582:	01 00 00 
  802585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802589:	89 c1                	mov    %eax,%ecx
  80258b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802591:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802599:	41 89 c8             	mov    %ecx,%r8d
  80259c:	48 89 d1             	mov    %rdx,%rcx
  80259f:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a4:	48 89 c6             	mov    %rax,%rsi
  8025a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ac:	48 b8 38 1e 80 00 00 	movabs $0x801e38,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bf:	78 56                	js     802617 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c5:	48 89 c2             	mov    %rax,%rdx
  8025c8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d3:	01 00 00 
  8025d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025da:	89 c1                	mov    %eax,%ecx
  8025dc:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8025e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ea:	41 89 c8             	mov    %ecx,%r8d
  8025ed:	48 89 d1             	mov    %rdx,%rcx
  8025f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f5:	48 89 c6             	mov    %rax,%rsi
  8025f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025fd:	48 b8 38 1e 80 00 00 	movabs $0x801e38,%rax
  802604:	00 00 00 
  802607:	ff d0                	callq  *%rax
  802609:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802610:	78 08                	js     80261a <dup+0x173>
		goto err;

	return newfdnum;
  802612:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802615:	eb 37                	jmp    80264e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802617:	90                   	nop
  802618:	eb 01                	jmp    80261b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80261a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80261b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261f:	48 89 c6             	mov    %rax,%rsi
  802622:	bf 00 00 00 00       	mov    $0x0,%edi
  802627:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802633:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802637:	48 89 c6             	mov    %rax,%rsi
  80263a:	bf 00 00 00 00       	mov    $0x0,%edi
  80263f:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  802646:	00 00 00 
  802649:	ff d0                	callq  *%rax
	return r;
  80264b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80264e:	c9                   	leaveq 
  80264f:	c3                   	retq   

0000000000802650 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802650:	55                   	push   %rbp
  802651:	48 89 e5             	mov    %rsp,%rbp
  802654:	48 83 ec 40          	sub    $0x40,%rsp
  802658:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80265b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80265f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802663:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802667:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80266a:	48 89 d6             	mov    %rdx,%rsi
  80266d:	89 c7                	mov    %eax,%edi
  80266f:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
  80267b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802682:	78 24                	js     8026a8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802688:	8b 00                	mov    (%rax),%eax
  80268a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80268e:	48 89 d6             	mov    %rdx,%rsi
  802691:	89 c7                	mov    %eax,%edi
  802693:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a6:	79 05                	jns    8026ad <read+0x5d>
		return r;
  8026a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ab:	eb 7a                	jmp    802727 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b1:	8b 40 08             	mov    0x8(%rax),%eax
  8026b4:	83 e0 03             	and    $0x3,%eax
  8026b7:	83 f8 01             	cmp    $0x1,%eax
  8026ba:	75 3a                	jne    8026f6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026c3:	00 00 00 
  8026c6:	48 8b 00             	mov    (%rax),%rax
  8026c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026d2:	89 c6                	mov    %eax,%esi
  8026d4:	48 bf d7 47 80 00 00 	movabs $0x8047d7,%rdi
  8026db:	00 00 00 
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	48 b9 df 08 80 00 00 	movabs $0x8008df,%rcx
  8026ea:	00 00 00 
  8026ed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026f4:	eb 31                	jmp    802727 <read+0xd7>
	}
	if (!dev->dev_read)
  8026f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026fe:	48 85 c0             	test   %rax,%rax
  802701:	75 07                	jne    80270a <read+0xba>
		return -E_NOT_SUPP;
  802703:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802708:	eb 1d                	jmp    802727 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80270a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802716:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80271a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80271e:	48 89 ce             	mov    %rcx,%rsi
  802721:	48 89 c7             	mov    %rax,%rdi
  802724:	41 ff d0             	callq  *%r8
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 30          	sub    $0x30,%rsp
  802731:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802734:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802738:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80273c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802743:	eb 46                	jmp    80278b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802745:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802748:	48 98                	cltq   
  80274a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80274e:	48 29 c2             	sub    %rax,%rdx
  802751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802754:	48 98                	cltq   
  802756:	48 89 c1             	mov    %rax,%rcx
  802759:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80275d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802760:	48 89 ce             	mov    %rcx,%rsi
  802763:	89 c7                	mov    %eax,%edi
  802765:	48 b8 50 26 80 00 00 	movabs $0x802650,%rax
  80276c:	00 00 00 
  80276f:	ff d0                	callq  *%rax
  802771:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802774:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802778:	79 05                	jns    80277f <readn+0x56>
			return m;
  80277a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80277d:	eb 1d                	jmp    80279c <readn+0x73>
		if (m == 0)
  80277f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802783:	74 13                	je     802798 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802785:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802788:	01 45 fc             	add    %eax,-0x4(%rbp)
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	48 98                	cltq   
  802790:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802794:	72 af                	jb     802745 <readn+0x1c>
  802796:	eb 01                	jmp    802799 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802798:	90                   	nop
	}
	return tot;
  802799:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80279c:	c9                   	leaveq 
  80279d:	c3                   	retq   

000000000080279e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80279e:	55                   	push   %rbp
  80279f:	48 89 e5             	mov    %rsp,%rbp
  8027a2:	48 83 ec 40          	sub    $0x40,%rsp
  8027a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d0:	78 24                	js     8027f6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d6:	8b 00                	mov    (%rax),%eax
  8027d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027dc:	48 89 d6             	mov    %rdx,%rsi
  8027df:	89 c7                	mov    %eax,%edi
  8027e1:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
  8027ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f4:	79 05                	jns    8027fb <write+0x5d>
		return r;
  8027f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f9:	eb 79                	jmp    802874 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	8b 40 08             	mov    0x8(%rax),%eax
  802802:	83 e0 03             	and    $0x3,%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	75 3a                	jne    802843 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802809:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802810:	00 00 00 
  802813:	48 8b 00             	mov    (%rax),%rax
  802816:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80281c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80281f:	89 c6                	mov    %eax,%esi
  802821:	48 bf f3 47 80 00 00 	movabs $0x8047f3,%rdi
  802828:	00 00 00 
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	48 b9 df 08 80 00 00 	movabs $0x8008df,%rcx
  802837:	00 00 00 
  80283a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80283c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802841:	eb 31                	jmp    802874 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802843:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802847:	48 8b 40 18          	mov    0x18(%rax),%rax
  80284b:	48 85 c0             	test   %rax,%rax
  80284e:	75 07                	jne    802857 <write+0xb9>
		return -E_NOT_SUPP;
  802850:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802855:	eb 1d                	jmp    802874 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80285f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802863:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802867:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80286b:	48 89 ce             	mov    %rcx,%rsi
  80286e:	48 89 c7             	mov    %rax,%rdi
  802871:	41 ff d0             	callq  *%r8
}
  802874:	c9                   	leaveq 
  802875:	c3                   	retq   

0000000000802876 <seek>:

int
seek(int fdnum, off_t offset)
{
  802876:	55                   	push   %rbp
  802877:	48 89 e5             	mov    %rsp,%rbp
  80287a:	48 83 ec 18          	sub    $0x18,%rsp
  80287e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802881:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802884:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802888:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80288b:	48 89 d6             	mov    %rdx,%rsi
  80288e:	89 c7                	mov    %eax,%edi
  802890:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
  80289c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a3:	79 05                	jns    8028aa <seek+0x34>
		return r;
  8028a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a8:	eb 0f                	jmp    8028b9 <seek+0x43>
	fd->fd_offset = offset;
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b9:	c9                   	leaveq 
  8028ba:	c3                   	retq   

00000000008028bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028bb:	55                   	push   %rbp
  8028bc:	48 89 e5             	mov    %rsp,%rbp
  8028bf:	48 83 ec 30          	sub    $0x30,%rsp
  8028c3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028d0:	48 89 d6             	mov    %rdx,%rsi
  8028d3:	89 c7                	mov    %eax,%edi
  8028d5:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
  8028e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e8:	78 24                	js     80290e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ee:	8b 00                	mov    (%rax),%eax
  8028f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f4:	48 89 d6             	mov    %rdx,%rsi
  8028f7:	89 c7                	mov    %eax,%edi
  8028f9:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802900:	00 00 00 
  802903:	ff d0                	callq  *%rax
  802905:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802908:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290c:	79 05                	jns    802913 <ftruncate+0x58>
		return r;
  80290e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802911:	eb 72                	jmp    802985 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	8b 40 08             	mov    0x8(%rax),%eax
  80291a:	83 e0 03             	and    $0x3,%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 3a                	jne    80295b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802921:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802928:	00 00 00 
  80292b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80292e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802934:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802937:	89 c6                	mov    %eax,%esi
  802939:	48 bf 10 48 80 00 00 	movabs $0x804810,%rdi
  802940:	00 00 00 
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	48 b9 df 08 80 00 00 	movabs $0x8008df,%rcx
  80294f:	00 00 00 
  802952:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802954:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802959:	eb 2a                	jmp    802985 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80295b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802963:	48 85 c0             	test   %rax,%rax
  802966:	75 07                	jne    80296f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802968:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296d:	eb 16                	jmp    802985 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80296f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802973:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80297e:	89 d6                	mov    %edx,%esi
  802980:	48 89 c7             	mov    %rax,%rdi
  802983:	ff d1                	callq  *%rcx
}
  802985:	c9                   	leaveq 
  802986:	c3                   	retq   

0000000000802987 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802987:	55                   	push   %rbp
  802988:	48 89 e5             	mov    %rsp,%rbp
  80298b:	48 83 ec 30          	sub    $0x30,%rsp
  80298f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802992:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802996:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299d:	48 89 d6             	mov    %rdx,%rsi
  8029a0:	89 c7                	mov    %eax,%edi
  8029a2:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
  8029ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b5:	78 24                	js     8029db <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bb:	8b 00                	mov    (%rax),%eax
  8029bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c1:	48 89 d6             	mov    %rdx,%rsi
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d9:	79 05                	jns    8029e0 <fstat+0x59>
		return r;
  8029db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029de:	eb 5e                	jmp    802a3e <fstat+0xb7>
	if (!dev->dev_stat)
  8029e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029e8:	48 85 c0             	test   %rax,%rax
  8029eb:	75 07                	jne    8029f4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8029ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029f2:	eb 4a                	jmp    802a3e <fstat+0xb7>
	stat->st_name[0] = 0;
  8029f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029ff:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a06:	00 00 00 
	stat->st_isdir = 0;
  802a09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a0d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a14:	00 00 00 
	stat->st_dev = dev;
  802a17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802a2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a32:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802a36:	48 89 d6             	mov    %rdx,%rsi
  802a39:	48 89 c7             	mov    %rax,%rdi
  802a3c:	ff d1                	callq  *%rcx
}
  802a3e:	c9                   	leaveq 
  802a3f:	c3                   	retq   

0000000000802a40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a40:	55                   	push   %rbp
  802a41:	48 89 e5             	mov    %rsp,%rbp
  802a44:	48 83 ec 20          	sub    $0x20,%rsp
  802a48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a54:	be 00 00 00 00       	mov    $0x0,%esi
  802a59:	48 89 c7             	mov    %rax,%rdi
  802a5c:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6f:	79 05                	jns    802a76 <stat+0x36>
		return fd;
  802a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a74:	eb 2f                	jmp    802aa5 <stat+0x65>
	r = fstat(fd, stat);
  802a76:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7d:	48 89 d6             	mov    %rdx,%rsi
  802a80:	89 c7                	mov    %eax,%edi
  802a82:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802a89:	00 00 00 
  802a8c:	ff d0                	callq  *%rax
  802a8e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a94:	89 c7                	mov    %eax,%edi
  802a96:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
	return r;
  802aa2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802aa5:	c9                   	leaveq 
  802aa6:	c3                   	retq   
	...

0000000000802aa8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802aa8:	55                   	push   %rbp
  802aa9:	48 89 e5             	mov    %rsp,%rbp
  802aac:	48 83 ec 10          	sub    $0x10,%rsp
  802ab0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ab3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ab7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802abe:	00 00 00 
  802ac1:	8b 00                	mov    (%rax),%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	75 1d                	jne    802ae4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ac7:	bf 01 00 00 00       	mov    $0x1,%edi
  802acc:	48 b8 2a 40 80 00 00 	movabs $0x80402a,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802adf:	00 00 00 
  802ae2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ae4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aeb:	00 00 00 
  802aee:	8b 00                	mov    (%rax),%eax
  802af0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802af3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802af8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802aff:	00 00 00 
  802b02:	89 c7                	mov    %eax,%edi
  802b04:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b14:	ba 00 00 00 00       	mov    $0x0,%edx
  802b19:	48 89 c6             	mov    %rax,%rsi
  802b1c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b21:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	48 83 ec 20          	sub    $0x20,%rsp
  802b37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b3b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b42:	48 89 c7             	mov    %rax,%rdi
  802b45:	48 b8 44 14 80 00 00 	movabs $0x801444,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b56:	7e 0a                	jle    802b62 <open+0x33>
		return -E_BAD_PATH;
  802b58:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b5d:	e9 a5 00 00 00       	jmpq   802c07 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802b62:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b66:	48 89 c7             	mov    %rax,%rdi
  802b69:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802b78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7c:	79 08                	jns    802b86 <open+0x57>
		return r;
  802b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b81:	e9 81 00 00 00       	jmpq   802c07 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802b86:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b8d:	00 00 00 
  802b90:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b93:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802b99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9d:	48 89 c6             	mov    %rax,%rsi
  802ba0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ba7:	00 00 00 
  802baa:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bba:	48 89 c6             	mov    %rax,%rsi
  802bbd:	bf 01 00 00 00       	mov    $0x1,%edi
  802bc2:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
  802bce:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd5:	79 1d                	jns    802bf4 <open+0xc5>
		fd_close(new_fd, 0);
  802bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdb:	be 00 00 00 00       	mov    $0x0,%esi
  802be0:	48 89 c7             	mov    %rax,%rdi
  802be3:	48 b8 ae 22 80 00 00 	movabs $0x8022ae,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
		return r;	
  802bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf2:	eb 13                	jmp    802c07 <open+0xd8>
	}
	return fd2num(new_fd);
  802bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf8:	48 89 c7             	mov    %rax,%rdi
  802bfb:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
}
  802c07:	c9                   	leaveq 
  802c08:	c3                   	retq   

0000000000802c09 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c09:	55                   	push   %rbp
  802c0a:	48 89 e5             	mov    %rsp,%rbp
  802c0d:	48 83 ec 10          	sub    $0x10,%rsp
  802c11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c19:	8b 50 0c             	mov    0xc(%rax),%edx
  802c1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c23:	00 00 00 
  802c26:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c28:	be 00 00 00 00       	mov    $0x0,%esi
  802c2d:	bf 06 00 00 00       	mov    $0x6,%edi
  802c32:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  802c39:	00 00 00 
  802c3c:	ff d0                	callq  *%rax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 30          	sub    $0x30,%rsp
  802c48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c58:	8b 50 0c             	mov    0xc(%rax),%edx
  802c5b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c62:	00 00 00 
  802c65:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c67:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c6e:	00 00 00 
  802c71:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c75:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802c79:	be 00 00 00 00       	mov    $0x0,%esi
  802c7e:	bf 03 00 00 00       	mov    $0x3,%edi
  802c83:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c96:	7e 23                	jle    802cbb <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9b:	48 63 d0             	movslq %eax,%rdx
  802c9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ca9:	00 00 00 
  802cac:	48 89 c7             	mov    %rax,%rdi
  802caf:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
	}
	return nbytes;
  802cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cbe:	c9                   	leaveq 
  802cbf:	c3                   	retq   

0000000000802cc0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802cc0:	55                   	push   %rbp
  802cc1:	48 89 e5             	mov    %rsp,%rbp
  802cc4:	48 83 ec 20          	sub    $0x20,%rsp
  802cc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ccc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd4:	8b 50 0c             	mov    0xc(%rax),%edx
  802cd7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cde:	00 00 00 
  802ce1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ce3:	be 00 00 00 00       	mov    $0x0,%esi
  802ce8:	bf 05 00 00 00       	mov    $0x5,%edi
  802ced:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
  802cf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d00:	79 05                	jns    802d07 <devfile_stat+0x47>
		return r;
  802d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d05:	eb 56                	jmp    802d5d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d0b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d12:	00 00 00 
  802d15:	48 89 c7             	mov    %rax,%rdi
  802d18:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d24:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d2b:	00 00 00 
  802d2e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d38:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d3e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d45:	00 00 00 
  802d48:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d52:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5d:	c9                   	leaveq 
  802d5e:	c3                   	retq   
	...

0000000000802d60 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d60:	55                   	push   %rbp
  802d61:	48 89 e5             	mov    %rsp,%rbp
  802d64:	48 83 ec 20          	sub    $0x20,%rsp
  802d68:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d6b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d72:	48 89 d6             	mov    %rdx,%rsi
  802d75:	89 c7                	mov    %eax,%edi
  802d77:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	79 05                	jns    802d91 <fd2sockid+0x31>
		return r;
  802d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8f:	eb 24                	jmp    802db5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d95:	8b 10                	mov    (%rax),%edx
  802d97:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d9e:	00 00 00 
  802da1:	8b 00                	mov    (%rax),%eax
  802da3:	39 c2                	cmp    %eax,%edx
  802da5:	74 07                	je     802dae <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802da7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dac:	eb 07                	jmp    802db5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802db5:	c9                   	leaveq 
  802db6:	c3                   	retq   

0000000000802db7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802db7:	55                   	push   %rbp
  802db8:	48 89 e5             	mov    %rsp,%rbp
  802dbb:	48 83 ec 20          	sub    $0x20,%rsp
  802dbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802dc2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dc6:	48 89 c7             	mov    %rax,%rdi
  802dc9:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
  802dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddc:	78 26                	js     802e04 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de2:	ba 07 04 00 00       	mov    $0x407,%edx
  802de7:	48 89 c6             	mov    %rax,%rsi
  802dea:	bf 00 00 00 00       	mov    $0x0,%edi
  802def:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e02:	79 16                	jns    802e1a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 c4 32 80 00 00 	movabs $0x8032c4,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
		return r;
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	eb 3a                	jmp    802e54 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e25:	00 00 00 
  802e28:	8b 12                	mov    (%rdx),%edx
  802e2a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e3e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e45:	48 89 c7             	mov    %rax,%rdi
  802e48:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
}
  802e54:	c9                   	leaveq 
  802e55:	c3                   	retq   

0000000000802e56 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e56:	55                   	push   %rbp
  802e57:	48 89 e5             	mov    %rsp,%rbp
  802e5a:	48 83 ec 30          	sub    $0x30,%rsp
  802e5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e6c:	89 c7                	mov    %eax,%edi
  802e6e:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e81:	79 05                	jns    802e88 <accept+0x32>
		return r;
  802e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e86:	eb 3b                	jmp    802ec3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e88:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e93:	48 89 ce             	mov    %rcx,%rsi
  802e96:	89 c7                	mov    %eax,%edi
  802e98:	48 b8 a1 31 80 00 00 	movabs $0x8031a1,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
  802ea4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eab:	79 05                	jns    802eb2 <accept+0x5c>
		return r;
  802ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb0:	eb 11                	jmp    802ec3 <accept+0x6d>
	return alloc_sockfd(r);
  802eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb5:	89 c7                	mov    %eax,%edi
  802eb7:	48 b8 b7 2d 80 00 00 	movabs $0x802db7,%rax
  802ebe:	00 00 00 
  802ec1:	ff d0                	callq  *%rax
}
  802ec3:	c9                   	leaveq 
  802ec4:	c3                   	retq   

0000000000802ec5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ec5:	55                   	push   %rbp
  802ec6:	48 89 e5             	mov    %rsp,%rbp
  802ec9:	48 83 ec 20          	sub    $0x20,%rsp
  802ecd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ed0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ed4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ed7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eef:	79 05                	jns    802ef6 <bind+0x31>
		return r;
  802ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef4:	eb 1b                	jmp    802f11 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ef6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ef9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f00:	48 89 ce             	mov    %rcx,%rsi
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 20 32 80 00 00 	movabs $0x803220,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
}
  802f11:	c9                   	leaveq 
  802f12:	c3                   	retq   

0000000000802f13 <shutdown>:

int
shutdown(int s, int how)
{
  802f13:	55                   	push   %rbp
  802f14:	48 89 e5             	mov    %rsp,%rbp
  802f17:	48 83 ec 20          	sub    $0x20,%rsp
  802f1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f1e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f39:	79 05                	jns    802f40 <shutdown+0x2d>
		return r;
  802f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3e:	eb 16                	jmp    802f56 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f40:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f46:	89 d6                	mov    %edx,%esi
  802f48:	89 c7                	mov    %eax,%edi
  802f4a:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
}
  802f56:	c9                   	leaveq 
  802f57:	c3                   	retq   

0000000000802f58 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f58:	55                   	push   %rbp
  802f59:	48 89 e5             	mov    %rsp,%rbp
  802f5c:	48 83 ec 10          	sub    $0x10,%rsp
  802f60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	83 f8 01             	cmp    $0x1,%eax
  802f7a:	75 17                	jne    802f93 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f80:	8b 40 0c             	mov    0xc(%rax),%eax
  802f83:	89 c7                	mov    %eax,%edi
  802f85:	48 b8 c4 32 80 00 00 	movabs $0x8032c4,%rax
  802f8c:	00 00 00 
  802f8f:	ff d0                	callq  *%rax
  802f91:	eb 05                	jmp    802f98 <devsock_close+0x40>
	else
		return 0;
  802f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f98:	c9                   	leaveq 
  802f99:	c3                   	retq   

0000000000802f9a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f9a:	55                   	push   %rbp
  802f9b:	48 89 e5             	mov    %rsp,%rbp
  802f9e:	48 83 ec 20          	sub    $0x20,%rsp
  802fa2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fa5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802faf:	89 c7                	mov    %eax,%edi
  802fb1:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802fb8:	00 00 00 
  802fbb:	ff d0                	callq  *%rax
  802fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc4:	79 05                	jns    802fcb <connect+0x31>
		return r;
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc9:	eb 1b                	jmp    802fe6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fcb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd5:	48 89 ce             	mov    %rcx,%rsi
  802fd8:	89 c7                	mov    %eax,%edi
  802fda:	48 b8 f1 32 80 00 00 	movabs $0x8032f1,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
}
  802fe6:	c9                   	leaveq 
  802fe7:	c3                   	retq   

0000000000802fe8 <listen>:

int
listen(int s, int backlog)
{
  802fe8:	55                   	push   %rbp
  802fe9:	48 89 e5             	mov    %rsp,%rbp
  802fec:	48 83 ec 20          	sub    $0x20,%rsp
  802ff0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ff3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ff6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff9:	89 c7                	mov    %eax,%edi
  802ffb:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
  803007:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300e:	79 05                	jns    803015 <listen+0x2d>
		return r;
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803013:	eb 16                	jmp    80302b <listen+0x43>
	return nsipc_listen(r, backlog);
  803015:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803018:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301b:	89 d6                	mov    %edx,%esi
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 20          	sub    $0x20,%rsp
  803035:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803039:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80303d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803045:	89 c2                	mov    %eax,%edx
  803047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304b:	8b 40 0c             	mov    0xc(%rax),%eax
  80304e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803052:	b9 00 00 00 00       	mov    $0x0,%ecx
  803057:	89 c7                	mov    %eax,%edi
  803059:	48 b8 95 33 80 00 00 	movabs $0x803395,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 20          	sub    $0x20,%rsp
  80306f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803073:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803077:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80307b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307f:	89 c2                	mov    %eax,%edx
  803081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803085:	8b 40 0c             	mov    0xc(%rax),%eax
  803088:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80308c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 61 34 80 00 00 	movabs $0x803461,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
}
  80309f:	c9                   	leaveq 
  8030a0:	c3                   	retq   

00000000008030a1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030a1:	55                   	push   %rbp
  8030a2:	48 89 e5             	mov    %rsp,%rbp
  8030a5:	48 83 ec 10          	sub    $0x10,%rsp
  8030a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b5:	48 be 3b 48 80 00 00 	movabs $0x80483b,%rsi
  8030bc:	00 00 00 
  8030bf:	48 89 c7             	mov    %rax,%rdi
  8030c2:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
	return 0;
  8030ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d3:	c9                   	leaveq 
  8030d4:	c3                   	retq   

00000000008030d5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8030d5:	55                   	push   %rbp
  8030d6:	48 89 e5             	mov    %rsp,%rbp
  8030d9:	48 83 ec 20          	sub    $0x20,%rsp
  8030dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030e3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030e6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030e9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ef:	89 ce                	mov    %ecx,%esi
  8030f1:	89 c7                	mov    %eax,%edi
  8030f3:	48 b8 19 35 80 00 00 	movabs $0x803519,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803106:	79 05                	jns    80310d <socket+0x38>
		return r;
  803108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310b:	eb 11                	jmp    80311e <socket+0x49>
	return alloc_sockfd(r);
  80310d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 b7 2d 80 00 00 	movabs $0x802db7,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
}
  80311e:	c9                   	leaveq 
  80311f:	c3                   	retq   

0000000000803120 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803120:	55                   	push   %rbp
  803121:	48 89 e5             	mov    %rsp,%rbp
  803124:	48 83 ec 10          	sub    $0x10,%rsp
  803128:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80312b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803132:	00 00 00 
  803135:	8b 00                	mov    (%rax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	75 1d                	jne    803158 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80313b:	bf 02 00 00 00       	mov    $0x2,%edi
  803140:	48 b8 2a 40 80 00 00 	movabs $0x80402a,%rax
  803147:	00 00 00 
  80314a:	ff d0                	callq  *%rax
  80314c:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803153:	00 00 00 
  803156:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803158:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80315f:	00 00 00 
  803162:	8b 00                	mov    (%rax),%eax
  803164:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803167:	b9 07 00 00 00       	mov    $0x7,%ecx
  80316c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803173:	00 00 00 
  803176:	89 c7                	mov    %eax,%edi
  803178:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803184:	ba 00 00 00 00       	mov    $0x0,%edx
  803189:	be 00 00 00 00       	mov    $0x0,%esi
  80318e:	bf 00 00 00 00       	mov    $0x0,%edi
  803193:	48 b8 94 3e 80 00 00 	movabs $0x803e94,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 30          	sub    $0x30,%rsp
  8031a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bb:	00 00 00 
  8031be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031c1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8031c8:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  8031cf:	00 00 00 
  8031d2:	ff d0                	callq  *%rax
  8031d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031db:	78 3e                	js     80321b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e4:	00 00 00 
  8031e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8031eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ef:	8b 40 10             	mov    0x10(%rax),%eax
  8031f2:	89 c2                	mov    %eax,%edx
  8031f4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031fc:	48 89 ce             	mov    %rcx,%rsi
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80320e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803212:	8b 50 10             	mov    0x10(%rax),%edx
  803215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803219:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80321b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80321e:	c9                   	leaveq 
  80321f:	c3                   	retq   

0000000000803220 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803220:	55                   	push   %rbp
  803221:	48 89 e5             	mov    %rsp,%rbp
  803224:	48 83 ec 10          	sub    $0x10,%rsp
  803228:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80322b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80322f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803232:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803239:	00 00 00 
  80323c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80323f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803241:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803248:	48 89 c6             	mov    %rax,%rsi
  80324b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803252:	00 00 00 
  803255:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803261:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803268:	00 00 00 
  80326b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80326e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803271:	bf 02 00 00 00       	mov    $0x2,%edi
  803276:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
}
  803282:	c9                   	leaveq 
  803283:	c3                   	retq   

0000000000803284 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 10          	sub    $0x10,%rsp
  80328c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80328f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803292:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803299:	00 00 00 
  80329c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80329f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a8:	00 00 00 
  8032ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032b1:	bf 03 00 00 00       	mov    $0x3,%edi
  8032b6:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
}
  8032c2:	c9                   	leaveq 
  8032c3:	c3                   	retq   

00000000008032c4 <nsipc_close>:

int
nsipc_close(int s)
{
  8032c4:	55                   	push   %rbp
  8032c5:	48 89 e5             	mov    %rsp,%rbp
  8032c8:	48 83 ec 10          	sub    $0x10,%rsp
  8032cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d6:	00 00 00 
  8032d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032dc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032de:	bf 04 00 00 00       	mov    $0x4,%edi
  8032e3:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
}
  8032ef:	c9                   	leaveq 
  8032f0:	c3                   	retq   

00000000008032f1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032f1:	55                   	push   %rbp
  8032f2:	48 89 e5             	mov    %rsp,%rbp
  8032f5:	48 83 ec 10          	sub    $0x10,%rsp
  8032f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803300:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803303:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80330a:	00 00 00 
  80330d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803310:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803312:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	48 89 c6             	mov    %rax,%rsi
  80331c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803323:	00 00 00 
  803326:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803332:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803339:	00 00 00 
  80333c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80333f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803342:	bf 05 00 00 00       	mov    $0x5,%edi
  803347:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
}
  803353:	c9                   	leaveq 
  803354:	c3                   	retq   

0000000000803355 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803355:	55                   	push   %rbp
  803356:	48 89 e5             	mov    %rsp,%rbp
  803359:	48 83 ec 10          	sub    $0x10,%rsp
  80335d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803360:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803363:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336a:	00 00 00 
  80336d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803370:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803372:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803379:	00 00 00 
  80337c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80337f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803382:	bf 06 00 00 00       	mov    $0x6,%edi
  803387:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
}
  803393:	c9                   	leaveq 
  803394:	c3                   	retq   

0000000000803395 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803395:	55                   	push   %rbp
  803396:	48 89 e5             	mov    %rsp,%rbp
  803399:	48 83 ec 30          	sub    $0x30,%rsp
  80339d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033a7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b1:	00 00 00 
  8033b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033b7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c0:	00 00 00 
  8033c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033c6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d0:	00 00 00 
  8033d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033d6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033d9:	bf 07 00 00 00       	mov    $0x7,%edi
  8033de:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f1:	78 69                	js     80345c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033f3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033fa:	7f 08                	jg     803404 <nsipc_recv+0x6f>
  8033fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ff:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803402:	7e 35                	jle    803439 <nsipc_recv+0xa4>
  803404:	48 b9 42 48 80 00 00 	movabs $0x804842,%rcx
  80340b:	00 00 00 
  80340e:	48 ba 57 48 80 00 00 	movabs $0x804857,%rdx
  803415:	00 00 00 
  803418:	be 61 00 00 00       	mov    $0x61,%esi
  80341d:	48 bf 6c 48 80 00 00 	movabs $0x80486c,%rdi
  803424:	00 00 00 
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	49 b8 a4 06 80 00 00 	movabs $0x8006a4,%r8
  803433:	00 00 00 
  803436:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343c:	48 63 d0             	movslq %eax,%rdx
  80343f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803443:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80344a:	00 00 00 
  80344d:	48 89 c7             	mov    %rax,%rdi
  803450:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
	}

	return r;
  80345c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80345f:	c9                   	leaveq 
  803460:	c3                   	retq   

0000000000803461 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803461:	55                   	push   %rbp
  803462:	48 89 e5             	mov    %rsp,%rbp
  803465:	48 83 ec 20          	sub    $0x20,%rsp
  803469:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80346c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803470:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803473:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803476:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347d:	00 00 00 
  803480:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803483:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803485:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80348c:	7e 35                	jle    8034c3 <nsipc_send+0x62>
  80348e:	48 b9 78 48 80 00 00 	movabs $0x804878,%rcx
  803495:	00 00 00 
  803498:	48 ba 57 48 80 00 00 	movabs $0x804857,%rdx
  80349f:	00 00 00 
  8034a2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8034a7:	48 bf 6c 48 80 00 00 	movabs $0x80486c,%rdi
  8034ae:	00 00 00 
  8034b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b6:	49 b8 a4 06 80 00 00 	movabs $0x8006a4,%r8
  8034bd:	00 00 00 
  8034c0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c6:	48 63 d0             	movslq %eax,%rdx
  8034c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cd:	48 89 c6             	mov    %rax,%rsi
  8034d0:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034d7:	00 00 00 
  8034da:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  8034e1:	00 00 00 
  8034e4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fd:	00 00 00 
  803500:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803503:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803506:	bf 08 00 00 00       	mov    $0x8,%edi
  80350b:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  803512:	00 00 00 
  803515:	ff d0                	callq  *%rax
}
  803517:	c9                   	leaveq 
  803518:	c3                   	retq   

0000000000803519 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803519:	55                   	push   %rbp
  80351a:	48 89 e5             	mov    %rsp,%rbp
  80351d:	48 83 ec 10          	sub    $0x10,%rsp
  803521:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803524:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803527:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80352a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803531:	00 00 00 
  803534:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803537:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803539:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803540:	00 00 00 
  803543:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803546:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803549:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803550:	00 00 00 
  803553:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803556:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803559:	bf 09 00 00 00       	mov    $0x9,%edi
  80355e:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  803565:	00 00 00 
  803568:	ff d0                	callq  *%rax
}
  80356a:	c9                   	leaveq 
  80356b:	c3                   	retq   

000000000080356c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80356c:	55                   	push   %rbp
  80356d:	48 89 e5             	mov    %rsp,%rbp
  803570:	53                   	push   %rbx
  803571:	48 83 ec 38          	sub    $0x38,%rsp
  803575:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803579:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80357d:	48 89 c7             	mov    %rax,%rdi
  803580:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80358f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803593:	0f 88 bf 01 00 00    	js     803758 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359d:	ba 07 04 00 00       	mov    $0x407,%edx
  8035a2:	48 89 c6             	mov    %rax,%rsi
  8035a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8035aa:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8035b1:	00 00 00 
  8035b4:	ff d0                	callq  *%rax
  8035b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035bd:	0f 88 95 01 00 00    	js     803758 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035c7:	48 89 c7             	mov    %rax,%rdi
  8035ca:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
  8035d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035dd:	0f 88 5d 01 00 00    	js     803740 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8035ec:	48 89 c6             	mov    %rax,%rsi
  8035ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f4:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803603:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803607:	0f 88 33 01 00 00    	js     803740 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80360d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803611:	48 89 c7             	mov    %rax,%rdi
  803614:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
  803620:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803628:	ba 07 04 00 00       	mov    $0x407,%edx
  80362d:	48 89 c6             	mov    %rax,%rsi
  803630:	bf 00 00 00 00       	mov    $0x0,%edi
  803635:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
  803641:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803644:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803648:	0f 88 d9 00 00 00    	js     803727 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80364e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803652:	48 89 c7             	mov    %rax,%rdi
  803655:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
  803661:	48 89 c2             	mov    %rax,%rdx
  803664:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803668:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80366e:	48 89 d1             	mov    %rdx,%rcx
  803671:	ba 00 00 00 00       	mov    $0x0,%edx
  803676:	48 89 c6             	mov    %rax,%rsi
  803679:	bf 00 00 00 00       	mov    $0x0,%edi
  80367e:	48 b8 38 1e 80 00 00 	movabs $0x801e38,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
  80368a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80368d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803691:	78 79                	js     80370c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803697:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80369e:	00 00 00 
  8036a1:	8b 12                	mov    (%rdx),%edx
  8036a3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036bb:	00 00 00 
  8036be:	8b 12                	mov    (%rdx),%edx
  8036c0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d1:	48 89 c7             	mov    %rax,%rdi
  8036d4:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
  8036e0:	89 c2                	mov    %eax,%edx
  8036e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036e6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036ec:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f4:	48 89 c7             	mov    %rax,%rdi
  8036f7:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  8036fe:	00 00 00 
  803701:	ff d0                	callq  *%rax
  803703:	89 03                	mov    %eax,(%rbx)
	return 0;
  803705:	b8 00 00 00 00       	mov    $0x0,%eax
  80370a:	eb 4f                	jmp    80375b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80370c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80370d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803711:	48 89 c6             	mov    %rax,%rsi
  803714:	bf 00 00 00 00       	mov    $0x0,%edi
  803719:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
  803725:	eb 01                	jmp    803728 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803727:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372c:	48 89 c6             	mov    %rax,%rsi
  80372f:	bf 00 00 00 00       	mov    $0x0,%edi
  803734:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803744:	48 89 c6             	mov    %rax,%rsi
  803747:	bf 00 00 00 00       	mov    $0x0,%edi
  80374c:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
err:
	return r;
  803758:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80375b:	48 83 c4 38          	add    $0x38,%rsp
  80375f:	5b                   	pop    %rbx
  803760:	5d                   	pop    %rbp
  803761:	c3                   	retq   

0000000000803762 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803762:	55                   	push   %rbp
  803763:	48 89 e5             	mov    %rsp,%rbp
  803766:	53                   	push   %rbx
  803767:	48 83 ec 28          	sub    $0x28,%rsp
  80376b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80376f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803773:	eb 01                	jmp    803776 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803775:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803776:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80377d:	00 00 00 
  803780:	48 8b 00             	mov    (%rax),%rax
  803783:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803789:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80378c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803790:	48 89 c7             	mov    %rax,%rdi
  803793:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
  80379f:	89 c3                	mov    %eax,%ebx
  8037a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a5:	48 89 c7             	mov    %rax,%rdi
  8037a8:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	39 c3                	cmp    %eax,%ebx
  8037b6:	0f 94 c0             	sete   %al
  8037b9:	0f b6 c0             	movzbl %al,%eax
  8037bc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037c6:	00 00 00 
  8037c9:	48 8b 00             	mov    (%rax),%rax
  8037cc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037d2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037d8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037db:	75 0a                	jne    8037e7 <_pipeisclosed+0x85>
			return ret;
  8037dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8037e0:	48 83 c4 28          	add    $0x28,%rsp
  8037e4:	5b                   	pop    %rbx
  8037e5:	5d                   	pop    %rbp
  8037e6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8037e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ea:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037ed:	74 86                	je     803775 <_pipeisclosed+0x13>
  8037ef:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8037f3:	75 80                	jne    803775 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8037f5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037fc:	00 00 00 
  8037ff:	48 8b 00             	mov    (%rax),%rax
  803802:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803808:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80380b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380e:	89 c6                	mov    %eax,%esi
  803810:	48 bf 89 48 80 00 00 	movabs $0x804889,%rdi
  803817:	00 00 00 
  80381a:	b8 00 00 00 00       	mov    $0x0,%eax
  80381f:	49 b8 df 08 80 00 00 	movabs $0x8008df,%r8
  803826:	00 00 00 
  803829:	41 ff d0             	callq  *%r8
	}
  80382c:	e9 44 ff ff ff       	jmpq   803775 <_pipeisclosed+0x13>

0000000000803831 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803831:	55                   	push   %rbp
  803832:	48 89 e5             	mov    %rsp,%rbp
  803835:	48 83 ec 30          	sub    $0x30,%rsp
  803839:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80383c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803840:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803843:	48 89 d6             	mov    %rdx,%rsi
  803846:	89 c7                	mov    %eax,%edi
  803848:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  80384f:	00 00 00 
  803852:	ff d0                	callq  *%rax
  803854:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80385b:	79 05                	jns    803862 <pipeisclosed+0x31>
		return r;
  80385d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803860:	eb 31                	jmp    803893 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803866:	48 89 c7             	mov    %rax,%rdi
  803869:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
  803875:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803881:	48 89 d6             	mov    %rdx,%rsi
  803884:	48 89 c7             	mov    %rax,%rdi
  803887:	48 b8 62 37 80 00 00 	movabs $0x803762,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
}
  803893:	c9                   	leaveq 
  803894:	c3                   	retq   

0000000000803895 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803895:	55                   	push   %rbp
  803896:	48 89 e5             	mov    %rsp,%rbp
  803899:	48 83 ec 40          	sub    $0x40,%rsp
  80389d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ad:	48 89 c7             	mov    %rax,%rdi
  8038b0:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038c8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038cf:	00 
  8038d0:	e9 97 00 00 00       	jmpq   80396c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038d5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038da:	74 09                	je     8038e5 <devpipe_read+0x50>
				return i;
  8038dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e0:	e9 95 00 00 00       	jmpq   80397a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ed:	48 89 d6             	mov    %rdx,%rsi
  8038f0:	48 89 c7             	mov    %rax,%rdi
  8038f3:	48 b8 62 37 80 00 00 	movabs $0x803762,%rax
  8038fa:	00 00 00 
  8038fd:	ff d0                	callq  *%rax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	74 07                	je     80390a <devpipe_read+0x75>
				return 0;
  803903:	b8 00 00 00 00       	mov    $0x0,%eax
  803908:	eb 70                	jmp    80397a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80390a:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
  803916:	eb 01                	jmp    803919 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803918:	90                   	nop
  803919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391d:	8b 10                	mov    (%rax),%edx
  80391f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803923:	8b 40 04             	mov    0x4(%rax),%eax
  803926:	39 c2                	cmp    %eax,%edx
  803928:	74 ab                	je     8038d5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80392a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803932:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393a:	8b 00                	mov    (%rax),%eax
  80393c:	89 c2                	mov    %eax,%edx
  80393e:	c1 fa 1f             	sar    $0x1f,%edx
  803941:	c1 ea 1b             	shr    $0x1b,%edx
  803944:	01 d0                	add    %edx,%eax
  803946:	83 e0 1f             	and    $0x1f,%eax
  803949:	29 d0                	sub    %edx,%eax
  80394b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80394f:	48 98                	cltq   
  803951:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803956:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	8b 00                	mov    (%rax),%eax
  80395e:	8d 50 01             	lea    0x1(%rax),%edx
  803961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803965:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803967:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80396c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803970:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803974:	72 a2                	jb     803918 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803976:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80397a:	c9                   	leaveq 
  80397b:	c3                   	retq   

000000000080397c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80397c:	55                   	push   %rbp
  80397d:	48 89 e5             	mov    %rsp,%rbp
  803980:	48 83 ec 40          	sub    $0x40,%rsp
  803984:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803988:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80398c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803994:	48 89 c7             	mov    %rax,%rdi
  803997:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
  8039a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039af:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039b6:	00 
  8039b7:	e9 93 00 00 00       	jmpq   803a4f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c4:	48 89 d6             	mov    %rdx,%rsi
  8039c7:	48 89 c7             	mov    %rax,%rdi
  8039ca:	48 b8 62 37 80 00 00 	movabs $0x803762,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	85 c0                	test   %eax,%eax
  8039d8:	74 07                	je     8039e1 <devpipe_write+0x65>
				return 0;
  8039da:	b8 00 00 00 00       	mov    $0x0,%eax
  8039df:	eb 7c                	jmp    803a5d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039e1:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
  8039ed:	eb 01                	jmp    8039f0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039ef:	90                   	nop
  8039f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f4:	8b 40 04             	mov    0x4(%rax),%eax
  8039f7:	48 63 d0             	movslq %eax,%rdx
  8039fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fe:	8b 00                	mov    (%rax),%eax
  803a00:	48 98                	cltq   
  803a02:	48 83 c0 20          	add    $0x20,%rax
  803a06:	48 39 c2             	cmp    %rax,%rdx
  803a09:	73 b1                	jae    8039bc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0f:	8b 40 04             	mov    0x4(%rax),%eax
  803a12:	89 c2                	mov    %eax,%edx
  803a14:	c1 fa 1f             	sar    $0x1f,%edx
  803a17:	c1 ea 1b             	shr    $0x1b,%edx
  803a1a:	01 d0                	add    %edx,%eax
  803a1c:	83 e0 1f             	and    $0x1f,%eax
  803a1f:	29 d0                	sub    %edx,%eax
  803a21:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a29:	48 01 ca             	add    %rcx,%rdx
  803a2c:	0f b6 0a             	movzbl (%rdx),%ecx
  803a2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a33:	48 98                	cltq   
  803a35:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3d:	8b 40 04             	mov    0x4(%rax),%eax
  803a40:	8d 50 01             	lea    0x1(%rax),%edx
  803a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a47:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a4a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a53:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a57:	72 96                	jb     8039ef <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a5d:	c9                   	leaveq 
  803a5e:	c3                   	retq   

0000000000803a5f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a5f:	55                   	push   %rbp
  803a60:	48 89 e5             	mov    %rsp,%rbp
  803a63:	48 83 ec 20          	sub    $0x20,%rsp
  803a67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a73:	48 89 c7             	mov    %rax,%rdi
  803a76:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  803a7d:	00 00 00 
  803a80:	ff d0                	callq  *%rax
  803a82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a8a:	48 be 9c 48 80 00 00 	movabs $0x80489c,%rsi
  803a91:	00 00 00 
  803a94:	48 89 c7             	mov    %rax,%rdi
  803a97:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803aa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa7:	8b 50 04             	mov    0x4(%rax),%edx
  803aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aae:	8b 00                	mov    (%rax),%eax
  803ab0:	29 c2                	sub    %eax,%edx
  803ab2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803abc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ac0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ac7:	00 00 00 
	stat->st_dev = &devpipe;
  803aca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ace:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ad5:	00 00 00 
  803ad8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ae4:	c9                   	leaveq 
  803ae5:	c3                   	retq   

0000000000803ae6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ae6:	55                   	push   %rbp
  803ae7:	48 89 e5             	mov    %rsp,%rbp
  803aea:	48 83 ec 10          	sub    $0x10,%rsp
  803aee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803af2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af6:	48 89 c6             	mov    %rax,%rsi
  803af9:	bf 00 00 00 00       	mov    $0x0,%edi
  803afe:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b0e:	48 89 c7             	mov    %rax,%rdi
  803b11:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  803b18:	00 00 00 
  803b1b:	ff d0                	callq  *%rax
  803b1d:	48 89 c6             	mov    %rax,%rsi
  803b20:	bf 00 00 00 00       	mov    $0x0,%edi
  803b25:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
}
  803b31:	c9                   	leaveq 
  803b32:	c3                   	retq   
	...

0000000000803b34 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803b34:	55                   	push   %rbp
  803b35:	48 89 e5             	mov    %rsp,%rbp
  803b38:	48 83 ec 20          	sub    $0x20,%rsp
  803b3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803b3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b43:	75 35                	jne    803b7a <wait+0x46>
  803b45:	48 b9 a3 48 80 00 00 	movabs $0x8048a3,%rcx
  803b4c:	00 00 00 
  803b4f:	48 ba ae 48 80 00 00 	movabs $0x8048ae,%rdx
  803b56:	00 00 00 
  803b59:	be 09 00 00 00       	mov    $0x9,%esi
  803b5e:	48 bf c3 48 80 00 00 	movabs $0x8048c3,%rdi
  803b65:	00 00 00 
  803b68:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6d:	49 b8 a4 06 80 00 00 	movabs $0x8006a4,%r8
  803b74:	00 00 00 
  803b77:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803b7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7d:	48 98                	cltq   
  803b7f:	48 89 c2             	mov    %rax,%rdx
  803b82:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803b88:	48 89 d0             	mov    %rdx,%rax
  803b8b:	48 c1 e0 02          	shl    $0x2,%rax
  803b8f:	48 01 d0             	add    %rdx,%rax
  803b92:	48 01 c0             	add    %rax,%rax
  803b95:	48 01 d0             	add    %rdx,%rax
  803b98:	48 c1 e0 05          	shl    $0x5,%rax
  803b9c:	48 89 c2             	mov    %rax,%rdx
  803b9f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ba6:	00 00 00 
  803ba9:	48 01 d0             	add    %rdx,%rax
  803bac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803bb0:	eb 0c                	jmp    803bbe <wait+0x8a>
		sys_yield();
  803bb2:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803bbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bc8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bcb:	75 0e                	jne    803bdb <wait+0xa7>
  803bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803bd7:	85 c0                	test   %eax,%eax
  803bd9:	75 d7                	jne    803bb2 <wait+0x7e>
		sys_yield();
}
  803bdb:	c9                   	leaveq 
  803bdc:	c3                   	retq   
  803bdd:	00 00                	add    %al,(%rax)
	...

0000000000803be0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803be0:	55                   	push   %rbp
  803be1:	48 89 e5             	mov    %rsp,%rbp
  803be4:	48 83 ec 20          	sub    $0x20,%rsp
  803be8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803beb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bee:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bf1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bf5:	be 01 00 00 00       	mov    $0x1,%esi
  803bfa:	48 89 c7             	mov    %rax,%rdi
  803bfd:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803c04:	00 00 00 
  803c07:	ff d0                	callq  *%rax
}
  803c09:	c9                   	leaveq 
  803c0a:	c3                   	retq   

0000000000803c0b <getchar>:

int
getchar(void)
{
  803c0b:	55                   	push   %rbp
  803c0c:	48 89 e5             	mov    %rsp,%rbp
  803c0f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c13:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c17:	ba 01 00 00 00       	mov    $0x1,%edx
  803c1c:	48 89 c6             	mov    %rax,%rsi
  803c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c24:	48 b8 50 26 80 00 00 	movabs $0x802650,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
  803c30:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c37:	79 05                	jns    803c3e <getchar+0x33>
		return r;
  803c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3c:	eb 14                	jmp    803c52 <getchar+0x47>
	if (r < 1)
  803c3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c42:	7f 07                	jg     803c4b <getchar+0x40>
		return -E_EOF;
  803c44:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c49:	eb 07                	jmp    803c52 <getchar+0x47>
	return c;
  803c4b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c4f:	0f b6 c0             	movzbl %al,%eax
}
  803c52:	c9                   	leaveq 
  803c53:	c3                   	retq   

0000000000803c54 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c54:	55                   	push   %rbp
  803c55:	48 89 e5             	mov    %rsp,%rbp
  803c58:	48 83 ec 20          	sub    $0x20,%rsp
  803c5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c5f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c66:	48 89 d6             	mov    %rdx,%rsi
  803c69:	89 c7                	mov    %eax,%edi
  803c6b:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7e:	79 05                	jns    803c85 <iscons+0x31>
		return r;
  803c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c83:	eb 1a                	jmp    803c9f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c89:	8b 10                	mov    (%rax),%edx
  803c8b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c92:	00 00 00 
  803c95:	8b 00                	mov    (%rax),%eax
  803c97:	39 c2                	cmp    %eax,%edx
  803c99:	0f 94 c0             	sete   %al
  803c9c:	0f b6 c0             	movzbl %al,%eax
}
  803c9f:	c9                   	leaveq 
  803ca0:	c3                   	retq   

0000000000803ca1 <opencons>:

int
opencons(void)
{
  803ca1:	55                   	push   %rbp
  803ca2:	48 89 e5             	mov    %rsp,%rbp
  803ca5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ca9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cad:	48 89 c7             	mov    %rax,%rdi
  803cb0:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  803cb7:	00 00 00 
  803cba:	ff d0                	callq  *%rax
  803cbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc3:	79 05                	jns    803cca <opencons+0x29>
		return r;
  803cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc8:	eb 5b                	jmp    803d25 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cce:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd3:	48 89 c6             	mov    %rax,%rsi
  803cd6:	bf 00 00 00 00       	mov    $0x0,%edi
  803cdb:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
  803ce7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cee:	79 05                	jns    803cf5 <opencons+0x54>
		return r;
  803cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf3:	eb 30                	jmp    803d25 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d00:	00 00 00 
  803d03:	8b 12                	mov    (%rdx),%edx
  803d05:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
}
  803d25:	c9                   	leaveq 
  803d26:	c3                   	retq   

0000000000803d27 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d27:	55                   	push   %rbp
  803d28:	48 89 e5             	mov    %rsp,%rbp
  803d2b:	48 83 ec 30          	sub    $0x30,%rsp
  803d2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d37:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d3b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d40:	75 13                	jne    803d55 <devcons_read+0x2e>
		return 0;
  803d42:	b8 00 00 00 00       	mov    $0x0,%eax
  803d47:	eb 49                	jmp    803d92 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803d49:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803d50:	00 00 00 
  803d53:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d55:	48 b8 ea 1c 80 00 00 	movabs $0x801cea,%rax
  803d5c:	00 00 00 
  803d5f:	ff d0                	callq  *%rax
  803d61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d68:	74 df                	je     803d49 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6e:	79 05                	jns    803d75 <devcons_read+0x4e>
		return c;
  803d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d73:	eb 1d                	jmp    803d92 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803d75:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d79:	75 07                	jne    803d82 <devcons_read+0x5b>
		return 0;
  803d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d80:	eb 10                	jmp    803d92 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d85:	89 c2                	mov    %eax,%edx
  803d87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d8b:	88 10                	mov    %dl,(%rax)
	return 1;
  803d8d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d92:	c9                   	leaveq 
  803d93:	c3                   	retq   

0000000000803d94 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d94:	55                   	push   %rbp
  803d95:	48 89 e5             	mov    %rsp,%rbp
  803d98:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d9f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803da6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803dad:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803db4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dbb:	eb 77                	jmp    803e34 <devcons_write+0xa0>
		m = n - tot;
  803dbd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dc4:	89 c2                	mov    %eax,%edx
  803dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc9:	89 d1                	mov    %edx,%ecx
  803dcb:	29 c1                	sub    %eax,%ecx
  803dcd:	89 c8                	mov    %ecx,%eax
  803dcf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd5:	83 f8 7f             	cmp    $0x7f,%eax
  803dd8:	76 07                	jbe    803de1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803dda:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de4:	48 63 d0             	movslq %eax,%rdx
  803de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dea:	48 98                	cltq   
  803dec:	48 89 c1             	mov    %rax,%rcx
  803def:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803df6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dfd:	48 89 ce             	mov    %rcx,%rsi
  803e00:	48 89 c7             	mov    %rax,%rdi
  803e03:	48 b8 d2 17 80 00 00 	movabs $0x8017d2,%rax
  803e0a:	00 00 00 
  803e0d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e12:	48 63 d0             	movslq %eax,%rdx
  803e15:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e1c:	48 89 d6             	mov    %rdx,%rsi
  803e1f:	48 89 c7             	mov    %rax,%rdi
  803e22:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e31:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e37:	48 98                	cltq   
  803e39:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e40:	0f 82 77 ff ff ff    	jb     803dbd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e49:	c9                   	leaveq 
  803e4a:	c3                   	retq   

0000000000803e4b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e4b:	55                   	push   %rbp
  803e4c:	48 89 e5             	mov    %rsp,%rbp
  803e4f:	48 83 ec 08          	sub    $0x8,%rsp
  803e53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e5c:	c9                   	leaveq 
  803e5d:	c3                   	retq   

0000000000803e5e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e5e:	55                   	push   %rbp
  803e5f:	48 89 e5             	mov    %rsp,%rbp
  803e62:	48 83 ec 10          	sub    $0x10,%rsp
  803e66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e72:	48 be d3 48 80 00 00 	movabs $0x8048d3,%rsi
  803e79:	00 00 00 
  803e7c:	48 89 c7             	mov    %rax,%rdi
  803e7f:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
	return 0;
  803e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e90:	c9                   	leaveq 
  803e91:	c3                   	retq   
	...

0000000000803e94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 30          	sub    $0x30,%rsp
  803e9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803eaf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eb4:	74 18                	je     803ece <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803eb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eba:	48 89 c7             	mov    %rax,%rdi
  803ebd:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
  803ec9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ecc:	eb 19                	jmp    803ee7 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803ece:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803ed5:	00 00 00 
  803ed8:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  803edf:	00 00 00 
  803ee2:	ff d0                	callq  *%rax
  803ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803ee7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eeb:	79 39                	jns    803f26 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803eed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ef2:	75 08                	jne    803efc <ipc_recv+0x68>
  803ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef8:	8b 00                	mov    (%rax),%eax
  803efa:	eb 05                	jmp    803f01 <ipc_recv+0x6d>
  803efc:	b8 00 00 00 00       	mov    $0x0,%eax
  803f01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f05:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803f07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f0c:	75 08                	jne    803f16 <ipc_recv+0x82>
  803f0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f12:	8b 00                	mov    (%rax),%eax
  803f14:	eb 05                	jmp    803f1b <ipc_recv+0x87>
  803f16:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f1f:	89 02                	mov    %eax,(%rdx)
		return r;
  803f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f24:	eb 53                	jmp    803f79 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803f26:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f2b:	74 19                	je     803f46 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803f2d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f34:	00 00 00 
  803f37:	48 8b 00             	mov    (%rax),%rax
  803f3a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f44:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803f46:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f4b:	74 19                	je     803f66 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803f4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f54:	00 00 00 
  803f57:	48 8b 00             	mov    (%rax),%rax
  803f5a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f64:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803f66:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f6d:	00 00 00 
  803f70:	48 8b 00             	mov    (%rax),%rax
  803f73:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803f79:	c9                   	leaveq 
  803f7a:	c3                   	retq   

0000000000803f7b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f7b:	55                   	push   %rbp
  803f7c:	48 89 e5             	mov    %rsp,%rbp
  803f7f:	48 83 ec 30          	sub    $0x30,%rsp
  803f83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f86:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f89:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f8d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803f90:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803f97:	eb 59                	jmp    803ff2 <ipc_send+0x77>
		if(pg) {
  803f99:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f9e:	74 20                	je     803fc0 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803fa0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fa3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fa6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803faa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fad:	89 c7                	mov    %eax,%edi
  803faf:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  803fb6:	00 00 00 
  803fb9:	ff d0                	callq  *%rax
  803fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbe:	eb 26                	jmp    803fe6 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803fc0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fc3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803fc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc9:	89 d1                	mov    %edx,%ecx
  803fcb:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803fd2:	00 00 00 
  803fd5:	89 c7                	mov    %eax,%edi
  803fd7:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803fe6:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803fed:	00 00 00 
  803ff0:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803ff2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ff6:	74 a1                	je     803f99 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ffc:	74 2a                	je     804028 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803ffe:	48 ba e0 48 80 00 00 	movabs $0x8048e0,%rdx
  804005:	00 00 00 
  804008:	be 49 00 00 00       	mov    $0x49,%esi
  80400d:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  804014:	00 00 00 
  804017:	b8 00 00 00 00       	mov    $0x0,%eax
  80401c:	48 b9 a4 06 80 00 00 	movabs $0x8006a4,%rcx
  804023:	00 00 00 
  804026:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804028:	c9                   	leaveq 
  804029:	c3                   	retq   

000000000080402a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80402a:	55                   	push   %rbp
  80402b:	48 89 e5             	mov    %rsp,%rbp
  80402e:	48 83 ec 18          	sub    $0x18,%rsp
  804032:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804035:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80403c:	eb 6a                	jmp    8040a8 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  80403e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804045:	00 00 00 
  804048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404b:	48 63 d0             	movslq %eax,%rdx
  80404e:	48 89 d0             	mov    %rdx,%rax
  804051:	48 c1 e0 02          	shl    $0x2,%rax
  804055:	48 01 d0             	add    %rdx,%rax
  804058:	48 01 c0             	add    %rax,%rax
  80405b:	48 01 d0             	add    %rdx,%rax
  80405e:	48 c1 e0 05          	shl    $0x5,%rax
  804062:	48 01 c8             	add    %rcx,%rax
  804065:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80406b:	8b 00                	mov    (%rax),%eax
  80406d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804070:	75 32                	jne    8040a4 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804072:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804079:	00 00 00 
  80407c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407f:	48 63 d0             	movslq %eax,%rdx
  804082:	48 89 d0             	mov    %rdx,%rax
  804085:	48 c1 e0 02          	shl    $0x2,%rax
  804089:	48 01 d0             	add    %rdx,%rax
  80408c:	48 01 c0             	add    %rax,%rax
  80408f:	48 01 d0             	add    %rdx,%rax
  804092:	48 c1 e0 05          	shl    $0x5,%rax
  804096:	48 01 c8             	add    %rcx,%rax
  804099:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80409f:	8b 40 08             	mov    0x8(%rax),%eax
  8040a2:	eb 12                	jmp    8040b6 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040a8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040af:	7e 8d                	jle    80403e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040b6:	c9                   	leaveq 
  8040b7:	c3                   	retq   

00000000008040b8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040b8:	55                   	push   %rbp
  8040b9:	48 89 e5             	mov    %rsp,%rbp
  8040bc:	48 83 ec 18          	sub    $0x18,%rsp
  8040c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c8:	48 89 c2             	mov    %rax,%rdx
  8040cb:	48 c1 ea 15          	shr    $0x15,%rdx
  8040cf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040d6:	01 00 00 
  8040d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040dd:	83 e0 01             	and    $0x1,%eax
  8040e0:	48 85 c0             	test   %rax,%rax
  8040e3:	75 07                	jne    8040ec <pageref+0x34>
		return 0;
  8040e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ea:	eb 53                	jmp    80413f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f0:	48 89 c2             	mov    %rax,%rdx
  8040f3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8040f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040fe:	01 00 00 
  804101:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804105:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410d:	83 e0 01             	and    $0x1,%eax
  804110:	48 85 c0             	test   %rax,%rax
  804113:	75 07                	jne    80411c <pageref+0x64>
		return 0;
  804115:	b8 00 00 00 00       	mov    $0x0,%eax
  80411a:	eb 23                	jmp    80413f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80411c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804120:	48 89 c2             	mov    %rax,%rdx
  804123:	48 c1 ea 0c          	shr    $0xc,%rdx
  804127:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80412e:	00 00 00 
  804131:	48 c1 e2 04          	shl    $0x4,%rdx
  804135:	48 01 d0             	add    %rdx,%rax
  804138:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80413c:	0f b7 c0             	movzwl %ax,%eax
}
  80413f:	c9                   	leaveq 
  804140:	c3                   	retq   
